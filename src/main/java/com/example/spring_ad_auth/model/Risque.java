package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
public class Risque {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String ref; // Colonne index 3 (PHY-1)
    private String categorie;
    @Column(columnDefinition = "TEXT")
    private String menaces; // Index 0
    private String origine; // Index 1
    private String actifsConcernes; // Index 2
    private String proprietaireRisque; // Index 4
    @Column(columnDefinition = "TEXT")
    private String scenariosRisque; // Index 5
    @Column(columnDefinition = "TEXT")
    private String vulnerabilites; // Index 6
    @Column(columnDefinition = "TEXT")
    private String mesuresExistantes; // Index 7

    // Besoins de sécurité (D, I, C)
    private Integer d; // Index 8
    private Integer i_need; // Index 9 (nommé i_need car 'i' est protégé)
    private Integer c; // Index 10

    // Impacts
    private Integer impactOrg; // Index 11
    private Integer impactJuridique; // Index 12
    private Integer impactImage; // Index 13
    private Integer impactFinancier; // Index 14

    // Initial / Résiduel
    private Integer probabiliteInitial; // Index 15
    private Integer graviteInitial; // Index 16
    private Integer niveauRisqueResiduel; // Index 17 (Calculé)

    private String optionTraitement; // Index 18
    @Column(columnDefinition = "TEXT")
    private String actionsTraitement; // Index 19

    // Cible
    private Integer besoinSecuriteCible; // Index 20
    private Integer probabiliteCible; // Index 21
    private Integer graviteCible; // Index 22
    private Integer niveauRisqueCible; // Index 23 (Calculé)

    private String optionTraitementApres; // Index 24

    private String couleurStyle; // Index 25

    // Getters and Setters ...


    public UUID getId() {
        return id;
    }

    public String getRef() {
        return ref;
    }

    public void setRef(String ref) {
        this.ref = ref;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public String getMenaces() {
        return menaces;
    }

    public void setMenaces(String menaces) {
        this.menaces = menaces;
    }

    public String getOrigine() {
        return origine;
    }

    public void setOrigine(String origine) {
        this.origine = origine;
    }

    public String getActifsConcernes() {
        return actifsConcernes;
    }

    public void setActifsConcernes(String actifsConcernes) {
        this.actifsConcernes = actifsConcernes;
    }

    public String getProprietaireRisque() {
        return proprietaireRisque;
    }

    public void setProprietaireRisque(String proprietaireRisque) {
        this.proprietaireRisque = proprietaireRisque;
    }

    public String getScenariosRisque() {
        return scenariosRisque;
    }

    public void setScenariosRisque(String scenariosRisque) {
        this.scenariosRisque = scenariosRisque;
    }

    public String getVulnerabilites() {
        return vulnerabilites;
    }

    public void setVulnerabilites(String vulnerabilites) {
        this.vulnerabilites = vulnerabilites;
    }

    public String getMesuresExistantes() {
        return mesuresExistantes;
    }

    public void setMesuresExistantes(String mesuresExistantes) {
        this.mesuresExistantes = mesuresExistantes;
    }

    public Integer getD() {
        return d;
    }

    public void setD(Integer d) {
        this.d = d;
    }

    public Integer getI_need() {
        return i_need;
    }

    public void setI_need(Integer i_need) {
        this.i_need = i_need;
    }

    public Integer getC() {
        return c;
    }

    public void setC(Integer c) {
        this.c = c;
    }

    public Integer getImpactOrg() {
        return impactOrg;
    }

    public void setImpactOrg(Integer impactOrg) {
        this.impactOrg = impactOrg;
    }

    public Integer getImpactJuridique() {
        return impactJuridique;
    }

    public void setImpactJuridique(Integer impactJuridique) {
        this.impactJuridique = impactJuridique;
    }

    public Integer getImpactImage() {
        return impactImage;
    }

    public void setImpactImage(Integer impactImage) {
        this.impactImage = impactImage;
    }

    public Integer getImpactFinancier() {
        return impactFinancier;
    }

    public void setImpactFinancier(Integer impactFinancier) {
        this.impactFinancier = impactFinancier;
    }

    public Integer getProbabiliteInitial() {
        return probabiliteInitial;
    }

    public void setProbabiliteInitial(Integer probabiliteInitial) {
        this.probabiliteInitial = probabiliteInitial;
    }

    public Integer getGraviteInitial() {
        return graviteInitial;
    }

    public void setGraviteInitial(Integer graviteInitial) {
        this.graviteInitial = graviteInitial;
    }

    public Integer getNiveauRisqueResiduel() {
        return niveauRisqueResiduel;
    }

    public void setNiveauRisqueResiduel(Integer niveauRisqueResiduel) {
        this.niveauRisqueResiduel = niveauRisqueResiduel;
    }

    public String getOptionTraitement() {
        return optionTraitement;
    }

    public void setOptionTraitement(String optionTraitement) {
        this.optionTraitement = optionTraitement;
    }

    public String getActionsTraitement() {
        return actionsTraitement;
    }

    public void setActionsTraitement(String actionsTraitement) {
        this.actionsTraitement = actionsTraitement;
    }

    public Integer getBesoinSecuriteCible() {
        return besoinSecuriteCible;
    }

    public void setBesoinSecuriteCible(Integer besoinSecuriteCible) {
        this.besoinSecuriteCible = besoinSecuriteCible;
    }

    public Integer getProbabiliteCible() {
        return probabiliteCible;
    }

    public void setProbabiliteCible(Integer probabiliteCible) {
        this.probabiliteCible = probabiliteCible;
    }

    public Integer getGraviteCible() {
        return graviteCible;
    }

    public void setGraviteCible(Integer graviteCible) {
        this.graviteCible = graviteCible;
    }

    public Integer getNiveauRisqueCible() {
        return niveauRisqueCible;
    }

    public void setNiveauRisqueCible(Integer niveauRisqueCible) {
        this.niveauRisqueCible = niveauRisqueCible;
    }

    public String getOptionTraitementApres() {
        return optionTraitementApres;
    }

    public void setOptionTraitementApres(String optionTraitementApres) {
        this.optionTraitementApres = optionTraitementApres;
    }

    public String getCouleurStyle() {
        return couleurStyle;
    }

    public void setCouleurStyle(String couleurStyle) {
        this.couleurStyle = couleurStyle;
    }


}