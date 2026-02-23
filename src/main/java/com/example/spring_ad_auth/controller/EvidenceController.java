package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.ElementSoA;
import com.example.spring_ad_auth.model.Preuve;
import com.example.spring_ad_auth.repository.ElementSoARepository;
import com.example.spring_ad_auth.repository.PreuveRepository;
import com.example.spring_ad_auth.service.AuditLogService;
import com.example.spring_ad_auth.service.FileStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@Controller
@RequestMapping("/compliance/preuves")
public class EvidenceController {

    @Autowired
    private ElementSoARepository soaRepo;
    @Autowired private PreuveRepository preuveRepo;
    @Autowired private FileStorageService fileStorageService;
    @Autowired private AuditLogService auditLogService;

    // Afficher les preuves d'un contrôle spécifique
    @GetMapping("/{soaId}")
    public String listPreuves(@PathVariable UUID soaId, Model model) {
        ElementSoA soa = soaRepo.findById(soaId).orElseThrow();
        model.addAttribute("soa", soa);
        model.addAttribute("preuves", preuveRepo.findByElementSoA(soa));
        return "compliance/preuves";
    }

    // Upload d'une nouvelle preuve
    @PostMapping("/upload")
    public String uploadPreuve(@RequestParam("soaId") UUID soaId,
                               @RequestParam("titre") String titre,
                               @RequestParam("type") String type,
                               @RequestParam("fichier") MultipartFile fichier) {
        try {
            ElementSoA soa = soaRepo.findById(soaId).orElseThrow();

            // 1. Sauvegarde physique
            String fileName = fileStorageService.storeFile(fichier);

            // 2. Enregistrement en BD
            Preuve preuve = new Preuve();
            preuve.setTitre(titre);
            preuve.setType(type);
            preuve.setUrlFichier(fileName);
            preuve.setElementSoA(soa);
            preuve.setVersion("1.0");

            preuveRepo.save(preuve);
            auditLogService.log("Preuve", preuve.getId(), "UPLOAD_PREUVE");

            return "redirect:/compliance/preuves/" + soaId + "?success";
        } catch (Exception e) {
            return "redirect:/compliance/preuves/" + soaId + "?error";
        }
    }
}