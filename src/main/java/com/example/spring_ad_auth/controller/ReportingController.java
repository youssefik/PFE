package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.RegistreRisque;
import com.example.spring_ad_auth.repository.RegistreRisqueRepository;
import com.example.spring_ad_auth.service.ReportingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/reporting")
public class ReportingController {

    @Autowired private ReportingService reportingService;


    @GetMapping("/dashboard")
    public String viewDashboard(Model model) {
        model.addAttribute("stats", reportingService.getGlobalStats());
        return "reporting/dashboard";
    }
}