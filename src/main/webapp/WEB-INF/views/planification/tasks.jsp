<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Planification des Tâches Sécurité</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-calendar-event text-primary"></i> Planification des Tâches</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addTaskModal">
            <i class="bi bi-plus-circle"></i> Nouvelle Tâche
        </button>
    </div>

    <!-- Tableau des tâches existantes -->
    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-dark">
                <tr>
                    <th>Titre</th>
                    <th>Type</th>
                    <th>Fréquence</th>
                    <th>Responsable</th>
                    <th>Prochaine Échéance</th>
                    <th>Statut</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="task" items="${tasks}">
                    <tr>
                        <td><strong>${task.titre}</strong></td>
                        <td><span class="badge bg-secondary">${task.typeTache}</span></td>
                        <td>${task.frequence}</td>
                        <td><i class="bi bi-envelope"></i> ${task.emailResponsable}</td>
                        <td>${task.prochaineExecution}</td>
                        <td>
                                <span class="badge ${task.statut == 'ACTIF' ? 'bg-success' : 'bg-danger'}">
                                        ${task.statut}
                                </span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- MODAL D'AJOUT DE TÂCHE -->
<div class="modal fade" id="addTaskModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="/planification/save" method="post">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Planifier une nouvelle action</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">

                    <div class="mb-3">
                        <label class="form-label">Titre de la tâche</label>
                        <input type="text" name="titre" class="form-control" placeholder="ex: Backup Base de Données" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Type d'opération</label>
                        <select name="typeTache" class="form-select">
                            <option value="BACKUP_DB">Sauvegarde Base de Données</option>
                            <option value="BACKUP_VM">Sauvegarde Machine Virtuelle</option>
                            <option value="REVUE_ACCES">Revue des accès AD</option>
                            <option value="SCAN_VULN">Scan de vulnérabilités</option>
                            <option value="AUTRE">Autre maintenance</option>
                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Fréquence</label>
                            <%--<select name="frequence" class="form-select">
                                <option value="JOURNALIER">Chaque jour</option>
                                <option value="HEBDOMADAIRE">Chaque semaine</option>
                                <option value="MENSUEL">Chaque mois</option>
                                <option value="BIMESTRIEL">Tous les 2 mois</option>
                                <option value="TRIMESTRIEL">Chaque trimestre</option>
                            </select>--%>
                            <select name="frequence" class="form-select">
                                <option value="TEST_10MIN" class="text-danger fw-bold">TEST (Toutes les 10 minutes)</option>
                                <option value="JOURNALIER">Chaque jour</option>
                                <option value="HEBDOMADAIRE">Chaque semaine</option>
                                <option value="MENSUEL">Chaque mois</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Date de début</label>
                            <input type="datetime-local" name="dateDebut" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email du responsable (Notification)</label>
                        <input type="email" name="emailResponsable" class="form-control" placeholder="nom@entreprise.com" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Description / Instructions</label>
                        <textarea name="description" class="form-control" rows="3"></textarea>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer la planification</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>