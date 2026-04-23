package com.example.spring_ad_auth.service;

/*
import org.springframework.ai.ollama.OllamaChatClient;
*/
import org.springframework.ai.ollama.OllamaChatModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SmartAIService {

    @Autowired
    private OllamaChatModel chatClient;

    public String getAnalysis(String description, String codeControle) {
        String prompt = """
        INSTRUCTIONS : Agis en auditeur certifié ISO 27001.
        CONTEXTE : Une non-conformité a été trouvée sur le contrôle %s.
        FAIT : "%s".
        
        TÂCHE : 
        1. Rédige une "CAUSE RACINE" (Pourquoi cet écart existe ?)
        2. Rédige une "ACTION CORRECTIVE" (Quelle mesure concrète prendre ?)
        
        FORMAT DE RÉPONSE : 
        CAUSE RACINE : [Texte court]
        ACTION : [Mesure précise]
        
        Réponds en français, soit bref et professionnel.
        """.formatted(codeControle, description);

        return chatClient.call(prompt);
    }


    public String getAuditRecommendation(String description, String codeControle) {
        String prompt = """
        CONTEXTE : Audit de certification ISO 27001.
        RÔLE : Tu es un auditeur Lead Expert.
        CONSTAT RÉEL : "%s"
        POINT DE CONTRÔLE : %s
        
        MISSION : Donne une recommandation corrective concrète, très courte (max 2 phrases) et professionnelle.
        INSTRUCTION : Commence par un verbe à l'infinitif. Va droit au but sans introduction.
        """.formatted(description, codeControle);

        try {
            // Utilise le chatClient qui est déjà configuré dans ton projet
            return chatClient.call(prompt);
        } catch (Exception e) {
            return "Délai dépassé : Le modèle Phi-3 met trop de temps à répondre sur ce PC.";
        }
    }


}