package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
public class Actif {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Contexte Métier (Colonnes A et B)
    private String activite;
    private String processus;

    // Actif Informationnel (Colonne C)
    private String nom;

    // Besoins de sécurité (Colonnes D, E, F)
    private int disponibilite;
    private int integrite;
    private int confidentialite;

    // Actifs Supports (Colonnes G, H, I, J, K)
    private String logicielSupport;
    private String materielSupport;
    private String personnelSupport;
    private String localSupport;
    private String reseauSupport;

    // Analyse d'impact (Colonne L)
    @Column(columnDefinition = "TEXT")
    private String evenementRedoute;

    @ManyToOne
    private Perimetre perimetre;

    // Getters et Setters...


    public UUID getId() {
        return id;
    }


    public String getActivite() {
        return activite;
    }

    public void setActivite(String activite) {
        this.activite = activite;
    }

    public String getProcessus() {
        return processus;
    }

    public void setProcessus(String processus) {
        this.processus = processus;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public int getDisponibilite() {
        return disponibilite;
    }

    public void setDisponibilite(int disponibilite) {
        this.disponibilite = disponibilite;
    }

    public int getIntegrite() {
        return integrite;
    }

    public void setIntegrite(int integrite) {
        this.integrite = integrite;
    }

    public int getConfidentialite() {
        return confidentialite;
    }

    public void setConfidentialite(int confidentialite) {
        this.confidentialite = confidentialite;
    }

    public String getLogicielSupport() {
        return logicielSupport;
    }

    public void setLogicielSupport(String logicielSupport) {
        this.logicielSupport = logicielSupport;
    }

    public String getMaterielSupport() {
        return materielSupport;
    }

    public void setMaterielSupport(String materielSupport) {
        this.materielSupport = materielSupport;
    }

    public String getPersonnelSupport() {
        return personnelSupport;
    }

    public void setPersonnelSupport(String personnelSupport) {
        this.personnelSupport = personnelSupport;
    }

    public String getLocalSupport() {
        return localSupport;
    }

    public void setLocalSupport(String localSupport) {
        this.localSupport = localSupport;
    }

    public String getReseauSupport() {
        return reseauSupport;
    }

    public void setReseauSupport(String reseauSupport) {
        this.reseauSupport = reseauSupport;
    }

    public String getEvenementRedoute() {
        return evenementRedoute;
    }

    public void setEvenementRedoute(String evenementRedoute) {
        this.evenementRedoute = evenementRedoute;
    }

    public Perimetre getPerimetre() {
        return perimetre;
    }

    public void setPerimetre(Perimetre perimetre) {
        this.perimetre = perimetre;
    }
}
