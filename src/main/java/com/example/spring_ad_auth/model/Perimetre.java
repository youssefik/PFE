package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
public class Perimetre {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String nom;
    @Column(columnDefinition = "TEXT")
    private String description;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
