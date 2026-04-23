package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.UUID;

@Entity
public class ActionCorrective {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String titre;
    private String responsable; // Nom de l'utilisateur chargé de l'action
    private LocalDate dateEcheance;
    private String statut; // "A_FAIRE", "EN_COURS", "TERMINE"

    @ManyToOne
    @JoinColumn(name = "non_conformite_id")
    private NonConformite nonConformite;

    public UUID getId() {
        return id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getResponsable() {
        return responsable;
    }

    public void setResponsable(String responsable) {
        this.responsable = responsable;
    }

    public LocalDate getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(LocalDate dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public NonConformite getNonConformite() {
        return nonConformite;
    }

    public void setNonConformite(NonConformite nonConformite) {
        this.nonConformite = nonConformite;
    }
}