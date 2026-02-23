package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.Utilisateur;
import com.example.spring_ad_auth.repository.UtilisateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
public class UserService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Transactional
    public void syncUserWithDB(String username) {
        // Chercher l'utilisateur par son login AD
        Utilisateur user = utilisateurRepository.findByUsername(username)
                .orElse(new Utilisateur());

        if (user.getId() == null) {
            user.setUsername(username);
            user.setNom(username); // On utilise le login comme nom par défaut
            user.setStatut("ACTIF");
            System.out.println("NOUVEAU : Utilisateur AD " + username + " créé en base de données.");
        }

        user.setDerniereConnexion(LocalDateTime.now());
        utilisateurRepository.save(user);
    }
}
