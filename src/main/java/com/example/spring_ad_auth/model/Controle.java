package com.example.spring_ad_auth.model;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "controles")
public class Controle {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String code; // ex: "A.5.1"

    @Column(nullable = false)
    private String titre;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String domaine; // ex: "Organisation de la sécurité"

    @ManyToOne
    @JoinColumn(name = "clause_id")
    private ClauseISO clauseISO;

    // Getters et Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getDomaine() { return domaine; }
    public void setDomaine(String domaine) { this.domaine = domaine; }
    public ClauseISO getClauseISO() { return clauseISO; }
    public void setClauseISO(ClauseISO clauseISO) { this.clauseISO = clauseISO; }
}