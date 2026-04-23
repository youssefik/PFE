package com.example.spring_ad_auth.config;

import com.example.spring_ad_auth.model.PlanificationLog;
import com.example.spring_ad_auth.model.PlanificationTache;
import com.example.spring_ad_auth.model.StatutTache;
import com.example.spring_ad_auth.repository.PlanificationLogRepository;
import com.example.spring_ad_auth.repository.PlanificationTacheRepository;
import com.example.spring_ad_auth.service.EmailService;
import com.example.spring_ad_auth.service.SchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@EnableScheduling
public class TaskEngine {

    @Autowired private PlanificationTacheRepository repository;
    @Autowired private EmailService emailService; // Ton service d'envoi de mail
    @Autowired
    private SchedulerService schedulerService;
    @Autowired private PlanificationLogRepository logRepository;



//    @Scheduled(fixedRate = 60000) // Vérification toutes les minutes
@Scheduled(fixedRate = 10000)
public void checkAndNotifyTasks() {
        LocalDateTime maintenant = LocalDateTime.now();

        // On récupère les tâches qui doivent être exécutées
        List<PlanificationTache> taches = repository.findByProchaineExecutionBeforeAndStatut(maintenant, StatutTache.ACTIF);

        for (PlanificationTache tache : taches) {
            try {
                // --- CONSTRUCTION DU MAIL DYNAMIQUE ---
                String sujet = "⚠️ RAPPEL SÉCURITÉ : " + tache.getTitre();

                StringBuilder corps = new StringBuilder();
                corps.append("Bonjour,\n\n");
                corps.append("Ceci est une notification automatique de votre CRM ISO 27001.\n\n");
                corps.append("Une tâche de sécurité est planifiée pour maintenant :\n");
                corps.append("--------------------------------------------------\n");
                corps.append("📌 Tâche : ").append(tache.getTitre()).append("\n");
                corps.append("📂 Type : ").append(tache.getTypeTache()).append("\n");
                corps.append("📝 Description : ").append(tache.getDescription() != null ? tache.getDescription() : "Aucune description fournie.").append("\n");
                corps.append("⏰ Fréquence : ").append(tache.getFrequence()).append("\n");
                corps.append("--------------------------------------------------\n\n");
                corps.append("Merci de réaliser cette action et de mettre à jour le registre si nécessaire.\n");
                corps.append("Cordialement,\n");
                corps.append("Le Système de Gestion de la Sécurité (SMSI)");

                // Envoi du mail
                emailService.sendSimpleMessage(tache.getEmailResponsable(), sujet, corps.toString());


                // SAUVEGARDE DU LOG
                logRepository.save(new PlanificationLog(tache.getTitre(), maintenant, "SUCCES", "Notification envoyée à " + tache.getEmailResponsable()));
                // --- MISE À JOUR DE LA PROCHAINE DATE ---
                // On calcule la prochaine date (ex: dans 1 mois si c'est mensuel)
                LocalDateTime prochaineDate = schedulerService.calculerProchaineDate(maintenant, tache.getFrequence());
                tache.setProchaineExecution(prochaineDate);
                tache.setDerniereExecution(maintenant);

                repository.save(tache);

                System.out.println("✅ Notification envoyée et planifiée pour le : " + prochaineDate + " pour la tâche : " + tache.getTitre());

            } catch (Exception e) {
                logRepository.save(new PlanificationLog(tache.getTitre(), maintenant, "ERREUR", e.getMessage()));
                System.err.println("❌ Erreur lors de l'envoi pour la tâche " + tache.getTitre() + " : " + e.getMessage());
            }
        }
    }


    // Vérifie toutes les 30 minutes
  /*  @Scheduled(fixedRate = 1800000)
    public void checkAndNotifyTasks() {
        LocalDateTime maintenant = LocalDateTime.now();
        List<PlanificationTache> tachesAExecuter = repository.findByProchaineExecutionBeforeAndStatut(maintenant, StatutTache.ACTIF);

        for (PlanificationTache tache : tachesAExecuter) {
            // 1. Envoyer le mail au responsable
            emailService.sendSimpleMessage(
                    tache.getEmailResponsable(),
                    "RAPPEL : Tâche de sécurité à effectuer - " + tache.getTitre(),
                    "Bonjour, ceci est un rappel pour la tâche : " + tache.getDescription()
            );

            // 2. Mettre à jour les dates pour la répétition
            tache.setDerniereExecution(maintenant);
            tache.setProchaineExecution(schedulerService.calculerProchaineDate(maintenant, tache.getFrequence()));

            repository.save(tache);

            // 3. Loguer l'action dans le journal d'audit (Preuve ISO)
            System.out.println("Notification envoyée pour : " + tache.getTitre());
        }
    }*/
}