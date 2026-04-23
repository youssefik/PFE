package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.RegistreRisque;
import com.example.spring_ad_auth.repository.RegistreRisqueRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RiskSyncService {

    @Autowired
    private RegistreRisqueRepository riskRepo;

    @Transactional
    public void saveRiskTable(List<List<String>> data) {
        // i=1 pour sauter les en-têtes du script python (la ligne categorie, ref, ...)
        for (int i = 1; i < data.size(); i++) {
            List<String> row = data.get(i);
            if (row.size() < 4) continue;

            String ref = row.get(1); // PHY-1
            if (ref == null || ref.isEmpty()) continue;

            RegistreRisque r = riskRepo.findByRef(ref).orElse(new RegistreRisque());

            // Mapping des colonnes basé sur votre structure CSV/JSON
            r.setCategorie(row.get(0));
            r.setRef(ref);
            r.setMenaces(row.get(2));
            r.setOrigine(row.get(3));
            r.setActifsConcernes(row.get(4));
            r.setProprietaireRisque(row.get(5));
            r.setScenariosRisque(row.get(6));
            r.setVulnerabilites(row.get(7));
            r.setMesuresExistantes(row.get(8));

            // --- CALCULS AUTOMATIQUES ---
            int pInit = parse(row.get(11)); // proba_initial
            int gInit = parse(row.get(12)); // gravite_initial
            int cidMax = parse(row.get(9));  // besoin_securite_initial

            // Formule : Max Valeur (CID) * Probabilité * Gravité
            int scoreInit = cidMax * pInit * gInit;
            r.setNiveauRisqueInitial(scoreInit);

            // --- TRAITEMENT ---
            r.setOptionTraitement(row.get(14));
            r.setActionsTraitement(row.get(15));

            int besoinC = parse(row.get(16));
            int probC = parse(row.get(17));
            int gravC = parse(row.get(18));

            // Formule Cible : Besoin Cible * Probabilité Cible * Gravité Cible
            int scoreCible = besoinC * probC * gravC;
            r.setNiveauRisqueCible(scoreCible);

            // Option auto basée sur le score cible
            if (scoreCible <= 12) r.setOptionTraitementApres("Accepter");
            else r.setOptionTraitementApres("Réduire");

            // Sauvegarde du style BD (index 21 si vous l'ajoutez en JS)
            if (row.size() > 21) r.setCouleurStyle(row.get(21));

            riskRepo.save(r);
        }
    }

    private int parse(String val) {
        try { return Integer.parseInt(val.trim()); } catch (Exception e) { return 0; }
    }

    // Utilisé par le controller pour renvoyer les données à Handsontable
    public List<List<String>> getRisksAsTable() {
        List<RegistreRisque> risks = riskRepo.findAll();
        List<List<String>> table = new ArrayList<>();

        for (RegistreRisque r : risks) {
            List<String> row = new ArrayList<>();
            row.add(r.getCategorie()); row.add(r.getRef()); row.add(r.getMenaces());
            row.add(r.getOrigine()); row.add(r.getActifsConcernes());
            row.add(r.getProprietaireRisque()); row.add(r.getScenariosRisque());
            row.add(r.getVulnerabilites()); row.add(r.getMesuresExistantes());
            row.add(String.valueOf(r.getBesoinSecuriteInitial()));
            // ... Ajoutez toutes les colonnes jusqu'à r.getCouleurStyle() à l'index 21
            table.add(row);
        }
        return table;
    }
}