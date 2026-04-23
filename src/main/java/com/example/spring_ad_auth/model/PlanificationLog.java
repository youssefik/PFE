package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
public class PlanificationLog {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String titreTache;
    private LocalDateTime dateExecution;
    private String statut; // "SUCCES" ou "ERREUR"

    @Column(columnDefinition = "TEXT")
    private String message; // ex: "Email envoyé à responsable@mail.com"

    // Constructeur vide, Getters et Setters...
    public PlanificationLog() {}
    public PlanificationLog(String titreTache, LocalDateTime date, String statut, String msg) {
        this.titreTache = titreTache;
        this.dateExecution = date;
        this.statut = statut;
        this.message = msg;
    }
    // ... Getters/Setters


    public UUID getId() {
        return id;
    }


    public String getTitreTache() {
        return titreTache;
    }

    public void setTitreTache(String titreTache) {
        this.titreTache = titreTache;
    }

    public LocalDateTime getDateExecution() {
        return dateExecution;
    }

    public void setDateExecution(LocalDateTime dateExecution) {
        this.dateExecution = dateExecution;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
