package com.example.spring_ad_auth.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collection;

@Controller
public class HomeController {

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/")
    public String home(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();

        model.addAttribute("username", username);
        model.addAttribute("authorities", authorities);

        return "home";  // On va créer une page home.jsp
    }

    @GetMapping("/admin")
    @ResponseBody
    public String admin() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return "Zone ADMIN - Utilisateur: " + auth.getName()
                + ", Rôles: " + auth.getAuthorities();
    }

    @GetMapping("/user")
    @ResponseBody
    public String user() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return "Zone USER - Utilisateur: " + auth.getName()
                + ", Rôles: " + auth.getAuthorities();
    }

    @GetMapping("/public/info")
    @ResponseBody
    public String publicInfo() {
        return "Information publique - accessible à tous.";
    }

    @GetMapping("/debug")
    @ResponseBody
    public String debug() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return "Authentification: " + (auth != null ? auth.toString() : "null");
    }
}