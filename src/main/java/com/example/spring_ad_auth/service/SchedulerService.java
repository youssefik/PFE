package com.example.spring_ad_auth.service;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class SchedulerService {

    public LocalDateTime calculerProchaineDate(LocalDateTime dateRef, String frequence) {
        switch (frequence) {
            case "TEST_10MIN": return dateRef.plusMinutes(10); // Ajout pour ton test
            case "JOURNALIER": return dateRef.plusDays(1);
            case "HEBDOMADAIRE": return dateRef.plusWeeks(1);
            case "MENSUEL": return dateRef.plusMonths(1);
            case "BIMESTRIEL": return dateRef.plusMonths(2);
            default: return dateRef.plusDays(1);
        }
    }
}
