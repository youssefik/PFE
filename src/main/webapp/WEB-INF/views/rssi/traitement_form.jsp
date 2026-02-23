<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Traitement du Risque - SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .risk-header {
            background: ${risque.score >= 15 ? '#dc3545' : (risque.score >= 8 ? '#ffc107' : '#198754')};
            color: ${risque.score >= 8 && risque.score < 15 ? 'black' : 'white'};
        }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand"><i class="bi bi-shield-fill-exclamation"></i> Traitement des Risques</span>
        <a href="/rssi/risques" class="btn btn-outline-light btn-sm">Annuler</a>
    </div>
</nav>

<div class="container mt-5">
    <div class="card shadow-lg mx-auto" style="max-width: 700px; border: none;">
        <div class="card-header risk-header p-4">
            <h4 class="mb-0"><i class="bi bi-hammer"></i> Plan de traitement</h4>
            <small>Menace : ${risque.menace}</small>
        </div>

        <div class="card-body p-4">
            <!-- Rappel du contexte du risque -->
            <div class="row mb-4 text-center">
                <div class="col-6 border-end">
                    <label class="text-muted small d-block">Actif impacté</label>
                    <strong>${risque.actif.nom}</strong>
                </div>
                <div class="col-6">
                    <label class="text-muted small d-block">Score de risque</label>
                    <span class="badge ${risque.score >= 15 ? 'bg-danger' : (risque.score >= 8 ? 'bg-warning text-dark' : 'bg-success')}">
                        ${risque.score} / 25
                    </span>
                </div>
            </div>

            <hr>

            <form action="/rssi/risques/traiter/save" method="post">
                <input type="hidden" name="risqueId" value="${risque.id}">

                <div class="mb-4">
                    <label class="form-label fw-bold"><i class="bi bi-diagram-3"></i> Stratégie ISO 27001</label>
                    <select name="strategie" class="form-select form-select-lg" required>
                        <option value="Reduire">🛡️ Réduire (Mettre en place des contrôles)</option>
                        <option value="Accepter">🤝 Accepter (Risque résiduel validé)</option>
                        <option value="Transferer">🔄 Transférer (Assurance / Sous-traitant)</option>
                        <option value="Eviter">🚫 Éviter (Supprimer l'activité à risque)</option>
                    </select>
                    <div class="form-text text-muted">Choisissez la méthode de traitement conforme à la clause 6.1.3.</div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold"><i class="bi bi-list-task"></i> Plan d'actions détaillé</label>
                    <textarea name="planTraitement" class="form-control" rows="5"
                              placeholder="Quelles mesures techniques ou organisationnelles vont être prises ?" required></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold"><i class="bi bi-calendar-event"></i> Date cible de fin</label>
                    <input type="date" name="dateCible" class="form-control" required>
                </div>

                <div class="d-grid gap-2 mt-5">
                    <button type="submit" class="btn btn-success btn-lg shadow-sm">
                        <i class="bi bi-check-circle"></i> Valider et enregistrer le plan
                    </button>
                    <a href="/rssi/risques" class="btn btn-link text-muted">Retourner à la liste sans enregistrer</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>