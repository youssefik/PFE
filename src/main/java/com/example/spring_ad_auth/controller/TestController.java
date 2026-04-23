package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.PlanificationTache;
import com.example.spring_ad_auth.model.StatutTache;
import com.example.spring_ad_auth.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collection;

@Controller
public class TestController {
    @Autowired
    TaskRepository taskRepository;


    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();

        model.addAttribute("username", auth.getName());
        model.addAttribute("isAdmin", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")));
        model.addAttribute("isRSSI", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_RSSI")));
        model.addAttribute("isAuditeur", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_AUDITEUR")));
        model.addAttribute("isPilote", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_PILOTE")));



        PlanificationTache nextTask = taskRepository.findTopByStatutOrderByProchaineExecutionAsc(StatutTache.ACTIF);
        model.addAttribute("nextTask", nextTask);

        return "dashboard";
    }



    @GetMapping("/admin/panel")
    @ResponseBody
    public String adminPanel() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return """
            <h1>Panneau Administrateur</h1>
            <p>Utilisateur: %s</p>
            <p>Rôles: %s</p>
            <p>Cette page n'est accessible qu'aux administrateurs (ROLE_ADMIN)</p>
            <p><a href="/dashboard">Retour</a></p>
            """.formatted(auth.getName(), auth.getAuthorities());
    }

    @GetMapping("/manager/panel")
    @ResponseBody
    public String managerPanel() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return """
            <h1>Panneau Manager</h1>
            <p>Utilisateur: %s</p>
            <p>Rôles: %s</p>
            <p>Cette page n'est accessible qu'aux managers (ROLE_MANAGER)</p>
            <p><a href="/dashboard">Retour</a></p>
            """.formatted(auth.getName(), auth.getAuthorities());
    }

    @GetMapping("/user/profile")
    @ResponseBody
    public String userProfile() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return """
            <h1>Profil Utilisateur</h1>
            <p>Utilisateur: %s</p>
            <p>Rôles: %s</p>
            <p>Cette page est accessible à tous les utilisateurs authentifiés</p>
            <p><a href="/dashboard">Retour</a></p>
            """.formatted(auth.getName(), auth.getAuthorities());
    }

    @GetMapping("/whoami")
    @ResponseBody
    public String whoami() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return """
            <h1>Informations d'authentification</h1>
            <p><strong>Nom:</strong> %s</p>
            <p><strong>Authentifié:</strong> %s</p>
            <p><strong>Rôles:</strong> %s</p>
            <p><strong>Détails:</strong> %s</p>
            <p><a href="/dashboard">Retour</a></p>
            """.formatted(
                auth.getName(),
                auth.isAuthenticated(),
                auth.getAuthorities(),
                auth.getDetails()
        );
    }
}