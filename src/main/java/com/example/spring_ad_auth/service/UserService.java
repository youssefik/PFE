package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.AppRole;
import com.example.spring_ad_auth.model.Utilisateur;
import com.example.spring_ad_auth.repository.UtilisateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;



@Service
public class UserService {

    @Autowired private UtilisateurRepository userRepository;

    @Value("${app.security.initial-admin}")
    private String initialAdmin;

    @Transactional
    public Utilisateur syncUserFromAD(String username, String email, String displayName) {
        // 1. Nettoyage du nom (TRÈS IMPORTANT)
        String cleanUsername = username.toLowerCase().trim();
        if (cleanUsername.contains("@")) cleanUsername = cleanUsername.split("@")[0];
        if (cleanUsername.contains("\\")) cleanUsername = cleanUsername.split("\\\\")[1];
        cleanUsername = cleanUsername.trim();

        final String finalUsername = cleanUsername;
        // On nettoie aussi la variable venant du properties au cas où il y ait un espace
        final String adminConfigured = initialAdmin.toLowerCase().trim();

        System.out.println("DEBUG ROLE - Tentative login : [" + finalUsername + "]");
        System.out.println("DEBUG ROLE - Admin autorisé : [" + adminConfigured + "]");

        return userRepository.findByUsername(finalUsername)
                .map(user -> {
                    // Si l'utilisateur existe déjà, on met juste à jour la date et les infos
                    user.setDerniereConnexion(LocalDateTime.now());
                    user.setNomComplet(displayName);
                    user.setEmail(email);
                    return userRepository.save(user);
                })
                .orElseGet(() -> {
                    // CRÉATION de l'utilisateur
                    Utilisateur newUser = new Utilisateur();
                    newUser.setUsername(finalUsername);
                    newUser.setNomComplet(displayName);
                    newUser.setEmail(email);
                    newUser.setDerniereConnexion(LocalDateTime.now());

                    // LOGIQUE STRICTE : Uniquement si le nom match EXACTEMENT
                    if (finalUsername.equals(adminConfigured)) {
                        newUser.setRole(AppRole.ROLE_ADMIN);
                        System.out.println(">>> ACCÈS : ROLE_ADMIN accordé à l'administrateur système.");
                    } else {
                        newUser.setRole(AppRole.ROLE_USER);
                        System.out.println(">>> ACCÈS : ROLE_USER accordé par défaut.");
                    }

                    if (newUser.getStatut().equals("INVITE")) {
                        newUser.setStatut("ACTIF");
                        System.out.println(">>> L'invité " + username + " est maintenant ACTIF.");
                    }


                    return userRepository.save(newUser);
                });
    }

    // Pour la console d'administration
    public List<Utilisateur> getAllUsers() {
        return userRepository.findAll();
    }

    @Transactional
    public void updateRole(UUID userId, AppRole newRole) {
        userRepository.findById(userId).ifPresent(u -> {
            u.setRole(newRole);
            userRepository.save(u);
        });
    }

    @Transactional
    public void importUserManually(String username, String nom, String email, AppRole role) {
        // 1. Nettoyage du login
        String cleanUsername = username.toLowerCase().trim();
        if (cleanUsername.contains("@")) cleanUsername = cleanUsername.split("@")[0];

        // 2. Vérification d'unicité (pour ne pas écraser un admin existant)
        if (userRepository.findByUsername(cleanUsername).isPresent()) {
            throw new RuntimeException("L'utilisateur '" + cleanUsername + "' est déjà présent dans le système.");
        }

        // 3. Création de l'entité
        Utilisateur newUser = new Utilisateur();
        newUser.setUsername(cleanUsername);
        newUser.setNomComplet(nom);
        newUser.setEmail(email);
        newUser.setRole(role);

        // Métadonnées importantes pour la commercialisation (Audit Trail)
        newUser.setStatut("INVITE"); // L'utilisateur n'est pas encore "ACTIF" (il ne s'est pas logué)
        newUser.setSource("AD");
        newUser.setDateCreation(LocalDateTime.now());

        userRepository.save(newUser);
        System.out.println(">>> IMPORT MANUEL : Utilisateur " + cleanUsername + " importé avec le rôle " + role);
    }
}

/*
@Service
public class UserService {

    @Autowired private UtilisateurRepository userRepository;

    @Value("${app.security.initial-admin}")
    private String initialAdmin;

    @Transactional
    public Utilisateur syncUserFromAD(String username, String email, String displayName) {
        // 1. Nettoyage du nom (évite les doublons domaine\\user ou user@domaine)
        String cleanUsername = username.toLowerCase();
        if (cleanUsername.contains("@")) cleanUsername = cleanUsername.split("@")[0];
        if (cleanUsername.contains("\\")) cleanUsername = cleanUsername.split("\\\\")[1];
        cleanUsername = cleanUsername.trim();

        final String finalUsername = cleanUsername;

        return userRepository.findByUsername(finalUsername)
                .map(user -> {
                    // MISE À JOUR : On ne change pas le rôle s'il existe déjà !
                    user.setDerniereConnexion(LocalDateTime.now());
                    user.setEmail(email);
                    user.setNomComplet(displayName);
                    return userRepository.save(user);
                })
                .orElseGet(() -> {
                    // CRÉATION : Premier login
                    Utilisateur newUser = new Utilisateur();
                    newUser.setUsername(finalUsername);
                    newUser.setEmail(email);
                    newUser.setNomComplet(displayName);
                    newUser.setDerniereConnexion(LocalDateTime.now());

                    // LOGIQUE DE RÔLE INITIAL
                    // Si c'est l'admin désigné ou si c'est le TOUT PREMIER utilisateur
                    if (finalUsername.equalsIgnoreCase(initialAdmin) || userRepository.count() == 0) {
                        newUser.setRole(AppRole.ROLE_ADMIN);
                    } else {
                        newUser.setRole(AppRole.ROLE_USER); // Rôle de base (sécurisé)
                    }
                    return userRepository.save(newUser);
                });
    }

    // Pour la console d'administration
    public List<Utilisateur> getAllUsers() {
        return userRepository.findAll();
    }

    @Transactional
    public void updateRole(UUID userId, AppRole newRole) {
        userRepository.findById(userId).ifPresent(u -> {
            u.setRole(newRole);
            userRepository.save(u);
        });
    }
}*/
