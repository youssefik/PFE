package com.example.spring_ad_auth.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
public class Signature {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String entityType; // "SOA", "RISQUES", "AUDIT"
    private UUID entityId;     // ID de l'objet signé

    private String nomSignataire; // Nom complet récupéré de l'AD
    private String roleSignataire; // ex: DG, RSSI
    private String username;       // login AD

    private LocalDateTime dateSignature = LocalDateTime.now();

    @Column(columnDefinition = "TEXT")
    private String commentaire; // ex: "Approuvé pour l'audit 2026"

    @Column(columnDefinition = "TEXT")
    private String imageSignature; // Contiendra les données de l'image (Base64)

    // Getter / Setter
    public String getImageSignature() { return imageSignature; }
    public void setImageSignature(String imageSignature) { this.imageSignature = imageSignature; }

    // Getters / Setters...

    public UUID getId() {
        return id;
    }

    public String getEntityType() {
        return entityType;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public UUID getEntityId() {
        return entityId;
    }

    public void setEntityId(UUID entityId) {
        this.entityId = entityId;
    }

    public String getNomSignataire() {
        return nomSignataire;
    }

    public void setNomSignataire(String nomSignataire) {
        this.nomSignataire = nomSignataire;
    }

    public String getRoleSignataire() {
        return roleSignataire;
    }

    public void setRoleSignataire(String roleSignataire) {
        this.roleSignataire = roleSignataire;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public LocalDateTime getDateSignature() {
        return dateSignature;
    }

    public void setDateSignature(LocalDateTime dateSignature) {
        this.dateSignature = dateSignature;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }
}