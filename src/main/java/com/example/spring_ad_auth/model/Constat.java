package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
public class Constat {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // "ANNEXE_A" ou "CLAUSE"
    private String source;

    private String type; // Utilisé comme "STATUT" pour les clauses (NC Majeure...)
    private String niveauMaturite; // Pour l'Annexe A (0 à 5)

    @Column(columnDefinition = "TEXT")
    private String description; // Faits d'audit

    @Column(columnDefinition = "TEXT")
    private String recommandation; // Nouveau champ

    private String gravite; // HAUTE, MOYENNE, FAIBLE

    @ManyToOne private Audit audit;
    @ManyToOne private Controle controle; // Pour l'Annexe A
    @ManyToOne private ClauseISO clauseIso; // Pour les clauses 4-10

    @OneToOne(mappedBy = "constat", cascade = CascadeType.ALL, orphanRemoval = true)
    private NonConformite nonConformite;

    public NonConformite getNonConformite() {
        return nonConformite;
    }

    public void setNonConformite(NonConformite nonConformite) {
        this.nonConformite = nonConformite;
    }

    public UUID getId() {
        return id;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getNiveauMaturite() {
        return niveauMaturite;
    }

    public void setNiveauMaturite(String niveauMaturite) {
        this.niveauMaturite = niveauMaturite;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRecommandation() {
        return recommandation;
    }

    public void setRecommandation(String recommandation) {
        this.recommandation = recommandation;
    }

    public String getGravite() {
        return gravite;
    }

    public void setGravite(String gravite) {
        this.gravite = gravite;
    }

    public Audit getAudit() {
        return audit;
    }

    public void setAudit(Audit audit) {
        this.audit = audit;
    }

    public Controle getControle() {
        return controle;
    }

    public void setControle(Controle controle) {
        this.controle = controle;
    }

    public ClauseISO getClauseIso() {
        return clauseIso;
    }

    public void setClauseIso(ClauseISO clauseIso) {
        this.clauseIso = clauseIso;
    }
}

/*@Entity
public class Constat {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String type; // "NC_MAJEURE", "NC_MINEURE", "OBSERVATION", "OPPORTUNITE"

    @Column(columnDefinition = "TEXT")
    private String description;

    private String gravite; // "HAUTE", "MOYENNE", "FAIBLE"

    @ManyToOne
    private Audit audit;

    @ManyToOne
    private Controle controle; // Sur quel point de la norme porte le constat

    @OneToOne(mappedBy = "constat", cascade = CascadeType.ALL)
    private NonConformite nonConformite;
    // Getters/Setters...


    public UUID getId() {
        return id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getGravite() {
        return gravite;
    }

    public void setGravite(String gravite) {
        this.gravite = gravite;
    }

    public Audit getAudit() {
        return audit;
    }

    public void setAudit(Audit audit) {
        this.audit = audit;
    }

    public Controle getControle() {
        return controle;
    }

    public void setControle(Controle controle) {
        this.controle = controle;
    }

    public NonConformite getNonConformite() {
        return nonConformite;
    }

    public void setNonConformite(NonConformite nonConformite) {
        this.nonConformite = nonConformite;
    }
}*/
