package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.mapper.ImprovementMapper;
import com.example.spring_ad_auth.repository.ImprovementRepository;
import com.example.spring_ad_auth.service.ImprovementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/compliance/improvement")
public class ImprovementController {

    @Autowired
    private ImprovementService improvementService;

    @Autowired
    private ImprovementRepository repo; // Utilisation de ton nom réel

    @Autowired
    private ImprovementMapper mapper;

    @GetMapping
    public String viewJournal() {
        return "compliance/improvement_editor";
    }

    @GetMapping("/data")
    @ResponseBody
    public List<Map<String, Object>> getJournalData() {
        // On utilise ImprovementRepository pour lire la base
        return repo.findAll().stream()
                .map(mapper::mapToMap)
                .toList();
    }

    @PostMapping("/save")
    @ResponseBody
    public String saveJournal(@RequestBody List<Map<String, Object>> data) {
        try {
            improvementService.saveAll(data);
            return "SUCCESS";
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}