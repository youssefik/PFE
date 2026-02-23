package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.ClauseISO;
import com.example.spring_ad_auth.model.Controle;
import com.example.spring_ad_auth.repository.ClauseISORepository;
import com.example.spring_ad_auth.repository.ControleRepository;
import com.example.spring_ad_auth.repository.JournalAuditRepository;
import com.example.spring_ad_auth.service.AuditLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class ReferentielController {

    @Autowired private ClauseISORepository clauseRepo;
    @Autowired private ControleRepository controleRepo;
    @Autowired private JournalAuditRepository auditRepo;
    @Autowired private AuditLogService auditLogService;

    // Gestion des Clauses
    @GetMapping("/clauses")
    public String listClauses(Model model) {
        model.addAttribute("clauses", clauseRepo.findAll());
        return "admin/clauses";
    }

    @PostMapping("/clauses/save")
    public String saveClause(@ModelAttribute ClauseISO clause) {
        ClauseISO saved = clauseRepo.save(clause);
        auditLogService.log("ClauseISO", saved.getId(), "CREATION/MODIF");
        return "redirect:/admin/clauses";
    }

    // Gestion des Contrôles
    @GetMapping("/controles")
    public String listControles(Model model) {
        model.addAttribute("controles", controleRepo.findAll());
        model.addAttribute("clauses", clauseRepo.findAll()); // Pour le menu déroulant
        return "admin/controles";
    }

    @PostMapping("/controles/save")
    public String saveControle(@ModelAttribute Controle controle) {
        Controle saved = controleRepo.save(controle);
        auditLogService.log("Controle", saved.getId(), "CREATION/MODIF");
        return "redirect:/admin/controles";
    }

    // Journal d'Audit
    @GetMapping("/audit-log")
    public String viewLogs(Model model) {
        model.addAttribute("logs", auditRepo.findAll());
        return "admin/audit_logs";
    }
}