package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.mapper.ActifMapper;
import com.example.spring_ad_auth.model.Actif;
import com.example.spring_ad_auth.model.Perimetre;
import com.example.spring_ad_auth.repository.ActifRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class ActifService {
    @Autowired
    private ActifRepository actifRepo;
    @Autowired private ExcelService excelService;
    @Autowired private ActifMapper mapper;

    @Transactional
    public void importFromExcel(String filePath, Perimetre p) throws IOException {
        // Lecture : 12 colonnes, index feuille 0, commence à la ligne 5 (index 4)
        // Note: startRow=4 pour sauter les 2 lignes de header (Ligne 3 et 4)
        List<List<String>> rows = excelService.readGeneric(filePath, 12, 0, 4);

        String lastActivite = "";
        String lastProcessus = "";
        List<Actif> toSave = new ArrayList<>();

        for (List<String> row : rows) {
            if (row.isEmpty() || row.stream().allMatch(String::isEmpty)) continue;

            // Mise à jour de la mémoire si les colonnes fusionnées ont une nouvelle valeur
            if (!row.get(0).isEmpty()) lastActivite = row.get(0);
            if (!row.get(1).isEmpty()) lastProcessus = row.get(1);

            // Création de l'entité
            if (!row.get(2).isEmpty()) { // On crée un actif seulement si la Col C n'est pas vide
                toSave.add(mapper.mapRowToEntity(row, lastActivite, lastProcessus, p));
            }
        }

        // Optionnel : On peut filtrer pour ne garder que les actifs du périmètre sélectionné
        actifRepo.saveAll(toSave);
    }
}