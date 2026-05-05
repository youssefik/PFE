<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Calendrier des Missions d'Audit">

    <style>
        .page-header-desc { border-left: 6px solid #dc3545; padding-left: 1rem; margin-bottom: 2rem; }
        .status-badge { font-size: 0.75rem; font-weight: 700; padding: 0.4rem 0.8rem; border-radius: 50px; }
        .table-valign-middle td { vertical-align: middle !important; }
    </style>

    <div class="page-header-desc">
        <h3 class="font-weight-bold text-dark">Planification des Audits</h3>
        <p class="text-muted">Gestion du programme d'audit annuel et suivi de l'exécution (Exigence ISO 27001 Clause 9.2).</p>
    </div>

    <!-- FORMULAIRE DE PLANIFICATION -->
    <div class="card card-outline card-danger shadow-sm mb-5">
        <div class="card-header">
            <h3 class="card-title font-weight-bold">
                <i class="fas fa-calendar-plus text-danger mr-2"></i> Programmer un nouvel audit
            </h3>
        </div>
        <div class="card-body bg-light">
            <form action="/audit/save" method="post" class="row">
                <div class="col-md-5 mb-3">
                    <label class="small font-weight-bold text-uppercase">Titre de la mission d'audit</label>
                    <input type="text" name="titre" class="form-control" placeholder="ex: Audit Interne - DRH" required>
                </div>
                <div class="col-md-3 mb-3">
                    <label class="small font-weight-bold text-uppercase">Date de début</label>
                    <input type="date" id="dateDebut" name="dateDebut" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                    <label class="small font-weight-bold text-uppercase">Date de fin prévue</label>
                    <input type="date" id="dateFin" name="dateFin" class="form-control" required>
                </div>
                <div class="col-md-1 mb-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-dark btn-block shadow-sm">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- LISTE DES MISSIONS -->
    <div class="card shadow-sm">
        <div class="card-header border-0">
            <h3 class="card-title font-weight-bold">Missions enregistrées</h3>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover table-striped table-valign-middle mb-0">
                <thead class="bg-dark">
                <tr>
                    <th class="pl-4">Titre de l'Audit</th>
                    <th>Période d'exécution</th>
                    <th>Statut</th>
                    <th class="text-center">Opérations</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="a" items="${audits}">
                    <tr>
                        <td class="pl-4">
                            <div class="font-weight-bold text-dark">${a.titre}</div>
                            <small class="text-muted"><i class="fas fa-fingerprint mr-1"></i> ID: ${a.id.toString().substring(0,8)}</small>
                        </td>
                        <td>
                            <div class="small"><i class="far fa-calendar-alt mr-2 text-danger"></i>Du <strong>${a.dateDebut}</strong></div>
                            <div class="small"><i class="fas fa-calendar-check mr-2 text-success"></i>Au <strong>${a.dateFin}</strong></div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${a.statut == 'TERMINE'}">
                                    <span class="badge badge-success status-badge px-3 py-2"><i class="fas fa-check-circle mr-1"></i> TERMINÉ</span>
                                </c:when>
                                <c:when test="${a.statut == 'EN_COURS'}">
                                    <span class="badge badge-warning status-badge px-3 py-2"><i class="fas fa-spinner fa-spin mr-1"></i> EN COURS</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-info status-badge px-3 py-2 text-white"><i class="far fa-clock mr-1"></i> ${a.statut}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <a href="/audit/realiser/${a.id}" class="btn btn-sm btn-danger px-4 elevation-1" style="border-radius: 50px;">
                                <i class="fas fa-play-circle mr-1"></i> Lancer l'Audit
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <c:if test="${empty audits}">
            <div class="card-body text-center py-5">
                <i class="fas fa-clipboard-list fa-3x text-muted mb-3"></i>
                <p class="text-muted">Aucune mission d'audit n'est actuellement planifiée.</p>
            </div>
        </c:if>
    </div>

    <!-- SCRIPTS DE CALCUL AUTOMATIQUE -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const dateDebutEl = document.getElementById('dateDebut');
            const dateFinEl = document.getElementById('dateFin');

            dateDebutEl.addEventListener('change', function() {
                if (this.value) {
                    let date = new Date(this.value);
                    // On ajoute 7 jours automatiquement pour faciliter la saisie
                    date.setDate(date.getDate() + 7);

                    let y = date.getFullYear();
                    let m = String(date.getMonth() + 1).padStart(2, '0');
                    let d = String(date.getDate()).padStart(2, '0');

                    let dateFinAuto = y + '-' + m + '-' + d;

                    dateFinEl.value = dateFinAuto;
                    dateFinEl.setAttribute('min', this.value); // Empêche de finir avant de commencer
                }
            });
        });
    </script>

</t:layout>


<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Missions d'Audit Interne - SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fc; font-family: 'Inter', sans-serif; }
        .page-header { border-left: 6px solid #dc3545; padding-left: 1rem; margin-bottom: 2rem; }
        .card-plan { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .table-missions { background: white; border-radius: 15px; overflow: hidden; }
        .status-badge { font-size: 0.75rem; font-weight: 700; padding: 0.5rem 1rem; border-radius: 50px; }
        .btn-realiser { background: #dc3545; color: white; border-radius: 50px; font-weight: 600; border: none; }
        .btn-realiser:hover { background: #b02a37; color: white; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container">
        <span class="navbar-brand fw-bold"><i class="bi bi-search text-info me-2"></i> Audit Interne (Check)</span>
        <a href="/dashboard" class="btn btn-outline-light btn-sm">Retour Dashboard</a>
    </div>
</nav>

<div class="container pb-5">
    <div class="page-header">
        <h3 class="fw-bold text-dark">Calendrier des Missions d'Audit</h3>
        <p class="text-muted">Planification et suivi des audits de conformité ISO 27001.</p>
    </div>

    <!-- FORMULAIRE DE PLANIFICATION -->
    <div class="card card-plan mb-5">
        <div class="card-header bg-white py-3 border-0">
            <h5 class="mb-0 fw-bold"><i class="bi bi-calendar-plus text-danger me-2"></i>Programmer un nouvel audit</h5>
        </div>
        <div class="card-body bg-light rounded-bottom p-4">
            <form action="/audit/save" method="post" class="row g-3">
                <div class="col-md-5">
                    <label class="form-label small fw-bold text-uppercase">Titre de la mission d'audit</label>
                    <input type="text" name="titre" class="form-control" placeholder="ex: Audit Externe - Octobre 2024" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-uppercase">Date de début</label>
                    <!-- ID ajouté : dateDebut -->
                    <input type="date" id="dateDebut" name="dateDebut" class="form-control" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-uppercase">Date de fin prévue</label>
                    <!-- ID ajouté : dateFin -->
                    <input type="date" id="dateFin" name="dateFin" class="form-control" required>
                </div>
                <div class="col-md-1 d-flex align-items-end">
                    <button type="submit" class="btn btn-dark w-100"><i class="bi bi-plus-lg"></i></button>
                </div>
            </form>
        </div>
    </div>

    <!-- LISTE DES MISSIONS (Inchangée) -->
    <div class="table-responsive table-missions shadow-sm">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-dark">
            <tr>
                <th class="ps-4">Titre de l'Audit</th>
                <th>Période d'exécution</th>
                <th>Statut</th>
                <th class="text-center">Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="a" items="${audits}">
                <tr>
                    <td class="ps-4">
                        <div class="fw-bold">${a.titre}</div>
                        <small class="text-muted">ID: ${a.id.toString().substring(0,8)}...</small>
                    </td>
                    <td>
                        <div class="small"><i class="bi bi-calendar-event me-2"></i>Du ${a.dateDebut}</div>
                        <div class="small"><i class="bi bi-calendar-check me-2"></i>Au ${a.dateFin}</div>
                    </td>
                    <td>
                        <span class="badge status-badge ${a.statut == 'TERMINE' ? 'bg-success' : 'bg-info text-white'}">
                                ${a.statut}
                        </span>
                    </td>
                    <td class="text-center">
                        <a href="/audit/realiser/${a.id}" class="btn btn-sm btn-realiser px-4">
                            <i class="bi bi-play-circle me-1"></i> Lancer
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- SCRIPT DE CALCUL AUTOMATIQUE DE LA DATE DE FIN -->
<script>
    document.getElementById('dateDebut').addEventListener('change', function() {
        const inputDebut = this.value;

        if (inputDebut) {
            // Créer un objet Date à partir de la valeur choisie
            let date = new Date(inputDebut);

            // Ajouter 7 jours
            date.setDate(date.getDate() + 7);

            // Formater la date au format YYYY-MM-DD requis pour l'input date
            let annee = date.getFullYear();
            let mois = String(date.getMonth() + 1).padStart(2, '0');
            let jour = String(date.getDate()).padStart(2, '0');

            let dateFinAuto = annee + '-' + mois + '-' + jour;

            // Appliquer la valeur au champ date de fin
            document.getElementById('dateFin').value = dateFinAuto;

            // Optionnel : Définir la date de début comme date minimum pour la fin
            document.getElementById('dateFin').setAttribute('min', inputDebut);
        }
    });
</script>

</body>
</html>
--%>


<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Missions d'Audit Interne - SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fc; font-family: 'Inter', sans-serif; }
        .page-header { border-left: 6px solid #dc3545; padding-left: 1rem; margin-bottom: 2rem; }
        .card-plan { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .table-missions { background: white; border-radius: 15px; overflow: hidden; }
        .status-badge { font-size: 0.75rem; font-weight: 700; padding: 0.5rem 1rem; border-radius: 50px; }
        .btn-realiser { background: #dc3545; color: white; border-radius: 50px; font-weight: 600; border: none; }
        .btn-realiser:hover { background: #b02a37; color: white; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container">
        <span class="navbar-brand fw-bold"><i class="bi bi-search text-info me-2"></i> Audit Interne (Check)</span>
        <a href="/dashboard" class="btn btn-outline-light btn-sm">Retour Dashboard</a>
    </div>
</nav>

<div class="container pb-5">
    <div class="page-header">
        <h3 class="fw-bold text-dark">Calendrier des Missions d'Audit</h3>
        <p class="text-muted">Planification et suivi des audits de conformité ISO 27001.</p>
    </div>

    <!-- FORMULAIRE DE PLANIFICATION -->
    <div class="card card-plan mb-5">
        <div class="card-header bg-white py-3 border-0">
            <h5 class="mb-0 fw-bold"><i class="bi bi-calendar-plus text-danger me-2"></i>Programmer un nouvel audit</h5>
        </div>
        <div class="card-body bg-light rounded-bottom p-4">
            <form action="/audit/save" method="post" class="row g-3">
                <div class="col-md-5">
                    <label class="form-label small fw-bold text-uppercase">Titre de la mission d'audit</label>
                    <input type="text" name="titre" class="form-control" placeholder="ex: Audit Externe - Octobre 2024" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-uppercase">Date de début</label>
                    <input type="date" name="dateDebut" class="form-control" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-uppercase">Date de fin prévue</label>
                    <input type="date" name="dateFin" class="form-control" required>
                </div>
                <div class="col-md-1 d-flex align-items-end">
                    <button type="submit" class="btn btn-dark w-100"><i class="bi bi-plus-lg"></i></button>
                </div>
            </form>
        </div>
    </div>

    <!-- LISTE DES MISSIONS -->
    <div class="table-responsive table-missions shadow-sm">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-dark">
            <tr>
                <th class="ps-4">Titre de l'Audit</th>
                <th>Période d'exécution</th>
                <th>Statut</th>
                <th class="text-center">Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="a" items="${audits}">
                <tr>
                    <td class="ps-4">
                        <div class="fw-bold">${a.titre}</div>
                        <small class="text-muted">ID: ${a.id.toString().substring(0,8)}...</small>
                    </td>
                    <td>
                        <div class="small"><i class="bi bi-calendar-event me-2"></i>Du ${a.dateDebut}</div>
                        <div class="small"><i class="bi bi-calendar-check me-2"></i>Au ${a.dateFin}</div>
                    </td>
                    <td>
                            <span class="badge status-badge ${a.statut == 'TERMINE' ? 'bg-success' : 'bg-info text-white'}">
                                    ${a.statut}
                            </span>
                    </td>
                    <td class="text-center">
                        <a href="/audit/realiser/${a.id}" class="btn btn-sm btn-realiser px-4">
                            <i class="bi bi-play-circle me-1"></i> Réaliser
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>--%>

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta charset="UTF-8">
        <title>Missions</title>
</head>
<body class="container mt-4">
<h3>📅 Missions d'Audit Interne</h3>
<div class="card p-3 mb-4 shadow-sm">
    <h5>Planifier un nouvel audit</h5>
    <form action="/audit/save" method="post" class="row g-3">
        <div class="col-md-4"><input type="text" name="titre" class="form-control" placeholder="Titre de la mission" required></div>
        <div class="col-md-3"><input type="date" name="dateDebut" class="form-control" required></div>
        <div class="col-md-3"><input type="date" name="dateFin" class="form-control" required></div>
        <div class="col-md-2"><button type="submit" class="btn btn-primary w-100">Planifier</button></div>
    </form>
</div>

<table class="table table-hover shadow-sm">
    <thead class="table-dark">
    <tr><th>Mission</th><th>Début</th><th>Fin</th><th>Statut</th><th>Actions</th></tr>
    </thead>
    <tbody>
    <c:forEach var="a" items="${audits}">
        <tr>
            <td><strong>${a.titre}</strong></td>
            <td>${a.dateDebut}</td>
            <td>${a.dateFin}</td>
            <td><span class="badge bg-info">${a.statut}</span></td>
            <td><a href="/audit/realiser/${a.id}" class="btn btn-sm btn-warning">Réaliser l'audit</a></td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>--%>
