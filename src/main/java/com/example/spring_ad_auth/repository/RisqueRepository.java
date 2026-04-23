package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.RegistreRisque;
import com.example.spring_ad_auth.model.Risque;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface RisqueRepository extends JpaRepository<RegistreRisque, UUID> {
    Optional<Risque> findByRef(String ref);
}