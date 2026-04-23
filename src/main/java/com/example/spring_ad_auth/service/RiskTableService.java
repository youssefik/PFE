package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.RegistreRisque;
import com.example.spring_ad_auth.repository.RegistreRisqueRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class RiskTableService {

    @Autowired
    private ExcelService excelService;

    @Autowired
    private RiskMapper riskMapper;

    @Autowired
    private RegistreRisqueRepository riskRepo;

    @Autowired private AuditLogService auditLogService;

    private final String HISTORY_DIR = "D:/Downoalds/spring-ad-auth/spring-ad-auth/history/risks/";


    /**
     * Méthode orchestrale pour importer les risques depuis Excel vers la BD
     */


    @Transactional
    public void importRisksFromExcel() throws IOException {
        List<List<String>> rows = excelService.readRisks();
        System.out.println("📊 Lignes extraites d'Excel : " + rows.size());

        String currentCategory = "Non classé";
        String lastMenace = "";
        String lastOrigine = "";
        String lastProprio = "";

        List<RegistreRisque> entities = new ArrayList<>();

        for (int i = 0; i < rows.size(); i++) {
            List<String> row = rows.get(i);
            if (row == null || row.isEmpty()) continue;

            String col0 = safeGet(row, 0); // Menaces ou Titre de catégorie
            String ref = safeGet(row, 3);   // Colonne D (REF)

            // 1. DÉTECTION DE LA CATÉGORIE (Ex: 1-Sinistres...)
            // Si la colonne REF est vide et que la colonne 0 commence par un chiffre
            if (col0.matches("^\\d-.*") && ref.isEmpty()) {
                currentCategory = col0;
                System.out.println("📂 Dossier détecté : " + currentCategory);
                continue; // On passe à la ligne suivante
            }

            // 2. MÉMOIRE POUR LES CELLULES FUSIONNÉES (Propagation)
            // Dans vos images, si c'est vide, on prend la valeur du dessus
            if (!col0.isEmpty()) lastMenace = col0;
            if (!safeGet(row, 1).isEmpty()) lastOrigine = safeGet(row, 1);
            if (!safeGet(row, 4).isEmpty()) lastProprio = safeGet(row, 4);

            // 3. ENREGISTREMENT SI RÉFÉRENCE PRÉSENTE
            if (!ref.isEmpty()) {
                // Ignorer si c'est par hasard la ligne d'entête "REF"
                if (ref.equalsIgnoreCase("REF")) continue;

                try {
                    // Utilisation du Mapper SRP pour créer l'entité
                    RegistreRisque riskEntity = riskMapper.mapRowToEntity(
                            row,
                            currentCategory,
                            lastMenace,
                            lastOrigine,
                            lastProprio
                    );
                    entities.add(riskEntity);
                    System.out.println("✅ Ajout Risque : " + ref);
                } catch (Exception e) {
                    System.err.println("❌ Erreur ligne " + i + " (Ref " + ref + ") : " + e.getMessage());
                }
            }
        }

        if (!entities.isEmpty()) {
            riskRepo.deleteAll();
            riskRepo.saveAll(entities);
            System.out.println("🚀 IMPORTATION RÉUSSIE : " + entities.size() + " risques en base.");
        }
    }

    /**
     * Méthode utilitaire pour éviter les erreurs si l'Excel a des colonnes vides à la fin
     */
// Dans RiskTableService, modifiez safeGet pour être encore plus robuste :
    private String safeGet(List<String> row, int idx) {
        if (idx >= row.size() || row.get(idx) == null) return "";
        String val = row.get(idx).trim();
        // Transforme "1.0" en "1" pour les références numériques
        if (val.endsWith(".0")) {
            val = val.substring(0, val.length() - 2);
        }
        return val;
    }

    /**
     * Utilisé par ton contrôleur pour l'affichage JSON dans Handsontable
     */
    public List<RegistreRisque> getAllRisksForDisplay() {
        return riskRepo.findAll();
    }


    // Dans RiskTableService.java, ajoute cette méthode :

    public void syncDatabaseToExcel() throws IOException {
        List<Map<String, Object>> dataForExcel = getRisksFromDatabase();
        excelService.writeRisks(dataForExcel);
    }


    /**
     * Correction erreur : getRisksFromDatabase()
     */
    public List<Map<String, Object>> getRisksFromDatabase() {
        List<RegistreRisque> entities = riskRepo.findAll();

        // Log pour debug (Tu verras le compte dans ta console IDE)
        System.out.println("📊 getRisksFromDatabase : " + entities.size() + " risques récupérés.");

        // Transformation via RiskMapper (Respect de SOLID : SRP)
        return entities.stream()
                .map(riskMapper::mapEntityToMap)
                .toList();
    }

    /**
     * Correction erreur : saveAllRisks()
     */
    @Transactional
    public void saveAllRisks(List<Map<String, Object>> risksData) throws IOException {
        // 1. Récupérer l'utilisateur qui fait l'action (Sécurité AD)
        String username = SecurityContextHolder.getContext().getAuthentication().getName();

        // 2. Préparer les données pour la BD
        List<Map<String, Object>> normalized = propagateCategories(risksData);
        List<RegistreRisque> entities = normalized.stream()
                .map(riskMapper::mapMapToEntity)
                .toList();

        // 3. Sauvegarde en Base de Données (Source de vérité)
        riskRepo.deleteAll();
        riskRepo.saveAll(entities);

        // 4. Génération de la nouvelle VERSION du fichier Excel
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String filename = "risks_v_" + timestamp + ".xlsx";
        String fullPath = HISTORY_DIR + filename;

        // Créer le dossier s'il n'existe pas
        File folder = new File(HISTORY_DIR);
        if (!folder.exists()) folder.mkdirs();

        // Écriture physique du fichier
        excelService.writeRisksToVersion(normalized, fullPath);

        // 5. ENREGISTREMENT DANS LE JOURNAL D'AUDIT (Traçabilité ISO 27001)
        auditLogService.log("REGISTRE_RISQUES", null,
                "Version générée : " + filename + " | Par : " + username + " | Items : " + entities.size());

        // 6. Mettre à jour aussi le fichier principal (pour l'affichage par défaut)
        excelService.writeRisksToVersion(normalized, "D:/Downoalds/spring-ad-auth/spring-ad-auth/risques_final.xlsx");

        System.out.println("✅ Version archivée : " + filename);
    }

    private List<Map<String, Object>> propagateCategories(List<Map<String, Object>> risks) {
        List<Map<String, Object>> result = new ArrayList<>();
        String lastValid = "Sans catégorie";
        for (Map<String, Object> risk : risks) {
            String cat = (String) risk.get("categorie");
            if (cat != null && !cat.trim().isEmpty()) lastValid = cat.trim();
            Map<String, Object> copy = new LinkedHashMap<>(risk);
            copy.put("categorie", lastValid);
            result.add(copy);
        }
        return result;
    }




/*    @Transactional
    public void saveAllRisks(List<Map<String, Object>> risksData) throws IOException {
        // 1. Gérer les catégories fusionnées (propre au format Excel/Handsontable)
        List<Map<String, Object>> normalized = propagateCategories(risksData);

        // 2. Transformer les Maps reçues en Entités JPA via le Mapper
        List<RegistreRisque> entities = new ArrayList<>();
        for (Map<String, Object> data : normalized) {
            entities.add(riskMapper.mapMapToEntity(data));
        }

        // 3. Sauvegarde DB (On nettoie et on remplace)
        riskRepo.deleteAll();
        riskRepo.saveAll(entities);

        // 4. Synchronisation vers le fichier Excel (L'Excel suit la DB)
        syncDatabaseToExcel();
    }*/


    /**
     * Logique de propagation pour gérer les cellules fusionnées Excel
     */

/*    private List<Map<String, Object>> propagateCategories(List<Map<String, Object>> risks) {
        List<Map<String, Object>> result = new ArrayList<>();
        String lastValid = "";
        for (Map<String, Object> risk : risks) {
            String cat = (String) risk.get("categorie");
            if (cat != null && !cat.trim().isEmpty()) {
                lastValid = cat.trim();
            }
            Map<String, Object> copy = new LinkedHashMap<>(risk);
            copy.put("categorie", lastValid);
            result.add(copy);
        }
        return result;
    }*/




    // Dans RiskTableService.java

    @Transactional
    public List<Map<String, Object>> getJsonRisksFromExcel() throws IOException {
        List<List<String>> rawData = excelService.readRisks();
        List<Map<String, Object>> risksJson = new ArrayList<>();

        // Variables de "mémoire" pour les cellules fusionnées
        String lastCategorie = "";
        String lastMenace = "";
        String lastOrigine = "";
        String lastProprio = "";

        // ON COMMENCE À I = 5 (Saute les 5 lignes de header)
        for (int i = 5; i < rawData.size(); i++) {
            List<String> row = rawData.get(i);
            if (row == null || row.isEmpty()) continue;

            String col0 = safeGet(row, 0); // Menace ou Titre Catégorie

            // 1. DÉTECTION DE CATÉGORIE (ex: 1-Sinistres physiques...)
            if (col0.matches("^\\d-.*")) {
                lastCategorie = col0;
                continue; // On ne traite pas cette ligne comme un risque
            }

            // 2. LOGIQUE DE MÉMOIRE (Propagation pour cellules fusionnées)
            // Si la colonne n'est pas vide, on met à jour la mémoire. Sinon on garde la dernière valeur.
            if (!col0.isEmpty()) lastMenace = col0;
            if (!safeGet(row, 1).isEmpty()) lastOrigine = safeGet(row, 1);
            if (!safeGet(row, 4).isEmpty()) lastProprio = safeGet(row, 4);

            // 3. IDENTIFICATION DU RISQUE PAR LA RÉFÉRENCE (Col D / Index 3)
            String refValue = safeGet(row, 3);
            if (!refValue.isEmpty()) {
                // On passe les "mémoires" au mapper pour remplir les vides
                RegistreRisque entity = riskMapper.mapRowToEntity(row, lastCategorie, lastMenace, lastOrigine, lastProprio);

                // On transforme en Map pour le Frontend Handsontable
                risksJson.add(riskMapper.mapEntityToMap(entity));
            }
        }
        return risksJson;
    }





}

/*
package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.RegistreRisque;
import com.example.spring_ad_auth.model.Risque;
import com.example.spring_ad_auth.repository.RisqueRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.io.IOException;
import java.util.*;
import java.util.regex.Pattern;

@Service
public class RiskTableService {

    @Autowired private ExcelService excelService;
    @Autowired private RisqueRepository risqueRepo;
    private static final Pattern REF_PATTERN = Pattern.compile("^[A-Z]+-\\d+");

    public List<Map<String, Object>> getJsonRisksFromExcel() throws IOException {
        List<List<String>> rawData = excelService.readRisks();
        List<Map<String, Object>> risksJson = new ArrayList<>();

        String lastMenace = "", lastOrigine = "", lastActifs = "", lastCategorie = "",propriotaire="";

        // ON COMMENCE À I = 5 (Saute les titres : Ligne 6 d'Excel)
        for (int i = 5; i < rawData.size(); i++) {
            List<String> row = rawData.get(i);
            if (row == null || row.isEmpty()) continue;

            // Détection de catégorie (ex: 1-Sinistres...)
            String firstCell = safeGet(row, 0);
            if (firstCell.matches("^\\d-.*")) {
                lastCategorie = firstCell;
                continue;
            }

            // Identification par la colonne REF (Index 3 / Colonne D)
            String refValue = safeGet(row, 3);
            if (REF_PATTERN.matcher(refValue).matches()) {

                // Mémoire pour les fusions
                if (!safeGet(row, 0).isEmpty()) lastMenace = safeGet(row, 0);
                if (!safeGet(row, 1).isEmpty()) lastOrigine = safeGet(row, 1);
                if (!safeGet(row, 2).isEmpty()) lastActifs = safeGet(row, 2);
                if (!safeGet(row, 4).isEmpty()) propriotaire = safeGet(row, 4);


                Map<String, Object> r = new LinkedHashMap<>();

                // --- LECTURE ET PARSE DES VALEURS (INDEXATION IMAGE EXCEL) ---
                // Colonnes : D(8), I(9), C(10) | Prob(15), Grav(16)
                int valD = parseVal(safeGet(row, 8));
                int valI = parseVal(safeGet(row, 9));
                int valC = parseVal(safeGet(row, 10));
                int proba = parseVal(safeGet(row, 15));
                int grav = parseVal(safeGet(row, 16));

                // --- AJOUT DES 4 COLONNES D'IMPACT MANQUANTES ---
                int impOrg = parseVal(safeGet(row, 11)); // Colonne L
                int impJur = parseVal(safeGet(row, 12)); // Colonne M
                int impImg = parseVal(safeGet(row, 13)); // Colonne N
                int impFin = parseVal(safeGet(row, 14)); // Colonne O


                // --- CALCULS FORCÉS EN JAVA ---
                int maxDIC = Math.max(valD, Math.max(valI, valC));
                int scoreRes = maxDIC * proba * grav;

                // --- TRAITEMENT CIBLE (Index 20, 21, 22) ---
                int bCible = parseVal(safeGet(row, 20));
                int pCible = parseVal(safeGet(row, 21));
                int gCible = parseVal(safeGet(row, 22));
                int scoreCible = bCible * pCible * gCible;

                // --- CONSTRUCTION DU JSON ---
                r.put("categorie", lastCategorie);
                r.put("ref", refValue);
                r.put("menaces", lastMenace);
                r.put("origine", lastOrigine);
                r.put("actifs", lastActifs);
                r.put("d", valD);
                r.put("i", valI);
                r.put("c", valC);
                r.put("proba", proba);
                r.put("grav", grav);
                r.put("scoreRes", scoreRes);
                r.put("besoinC", bCible);
                r.put("probC", pCible);
                r.put("gravC", gCible);
                r.put("scoreCible", scoreCible);
                r.put("optionApres", (scoreCible <= 12) ? "Accepter" : (scoreCible >= 13 && scoreCible < 23) ? "Surveiller / Accepter avec suivi" : (scoreCible >= 24 && scoreCible < 35) ? "Traiter (réduire)" : "Éviter / Transférer" );

                r.put("proprio", propriotaire);
                r.put("scenario", safeGet(row, 5));
                r.put("vulner", safeGet(row, 6));
                r.put("mesures", safeGet(row, 7));


//                r.put("optionTrait", safeGet(row, 18));
                r.put("optionTrait", (scoreRes <= 12) ? "Accepter" : (scoreRes >= 13 && scoreRes < 23) ? "Surveiller / Accepter avec suivi" : (scoreRes >= 24 && scoreRes < 35) ? "Traiter (réduire)" : "Éviter / Transférer" );

                r.put("actions", safeGet(row, 19));


                r.put("impOrg", impOrg);
                r.put("impJur", impJur);
                r.put("impImg", impImg);
                r.put("impFin", impFin);

                // On récupère Prob (15) et Grav (16)




                risksJson.add(r);

                // Persister immédiatement en BD pour corriger les erreurs de calcul Excel
//                syncToDB(refValue, lastMenace, scoreRes, scoreCible, (String)r.get("optionApres"), valD, valI, valC);
            }
        }
        return risksJson;
    }

    @Transactional
    public void saveAllRisks(List<Map<String, Object>> risks) throws IOException {
        System.out.println("💾 saveAllRisks : " + risks.size() + " éléments");
        List<Map<String, Object>> normalizedRisks = propagateCategories(risks);
        List<RegistreRisque> entities = new ArrayList<>();
        for (Map<String, Object> r : risks) {
            RegistreRisque entity = new RegistreRisque();
            entity.setCategorie((String) r.get("categorie"));
            entity.setRef((String) r.get("ref"));
            entity.setMenaces((String) r.get("menaces"));
            entity.setOrigine((String) r.get("origine"));
            entity.setActifsConcernes((String) r.get("actifs"));
            entity.setProprietaireRisque((String) r.get("proprio"));
            entity.setScenariosRisque((String) r.get("scenario"));
            entity.setVulnerabilites((String) r.get("vulner"));
            entity.setMesuresExistantes((String) r.get("mesures")); // facultatif

            // Appréciation initiale
            entity.setBesoinSecuriteInitial(Math.max(getInt(r.get("d")), Math.max(getInt(r.get("i")), getInt(r.get("c")))));
            entity.setImpactInitial(0); // non utilisé, peut-être calculer plus tard
            entity.setProbabiliteInitial(getInt(r.get("proba")));
            entity.setGraviteInitial(getInt(r.get("grav")));
            entity.setNiveauRisqueInitial(getInt(r.get("scoreRes")));
            entity.setOptionTraitement((String) r.get("optionTrait"));
            entity.setActionsTraitement((String) r.get("actions"));

            // Traitement cible
            entity.setBesoinSecuriteCible(getInt(r.get("besoinC")));
            entity.setProbabiliteCible(getInt(r.get("probC")));
            entity.setGraviteCible(getInt(r.get("gravC")));
            entity.setNiveauRisqueCible(getInt(r.get("scoreCible")));
            entity.setOptionTraitementApres((String) r.get("optionApres"));

            entity.setCouleurStyle(null); // optionnel

            entities.add(entity);
        }

        // Remplacer tout le contenu de la table
        risqueRepo.deleteAll();
        risqueRepo.saveAll(entities);

        // Mettre à jour le fichier Excel
        System.out.println("📁 Appel à writeRisks");
        excelService.writeRisks(normalizedRisks);
        System.out.println("✅ Écriture Excel terminée");
    }

    private int getInt(Object val) {
        if (val == null) return 0;
        if (val instanceof Number) return ((Number) val).intValue();
        try {
            return Integer.parseInt(val.toString());
        } catch (NumberFormatException e) {
            return 0;
        }
    }



    private String safeGet(List<String> row, int idx) {
        return (idx < row.size() && row.get(idx) != null) ? row.get(idx).trim() : "";
    }

    private int parseVal(String val) {
        if (val.isEmpty() || val.contains("*") || val.contains("=") || val.contains("P7")) return 1;
        try {
            // Nettoyage : gère les décimales .0 ou ,0 venant d'Excel
            String clean = val.replace(",", ".").split("\\.")[0].replaceAll("[^0-9]", "");
            return Integer.parseInt(clean);
        } catch (Exception e) { return 1; }
    }


    private List<Map<String, Object>> propagateCategories(List<Map<String, Object>> risks) {
        List<Map<String, Object>> result = new ArrayList<>();
        String lastValid = "";
        for (Map<String, Object> risk : risks) {
            String cat = (String) risk.get("categorie");
            if (cat != null && !cat.trim().isEmpty()) {
                lastValid = cat.trim();
            }
            Map<String, Object> copy = new LinkedHashMap<>(risk);
            if (!lastValid.isEmpty()) {
                copy.put("categorie", lastValid);
            }
            result.add(copy);
        }
        return result;
    }

*/
/*    private void syncToDB(String ref, String m, int res, int cible, String opt, int d, int i, int c) {
        Risque r = risqueRepo.findByRef(ref).orElse(new Risque());
        r.setRef(ref);
        r.setMenaces(m);
        r.setD(d); r.setI_need(i); r.setC(c); // Force les valeurs DIC
        r.setNiveauRisqueResiduel(res);
        r.setNiveauRisqueCible(cible);
        r.setOptionTraitementApres(opt);
        risqueRepo.save(r);
    }*//*

}*/
