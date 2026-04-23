package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Entity
public class ElementSoA {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private boolean applicable;
    @Column(columnDefinition = "TEXT")
    private String justification; // Pourquoi est-ce (ou non) applicable ?

    private String statutMiseEnOeuvre; // ex: "NON_DEMARRE", "EN_COURS", "CONFORME"
    private String efficacite; // "EFFICACE", "A_AMELIORER", "NON_EFFICACE"
    private LocalDate dateDerniereRevue;

    // Ajoutez ces champs dans ElementSoA pour ne pas perdre les colonnes 6 et 7 d'Excel
    private String dispositif; // Correspond à la colonne 6
    private String responsable; // Correspond à la colonne 7

    @OneToOne
    @JoinColumn(name = "controle_id")
    private Controle controle; // Lien vers le référentiel créé au Sprint 1

    @OneToMany(mappedBy = "elementSoA", cascade = CascadeType.ALL)
    private List<Preuve> preuves;

    private String couleur; // Nouveau : stockera par exemple "#ff0000"

    private String couleurStyle; // Stockera "codeFond|codeTexte"

    // Getters/Setters

    public UUID getId() {
        return id;
    }



    public boolean isApplicable() {
        return applicable;
    }

    public void setApplicable(boolean applicable) {
        this.applicable = applicable;
    }

    public String getJustification() {
        return justification;
    }

    public void setJustification(String justification) {
        this.justification = justification;
    }

    public String getStatutMiseEnOeuvre() {
        return statutMiseEnOeuvre;
    }

    public void setStatutMiseEnOeuvre(String statutMiseEnOeuvre) {
        this.statutMiseEnOeuvre = statutMiseEnOeuvre;
    }

    public String getEfficacite() {
        return efficacite;
    }

    public void setEfficacite(String efficacite) {
        this.efficacite = efficacite;
    }

    public LocalDate getDateDerniereRevue() {
        return dateDerniereRevue;
    }

    public void setDateDerniereRevue(LocalDate dateDerniereRevue) {
        this.dateDerniereRevue = dateDerniereRevue;
    }

    public Controle getControle() {
        return controle;
    }

    public void setControle(Controle controle) {
        this.controle = controle;
    }

    public List<Preuve> getPreuves() {
        return preuves;
    }

    public void setPreuves(List<Preuve> preuves) {
        this.preuves = preuves;
    }

    public String getCouleur() {
        return couleur;
    }

    public void setCouleur(String couleur) {
        this.couleur = couleur;
    }


    public String getCouleurStyle() {
        return couleurStyle;
    }
    public void setCouleurStyle(String couleurStyle) {
        this.couleurStyle = couleurStyle;
    }

    public String getDispositif() {
        return dispositif;
    }

    public void setDispositif(String dispositif) {
        this.dispositif = dispositif;
    }

    public String getResponsable() {
        return responsable;
    }

    public void setResponsable(String responsable) {
        this.responsable = responsable;
    }
}
