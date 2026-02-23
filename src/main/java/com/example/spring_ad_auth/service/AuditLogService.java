package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.JournalAudit;
import com.example.spring_ad_auth.repository.JournalAuditRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class AuditLogService {

    @Autowired
    private JournalAuditRepository auditRepo;

    /**
     * Enregistre une action dans le journal d'audit
     * @param entityType Le nom de la classe impactée (ex: "Controle")
     * @param entityId L'ID de l'objet créé/modifié
     * @param action Le type d'action (ex: "CREATION", "MODIFICATION")
     */
    public void log(String entityType, UUID entityId, String action) {
        // 1. Récupérer l'utilisateur actuellement connecté via Spring Security
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String currentUserName = (auth != null) ? auth.getName() : "SYSTEM";

        // 2. Créer l'entrée du journal
        JournalAudit entry = new JournalAudit();
        entry.setTypeEntite(entityType);
        entry.setIdEntite(entityId);
        entry.setAction(action);
        entry.setUtilisateur(currentUserName);

        // 3. Sauvegarder en base de données
        auditRepo.save(entry);
    }
}