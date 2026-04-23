package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
public class Audit {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String titre;
    private LocalDate dateDebut;
    private LocalDate dateFin;
    private String statut; // "PLANIFIE", "EN_COURS", "TERMINE"

    @OneToMany(mappedBy = "audit", cascade = CascadeType.ALL)
    private List<Constat> constats = new ArrayList<>(); // Toujours initialiser !
    // Getters/Setters...


    public UUID getId() {
        return id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public List<Constat> getConstats() {
        return constats;
    }

    public void setConstats(List<Constat> constats) {
        this.constats = constats;
    }
}