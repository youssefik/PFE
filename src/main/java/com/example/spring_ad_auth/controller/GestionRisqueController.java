package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.Actif;
import com.example.spring_ad_auth.model.Perimetre;
import com.example.spring_ad_auth.model.Risque;
import com.example.spring_ad_auth.model.TraitementRisque;
import com.example.spring_ad_auth.repository.ActifRepository;
import com.example.spring_ad_auth.repository.PerimetreRepository;
import com.example.spring_ad_auth.repository.RisqueRepository;
import com.example.spring_ad_auth.repository.TraitementRisqueRepository;
import com.example.spring_ad_auth.service.AuditLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@Controller
@RequestMapping("/rssi")
public class GestionRisqueController {

    @Autowired
    private PerimetreRepository perimetreRepo;
    @Autowired private ActifRepository actifRepo;
    @Autowired private RisqueRepository risqueRepo;
    @Autowired private AuditLogService auditLogService;

    @Autowired private TraitementRisqueRepository traitementRepo;

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
    }

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
        Risque risque = risqueRepo.findById(id).orElseThrow();
        model.addAttribute("risque", risque);
        return "rssi/traitement_form";
    }

    // Enregistrer le traitement
    @PostMapping("/risques/traiter/save")
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
    }
}