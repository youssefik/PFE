package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.Constat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ConstatRepository extends JpaRepository<Constat,Long> {
    Optional<Constat> findById(UUID constatId);

    List<Constat> findByAuditId(UUID id);

    // Pour retrouver le constat lié à une clause 4-10
    Optional<Constat> findByAuditIdAndClauseIsoId(UUID auditId, UUID clauseId);

    // Pour retrouver le constat lié à un contrôle de l'Annexe A
    Optional<Constat> findByAuditIdAndControleId(UUID auditId, UUID controleId);

}
