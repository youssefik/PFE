package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.ClauseISO;
import com.example.spring_ad_auth.model.Controle;
import com.example.spring_ad_auth.model.ElementSoA;
import com.example.spring_ad_auth.repository.ClauseISORepository;
import com.example.spring_ad_auth.repository.ControleRepository;
import com.example.spring_ad_auth.repository.ElementSoARepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SoAIntegrationService {

    @Autowired
    private ControleRepository controleRepo;
    @Autowired private ElementSoARepository soaRepo;
    @Autowired private SoATableService soaTableService;
    @Autowired
    ExcelService excelService;
    @Autowired
    ClauseISORepository clauseRepo;
// Le service tableur précédent

    private static final String EXCEL_PATH = "./SoA_Export.xlsx";

    // EXPORT : Prend la BD et met à jour le fichier Excel sans détruire les titres
//    public void exportDbToExcel() throws IOException {
//        File file = new File(EXCEL_PATH);
//
//        // 1. Lire les données DEPUIS LA BD (via le service corrigé)
//        List<List<String>> dataFromDb = soaTableService.getSoAAsTable();
//
//        Workbook workbook;
//        try (FileInputStream fis = new FileInputStream(file)) {
//            workbook = new XSSFWorkbook(fis);
//        }
//
//        Sheet sheet = workbook.getSheetAt(1);
//
//        // 2. Nettoyage et Écriture
//        for (int i = 0; i < dataFromDb.size(); i++) {
//            int excelRowNum = i + 2; // Selon votre image, les données commencent souvent ligne 3 (index 2)
//            Row row = sheet.getRow(excelRowNum);
//            if (row == null) row = sheet.createRow(excelRowNum);
//
//            List<String> rowData = dataFromDb.get(i);
//            for (int j = 0; j < rowData.size(); j++) {
//                Cell cell = row.getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
//                cell.setCellValue(rowData.get(j) != null ? rowData.get(j) : "");
//            }
//        }
//
//        // 3. Sauvegarde physique REELLE
//        try (FileOutputStream fos = new FileOutputStream(file)) {
//            workbook.write(fos);
//        }
//        workbook.close();
//        System.out.println("✅ EXPORT TERMINÉ - Allez ouvrir le fichier DDA.xlsx sur votre disque D.");
//    }

/*    public void exportDbToExcel() throws IOException {
        File file = new File(EXCEL_PATH);
        System.out.println(">>> TENTATIVE D'EXPORT VERS : " + file.getAbsolutePath());

        if (!file.exists()) {
            throw new IOException("Fichier introuvable à l'adresse : " + EXCEL_PATH);
        }

        // 1. Charger le fichier
        Workbook workbook;
        try (FileInputStream fis = new FileInputStream(file)) {
            workbook = new XSSFWorkbook(fis);
        }

        // 2. Sélectionner la DEUXIÈME feuille (Index 1)
        if (workbook.getNumberOfSheets() < 2) {
            throw new IOException("Le fichier n'a pas de deuxième feuille pour le SoA.");
        }
        Sheet sheet = workbook.getSheetAt(1);
        System.out.println(">>> ÉCRITURE SUR LA FEUILLE : " + sheet.getSheetName());

        // 3. NETTOYAGE RIGOUREUX : On écrase les lignes existantes à partir de l'index 3
        // On ne supprime pas juste l'objet Row, on s'assure qu'on va tout écraser
        List<List<String>> dataFromDb = soaTableService.getSoAAsTable();

        for (int i = 0; i < dataFromDb.size(); i++) {
            int excelRowNum = i + 3; // Ligne 4 d'Excel
            Row row = sheet.getRow(excelRowNum);
            if (row == null) row = sheet.createRow(excelRowNum);

            List<String> rowData = dataFromDb.get(i);
            for (int j = 0; j < rowData.size(); j++) {
                Cell cell = row.getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                cell.setCellValue(rowData.get(j));
            }
        }

        // 4. SAUVEGARDE FORCEE
        // On utilise un bloc try-with-resources pour être SÛR que le fichier est libéré
        try (FileOutputStream fos = new FileOutputStream(file)) {
            workbook.write(fos);
            fos.flush(); // Force l'écriture des buffers
        } finally {
            workbook.close();
        }

        System.out.println(">>> EXPORT RÉUSSI. Taille finale du fichier : " + file.length() + " octets");
    }*/
    // EXPORT : Prend la BD et crée/écrase le fichier Excel
/*    public void exportDbToExcel() throws IOException {
        List<List<String>> data = soaTableService.getSoAAsTable();
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("SoA_Sync");
            for (int i = 0; i < data.size(); i++) {
                Row row = sheet.createRow(i);
                List<String> rowData = data.get(i);
                for (int j = 0; j < rowData.size(); j++) {
                    row.createCell(j).setCellValue(rowData.get(j));
                }
            }
            try (FileOutputStream fos = new FileOutputStream(EXCEL_PATH)) {
                workbook.write(fos);
            }
        }
    }*/



    // IMPORT : Lit le fichier Excel et met à jour la BD
    public void importExcelToDb() throws IOException {
        // Lit les données à partir de l'index 4 (Ligne 5)
        List<List<String>> sheetData = excelService.readAll();

        // On envoie ces données à la méthode de sauvegarde qui gère déjà la logique BD
        soaTableService.saveTableToDBFromImport(sheetData);
    }
    // IMPORT : Lit le fichier Excel et met à jour la BD
/*    public void importExcelToDb() throws IOException {
        List<List<String>> sheetData = new ArrayList<>();
        try (FileInputStream fis = new FileInputStream(EXCEL_PATH);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                List<String> rowData = new ArrayList<>();
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    rowData.add(row.getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK).toString());
                }
                sheetData.add(rowData);
            }
        }
        // Utilise la logique de sauvegarde en BD déjà créée
        soaTableService.saveTableToDB(sheetData);
    }*/

    public String getExcelPath() {
        return EXCEL_PATH;
    }


    @Transactional
    public void importReferentielFromExcel() throws IOException {
        // On commence par s'assurer que les clauses 4-10 existent
        initManagementSystemClauses();

        List<List<String>> data = excelService.readAll();
        ClauseISO currentAnnexATheme = null;

        for (List<String> row : data) {
            if (row.isEmpty()) continue;

            String colA = row.get(0).trim(); // ex: "5, MESURES..." ou "5.1"
            String colB = (row.size() > 1) ? row.get(1).trim() : ""; // Titre de la mesure

            if (colA.isEmpty()) continue;

            // LOGIQUE : Identifier si c'est un Titre de Thème de l'Annexe A (Ex: "5, MESURES...")
            if (colA.contains(",") || !colA.contains(".")) {
                currentAnnexATheme = clauseRepo.findByCode(colA.split(",")[0].trim());
                if (currentAnnexATheme == null) {
                    currentAnnexATheme = new ClauseISO();
                    // On met un code spécifique pour l'Annexe A pour éviter les conflits avec Clause 5 (Leadership)
                    currentAnnexATheme.setCode("A." + colA.split(",")[0].trim());
                    currentAnnexATheme.setTitre(colA);
                    currentAnnexATheme = clauseRepo.save(currentAnnexATheme);
                    System.out.println("📁 Thème Annexe A créé : " + colA);
                }
            }
            // LOGIQUE : C'est une mesure de sécurité (Ex: "5.1")
            else {
                Controle ctrl = controleRepo.findByCode(colA);
                if (ctrl == null) {
                    ctrl = new Controle();
                    ctrl.setCode(colA);
                    ctrl.setTitre(colB);
                    ctrl.setClauseISO(currentAnnexATheme);
                    ctrl.setDomaine(currentAnnexATheme != null ? currentAnnexATheme.getTitre() : "Annexe A");
                    ctrl = controleRepo.save(ctrl);
                }

                // Synchro ElementSoA
                ElementSoA soa = soaRepo.findByControleId(ctrl.getId()).orElse(new ElementSoA());
                soa.setControle(ctrl);
                soa.setApplicable("OUI".equalsIgnoreCase(row.get(2)));
                soa.setJustification(row.size() > 3 ? row.get(3) : "");
                soa.setDispositif(row.size() > 4 ? row.get(4) : "");
                soa.setStatutMiseEnOeuvre(row.size() > 5 ? row.get(5) : "");
                soa.setResponsable(row.size() > 6 ? row.get(6) : "");
                soaRepo.save(soa);
            }
        }
    }


/*
    public void importReferentielFromExcel() throws IOException {
        // Lecture de la feuille 1 (DDA), à partir de la ligne 5 (Index 4)
        List<List<String>> data = excelService.readAll();
        System.out.println("Début de l'importation... " + data.size() + " lignes.");

        ClauseISO currentTheme = null;

        for (List<String> row : data) {
            if (row.isEmpty()) continue;

            String colA = row.get(0).trim(); // Index 0: Code ou Thème
            String colB = (row.size() > 1) ? row.get(1).trim() : ""; // Index 1: Titre

            if (colA.isEmpty()) continue;

            // LOGIQUE 1 : Si la colonne A contient une virgule (ex: "5, MESURES...") -> C'est un THÈME (Clause)
            if (colA.contains(",") || !colA.contains(".")) {
                currentTheme = clauseRepo.findByTitre(colA);
                if (currentTheme == null) {
                    currentTheme = new ClauseISO();
                    currentTheme.setCode(colA.split(",")[0]); // "5"
                    currentTheme.setTitre(colA);
                    currentTheme = clauseRepo.save(currentTheme);
                    System.out.println("📁 Thème créé : " + colA);
                }
            }

            // LOGIQUE 2 : Si la colonne A contient un point (ex: "5.1") -> C'est un CONTRÔLE
            else {
                Controle ctrl = controleRepo.findByCode(colA);
                if (ctrl == null) {
                    ctrl = new Controle();
                    ctrl.setCode(colA);
                    ctrl.setTitre(colB);
                    ctrl.setClauseISO(currentTheme); // On le lie au thème parent
                    ctrl.setDomaine(currentTheme != null ? currentTheme.getTitre() : "Général");
                    ctrl = controleRepo.save(ctrl);
                }

                // LOGIQUE 3 : Remplissage immédiat de l'ElementSoA (L'état de conformité)
                // On récupère les colonnes C, D, E, F, G
                ElementSoA soa = soaRepo.findByControleId(ctrl.getId()).orElse(new ElementSoA());
                soa.setControle(ctrl);

                // Col C (Index 2): Applicabilité
                soa.setApplicable("OUI".equalsIgnoreCase(row.get(2)));

                // Col D (Index 3): Justification
                soa.setJustification(row.size() > 3 ? row.get(3) : "");

                // Col E (Index 4): Preuve (Dispositif)
                soa.setDispositif(row.size() > 4 ? row.get(4) : "");

                // Col F (Index 5): Mise en place? (Statut)
                soa.setStatutMiseEnOeuvre(row.size() > 5 ? row.get(5) : "");

                // Col G (Index 6): Responsable
                soa.setResponsable(row.size() > 6 ? row.get(6) : "");

                soaRepo.save(soa);
            }
        }
    }
*/

/*    @Transactional
    public void importReferentielFromExcel() throws IOException {
        List<List<String>> data = excelService.readAll();
        System.out.println("Début de l'importation du référentiel... " + data.size() + " lignes.");

        ClauseISO currentClause = null;

        // On commence à i=1 pour sauter les titres
        for (int i = 1; i < data.size(); i++) {
            List<String> row = data.get(i);
            if (row.size() < 3) continue;

            String code = row.get(1).trim(); // ex: "5.1" ou "5.1.1"
            String titre = row.get(2).trim();

            if (code.isEmpty() || titre.isEmpty()) continue;

            // Si le code est court (ex: 5.1), c'est une Clause
            if (code.split("\\.").length <= 2) {
                currentClause = clauseRepo.findByCode(code);
                if (currentClause == null) {
                    currentClause = new ClauseISO();
                    currentClause.setCode(code);
                    currentClause.setTitre(titre);
                    currentClause = clauseRepo.save(currentClause);
                    System.out.println("✅ Clause créée : " + code);
                }
            }
            // Si le code est long (ex: 5.1.1), c'est un Contrôle
            else {
                Controle ctrl = controleRepo.findByCode(code);
                if (ctrl == null) {
                    ctrl = new Controle();
                    ctrl.setCode(code);
                    ctrl.setTitre(titre);
                    ctrl.setClauseISO(currentClause);
                    ctrl.setDomaine(row.get(0)); // Première colonne
                    controleRepo.save(ctrl);
                    System.out.println("✅ Contrôle créé : " + code);
                }
            }
        }
    }*/

    public void initManagementSystemClauses() {
        // 1. Création des sections mères (Parents)
        String[][] parents = {{"4", "Contexte"}, {"5", "Leadership"}, {"6", "Planification"}, {"7", "Support"}, {"8", "Fonctionnement"}, {"9", "Évaluation"}, {"10", "Amélioration"}};
        Map<String, ClauseISO> parentMap = new HashMap<>();

        for (String[] p : parents) {
            ClauseISO c = clauseRepo.findByCode(p[0]);
            if (c == null) {
                c = new ClauseISO();
                c.setCode(p[0]);
                c.setTitre(p[1]);
                c = clauseRepo.save(c);
            }
            parentMap.put(p[0], c);
        }

        // 2. Création des sous-exigences détaillées
        String[][] subClauses = {
                // Clause 4
                {"4", "4.1", "Compréhension de l'organisation", "Identifier les enjeux internes et externes pertinents."},
                {"4", "4.2", "Parties intéressées", "Identifier besoins et attentes des parties intéressées."},
                {"4", "4.3", "Périmètre du SMSI", "Déterminer les limites et l'applicabilité du SMSI."},
                {"4", "4.4", "SMSI", "Établir, mettre en œuvre, maintenir et améliorer le SMSI."},
                // Clause 5
                {"5", "5.1", "Leadership et engagement", "Démontrer l'engagement de la direction pour le SMSI."},
                {"5", "5.2", "Politique", "Établir et communiquer une politique de sécurité."},
                {"5", "5.3", "Rôles et responsabilités", "Attribuer et communiquer les responsabilités de sécurité."},
                // Clause 6
                {"6", "6.1.1", "Actions face aux risques", "Actions pour faire face aux risques et opportunités."},
                {"6", "6.1.2", "Appréciation des risques", "Identifier, analyser et évaluer les risques."},
                {"6", "6.1.3", "Traitement des risques", "Sélectionner et planifier le traitement des risques."},
                {"6", "6.2", "Objectifs sécurité", "Définir des objectifs de sécurité mesurables."},
                {"6", "6.3", "Planification des changements", "Gérer les modifications du SMSI de façon planifiée."},
                // Clause 7
                {"7", "7.1", "Ressources", "Fournir les ressources nécessaires au SMSI."},
                {"7", "7.2", "Compétences", "S'assurer des compétences nécessaires du personnel."},
                {"7", "7.3", "Sensibilisation", "Sensibiliser le personnel à la sécurité."},
                {"7", "7.4", "Communication", "Définir les besoins de communication interne/externe."},
                {"7", "7.5", "Informations documentées", "Gérer la création, mise à jour et contrôle des documents."},
                // Clause 8
                {"8", "8.1", "Planification opérationnelle", "Planifier et contrôler les processus nécessaires."},
                {"8", "8.2", "Appréciation des risques", "Réaliser des évaluations de risques périodiques."},
                {"8", "8.3", "Traitement des risques", "Mettre en œuvre le plan de traitement des risques."},
                // Clause 9
                {"9", "9.1", "Surveillance et mesure", "Évaluer les performances et l'efficacité du SMSI."},
                {"9", "9.2", "Audit interne", "Planifier et réaliser des audits internes à intervalles réguliers."},
                {"9", "9.3", "Revue de direction", "Évaluation périodique du SMSI par la Direction."},
                // Clause 10
                {"10", "10.1", "Amélioration continue", "Améliorer en permanence la pertinence du SMSI."},
                {"10", "10.2", "Non-conformités", "Réagir aux NC et mener les actions correctives."}
        };

        for (String[] data : subClauses) {
            if (clauseRepo.findByCode(data[1]) == null) {
                ClauseISO sub = new ClauseISO();
                sub.setParent(parentMap.get(data[0])); // Lien hiérarchique
                sub.setCode(data[1]);
                sub.setTitre(data[2]);
                sub.setExigences(data[3]);
                clauseRepo.save(sub);
            }
        }
    }
/*
    public void initManagementSystemClauses() {
        String[][] mainClauses = {
                {"4", "Contexte de l'organisme", "Compréhension de l'organisme et de son contexte (besoins, parties intéressées, périmètre)."},
                {"5", "Leadership", "Engagement de la direction, politique et rôles organisationnels."},
                {"6", "Planification", "Actions à face aux risques et opportunités, objectifs de sécurité."},
                {"7", "Support", "Ressources, compétences, sensibilisation, communication et informations documentées."},
                {"8", "Fonctionnement", "Planification, contrôle opérationnel et évaluation des risques."},
                {"9", "Évaluation des performances", "Surveillance, mesure, analyse, audit interne et revue de direction."},
                {"10", "Amélioration", "Non-conformités, actions correctives et amélioration continue."}
        };

        for (String[] data : mainClauses) {
            if (clauseRepo.findByCode(data[0]) == null) {
                ClauseISO clause = new ClauseISO();
                clause.setCode(data[0]);
                clause.setTitre(data[1]);
                clause.setDescription(data[2]);
                clauseRepo.save(clause);
                System.out.println("✅ Clause Standard créée : " + data[0]);
            }
        }
    }
*/

    public boolean isReferentielEmpty() {
        return controleRepo.count() == 0;
    }
}