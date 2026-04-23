package com.example.spring_ad_auth.model;

import jakarta.persistence.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "planification_taches")
public class PlanificationTache {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String titre; // ex: "Sauvegarde VM Production"
    private String description;
    private String typeTache; // BACKUP_VM, BACKUP_DB, REVUE_RISQUE, AUDIT_LOGS

    // Planification
    private String frequence; // "JOURNALIER", "HEBDOMADAIRE", "MENSUEL", "BIMESTRIEL"
    private LocalDateTime derniereExecution;
    private LocalDateTime prochaineExecution;

    // Notification
    private String emailResponsable;
    private boolean notificationEnvoyee = false;

    @Enumerated(EnumType.STRING)
    private StatutTache statut = StatutTache.ACTIF;


    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime dateDebut;

    // Getters / Setters...


    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTypeTache() {
        return typeTache;
    }

    public void setTypeTache(String typeTache) {
        this.typeTache = typeTache;
    }

    public String getFrequence() {
        return frequence;
    }

    public void setFrequence(String frequence) {
        this.frequence = frequence;
    }

    public LocalDateTime getDerniereExecution() {
        return derniereExecution;
    }

    public void setDerniereExecution(LocalDateTime derniereExecution) {
        this.derniereExecution = derniereExecution;
    }

    public LocalDateTime getProchaineExecution() {
        return prochaineExecution;
    }

    public void setProchaineExecution(LocalDateTime prochaineExecution) {
        this.prochaineExecution = prochaineExecution;
    }

    public String getEmailResponsable() {
        return emailResponsable;
    }

    public void setEmailResponsable(String emailResponsable) {
        this.emailResponsable = emailResponsable;
    }

    public boolean isNotificationEnvoyee() {
        return notificationEnvoyee;
    }

    public void setNotificationEnvoyee(boolean notificationEnvoyee) {
        this.notificationEnvoyee = notificationEnvoyee;
    }

    public StatutTache getStatut() {
        return statut;
    }

    public void setStatut(StatutTache statut) {
        this.statut = statut;
    }

    public UUID getId() {
        return id;
    }

    public void setDateDebut(LocalDateTime dateDebut) {
        this.dateDebut = dateDebut;
    }

    // Ajoute aussi celui-ci si tu ne l'as pas pour l'ID
    public void setId(UUID id) {
        this.id = id;
    }


    public LocalDateTime getDateDebut() {
        return dateDebut;
    }
}
