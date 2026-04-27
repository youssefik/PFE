package com.example.spring_ad_auth.mapper;


import com.example.spring_ad_auth.model.ActionAmelioration;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Component
public class ImprovementMapper {

    // INDICES RÉELS DU FICHIER EXCEL (POI lit tout, même le masqué)
    private static final int IDX_NUMERO = 0;      // Col A
    private static final int IDX_ACTION = 1;      // Col B
    private static final int IDX_DATE_BESOIN = 4; // Col E
    private static final int IDX_RESPONSABLE = 6; // Col G
    private static final int IDX_ANALYSE = 8;     // Col I
    private static final int IDX_STATUT = 9;      // Col J
    private static final int IDX_CLOTURE = 10;    // Col K
    private static final int IDX_EFFICACITE = 11; // Col L

    public ActionAmelioration mapToEntity(List<String> row, String lastNum, String lastDate) {
        ActionAmelioration a = new ActionAmelioration();

        // Propagation du numéro (Col A)
        String numero = getSafe(row, IDX_NUMERO);
        a.setNumero(numero.isEmpty() ? lastNum : numero);

        // Action (Col B)
        a.setActionCorrective(getSafe(row, IDX_ACTION));

        // Date Besoin (Col E)
        String dateVal = getSafe(row, IDX_DATE_BESOIN);
        a.setDateBesoin(dateVal.isEmpty() ? lastDate : dateVal);

        // Responsable (Col G)
        a.setResponsable(getSafe(row, IDX_RESPONSABLE));

        // Analyse Cause (Col I)
        a.setAnalyseCause(getSafe(row, IDX_ANALYSE));

        // Statut (Col J)
        String statutExcel = getSafe(row, IDX_STATUT); // Col J
        a.setStatut(statutExcel.isEmpty() ? "EN_COURS" : statutExcel);


//        a.setStatut(getSafe(row, IDX_STATUT));

        // Date Clôture (Col K)
        a.setDateCloture(getSafe(row, IDX_CLOTURE));

        // Efficacité (Col L)
        a.setEfficacite(getSafe(row, IDX_EFFICACITE));

        return a;
    }

    private String getSafe(List<String> row, int i) {
        if (i >= row.size() || row.get(i) == null) return "";
        return row.get(i).trim();
    }

    // Utilisé pour l'affichage JSON Handsontable
    public Map<String, Object> mapToMap(ActionAmelioration a) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("numero", a.getNumero());
        map.put("action", a.getActionCorrective());
        map.put("dateBesoin", a.getDateBesoin());
        map.put("responsable", a.getResponsable());
        map.put("analyseCause", a.getAnalyseCause());
        map.put("statut", a.getStatut());
        map.put("dateCloture", a.getDateCloture());
        map.put("efficacite", a.getEfficacite());
        return map;
    }
}

/*@Component
public class ImprovementMapper {

    public ActionAmelioration mapToEntity(List<String> row, String lastDateEnregistrement) {
        ActionAmelioration a = new ActionAmelioration();

        // Index 0: Numéro (#001)
        a.setNumero(getSafe(row, 0));

        // Index 1: Action corrective
        a.setActionCorrective(getSafe(row, 1));

        // Index 2: Date d'enregistrement (On utilise la mémoire si la cellule est vide)
        String rowDate = getSafe(row, 2);
        a.setDateBesoin(!rowDate.isEmpty() ? rowDate : lastDateEnregistrement);

        // Index 3: Responsable
        a.setResponsable(getSafe(row, 3));

        // Index 4: Analyse de cause
        a.setAnalyseCause(getSafe(row, 4));

        // Index 5: Statut (OK/NOK)
        a.setStatut(getSafe(row, 5));

        // Index 6: Date de clôture
        a.setDateCloture(getSafe(row, 6));

        // Index 7: Efficacité
        a.setEfficacite(getSafe(row, 7));

        return a;
    }

    private String getSafe(List<String> row, int i) {
        if (i >= row.size() || row.get(i) == null) return "";
        String val = row.get(i).trim();
        // Correction pour les nombres Excel (.0)
        if (val.endsWith(".0")) val = val.substring(0, val.length() - 2);
        return val;
    }

    // Utilisé pour renvoyer le JSON au Handsontable
    public Map<String, Object> mapToMap(ActionAmelioration a) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("numero", a.getNumero());
        map.put("action", a.getActionCorrective());
        map.put("dateBesoin", a.getDateBesoin());
        map.put("responsable", a.getResponsable());
        map.put("analyseCause", a.getAnalyseCause());
        map.put("statut", a.getStatut());
        map.put("dateCloture", a.getDateCloture());
        map.put("efficacite", a.getEfficacite());
        return map;
    }
}*/

/*
@Component
public class ImprovementMapper {

    public ActionAmelioration mapToEntity(List<String> row) {
        ActionAmelioration a = new ActionAmelioration();
        a.setNumero(getSafe(row, 0));
        a.setActionCorrective(getSafe(row, 1));
        a.setDateBesoin(getSafe(row, 2));
        a.setResponsable(getSafe(row, 3));
        a.setAnalyseCause(getSafe(row, 4));
        a.setStatut(getSafe(row, 5));
        a.setDateCloture(getSafe(row, 6));
        a.setEfficacite(getSafe(row, 7));
        return a;
    }

    public Map<String, Object> mapToMap(ActionAmelioration a) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("numero", a.getNumero());
        map.put("action", a.getActionCorrective());
        map.put("dateBesoin", a.getDateBesoin());
        map.put("responsable", a.getResponsable());
        map.put("analyseCause", a.getAnalyseCause());
        map.put("statut", a.getStatut());
        map.put("dateCloture", a.getDateCloture());
        map.put("efficacite", a.getEfficacite());
        return map;
    }

    private String getSafe(List<String> row, int i) {
        return (i < row.size() && row.get(i) != null) ? row.get(i).trim() : "";
    }
}*/
