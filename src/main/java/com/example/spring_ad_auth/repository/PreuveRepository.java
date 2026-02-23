package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.ElementSoA;
import com.example.spring_ad_auth.model.Preuve;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface PreuveRepository extends JpaRepository<Preuve, UUID> {
    public List<Preuve> findByElementSoA(ElementSoA elementSoA);
}

