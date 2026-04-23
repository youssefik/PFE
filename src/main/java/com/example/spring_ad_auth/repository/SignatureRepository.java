package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.Signature;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface SignatureRepository extends JpaRepository<Signature, UUID> {
    // Retrouver toutes les signatures pour un document précis
    List<Signature> findByEntityTypeAndEntityIdOrderByDateSignatureDesc(String type, UUID id);
}
