package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.OllamaRequest;
import com.example.spring_ad_auth.model.OllamaResponse;
import com.example.spring_ad_auth.service.SmartAIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/ai")
public class AiAuditController {

    @Autowired
    private SmartAIService aiService;

    @PostMapping("/audit-assist")
    public String getAssist(@RequestBody Map<String, Object> payload) {
        // On récupère les données envoyées par la page realiser_checklist.jsp
        String description = (String) payload.get("prompt");
        String code = (String) payload.get("controlCode");

        if (description == null || description.length() < 5) {
            return "Veuillez saisir un constat plus détaillé.";
        }

        // On appelle le service qui utilise Spring AI
        return aiService.getAuditRecommendation(description, code);
    }
}
