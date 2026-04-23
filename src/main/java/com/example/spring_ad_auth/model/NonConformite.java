package com.example.spring_ad_auth.model;

import jakarta.persistence.*;

import java.util.List;
import java.util.UUID;

@Entity
public class NonConformite {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String reference;
    @Column(columnDefinition = "TEXT")
    private String causeRacine;

    @OneToOne @JoinColumn(name = "constat_id")
    private Constat constat;

    @OneToMany(mappedBy = "nonConformite", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ActionCorrective> actions;

    public UUID getId() {
        return id;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getCauseRacine() {
        return causeRacine;
    }

    public void setCauseRacine(String causeRacine) {
        this.causeRacine = causeRacine;
    }

    public Constat getConstat() {
        return constat;
    }

    public void setConstat(Constat constat) {
        this.constat = constat;
    }

    public List<ActionCorrective> getActions() {
        return actions;
    }

    public void setActions(List<ActionCorrective> actions) {
        this.actions = actions;
    }
}

