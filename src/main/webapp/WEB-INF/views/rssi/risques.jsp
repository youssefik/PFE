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
</html>