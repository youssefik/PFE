package com.example.spring_ad_auth.model;

import jakarta.persistence.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.util.UUID;

@Entity
public class TraitementRisque {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Stratégies standards ISO 27001
    private String strategie; // "Reduire", "Accepter", "Transferer", "Eviter"

    @Column(columnDefinition = "TEXT")
    private String planTraitement; // Description des actions

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateCible;    private String statut; // "A_FAIRE", "EN_COURS", "TERMINE"

    @OneToOne
    @JoinColumn(name = "risque_id")
    private Risque risque;

    // Getters et Setters


    public String getStrategie() {
        return strategie;
    }

    public void setStrategie(String strategie) {
        this.strategie = strategie;
    }

    public String getPlanTraitement() {
        return planTraitement;
    }

    public void setPlanTraitement(String planTraitement) {
        this.planTraitement = planTraitement;
    }

    public LocalDate getDateCible() {
        return dateCible;
    }

    public void setDateCible(LocalDate dateCible) {
        this.dateCible = dateCible;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Risque getRisque() {
        return risque;
    }

    public void setRisque(Risque risque) {
        this.risque = risque;
    }

    public UUID getId() {
        return id;
    }

}