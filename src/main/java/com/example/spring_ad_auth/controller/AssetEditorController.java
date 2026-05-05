package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.Actif;
import com.example.spring_ad_auth.model.Perimetre;
import com.example.spring_ad_auth.repository.ActifRepository;
import com.example.spring_ad_auth.repository.PerimetreRepository;
import com.example.spring_ad_auth.service.ExcelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping("/rssi/assets-editor")
public class AssetEditorController {

    @Autowired private ActifRepository actifRepo;
    @Autowired private PerimetreRepository perimetreRepo;
    @Autowired private ExcelService excelService;

    @GetMapping
    public String viewEditor() {
        return "rssi/assets_editor";
    }

    @GetMapping("/data")
    @ResponseBody
    public List<Map<String, Object>> getAssetsData() {
        List<Actif> actifs = actifRepo.findAll();
        List<Map<String, Object>> result = new ArrayList<>();

        for (Actif a : actifs) {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", a.getId().toString());
            map.put("activite", a.getActivite());
            map.put("processus", a.getProcessus());
            map.put("nom", a.getNom());
            map.put("d", a.getDisponibilite());
            map.put("i", a.getIntegrite());
            map.put("c", a.getConfidentialite());
            map.put("logiciel", a.getLogicielSupport());
            map.put("materiel", a.getMaterielSupport());
            map.put("personnel", a.getPersonnelSupport());
            map.put("local", a.getLocalSupport());
            map.put("reseau", a.getReseauSupport());
            map.put("impact", a.getEvenementRedoute());
            result.add(map);
        }
        return result;
    }

    @PostMapping("/save")
    @ResponseBody
    @Transactional
    public String saveAssets(@RequestBody List<Map<String, Object>> data) throws IOException {
        try {
            // 1. On récupère le périmètre par défaut (ou à adapter selon ton besoin)
            Perimetre defaultP = perimetreRepo.findAll().get(0);

            List<Actif> newActifs = new ArrayList<>();
            for (Map<String, Object> m : data) {
                if (String.valueOf(m.get("nom")).isEmpty()) continue;

                Actif a = new Actif();
                a.setActivite(String.valueOf(m.getOrDefault("activite", "")));
                a.setProcessus(String.valueOf(m.getOrDefault("processus", "")));
                a.setNom(String.valueOf(m.get("nom")));
                a.setDisponibilite(parse(m.get("d")));
                a.setIntegrite(parse(m.get("i")));
                a.setConfidentialite(parse(m.get("c")));
                a.setLogicielSupport(String.valueOf(m.getOrDefault("logiciel", "")));
                a.setMaterielSupport(String.valueOf(m.getOrDefault("materiel", "")));
                a.setPersonnelSupport(String.valueOf(m.getOrDefault("personnel", "")));
                a.setLocalSupport(String.valueOf(m.getOrDefault("local", "")));
                a.setReseauSupport(String.valueOf(m.getOrDefault("reseau", "")));
                a.setEvenementRedoute(String.valueOf(m.getOrDefault("impact", "")));
                a.setPerimetre(defaultP);
                newActifs.add(a);
            }

            actifRepo.deleteAll();
            actifRepo.saveAll(newActifs);

            // 2. Synchronisation Excel (Facultatif, selon ta méthode saveAll déjà vue)
            return "SUCCESS";
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }

    private int parse(Object v) {
        if (v == null || v.toString().isEmpty()) return 1;
        try { return (int) Double.parseDouble(v.toString()); } catch (Exception e) { return 1; }
    }
}