package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "registre_risques")
public class RegistreRisque {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String categorie;
    private String ref;
    @Column(columnDefinition = "TEXT")
    private String menaces;
    private String origine;
    private String actifsConcernes;
//    private String proprietaireRisque;
    @Column(columnDefinition = "TEXT")
    private String scenariosRisque;
    @Column(columnDefinition = "TEXT")
    private String vulnerabilites;
    @Column(columnDefinition = "TEXT")
    private String mesuresExistantes;

    // --- AJOUT DES COLONNES MANQUANTES ---
    private int valD; // Disponibilité
    private int valI; // Intégrité
    private int valC; // Confidentialité

    private int impOrg; // Impact Organisationnel
    private int impJur; // Juridique
    private int impImg; // Image
    private int impFin; // Financier
    // --------------------------------------

    private int besoinSecuriteInitial;
    private int probabiliteInitial;
    private int graviteInitial;
    private int niveauRisqueInitial;

    private String optionTraitement;
    @Column(columnDefinition = "TEXT")
    private String actionsTraitement;

    private int besoinSecuriteCible;
    private int probabiliteCible;
    private int graviteCible;
    private int niveauRisqueCible;
    private String optionTraitementApres;

    private String couleurStyle;

    // ... Générez les Getters et Setters pour les nouveaux champs ...


    public UUID getId() {
        return id;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public String getRef() {
        return ref;
    }

    public void setRef(String ref) {
        this.ref = ref;
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
//
//    public String getProprietaireRisque() {
//        return proprietaireRisque;
//    }
//
//    public void setProprietaireRisque(String proprietaireRisque) {
//        this.proprietaireRisque = proprietaireRisque;
//    }

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

    public int getValD() {
        return valD;
    }

    public void setValD(int valD) {
        this.valD = valD;
    }

    public int getValI() {
        return valI;
    }

    public void setValI(int valI) {
        this.valI = valI;
    }

    public int getValC() {
        return valC;
    }

    public void setValC(int valC) {
        this.valC = valC;
    }

    public int getImpOrg() {
        return impOrg;
    }

    public void setImpOrg(int impOrg) {
        this.impOrg = impOrg;
    }

    public int getImpJur() {
        return impJur;
    }

    public void setImpJur(int impJur) {
        this.impJur = impJur;
    }

    public int getImpImg() {
        return impImg;
    }

    public void setImpImg(int impImg) {
        this.impImg = impImg;
    }

    public int getImpFin() {
        return impFin;
    }

    public void setImpFin(int impFin) {
        this.impFin = impFin;
    }

    public int getBesoinSecuriteInitial() {
        return besoinSecuriteInitial;
    }

    public void setBesoinSecuriteInitial(int besoinSecuriteInitial) {
        this.besoinSecuriteInitial = besoinSecuriteInitial;
    }

    public int getProbabiliteInitial() {
        return probabiliteInitial;
    }

    public void setProbabiliteInitial(int probabiliteInitial) {
        this.probabiliteInitial = probabiliteInitial;
    }

    public int getGraviteInitial() {
        return graviteInitial;
    }

    public void setGraviteInitial(int graviteInitial) {
        this.graviteInitial = graviteInitial;
    }

    public int getNiveauRisqueInitial() {
        return niveauRisqueInitial;
    }

    public void setNiveauRisqueInitial(int niveauRisqueInitial) {
        this.niveauRisqueInitial = niveauRisqueInitial;
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

    public int getBesoinSecuriteCible() {
        return besoinSecuriteCible;
    }

    public void setBesoinSecuriteCible(int besoinSecuriteCible) {
        this.besoinSecuriteCible = besoinSecuriteCible;
    }

    public int getProbabiliteCible() {
        return probabiliteCible;
    }

    public void setProbabiliteCible(int probabiliteCible) {
        this.probabiliteCible = probabiliteCible;
    }

    public int getGraviteCible() {
        return graviteCible;
    }

    public void setGraviteCible(int graviteCible) {
        this.graviteCible = graviteCible;
    }

    public int getNiveauRisqueCible() {
        return niveauRisqueCible;
    }

    public void setNiveauRisqueCible(int niveauRisqueCible) {
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

/*@Entity
@Table(name = "registre_risques")
public class RegistreRisque {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String categorie; // 1-Sinistres physiques (PHY)
    private String ref;       // PHY-1
    @Column(columnDefinition = "TEXT")
    private String menaces;
    private String origine;           // EBIOS: Source de la menace
    private String actifsConcernes;
    private String proprietaireRisque;

    @Column(columnDefinition = "TEXT")
    private String scenariosRisque;
    @Column(columnDefinition = "TEXT")
    private String vulnerabilites;     // ISO 27005: Faiblesses exploitables
    @Column(columnDefinition = "TEXT")
    private String mesuresExistantes;

    // --- APPRÉCIATION (INITIAL) ---
    private int besoinSecuriteInitial; // Max(CID)
    private int impactInitial;         // Conséquence métier
    private int probabiliteInitial;    // Vraisemblance
    private int graviteInitial;
    private int niveauRisqueInitial; // Score (Calculé)

    private String optionTraitement; // Réduire, Accepter...
    @Column(columnDefinition = "TEXT")
    private String actionsTraitement;

    // --- TRAITEMENT (CIBLE) ---
    private int besoinSecuriteCible;
    private int probabiliteCible;
    private int graviteCible;
    private int niveauRisqueCible;     // Risque Résiduel calculé
    private String optionTraitementApres;

    // Style graphique stocké en BD uniquement
    private String couleurStyle;

    // Getters et Setters (indispensables pour JPA et JSON)
    // ...



    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public String getRef() {
        return ref;
    }

    public void setRef(String ref) {
        this.ref = ref;
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

    public int getBesoinSecuriteInitial() {
        return besoinSecuriteInitial;
    }

    public void setBesoinSecuriteInitial(int besoinSecuriteInitial) {
        this.besoinSecuriteInitial = besoinSecuriteInitial;
    }

    public int getImpactInitial() {
        return impactInitial;
    }

    public void setImpactInitial(int impactInitial) {
        this.impactInitial = impactInitial;
    }

    public int getProbabiliteInitial() {
        return probabiliteInitial;
    }

    public void setProbabiliteInitial(int probabiliteInitial) {
        this.probabiliteInitial = probabiliteInitial;
    }

    public int getGraviteInitial() {
        return graviteInitial;
    }

    public void setGraviteInitial(int graviteInitial) {
        this.graviteInitial = graviteInitial;
    }

    public int getNiveauRisqueInitial() {
        return niveauRisqueInitial;
    }

    public void setNiveauRisqueInitial(int niveauRisqueInitial) {
        this.niveauRisqueInitial = niveauRisqueInitial;
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

    public int getBesoinSecuriteCible() {
        return besoinSecuriteCible;
    }

    public void setBesoinSecuriteCible(int besoinSecuriteCible) {
        this.besoinSecuriteCible = besoinSecuriteCible;
    }

    public int getProbabiliteCible() {
        return probabiliteCible;
    }

    public void setProbabiliteCible(int probabiliteCible) {
        this.probabiliteCible = probabiliteCible;
    }

    public int getGraviteCible() {
        return graviteCible;
    }

    public void setGraviteCible(int graviteCible) {
        this.graviteCible = graviteCible;
    }

    public int getNiveauRisqueCible() {
        return niveauRisqueCible;
    }

    public void setNiveauRisqueCible(int niveauRisqueCible) {
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

    public UUID getId() {
        return id;
    }

}*/
