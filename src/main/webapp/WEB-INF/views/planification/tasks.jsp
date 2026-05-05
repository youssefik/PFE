<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Planification de la Sécurité Opérationnelle">

    <div class="row mb-3">
        <div class="col-12">
            <div class="callout callout-danger bg-white shadow-sm">
                <h5><i class="fas fa-calendar-alt mr-2 text-danger"></i> Maintenance du SMSI</h5>
                <p>Planifiez et suivez l'exécution des tâches de maintenance, sauvegardes et revues périodiques.</p>
            </div>
        </div>
    </div>

    <!-- TABLEAU DES TÂCHES EXISTANTES -->
    <div class="card card-outline card-danger shadow-sm">
        <div class="card-header border-0">
            <h3 class="card-title font-weight-bold">Registre des actions planifiées</h3>
            <div class="card-tools">
                <button class="btn btn-danger btn-sm shadow-sm font-weight-bold" data-toggle="modal" data-target="#addTaskModal">
                    <i class="fas fa-plus-circle mr-1"></i> PROGRAMMER UNE TÂCHE
                </button>
                <a href="/planification/logs" class="btn btn-tool ml-2">
                    <i class="fas fa-history mr-1"></i> Voir l'Historique
                </a>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped table-valign-middle mb-0">
                    <thead class="bg-dark">
                    <tr>
                        <th class="pl-4">Titre de l'action</th>
                        <th>Type d'opération</th>
                        <th>Fréquence</th>
                        <th>Responsable / Contact</th>
                        <th>Prochaine Échéance</th>
                        <th class="text-center pr-4">Statut</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="task" items="${tasks}">
                        <tr>
                            <td class="pl-4 font-weight-bold text-dark">
                                    ${task.titre}
                            </td>
                            <td>
                                <span class="badge badge-light border text-muted py-1 px-2">
                                    <i class="fas fa-cog mr-1"></i> ${task.typeTache}
                                </span>
                            </td>
                            <td>
                                <i class="far fa-clock text-info mr-1"></i> ${task.frequence}
                            </td>
                            <td>
                                <div class="small"><i class="fas fa-user-shield text-muted mr-1"></i> ${task.emailResponsable}</div>
                            </td>
                            <td>
                                <div class="text-danger font-weight-bold small">
                                    <i class="far fa-calendar-check mr-1"></i> ${task.prochaineExecution}
                                </div>
                            </td>
                            <td class="text-center pr-4">
                                <c:choose>
                                    <c:when test="${task.statut == 'ACTIF'}">
                                        <span class="badge badge-success px-3 py-1 elevation-1">ACTIF</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-secondary px-3 py-1 elevation-1">${task.statut}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty tasks}">
                <div class="text-center py-5">
                    <i class="fas fa-tasks fa-3x text-muted mb-3"></i>
                    <p class="text-muted">Aucune tâche planifiée pour le moment.</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- MODAL D'AJOUT DE TÂCHE (Style AdminLTE / BS4) -->
    <div class="modal fade" id="addTaskModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content shadow-lg border-0">
                <form action="/planification/save" method="post">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title font-weight-bold"><i class="fas fa-calendar-plus mr-2"></i> Nouvelle Planification</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row">
                            <div class="col-md-7">
                                <div class="form-group">
                                    <label class="font-weight-bold small text-uppercase">Titre de la tâche</label>
                                    <input type="text" name="titre" class="form-control" placeholder="ex: Revue trimestrielle des accès AD" required>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <div class="form-group">
                                    <label class="font-weight-bold small text-uppercase">Type d'opération</label>
                                    <select name="typeTache" class="form-control select2" required>
                                        <option value="BACKUP_DB">Sauvegarde Base de Données</option>
                                        <option value="BACKUP_VM">Sauvegarde Machine Virtuelle</option>
                                        <option value="REVUE_ACCES">Revue des accès AD</option>
                                        <option value="SCAN_VULN">Scan de vulnérabilités</option>
                                        <option value="AUTRE">Autre maintenance</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="font-weight-bold small text-uppercase">Fréquence de rappel</label>
                                    <select name="frequence" class="form-control" required>
                                        <option value="TEST_10MIN" class="text-danger font-weight-bold text-center">MODE TEST (10 Minutes)</option>
                                        <option value="JOURNALIER">Chaque jour</option>
                                        <option value="HEBDOMADAIRE">Chaque semaine</option>
                                        <option value="MENSUEL">Chaque mois</option>
                                        <option value="TRIMESTRIEL">Chaque trimestre</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="font-weight-bold small text-uppercase">Date & Heure de début</label>
                                    <input type="datetime-local" name="dateDebut" class="form-control" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="font-weight-bold small text-uppercase">Responsable (Notifications Email)</label>
                            <input type="email" name="emailResponsable" class="form-control" placeholder="nom@entreprise.com" required>
                            <small class="form-text text-muted italic">Un rappel sera envoyé automatiquement à cette adresse avant l'échéance.</small>
                        </div>

                        <div class="form-group">
                            <label class="font-weight-bold small text-uppercase">Description des instructions</label>
                            <textarea name="description" class="form-control" rows="3" placeholder="Décrivez les étapes à suivre pour valider cette tâche..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-secondary px-4" data-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-danger px-4 shadow font-weight-bold">
                            ENREGISTRER LA PLANIFICATION
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</t:layout>
<%--
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
                            &lt;%&ndash;<select name="frequence" class="form-select">
                                <option value="JOURNALIER">Chaque jour</option>
                                <option value="HEBDOMADAIRE">Chaque semaine</option>
                                <option value="MENSUEL">Chaque mois</option>
                                <option value="BIMESTRIEL">Tous les 2 mois</option>
                                <option value="TRIMESTRIEL">Chaque trimestre</option>
                            </select>&ndash;%&gt;
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
</html>--%>
