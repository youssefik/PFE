package com.example.spring_ad_auth.model;

public enum StatutTache {
    ACTIF("Actif", "bg-success"),
    INACTIF("Suspendu", "bg-secondary"),
    TERMINE("Terminé", "bg-primary"),
    ERREUR("En Erreur", "bg-danger");

    private final String libelle;
    private final String colorClass;

    StatutTache(String libelle, String colorClass) {
        this.libelle = libelle;
        this.colorClass = colorClass;
    }

    public String getLibelle() { return libelle; }
    public String getColorClass() { return colorClass; }
}