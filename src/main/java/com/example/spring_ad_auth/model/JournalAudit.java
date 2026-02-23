package com.example.spring_ad_auth.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "journal_audit")
public class JournalAudit {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String typeEntite; // ex: "Controle", "Utilisateur"
    private UUID idEntite;     // ID de l'objet modifié
    private String action;     // ex: "CREATION", "MODIFICATION", "SUPPRESSION"
    private String utilisateur; // Username AD de celui qui a fait l'action

    private LocalDateTime dateCreation = LocalDateTime.now();

    // Getters et Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public String getTypeEntite() { return typeEntite; }
    public void setTypeEntite(String typeEntite) { this.typeEntite = typeEntite; }
    public UUID getIdEntite() { return idEntite; }
    public void setIdEntite(UUID idEntite) { this.idEntite = idEntite; }
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    public String getUtilisateur() { return utilisateur; }
    public void setUtilisateur(String utilisateur) { this.utilisateur = utilisateur; }
    public LocalDateTime getDateCreation() { return dateCreation; }
}