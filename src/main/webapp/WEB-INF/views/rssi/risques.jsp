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
</html>