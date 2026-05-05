package com.example.spring_ad_auth.config;

import com.example.spring_ad_auth.repository.*;
import com.example.spring_ad_auth.service.AssetIntegrationService;
import com.example.spring_ad_auth.service.ImprovementService;
import com.example.spring_ad_auth.service.RiskTableService;
import com.example.spring_ad_auth.service.SoAIntegrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired private SoAIntegrationService syncService;
    @Autowired private ControleRepository controleRepo;
    @Autowired private RisqueRepository risqueRepo;
    @Autowired private RiskTableService riskTableService;
    @Autowired private ImprovementRepository improvementRepo;
    @Autowired private ImprovementService improvementService; // Injecter le service

    @Autowired private AssetIntegrationService assetService;
    @Autowired private ActifRepository actifRepo;
    @Override
    public void run(String... args) throws Exception {
        // Toujours lancer l'init des clauses 4-10
        syncService.initManagementSystemClauses();



        // Importer l'Annexe A si vide
/*        if (syncService.isReferentielEmpty()) {
            syncService.importReferentielFromExcel();
        }*/

        if (improvementRepo.count() == 0) {
            try {
                improvementService.initJournalFromExcel();
            } catch (Exception e) {
                System.err.println("❌ Erreur init Journal d'amélioration : " + e.getMessage());
            }
        }

        if (actifRepo.count() == 0) {
            assetService.importAssetsFromExcel();
        }

    }

}
/*
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private ClauseISORepository clauseRepo;
    @Autowired
    private PerimetreRepository perimetreRepo; // Ajoutez ceci


    @Override
    public void run(String... args) throws Exception {
        if (clauseRepo.count() == 0) {
            ClauseISO c5 = new ClauseISO();
            c5.setCode("5");
            c5.setTitre("Leadership");
            c5.setDescription("Responsabilités de la direction.");
            clauseRepo.save(c5);

            ClauseISO c6 = new ClauseISO();
            c6.setCode("6");
            c6.setTitre("Planification");
            c6.setDescription("Gestion des risques et opportunités.");
            clauseRepo.save(c6);

            System.out.println(">> Référentiel ISO initialisé avec succès.");
        }

        // INITIALISATION DU PÉRIMÈTRE (Sprint 2)
        if (perimetreRepo.count() == 0) {
            Perimetre p1 = new Perimetre();
            p1.setNom("Direction des Systèmes d'Information (DSI)");
            p1.setDescription("Tout le périmètre technique incluant serveurs et réseaux.");
            perimetreRepo.save(p1);

            Perimetre p2 = new Perimetre();
            p2.setNom("Ressources Humaines");
            p2.setDescription("Gestion des données personnelles des employés.");
            perimetreRepo.save(p2);

            System.out.println(">> Périmètres initialisés.");
        }
    }
}*/
