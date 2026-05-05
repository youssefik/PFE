package com.example.spring_ad_auth.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.Collection;

@ControllerAdvice
public class GlobalModelAdvice {
    @ModelAttribute
    public void addAttributes(Model model, Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

            // On injecte les rôles pour la Sidebar du Layout
            model.addAttribute("isAdmin", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")));
            model.addAttribute("isRSSI", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_RSSI")));
            model.addAttribute("isAuditeur", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_AUDITEUR")));
            model.addAttribute("isPilote", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_PILOTE")));
            model.addAttribute("isDirection", authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_DIRECTION")));

            model.addAttribute("currentUsername", authentication.getName());
        }
    }
}
