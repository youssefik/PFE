package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.Actif;
import com.example.spring_ad_auth.model.Perimetre;
import com.example.spring_ad_auth.repository.ActifRepository;
import com.example.spring_ad_auth.repository.PerimetreRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class AssetIntegrationService {

    @Autowired
    private ExcelService excelService;
    @Autowired private ActifRepository actifRepo;
    @Autowired private PerimetreRepository perimetreRepo;



    @Transactional
    public void importAssetsFromExcel() throws IOException {
        // 1. GESTION DU PÉRIMÈTRE
        Perimetre p = perimetreRepo.findByNom("Shore 1")
                .orElseGet(() -> {
                    Perimetre newP = new Perimetre();
                    newP.setNom("Shore 1");
                    newP.setDescription("Périmètre principal Shore 1");
                    return perimetreRepo.save(newP);
                });

        // 2. LECTURE (On lit 12 colonnes, Feuille 0, à partir de la ligne index 4)
        List<List<String>> rows = excelService.readAssetsExcel();

        // Variables de "mémoire" pour CHAQUE colonne susceptible d'être fusionnée
        String lastActivite = "";
        String lastProcessus = "";
        String lastPersonnel = "";
        String lastLocal = "";
        String lastReseau = "";

        List<Actif> assetsToSave = new ArrayList<>();

        for (List<String> row : rows) {
            if (row.isEmpty() || row.stream().allMatch(String::isEmpty)) continue;

            // --- GESTION DE LA MÉMOIRE (CELLULES FUSIONNÉES) ---

            // Colonne A : Activité
            String valA = getSafe(row, 0);
            if (!valA.isEmpty()) lastActivite = valA;

            // Colonne B : Processus
            String valB = getSafe(row, 1);
            if (!valB.isEmpty()) lastProcessus = valB;

            // Colonne I : Personnel Support (Index 8)
            String valI = getSafe(row, 8);
            if (!valI.isEmpty()) lastPersonnel = valI;

            // Colonne J : Local Support (Index 9)
            String valJ = getSafe(row, 9);
            if (!valJ.isEmpty()) lastLocal = valJ;

            // Colonne K : Réseau Support (Index 10)
            String valK = getSafe(row, 10);
            if (!valK.isEmpty()) lastReseau = valK;

            // --- CONDITION DE CRÉATION ---
            // On crée l'actif uniquement si le nom (Col C / Index 2) n'est pas vide
            String nomActif = getSafe(row, 2);
            if (nomActif.isEmpty() || nomActif.equalsIgnoreCase("Actif informationnel")) continue;

            Actif actif = new Actif();
            actif.setPerimetre(p);
            actif.setNom(nomActif);

            // On applique les valeurs mémorisées (qu'elles soient sur cette ligne ou héritées du haut)
            actif.setActivite(lastActivite);
            actif.setProcessus(lastProcessus);

            // Besoins DIC
            actif.setDisponibilite(parseSafeInt(getSafe(row, 3)));
            actif.setIntegrite(parseSafeInt(getSafe(row, 4)));
            actif.setConfidentialite(parseSafeInt(getSafe(row, 5)));

            // Actifs Supports (Logiciel et Matériel ne sont généralement pas fusionnés, mais à vérifier)
            actif.setLogicielSupport(getSafe(row, 6));
            actif.setMaterielSupport(getSafe(row, 7));

            // Application de la mémoire pour les supports fusionnés
            actif.setPersonnelSupport(lastPersonnel);
            actif.setLocalSupport(lastLocal);
            actif.setReseauSupport(lastReseau);

            // Impact
            actif.setEvenementRedoute(getSafe(row, 11));

            assetsToSave.add(actif);
        }

        // 3. SAUVEGARDE
        actifRepo.deleteAll(); // Nettoyage avant ré-import
        actifRepo.saveAll(assetsToSave);
        System.out.println("✅ Importation terminée : " + assetsToSave.size() + " actifs synchronisés.");
    }

/*    @Transactional
    public void importAssetsFromExcel() throws IOException {
        List<List<String>> rows = excelService.readAssetsExcel();

        // Variables de "mémoire" pour gérer les cellules fusionnées
        String lastActivite = "";
        String lastProcessus = "";

        // Récupérer un périmètre par défaut (ou à adapter selon ton flux)
        Perimetre p = perimetreRepo.findAll().stream().findFirst()
                .orElseThrow(() -> new RuntimeException("Créez d'abord un périmètre !"));

        List<Actif> assetsToSave = new ArrayList<>();

        for (List<String> row : rows) {
            // Ignorer les lignes totalement vides
            if (row.isEmpty() || row.stream().allMatch(String::isEmpty)) continue;

            // 1. Gérer la mémoire des colonnes fusionnées (Activité et Processus)
            String currentColA = getSafe(row, 0);
            String currentColB = getSafe(row, 1);

            if (!currentColA.isEmpty()) lastActivite = currentColA;
            if (!currentColB.isEmpty()) lastProcessus = currentColB;

            // 2. Création de l'entité
            Actif actif = new Actif();
            actif.setPerimetre(p);
            actif.setActivite(lastActivite);
            actif.setProcessus(lastProcessus);

            actif.setNom(getSafe(row, 2)); // Actif info

            // Besoins de sécurité (D-I-C) - colonnes D, E, F
            actif.setDisponibilite(parseSafeInt(getSafe(row, 3)));
            actif.setIntegrite(parseSafeInt(getSafe(row, 4)));
            actif.setConfidentialite(parseSafeInt(getSafe(row, 5)));

            // Actifs Supports - colonnes G, H, I, J, K
            actif.setLogicielSupport(getSafe(row, 6));
            actif.setMaterielSupport(getSafe(row, 7));
            actif.setPersonnelSupport(getSafe(row, 8));
            actif.setLocalSupport(getSafe(row, 9));
            actif.setReseauSupport(getSafe(row, 10));

            // Impact (Évènement redouté) - colonne L
            actif.setEvenementRedoute(getSafe(row, 11));

            // On n'ajoute l'actif que s'il a un nom (Colonne C non vide)
            if (!actif.getNom().isEmpty()) {
                assetsToSave.add(actif);
            }
        }

        // Nettoyer l'ancien inventaire et sauvegarder le nouveau
        actifRepo.deleteAll();
        actifRepo.saveAll(assetsToSave);
        System.out.println("🚀 Inventaire synchronisé : " + assetsToSave.size() + " actifs chargés.");
    }*/

    private String getSafe(List<String> row, int index) {
        return (index < row.size() && row.get(index) != null) ? row.get(index).trim() : "";
    }

    private int parseSafeInt(String value) {
        if (value == null || value.isEmpty()) return 1;
        try {
            return (int) Double.parseDouble(value.replaceAll("[^0-9.]", ""));
        } catch (Exception e) {
            return 1;
        }
    }
}