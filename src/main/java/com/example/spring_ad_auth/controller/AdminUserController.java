package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.AppRole;
import com.example.spring_ad_auth.repository.UtilisateurRepository;
import com.example.spring_ad_auth.service.LdapSearchService;
import com.example.spring_ad_auth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.UUID;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public String listUsers(Model model) {
        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("allRoles", AppRole.values());
        return "admin/users_list";
    }

    @PostMapping("/update-role")
    public String changeRole(@RequestParam UUID userId, @RequestParam AppRole newRole) {
        userService.updateRole(userId, newRole);
        return "redirect:/admin/users?success=true";
    }

    @Autowired private LdapSearchService ldapSearchService;
    @Autowired private UtilisateurRepository userRepository;


    // Redirige /admin/users/import vers la page de recherche s'il est accédé en GET
    @GetMapping("/import")
    public String redirectImport() {
        return "redirect:/admin/users/search";
    }

    // Affiche la page de recherche (C'est cette URL qu'il faut utiliser pour voir la page)
    @GetMapping("/search")
    public String showSearchPage(@RequestParam(required = false) String q, Model model) {
        if (q != null && !q.isEmpty()) {
            model.addAttribute("results", ldapSearchService.searchUsersInAD(q));
        }
        model.addAttribute("roles", AppRole.values());
        return "admin/user_import";
    }

    // Traite le formulaire envoyé depuis user_import.jsp
    @PostMapping("/import")
    public String importUser(@RequestParam String username,
                             @RequestParam String nom,
                             @RequestParam String email,
                             @RequestParam AppRole role) {
        // Logique d'importation...
        userService.importUserManually(username, nom, email, role);
        return "redirect:/admin/users?success=imported";
    }

}
