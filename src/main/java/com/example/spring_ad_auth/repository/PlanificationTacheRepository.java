package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.PlanificationTache;
import com.example.spring_ad_auth.model.StatutTache;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface PlanificationTacheRepository extends JpaRepository<PlanificationTache, UUID> {

    // Cette méthode permet de trouver les tâches dont l'heure d'exécution est dépassée
    List<PlanificationTache> findByProchaineExecutionBeforeAndStatut(LocalDateTime now, StatutTache statut);

}
