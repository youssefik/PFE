package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.Controle;
import com.example.spring_ad_auth.model.ElementSoA;
import com.example.spring_ad_auth.repository.ControleRepository;
import com.example.spring_ad_auth.repository.ElementSoARepository;
import com.example.spring_ad_auth.repository.PreuveRepository;
import com.example.spring_ad_auth.repository.SignatureRepository;
import com.example.spring_ad_auth.service.AuditLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.*;

@Controller
@RequestMapping("/compliance")
public class ComplianceController {

    @Autowired
    private ControleRepository controleRepo;
    @Autowired private ElementSoARepository soaRepo;
    @Autowired private PreuveRepository preuveRepo;
    @Autowired private AuditLogService auditLogService;
    @Autowired private SignatureRepository signatureRepo;

    // Affiche la Déclaration d'Applicabilité (SoA)
/*    @GetMapping("/soa")
    public String viewSoA(Model model) {
        List<Controle> allPossibleControls = controleRepo.findAll();
        List<ElementSoA> soaElements = soaRepo.findAll();

        // 1. Taux d'applicabilité (Applicables / Total Annexe A)
        long countApplicable = soaElements.stream().filter(ElementSoA::isApplicable).count();
        double tauxApplicabilite = allPossibleControls.isEmpty() ? 0 :
                (double) countApplicable / allPossibleControls.size() * 100;

        // 2. Taux de conformité (Conformes / Applicables)
        long countConforme = soaElements.stream()
                .filter(e -> e.isApplicable() && "Oui".equalsIgnoreCase(e.getStatutMiseEnOeuvre()))
                .count();
        double tauxConformite = countApplicable == 0 ? 0 :
                (double) countConforme / countApplicable * 100;

        // 3. Nombre de preuves
        long totalPreuves = preuveRepo.count();

        model.addAttribute("tauxApplicabilite", Math.round(tauxApplicabilite));
        model.addAttribute("tauxConformite", Math.round(tauxConformite));
        model.addAttribute("totalPreuves", totalPreuves);

        return "compliance/soa";
    }*/
    @GetMapping("/soa")
    public String viewSoA(Model model) {
        List<Controle> controles = controleRepo.findAll();
        List<ElementSoA> soaElements = soaRepo.findAll();

        // 1. On compte les contrôles marqués comme APPLICABLES (OUI)
        long countApplicable = soaElements.stream()
                .filter(ElementSoA::isApplicable)
                .count();

        // 2. CORRECTION : On accepte "Oui" ou "CONFORME" (insensible à la casse)
        long countConforme = soaElements.stream()
                .filter(e -> e.isApplicable() && (
                        "Oui".equalsIgnoreCase(e.getStatutMiseEnOeuvre()) ||
                                "CONFORME".equalsIgnoreCase(e.getStatutMiseEnOeuvre())
                ))
                .count();

        // 3. Calcul du pourcentage
        int percentConforme = 0;
        if (countApplicable > 0) {
            // On multiplie par 100.0 pour forcer le calcul en nombre flottant avant de repasser en int
            percentConforme = (int) ((double) countConforme / countApplicable * 100);
        }

        Map<String, Object> stats = new HashMap<>();
        stats.put("percentApplicable", (controles.isEmpty()) ? 0 : (countApplicable * 100 / controles.size()));
        stats.put("percentConforme", percentConforme);
        stats.put("countPreuves", preuveRepo.count());

        model.addAttribute("stats", stats);
        model.addAttribute("controles", controles);
        model.addAttribute("soaElements", soaElements);
        model.addAttribute("signatures", signatureRepo.findByEntityTypeAndEntityIdOrderByDateSignatureDesc("SOA", null));

        return "compliance/soa";
    }


/*    @GetMapping("/soa")
    public String viewSoA(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();

        // 1. Envoyer les données du SoA
        model.addAttribute("controles", controleRepo.findAll());
        model.addAttribute("soaElements", soaRepo.findAll());

        // 2. Envoyer l'historique des signatures pour le type "SOA"
        // On passe null en ID car le document SoA est global à l'appli
        model.addAttribute("signatures", signatureRepo.findByEntityTypeAndEntityIdOrderByDateSignatureDesc("SOA", null));

        // 3. Envoyer les rôles pour afficher le bouton de signature
        model.addAttribute("isAdmin", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")));
        model.addAttribute("isRSSI", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_RSSI")));
        model.addAttribute("isDirection", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_DIRECTION")));

        return "compliance/soa";
    }*/

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