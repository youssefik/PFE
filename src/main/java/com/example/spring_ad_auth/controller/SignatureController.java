package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.Signature;
import com.example.spring_ad_auth.repository.SignatureRepository;
import com.example.spring_ad_auth.service.SignatureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.UUID;

@Controller
@RequestMapping("/signature")
public class SignatureController {

    @Autowired private SignatureService signatureService;
    @Autowired private SignatureRepository signatureRepo;

    @PostMapping("/sign")
    public String performSignature(@RequestParam String type,
                                   @RequestParam(required = false) UUID id,
                                   @RequestParam String commentaire,
                                   @RequestParam String imageSignature) { // Reçoit l'image du dessin

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        Signature s = new Signature();
        s.setEntityType(type);
        s.setEntityId(id);
        s.setNomSignataire(auth.getName());
        s.setCommentaire(commentaire);
        s.setImageSignature(imageSignature); // Sauvegarde de l'image

        signatureRepo.save(s);
        return "redirect:/compliance/soa";
    }
}