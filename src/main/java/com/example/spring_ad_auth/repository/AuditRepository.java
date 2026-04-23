package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.Audit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface AuditRepository extends JpaRepository<Audit, Long> {
    Optional<Audit> findById(UUID auditId);
}
