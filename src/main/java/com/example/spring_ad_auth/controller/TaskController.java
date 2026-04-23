package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.model.PlanificationTache;
import com.example.spring_ad_auth.model.StatutTache;
import com.example.spring_ad_auth.repository.PlanificationLogRepository;
import com.example.spring_ad_auth.repository.PlanificationTacheRepository;
import com.example.spring_ad_auth.service.SchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/planification")
public class TaskController {

    @Autowired
    private PlanificationTacheRepository taskRepository;
    @Autowired private SchedulerService schedulerService;
    @Autowired
    PlanificationLogRepository logRepository;


    @GetMapping
    public String listTasks(Model model) {
        model.addAttribute("tasks", taskRepository.findAll());
        return "planification/tasks"; // Ton fichier JSP
    }

    @PostMapping("/save")
    public String saveTask(@ModelAttribute PlanificationTache task) {
        // Maintenant task.getDateDebut() sera reconnu !
        task.setProchaineExecution(task.getDateDebut());
        task.setStatut(StatutTache.ACTIF);

        taskRepository.save(task);
        return "redirect:/planification?success=true";
    }

    @GetMapping("/logs")
    public String viewLogs(Model model) {
        model.addAttribute("logs", logRepository.findAllByOrderByDateExecutionDesc());
        return "planification/logs"; // Chemin vers le fichier JSP
    }

}
