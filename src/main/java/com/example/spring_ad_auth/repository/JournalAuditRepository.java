package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.JournalAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.UUID;
import java.util.List;

@Repository
public interface JournalAuditRepository extends JpaRepository<JournalAudit, UUID> {
    // Permet de voir l'historique d'un objet précis
    List<JournalAudit> findByIdEntiteOrderByDateCreationDesc(UUID idEntite);

    // Permet de voir les actions d'un utilisateur précis
    List<JournalAudit> findByUtilisateurOrderByDateCreationDesc(String utilisateur);
}