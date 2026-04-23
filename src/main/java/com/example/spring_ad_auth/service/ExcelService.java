package com.example.spring_ad_auth.service;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import java.io.*;
import java.util.*;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.stream.Collectors;

@Service
public class ExcelService {

    private static final String EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/DDA.xlsx";
    private static final String RISK_EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/risques_final.xlsx";

    // Modifié pour lire à partir de la ligne 5 (Index 4)
    public List<List<String>> readAll() throws IOException {
        return readGenericFromLine(EXCEL_PATH, 8, 1, 4);
    }


    public List<List<String>> readRisks() throws IOException {
        File file = new File(RISK_EXCEL_PATH);
        if (!file.exists()) {
            try (XSSFWorkbook workbook = new XSSFWorkbook()) {
                Sheet sheet = workbook.createSheet("Risques");
                createFullHeaderRows(sheet);
                try (FileOutputStream fos = new FileOutputStream(file)) {
                    workbook.write(fos);
                }
            }
        }
        return readGeneric(RISK_EXCEL_PATH, 25 , 0,5);
    }

    private List<List<String>> readGenericFromLine(String path, int maxCols, int sheetIdx, int startRow) throws IOException {
        List<List<String>> result = new ArrayList<>();
        try (FileInputStream fis = new FileInputStream(new File(path));
             Workbook wb = new XSSFWorkbook(fis)) {
            Sheet sheet = wb.getSheetAt(sheetIdx);
            for (int i = startRow; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                List<String> rowData = new ArrayList<>();
                for (int j = 0; j < maxCols; j++) {
                    Cell c = row.getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                    rowData.add(c.toString());
                }
                result.add(rowData);
            }
        }
        return result;
    }

//    public void writeRisks(List<Map<String, Object>> risks) throws IOException {
//        risks = propagateCategories(risks);
//
//        File original = new File(RISK_EXCEL_PATH);
//        File tempFile = new File(original.getAbsolutePath() + ".tmp");
//
//        if (original.exists() && !original.canWrite()) {
//            throw new IOException("Le fichier Excel est verrouillé. Veuillez fermer Excel.");
//        }
//
//        List<Row> headerRows = new ArrayList<>();
//        XSSFWorkbook originalWorkbook = null;
//        if (original.exists()) {
//            try (FileInputStream fis = new FileInputStream(original)) {
//                originalWorkbook = new XSSFWorkbook(fis);
//                Sheet sheet = originalWorkbook.getSheetAt(0);
//                if (sheet == null) throw new IOException("Aucune feuille trouvée dans le fichier.");
//                for (int i = 0; i <= 4; i++) {
//                    headerRows.add(sheet.getRow(i));
//                }
//            }
//        }
//
//        XSSFWorkbook newWorkbook = new XSSFWorkbook();
//        Sheet newSheet = newWorkbook.createSheet("Risques");
//
//        // Copier les 5 premières lignes d'en-tête
//        for (int i = 0; i < 5; i++) {
//            Row sourceRow = (i < headerRows.size()) ? headerRows.get(i) : null;
//            Row newRow = newSheet.createRow(i);
//            if (sourceRow != null) {
//                copyRow(sourceRow, newRow, newWorkbook);
//            } else {
//                for (int j = 0; j < 25; j++) newRow.createCell(j);
//            }
//        }
//
//        if (headerRows.isEmpty() || headerRows.stream().allMatch(Objects::isNull)) {
//            createFullHeaderRows(newSheet);
//        }
//
//        // Regrouper les risques par catégorie
//        Map<String, List<Map<String, Object>>> risksByCategory = new LinkedHashMap<>();
//        for (Map<String, Object> risk : risks) {
//            String cat = (String) risk.get("categorie");
//            if (cat == null) cat = "";
//            risksByCategory.computeIfAbsent(cat, k -> new ArrayList<>()).add(risk);
//        }
//
//        int rowNum = 5;
//        for (Map.Entry<String, List<Map<String, Object>>> entry : risksByCategory.entrySet()) {
//            String category = entry.getKey();
//            List<Map<String, Object>> catRisks = entry.getValue();
//
//            if (category != null && !category.trim().isEmpty()) {
//                Row catRow = newSheet.createRow(rowNum++);
//                catRow.createCell(0).setCellValue(category);
//            }
//
//            for (Map<String, Object> risk : catRisks) {
//                Row row = newSheet.createRow(rowNum++);
//                row.createCell(0).setCellValue(""); // catégorie vide
//
//                // Colonnes dans l'ordre attendu par la lecture (0‑24)
//                setCellValue(row.createCell(0), (String) risk.get("menaces"));
//                setCellValue(row.createCell(1), (String) risk.get("origine"));
//                setCellValue(row.createCell(2), (String) risk.get("actifs"));
//                setCellValue(row.createCell(3), (String) risk.get("ref"));
//                setCellValue(row.createCell(4), (String) risk.get("proprio"));
//                setCellValue(row.createCell(5), (String) risk.get("scenario"));
//                setCellValue(row.createCell(6), (String) risk.get("vulner"));
//                setCellValue(row.createCell(7), (String) risk.get("mesures"));          // colonne 8 = mesures
//                setCellValue(row.createCell(8), getInt(risk.get("d")));                 // 9 = D
//                setCellValue(row.createCell(9), getInt(risk.get("i")));                // 10 = I
//                setCellValue(row.createCell(10), getInt(risk.get("c")));                // 11 = C
//                setCellValue(row.createCell(11), getInt(risk.get("impOrg")));           // 12 = Org
//                setCellValue(row.createCell(12), getInt(risk.get("impJur")));           // 13 = Jur
//                setCellValue(row.createCell(13), getInt(risk.get("impImg")));           // 14 = Img
//                setCellValue(row.createCell(14), getInt(risk.get("impFin")));           // 15 = Fin
//                setCellValue(row.createCell(15), getInt(risk.get("proba")));            // 16 = Prob
//                setCellValue(row.createCell(16), getInt(risk.get("grav")));             // 17 = Grav
//                setCellValue(row.createCell(17), getInt(risk.get("scoreRes")));         // 18 = Score
//                setCellValue(row.createCell(18), (String) risk.get("optionTrait"));     // 19 = Option
//                setCellValue(row.createCell(19), (String) risk.get("actions"));         // 20 = Actions
//                setCellValue(row.createCell(20), getInt(risk.get("besoinC")));          // 21 = BesoinC
//                setCellValue(row.createCell(21), getInt(risk.get("probC")));            // 22 = ProbC
//                setCellValue(row.createCell(22), getInt(risk.get("gravC")));            // 23 = GravC
//                setCellValue(row.createCell(23), getInt(risk.get("scoreCible")));       // 24 = Score Cible
//                // La colonne 25 (optionApres) n'est pas lue, donc omise
//            }
//        }
//
//        try (FileOutputStream fos = new FileOutputStream(tempFile)) {
//            newWorkbook.write(fos);
//            fos.flush();
//        } finally {
//            newWorkbook.close();
//            if (originalWorkbook != null) originalWorkbook.close();
//        }
//
//        if (original.exists() && !original.delete()) {
//            throw new IOException("Impossible de supprimer l'ancien fichier (fermez Excel).");
//        }
//        if (!tempFile.renameTo(original)) {
//            throw new IOException("Échec du renommage du fichier temporaire.");
//        }
//
//        System.out.println("✅ Fichier Excel mis à jour : " + original.getAbsolutePath());
//    }


    public void writeRisks(List<Map<String, Object>> risks) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Risques");
        createFullHeaderRows(sheet); // Ta méthode de création de headers

        // Groupement par catégorie pour créer les lignes titres
        Map<String, List<Map<String, Object>>> grouped = risks.stream()
                .collect(Collectors.groupingBy(r -> (String) r.get("categorie"), LinkedHashMap::new, Collectors.toList()));

        int rowIdx = 5; // On commence après le header
        for (Map.Entry<String, List<Map<String, Object>>> entry : grouped.entrySet()) {

            // 1. Écrire la ligne de TITRE DE GROUPE (ex: 1-Sinistres...)
            Row catRow = sheet.createRow(rowIdx++);
            Cell catCell = catRow.createCell(0);
            catCell.setCellValue(entry.getKey());
            // Optionnel: ajouter du style gras/couleur ici

            // 2. Écrire les risques de cette catégorie
            for (Map<String, Object> r : entry.getValue()) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(String.valueOf(r.get("menaces")));
                row.createCell(1).setCellValue(String.valueOf(r.get("origine")));
                row.createCell(2).setCellValue(String.valueOf(r.get("actifs")));
                row.createCell(3).setCellValue(String.valueOf(r.get("ref")));
                row.createCell(4).setCellValue(String.valueOf(r.get("proprio")));
                row.createCell(5).setCellValue(String.valueOf(r.get("scenario")));
                row.createCell(6).setCellValue(String.valueOf(r.get("vulner")));
                row.createCell(7).setCellValue(String.valueOf(r.get("mesures")));
                row.createCell(8).setCellValue(getInt(r.get("d")));
                row.createCell(9).setCellValue(getInt(r.get("i")));
                row.createCell(10).setCellValue(getInt(r.get("c")));
                row.createCell(11).setCellValue(getInt(r.get("impOrg")));
                row.createCell(12).setCellValue(getInt(r.get("impJur")));
                row.createCell(13).setCellValue(getInt(r.get("impImg")));
                row.createCell(14).setCellValue(getInt(r.get("impFin")));
                row.createCell(15).setCellValue(getInt(r.get("proba")));
                row.createCell(16).setCellValue(getInt(r.get("grav")));
                row.createCell(17).setCellValue(getInt(r.get("scoreRes")));
                row.createCell(18).setCellValue(String.valueOf(r.get("optionTrait")));
                row.createCell(19).setCellValue(String.valueOf(r.get("actions")));
                row.createCell(20).setCellValue(getInt(r.get("besoinC")));
                row.createCell(21).setCellValue(getInt(r.get("probC")));
                row.createCell(22).setCellValue(getInt(r.get("gravC")));
                row.createCell(23).setCellValue(getInt(r.get("scoreCible")));
                row.createCell(24).setCellValue(String.valueOf(r.get("optionApres")));
            }
        }

        try (FileOutputStream fos = new FileOutputStream(RISK_EXCEL_PATH)) {
            workbook.write(fos);
        }
        workbook.close();
    }

    // ---------------------------------------------------------------------
    // Méthodes utilitaires (propagation, copie de lignes, etc.)
    // ---------------------------------------------------------------------
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

    private void setCellValue(Cell cell, String value) { cell.setCellValue(value != null ? value : ""); }


    private void setCellValue(Cell cell, int value) { cell.setCellValue(value); }

    private int getInt(Object val) {
        if (val == null) return 0;
        if (val instanceof Number) return ((Number) val).intValue();
        try {
            return Integer.parseInt(val.toString());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private void copyRow(Row sourceRow, Row targetRow, Workbook newWorkbook) {
        for (int i = 0; i < sourceRow.getLastCellNum(); i++) {
            Cell sourceCell = sourceRow.getCell(i);
            if (sourceCell != null) {
                Cell targetCell = targetRow.createCell(i);
                copyCell(sourceCell, targetCell, newWorkbook);
            }
        }
        Sheet sourceSheet = sourceRow.getSheet();
        Sheet targetSheet = targetRow.getSheet();
        for (int i = 0; i < sourceSheet.getNumMergedRegions(); i++) {
            CellRangeAddress region = sourceSheet.getMergedRegion(i);
            if (region.getFirstRow() == sourceRow.getRowNum()) {
                CellRangeAddress newRegion = new CellRangeAddress(
                        targetRow.getRowNum(), targetRow.getRowNum(),
                        region.getFirstColumn(), region.getLastColumn()
                );
                targetSheet.addMergedRegion(newRegion);
            }
        }
    }

    private void copyCell(Cell source, Cell target, Workbook newWorkbook) {
        target.setCellType(source.getCellType());
        switch (source.getCellType()) {
            case STRING:
                target.setCellValue(source.getStringCellValue());
                break;
            case NUMERIC:
                target.setCellValue(source.getNumericCellValue());
                break;
            case BOOLEAN:
                target.setCellValue(source.getBooleanCellValue());
                break;
            case FORMULA:
                target.setCellFormula(source.getCellFormula());
                break;
            default:
                target.setCellValue("");
        }
        CellStyle newStyle = newWorkbook.createCellStyle();
        newStyle.cloneStyleFrom(source.getCellStyle());
        target.setCellStyle(newStyle);
    }

    private void createFullHeaderRows(Sheet sheet) {
        // Ligne 0 : titre
        Row titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("Programme gestion des risques");
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 24));
        // Ligne 1 : vide
        sheet.createRow(1);
        // Ligne 2 : "APPRECIATION DE RISQUE" et "TRAITEMENT DE RISQUE"
        Row row2 = sheet.createRow(2);
        row2.createCell(0).setCellValue("APPRECIATION DE RISQUE");
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 17));
        row2.createCell(18).setCellValue("TRAITEMENT DE RISQUE");
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 18, 24));
        // Ligne 3 : en-têtes principaux
        Row row3 = sheet.createRow(3);
        String[] headers = {
                "Menaces", "Origine", "Actifs concernés", "REF", "Propriétaire de risque",
                "Scénarios de risque", "Vulnérabilités", "Mesures existantes", "Besoin de sécurité",
                "", "", "Impact", "", "", "", "Probabilité", "Gravité", "Niveau de risque résiduel",
                "Option de traitement du risque", "Actions de traitement", "Besoin de sécurité",
                "Probabilité", "Gravité", "Niveau de risque cible", "Option de traitement du risque après"
        };
        for (int i = 0; i < headers.length; i++) {
            row3.createCell(i).setCellValue(headers[i]);
        }
        // Ligne 4 : sous-en-têtes
        Row row4 = sheet.createRow(4);
        String[] subHeaders = {
                "", "", "", "", "", "", "", "", "D", "I", "C", "Organisationnel",
                "Juridique et réglementaire", "Image", "Financier", "", "", "", "", "", "", "", "", "", ""
        };
        for (int i = 0; i < subHeaders.length; i++) {
            row4.createCell(i).setCellValue(subHeaders[i]);
        }
    }

    // ---------------------------------------------------------------------
    // Lecture générique et sauvegardes
    // ---------------------------------------------------------------------
    // Dans ExcelService.java

    private List<List<String>> readGeneric(String filePath, int maxCols, int sheetIndex, int startRow) throws IOException {
        List<List<String>> result = new ArrayList<>();
        try (FileInputStream fis = new FileInputStream(filePath);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(sheetIndex);

            // On commence la boucle à startRow (Index 4)
            for (int i = startRow; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                List<String> rowData = new ArrayList<>();
                for (int cn = 0; cn < maxCols; cn++) {
                    Cell cell = row.getCell(cn, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
                    if (cell == null) {
                        rowData.add("");
                    } else {
                        // Transformation simple en String (conforme à votre code initial)
                        rowData.add(cell.toString());
                    }
                }
                result.add(rowData);
            }
        }
        return result;
    }

/*
    private List<List<String>> readGeneric(String filePath, int maxCols) throws IOException {
        List<List<String>> result = new ArrayList<>();
        try (FileInputStream fis = new FileInputStream(filePath);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                List<String> rowData = new ArrayList<>();
                for (int cn = 0; cn < maxCols; cn++) {
                    Cell cell = row.getCell(cn, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
                    if (cell == null) {
                        rowData.add("");
                    } else {
                        switch (cell.getCellType()) {
                            case STRING:
                                rowData.add(cell.getStringCellValue());
                                break;
                            case NUMERIC:
                                rowData.add(String.valueOf((int) cell.getNumericCellValue()));
                                break;
                            default:
                                rowData.add("");
                        }
                    }
                }
                result.add(rowData);
            }
        }
        return result;
    }
*/


    // Écrit dans l'Excel à partir de la ligne 5 (Index 4)
    public void saveAll(List<List<String>> data) throws IOException {
        saveToExcel(EXCEL_PATH, data, 8, 1, 4);
    }


    private void saveToExcel(String path, List<List<String>> data, int colLimit, int sheetIdx, int startIdx) throws IOException {
        Workbook wb;
        try (FileInputStream fis = new FileInputStream(new File(path))) {
            wb = new XSSFWorkbook(fis);
        }
        Sheet sheet = wb.getSheetAt(sheetIdx);

        // Nettoyage avant écriture (ligne 5 et +)
        for (int i = sheet.getLastRowNum(); i >= startIdx; i--) {
            Row r = sheet.getRow(i);
            if (r != null) sheet.removeRow(r);
        }

        // Écriture
        for (int i = 0; i < data.size(); i++) {
            Row row = sheet.createRow(i + startIdx);
            for (int j = 0; j < Math.min(data.get(i).size(), colLimit); j++) {
                row.createCell(j).setCellValue(data.get(i).get(j));
            }
        }

        try (FileOutputStream fos = new FileOutputStream(new File(path))) {
            wb.write(fos);
        }
        wb.close();
    }



    public void saveRisks(List<List<String>> data) throws IOException {
        // Pour les Risques : on reste sur la PREMIÈRE feuille (index 0)
        // et on commence à la ligne 0 (comportement d'origine)
        saveGenericUpdate(RISK_EXCEL_PATH, data, 25, 0, 0);
    }


    public void writeRisksToVersion(List<Map<String, Object>> risks, String path) throws IOException {
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Risques");

            // On réutilise tes headers officiels
            createFullHeaderRows(sheet);

            int rowIdx = 5; // On commence après l'entête

            // Groupement pour le rendu visuel Excel (cellules fusionnées)
            Map<String, List<Map<String, Object>>> grouped = risks.stream()
                    .collect(Collectors.groupingBy(r -> (String) r.get("categorie"), LinkedHashMap::new, Collectors.toList()));

            for (Map.Entry<String, List<Map<String, Object>>> entry : grouped.entrySet()) {
                // Ligne de titre de catégorie (Barre rouge ou grisée)
                Row catRow = sheet.createRow(rowIdx++);
                catRow.createCell(0).setCellValue(entry.getKey());

                // Lignes de données
                for (Map<String, Object> r : entry.getValue()) {
                    Row row = sheet.createRow(rowIdx++);
                    writeRiskRow(row, r); // Utilise ton helper pour remplir les 25 colonnes
                }
            }

            // Sauvegarde sur le disque
            try (FileOutputStream fos = new FileOutputStream(path)) {
                workbook.write(fos);
            }
        }
    }


    private void writeRiskRow(Row row, Map<String, Object> r) {
        // On remplit les 25 colonnes selon ton mapping
        /*row.createCell(0).setCellValue(String.valueOf(r.getOrDefault("menaces","")));
        row.createCell(1).setCellValue(String.valueOf(r.getOrDefault("origine","")));
        row.createCell(2).setCellValue(String.valueOf(r.getOrDefault("actifs","")));
        row.createCell(3).setCellValue(String.valueOf(r.getOrDefault("ref","")));*/
        // ... continue pour les colonnes de 4 à 24 ...
        // Note : utilise getInt() pour les colonnes numériques (D, I, C, Proba, etc.)

        row.createCell(0).setCellValue(String.valueOf(r.get("menaces")));
        row.createCell(1).setCellValue(String.valueOf(r.get("origine")));
        row.createCell(2).setCellValue(String.valueOf(r.get("actifs")));
        row.createCell(3).setCellValue(String.valueOf(r.get("ref")));
        row.createCell(4).setCellValue(String.valueOf(r.get("proprio")));
        row.createCell(5).setCellValue(String.valueOf(r.get("scenario")));
        row.createCell(6).setCellValue(String.valueOf(r.get("vulner")));
        row.createCell(7).setCellValue(String.valueOf(r.get("mesures")));
        row.createCell(8).setCellValue(getInt(r.get("d")));
        row.createCell(9).setCellValue(getInt(r.get("i")));
        row.createCell(10).setCellValue(getInt(r.get("c")));
        row.createCell(11).setCellValue(getInt(r.get("impOrg")));
        row.createCell(12).setCellValue(getInt(r.get("impJur")));
        row.createCell(13).setCellValue(getInt(r.get("impImg")));
        row.createCell(14).setCellValue(getInt(r.get("impFin")));
        row.createCell(15).setCellValue(getInt(r.get("proba")));
        row.createCell(16).setCellValue(getInt(r.get("grav")));
        row.createCell(17).setCellValue(getInt(r.get("scoreRes")));
        row.createCell(18).setCellValue(String.valueOf(r.get("optionTrait")));
        row.createCell(19).setCellValue(String.valueOf(r.get("actions")));
        row.createCell(20).setCellValue(getInt(r.get("besoinC")));
        row.createCell(21).setCellValue(getInt(r.get("probC")));
        row.createCell(22).setCellValue(getInt(r.get("gravC")));
        row.createCell(23).setCellValue(getInt(r.get("scoreCible")));
        row.createCell(24).setCellValue(String.valueOf(r.get("optionApres")));
    }



/*
    public void writeRisksToVersion(List<Map<String, Object>> risks, String versionedPath) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Risques");
        createFullHeaderRows(sheet);

        // Groupement par catégorie (comme nous l'avions fait)
        Map<String, List<Map<String, Object>>> grouped = risks.stream()
                .collect(Collectors.groupingBy(r -> (String) r.getOrDefault("categorie", "Sans catégorie"),
                        LinkedHashMap::new, Collectors.toList()));

        int rowIdx = 5;
        for (Map.Entry<String, List<Map<String, Object>>> entry : grouped.entrySet()) {
            Row catRow = sheet.createRow(rowIdx++);
            catRow.createCell(0).setCellValue(entry.getKey());

            for (Map<String, Object> r : entry.getValue()) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(String.valueOf(r.get("menaces")));
                row.createCell(1).setCellValue(String.valueOf(r.get("origine")));
                row.createCell(2).setCellValue(String.valueOf(r.get("actifs")));
                row.createCell(3).setCellValue(String.valueOf(r.get("ref")));
                row.createCell(4).setCellValue(String.valueOf(r.get("proprio")));
                row.createCell(5).setCellValue(String.valueOf(r.get("scenario")));
                row.createCell(6).setCellValue(String.valueOf(r.get("vulner")));
                row.createCell(7).setCellValue(String.valueOf(r.get("mesures")));
                row.createCell(8).setCellValue(getInt(r.get("d")));
                row.createCell(9).setCellValue(getInt(r.get("i")));
                row.createCell(10).setCellValue(getInt(r.get("c")));
                row.createCell(11).setCellValue(getInt(r.get("impOrg")));
                row.createCell(12).setCellValue(getInt(r.get("impJur")));
                row.createCell(13).setCellValue(getInt(r.get("impImg")));
                row.createCell(14).setCellValue(getInt(r.get("impFin")));
                row.createCell(15).setCellValue(getInt(r.get("proba")));
                row.createCell(16).setCellValue(getInt(r.get("grav")));
                row.createCell(17).setCellValue(getInt(r.get("scoreRes")));
                row.createCell(18).setCellValue(String.valueOf(r.get("optionTrait")));
                row.createCell(19).setCellValue(String.valueOf(r.get("actions")));
                row.createCell(20).setCellValue(getInt(r.get("besoinC")));
                row.createCell(21).setCellValue(getInt(r.get("probC")));
                row.createCell(22).setCellValue(getInt(r.get("gravC")));
                row.createCell(23).setCellValue(getInt(r.get("scoreCible")));
                row.createCell(24).setCellValue(String.valueOf(r.get("optionApres")));
                // etc...
            }
        }

        // ÉCRITURE DANS LE NOUVEAU FICHIER VERSIONNÉ
        try (FileOutputStream fos = new FileOutputStream(versionedPath)) {
            workbook.write(fos);
        }
        workbook.close();
    }
*/

    /**
     * Cette méthode ouvre le fichier existant pour préserver les headers complexes
     */

    private void saveGenericUpdate(String path, List<List<String>> data, int colLimit, int sheetIndex, int startRowIndex) throws IOException {
        File file = new File(path);
        Workbook workbook;
        try (FileInputStream fis = new FileInputStream(file)) {
            workbook = new XSSFWorkbook(fis);
        }

        Sheet sheet = workbook.getSheetAt(sheetIndex);

        // 1. Nettoyage sécurisé à partir de la ligne 5
        int lastRow = sheet.getLastRowNum();
        for (int i = lastRow; i >= startRowIndex; i--) {
            Row r = sheet.getRow(i);
            if (r != null) sheet.removeRow(r);
        }

        // 2. Écriture des données
        for (int i = 0; i < data.size(); i++) {
            Row row = sheet.createRow(i + startRowIndex);
            List<String> rowData = data.get(i);
            for (int j = 0; j < Math.min(rowData.size(), colLimit); j++) {
                row.createCell(j).setCellValue(rowData.get(j));
            }
        }

        try (FileOutputStream fos = new FileOutputStream(path)) {
            workbook.write(fos);
        }
        workbook.close();
    }
}



/*    public void saveAll(List<List<String>> data) throws IOException {
        saveGeneric(EXCEL_PATH, data, 8, "SoA");
    }

    public void saveRisks(List<List<String>> data) throws IOException {
        saveGeneric(RISK_EXCEL_PATH, data, 25, "Risques");
    }

    private void saveGeneric(String path, List<List<String>> data, int colLimit, String sheetName) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet(sheetName);
            for (int i = 0; i < data.size(); i++) {
                Row row = sheet.createRow(i);
                List<String> rowData = data.get(i);
                for (int j = 0; j < Math.min(rowData.size(), colLimit); j++) {
                    row.createCell(j).setCellValue(rowData.get(j));
                }
            }
            try (FileOutputStream fos = new FileOutputStream(path)) {
                workbook.write(fos);
            }
        }
    }*/


//v2

//package com.example.spring_ad_auth.service;
//
//import org.apache.poi.ss.usermodel.*;
//import org.apache.poi.ss.util.CellRangeAddress;
//import org.apache.poi.xssf.usermodel.XSSFWorkbook;
//import org.springframework.stereotype.Service;
//import java.io.*;
//import java.util.*;
//import java.nio.file.Files;
//import java.nio.file.StandardCopyOption;
//
//@Service
//public class ExcelService {
//
//    private static final String EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/SoA.xlsx";
//    private static final String RISK_EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/risques_final.xlsx";
//
//    // --- LECTURE SOA ---
//    public List<List<String>> readAll() throws IOException {
//        return readGeneric(EXCEL_PATH, 8);
//    }
//
//    // --- LECTURE RISQUES ---
//    public List<List<String>> readRisks() throws IOException {
//        File file = new File(RISK_EXCEL_PATH);
//        if (!file.exists()) {
//            try (XSSFWorkbook workbook = new XSSFWorkbook()) {
//                Sheet sheet = workbook.createSheet("Risques");
//                createFullHeaderRows(sheet);
//                try (FileOutputStream fos = new FileOutputStream(file)) {
//                    workbook.write(fos);
//                }
//            }
//        }
//        return readGeneric(RISK_EXCEL_PATH, 25);
//    }
//
//    // ---------------------------------------------------------------------
//    //  ÉCRITURE DES RISQUES DANS LE FICHIER EXCEL (STRUCTURE CORRECTE)
//    // ---------------------------------------------------------------------
//    public void writeRisks(List<Map<String, Object>> risks) throws IOException {
//        // Normaliser les catégories
//        risks = propagateCategories(risks);
//
//        File original = new File(RISK_EXCEL_PATH);
//        File tempFile = new File(original.getAbsolutePath() + ".tmp");
//
//        if (original.exists() && !original.canWrite()) {
//            throw new IOException("Le fichier Excel est verrouillé. Veuillez fermer Excel.");
//        }
//
//        // 1. Récupérer les 5 premières lignes d'en-tête du fichier original
//        List<Row> headerRows = new ArrayList<>();
//        XSSFWorkbook originalWorkbook = null;
//        if (original.exists()) {
//            try (FileInputStream fis = new FileInputStream(original)) {
//                originalWorkbook = new XSSFWorkbook(fis);
//                Sheet sheet = originalWorkbook.getSheetAt(0);
//                if (sheet == null) throw new IOException("Feuille 'Risques' introuvable.");
//                for (int i = 0; i <= 4; i++) {
//                    headerRows.add(sheet.getRow(i));
//                }
//            }
//        }
//
//        // 2. Créer un nouveau classeur
//        XSSFWorkbook newWorkbook = new XSSFWorkbook();
//        Sheet newSheet = newWorkbook.createSheet("Risques");
//
//        // 3. Copier les 5 premières lignes avec leurs styles et fusions
//        for (int i = 0; i < 5; i++) {
//            Row sourceRow = (i < headerRows.size()) ? headerRows.get(i) : null;
//            Row newRow = newSheet.createRow(i);
//            if (sourceRow != null) {
//                copyRow(sourceRow, newRow, newWorkbook);
//            } else {
//                for (int j = 0; j < 25; j++) newRow.createCell(j);
//            }
//        }
//
//        // Si le fichier n'existait pas, on crée les en-têtes complets
//        if (headerRows.isEmpty() || headerRows.stream().allMatch(Objects::isNull)) {
//            createFullHeaderRows(newSheet);
//        }
//
//        // 4. Regrouper les risques par catégorie
//        Map<String, List<Map<String, Object>>> risksByCategory = new LinkedHashMap<>();
//        for (Map<String, Object> risk : risks) {
//            String cat = (String) risk.get("categorie");
//            if (cat == null) cat = "";
//            risksByCategory.computeIfAbsent(cat, k -> new ArrayList<>()).add(risk);
//        }
//
//        // 5. Écrire les données à partir de la ligne 5
//        int rowNum = 5;
//        for (Map.Entry<String, List<Map<String, Object>>> entry : risksByCategory.entrySet()) {
//            String category = entry.getKey();
//            List<Map<String, Object>> catRisks = entry.getValue();
//
//            // Ligne de catégorie (si la catégorie n'est pas vide)
//            if (category != null && !category.trim().isEmpty()) {
//                Row catRow = newSheet.createRow(rowNum++);
//                catRow.createCell(0).setCellValue(category);
//                // les autres colonnes restent vides
//            }
//
//            // Lignes des risques
//            for (Map<String, Object> risk : catRisks) {
//                Row row = newSheet.createRow(rowNum++);
//                row.createCell(0).setCellValue("");  // colonne catégorie vide
//
//                setCellValue(row.createCell(1), (String) risk.get("menaces"));
//                setCellValue(row.createCell(2), (String) risk.get("origine"));
//                setCellValue(row.createCell(3), (String) risk.get("actifs"));
//                setCellValue(row.createCell(4), (String) risk.get("ref"));
//                setCellValue(row.createCell(5), (String) risk.get("proprio"));
//                setCellValue(row.createCell(6), (String) risk.get("scenario"));
//                setCellValue(row.createCell(7), (String) risk.get("vulner"));
//                setCellValue(row.createCell(8), getInt(risk.get("d")));
//                setCellValue(row.createCell(9), getInt(risk.get("i")));
//                setCellValue(row.createCell(10), getInt(risk.get("c")));
//                setCellValue(row.createCell(11), getInt(risk.get("impOrg")));
//                setCellValue(row.createCell(12), getInt(risk.get("impJur")));
//                setCellValue(row.createCell(13), getInt(risk.get("impImg")));
//                setCellValue(row.createCell(14), getInt(risk.get("impFin")));
//                setCellValue(row.createCell(15), getInt(risk.get("proba")));
//                setCellValue(row.createCell(16), getInt(risk.get("grav")));
//                setCellValue(row.createCell(17), getInt(risk.get("scoreRes")));
//                setCellValue(row.createCell(18), (String) risk.get("optionTrait"));
//                setCellValue(row.createCell(19), (String) risk.get("actions"));
//                setCellValue(row.createCell(20), getInt(risk.get("besoinC")));
//                setCellValue(row.createCell(21), getInt(risk.get("probC")));
//                setCellValue(row.createCell(22), getInt(risk.get("gravC")));
//                setCellValue(row.createCell(23), getInt(risk.get("scoreCible")));
//                setCellValue(row.createCell(24), (String) risk.get("optionApres"));
//            }
//        }
//
//        // 6. Sauvegarder dans un fichier temporaire
//        try (FileOutputStream fos = new FileOutputStream(tempFile)) {
//            newWorkbook.write(fos);
//            fos.flush();
//        } finally {
//            newWorkbook.close();
//            if (originalWorkbook != null) originalWorkbook.close();
//        }
//
//        // 7. Remplacer l'original par le temporaire
//        if (original.exists() && !original.delete()) {
//            throw new IOException("Impossible de supprimer l'ancien fichier (fermez Excel).");
//        }
//        if (!tempFile.renameTo(original)) {
//            throw new IOException("Échec du renommage du fichier temporaire.");
//        }
//
//        System.out.println("✅ Fichier Excel mis à jour : " + original.getAbsolutePath());
//    }
//
//    // ---------------------------------------------------------------------
//    //  MÉTHODES UTILITAIRES
//    // ---------------------------------------------------------------------
//    private List<Map<String, Object>> propagateCategories(List<Map<String, Object>> risks) {
//        List<Map<String, Object>> result = new ArrayList<>();
//        String lastValid = "";
//        for (Map<String, Object> risk : risks) {
//            String cat = (String) risk.get("categorie");
//            if (cat != null && !cat.trim().isEmpty()) {
//                lastValid = cat.trim();
//            }
//            Map<String, Object> copy = new LinkedHashMap<>(risk);
//            if (!lastValid.isEmpty()) {
//                copy.put("categorie", lastValid);
//            }
//            result.add(copy);
//        }
//        return result;
//    }
//
//    private void setCellValue(Cell cell, String value) {
//        cell.setCellValue(value != null ? value : "");
//    }
//
//    private void setCellValue(Cell cell, int value) {
//        cell.setCellValue(value);
//    }
//
//    private int getInt(Object val) {
//        if (val == null) return 0;
//        if (val instanceof Number) return ((Number) val).intValue();
//        try {
//            return Integer.parseInt(val.toString());
//        } catch (NumberFormatException e) {
//            return 0;
//        }
//    }
//
//    private void copyRow(Row sourceRow, Row targetRow, Workbook newWorkbook) {
//        for (int i = 0; i < sourceRow.getLastCellNum(); i++) {
//            Cell sourceCell = sourceRow.getCell(i);
//            if (sourceCell != null) {
//                Cell targetCell = targetRow.createCell(i);
//                copyCell(sourceCell, targetCell, newWorkbook);
//            }
//        }
//        // Copier les fusions de cellules
//        Sheet sourceSheet = sourceRow.getSheet();
//        Sheet targetSheet = targetRow.getSheet();
//        for (int i = 0; i < sourceSheet.getNumMergedRegions(); i++) {
//            CellRangeAddress region = sourceSheet.getMergedRegion(i);
//            if (region.getFirstRow() == sourceRow.getRowNum()) {
//                CellRangeAddress newRegion = new CellRangeAddress(
//                        targetRow.getRowNum(), targetRow.getRowNum(),
//                        region.getFirstColumn(), region.getLastColumn()
//                );
//                targetSheet.addMergedRegion(newRegion);
//            }
//        }
//    }
//
//    private void copyCell(Cell source, Cell target, Workbook newWorkbook) {
//        target.setCellType(source.getCellType());
//        switch (source.getCellType()) {
//            case STRING:
//                target.setCellValue(source.getStringCellValue());
//                break;
//            case NUMERIC:
//                target.setCellValue(source.getNumericCellValue());
//                break;
//            case BOOLEAN:
//                target.setCellValue(source.getBooleanCellValue());
//                break;
//            case FORMULA:
//                target.setCellFormula(source.getCellFormula());
//                break;
//            default:
//                target.setCellValue("");
//        }
//        CellStyle newStyle = newWorkbook.createCellStyle();
//        newStyle.cloneStyleFrom(source.getCellStyle());
//        target.setCellStyle(newStyle);
//    }
//
//    private void createFullHeaderRows(Sheet sheet) {
//        // Ligne 0 : titre
//        Row titleRow = sheet.createRow(0);
//        titleRow.createCell(0).setCellValue("Programme gestion des risques");
//        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 24));
//        // Ligne 1 : vide
//        sheet.createRow(1);
//        // Ligne 2 : "APPRECIATION DE RISQUE" et "TRAITEMENT DE RISQUE"
//        Row row2 = sheet.createRow(2);
//        row2.createCell(0).setCellValue("APPRECIATION DE RISQUE");
//        sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 17));
//        row2.createCell(18).setCellValue("TRAITEMENT DE RISQUE");
//        sheet.addMergedRegion(new CellRangeAddress(2, 2, 18, 24));
//        // Ligne 3 : en-têtes principaux
//        Row row3 = sheet.createRow(3);
//        String[] headers = {
//                "Menaces", "Origine", "Actifs concernés", "REF", "Propriétaire de risque",
//                "Scénarios de risque", "Vulnérabilités", "Mesures existantes", "Besoin de sécurité",
//                "", "", "Impact", "", "", "", "Probabilité", "Gravité", "Niveau de risque résiduel",
//                "Option de traitement du risque", "Actions de traitement", "Besoin de sécurité",
//                "Probabilité", "Gravité", "Niveau de risque cible", "Option de traitement du risque après"
//        };
//        for (int i = 0; i < headers.length; i++) {
//            row3.createCell(i).setCellValue(headers[i]);
//        }
//        // Ligne 4 : sous-en-têtes
//        Row row4 = sheet.createRow(4);
//        String[] subHeaders = {
//                "", "", "", "", "", "", "", "", "D", "I", "C", "Organisationnel",
//                "Juridique et réglementaire", "Image", "Financier", "", "", "", "", "", "", "", "", "", ""
//        };
//        for (int i = 0; i < subHeaders.length; i++) {
//            row4.createCell(i).setCellValue(subHeaders[i]);
//        }
//    }
//
//    // ---------------------------------------------------------------------
//    //  LECTURE GÉNÉRIQUE
//    // ---------------------------------------------------------------------
//    private List<List<String>> readGeneric(String filePath, int maxCols) throws IOException {
//        List<List<String>> result = new ArrayList<>();
//        try (FileInputStream fis = new FileInputStream(filePath);
//             Workbook workbook = new XSSFWorkbook(fis)) {
//            Sheet sheet = workbook.getSheetAt(0);
//            for (Row row : sheet) {
//                List<String> rowData = new ArrayList<>();
//                for (int cn = 0; cn < maxCols; cn++) {
//                    Cell cell = row.getCell(cn, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
//                    if (cell == null) {
//                        rowData.add("");
//                    } else {
//                        switch (cell.getCellType()) {
//                            case STRING:
//                                rowData.add(cell.getStringCellValue());
//                                break;
//                            case NUMERIC:
//                                rowData.add(String.valueOf((int) cell.getNumericCellValue()));
//                                break;
//                            default:
//                                rowData.add("");
//                        }
//                    }
//                }
//                result.add(rowData);
//            }
//        }
//        return result;
//    }
//
//    // --- SAUVEGARDE SOA ---
//    public void saveAll(List<List<String>> data) throws IOException {
//        saveGeneric(EXCEL_PATH, data, 8, "SoA");
//    }
//
//    // --- SAUVEGARDE RISQUES (si besoin) ---
//    public void saveRisks(List<List<String>> data) throws IOException {
//        saveGeneric(RISK_EXCEL_PATH, data, 25, "Risques");
//    }
//
//    private void saveGeneric(String path, List<List<String>> data, int colLimit, String sheetName) throws IOException {
//        try (Workbook workbook = new XSSFWorkbook()) {
//            Sheet sheet = workbook.createSheet(sheetName);
//            for (int i = 0; i < data.size(); i++) {
//                Row row = sheet.createRow(i);
//                List<String> rowData = data.get(i);
//                for (int j = 0; j < Math.min(rowData.size(), colLimit); j++) {
//                    row.createCell(j).setCellValue(rowData.get(j));
//                }
//            }
//            try (FileOutputStream fos = new FileOutputStream(path)) {
//                workbook.write(fos);
//            }
//        }
//    }
//}




//v1

/*
package com.example.spring_ad_auth.service;

import org.apache.poi.ss.usermodel.*;
        import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import java.io.*;
        import java.util.ArrayList;
import java.util.List;

@Service
public class ExcelService {

    // Utilisez le chemin absolu que vous avez donné
    private static final String EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/SoA.xlsx";

    private static final String RISK_EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/risques_final.xlsx";


    public List<List<String>> readAll() throws IOException {
        List<List<String>> sheetData = new ArrayList<>();
        File file = new File(EXCEL_PATH);
        if (!file.exists()) return sheetData;

        try (FileInputStream fis = new FileInputStream(file);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(0);
            DataFormatter formatter = new DataFormatter();

            for (int i = 0; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                List<String> rowData = new ArrayList<>();
                // ON LIT STRICTEMENT 8 COLONNES (0 à 7)
                for (int j = 0; j < 8; j++) {
                    Cell cell = row.getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                    rowData.add(formatter.formatCellValue(cell));
                }
                sheetData.add(rowData);
            }
        }
        return sheetData;
    }

    
    public void saveAll(List<List<String>> data) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("SoA");
            for (int i = 0; i < data.size(); i++) {
                Row row = sheet.createRow(i);
                List<String> rowData = data.get(i);
                // On limite strictement à 8 colonnes pour le fichier physique
                for (int j = 0; j < Math.min(rowData.size(), 8); j++) {
                    row.createCell(j).setCellValue(rowData.get(j));
                }
            }
            try (FileOutputStream fos = new FileOutputStream(EXCEL_PATH)) {
                workbook.write(fos);
            }
        }
    }



    public List<List<String>> readRisks() throws IOException {
        List<List<String>> sheetData = new ArrayList<>();
        File file = new File(RISK_EXCEL_PATH);
        if (!file.exists()) return sheetData;

        try (FileInputStream fis = new FileInputStream(file);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(0);
            DataFormatter formatter = new DataFormatter();

            for (int i = 0; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                List<String> rowData = new ArrayList<>();
                // On lit les 25 colonnes selon votre structure CSV/Excel
                for (int j = 0; j < 25; j++) { // Force la lecture de 25 colonnes même si vides
                    Cell cell = row.getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                    rowData.add(formatter.formatCellValue(cell));
                }

                sheetData.add(rowData);
            }
        }
        return sheetData;
    }
}*//*


package com.example.spring_ad_auth.service;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.io.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@Service
public class ExcelService {

 static final String EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/SoA.xlsx";
//    private static final String RISK_EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/risques_final.xlsx";

    private static final String RISK_EXCEL_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/risques_final.xlsx";

    // --- LECTURE SOA ---
    public List<List<String>> readAll() throws IOException {
        return readGeneric(EXCEL_PATH, 8);
    }

    // --- LECTURE RISQUES ---
    public List<List<String>> readRisks() throws IOException {
        File file = new File(RISK_EXCEL_PATH);
        if (!file.exists()) {
            // Créer un fichier vide avec les en‑têtes
            try (XSSFWorkbook workbook = new XSSFWorkbook()) {
                Sheet sheet = workbook.createSheet("Risques");
                createHeaderRows(sheet); // on suppose que cette méthode existe
                try (FileOutputStream fos = new FileOutputStream(file)) {
                    workbook.write(fos);
                }
            }
        }
        return readGeneric(RISK_EXCEL_PATH, 25);
    }

    // ---------------------------------------------------------------------
    //  ÉCRITURE DES RISQUES DANS LE FICHIER EXCEL
    // ---------------------------------------------------------------------


    public void writeRisks(List<Map<String, Object>> risks) throws IOException {
        // Normaliser les catégories
        risks = propagateCategories(risks);

        File original = new File(RISK_EXCEL_PATH);
        File tempFile = new File(original.getAbsolutePath() + ".tmp");

        // Vérifier si le fichier original existe et s'il est accessible en écriture
        if (original.exists() && !original.canWrite()) {
            throw new IOException("Le fichier Excel est verrouillé (probablement ouvert dans Excel). Veuillez le fermer et réessayer.");
        }

        // Ouvrir le classeur existant ou en créer un nouveau
        XSSFWorkbook workbook;
        if (original.exists()) {
            try (FileInputStream fis = new FileInputStream(original)) {
                workbook = new XSSFWorkbook(fis);
            }
        } else {
            workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Risques");
            createFullHeaderRows(sheet);
        }

        Sheet sheet = workbook.getSheet("Risques");
        if (sheet == null) {
            sheet = workbook.createSheet("Risques");
            createFullHeaderRows(sheet);
        }

        // Supprimer les anciennes lignes de données (à partir de la ligne 5)
        int lastRow = sheet.getLastRowNum();
        for (int i = lastRow; i >= 5; i--) {
            Row row = sheet.getRow(i);
            if (row != null) sheet.removeRow(row);
        }

        // Récupérer les styles des en-têtes (lignes 3 et 4)
        Row headerRow3 = sheet.getRow(3);
        Row headerRow4 = sheet.getRow(4);
        CellStyle[] headerStyles = new CellStyle[25];
        if (headerRow3 != null) {
            for (int i = 0; i < 25; i++) {
                Cell cell = headerRow3.getCell(i);
                if (cell != null) headerStyles[i] = cell.getCellStyle();
            }
        } else {
            headerStyles = null;
        }

        // Écrire les données
        int rowNum = 5;
        String previousCategory = null;
        for (Map<String, Object> risk : risks) {
            Row row = sheet.createRow(rowNum++);
            String currentCategory = (String) risk.get("categorie");
            String catToCompare = (currentCategory == null) ? "" : currentCategory;
            String prevCat = (previousCategory == null) ? "" : previousCategory;

            Cell catCell = row.createCell(0);
            if (!catToCompare.equals(prevCat)) {
                catCell.setCellValue(catToCompare);
            } else {
                catCell.setCellValue("");
            }
            if (headerStyles != null && headerStyles[0] != null) catCell.setCellStyle(headerStyles[0]);
            previousCategory = catToCompare;

            // Autres colonnes
            setCellValue(row.createCell(1), (String) risk.get("menaces"), headerStyles != null ? headerStyles[1] : null);
            setCellValue(row.createCell(2), (String) risk.get("origine"), headerStyles != null ? headerStyles[2] : null);
            setCellValue(row.createCell(3), (String) risk.get("actifs"), headerStyles != null ? headerStyles[3] : null);
            setCellValue(row.createCell(4), (String) risk.get("ref"), headerStyles != null ? headerStyles[4] : null);
            setCellValue(row.createCell(5), (String) risk.get("proprio"), headerStyles != null ? headerStyles[5] : null);
            setCellValue(row.createCell(6), (String) risk.get("scenario"), headerStyles != null ? headerStyles[6] : null);
            setCellValue(row.createCell(7), (String) risk.get("vulner"), headerStyles != null ? headerStyles[7] : null);
            setCellValue(row.createCell(8), getInt(risk.get("d")), headerStyles != null ? headerStyles[8] : null);
            setCellValue(row.createCell(9), getInt(risk.get("i")), headerStyles != null ? headerStyles[9] : null);
            setCellValue(row.createCell(10), getInt(risk.get("c")), headerStyles != null ? headerStyles[10] : null);
            setCellValue(row.createCell(11), getInt(risk.get("impOrg")), headerStyles != null ? headerStyles[11] : null);
            setCellValue(row.createCell(12), getInt(risk.get("impJur")), headerStyles != null ? headerStyles[12] : null);
            setCellValue(row.createCell(13), getInt(risk.get("impImg")), headerStyles != null ? headerStyles[13] : null);
            setCellValue(row.createCell(14), getInt(risk.get("impFin")), headerStyles != null ? headerStyles[14] : null);
            setCellValue(row.createCell(15), getInt(risk.get("proba")), headerStyles != null ? headerStyles[15] : null);
            setCellValue(row.createCell(16), getInt(risk.get("grav")), headerStyles != null ? headerStyles[16] : null);
            setCellValue(row.createCell(17), getInt(risk.get("scoreRes")), headerStyles != null ? headerStyles[17] : null);
            setCellValue(row.createCell(18), (String) risk.get("optionTrait"), headerStyles != null ? headerStyles[18] : null);
            setCellValue(row.createCell(19), (String) risk.get("actions"), headerStyles != null ? headerStyles[19] : null);
            setCellValue(row.createCell(20), getInt(risk.get("besoinC")), headerStyles != null ? headerStyles[20] : null);
            setCellValue(row.createCell(21), getInt(risk.get("probC")), headerStyles != null ? headerStyles[21] : null);
            setCellValue(row.createCell(22), getInt(risk.get("gravC")), headerStyles != null ? headerStyles[22] : null);
            setCellValue(row.createCell(23), getInt(risk.get("scoreCible")), headerStyles != null ? headerStyles[23] : null);
            setCellValue(row.createCell(24), (String) risk.get("optionApres"), headerStyles != null ? headerStyles[24] : null);
        }

        // Écrire dans un fichier temporaire
        try (FileOutputStream fos = new FileOutputStream(tempFile)) {
            workbook.write(fos);
            fos.flush();
        }
        workbook.close();

        // Tenter de remplacer l'original
        try {
            // Essayer de supprimer l'original s'il existe
            if (original.exists()) {
                if (!original.delete()) {
                    throw new IOException("Impossible de supprimer l'ancien fichier (peut-être verrouillé)");
                }
            }
            // Renommer le temporaire
            if (!tempFile.renameTo(original)) {
                throw new IOException("Échec du renommage du fichier temporaire");
            }
            System.out.println("✅ Fichier Excel mis à jour : " + original.getAbsolutePath());
            System.out.println("Nouvelle taille : " + original.length());
        } catch (IOException e) {
            // En cas d'échec, on nettoie et on relance l'exception
            if (tempFile.exists()) tempFile.delete();
            throw e;
        }
    }

    private void createFullHeaderRows(Sheet sheet) {
        // Ligne 0 : Titre principal
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("Programme gestion des risques");
        // Fusionner les 25 colonnes pour le titre
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 24));

        // Ligne 1 : vide
        sheet.createRow(1);

        // Ligne 2 : "APPRECIATION DE RISQUE" et "TRAITEMENT DE RISQUE"
        Row headerRow2 = sheet.createRow(2);
        Cell appreciationCell = headerRow2.createCell(0);
        appreciationCell.setCellValue("APPRECIATION DE RISQUE");
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 17));
        Cell traitementCell = headerRow2.createCell(18);
        traitementCell.setCellValue("TRAITEMENT DE RISQUE");
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 18, 24));

        // Ligne 3 : en-têtes principaux
        Row headerRow3 = sheet.createRow(3);
        String[] headersMain = {
                "Menaces", "Origine", "Actifs concernés", "REF", "Propriétaire de risque", "Scénarios de risque",
                "Vulnérabilités", "Mesures existantes", "Besoin de sécurité", "", "", "Impact", "", "", "",
                "Probabilité", "Gravité", "Niveau de risque résiduel", "Option de traitement du risque",
                "Actions de traitement", "Besoin de sécurité", "Probabilité", "Gravité", "Niveau de risque cible",
                "Option de traitement du risque après"
        };
        for (int i = 0; i < headersMain.length; i++) {
            headerRow3.createCell(i).setCellValue(headersMain[i]);
        }

        // Ligne 4 : sous-en-têtes
        Row headerRow4 = sheet.createRow(4);
        String[] headersSub = {
                "", "", "", "", "", "", "", "", "D", "I", "C", "Organisationnel", "Juridique et réglementaire",
                "Image", "Financier", "", "", "", "", "", "", "", "", "", ""
        };
        for (int i = 0; i < headersSub.length; i++) {
            headerRow4.createCell(i).setCellValue(headersSub[i]);
        }

        // Appliquer un style basique (bordures) aux cellules d'en-tête (optionnel)
        CellStyle borderStyle = sheet.getWorkbook().createCellStyle();
        borderStyle.setBorderTop(BorderStyle.THIN);
        borderStyle.setBorderBottom(BorderStyle.THIN);
        borderStyle.setBorderLeft(BorderStyle.THIN);
        borderStyle.setBorderRight(BorderStyle.THIN);
        for (int i = 0; i <= 24; i++) {
            Cell cell3 = headerRow3.getCell(i);
            if (cell3 != null) cell3.setCellStyle(borderStyle);
            Cell cell4 = headerRow4.getCell(i);
            if (cell4 != null) cell4.setCellStyle(borderStyle);
        }
    }
    // ---------------------------------------------------------------------
    //  MÉTHODES UTILITAIRES
    // ---------------------------------------------------------------------
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

    private void setCellValue(Cell cell, String value, CellStyle style) {
        if (value != null) {
            cell.setCellValue(value);
        } else {
            cell.setCellValue("");
        }
        if (style != null) cell.setCellStyle(style);
    }

    private void setCellValue(Cell cell, int value, CellStyle style) {
        cell.setCellValue(value);
        if (style != null) cell.setCellStyle(style);
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

    private void createHeaderRows(Sheet sheet) {
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("Programme de gestion des risques");

        Row headerRow = sheet.createRow(1);
        String[] headers = {
                "Catégorie", "Menaces", "Origine", "Actifs", "Réf.", "Proprio", "Scénario", "Vulnérabilité",
                "D", "I", "C", "Imp.Org", "Imp.Jur", "Imp.Img", "Imp.Fin", "Prob.", "Grav.", "Score", "Option", "Actions",
                "Bes.C", "Prob.C", "Grav.C", "Score C", "Fin"
        };
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            CellStyle style = sheet.getWorkbook().createCellStyle();
            style.setBorderTop(BorderStyle.THIN);
            style.setBorderBottom(BorderStyle.THIN);
            style.setBorderLeft(BorderStyle.THIN);
            style.setBorderRight(BorderStyle.THIN);
            cell.setCellStyle(style);
        }
    }

    // ---------------------------------------------------------------------
    //  LECTURE GÉNÉRIQUE (inchangée)
    // ---------------------------------------------------------------------
    private List<List<String>> readGeneric(String filePath, int maxCols) throws IOException {
        List<List<String>> result = new ArrayList<>();
        try (FileInputStream fis = new FileInputStream(filePath);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                List<String> rowData = new ArrayList<>();
                for (int cn = 0; cn < maxCols; cn++) {
                    Cell cell = row.getCell(cn, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
                    if (cell == null) {
                        rowData.add("");
                    } else {
                        switch (cell.getCellType()) {
                            case STRING:
                                rowData.add(cell.getStringCellValue());
                                break;
                            case NUMERIC:
                                rowData.add(String.valueOf((int) cell.getNumericCellValue()));
                                break;
                            default:
                                rowData.add("");
                        }
                    }
                }
                result.add(rowData);
            }
        }
        return result;
    }


    private void setCellValueWithStyle(Cell cell, String value, CellStyle style) {
        if (value != null) {
            cell.setCellValue(value);
        } else {
            cell.setCellValue("");
        }
        if (style != null) {
            cell.setCellStyle(style);
        }
    }

    private void setCellValueWithStyle(Cell cell, int value, CellStyle style) {
        cell.setCellValue(value);
        if (style != null) {
            cell.setCellStyle(style);
        }
    }

    private void createHeaderRow(Sheet sheet) {
        String[] headers = {
                "Catégorie", "Menaces", "Origine", "Actifs", "Réf.", "Proprio", "Scénario", "Vulnérabilité",
                "D", "I", "C", "Imp.Org", "Imp.Jur", "Imp.Img", "Imp.Fin", "Prob.", "Grav.", "Score", "Option", "Actions",
                "Bes.C", "Prob.C", "Grav.C", "Score C", "Fin"
        };
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            CellStyle style = sheet.getWorkbook().createCellStyle();
            style.setBorderTop(BorderStyle.THIN);
            style.setBorderBottom(BorderStyle.THIN);
            style.setBorderLeft(BorderStyle.THIN);
            style.setBorderRight(BorderStyle.THIN);
            cell.setCellStyle(style);
        }
    }


    // --- SAUVEGARDE SOA ---
    public void saveAll(List<List<String>> data) throws IOException {
        saveGeneric(EXCEL_PATH, data, 8, "SoA");
    }

    // --- SAUVEGARDE RISQUES (Ajoutée) ---
    public void saveRisks(List<List<String>> data) throws IOException {
        saveGeneric(RISK_EXCEL_PATH, data, 25, "Risques");
    }

    // --- MÉTHODE DE SAUVEGARDE GÉNÉRIQUE ---
    private void saveGeneric(String path, List<List<String>> data, int colLimit, String sheetName) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet(sheetName);
            for (int i = 0; i < data.size(); i++) {
                Row row = sheet.createRow(i);
                List<String> rowData = data.get(i);
                for (int j = 0; j < Math.min(rowData.size(), colLimit); j++) {
                    row.createCell(j).setCellValue(rowData.get(j));
                }
            }
            try (FileOutputStream fos = new FileOutputStream(path)) {
                workbook.write(fos);
            }
        }
    }
}*/
