package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.Controle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.UUID;
import java.util.List;

@Repository
public interface ControleRepository extends JpaRepository<Controle, UUID> {
    List<Controle> findByDomaine(String domaine);
    Controle findByCode(String code);
}