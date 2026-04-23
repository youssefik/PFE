package com.example.spring_ad_auth.config;

import com.example.spring_ad_auth.service.UserService;
import jakarta.servlet.DispatcherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.ldap.authentication.ad.ActiveDirectoryLdapAuthenticationProvider;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.util.HashSet;
import java.util.Set;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Value("${ad.domain}") private String adDomain;
    @Value("${ad.url}") private String adUrl;
    @Value("${ad.rootDn}") private String adRootDn;

    @Autowired @Lazy
    private AdUserDetailsContextMapper adContextMapper;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                        .requestMatchers("/login", "/public/**", "/h2-console/**").permitAll()
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/admin/users/**").hasRole("ADMIN")
                        .requestMatchers("/rssi/**").hasAnyRole("RSSI", "ADMIN")
                        .requestMatchers("/planification/**").hasAnyRole("RSSI", "ADMIN", "PILOTE")
                        .requestMatchers("/rssi/risk-editor/**").hasAnyRole("RSSI", "ADMIN")
                        .requestMatchers("/compliance/editor/**").hasAnyRole("ADMIN", "RSSI")
                        .requestMatchers("/compliance/sync/**").hasAnyRole("ADMIN", "RSSI")
                        .requestMatchers("/excel/**").hasAnyRole("ADMIN", "RSSI")
                        .requestMatchers("/audit/**").hasAnyRole("AUDITEUR", "ADMIN")
                        .requestMatchers("/reporting/**").hasAnyRole("ADMIN", "RSSI", "DIRECTION")
                        .requestMatchers("/api/ai/**").hasAnyRole("RSSI", "ADMIN")
                        .anyRequest().authenticated()
                )
                .headers(h -> h.frameOptions(f -> f.disable()))
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/dashboard", true)
                        .failureUrl("/login?error")
                        .permitAll()
                )
                .logout(logout -> logout.logoutSuccessUrl("/login?logout").permitAll());

        return http.build();
    }

    @Bean
    public AuthenticationProvider activeDirectoryLdapAuthenticationProvider() {
        // Utilisation du constructeur COMPLET qui marchait avant
        ActiveDirectoryLdapAuthenticationProvider provider =
                new ActiveDirectoryLdapAuthenticationProvider(adDomain, adUrl, adRootDn);

        provider.setConvertSubErrorCodesToExceptions(true);

        // --- CRUCIAL : On remet VOTRE filtre qui fonctionnait ---
        provider.setSearchFilter("(&(objectClass=user)(|(sAMAccountName={1})(userPrincipalName={0})))");

        // --- ON FAIT LE LIEN AVEC LE MAPPER ---
        provider.setUserDetailsContextMapper(adContextMapper);

        return provider;
    }
}


/*
import com.example.spring_ad_auth.model.Utilisateur;
import com.example.spring_ad_auth.repository.UtilisateurRepository;
import jakarta.servlet.DispatcherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.ldap.authentication.ad.ActiveDirectoryLdapAuthenticationProvider;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

@Configuration
public class SecurityConfig {
    @Autowired
    UtilisateurRepository utilisateurRepository;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Toujours désactivé pour le dev/H2
                .authorizeHttpRequests(authz -> authz
                        // IMPORTANT : Autoriser les forwards internes vers les JSP
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()

                        // Pages publiques
                        .requestMatchers("/login", "/public/**", "/css/**", "/js/**").permitAll()

                        // Accès H2 Console (si utilisé)
                        .requestMatchers("/h2-console/**").permitAll()

                        // Accès basé sur les rôles SMSI (Sprint 1)
                        .requestMatchers("/admin/**").hasAnyRole("ADMIN", "RSSI")

                        .anyRequest().authenticated()
                )
                // Nécessaire pour afficher la console H2 ou des iframes JSP
                .headers(headers -> headers.frameOptions(frame -> frame.disable()))

                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .defaultSuccessUrl("/dashboard", true)
                        .failureHandler((request, response, exception) -> {
                            System.out.println("ERREUR LOGIN : " + exception.getMessage());
                            exception.printStackTrace(); // Ceci affichera TOUTE la trace LDAP
                            response.sendRedirect("/login?error");
                        })
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout")
                        .permitAll()
                )
                .authenticationProvider(activeDirectoryLdapAuthenticationProvider());

        return http.build();
    }

    @Bean
    public ActiveDirectoryLdapAuthenticationProvider activeDirectoryLdapAuthenticationProvider() {
        String domain = "test.local";
        String url = "ldap://192.168.56.100:389";
        String rootDn = "DC=test,DC=local";

        ActiveDirectoryLdapAuthenticationProvider provider =
                new ActiveDirectoryLdapAuthenticationProvider(domain, url, rootDn);

        provider.setConvertSubErrorCodesToExceptions(true);
        provider.setSearchFilter("(&(objectClass=user)(|(sAMAccountName={1})(userPrincipalName={0})))");

        // --- DÉBUT DE LA PARTIE COMPLÈTE ---
        provider.setAuthoritiesMapper((authorities) -> {
            Set<GrantedAuthority> mapped = new HashSet<>();

            // 1. Logique de mapping des rôles AD -> Spring Security
            System.out.println("DEBUG AD - Groupes bruts reçus : " + authorities);

            for (GrantedAuthority authority : authorities) {
                String group = authority.getAuthority().toUpperCase();

                if (group.contains("SMSI_ADMINS")) {
                    mapped.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
                } else if (group.contains("SMSI_RSSI")) {
                    mapped.add(new SimpleGrantedAuthority("ROLE_RSSI"));
                } else if (group.contains("SMSI_AUDITORS")) {
                    mapped.add(new SimpleGrantedAuthority("ROLE_AUDITEUR"));
                } else if (group.contains("SMSI_PILOTES")) {
                    mapped.add(new SimpleGrantedAuthority("ROLE_PILOTE"));
                } else if (group.contains("SMSI_DIRECTION")) {
                    mapped.add(new SimpleGrantedAuthority("ROLE_DIRECTION"));
                }
            }

            // Toujours ajouter ROLE_USER par défaut
            mapped.add(new SimpleGrantedAuthority("ROLE_USER"));

            // 2. Synchronisation avec la base de données locale
            // On récupère le nom de l'utilisateur qui est en train de se connecter
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null) {
                String username = auth.getName();

                // On cherche si l'utilisateur existe déjà
                Utilisateur user = utilisateurRepository.findByUsername(username)
                        .orElse(new Utilisateur());

                if (user.getId() == null) {
                    user.setUsername(username);
                    user.setNom(username); // On peut enrichir via LDAP plus tard
                    System.out.println("LOG - Création de l'utilisateur en BD : " + username);
                }

                user.setDerniereConnexion(LocalDateTime.now());
                utilisateurRepository.save(user);
            }

            System.out.println("DEBUG AD - Rôles finaux mappés : " + mapped);
            return mapped;
        });
        // --- FIN DE LA PARTIE COMPLÈTE ---

        return provider;
    }
}
*/
