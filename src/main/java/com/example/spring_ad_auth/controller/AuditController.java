package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.*;
import com.example.spring_ad_auth.repository.*;
import com.example.spring_ad_auth.service.AuditLogService;
import com.example.spring_ad_auth.service.ImprovementService;
import jakarta.transaction.Transactional;
import org.antlr.v4.runtime.tree.pattern.ParseTreePattern;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/audit")
public class AuditController {

    @Autowired private AuditRepository auditRepo;
    @Autowired private ElementSoARepository soaRepo;
    @Autowired private ConstatRepository constatRepo;
    @Autowired private AuditLogService auditLogService;
    @Autowired private ControleRepository controleRepo;

    @Autowired private NonConformiteRepository ncRepo;
    @Autowired private ActionCorrectiveRepository actionRepo;
    @Autowired private ClauseISORepository clauseRepo;
    @Autowired private  ImprovementService improvementService;
    ;

    @PostMapping("/action/cloturer/{id}")
    public String closeAction(@PathVariable UUID id) {
        // 1. Récupérer l'action concernée
        ActionCorrective action = actionRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Action non trouvée"));

        // 2. Changer le statut
        action.setStatut("TERMINE");

        // 3. Sauvegarder
        actionRepo.save(action);

        // 4. Logger l'action (ISO 27001 : preuve de clôture)
        auditLogService.log("ActionCorrective", id, "CLOTURE_ACTION");

        return "redirect:/audit/actions-correctives";
    }


    // 1. Liste des audits programmés (URL: /audit/missions)

    @GetMapping("/missions")
    public String listMissions(Model model) {
        model.addAttribute("audits", auditRepo.findAll());

        // Proposition automatique date de fin = aujourd'hui + 7 jours
        model.addAttribute("defaultDateFin", LocalDate.now().plusWeeks(1));
        return "audit/missions";
    }

/*    @GetMapping("/realiser/{id}")
    public String conductAudit(@PathVariable UUID id, Model model) {
        Audit audit = auditRepo.findById(id).orElseThrow();

        model.addAttribute("audit", audit);
        // Onglet Annexe A : Uniquement les contrôles APPLICABLES du SoA
        model.addAttribute("soaApplicables", soaRepo.findAll().stream().filter(ElementSoA::isApplicable).toList());
        // Onglet Clauses 4-10 : Tous les chapitres normatifs

        model.addAttribute("clausesList", clauseRepo.findAll());

        return "audit/realiser_checklist";
    }*/


    @GetMapping("/realiser/{id}")
    public String conductAudit(@PathVariable UUID id, Model model) {
        Audit audit = auditRepo.findById(id).orElseThrow();

        // Charger simplement les données
        model.addAttribute("audit", audit);
        model.addAttribute("constats", audit.getConstats()); // Liste des résultats déjà saisis

        // Séparer les parents des sous-clauses pour l'affichage
        model.addAttribute("parentChapters", clauseRepo.findAllByParentIsNull());
        model.addAttribute("subClausesList", clauseRepo.findAllByParentIsNotNull());

        // Annexe A
        model.addAttribute("soaApplicables", soaRepo.findAll().stream()
                .filter(e -> e.isApplicable()).toList());

        return "audit/realiser_checklist";
    }

/*
    @GetMapping("/realiser/{id}")
*/
/*
    public String conductAudit(@PathVariable UUID id, Model model) {
        Audit audit = auditRepo.findById(id).orElseThrow();

        // 1. Initialisation des conteneurs en String pour JSTL
        Map<String, String> processedTypesMap = new HashMap<>();
        List<String> auditedClauseIds = new ArrayList<>();
        List<String> auditedControleIds = new ArrayList<>();

        // 2. Remplissage des données traitées
        for (Constat c : audit.getConstats()) {
            if (c.getClauseIso() != null) {
                String cid = c.getClauseIso().getId().toString();
                auditedClauseIds.add(cid);
                processedTypesMap.put(cid, c.getType()); // ex: "Conforme", "NC Majeur"
            }
            if (c.getControle() != null) {
                String ctrlId = c.getControle().getId().toString();
                auditedControleIds.add(ctrlId);
                processedTypesMap.put(ctrlId, "TRAITÉ");
            }
        }

        model.addAttribute("audit", audit);
        model.addAttribute("auditedClauseIds", auditedClauseIds);
        model.addAttribute("auditedControleIds", auditedControleIds);
        model.addAttribute("processedTypesMap", processedTypesMap);

        // 3. Charger les référentiels
        model.addAttribute("parentChapters", clauseRepo.findAllByParentIsNull());
        model.addAttribute("subClausesList", clauseRepo.findAllByParentIsNotNull());
        model.addAttribute("soaApplicables", soaRepo.findAll().stream()
                .filter(e -> e.isApplicable() && e.getControle() != null).toList());

        return "audit/realiser_checklist";
    }
*/

    @PostMapping("/constat/save")
    public String saveConstat(@RequestParam String source,
                              @RequestParam UUID auditId,
                              @RequestParam(required = false) UUID clauseId,
                              @RequestParam(required = false) UUID controleId,
                              @ModelAttribute Constat constat) {

        // 1. Récupérer l'audit parent
        Audit audit = auditRepo.findById(auditId)
                .orElseThrow(() -> new RuntimeException("Audit introuvable"));
        constat.setAudit(audit);
        constat.setSource(source);

        // 2. Lier le constat selon la provenance
        if ("CLAUSE".equals(source) && clauseId != null) {
            ClauseISO clause = clauseRepo.findById(clauseId)
                    .orElseThrow(() -> new RuntimeException("Sous-clause introuvable"));
            constat.setClauseIso(clause);
            // Sécurité : on s'assure que le champ contrôle est nul
            constat.setControle(null);
        }
        else if ("ANNEXE_A".equals(source) && controleId != null) {
            Controle controle = controleRepo.findById(controleId)
                    .orElseThrow(() -> new RuntimeException("Contrôle Annexe A introuvable"));
            constat.setControle(controle);
            // Sécurité : on s'assure que le champ clause est nul
            constat.setClauseIso(null);
        }

        // 3. Sauvegarde
        constatRepo.save(constat);

        // 4. Logique de journalisation (Indispensable pour l'audit SMSI)
        auditLogService.log("Constat", constat.getId(), "EVALUATION_" + source);

        // 5. Redirection avec l'ID pour le scroll automatique JavaScript
        // On nettoie l'ID de toute fioriture pour qu'il matche exactement avec le HTML
        String lastId = (clauseId != null) ? clauseId.toString() : (controleId != null ? controleId.toString() : "");

        return "redirect:/audit/realiser/" + auditId + "?lastProcessedId=" + lastId;
    }

/*    @GetMapping("/missions")
    public String listMissions(Model model) {
        model.addAttribute("audits", auditRepo.findAll());
        return "audit/missions"; // Doit exister: /WEB-INF/views/audit/missions.jsp
    }*/

    // --- FIX : MÉTHODE AJOUTÉE POUR CRÉER L'AUDIT ---
    @PostMapping("/save")
    public String saveAudit(@ModelAttribute Audit audit) {
        // Règle métier : Date fin = Date début + 7 jours par défaut
        if (audit.getDateDebut() != null) {
            audit.setDateFin(audit.getDateDebut().plusWeeks(1));
        }
        audit.setStatut("PLANIFIE");
        auditRepo.save(audit);
        return "redirect:/audit/missions";
    }

    @Transactional
    @PostMapping("/constat/supprimer")
    public String deleteConstat(@RequestParam UUID auditId,
                                @RequestParam(required = false) UUID clauseId,
                                @RequestParam(required = false) UUID controleId) {

        Optional<Constat> constatOpt = Optional.empty();

        // 1. Recherche du constat (dépend de la provenance : Clause ou Annexe A)
        if (clauseId != null) {
            constatOpt = constatRepo.findByAuditIdAndClauseIsoId(auditId, clauseId);
        } else if (controleId != null) {
            constatOpt = constatRepo.findByAuditIdAndControleId(auditId, controleId);
        }

        // 2. Exécution de la suppression
        if (constatOpt.isPresent()) {
            Constat toDelete = constatOpt.get();

            // Log d'audit (Preuve de modification du registre d'audit pour l'ISO)
            auditLogService.log("Constat", toDelete.getId(), "DELETE_AND_RESET_CHECKLIST");

            // On supprime le constat.
            // Grâce au 'orphanRemoval = true' dans l'entité,
            // la NonConformite et les ActionsCorrectives disparaîtront aussi !
            constatRepo.delete(toDelete);

            System.out.println(">>> [Audit] Reset réussi pour l'élément lié à l'ID : " + (clauseId != null ? clauseId : controleId));
        }

        return "redirect:/audit/realiser/" + auditId;
    }

/*    @GetMapping("/resultats/{id}")
    public String viewAuditResults(@PathVariable UUID id, Model model) {
        Audit audit = auditRepo.findById(id).orElseThrow();
        // Séparer les constats par type de contrôle (Regex pour détecter Annexe A ex: A.5.1)
        List<Constat> constatsAnnexe = audit.getConstats().stream()
                .filter(c -> c.getControle().getCode().startsWith("A.")).toList();
        List<Constat> constatsClauses = audit.getConstats().stream()
                .filter(c -> !c.getControle().getCode().startsWith("A.")).toList();

        model.addAttribute("audit", audit);
        model.addAttribute("resAnnexe", constatsAnnexe);
        model.addAttribute("resClauses", constatsClauses);
        return "audit/resultats";
    }*/
/*    @PostMapping("/save")
    public String saveAudit(@ModelAttribute Audit audit) {
        audit.setStatut("PLANIFIE");
        Audit saved = auditRepo.save(audit);
        auditLogService.log("Audit", saved.getId(), "PLANIFICATION_AUDIT");
        return "redirect:/audit/missions";
    }*/

    // 2. Interface de réalisation de l'audit (Checklist)
/*    @GetMapping("/realiser/{id}")
    public String conductAudit(@PathVariable UUID id, Model model) {
        Audit audit = auditRepo.findById(id).orElseThrow(() -> new RuntimeException("Audit non trouvé"));

        // On ne propose à l'audit que les points déclarés "Applicables" dans le SoA
        List<ElementSoA> applicableControls = soaRepo.findAll().stream()
                .filter(ElementSoA::isApplicable)
                .toList();

        model.addAttribute("audit", audit);
        model.addAttribute("soaList", applicableControls);
        return "audit/realiser_checklist";
    }*/

    // 3. Enregistrer un constat
/*    @PostMapping("/constat/save")
    public String saveConstat(@RequestParam("auditId") UUID auditId,
                              @RequestParam(value = "controleId", required = false) UUID ctrlId, // Facultatif
                              @RequestParam(value = "clauseId", required = false) UUID clauseId, // Facultatif
                              @RequestParam("source") String source,
                              @ModelAttribute Constat constat) {

        // 1. On récupère l'audit (Toujours obligatoire)
        Audit audit = auditRepo.findById(auditId)
                .orElseThrow(() -> new RuntimeException("Audit non trouvé"));
        constat.setAudit(audit);
        constat.setSource(source);

        // 2. Gestion si c'est une ANNEXE_A
        if ("ANNEXE_A".equals(source) && ctrlId != null) {
            Controle controle = controleRepo.findById(ctrlId)
                    .orElseThrow(() -> new RuntimeException("Contrôle technique non trouvé"));
            constat.setControle(controle);
            // On s'assure que la clause n'est pas liée
            constat.setClauseIso(null);
        }

        // 3. Gestion si c'est une CLAUSE 4-10
        else if ("CLAUSE".equals(source) && clauseId != null) {
            ClauseISO clause = clauseRepo.findById(clauseId) // Remplacez par votre repo exact
                    .orElseThrow(() -> new RuntimeException("Chapitre normatif non trouvé"));
            constat.setClauseIso(clause);
            // On s'assure que le contrôle n'est pas lié
            constat.setControle(null);
        }

        // 4. Sauvegarde finale
        Constat saved = constatRepo.save(constat);
        auditLogService.log("Constat", saved.getId(), "NOUVEAU_CONSTAT_" + source);

        // On renvoie l'ID de l'élément traité pour que le script JS scrolle vers le suivant
        String lastId = (source.equals("CLAUSE")) ? clauseId.toString() : ctrlId.toString();

        return "redirect:/audit/realiser/" + auditId + "?lastProcessedId=" + lastId;
    }*/


/*    @PostMapping("/constat/save")
    public String saveConstat(@RequestParam("auditId") UUID auditId,
                              @RequestParam("controleId") UUID ctrlId,
                              @ModelAttribute Constat constat) {
        Audit audit = auditRepo.findById(auditId).orElseThrow();
        // RECUPERATION ET LIEN DU CONTROLE (Crucial pour le rapport d'audit)
        Controle controle = controleRepo.findById(ctrlId).orElseThrow();

        constat.setAudit(audit);
        constat.setControle(controle); // Liaison réelle

        Constat saved = constatRepo.save(constat);
        auditLogService.log("Constat", saved.getId(), "AJOUT_CONSTAT_AUDIT");

        return "redirect:/audit/realiser/" + auditId;
    }*/
/*    @PostMapping("/constat/save")
    public String saveConstat(@RequestParam("auditId") UUID auditId,
                              @RequestParam("controleId") UUID ctrlId,
                              @ModelAttribute Constat constat) {
        Audit audit = auditRepo.findById(auditId).orElseThrow();
        constat.setAudit(audit);
        // Ici on pourrait aussi lier le constat au Controle s'il y a un champ dédié

        Constat saved = constatRepo.save(constat);
        auditLogService.log("Constat", saved.getId(), "AJOUT_CONSTAT_AUDIT");

        return "redirect:/audit/realiser/" + auditId;
    }*/


    @GetMapping("/actions-correctives")
    public String listActions(Model model) {
        // 1. Récupérer toutes les NC et les diviser par source
        List<NonConformite> allNcs = ncRepo.findAll();
        model.addAttribute("ncsClauses", allNcs.stream()
                .filter(n -> "CLAUSE".equals(n.getConstat().getSource())).toList());
        model.addAttribute("ncsAnnexe", allNcs.stream()
                .filter(n -> "ANNEXE_A".equals(n.getConstat().getSource())).toList());

        // 2. Récupérer les Constats en attente (exclure les conformes / maturité élevée)
        List<Constat> constatsEnAttente = constatRepo.findAll().stream()
                .filter(c -> {
                    // On ne traite pas un constat déjà transformé en NC officielle
                    if (c.getNonConformite() != null) return false;

                    if ("CLAUSE".equals(c.getSource())) {
                        return c.getType() != null && !"Conforme".equals(c.getType());
                    } else {
                        return c.getNiveauMaturite() != null
                                && !c.getNiveauMaturite().contains("4")
                                && !c.getNiveauMaturite().contains("5")
                                && !"Non applicable".equals(c.getNiveauMaturite());
                    }
                }).toList();

        model.addAttribute("constatsClausesPending", constatsEnAttente.stream()
                .filter(c -> "CLAUSE".equals(c.getSource())).toList());
        model.addAttribute("constatsAnnexePending", constatsEnAttente.stream()
                .filter(c -> "ANNEXE_A".equals(c.getSource())).toList());

        return "audit/actions_correctives";
    }

    /*@GetMapping("/actions-correctives")
    public String listActions(Model model) {
        // 1. Récupérer toutes les NC existantes
        model.addAttribute("ncs", ncRepo.findAll());

        // 2. Récupérer les Constats qui ne sont pas encore transformés en NC
        // Filtrer pour exclure les constats de type "Conforme"
        *//*List<Constat> constatsSansConforme = constatRepo.findAll().stream()
                .filter(c -> c.getType() != null && !"Conforme".equals(c.getType()))
                .collect(Collectors.toList());*//*
        List<Constat> constatsSansConforme = constatRepo.findAll().stream()
                .filter(c -> {
                    if (c.getType() != null) {
                        return !"Conforme".equals(c.getType());
                    } else {
                        // Pour Annexe A, on exclut les niveaux 4,5 et "Non applicable" si souhaité
                        return c.getNiveauMaturite() != null
                                && !c.getNiveauMaturite().contains("4")
                                && !c.getNiveauMaturite().contains("5")
                                && !"Non applicable".equals(c.getNiveauMaturite());
                    }
                })
                .collect(Collectors.toList());
        model.addAttribute("constatsEnAttente", constatsSansConforme);

        return "audit/actions_correctives";
    }*/



/*    // 1. Liste globale des Non-Conformités et Actions Correctives
    @GetMapping("/actions-correctives")
    public String listActions(Model model) {
        // 1. Récupérer toutes les NC existantes
        model.addAttribute("ncs", ncRepo.findAll());

        // 2. Récupérer les Constats qui ne sont pas encore transformés en NC
        // (Pour simplifier ici, on envoie tous les constats de type NC)
        model.addAttribute("constatsEnAttente", constatRepo.findAll());

        return "audit/actions_correctives";
    }*/


    // 2. Transformer un constat en Non-Conformité officielle
    @PostMapping("/constat/valider-nc")
    public String validateNC(@RequestParam("constatId") UUID constatId,
                             @RequestParam("reference") String ref,
                             @RequestParam("cause") String cause) {
        Constat constat = constatRepo.findById(constatId).orElseThrow();

        NonConformite nc = new NonConformite();
        nc.setConstat(constat);
        nc.setReference(ref);
        nc.setCauseRacine(cause);
        ncRepo.save(nc);

        auditLogService.log("NonConformite", nc.getId(), "CREATION_NC");
        return "redirect:/audit/actions-correctives";
    }

    // 3. Ajouter une action corrective à une NC

    @PostMapping("/action/save")
    public String saveAction(@RequestParam UUID ncId, @ModelAttribute ActionCorrective action) {
        // 1. Enregistrement dans le module Audit
        NonConformite nc = ncRepo.findById(ncId).orElseThrow();
        action.setNonConformite(nc);
        action.setStatut("A_FAIRE");
        ActionCorrective savedAction = actionRepo.save(action);

        // 2. TRANSFERT AUTOMATIQUE VERS LE JOURNAL D'AMÉLIORATION
        improvementService.addActionFromAudit(savedAction);

        return "redirect:/audit/actions-correctives?success=true";
    }
/*    @PostMapping("/action/save")
    public String saveAction(@RequestParam("ncId") UUID ncId, @ModelAttribute ActionCorrective action) {
        NonConformite nc = ncRepo.findById(ncId).orElseThrow();
        action.setNonConformite(nc);
        action.setStatut("A_FAIRE");
        actionRepo.save(action);

        return "redirect:/audit/actions-correctives";
    }*/


    @GetMapping("/resultat/{id}")
    public String viewAuditResult(@PathVariable UUID id, Model model) {
        Audit audit = auditRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Audit non trouvé"));

        // Récupérer tous les constats de cet audit
        List<Constat> tousLesConstats = constatRepo.findByAuditId(id);

        // Séparer les résultats pour les deux onglets
        List<Constat> resultatsClauses = tousLesConstats.stream()
                .filter(c -> "CLAUSE".equals(c.getSource())).toList();

        List<Constat> resultatsAnnexeA = tousLesConstats.stream()
                .filter(c -> "ANNEXE_A".equals(c.getSource())).toList();

        model.addAttribute("audit", audit);
        model.addAttribute("resultatsClauses", resultatsClauses);
        model.addAttribute("resultatsAnnexeA", resultatsAnnexeA);

        return "audit/audit_resultat";
    }
}