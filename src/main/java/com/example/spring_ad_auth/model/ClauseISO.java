package com.example.spring_ad_auth.model;

import jakarta.persistence.*;
import java.util.UUID;
import java.util.List;

@Entity
@Table(name = "clauses_iso")
public class ClauseISO {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String code; // ex: "5.1"

    @Column(nullable = false)
    private String titre;

    @Column(columnDefinition = "TEXT")
    private String description;

    @OneToMany(mappedBy = "clauseISO", cascade = CascadeType.ALL)
    private List<Controle> controles;

    @Column(columnDefinition = "TEXT")
    private String exigences; // ex: "Identifier les enjeux internes et externes"

    @ManyToOne
    @JoinColumn(name = "parent_id")
    private ClauseISO parent; // La clause 4 sera le parent de 4.1, 4.2, etc.


    // Getters et Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public List<Controle> getControles() { return controles; }
    public void setControles(List<Controle> controles) { this.controles = controles; }

    public String getExigences() {
        return exigences;
    }

    public void setExigences(String exigences) {
        this.exigences = exigences;
    }

    public ClauseISO getParent() {
        return parent;
    }

    public void setParent(ClauseISO parent) {
        this.parent = parent;
    }
}