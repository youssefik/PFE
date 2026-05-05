<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Analyse des Risques - SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container"><span class="navbar-brand">🛡️ Analyse des Risques</span><a href="/dashboard" class="btn btn-outline-light btn-sm">Retour</a></div>
</nav>

<div class="container">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-white"><h5><i class="bi bi-plus-circle"></i> Identifier un nouveau risque</h5></div>
        <div class="card-body">
            <form action="/rssi/risques/save" method="post" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Actif impacté</label>
                    <!-- Notez le name="actifId" au lieu de actif.id -->
                    <select name="actifId" class="form-select" required>
                        <c:forEach var="a" items="${actifs}">
                            <option value="${a.id}">${a.nom}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Menace</label>
                    <input type="text" name="menace" class="form-control" placeholder="ex: Panne serveur" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Impact (1-5)</label>
                    <input type="number" name="impact" class="form-control" min="1" max="5" value="1">
                </div>
                <div class="col-md-2">
                    <label class="form-label">Vraisemblance (1-5)</label>
                    <input type="number" name="vraisemblance" class="form-control" min="1" max="5" value="1">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-danger w-100">Évaluer</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <table class="table table-hover mb-0">
            <thead class="table-light">
            <tr><th>Actif</th><th>Menace</th><th>Score</th><th>Statut</th><th>Action</th></tr>
            </thead>
            <tbody>
            <c:forEach var="r" items="${risques}">
                <tr>
                    <td><strong>${r.actif.nom}</strong></td>
                    <td>${r.menace}</td>
                    <td>
                            <span class="badge ${r.score >= 15 ? 'bg-danger' : (r.score >= 8 ? 'bg-warning' : 'bg-success')}">
                                Score: ${r.score}
                            </span>
                    </td>
                    <td><span class="badge border text-dark">${r.statut}</span></td>
                    <td>
                        <c:if test="${r.statut == 'IDENTIFIE'}">
                            <a href="/rssi/risques/traiter/${r.id}" class="btn btn-sm btn-outline-primary">Traiter</a>
                        </c:if>
                        <c:if test="${r.statut == 'TRAITE'}">
                            <span class="text-success small"><i class="bi bi-check-all"></i> Planifié</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Analyse des Risques ISO 27005">

    <style>
        .page-header-desc { border-left: 5px solid #D2010D; padding-left: 15px; margin-bottom: 30px; }
        .score-badge { font-weight: 800; padding: 8px 12px; border-radius: 4px; min-width: 60px; display: inline-block; }
        /* Style personnalisé pour les sliders */
        input[type="range"]::-webkit-slider-thumb { background: #D2010D; }
        input[type="range"]::-moz-range-thumb { background: #D2010D; }
    </style>

    <div class="row mb-4">
        <div class="col-12">
            <div class="page-header-desc">
                <h3 class="font-weight-bold">Identification des Scénarios</h3>
                <p class="text-muted">Analyse des couples <strong>Menaces / Vulnérabilités</strong> sur les actifs critiques du périmètre.</p>
            </div>
        </div>
    </div>

    <!-- FORMULAIRE D'ESTIMATION DU RISQUE -->
    <div class="card card-outline card-danger shadow-sm mb-4">
        <div class="card-header">
            <h3 class="card-title font-weight-bold text-uppercase"><i class="fas fa-biohazard mr-2"></i> Évaluer un nouveau scénario</h3>
        </div>
        <div class="card-body">
            <form action="/rssi/risques/save" method="post">
                <div class="row">
                    <!-- Section Actifs et Sources -->
                    <div class="col-md-3 form-group">
                        <label class="font-weight-bold small">Actif Support Concerné</label>
                        <select name="actifId" class="form-control form-control-sm" required>
                            <c:forEach var="a" items="${actifs}">
                                <option value="${a.id}">${a.nom} (D${a.disponibilite} I${a.integrite} C${a.confidentialite})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="font-weight-bold small text-danger">Source de Menace (EBIOS)</label>
                        <select name="origineMenace" class="form-control form-control-sm">
                            <option value="Cybercriminel">Cybercriminel (Externe)</option>
                            <option value="Employé malveillant">Employé malveillant (Interne)</option>
                            <option value="Prestataire">Prestataire / Tierce partie</option>
                            <option value="Erreur humaine">Erreur / Accident</option>
                        </select>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="font-weight-bold small">Vulnérabilité exploitée</label>
                        <input type="text" name="vulnerabilite" class="form-control form-control-sm" placeholder="ex: Absence de patch" required>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="font-weight-bold small">Événement (Menace)</label>
                        <input type="text" name="menace" class="form-control form-control-sm" placeholder="ex: Vol de données" required>
                    </div>

                    <!-- Cotation Vraisemblance et Gravité -->
                    <div class="col-md-3 form-group mt-2">
                        <label class="font-weight-bold small">Gravité (G)</label>
                        <input type="range" class="custom-range" name="gravite" min="1" max="5" value="1" oninput="this.nextElementSibling.value = this.value">
                        <output class="font-weight-bold text-danger">1</output>
                    </div>
                    <div class="col-md-3 form-group mt-2">
                        <label class="font-weight-bold small">Vraisemblance (V)</label>
                        <input type="range" class="custom-range" name="vraisemblance" min="1" max="5" value="1" oninput="this.nextElementSibling.value = this.value">
                        <output class="font-weight-bold text-danger">1</output>
                    </div>

                    <!-- Impacts Multi-critères -->
                    <div class="col-md-6 mt-2">
                        <div class="row">
                            <div class="col-3 form-group"><label class="small font-weight-bold">Imp. Org.</label><input type="number" name="impOrg" class="form-control form-control-sm" min="1" max="4" value="1"></div>
                            <div class="col-3 form-group"><label class="small font-weight-bold">Imp. Jurid.</label><input type="number" name="impJur" class="form-control form-control-sm" min="1" max="4" value="1"></div>
                            <div class="col-3 form-group"><label class="small font-weight-bold">Imp. Image</label><input type="number" name="impImg" class="form-control form-control-sm" min="1" max="4" value="1"></div>
                            <div class="col-3 form-group"><label class="small font-weight-bold">Imp. Fin.</label><input type="number" name="impFin" class="form-control form-control-sm" min="1" max="4" value="1"></div>
                        </div>
                    </div>
                </div>

                <div class="row mt-3 border-top pt-3">
                    <div class="col-12 text-right">
                        <button type="submit" class="btn btn-danger font-weight-bold px-5 elevation-1">
                            <i class="fas fa-calculator mr-1"></i> ESTIMER LE RISQUE
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- REGISTRE DES SCÉNARIOS -->
    <div class="card shadow-sm">
        <div class="card-header border-0 bg-dark py-3">
            <h3 class="card-title font-weight-bold"><i class="fas fa-list-alt mr-2"></i> Inventaire des scénarios de risques</h3>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped table-valign-middle mb-0">
                    <thead class="bg-light">
                    <tr>
                        <th class="pl-4">Actif / Menace identifiée</th>
                        <th class="text-center">Score Inhérent</th>
                        <th class="text-center">Statut du Traitement</th>
                        <th class="text-right pr-4">Opérations</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${risques}">
                        <tr>
                            <td class="pl-4">
                                <div class="font-weight-bold text-dark text-lg">${r.actifsConcernes}</div>
                                <div class="text-muted"><i class="fas fa-skull-crossbones mr-2 text-secondary"></i> ${r.menaces}</div>
                            </td>
                            <td class="text-center">
                                <span class="badge ${r.couleurStyle} elevation-1 px-3 py-2 text-lg">
                                        ${r.niveauRisqueInitial}
                                </span>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${empty r.optionTraitement}">
                                        <span class="badge border border-dark text-muted font-weight-normal py-2 px-3">
                                            <i class="fas fa-search mr-1"></i> À ÉVALUER
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-success px-3 py-2 elevation-1">
                                            <i class="fas fa-shield-alt mr-1"></i> ${r.optionTraitement}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-right pr-4">
                                <c:if test="${empty r.optionTraitement}">
                                    <a href="/rssi/risques/traiter/${r.id}" class="btn btn-sm btn-dark font-weight-bold shadow-sm px-4 rounded-pill">
                                        <i class="fas fa-pencil-alt mr-1"></i> TRAITER
                                    </a>
                                </c:if>
                                <c:if test="${not empty r.optionTraitement}">
                                    <span class="text-success font-weight-bold small"><i class="fas fa-check-double mr-1"></i> PLANIFIÉ</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <c:if test="${empty risques}">
                <div class="p-5 text-center text-muted italic">
                    <i class="fas fa-ghost fa-3x mb-3 opacity-25"></i>
                    <p>Aucun scénario de risque n'a été identifié sur ce périmètre.</p>
                </div>
            </c:if>
        </div>
    </div>

</t:layout>

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Analyse des Risques | ISO 27001</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #D2010D; }
        body { background-color: #f4f4f4; }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; margin-bottom: 30px; }
        .btn-iso { background-color: var(--iso-red); color: white; font-weight: bold; border-radius: 0; }
        .score-badge { font-weight: 800; padding: 5px 10px; border-radius: 4px; }
    </style>
</head>
<body class="py-5">
<div class="container">
    <div class="page-header">
        <h2 class="fw-bold m-0 text-uppercase">Identification des Scénarios</h2>
        <small class="text-muted">Analyse des couples Menaces / Vulnérabilités</small>
    </div>

    <div class="card border-0 shadow-sm mb-4" style="border-top: 4px solid var(--iso-red) !important;">
        <div class="card-body p-4">
            <form action="/rssi/risques/save" method="post" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label fw-bold small">Actif Support</label>
                    <select name="actifId" class="form-select" required>
                        <c:forEach var="a" items="${actifs}">
                            <option value="${a.id}">${a.nom} (C${a.confidentialite}I${a.integrite}D${a.disponibilite})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-danger">Source de Menace (EBIOS)</label>
                    <select name="origineMenace" class="form-select">
                        <option value="Cybercriminel">Cybercriminel (Externe)</option>
                        <option value="Employé malveillant">Employé malveillant (Interne)</option>
                        <option value="Prestataire">Prestataire / Tierce partie</option>
                        <option value="Erreur humaine">Erreur / Accident</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small">Vulnérabilité exploitée (ISO)</label>
                    <input type="text" name="vulnerabilite" class="form-control" placeholder="ex: Absence de patch, mot de passe faible" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small">Événement redouté (Menace)</label>
                    <input type="text" name="menace" class="form-control" placeholder="ex: Vol de données, Chiffrement" required>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold small">Gravité (1-5)</label>
                    <input type="range" class="form-range" name="gravite" min="1" max="5"
                           oninput="this.nextElementSibling.value = this.value">
                    <output class="fw-bold text-danger">1</output>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small">Vraisemblance (1-5)</label>
                    <input type="range" class="form-range" name="vraisemblance" min="1" max="5" oninput="this.nextElementSibling.value = this.value">
                    <output class="fw-bold text-danger">1</output>
                </div>
                <div class="row mb-3">
                    <div class="col-md-3">
                        <label class="small fw-bold">Impact Org.</label>
                        <input type="number" name="impOrg" class="form-control" min="1" max="4" value="1">
                    </div>
                    <div class="col-md-3">
                        <label class="small fw-bold">Impact Juridique</label>
                        <input type="number" name="impJur" class="form-control" min="1" max="4" value="1">
                    </div>
                    <div class="col-md-3">
                        <label class="small fw-bold">Impact Image</label>
                        <input type="number" name="impImg" class="form-control" min="1" max="4" value="1">
                    </div>
                    <div class="col-md-3">
                        <label class="small fw-bold">Impact Fin.</label>
                        <input type="number" name="impFin" class="form-control" min="1" max="4" value="1">
                    </div>
                </div>
                <div class="col-md-6 d-flex align-items-end">
                    <button type="submit" class="btn btn-iso w-100 py-2">ESTIMER LE RISQUE</button>
                </div>
            </form>
        </div>
    </div>


    <div class="card border-0 shadow-sm">
        <table class="table table-hover mb-0">
            <thead class="table-light">
            <tr>
                <th class="ps-4">Actif / Menace</th>
                <th class="text-center">Score</th>
                <th>État du Traitement</th> <!-- Colonne Statut -->
                <th class="text-end pe-4">Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="r" items="${risques}">
                <tr>
                    <td class="ps-4">
                        <div class="fw-bold">${r.actifsConcernes}</div>
                        <div class="text-muted small">${r.menaces}</div>
                    </td>
                    <td class="text-center">
                    <span class="badge ${r.couleurStyle} p-2">
                            ${r.niveauRisqueInitial}
                    </span>
                    </td>
                    <td>
                        <!-- On teste si optionTraitement est vide pour définir l'état -->
                        <c:choose>
                            <c:when test="${empty r.optionTraitement}">
                                <span class="badge border text-dark fw-normal p-2">À ÉVALUER</span>
                            </c:when>
                            <c:otherwise>
                            <span class="badge bg-light text-success border-success p-2">
                                <i class="bi bi-shield-check"></i> ${r.optionTraitement}
                            </span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="text-end pe-4">
                        <!-- Si optionTraitement est vide, on affiche le bouton Traiter -->
                        <c:if test="${empty r.optionTraitement}">
                            <a href="/rssi/risques/traiter/${r.id}" class="btn btn-sm btn-dark px-3 fw-bold">TRAITER</a>
                        </c:if>
                        <!-- Sinon, on affiche que c'est déjà planifié -->
                        <c:if test="${not empty r.optionTraitement}">
                            <span class="text-success fw-bold small"><i class="bi bi-check-all"></i> PLANIFIÉ</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>--%>
