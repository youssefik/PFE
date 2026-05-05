package com.example.spring_ad_auth.mapper;

import com.example.spring_ad_auth.model.Actif;
import com.example.spring_ad_auth.model.Perimetre;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class ActifMapper {

    public Actif mapRowToEntity(List<String> row, String lastActivite, String lastProcessus, Perimetre p) {
        Actif a = new Actif();
        a.setPerimetre(p);

        // Gestion des colonnes fusionnées A et B
        String cell0 = getSafe(row, 0);
        String cell1 = getSafe(row, 1);
        a.setActivite(!cell0.isEmpty() ? cell0 : lastActivite);
        a.setProcessus(!cell1.isEmpty() ? cell1 : lastProcessus);

        // Données de base
        a.setNom(getSafe(row, 2)); // Actif info

        // DIC (Besoins)
        a.setDisponibilite(parseSafeInt(getSafe(row, 3)));
        a.setIntegrite(parseSafeInt(getSafe(row, 4)));
        a.setConfidentialite(parseSafeInt(getSafe(row, 5)));

        // Supports
        a.setLogicielSupport(getSafe(row, 6));
        a.setMaterielSupport(getSafe(row, 7));
        a.setPersonnelSupport(getSafe(row, 8));
        a.setLocalSupport(getSafe(row, 9));
        a.setReseauSupport(getSafe(row, 10));

        // Impact
        a.setEvenementRedoute(getSafe(row, 11));

        return a;
    }

    private String getSafe(List<String> row, int i) {
        return (i < row.size() && row.get(i) != null) ? row.get(i).trim() : "";
    }

    private int parseSafeInt(String val) {
        try {
            return (int) Double.parseDouble(val.replaceAll("[^0-9]", ""));
        } catch (Exception e) { return 1; }
    }
}
