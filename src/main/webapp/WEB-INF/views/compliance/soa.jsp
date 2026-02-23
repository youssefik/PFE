<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SoA - Déclaration d'Applicabilité</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-primary mb-4 shadow-sm">
    <div class="container">
        <span class="navbar-brand"><i class="bi bi-list-check"></i> Déclaration d'Applicabilité (SoA)</span>
        <a href="/dashboard" class="btn btn-light btn-sm">Retour</a>
    </div>
</nav>

<div class="container-fluid px-4">
    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th>Code</th>
                    <th>Contrôle Annexe A</th>
                    <th>Applicable</th>
                    <th>État Mise en œuvre</th>
                    <th>Justification</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ctrl" items="${controles}">
                    <c:set var="soa" value="${null}" />
                    <%-- On cherche l'élément SoA lié à ce contrôle --%>
                    <c:forEach var="item" items="${soaElements}">
                        <c:if test="${item.controle.id == ctrl.id}">
                            <c:set var="soa" value="${item}" />
                        </c:if>
                    </c:forEach>

                    <tr>
                        <td><strong>${ctrl.code}</strong></td>
                        <td>
                            <div class="fw-bold">${ctrl.titre}</div>
                            <small class="text-muted">${ctrl.domaine}</small>
                        </td>
                        <td>
                                <span class="badge ${soa.applicable ? 'bg-success' : 'bg-secondary'}">
                                        ${soa != null ? (soa.applicable ? 'OUI' : 'NON') : 'A définir'}
                                </span>
                        </td>
                        <td>
                                <span class="badge border text-dark">
                                        ${soa.statutMiseEnOeuvre != null ? soa.statutMiseEnOeuvre : 'INDIRE'}
                                </span>
                        </td>
                        <td class="small">${soa.justification}</td>
                        <td>
                            <!-- Bouton pour ouvrir un modal de mise à jour (Simplifié ici par un lien) -->
                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modal${ctrl.id}">
                                <i class="bi bi-pencil"></i> Éditer
                            </button>

                            <!-- MODAL DE MISE À JOUR -->
                            <div class="modal fade" id="modal${ctrl.id}" tabindex="-1">
                                <div class="modal-dialog">
                                    <form action="/compliance/soa/update" method="post" class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Mise à jour : ${ctrl.code}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="controleId" value="${ctrl.id}">
                                            <div class="mb-3">
                                                <label class="form-label">Applicabilité</label>
                                                <select name="applicable" class="form-select">
                                                    <option value="true" ${soa.applicable ? 'selected' : ''}>Oui (Applicable)</option>
                                                    <option value="false" ${soa != null && !soa.applicable ? 'selected' : ''}>Non (Exclu)</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Statut de mise en œuvre</label>
                                                <select name="statut" class="form-select">
                                                    <option value="NON_DEMARRE">Non démarré</option>
                                                    <option value="EN_COURS">En cours / Partiel</option>
                                                    <option value="CONFORME">Conforme / Appliqué</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Justification</label>
                                                <textarea name="justification" class="form-control" rows="3">${soa.justification}</textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="submit" class="btn btn-primary">Enregistrer</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <c:if test="${soa != null}">
                                <a href="/compliance/preuves/${soa.id}" class="btn btn-sm btn-warning">
                                    <i class="bi bi-folder2-open"></i> Preuves
                                    <span class="badge bg-white text-dark ms-1">${soa.preuves.size()}</span>
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>