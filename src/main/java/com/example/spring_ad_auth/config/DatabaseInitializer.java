package com.example.spring_ad_auth.config;

import com.example.spring_ad_auth.repository.RegistreRisqueRepository;
import com.example.spring_ad_auth.service.RiskTableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class DatabaseInitializer {

    @Autowired
    private RiskTableService riskTableService;

    @Autowired
    private RegistreRisqueRepository riskRepo;

    // Cette méthode s'exécute automatiquement quand l'application est prête

    @EventListener(ApplicationReadyEvent.class)
    public void initializeDatabase() {
        try {
            if (riskRepo.count() == 0) {
                System.out.println("📥 Initialisation initiale depuis le fichier Excel...");
                // APPEL DIRECT DE LA MÉTHODE DE SYNCHRONISATION
                riskTableService.importRisksFromExcel();
            } else {
                System.out.println("ℹ️ Données présentes. L'initialiseur est en sommeil.");
            }
        } catch (Exception e) {
            System.err.println("❌ Échec de l'initialisation : " + e.getMessage());
        }
    }
}
