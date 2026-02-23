package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.Controle;
import com.example.spring_ad_auth.model.ElementSoA;
import com.example.spring_ad_auth.repository.ControleRepository;
import com.example.spring_ad_auth.repository.ElementSoARepository;
import com.example.spring_ad_auth.repository.PreuveRepository;
import com.example.spring_ad_auth.service.AuditLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/compliance")
public class ComplianceController {

    @Autowired
    private ControleRepository controleRepo;
    @Autowired private ElementSoARepository soaRepo;
    @Autowired private PreuveRepository preuveRepo;
    @Autowired private AuditLogService auditLogService;

    // Affiche la Déclaration d'Applicabilité (SoA)
    @GetMapping("/soa")
    public String viewSoA(Model model) {
        // Logique : si un contrôle n'a pas encore d'élément SoA, on pourrait le créer ici
        List<Controle> allControles = controleRepo.findAll();
        model.addAttribute("controles", allControles);
        model.addAttribute("soaElements", soaRepo.findAll());
        return "compliance/soa";
    }

    // Mettre à jour le statut d'un contrôle dans le SoA
    @PostMapping("/soa/update")
    public String updateSoA(@RequestParam("controleId") UUID ctrlId,
                            @RequestParam("applicable") boolean applicable,
                            @RequestParam("statut") String statut,
                            @RequestParam("justification") String justification) {

        Controle ctrl = controleRepo.findById(ctrlId).orElseThrow();

        // Chercher l'élément SoA existant ou en créer un nouveau
        ElementSoA soa = soaRepo.findAll().stream()
                .filter(e -> e.getControle().getId().equals(ctrlId))
                .findFirst().orElse(new ElementSoA());

        soa.setControle(ctrl);
        soa.setApplicable(applicable);
        soa.setStatutMiseEnOeuvre(statut);
        soa.setJustification(justification);
        soa.setDateDerniereRevue(LocalDate.now());

        soaRepo.save(soa);
        auditLogService.log("ElementSoA", soa.getId(), "MISE_A_JOUR_CONFORMITE");

        return "redirect:/compliance/soa";
    }
}