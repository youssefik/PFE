package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.service.SoAIntegrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/compliance/sync")
public class SoASyncController {

    @Autowired private SoAIntegrationService syncService;


    @GetMapping("/import")
    @ResponseBody
    public String importData() {
        try {
            syncService.importExcelToDb();
            return "SUCCESS : Fichier Excel importé vers la Base de données";
        } catch (Exception e) {
            return "ERROR : " + e.getMessage();
        }
    }
}
