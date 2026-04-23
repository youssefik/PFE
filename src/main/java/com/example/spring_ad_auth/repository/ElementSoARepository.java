package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.ElementSoA;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface ElementSoARepository extends JpaRepository<ElementSoA, UUID> {

    // Utilisation d'une jointure pour être sûr de trouver par le code du contrôle
    @Query("SELECT e FROM ElementSoA e WHERE e.controle.code = :code")
    Optional<ElementSoA> findByControleCode(@Param("code") String code);

    @Query("SELECT e FROM ElementSoA e WHERE e.controle.id = :id")
    Optional<ElementSoA> findByControleId(@Param("id") UUID id);
}
