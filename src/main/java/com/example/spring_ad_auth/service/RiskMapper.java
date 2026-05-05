package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.RegistreRisque;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class RiskMapper {

    @Autowired
    private RiskCalculator calculator;


    public RegistreRisque mapRowToEntity(List<String> row, String categorie, String menace, String origine, String proprio) {
        RegistreRisque e = new RegistreRisque();

        // Valeurs propagées (Fusionnées dans Excel)
        e.setCategorie(categorie);
        e.setMenaces(menace);
        e.setOrigine(origine);
//        e.setProprietaireRisque(proprio);

        // Colonnes Standard
        e.setActifsConcernes(safeGet(row, 2));
        e.setRef(safeGet(row, 3));
        e.setScenariosRisque(safeGet(row, 5));
        e.setVulnerabilites(safeGet(row, 6));
        e.setMesuresExistantes(safeGet(row, 7));

        // Besoins de Sécurité (CID)
        e.setValD(parse(safeGet(row, 8)));
        e.setValI(parse(safeGet(row, 9)));
        e.setValC(parse(safeGet(row, 10)));
        int maxCID = Math.max(e.getValD(), Math.max(e.getValI(), e.getValC()));
        e.setBesoinSecuriteInitial(maxCID);

        // Impacts (Indices 11 à 14)
        e.setImpOrg(parse(safeGet(row, 11)));
        e.setImpJur(parse(safeGet(row, 12)));
        e.setImpImg(parse(safeGet(row, 13)));
        e.setImpFin(parse(safeGet(row, 14)));

        // Probabilité et Gravité
        e.setProbabiliteInitial(parse(safeGet(row, 15)));
        e.setGraviteInitial(parse(safeGet(row, 16)));

        // Calcul via RiskCalculator
        e.setNiveauRisqueInitial(calculator.calculateScore(maxCID, e.getProbabiliteInitial(), e.getGraviteInitial()));

        // Traitement
        e.setOptionTraitement(safeGet(row, 18));
        e.setActionsTraitement(safeGet(row, 19));

        // Cible
        e.setBesoinSecuriteCible(parse(safeGet(row, 20)));
        e.setProbabiliteCible(parse(safeGet(row, 21)));
        e.setGraviteCible(parse(safeGet(row, 22)));
        e.setNiveauRisqueCible(calculator.calculateScore(e.getBesoinSecuriteCible(), e.getProbabiliteCible(), e.getGraviteCible()));

        e.setOptionTraitementApres(safeGet(row, 24));

        return e;
    }


    // --- HELPER METHODS POUR ÉVITER LES NULLS ET LES ERREURS DE TYPE ---
    private String safeGet(List<String> row, int idx) {
        return (idx < row.size() && row.get(idx) != null) ? row.get(idx).trim() : "";
    }


    private int parseSafeInt(String value) {
        if (value == null || value.isEmpty()) return 1; // Valeur par défaut
        try {
            // Gérer les cas comme "1.0" venant d'Excel
            return (int) Double.parseDouble(value.replaceAll("[^0-9.]", ""));
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    // Dans RiskMapper.java, ajoute cette méthode :
    public List<String> mapEntityToRow(RegistreRisque entity) {
        List<String> row = new ArrayList<>();
        // On suit EXACTEMENT l'ordre des colonnes de ton Excel (0 à 24)
        row.add(entity.getMenaces());        // 0
        row.add(entity.getOrigine());        // 1
        row.add(entity.getActifsConcernes());// 2
        row.add(entity.getRef());            // 3
//        row.add(entity.getProprietaireRisque()); // 4
        row.add(entity.getScenariosRisque());// 5
        row.add(entity.getVulnerabilites()); // 6
        row.add(entity.getMesuresExistantes()); // 7
        row.add(String.valueOf(entity.getValD())); // 8
        row.add(String.valueOf(entity.getValI())); // 9
        row.add(String.valueOf(entity.getValC())); // 10
        row.add(String.valueOf(entity.getImpOrg())); // 11
        row.add(String.valueOf(entity.getImpJur())); // 12
        row.add(String.valueOf(entity.getImpImg())); // 13
        row.add(String.valueOf(entity.getImpFin())); // 14
        row.add(String.valueOf(entity.getProbabiliteInitial())); // 15
        row.add(String.valueOf(entity.getGraviteInitial()));    // 16
        row.add(String.valueOf(entity.getNiveauRisqueInitial())); // 17
        row.add(entity.getOptionTraitement()); // 18
        row.add(entity.getActionsTraitement()); // 19
        row.add(String.valueOf(entity.getBesoinSecuriteCible())); // 20
        row.add(String.valueOf(entity.getProbabiliteCible()));     // 21
        row.add(String.valueOf(entity.getGraviteCible()));        // 22
        row.add(String.valueOf(entity.getNiveauRisqueCible()));   // 23
        row.add(entity.getOptionTraitementApres()); // 24

        return row;
    }



    // Dans RiskMapper.java, ajoute ces deux méthodes :

    /**
     * Convertit une entité de la BD vers une Map pour le frontend (Handsontable)
     */


    // Convertit pour Handsontable (JS)
    public Map<String, Object> mapEntityToMap(RegistreRisque e) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("categorie", e.getCategorie());
        map.put("menaces", e.getMenaces());
        map.put("origine", e.getOrigine());
        map.put("actifs", e.getActifsConcernes());
        map.put("ref", e.getRef());
//        map.put("proprio", e.getProprietaireRisque());
        map.put("scenario", e.getScenariosRisque());
        map.put("vulner", e.getVulnerabilites());
        map.put("mesures", e.getMesuresExistantes());
        map.put("d", e.getValD());
        map.put("i", e.getValI());
        map.put("c", e.getValC());
        map.put("impOrg", e.getImpOrg());
        map.put("impJur", e.getImpJur());
        map.put("impImg", e.getImpImg());
        map.put("impFin", e.getImpFin());
        map.put("proba", e.getProbabiliteInitial());
        map.put("grav", e.getGraviteInitial());
        map.put("scoreRes", e.getNiveauRisqueInitial());
        map.put("optionTrait", e.getOptionTraitement());
        map.put("actions", e.getActionsTraitement());
        map.put("besoinC", e.getBesoinSecuriteCible());
        map.put("probC", e.getProbabiliteCible());
        map.put("gravC", e.getGraviteCible());
        map.put("scoreCible", e.getNiveauRisqueCible());
        map.put("optionApres", e.getOptionTraitementApres());
        return map;
    }


    /**
     * Convertit une Map du frontend (JSON) vers une entité JPA
     */
    public RegistreRisque mapMapToEntity(Map<String, Object> map) {
        RegistreRisque e = new RegistreRisque();
        e.setCategorie((String) map.get("categorie"));
        e.setMenaces((String) map.get("menaces"));
        e.setOrigine((String) map.get("origine"));
        e.setActifsConcernes((String) map.get("actifs"));
        e.setRef((String) map.get("ref"));
//        e.setProprietaireRisque((String) map.get("proprio"));
        e.setScenariosRisque((String) map.get("scenario"));
        e.setVulnerabilites((String) map.get("vulner"));
        e.setMesuresExistantes((String) map.get("mesures"));

        e.setValD(parse(map.get("d")));
        e.setValI(parse(map.get("i")));
        e.setValC(parse(map.get("c")));
        e.setImpOrg(parse(map.get("impOrg")));
        e.setImpJur(parse(map.get("impJur")));
        e.setImpImg(parse(map.get("impImg")));
        e.setImpFin(parse(map.get("impFin")));
        e.setProbabiliteInitial(parse(map.get("proba")));
        e.setGraviteInitial(parse(map.get("grav")));

        int maxCID = Math.max(e.getValD(), Math.max(e.getValI(), e.getValC()));
        e.setBesoinSecuriteInitial(maxCID);
        e.setNiveauRisqueInitial(calculator.calculateScore(maxCID, e.getProbabiliteInitial(), e.getGraviteInitial()));

        e.setOptionTraitement((String) map.get("optionTrait"));
        e.setActionsTraitement((String) map.get("actions"));
        e.setBesoinSecuriteCible(parse(map.get("besoinC")));
        e.setProbabiliteCible(parse(map.get("probC")));
        e.setGraviteCible(parse(map.get("gravC")));
        e.setNiveauRisqueCible(calculator.calculateScore(e.getBesoinSecuriteCible(), e.getProbabiliteCible(), e.getGraviteCible()));
        e.setOptionTraitementApres((String) map.get("optionApres"));

        return e;
    }

    private int parse(Object val) {
        if (val == null) return 1; // Valeur par défaut

        String strVal = val.toString().trim();
        if (strVal.isEmpty()) return 1;

        try {
            // On utilise Double.parseDouble pour supporter les formats "1" et "1.0"
            // On enlève tout caractère non numérique sauf le point
            return (int) Double.parseDouble(strVal.replaceAll("[^0-9.]", ""));
        } catch (Exception e) {
            System.err.println("Erreur de parsing pour la valeur : " + strVal);
            return 1; // Retourne 1 en cas d'erreur pour ne pas casser le calcul
        }
    }


    // Helper pour convertir la Map JSON reçue en List<String> indexée
    private List<String> convertMapToList(Map<String, Object> map) {
        String[] array = new String[25];
        array[0] = String.valueOf(map.getOrDefault("menaces", ""));
        array[1] = String.valueOf(map.getOrDefault("origine", ""));
        array[2] = String.valueOf(map.getOrDefault("actifs", ""));
        array[3] = String.valueOf(map.getOrDefault("ref", ""));
        array[4] = String.valueOf(map.getOrDefault("proprio", ""));
        array[5] = String.valueOf(map.getOrDefault("scenario", ""));
        array[6] = String.valueOf(map.getOrDefault("vulner", ""));
        array[7] = String.valueOf(map.getOrDefault("mesures", ""));
        array[8] = String.valueOf(map.getOrDefault("d", "1"));
        array[9] = String.valueOf(map.getOrDefault("i", "1"));
        array[10] = String.valueOf(map.getOrDefault("c", "1"));
        array[11] = String.valueOf(map.getOrDefault("impOrg", "1"));
        array[12] = String.valueOf(map.getOrDefault("impJur", "1"));
        array[13] = String.valueOf(map.getOrDefault("impImg", "1"));
        array[14] = String.valueOf(map.getOrDefault("impFin", "1"));
        array[15] = String.valueOf(map.getOrDefault("proba", "1"));
        array[16] = String.valueOf(map.getOrDefault("grav", "1"));
        array[18] = String.valueOf(map.getOrDefault("optionTrait", ""));
        array[19] = String.valueOf(map.getOrDefault("actions", ""));
        array[20] = String.valueOf(map.getOrDefault("besoinC", "1"));
        array[21] = String.valueOf(map.getOrDefault("probC", "1"));
        array[22] = String.valueOf(map.getOrDefault("gravC", "1"));
        array[24] = String.valueOf(map.getOrDefault("optionApres", ""));
        return Arrays.asList(array);
    }
}