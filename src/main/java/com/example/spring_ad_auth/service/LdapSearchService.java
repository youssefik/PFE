package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.Utilisateur;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ldap.core.AttributesMapper;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.ldap.query.LdapQueryBuilder;
import org.springframework.stereotype.Service;

import javax.naming.directory.Attributes;
import javax.naming.NamingException;
import java.util.List;

@Service
public class LdapSearchService {

    @Autowired
    private LdapTemplate ldapTemplate;

    public List<Utilisateur> searchUsersInAD(String queryText) {

        // Utilisation de LdapQueryBuilder pour éviter les injections LDAP
        // (Sécurité cruciale pour un CRM professionnel)
        var query = LdapQueryBuilder.query()
                .where("objectClass").is("user")
                .and(LdapQueryBuilder.query()
                        .where("sAMAccountName").like("*" + queryText + "*")
                        .or("displayName").like("*" + queryText + "*"));

        // Utilisation explicite de AttributesMapper pour aider le compilateur
        return ldapTemplate.search(query, new AttributesMapper<Utilisateur>() {
            @Override
            public Utilisateur mapFromAttributes(Attributes attrs) throws NamingException {
                Utilisateur user = new Utilisateur();

                // sAMAccountName (Login)
                if (attrs.get("sAMAccountName") != null) {
                    user.setUsername(attrs.get("sAMAccountName").get().toString());
                }

                // displayName (Nom complet)
                if (attrs.get("displayName") != null) {
                    user.setNomComplet(attrs.get("displayName").get().toString());
                }

                // mail (Email)
                if (attrs.get("mail") != null) {
                    user.setEmail(attrs.get("mail").get().toString());
                }

                // facultatif : récupérer la fonction (Title dans l'AD)
                if (attrs.get("title") != null) {
                    user.setFonction(attrs.get("title").get().toString());
                }

                return user;
            }
        });
    }
}