package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.*;
import com.example.spring_ad_auth.repository.*;
import com.example.spring_ad_auth.service.AuditLogService;
import com.example.spring_ad_auth.service.RiskTableService;
import org.antlr.v4.runtime.misc.LogManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.UUID;

@Controller
@RequestMapping("/rssi")
public class GestionRisqueController {

    @Autowired
    private PerimetreRepository perimetreRepo;
    @Autowired private ActifRepository actifRepo;
    @Autowired private RisqueRepository risqueRepo;
    @Autowired private AuditLogService auditLogService;
    @Autowired private RegistreRisqueRepository registreRisqueRepository;

    @Autowired private TraitementRisqueRepository traitementRepo;
    @Autowired private RiskTableService riskTableService;

    // --- GESTION DES ACTIFS ---
    @GetMapping("/risk_editor")
    public String risk_editor(Model model) {
        model.addAttribute("actifs", actifRepo.findAll());
        model.addAttribute("perimetres", perimetreRepo.findAll());
        return "rssi/risk_editor";
    }

    // --- GESTION DES ACTIFS ---
    @GetMapping("/actifs")
    public String listActifs(Model model) {
        model.addAttribute("actifs", actifRepo.findAll());
        model.addAttribute("perimetres", perimetreRepo.findAll());
        return "rssi/actifs";
    }

/*    @PostMapping("/actifs/save")
    public String saveActif(@ModelAttribute Actif actif) {
        Actif saved = actifRepo.save(actif);
        auditLogService.log("Actif", saved.getId(), "INVENTAIRE");
        return "redirect:/rssi/actifs";
    }*/


    @PostMapping("/actifs/save")
    public String saveActif(
            @RequestParam("nom") String nom,
            @RequestParam("type") String type,
            @RequestParam("proprietaire") String proprietaire,
            @RequestParam("confidentialite") int confidentialite,
            @RequestParam("integrite") int integrite,
            @RequestParam("disponibilite") int disponibilite,
            @RequestParam("perimetreId") UUID perimetreId) { // UUID récupéré proprement

        try {
            Actif actif = new Actif();
            actif.setNom(nom);
            actif.setType(type);
            actif.setProprietaire(proprietaire);
            actif.setConfidentialite(confidentialite);
            actif.setIntegrite(integrite);
            actif.setDisponibilite(disponibilite);

            // Liaison avec le périmètre
            Perimetre p = perimetreRepo.findById(perimetreId).orElse(null);
            if (p == null) return "redirect:/rssi/actifs?error=perimetre_not_found";
            actif.setPerimetre(p);

            // Sauvegarde
            Actif saved = actifRepo.save(actif);

            // Audit Log
            auditLogService.log("Actif", saved.getId(), "INVENTAIRE_ACTIF");

            return "redirect:/rssi/actifs?success";
        } catch (Exception e) {
            return "redirect:/rssi/actifs?error=" + e.getMessage();
        }
    }

    // --- GESTION DES RISQUES ---
    @GetMapping("/risques")
    public String listRisques(Model model) {
        model.addAttribute("risques", risqueRepo.findAll());
        model.addAttribute("actifs", actifRepo.findAll());
        return "rssi/risques";
    }


    @PostMapping("/risques/save")
    public String saveRisque(@RequestParam UUID actifId,
                             @RequestParam String menace,
                             @RequestParam String vulnerabilite,
                             @RequestParam String origineMenace,
                             @RequestParam int impOrg,  // Nouveau : Impact Organisationnel
                             @RequestParam int impJur,  // Nouveau : Impact Juridique
                             @RequestParam int impImg,  // Nouveau : Impact Image
                             @RequestParam int impFin,  // Nouveau : Impact Financier
                             @RequestParam int vraisemblance,
                             @RequestParam int gravite) {

        // 1. Récupération de l'actif concerné
        Actif actif = actifRepo.findById(actifId)
                .orElseThrow(() -> new RuntimeException("Actif non trouvé"));

        RegistreRisque risque = new RegistreRisque();

        // 2. Informations générales (Contexte ISO/EBIOS)
        risque.setActifsConcernes(actif.getNom());
        risque.setProprietaireRisque(actif.getProprietaire());
        risque.setMenaces(menace);
        risque.setVulnerabilites(vulnerabilite);
        risque.setOrigine(origineMenace);

        // Génération automatique du scénario (Atelier 4 EBIOS)
        risque.setScenariosRisque("La source [" + origineMenace + "] exploite la faiblesse [" +
                vulnerabilite + "] causant [" + menace + "] sur l'actif " + actif.getNom());

        // 3. Stockage des valeurs CID de l'actif dans le risque (Instantané)
        risque.setValC(actif.getConfidentialite());
        risque.setValI(actif.getIntegrite());
        risque.setValD(actif.getDisponibilite());

        // 4. Stockage des impacts détaillés (Remplace impactInitial)
        risque.setImpOrg(impOrg);
        risque.setImpJur(impJur);
        risque.setImpImg(impImg);
        risque.setImpFin(impFin);

        // 5. CALCULS MÉTHODOLOGIQUES ISO 27005
        // Besoin de Sécurité Initial = MAX des scores de l'actif (C, I ou D)
        int maxCID = Math.max(risque.getValC(), Math.max(risque.getValI(), risque.getValD()));
        risque.setBesoinSecuriteInitial(maxCID);

        risque.setProbabiliteInitial(vraisemblance);
        risque.setGraviteInitial(gravite);

        // SCORE FINAL : Max(CID) * Probabilité * Gravité
        int scoreFinal = maxCID * vraisemblance * gravite;
        risque.setNiveauRisqueInitial(scoreFinal);

        // 6. Logique visuelle (Badge Couleur)
        // Seuil de danger : adapter selon votre grille (ex: max possible 4x5x5 = 100)
        if (scoreFinal >= 40) {
            risque.setCouleurStyle("bg-danger text-white");
        } else if (scoreFinal >= 15) {
            risque.setCouleurStyle("bg-warning text-dark");
        } else {
            risque.setCouleurStyle("bg-success text-white");
        }

        // 7. Champs techniques
        risque.setRef("RSK-" + (System.currentTimeMillis() % 10000));
        risque.setCategorie("AUTO"); // Catégorie par défaut pour les saisies web

        // 8. SAUVEGARDE EN BASE
        registreRisqueRepository.save(risque);

        // 9. SYNCHRONISATION AUTOMATIQUE VERS EXCEL
        try {
            riskTableService.syncDatabaseToExcel();
            System.out.println("✅ Synchro Excel effectuée après ajout du risque.");
        } catch (IOException e) {
            System.err.println("⚠️ Erreur synchro Excel : " + e.getMessage());
        }

        return "redirect:/rssi/risques?success";
    }


/*    @PostMapping("/risques/save")
    public String saveRisque(@RequestParam UUID actifId,
                             @RequestParam String menace,
                             @RequestParam String vulnerabilite, // AJOUT ISO 27005
                             @RequestParam String origineMenace, // AJOUT EBIOS RM
                             @RequestParam int impact,
                             @RequestParam int vraisemblance) {

        Actif actif = actifRepo.findById(actifId).orElseThrow();

        RegistreRisque risque = new RegistreRisque();

        // --- IDENTIFICATION (EBIOS Ateliers 3 & 4) ---
        risque.setActifsConcernes(actif.getNom());
        risque.setMenaces(menace);
        risque.setVulnerabilites(vulnerabilite); // Faiblesse technique
        risque.setOrigine(origineMenace);        // Qui attaque ? (Cybercriminel, Interne...)

        // Scénario opérationnel (EBIOS Workshop 4)
        String scenario = "Un " + origineMenace + " exploite " + vulnerabilite +
                " pour causer " + menace + " sur " + actif.getNom();
        risque.setScenariosRisque(scenario);

        // --- ÉVALUATION (ISO 27005) ---
        int valeurActif = Math.max(actif.getConfidentialite(),
                Math.max(actif.getIntegrite(), actif.getDisponibilite()));

        // Le niveau de risque prend en compte la valeur intrinsèque de l'actif
        // Formule recommandée : (Valeur Actif) + (Impact + Vraisemblance) ou Multiplication
        int scoreBase = (impact * vraisemblance);
        int niveauRisque = valeurActif * scoreBase;

        risque.setBesoinSecuriteInitial(valeurActif);
        risque.setImpactInitial(impact);
        risque.setProbabiliteInitial(vraisemblance);
        risque.setNiveauRisqueInitial(niveauRisque);

        // --- GRADUATION DES COULEURS (Matrice 5x5) ---
        if (niveauRisque > 30) {
            risque.setCouleurStyle("bg-danger text-white"); // Critique
        } else if (niveauRisque >= 15) {
            risque.setCouleurStyle("bg-warning text-dark"); // Significatif
        } else {
            risque.setCouleurStyle("bg-success text-white"); // Faible
        }

        risque.setRef("ISO-" + (System.currentTimeMillis() % 10000));
        registreRisqueRepository.save(risque);

        try {
            riskTableService.syncDatabaseToExcel();
        } catch (IOException e) {
            e.printStackTrace(); // Log l'erreur mais ne bloque pas l'utilisateur
        }

        return "redirect:/rssi/risques?success";
    }*/


/*    @PostMapping("/risques/save")
    public String saveRisque(@RequestParam UUID actifId,
                             @RequestParam String menace,
                             @RequestParam int impact,
                             @RequestParam int vraisemblance) {

        // 1. Récupération de l'actif pour le lier au registre
        Actif actif = actifRepo.findById(actifId)
                .orElseThrow(() -> new RuntimeException("Actif non trouvé"));

        RegistreRisque risque = new RegistreRisque();

        // 2. Mapping vers vos champs spécifiques
        risque.setMenaces(menace); // Champ "menaces" (TEXT)
        risque.setActifsConcernes(actif.getNom()); // Nom de l'actif
        risque.setProprietaireRisque(actif.getProprietaire()); // Propriétaire de l'actif

        // 3. Calcul du Besoin de Sécurité Initial (Max du CID de l'actif)
        int maxCID = Math.max(actif.getConfidentialite(),
                Math.max(actif.getIntegrite(), actif.getDisponibilite()));
        risque.setBesoinSecuriteInitial(maxCID);

        // 4. Appréciation du risque (Initial)
        risque.setImpactInitial(impact);
        risque.setProbabiliteInitial(vraisemblance);

        int score = impact * vraisemblance;
        risque.setGraviteInitial(score);
        risque.setNiveauRisqueInitial(score); // Le score calculé

        // 5. Champs techniques obligatoires
        risque.setRef("RSK-" + (System.currentTimeMillis() % 10000));
        risque.setCategorie("TECH"); // Catégorie par défaut

        // 6. Gestion de la couleur (Votre champ couleurStyle)
        if (score >= 15) {
            risque.setCouleurStyle("bg-danger text-white");
        } else if (score >= 8) {
            risque.setCouleurStyle("bg-warning text-dark");
        } else {
            risque.setCouleurStyle("bg-success text-white");
        }

        // Note : optionTraitement reste NULL ici, ce qui signifie "Non traité"

        registreRisqueRepository.save(risque);

        return "redirect:/rssi/risques";
    }*/

/*    @PostMapping("/risques/save")
    public String saveRisque(
            @RequestParam("menace") String menace,
            @RequestParam("impact") Integer impact,
            @RequestParam("vraisemblance") Integer vraisemblance,
            @RequestParam("actifId") UUID actifId) { // On récupère l'ID seul

        try {
            Risque risque = new Risque();
            risque.setMenace(menace);
            risque.setImpact(impact != null ? impact : 1);
            risque.setVraisemblance(vraisemblance != null ? vraisemblance : 1);

            // Calcul du score
            risque.setScore(risque.getImpact() * risque.getVraisemblance());
            risque.setStatut("IDENTIFIE");

            // Liaison avec l'Actif
            Actif actif = actifRepo.findById(actifId).orElse(null);
            if (actif == null) return "redirect:/rssi/risques?error=actif_not_found";
            risque.setActif(actif);

            // Sauvegarde
            Risque saved = risqueRepo.save(risque);

            // Log d'audit
            auditLogService.log("Risque", saved.getId(), "EVALUATION_RISQUE");

            return "redirect:/rssi/risques?success";
        } catch (Exception e) {
            e.printStackTrace(); // Regardez votre console pour voir l'erreur réelle
            return "redirect:/rssi/risques?error=500";
        }
    }*/

    @GetMapping("/perimetres")
    public String listPerimetres(Model model) {
        model.addAttribute("perimetres", perimetreRepo.findAll());
        return "rssi/perimetres";
    }

    @PostMapping("/perimetres/save")
    public String savePerimetre(@ModelAttribute Perimetre perimetre) {
        perimetreRepo.save(perimetre);
        auditLogService.log("Perimetre", perimetre.getId(), "CREATION");
        return "redirect:/rssi/perimetres";
    }

    // Afficher le formulaire de traitement pour un risque spécifique
    @GetMapping("/risques/traiter/{id}")
    public String formTraiter(@PathVariable UUID id, Model model) {
        RegistreRisque risque = risqueRepo.findById(id).orElseThrow();
        model.addAttribute("risque", risque);
        return "rssi/traitement_form";
    }

    @PostMapping("/risques/traiter/save")
    public String saveTraitementRisque(@RequestParam UUID risqueId,
                                       @RequestParam String strategie,
                                       @RequestParam String planTraitement,
                                       @RequestParam int efficaciteAttendue) { // 1 à 100%

        RegistreRisque risque = registreRisqueRepository.findById(risqueId).orElseThrow();

        // 1. Choix de la stratégie (ISO 27005)
        risque.setOptionTraitement(strategie);
        risque.setActionsTraitement(planTraitement);

        // 2. Calcul du RISQUE RÉSIDUEL (Ce qui reste après traitement)
        // Formule : Risque Initial * (1 - Efficacité des mesures)
        double reduction = (double) efficaciteAttendue / 100.0;
        int risqueResiduel = (int) (risque.getNiveauRisqueInitial() * (1 - reduction));

        risque.setNiveauRisqueCible(risqueResiduel);

        // 3. Changement d'état automatique (Workshop 5 EBIOS)
        if (risqueResiduel < 10) {
            risque.setOptionTraitementApres("ACCEPTE");
        } else {
            risque.setOptionTraitementApres("A_SURVEILLER");
        }

        registreRisqueRepository.save(risque);
        return "redirect:/rssi/risques";
    }

/*
    @PostMapping("/risques/traiter/save")
    public String saveTraitementRisque(@RequestParam UUID risqueId,
                                       @RequestParam String strategie,
                                       @RequestParam String planTraitement,
                                       @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateCible) {

        // 1. Récupérer le risque existant dans le registre
        RegistreRisque risque = registreRisqueRepository.findById(risqueId)
                .orElseThrow(() -> new RuntimeException("Risque non trouvé"));

        // 2. Mettre à jour les champs de traitement (selon votre entité RegistreRisque)
        risque.setOptionTraitement(strategie);     // ex: "Reduire", "Accepter"
        risque.setActionsTraitement(planTraitement); // Le texte détaillé

        // Note : Si vous n'avez pas de champ spécifique pour la dateCible dans l'entité,
        // vous pouvez concaténer la date dans les actions ou ajouter le champ à l'entité.
        // risque.setActionsTraitement(planTraitement + " (Échéance : " + dateCible + ")");

        // 3. Calculer le niveau cible (Optionnel - ISO 27005)
        // Souvent, on considère que le risque cible est réduit après traitement
        risque.setNiveauRisqueCible(risque.getNiveauRisqueInitial() / 2);

        // 4. Sauvegarder
        registreRisqueRepository.save(risque);

        // 5. Rediriger vers la liste
        return "redirect:/rssi/risques";
    }
*/

    // Enregistrer le traitement
/*    @PostMapping("/risques/traiter/save")
    public String saveTraitement(@RequestParam("risqueId") UUID risqueId,
                                 @ModelAttribute TraitementRisque traitement) {

        Risque risque = risqueRepo.findById(risqueId).orElseThrow();
        traitement.setRisque(risque);
        traitement.setStatut("A_FAIRE");

        traitementRepo.save(traitement);

        // On met à jour le statut du risque
        risque.setStatut("TRAITE");
        risqueRepo.save(risque);

        auditLogService.log("TraitementRisque", traitement.getId(), "DEFINITION_PLAN_TRAITEMENT");

        return "redirect:/rssi/risques";
    }*/
}