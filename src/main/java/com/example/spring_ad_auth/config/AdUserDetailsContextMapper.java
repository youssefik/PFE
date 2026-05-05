package com.example.spring_ad_auth.config;

import com.example.spring_ad_auth.model.Utilisateur;
import com.example.spring_ad_auth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ldap.core.DirContextAdapter;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.ldap.userdetails.UserDetailsContextMapper;
import org.springframework.stereotype.Component;

import java.util.Collection;

@Component
public class AdUserDetailsContextMapper implements UserDetailsContextMapper {

    @Autowired
    private UserService userService; // ON UTILISE LE SERVICE !

    @Override
    public UserDetails mapUserFromContext(DirContextOperations ctx, String username,
                                          Collection<? extends GrantedAuthority> authorities) {

        System.out.println(">>> AD AUTH SUCCESS pour : " + username);

        // 1. Extraction des infos AD
        String email = ctx.getStringAttribute("mail");
        String displayName = ctx.getStringAttribute("displayName");

        // 2. APPEL DU SERVICE (C'est lui qui contient la logique initial-admin)
        Utilisateur user = userService.syncUserFromAD(username, email, displayName);

        System.out.println(">>> RÔLE ATTRIBUÉ DANS LA SESSION : " + user.getRole().name());

        // 3. Renvoi des autorités basées sur l'utilisateur retourné par le service
        return new org.springframework.security.core.userdetails.User(
                username,
                "",
                AuthorityUtils.createAuthorityList(user.getRole().name())
        );
    }

    @Override
    public void mapUserToContext(UserDetails user, DirContextAdapter ctx) {}
}