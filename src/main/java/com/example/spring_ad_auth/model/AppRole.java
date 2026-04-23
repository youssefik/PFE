package com.example.spring_ad_auth.model;

public enum AppRole {
    ROLE_USER,
    ROLE_ADMIN,    // Configuration système, Logs d'audit
    ROLE_RSSI,     // Risques, SoA, Stratégie
    ROLE_PILOTE,   // Actions correctives, Planification
    ROLE_DIRECTION, // Rapports, KPIs
    ROLE_AUDITEUR; // Lecture seule, Audit interne
}