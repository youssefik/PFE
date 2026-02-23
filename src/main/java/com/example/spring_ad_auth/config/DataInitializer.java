package com.example.spring_ad_auth.config;

import com.example.spring_ad_auth.model.ClauseISO;
import com.example.spring_ad_auth.model.Perimetre;
import com.example.spring_ad_auth.repository.ClauseISORepository;
import com.example.spring_ad_auth.repository.PerimetreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

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
}