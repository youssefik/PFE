package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.PlanificationTache;
import com.example.spring_ad_auth.model.StatutTache;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaskRepository extends JpaRepository<PlanificationTache, Long> {
    PlanificationTache findTopByStatutOrderByProchaineExecutionAsc(StatutTache statutTache);
}
