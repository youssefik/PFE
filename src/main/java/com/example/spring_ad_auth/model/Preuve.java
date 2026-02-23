package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
public class Preuve {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String titre;
    private String type; // ex: Document, Capture d'écran, Log
    private String urlFichier; // Chemin vers le fichier stocké
    private String version;
    private LocalDateTime dateAjout = LocalDateTime.now();

    @ManyToOne
    private ElementSoA elementSoA;
    // Getters/Setters

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUrlFichier() {
        return urlFichier;
    }

    public void setUrlFichier(String urlFichier) {
        this.urlFichier = urlFichier;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public LocalDateTime getDateAjout() {
        return dateAjout;
    }

    public void setDateAjout(LocalDateTime dateAjout) {
        this.dateAjout = dateAjout;
    }

    public ElementSoA getElementSoA() {
        return elementSoA;
    }

    public void setElementSoA(ElementSoA elementSoA) {
        this.elementSoA = elementSoA;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public UUID getId() {
        return id;
    }

}
