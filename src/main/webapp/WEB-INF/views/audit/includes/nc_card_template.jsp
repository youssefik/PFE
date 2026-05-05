<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%-- On prépare un ID sans tirets pour le modal --%>
<c:set var="safeNcId" value="${currentNC.id.toString().replace('-', '')}" />

<%-- Suppression de la classe col-12 car le conteneur col-md-6 est déjà dans la page parente --%>
<div class="card nc-card shadow-sm border-left border-danger mb-4" style="border-left-width: 5px !important;">
    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
        <span class="h6 mb-0 text-danger font-weight-bold">
            <i class="fas fa-folder-open mr-2"></i>Ref: ${currentNC.reference}
        </span>
        <span class="badge badge-light border font-italic">
            Audit : ${currentNC.constat.audit.titre}
        </span>
    </div>

    <div class="card-body pt-0">
        <div class="row">
            <div class="col-md-5">
                <div class="p-3 bg-light rounded border h-100">
                    <h6 class="font-weight-bold small text-uppercase text-danger mb-2">
                        L'Écart (Point : ${targetPoint})
                    </h6>
                    <p class="small text-dark mb-3">${currentNC.constat.description}</p>

                    <h6 class="font-weight-bold small text-uppercase text-muted mb-2">Cause Racine</h6>
                    <div class="p-2 bg-white rounded border border-secondary small font-italic" style="border-style: dashed !important;">
                        ${currentNC.causeRacine}
                    </div>
                </div>
            </div>

            <div class="col-md-7 pl-md-4">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="font-weight-bold mb-0 text-primary">Actions engagées</h6>
                    <%-- CORRECTION : data-toggle et data-target au lieu de data-bs --%>
                    <button type="button" class="btn btn-xs btn-danger elevation-1"
                            data-toggle="modal" data-target="#addAct${safeNcId}">
                        <i class="fas fa-plus mr-1"></i> Ajouter
                    </button>
                </div>

                <table class="table table-sm table-hover mb-0">
                    <thead class="thead-light">
                    <tr style="font-size: 0.70rem; text-transform: uppercase;">
                        <th>Mesure</th><th>Resp.</th><th class="text-right">État</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="act" items="${currentNC.actions}">
                        <tr style="font-size: 0.85rem;">
                            <td><strong>${act.titre}</strong></td>
                            <td><small>${act.responsable}</small></td>
                            <td class="text-right">
                                <c:if test="${act.statut != 'TERMINE'}">
                                    <form action="/audit/action/cloturer/${act.id}" method="post">
                                        <button type="submit" class="btn btn-xs btn-outline-success py-0">Clôturer</button>
                                    </form>
                                </c:if>
                                <c:if test="${act.statut == 'TERMINE'}">
                                    <span class="badge badge-success px-2">OK</span>
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

<!-- Modal pour AJOUTER une action (BS4 Compatible) -->
<div class="modal fade" id="addAct${safeNcId}" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <form action="/audit/action/save" method="post" class="modal-content border-0 shadow-lg">
            <input type="hidden" name="ncId" value="${currentNC.id}">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title font-weight-bold">Planifier action : ${currentNC.reference}</h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body p-4">
                <div class="form-group">
                    <label class="font-weight-bold small text-uppercase">Description de l'action</label>
                    <textarea name="titre" class="form-control" rows="3" required placeholder="Que faut-il faire pour corriger ?"></textarea>
                </div>
                <div class="row">
                    <div class="col-md-6 form-group">
                        <label class="font-weight-bold small text-uppercase">Responsable</label>
                        <input type="text" name="responsable" class="form-control" required>
                    </div>
                    <div class="col-md-6 form-group">
                        <label class="font-weight-bold small text-uppercase">Échéance (Deadline)</label>
                        <input type="date" name="dateEcheance" class="form-control" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light border-0">
                <button type="submit" class="btn btn-danger btn-block font-weight-bold py-2">ENGAGER L'ACTION CORRECTIVE</button>
            </div>
        </form>
    </div>
</div>