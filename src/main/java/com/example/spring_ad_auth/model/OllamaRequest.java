package com.example.spring_ad_auth.model;

public class OllamaRequest {
    public String model;
    public String prompt;
    public boolean stream = false; // Important pour recevoir le texte d'un bloc

    public OllamaRequest(String model, String prompt) {
        this.model = model;
        this.prompt = prompt;
    }
}
