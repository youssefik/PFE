package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.service.SmartAIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/ai")
public class AIController {

    @Autowired
    private SmartAIService aiService;

    @PostMapping("/suggest-nc")
    public String suggest(@RequestBody Map<String, Object> payload) {
        try {
            // Log pour déboguer dans votre console IDE
            System.out.println("Payload reçu : " + payload);

            String desc = (String) payload.get("desc");
            String code = (String) payload.get("code");

            if (desc == null || code == null) {
                return "Erreur : Description ou code manquant dans la requête.";
            }

            return aiService.getAnalysis(desc, code);
        } catch (Exception e) {
            // C'est ce message que vous verrez dans les logs si ça crash
            e.printStackTrace();
            return "ERREUR INTERNE : " + e.getMessage();
        }
    }
}