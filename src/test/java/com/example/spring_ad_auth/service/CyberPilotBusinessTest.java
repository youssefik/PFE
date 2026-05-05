package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.RegistreRisque;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class CyberPilotBusinessTest {

    @Autowired
    private RiskCalculator calculator;

    @Autowired
    private RiskMapper riskMapper;

    @Test
    @DisplayName("Validation de la Formule ISO 27005 : Max(C,I,D) * P * G")
    void testScoreFormula() {
        // Scénario : Actif Critique (C=4, I=2, D=2) -> Max = 4
        // Probabilité = 2, Gravité = 3
        // Attendu : 4 * 2 * 3 = 24
        int score = calculator.calculateScore(4, 2, 3);
        assertEquals(24, score, "Le calcul du score brut doit être conforme à la norme ISO 27005");
    }

    @Test
    @DisplayName("Test de Robustesse : Parsing des données Excel mal formatées")
    void testMapperRobustness() {
        // Simulation d'une ligne venant d'Excel avec des formats "sales" (ex: nombres avec .0)
        List<String> row = new ArrayList<>();
        row.add("Menace");      // 0
        row.add("Source");      // 1
        row.add("Actif");       // 2
        row.add("REF-001");     // 3 (REF)
        row.add("Proprio");     // 4
        row.add("Scenario");    // 5
        row.add("Vulner");      // 6
        row.add("Mesures");     // 7
        row.add("4.0");         // 8 (D)
        row.add("2");           // 9 (I)
        row.add("1.0");         // 10 (C)
        row.add("1");row.add("1");row.add("1");row.add("1"); // Impacts
        row.add("2.0");         // 15 (Proba)
        row.add("3");           // 16 (Grav)


        RegistreRisque result = riskMapper.mapRowToEntity(row, "CAT-TEST", "Menace", "Source", "Proprio");

        assertNotNull(result);
        assertEquals(4, result.getValD(), "Le mapper doit transformer '4.0' en integer 4");
        assertEquals(2, result.getProbabiliteInitial());
        assertEquals(24, result.getNiveauRisqueInitial(), "Le score doit être recalculé correctement par le mapper");
    }
}