package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
public class Risque {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String titre;
    private String menace;
    private String vulnerabilite;

    private int impact;      // 1 à 5
    private int vraisemblance; // 1 à 5
    private int score;       // impact * vraisemblance
    private String statut;   // IDENTIFIE, TRAITE, ACCEPTE

    @ManyToOne
    private Actif actif;
    // Getters/Setters

    @OneToOne(mappedBy = "risque", cascade = CascadeType.ALL)
    private TraitementRisque traitement;

    public UUID getId() {
        return id;
    }


    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getMenace() {
        return menace;
    }

    public void setMenace(String menace) {
        this.menace = menace;
    }

    public String getVulnerabilite() {
        return vulnerabilite;
    }

    public void setVulnerabilite(String vulnerabilite) {
        this.vulnerabilite = vulnerabilite;
    }

    public int getImpact() {
        return impact;
    }

    public void setImpact(int impact) {
        this.impact = impact;
    }

    public int getVraisemblance() {
        return vraisemblance;
    }

    public void setVraisemblance(int vraisemblance) {
        this.vraisemblance = vraisemblance;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Actif getActif() {
        return actif;
    }

    public void setActif(Actif actif) {
        this.actif = actif;
    }

    public TraitementRisque getTraitement() {
        return traitement;
    }

    public void setTraitement(TraitementRisque traitement) {
        this.traitement = traitement;
    }
}