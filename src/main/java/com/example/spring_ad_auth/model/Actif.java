package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
public class Actif {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String nom;
    private String type; // ex: Matériel, Logiciel, Site
    private String proprietaire; // On stocke ici le nom du responsable

    // Critères de criticité (0 à 3)
    private int confidentialite;
    private int integrite;
    private int disponibilite;

    @ManyToOne
    private Perimetre perimetre;
    // Getters/Setters


    public UUID getId() {
        return id;
    }


    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getProprietaire() {
        return proprietaire;
    }

    public void setProprietaire(String proprietaire) {
        this.proprietaire = proprietaire;
    }

    public int getConfidentialite() {
        return confidentialite;
    }

    public void setConfidentialite(int confidentialite) {
        this.confidentialite = confidentialite;
    }

    public int getIntegrite() {
        return integrite;
    }

    public void setIntegrite(int integrite) {
        this.integrite = integrite;
    }

    public int getDisponibilite() {
        return disponibilite;
    }

    public void setDisponibilite(int disponibilite) {
        this.disponibilite = disponibilite;
    }

    public Perimetre getPerimetre() {
        return perimetre;
    }

    public void setPerimetre(Perimetre perimetre) {
        this.perimetre = perimetre;
    }
}
