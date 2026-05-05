package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.*;
import com.example.spring_ad_auth.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;


@Service
public class ReportingService {

    @Autowired private RegistreRisqueRepository riskRepo;
    @Autowired private ActionCorrectiveRepository actionRepo;
    @Autowired private ElementSoARepository soaRepo;
    @Autowired private ClauseISORepository clauseRepo;
    @Autowired private ConstatRepository constatRepo;

    public Map<String, Object> getGlobalStats() {
        Map<String, Object> stats = new HashMap<>();
        List<RegistreRisque> allRisks = riskRepo.findAll();

        int[][] distribution = new int[6][6];
        int highRisks = 0;

        for (RegistreRisque r : allRisks) {
            // 1. CORRECTION MATRICE :
            // On utilise PROBABILITE_INITIAL pour l'axe X
            // On utilise GRAVITE_INITIAL pour l'axe Y (car IMPACT_INITIAL est à 0 dans ta BD)
            int proba = Math.max(1, Math.min(r.getProbabiliteInitial(), 5));
            int gravite = Math.max(1, Math.min(r.getGraviteInitial(), 5)); // On sature à 5

            distribution[gravite][proba]++;

            // 2. COMPTEUR RISQUES CRITIQUES :
            // Dans ta BD, tu as des scores de 48, 24, 16. On définit le seuil critique à >= 15.
            if (r.getNiveauRisqueInitial() >= 15) {
                highRisks++;
            }
        }

        // 3. COMPTEUR ACTIFS (Basé sur le texte unique dans le registre)
        long totalAssetsUnique = allRisks.stream()
                .map(RegistreRisque::getActifsConcernes)
                .distinct()
                .count();

        // 4. ACTIONS CORRECTIVES
        long totalActions = actionRepo.count();
        long closedActions = actionRepo.findAll().stream()
                .filter(a -> "TERMINE".equalsIgnoreCase(a.getStatut())).count();

        // 5. CONFORMITÉ SoA (Adapté à ton texte "Oui")
        List<ElementSoA> soaElements = soaRepo.findAll();
        long applicableSoA = soaElements.stream().filter(ElementSoA::isApplicable).count();
        long conformeSoA = soaElements.stream()
                .filter(e -> e.isApplicable() && "Oui".equalsIgnoreCase(e.getStatutMiseEnOeuvre()))
                .count();

        int complianceRate = (applicableSoA > 0) ? (int)((double)conformeSoA / applicableSoA * 100) : 0;

        // --- ENVOI DES STATS ---
        stats.put("totalRisks", allRisks.size());
        stats.put("riskDistribution", distribution);
        stats.put("highRisksCount", highRisks);
        stats.put("totalAssets", totalAssetsUnique); // Utilise le chiffre des actifs uniques
        stats.put("totalActions", totalActions);
        stats.put("closedActions", closedActions);
        stats.put("complianceRate", complianceRate);

        return stats;
    }

    public Map<String, Object> getClauseConformityStats(UUID auditId) {
        List<ClauseISO> allSubClauses = clauseRepo.findAllByParentIsNotNull(); // On ne prend que les 4.1, 4.2...
        List<Constat> auditConstats = constatRepo.findByAuditId(auditId);

        long total = allSubClauses.size();
        long treated = 0;
        long wellTreated = 0;

        for (ClauseISO sc : allSubClauses) {
            // Chercher si un constat existe pour cette sous-clause
            Optional<Constat> constat = auditConstats.stream()
                    .filter(c -> c.getClauseIso() != null && c.getClauseIso().getId().equals(sc.getId()))
                    .findFirst();

            if (constat.isPresent()) {
                treated++;
                String status = constat.get().getType();
                // Logique de "Bien Traité" (Ajuster selon tes besoins)
                if (!status.contains("NC")) {
                    wellTreated++;
                }
            }
        }

        Map<String, Object> results = new HashMap<>();
        results.put("percentTreated", total == 0 ? 0 : (treated * 100 / total));
        results.put("percentWellTreated", treated == 0 ? 0 : (wellTreated * 100 / treated));
        return results;
    }
}
/*

@Service
public class ReportingService {

    @Autowired private ElementSoARepository soaRepo;
    @Autowired private RisqueRepository risqueRepo;
    @Autowired private ActionCorrectiveRepository actionRepo;
    @Autowired private ActifRepository actifRepo;
    @Autowired private RegistreRisqueRepository registreRisqueRepository;

    public Map<String, Object> getGlobalStats() {
        Map<String, Object> stats = new HashMap<>();
        List<RegistreRisque> allRisks = risqueRepo.findAll();

        // 1. Initialisation de la matrice 5x5 (on utilise 6 pour ignorer l'index 0)
        int[][] distribution = new int[6][6];
        int highRisks = 0;

        for (RegistreRisque r : allRisks) {
            // Sécurité pour éviter les index hors limites (doit être 1-5)
            int impact = Math.max(1, Math.min(r.getImpactInitial(), 5));
            int proba = Math.max(1, Math.min(r.getProbabiliteInitial(), 5));

            // On incrémente la case correspondante
            distribution[impact][proba]++;

            // On compte les risques critiques (Score >= 15 par exemple)
            if (r.getNiveauRisqueInitial() >= 15) {
                highRisks++;
            }
        }

        // 2. Calculs de base
        long totalActions = actionRepo.count();
        long closedActions = actionRepo.findAll().stream().filter(a -> "TERMINE".equals(a.getStatut())).count();

        // 3. Stockage dans la Map pour la vue
        stats.put("totalRisks", allRisks.size());
        stats.put("riskDistribution", distribution);
        stats.put("highRisksCount", highRisks);
        stats.put("totalAssets", actifRepo.count());
        stats.put("totalActions", totalActions);
        stats.put("closedActions", closedActions);

        // Exemple de calcul de conformité SoA (ajuster selon votre logique)
        long totalSoA = soaRepo.count();
        long applicableSoA = soaRepo.findAll().stream().filter(e -> e.isApplicable()).count();
        stats.put("applicableControls", applicableSoA);
        stats.put("conformingControls", soaRepo.findAll().stream().filter(e -> "Oui".equalsIgnoreCase(e.getStatutMiseEnOeuvre())).count());

        if (applicableSoA > 0) {
            int rate = (int) ((double) (long)stats.get("conformingControls") / applicableSoA * 100);
            stats.put("complianceRate", rate);
        } else {
            stats.put("complianceRate", 0);
        }

        return stats;
    }

*/
/*
    public Map<String, Object> getGlobalStats() {
        Map<String, Object> stats = new HashMap<>();

        // 1. Statistiques SoA
        List<ElementSoA> allSoa = soaRepo.findAll();
        long applicableCount = allSoa.stream().filter(ElementSoA::isApplicable).count();
        long conformingCount = allSoa.stream().filter(e -> "Oui".equalsIgnoreCase(e.getStatutMiseEnOeuvre())).count();

        double complianceRate = applicableCount > 0 ? (double) conformingCount / applicableCount * 100 : 0;

        // 2. Statistiques Risques
        List<RegistreRisque> risques = risqueRepo.findAll();
*//*

*/
/*
        long highRisks = risques.stream().filter(r -> r.getScoreCible() >= 15).count();
*//*
*/
/*


        // 3. Amélioration continue
        List<ActionCorrective> actions = actionRepo.findAll();
        long closedActions = actions.stream().filter(a -> "TERMINE".equalsIgnoreCase(a.getStatut())).count();


        List<RegistreRisque> risks = registreRisqueRepository.findAll();

        // 1. Initialiser une matrice 5x5 (on utilise 6 pour ignorer l'index 0)
        int[][] matrix = new int[6][6];
        int totalHigh = 0;

        for (RegistreRisque r : risks) {
            int impact = r.getImpactInitial();      // Doit être entre 1 et 5
            int proba = r.getProbabiliteInitial();   // Doit être entre 1 et 5

            if (impact >= 1 && impact <= 5 && proba >= 1 && proba <= 5) {
                matrix[impact][proba]++; // On incrémente la case correspondante
            }

            if (r.getNiveauRisqueInitial() >= 15) {
                totalHigh++;
            }
        }

        stats.put("totalRisks", risks.size());
        stats.put("highRisksCount", totalHigh);
        stats.put("riskDistribution", matrix); // On envoie le tableau 2D au JSP


        stats.put("complianceRate", Math.round(complianceRate));
        stats.put("applicableControls", applicableCount);
        stats.put("conformingControls", conformingCount);
*//*

*/
/*
        stats.put("highRisksCount", highRisks);
*//*
*/
/*

        stats.put("totalActions", actions.size());
        stats.put("closedActions", closedActions);
        stats.put("totalAssets", actifRepo.count());

        return stats;
    }
*//*

}*/
