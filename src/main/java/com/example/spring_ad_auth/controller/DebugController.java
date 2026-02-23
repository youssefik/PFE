package com.example.spring_ad_auth.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class DebugController {

    @GetMapping("/debug/auth")
    @ResponseBody
    public String debugAuth() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null) {
            return "Pas d'authentification";
        }
        return "Authentification: " + auth.toString();
    }

    @GetMapping("/debug/ldap")
    @ResponseBody
    public String debugLdap() {
        return "Vérifiez les logs pour les détails de connexion LDAP";
    }
}