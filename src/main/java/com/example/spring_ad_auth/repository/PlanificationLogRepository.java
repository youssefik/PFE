package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.PlanificationLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PlanificationLogRepository extends JpaRepository<PlanificationLog, UUID> {
    // Récupérer les logs du plus récent au plus ancien
    List<PlanificationLog> findAllByOrderByDateExecutionDesc();

}
