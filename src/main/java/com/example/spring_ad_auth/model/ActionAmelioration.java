package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "journal_amelioration")
public class ActionAmelioration {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String numero;              // Col A (Index 0)
    @Column(columnDefinition = "TEXT")
    private String actionCorrective;
    @Column(columnDefinition = "TEXT")
    // Col B (Index 1)
    private String dateBesoin;          // Col C (Index 2)
    private String responsable;         // Col D (Index 3)
    @Column(columnDefinition = "TEXT")
    private String analyseCause;        // Col E (Index 4)

    private String statut = "EN_COURS"; // Valeur par défaut

    private String dateCloture;         // Col G (Index 6)
    @Column(columnDefinition = "TEXT")
    private String efficacite;          // Col H (Index 7)

    // Getters and Setters...


    public UUID getId() {
        return id;
    }


    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getActionCorrective() {
        return actionCorrective;
    }

    public void setActionCorrective(String actionCorrective) {
        this.actionCorrective = actionCorrective;
    }

    public String getDateBesoin() {
        return dateBesoin;
    }

    public void setDateBesoin(String dateBesoin) {
        this.dateBesoin = dateBesoin;
    }

    public String getResponsable() {
        return responsable;
    }

    public void setResponsable(String responsable) {
        this.responsable = responsable;
    }

    public String getAnalyseCause() {
        return analyseCause;
    }

    public void setAnalyseCause(String analyseCause) {
        this.analyseCause = analyseCause;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getDateCloture() {
        return dateCloture;
    }

    public void setDateCloture(String dateCloture) {
        this.dateCloture = dateCloture;
    }

    public String getEfficacite() {
        return efficacite;
    }

    public void setEfficacite(String efficacite) {
        this.efficacite = efficacite;
    }
}