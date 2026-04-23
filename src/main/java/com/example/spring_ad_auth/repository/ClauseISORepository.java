package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.ClauseISO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ClauseISORepository extends JpaRepository<ClauseISO, UUID> {
    ClauseISO findByCode(String code);

    ClauseISO findByTitre(String colA);


    // Vérifiez que vos listes retournent bien des List
    List<ClauseISO> findAllByParentIsNull();
    List<ClauseISO> findAllByParentIsNotNull();
}