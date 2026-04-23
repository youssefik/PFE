<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="modal fade" id="modalNC${currentConstat.id}" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content shadow-lg border-0" style="border-radius: 20px;">
            <form action="/audit/constat/valider-nc" method="post">
                <input type="hidden" name="constatId" value="${currentConstat.id}">

                <div class="modal-header ${currentConstat.source == 'ANNEXE_A' ? 'bg-danger' : 'bg-dark'} text-white border-0 py-3">
                    <h5 class="modal-title fw-bold">
                        <i class="bi bi- exclamation-triangle-fill me-2"></i>Validation Non-Conformité
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <!-- Rappel des faits -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="p-3 bg-light rounded-3 border-start border-4 border-warning h-100">
                                <small class="text-uppercase fw-bold text-muted" style="font-size: 0.65rem;">Observation Auditeur :</small>
                                <p class="small mb-0 mt-1 text-dark">${currentConstat.description}</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="p-3 bg-light rounded-3 border-start border-4 border-info h-100">
                                <small class="text-uppercase fw-bold text-muted" style="font-size: 0.65rem;">Recommandation initiale :</small>
                                <p class="small mb-0 mt-1 text-dark italic">${currentConstat.recommandation}</p>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Référence Interne NC</label>
                        <input type="text" name="reference" class="form-control border-2"
                               placeholder="ex: NC-${currentConstat.source == 'ANNEXE_A' ? 'TECH' : 'GOV'}-2024-001" required>
                    </div>

                    <div class="mb-0">
                        <label class="form-label fw-bold d-flex justify-content-between">
                            Analyse de la cause racine (Root Cause Analysis)
                            <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold"
                                    id="btn_ai_${currentConstat.id}"
                                    data-id="${currentConstat.id}"
                                    data-desc="<c:out value='${currentConstat.description}'/>"
                                    data-code="<c:out value='${currentConstat.source == \"ANNEXE_A\" ? currentConstat.controle.code : currentConstat.clauseIso.code}'/>"
                                    onclick="askOllama(this)">
                                <i class="bi bi-robot"></i> Analyser via IA Phi-3
                            </button>
                        </label>
                        <textarea id="cause_${currentConstat.id}" name="cause" class="form-control border-2 shadow-inner"
                                  rows="4" placeholder="Définissez l'origine réelle de l'écart..." required></textarea>
                    </div>
                </div>

                <div class="modal-footer border-0 bg-light p-3">
                    <button type="submit" class="btn ${currentConstat.source == 'ANNEXE_A' ? 'btn-danger' : 'btn-dark'} w-100 rounded-pill py-2 fw-bold shadow">
                        VALIDER ET OUVRIR LE PLAN D'ACTION
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>