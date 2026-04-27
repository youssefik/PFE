package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.ActionAmelioration;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ImprovementRepository extends JpaRepository<ActionAmelioration, UUID> {
}
