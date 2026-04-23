<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%-- On prépare un ID sans tirets pour le modal --%>
<c:set var="safeNcId" value="${currentNC.id.toString().replace('-', '')}" />

<div class="col-12 mb-4">
    <div class="card nc-card shadow-sm border-start border-5 border-${ncColor} border-0 bg-white">
        <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
            <span class="h5 mb-0 text-${ncColor} fw-bold">
                <i class="bi bi-folder-fill me-2"></i>Ref: ${currentNC.reference}
            </span>
            <span class="badge bg-light text-secondary border rounded-pill">
                Audit : ${currentNC.constat.audit.titre}
            </span>
        </div>

        <div class="card-body pt-0">
            <div class="row g-4">
                <div class="col-md-5">
                    <div class="p-3 bg-light rounded-4 border h-100">
                        <h6 class="fw-bold small text-uppercase text-${ncColor} mb-2">
                            L'Écart (Point : ${targetPoint})
                        </h6>
                        <p class="small text-dark mb-4">${currentNC.constat.description}</p>

                        <h6 class="fw-bold small text-uppercase text-muted mb-2">Cause Racine Confirmée</h6>
                        <div class="p-2 bg-white rounded border border-dashed text-secondary small fst-italic">
                            ${currentNC.causeRacine}
                        </div>
                    </div>
                </div>

                <div class="col-md-7 ps-md-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0 text-primary">Actions engagées</h6>
                        <button type="button" class="btn btn-sm btn-${ncColor} rounded-pill px-3 shadow-sm fw-bold"
                                data-bs-toggle="modal" data-bs-target="#addAct${safeNcId}">
                            <i class="bi bi-plus-lg me-1"></i> Ajouter
                        </button>
                    </div>

                    <table class="table table-sm table-hover mb-0">
                        <thead class="table-light">
                        <tr style="font-size: 0.75rem;">
                            <th>Mesure</th><th>Responsable</th><th>Échéance</th><th class="text-end">État</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="act" items="${currentNC.actions}">
                            <tr style="font-size: 0.85rem;">
                                <td><strong>${act.titre}</strong></td>
                                <td>${act.responsable}</td>
                                <td>${act.dateEcheance}</td>
                                <td class="text-end">
                                    <c:if test="${act.statut != 'TERMINE'}">
                                        <form action="/audit/action/cloturer/${act.id}" method="post">
                                            <button type="submit" class="btn btn-sm btn-outline-success py-0 px-2 rounded-pill">OK</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${act.statut == 'TERMINE'}">
                                        <span class="badge bg-success-subtle text-success">Clôturé</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal pour AJOUTER une action (S'assurer que cet ID matche le target du bouton) -->
<div class="modal fade" id="addAct${safeNcId}" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="/audit/action/save" method="post" class="modal-content">
            <!-- IMPORTANT : Doit être currentNC.id -->
            <input type="hidden" name="ncId" value="${currentNC.id}">
            <div class="modal-header bg-primary text-white">
                <h6 class="modal-title">Planifier mesure pour ${currentNC.reference}</h6>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <label class="form-label fw-bold small">Description de l'action</label>
                    <textarea name="titre" class="form-control" rows="3" required></textarea>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold small">Responsable</label>
                        <input type="text" name="responsable" class="form-control" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold small">Deadline</label>
                        <input type="date" name="dateEcheance" class="form-control" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light border-0">
                <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-bold">ENGAGER L'ACTION</button>
            </div>
        </form>
    </div>
</div>