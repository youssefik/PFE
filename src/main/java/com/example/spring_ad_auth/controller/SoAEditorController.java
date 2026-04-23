package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.service.SoATableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/compliance/editor")
public class SoAEditorController {

    @Autowired
    private SoATableService soaTableService;

    @GetMapping
    public String viewEditor() {
        return "compliance/soa_editor";
    }

    @GetMapping("/data")
    @ResponseBody
    public List<List<String>> getTableData() throws IOException {
        return soaTableService.getSoAAsTable();
    }

    @PostMapping("/save")
    @ResponseBody
    public String saveTableData(@RequestBody List<List<String>> data) {
        try {
            // CORRECTION ICI : Le nom doit être saveTableToDB
            soaTableService.saveTableToDB(data);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }
}
/*
package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.service.ExcelService;
import com.example.spring_ad_auth.service.SoATableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/compliance/editor")
public class SoAEditorController {

    @Autowired private SoATableService soaTableService;
    @Autowired private ExcelService excelService;
    // Affiche la page de l'éditeur
    @GetMapping
    public String viewEditor() {
        return "compliance/soa_editor";
    }

    // Endpoint API pour charger les données
    @GetMapping("/data")
    public List<List<String>> getTableData() throws IOException {
        // TRÈS IMPORTANT : On appelle le service qui fusionne Excel + BD
        return soaTableService.getSoAAsTable();
    }

    // Endpoint API pour sauvegarder les données
    @PostMapping("/save")
    @ResponseBody
    public String saveTableData(@RequestBody List<List<String>> data) {
        try {
            // 1. Sauvegarde dans la Base de Données
            soaTableService.saveTableToDB(data);

            // 2. Sauvegarde dans le fichier Excel (POUR QUE LE FICHIER CHANGE AUSSI)
            excelService.saveAll(data);

            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }
}*/
