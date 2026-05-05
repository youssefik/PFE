<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Audit : ${audit.titre}">

    <style>
        .audit-row { transition: 0.3s; background: white; border-bottom: 1px solid #eee; }
        .audit-row.is-done { background-color: #f8fff9 !important; }
        .next-up { border: 2px solid #D2010D !important; background-color: #fff5f5 !important; animation: pulse 1s 3; }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.7; } 100% { opacity: 1; } }

        .code-tag { font-weight: 700; color: #D2010D; }
        .ai-loader { display: none; }
        .modal-header { background: #343a40; color: white; }
        .btn-save-nc { background-color: #D2010D; color: white; font-weight: 800; border: none; text-transform: uppercase; border-radius: 4px; padding: 10px; }

        /* Ajustements Bootstrap 4 pour accordéons */
        .card-header .btn-link { color: #333; text-decoration: none; width: 100%; text-align: left; }
    </style>

    <!-- CALCULS DE PROGRESSION -->
    <c:set var="totalRequirements" value="${fn:length(subClausesList) + fn:length(soaApplicables)}" />
    <c:set var="auditedClauseCount" value="0" />
    <c:set var="auditedControleCount" value="0" />
    <c:forEach var="constat" items="${audit.constats}">
        <c:if test="${constat.clauseIso != null}"><c:set var="auditedClauseCount" value="${auditedClauseCount + 1}" /></c:if>
        <c:if test="${constat.controle != null}"><c:set var="auditedControleCount" value="${auditedControleCount + 1}" /></c:if>
    </c:forEach>
    <c:set var="totalDone" value="${auditedClauseCount + auditedControleCount}" />
    <c:set var="progGlobalPct" value="${totalRequirements > 0 ? (totalDone * 100 / totalRequirements) : 0}" />

    <div class="row mb-4 no-print">
        <div class="col-md-8">
            <div class="info-box shadow-sm">
                <span class="info-box-icon bg-danger"><i class="fas fa-tasks"></i></span>
                <div class="info-box-content">
                    <span class="info-box-text">PROGRESSION DE L'AUDIT</span>
                    <span class="info-box-number"><fmt:formatNumber value="${progGlobalPct}" maxFractionDigits="0"/>% réalisé</span>
                    <div class="progress"><div class="progress-bar bg-danger" style="width: ${progGlobalPct}%"></div></div>
                    <span class="progress-description text-muted">${totalDone} sur ${totalRequirements} points évalués</span>
                </div>
            </div>
        </div>
        <div class="col-md-4 text-right">
            <a href="/audit/resultat/${audit.id}" class="btn btn-primary shadow-sm mb-2"><i class="fas fa-file-alt mr-2"></i> RÉSULTATS FINAUX</a><br>
            <a href="/audit/missions" class="btn btn-outline-dark btn-sm"><i class="fas fa-door-open mr-1"></i> Quitter la mission</a>
        </div>
    </div>

    <!-- ONGLETS -->
    <div class="card card-danger card-outline card-tabs shadow-sm">
        <div class="card-header p-0 pt-1 border-bottom-0">
            <ul class="nav nav-tabs" id="auditTabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" data-toggle="pill" href="#tabClauses" role="tab"><i class="fas fa-list-check mr-2"></i> Exigences SMSI (4-10)</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="pill" href="#tabAnnexe" role="tab"><i class="fas fa-shield-alt mr-2"></i> Mesures de l'Annexe A</a>
                </li>
            </ul>
        </div>

        <div class="card-body">
            <div class="tab-content">

                <!-- ONGLET 1 : CLAUSES -->
                <div class="tab-pane fade show active" id="tabClauses" role="tabpanel">
                    <div id="accordionAudit">
                        <c:forEach var="parent" items="${parentChapters}" varStatus="pStatus">
                            <!-- Calcul Conformité Chapitre -->
                            <c:set var="subCount" value="0" /><c:set var="confCount" value="0" />
                            <c:forEach var="sub" items="${subClausesList}"><c:if test="${sub.parent.id == parent.id}"><c:set var="subCount" value="${subCount + 1}" />
                                <c:forEach var="c" items="${audit.constats}"><c:if test="${c.clauseIso.id == sub.id && c.type == 'Conforme'}"><c:set var="confCount" value="${confCount + 1}" /></c:if></c:forEach>
                            </c:if></c:forEach>
                            <c:set var="cPct" value="${subCount > 0 ? (confCount * 100 / subCount) : 0}" />

                            <div class="card card-light mb-2 shadow-none border">
                                <div class="card-header">
                                    <h4 class="card-title w-100">
                                        <a class="d-flex justify-content-between align-items-center" data-toggle="collapse" href="#chapter${pStatus.index}">
                                            <span><strong>${parent.code}</strong> ${parent.titre}</span>
                                            <div style="width: 120px;">
                                                <div class="progress progress-xxs mb-0"><div class="progress-bar bg-success" style="width: ${cPct}%"></div></div>
                                                <small class="text-muted font-weight-bold" style="font-size: 10px;">${cPct}% OK</small>
                                            </div>
                                        </a>
                                    </h4>
                                </div>
                                <div id="chapter${pStatus.index}" class="collapse" data-parent="#accordionAudit">
                                    <div class="card-body p-0">
                                        <table class="table table-hover table-valign-middle mb-0">
                                            <tbody>
                                            <c:forEach var="sub" items="${subClausesList}">
                                                <c:if test="${sub.parent.id == parent.id}">
                                                    <c:set var="curConstat" value="${null}" />
                                                    <c:forEach var="constat" items="${audit.constats}"><c:if test="${constat.clauseIso.id == sub.id}"><c:set var="curConstat" value="${constat}" /></c:if></c:forEach>

                                                    <tr id="row_sc_${sub.id}" class="audit-row ${curConstat != null ? 'is-done' : 'not-done'}">
                                                        <td class="pl-4 font-weight-bold code-tag" style="width:80px;">${sub.code}</td>
                                                        <td><strong>${sub.titre}</strong><br><small class="text-muted italic">${sub.exigences}</small></td>
                                                        <td class="text-right pr-4" style="width:250px;">
                                                            <c:choose>
                                                                <c:when test="${curConstat == null}">
                                                                    <button class="btn btn-dark btn-sm px-4 elevation-1" data-toggle="modal" data-target="#modalSc_${sub.id.toString().replace('-','')}">AUDITER</button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="d-flex align-items-center justify-content-end">
                                                                        <span class="badge ${curConstat.type == 'Conforme' ? 'badge-success' : 'badge-warning'} px-3 py-2 mr-3 elevation-1">
                                                                                ${curConstat.type}
                                                                        </span>
                                                                        <form action="/audit/constat/supprimer" method="post" class="d-inline" onsubmit="return confirm('Supprimer ce constat ?')">
                                                                            <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="clauseId" value="${sub.id}">
                                                                            <button type="submit" class="btn btn-link text-danger p-0 ml-1"><i class="fas fa-trash"></i></button>
                                                                        </form>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>

                                                    <!-- MODAL CLAUSE (AdminLTE 3 Style) -->
                                                    <div class="modal fade" id="modalSc_${sub.id.toString().replace('-','')}" tabindex="-1" role="dialog" aria-hidden="true">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content shadow-lg border-0">
                                                                <form action="/audit/constat/save" method="post">
                                                                    <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="clauseId" value="${sub.id}"><input type="hidden" name="source" value="CLAUSE">
                                                                    <div class="modal-header"><h5 class="modal-title font-weight-bold">Point : ${sub.code}</h5><button type="button" class="close text-white" data-dismiss="modal">&times;</button></div>
                                                                    <div class="modal-body">
                                                                        <div class="form-group"><label class="font-weight-bold small text-uppercase">Statut de conformité</label>
                                                                            <select name="type" class="form-control" required><option value="" disabled selected>Choisir un verdict...</option>
                                                                                <option value="Conforme">✅ Conforme</option><option value="Observation">👁️ Observation</option><option value="NC Mineur">⚠️ NC Mineur</option><option value="NC Majeur">🚨 NC Majeur</option><option value="Opportunité d'amélioration">📈 Opportunité</option></select></div>
                                                                        <div class="form-group"><label class="font-weight-bold small text-uppercase">Preuves récoltées</label>
                                                                            <textarea id="desc_sc_${sub.id}" name="description" class="form-control" rows="3" required placeholder="Observations..."></textarea></div>
                                                                        <div class="form-group"><label class="d-flex justify-content-between font-weight-bold small text-uppercase">Recommandation <button type="button" class="btn btn-link btn-xs p-0 text-primary" onclick="getAiSuggestion('sc_${sub.id}', '${sub.code}')"><i class="fas fa-robot mr-1"></i> Aide IA</button></label>
                                                                            <textarea id="rec_sc_${sub.id}" name="recommandation" class="form-control bg-light" rows="3"></textarea><div id="loader_sc_${sub.id}" class="spinner-border spinner-border-sm text-primary ai-loader mt-1"></div></div>
                                                                    </div>
                                                                    <div class="modal-footer"><button type="submit" class="btn btn-save-nc btn-block">Valider l'exigence</button></div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- ONGLET 2 : ANNEXE A -->
                <div class="tab-pane fade" id="tabAnnexe" role="tabpanel">
                    <div class="card card-dark">
                        <div class="card-header"><h3 class="card-title"><i class="fas fa-shield-alt mr-2"></i>Contrôles techniques (Applicables au SoA)</h3></div>
                        <div class="card-body p-0">
                            <table class="table table-striped table-hover align-middle mb-0">
                                <thead><tr><th class="pl-4">Code</th><th>Mesure Technique de l'Annexe A</th><th class="text-center">Action / État</th></tr></thead>
                                <tbody>
                                <c:forEach var="soa" items="${soaApplicables}">
                                    <c:set var="curConstat" value="${null}" />
                                    <c:forEach var="constat" items="${audit.constats}"><c:if test="${constat.controle.id == soa.controle.id}"><c:set var="curConstat" value="${constat}" /></c:if></c:forEach>
                                    <tr id="ann_row_${soa.controle.id}" class="audit-row ${curConstat != null ? 'is-done' : 'not-done'}">
                                        <td class="pl-4 font-weight-bold code-tag">${soa.controle.code}</td>
                                        <td><strong>${soa.controle.titre}</strong><br><small class="text-muted">Justification: ${soa.justification}</small></td>
                                        <td class="text-center" style="width:250px;">
                                            <c:choose>
                                                <c:when test="${curConstat == null}"><button class="btn btn-danger btn-sm px-4 elevation-1 font-weight-bold" data-toggle="modal" data-target="#modalA_${soa.id.toString().replace('-','')}">AUDITER</button></c:when>
                                                <c:otherwise>
                                                    <div class="d-flex align-items-center justify-content-center">
                                                        <span class="badge badge-light border px-3 py-2 mr-3 elevation-1 font-weight-bold">${curConstat.niveauMaturite}</span>
                                                        <form action="/audit/constat/supprimer" method="post" class="d-inline" onsubmit="return confirm('Réinitialiser cet audit ?')">
                                                            <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="controleId" value="${soa.controle.id}">
                                                            <button type="submit" class="btn btn-link text-danger p-0"><i class="fas fa-trash"></i></button>
                                                        </form>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>

                                    <!-- MODAL ANNEXE A (Similaire Clause) -->
                                    <div class="modal fade" id="modalA_${soa.id.toString().replace('-','')}" tabindex="-1" role="dialog" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content shadow-lg border-0">
                                                <form action="/audit/constat/save" method="post">
                                                    <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="controleId" value="${soa.controle.id}"><input type="hidden" name="source" value="ANNEXE_A">
                                                    <div class="modal-header bg-danger text-white"><h5 class="modal-title font-weight-bold">Mesure : ${soa.controle.code}</h5><button type="button" class="close text-white" data-dismiss="modal">&times;</button></div>
                                                    <div class="modal-body p-4">
                                                        <div class="form-group"><label class="small font-weight-bold">Niveau de maturité (0-5)</label>
                                                            <select name="niveauMaturite" class="form-control" required><option value="" disabled selected>Niveau...</option><option>0 - Inexistant</option><option>1 - Initialisé</option><option>2 - Reproductible</option><option>3 - Défini</option><option>4 - Géré</option><option>5 - Optimisé</option><option>Non applicable</option></select></div>
                                                        <div class="form-group"><label class="small font-weight-bold">Observations / Évidence</label><textarea id="desc_a_${soa.id}" name="description" class="form-control" rows="3" required placeholder="Preuves..."></textarea></div>
                                                        <div class="form-group"><label class="d-flex justify-content-between small font-weight-bold">Recommandation <button type="button" class="btn btn-link btn-xs p-0 text-primary" onclick="getAiSuggestion('a_${soa.id}', '${soa.controle.code}')"><i class="fas fa-robot mr-1"></i> Aide IA</button></label><textarea id="rec_a_${soa.id}" name="recommandation" class="form-control bg-light" rows="3"></textarea><div id="loader_a_${soa.id}" class="spinner-border spinner-border-sm text-primary ai-loader mt-1"></div></div>
                                                    </div>
                                                    <div class="modal-footer"><button type="submit" class="btn btn-dark btn-block shadow font-weight-bold">VALIDER L'ÉVALUATION</button></div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- SCRIPT DE LOGIQUE ET IA -->
    <script>
        async function getAiSuggestion(fieldId, code) {
            const descField = document.getElementById('desc_' + fieldId);
            const recField = document.getElementById('rec_' + fieldId);
            const loader = document.getElementById('loader_' + fieldId);
            if (!descField.value) { alert("Détaillez d'abord votre observation pour l'analyse."); return; }
            loader.style.display = 'inline-block';
            try {
                const res = await fetch('/api/ai/audit-assist', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ prompt: descField.value, controlCode: code })
                });
                recField.value = await res.text();
            } catch (e) {
                alert("Ollama ou API déconnecté. Vérifiez l'IA.");
            } finally { loader.style.display = 'none'; }
        }

        // Persistance des onglets et autoscroll
        document.addEventListener("DOMContentLoaded", function() {
            // Recharger l'onglet actif après une action de sauvegarde
            const activeTab = localStorage.getItem('lastAuditTab');
            if (activeTab) {
                $('.nav-tabs a[href="' + activeTab + '"]').tab('show');
            }
            $('.nav-tabs a').on('shown.bs.tab', function (e) {
                localStorage.setItem('lastAuditTab', $(e.target).attr('href'));
            });

            // Focus sur le prochain élément à traiter si on vient d'une sauvegarde
            const params = new URLSearchParams(window.location.search);
            if (params.get('lastProcessedId')) {
                const nextItem = document.querySelector('.tab-pane.active .not-done');
                if (nextItem) {
                    const parentCollapse = nextItem.closest('.collapse');
                    if (parentCollapse) $(parentCollapse).collapse('show');
                    nextItem.classList.add('next-up');
                    nextItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });
    </script>

</t:layout>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Audit Interne Professionnel | ISO 27001</title>
    <!-- CSS Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; --iso-gray: #F4F4F4; --success-green: #198754; }
        body { background-color: var(--iso-gray); font-family: 'Inter', sans-serif; color: var(--iso-dark); scroll-behavior: smooth; }

        .navbar { border-bottom: 3px solid var(--iso-red); }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 20px; margin-bottom: 30px; }

        /* Navigation */
        .nav-tabs .nav-link { color: var(--iso-dark); font-weight: 600; border: none; padding: 12px 25px; border-bottom: 3px solid transparent; }
        .nav-tabs .nav-link.active { color: var(--iso-red); border-bottom-color: var(--iso-red); background: transparent; }

        /* Accordéons */
        .accordion-item { border: none; margin-bottom: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-radius: 8px !important; overflow: hidden; }
        .accordion-button { font-weight: 700; color: var(--iso-dark); background-color: white !important; }
        .accordion-button:not(.collapsed) { color: var(--iso-red); box-shadow: none; border-bottom: 1px solid #eee; }

        /* Lignes d'audit */
        .audit-row { transition: 0.3s; background: white; border-bottom: 1px solid #eee; }
        .audit-row.is-done { background-color: #f8fff9 !important; }
        .next-up { border: 2px solid var(--iso-red) !important; background-color: #fff5f5 !important; animation: pulse 1s 3; }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.7; } 100% { opacity: 1; } }

        /* STYLE DES MODALS UNIFIÉ */
        .modal-content { border-radius: 16px; overflow: hidden; border: none; }
        .modal-header { background: linear-gradient(135deg, var(--iso-dark) 0%, #2c2c2c 100%); color: white; padding: 1.25rem; }
        .modal-body { padding: 1.5rem 2rem; }
        .modal-footer { padding: 1.5rem; border-top: 1px solid #eee; background: #fafafa; }
        .form-label { font-weight: 700; font-size: 0.8rem; text-transform: uppercase; color: #555; letter-spacing: 0.5px; }

        .btn-save-nc { background-color: var(--iso-red); color: white; font-weight: 800; padding: 12px; border: none; text-transform: uppercase; width: 100%; border-radius: 8px; transition: 0.3s; }
        .btn-save-nc:hover { background-color: #a8010a; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(210,1,13,0.2); }

        .code-tag { font-weight: 700; color: var(--iso-red); }
        .ai-loader { display: none; }
    </style>
</head>
<body class="py-4">

<nav class="navbar navbar-light bg-white border-bottom py-3 mb-4 shadow-sm no-print">
    <div class="container">
        <div class="d-flex align-items-center">
            <div class="bg-danger text-white px-3 py-1 fw-bold me-3 rounded shadow-sm">ISO 27001</div>
            <span class="fw-bold text-dark text-uppercase">Système d'Audit Interne Professionnel</span>
        </div>
        <div class="d-flex gap-2">
            <a href="/audit/resultat/${audit.id}" class="btn btn-primary btn-sm px-4 fw-bold shadow-sm">
                <i class="bi bi-file-earmark-bar-graph"></i> RÉSULTATS
            </a>
            <a href="/audit/missions" class="btn btn-outline-dark btn-sm fw-bold">QUITTER</a>
        </div>
    </div>
</nav>

<main class="container">
    <!-- Barre de progression générale fixée -->
    <div class="page-header mb-4">
        <h2 class="fw-bold m-0 uppercase">${audit.titre}</h2>
        <c:set var="totalRequirements" value="${fn:length(subClausesList) + fn:length(soaApplicables)}" />

        &lt;%&ndash; Compter les constats réels (clauses et contrôles) &ndash;%&gt;
        <c:set var="auditedClauseCount" value="0" />
        <c:set var="auditedControleCount" value="0" />
        <c:forEach var="constat" items="${audit.constats}">
            <c:if test="${constat.clauseIso != null}">
                <c:set var="auditedClauseCount" value="${auditedClauseCount + 1}" />
            </c:if>
            <c:if test="${constat.controle != null}">
                <c:set var="auditedControleCount" value="${auditedControleCount + 1}" />
            </c:if>
        </c:forEach>
        <c:set var="totalDone" value="${auditedClauseCount + auditedControleCount}" />
        <c:set var="progGlobalPct" value="${totalRequirements > 0 ? (totalDone * 100 / totalRequirements) : 0}" />

        <div class="mt-3 bg-white p-3 rounded shadow-sm border d-inline-block" style="min-width: 350px;">
            <div class="d-flex justify-content-between mb-1 small fw-bold">
                <span class="text-muted text-uppercase">État global de l'Audit</span>
                <span class="text-danger"><fmt:formatNumber value="${progGlobalPct}" maxFractionDigits="0"/>% RÉALISÉ</span>
            </div>
            <div class="progress" style="height: 8px;"><div class="progress-bar bg-danger shadow-sm" style="width: ${progGlobalPct}%"></div></div>
            <small class="text-muted" style="font-size: 0.65rem;">${totalDone} sur ${totalRequirements} points évalués</small>
        </div>
    </div>

    <!-- Onglets -->
    <ul class="nav nav-tabs mb-4" id="auditTab">
        <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabClauses"><i class="bi bi-list-check"></i> Exigences SMSI (4-10)</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabAnnexe"><i class="bi bi-shield-lock"></i> Mesures de l'Annexe A</button></li>
    </ul>

    <div class="tab-content">
        <!-- ONGLET 1 : CLAUSES -->
        <div class="tab-pane fade show active" id="tabClauses">
            <div class="accordion" id="accAudit">
                <c:forEach var="parent" items="${parentChapters}" varStatus="pStatus">
                    <!-- CALCUL CONFORMITÉ CHAPITRE -->
                    <c:set var="subCount" value="0" />
                    <c:set var="confCount" value="0" />
                    <c:forEach var="sub" items="${subClausesList}">
                        <c:if test="${sub.parent.id == parent.id}">
                            <c:set var="subCount" value="${subCount + 1}" />
                            <c:forEach var="c" items="${audit.constats}">
                                <c:if test="${c.clauseIso.id == sub.id && c.type == 'Conforme'}"><c:set var="confCount" value="${confCount + 1}" /></c:if>
                            </c:forEach>
                        </c:if>
                    </c:forEach>
                    <c:set var="cPct" value="${subCount > 0 ? (confCount * 100 / subCount) : 0}" />

                    <div class="accordion-item shadow-sm">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed d-flex justify-content-between" type="button" data-bs-toggle="collapse" data-bs-target="#chapter${pStatus.index}">
                                <div class="w-100 d-flex justify-content-between align-items-center me-3">
                                    <span><strong>Chapitre ${parent.code}</strong> : ${parent.titre}</span>
                                    <div class="text-end" style="width: 140px;">
                                        <div class="progress" style="height: 5px;"><div class="progress-bar bg-success" style="width: ${cPct}%"></div></div>
                                        <small class="text-muted fw-bold" style="font-size: 0.6rem;">CONFORMITÉ : ${cPct}%</small>
                                    </div>
                                </div>
                            </button>
                        </h2>

                        <div id="chapter${pStatus.index}" class="accordion-collapse collapse">
                            <div class="accordion-body p-0">
                                <table class="table table-hover align-middle mb-0">
                                    <tbody>
                                    <c:forEach var="sub" items="${subClausesList}">
                                        <c:if test="${sub.parent.id == parent.id}">
                                            <c:set var="curConstat" value="${null}" />
                                            <c:forEach var="constat" items="${audit.constats}">
                                                <c:if test="${constat.clauseIso.id == sub.id}"><c:set var="curConstat" value="${constat}" /></c:if>
                                            </c:forEach>

                                            <tr id="row_sc_${sub.id}" class="audit-row ${curConstat != null ? 'is-done' : 'not-done'}">
                                                <td width="70" class="ps-4 fw-bold code-tag">${sub.code}</td>
                                                <td><strong>${sub.titre}</strong><br><small class="text-muted italic">${sub.exigences}</small></td>
                                                <td class="text-end pe-4" width="240">
                                                    <c:choose>
                                                        <c:when test="${curConstat == null}">
                                                            <button class="btn btn-dark btn-sm rounded-pill px-4 shadow-sm fw-bold" data-bs-toggle="modal" data-bs-target="#modalSc_${sub.id.toString().replace('-','')}">AUDITER</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="d-flex align-items-center justify-content-end">
&lt;%&ndash;                                                                <span class="badge ${curConstat.type == 'Conforme' ? 'bg-success' : 'bg-warning text-dark'} p-2 me-3 rounded-pill px-3 shadow-sm">${curConstat.type}</span>&ndash;%&gt;
                                                                <span class="badge ${curConstat.type == 'Conforme' ? 'bg-success' : (curConstat.type == 'Observation' ? 'bg-info' : (curConstat.type == 'NC Mineur' ? 'bg-warning' : 'bg-danger'))} me-3 px-3 py-2 rounded-pill shadow-sm">
                                                                    <i class="bi ${curConstat.type == 'Conforme' ? 'bi-check-all' : (curConstat.type == 'Observation' ? 'bi-eye' : (curConstat.type == 'NC Mineur' ? 'bi-exclamation-triangle' : 'bi-x-octagon'))}"></i>
                                                                    ${curConstat.type}
                                                                </span>
                                                                <form action="/audit/constat/supprimer" method="post" class="d-inline" onsubmit="return confirm('Voulez-vous supprimer ce constat ?')">
                                                                    <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="clauseId" value="${sub.id}">
                                                                    <button type="submit" class="btn btn-link text-danger p-0" title="Réinitialiser"><i class="bi bi-trash-fill fs-5"></i></button>
                                                                </form>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>

                                            <!-- MODAL CLAUSE -->
                                            <div class="modal fade" id="modalSc_${sub.id.toString().replace('-','')}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content shadow-lg border-0">
                                                        <form action="/audit/constat/save" method="post">
                                                            <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="clauseId" value="${sub.id}"><input type="hidden" name="source" value="CLAUSE">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title fw-bold">Point d'Audit : ${sub.code}</h5>
                                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <label class="form-label">Statut de conformité</label>
                                                                <select name="type" class="form-select border-2 mb-4" required>
                                                                    <option value="" disabled selected>Verdict...</option>
                                                                    <option value="Conforme">✅ Conforme</option>
                                                                    <option value="Observation">👁️ Observation</option>
                                                                    <option value="NC Mineur">⚠️ NC Mineur</option>
                                                                    <option value="NC Majeur">🚨 NC Majeur</option>
                                                                    <option value="Opportunité d'amélioration">📈 Opportunité d'amélioration</option>
                                                                </select>
                                                                <label class="form-label">Description et Preuves d'Audit</label>
                                                                <textarea id="desc_sc_${sub.id}" name="description" class="form-control border-2 mb-4" rows="3" required placeholder="Observations relevées..."></textarea>
                                                                <label class="form-label d-flex justify-content-between fw-bold">Recommandation <button type="button" class="btn btn-link btn-sm p-0 text-primary text-decoration-none" onclick="getAiSuggestion('sc_${sub.id}', '${sub.code}')"><i class="bi bi-robot"></i> Aide IA</button></label>
                                                                <textarea id="rec_sc_${sub.id}" name="recommandation" class="form-control border-2 bg-light" rows="3"></textarea>
                                                                <div id="loader_sc_${sub.id}" class="spinner-border spinner-border-sm text-primary ai-loader mt-2"></div>
                                                            </div>
                                                            <div class="modal-footer"><button type="submit" class="btn-save-nc">VALIDER L'EXIGENCE</button></div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- ONGLET 2 : ANNEXE A (statut conformité + re-traiter + recommandation IA) -->
        <div class="tab-pane fade" id="tabAnnexe">
            <div class="card iso-card shadow-sm border-0 overflow-hidden">
                <table class="table align-middle mb-0">
                    <thead class="bg-danger text-white">
                    <tr><th class="ps-4 py-3">Code</th><th>Mesure Technique de l'Annexe A</th><th class="text-center">Action / État</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="soa" items="${soaApplicables}">
                        &lt;%&ndash; Recherche d'un constat existant pour ce contrôle &ndash;%&gt;
                        <c:set var="curConstat" value="${null}" />
                        <c:forEach var="constat" items="${audit.constats}">
                            <c:if test="${constat.controle.id == soa.controle.id}">
                                <c:set var="curConstat" value="${constat}" />
                            </c:if>
                        </c:forEach>
                        <tr id="ann_row_${soa.controle.id}" class="audit-row ${curConstat != null ? 'is-done' : 'not-done'}">
                            <td width="70" class="ps-4 fw-bold code-tag">${soa.controle.code}</td>
                            <td><strong>${soa.controle.titre}</strong><br><small class="text-muted">Justification : ${soa.justification}</small></td>
                            <td class="text-center" width="240">
                                <c:choose>
                                    <c:when test="${curConstat == null}">
                                        <button class="btn btn-danger btn-sm rounded-pill px-4 fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#modalA_${soa.id.toString().replace('-','')}">AUDITER</button>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="d-flex align-items-center justify-content-center">
                                            <span class="badge
                                                ${curConstat.niveauMaturite == 'Non applicable' ? 'bg-secondary' :
                                                  (curConstat.niveauMaturite.contains('0') ? 'bg-danger' :
                                                  (curConstat.niveauMaturite.contains('1') ? 'bg-danger' :
                                                  (curConstat.niveauMaturite.contains('2') ? 'bg-warning text-dark' :
                                                  (curConstat.niveauMaturite.contains('3') ? 'bg-warning text-dark' :
                                                  (curConstat.niveauMaturite.contains('4') ? 'bg-success' :
                                                  (curConstat.niveauMaturite.contains('5') ? 'bg-success' : 'bg-secondary'))))))}
                                                me-3 px-3 py-2 rounded-pill shadow-sm">
                                                <i class="bi
                                                    ${curConstat.niveauMaturite == 'Non applicable' ? 'bi-dash-circle' :
                                                     (curConstat.niveauMaturite.contains('0') ? 'bi-0-circle' :
                                                     (curConstat.niveauMaturite.contains('1') ? 'bi-1-circle' :
                                                     (curConstat.niveauMaturite.contains('2') ? 'bi-2-circle' :
                                                     (curConstat.niveauMaturite.contains('3') ? 'bi-3-circle' :
                                                     (curConstat.niveauMaturite.contains('4') ? 'bi-4-circle' :
                                                     (curConstat.niveauMaturite.contains('5') ? 'bi-5-circle' : 'bi-question-circle'))))))}">
                                                </i>
                                                ${curConstat.niveauMaturite}
                                            </span>
                                            <!-- Bouton Re-traiter -->
                                            <form action="/audit/constat/supprimer" method="post" class="d-inline" onsubmit="return confirm('Re-auditer cette mesure ?')">
                                                <input type="hidden" name="auditId" value="${audit.id}">
                                                <input type="hidden" name="controleId" value="${soa.controle.id}">
                                                <button type="submit" class="btn btn-link text-danger p-0" title="Re-traiter"><i class="bi bi-trash-fill fs-5"></i></button>
                                            </form>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <!-- MODAL ANNEXE A (Statut de conformité + Recommandation IA) -->
                        <div class="modal fade" id="modalA_${soa.id.toString().replace('-','')}" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content shadow-lg border-0">
                                    <form action="/audit/constat/save" method="post">
                                        <input type="hidden" name="auditId" value="${audit.id}">
                                        <input type="hidden" name="controleId" value="${soa.controle.id}">
                                        <input type="hidden" name="source" value="ANNEXE_A">
                                        <div class="modal-header" style="background: linear-gradient(135deg, #d2010d 0%, #a8010a 100%);">
                                            <h5 class="modal-title fw-bold">Audit : ${soa.controle.code}</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body p-4">
                                            <!-- Statut de conformité -->
&lt;%&ndash;                                            <label class="form-label">Statut de conformité</label>&ndash;%&gt;
&lt;%&ndash;                                            <select name="type" class="form-select border-2 mb-4" required>&ndash;%&gt;
&lt;%&ndash;                                                <option value="" disabled selected>Verdict...</option>&ndash;%&gt;
&lt;%&ndash;                                                <option value="Conforme">✅ Conforme</option>&ndash;%&gt;
&lt;%&ndash;                                                <option value="Observation">👁️ Observation</option>&ndash;%&gt;
&lt;%&ndash;                                                <option value="NC Mineur">⚠️ NC Mineur</option>&ndash;%&gt;
&lt;%&ndash;                                                <option value="NC Majeur">🚨 NC Majeur</option>&ndash;%&gt;
&lt;%&ndash;                                                <option value="Opportunité d'amélioration">📈 Opportunité d'amélioration</option>&ndash;%&gt;
&lt;%&ndash;                                            </select>&ndash;%&gt;
                                            <!-- Niveau de maturité -->
                                            <label class="form-label">Niveau de maturité (0-5)</label>
                                            <select name="niveauMaturite" class="form-select border-2 mb-4" required>
                                                <option value="" disabled selected>Niveau de maturité...</option>
                                                <option>0 - Inexistant</option><option>1 - Initialisé</option>
                                                <option>2 - Reproductible</option><option>3 - Défini</option>
                                                <option>4 - Géré</option><option>5 - Optimisé</option>
                                                <option>Non applicable</option>
                                            </select>
                                            <!-- Observations -->
                                            <label class="form-label">Observations / Preuves récoltées</label>
                                            <textarea id="desc_a_${soa.id}" name="description" class="form-control border-2 mb-2" rows="3" required placeholder="Détaillez les preuves d'audit..."></textarea>
                                            <!-- Recommandation avec IA -->
                                            <label class="form-label d-flex justify-content-between fw-bold mt-3">
                                                Recommandation
                                                <button type="button" class="btn btn-link btn-sm p-0 text-primary text-decoration-none" onclick="getAiSuggestion('a_${soa.id}', '${soa.controle.code}')">
                                                    <i class="bi bi-robot"></i> Aide IA
                                                </button>
                                            </label>
                                            <textarea id="rec_a_${soa.id}" name="recommandation" class="form-control border-2 bg-light" rows="3"></textarea>
                                            <div id="loader_a_${soa.id}" class="spinner-border spinner-border-sm text-primary ai-loader mt-2"></div>
                                        </div>
                                        <div class="modal-footer border-0">
                                            <button type="submit" class="btn-save-nc" style="background-color: var(--iso-dark);">Valider l'évaluation</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const activeTab = localStorage.getItem('lastAuditTab') || '#tabClauses';
        const trigger = document.querySelector('button[data-bs-target="' + activeTab + '"]');
        if (trigger) bootstrap.Tab.getOrCreateInstance(trigger).show();
        document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(btn => {
            btn.addEventListener('shown.bs.tab', e => localStorage.setItem('lastAuditTab', e.target.getAttribute('data-bs-target')));
        });

        const params = new URLSearchParams(window.location.search);
        if (params.get('lastProcessedId')) {
            const currentTab = localStorage.getItem('lastAuditTab') || '#tabClauses';
            const nextItem = document.querySelector(currentTab + ' .not-done');
            if (nextItem) {
                const coll = nextItem.closest('.accordion-collapse');
                if (coll) bootstrap.Collapse.getOrCreateInstance(coll).show();
                nextItem.classList.add('next-up');
                nextItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    });

    async function getAiSuggestion(fieldId, code) {
        const descField = document.getElementById('desc_' + fieldId);
        const recField = document.getElementById('rec_' + fieldId);
        const loader = document.getElementById('loader_' + fieldId);
        if (!descField.value) return alert("Saisissez un fait constaté pour l'analyse.");
        loader.style.display = 'inline-block';
        try {
            const res = await fetch('/api/ai/audit-assist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ prompt: descField.value, controlCode: code })
            });
            recField.value = await res.text();
        } catch (e) { alert("IA hors-ligne."); } finally { loader.style.display = 'none'; }
    }
</script>
</body>
</html>--%>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Audit Interne Professionnel | ISO 27001</title>
    <!-- CSS Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; --iso-gray: #F4F4F4; --success-green: #198754; }
        body { background-color: var(--iso-gray); font-family: 'Inter', sans-serif; scroll-behavior: smooth; }

        .navbar { border-bottom: 3px solid var(--iso-red); }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 20px; margin-bottom: 30px; }

        /* Navigation */
        .nav-tabs .nav-link { color: var(--iso-dark); font-weight: 600; border: none; padding: 12px 25px; border-bottom: 3px solid transparent; }
        .nav-tabs .nav-link.active { color: var(--iso-red); border-bottom-color: var(--iso-red); background: transparent; }

        /* Accordéons */
        .accordion-item { border: none; margin-bottom: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-radius: 8px !important; overflow: hidden; }
        .accordion-button { font-weight: 700; color: var(--iso-dark); background-color: white !important; }
        .accordion-button:not(.collapsed) { color: var(--iso-red); box-shadow: none; border-bottom: 1px solid #eee; }

        /* Lignes d'audit */
        .audit-row { transition: 0.3s; background: white; border-bottom: 1px solid #eee; }
        .audit-row.is-done { background-color: #f8fff9 !important; }
        .next-up { border: 2px solid var(--iso-red) !important; background-color: #fff5f5 !important; animation: pulse 1s 3; }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.7; } 100% { opacity: 1; } }

        /* STYLE DES MODALS UNIFIÉ */
        .modal-content { border-radius: 16px; overflow: hidden; border: none; }
        .modal-header { background: linear-gradient(135deg, var(--iso-dark) 0%, #2c2c2c 100%); color: white; padding: 1.25rem; }
        .modal-body { padding: 1.5rem 2rem; }
        .modal-footer { padding: 1.5rem; border-top: 1px solid #eee; background: #fafafa; }
        .form-label { font-weight: 700; font-size: 0.75rem; text-transform: uppercase; color: #555; letter-spacing: 0.5px; }

        .btn-save-nc { background-color: var(--iso-red); color: white; font-weight: 800; padding: 12px; border: none; text-transform: uppercase; width: 100%; border-radius: 8px; transition: 0.3s; }
        .btn-save-nc:hover { background-color: #a8010a; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(210,1,13,0.2); }

        .code-tag { font-weight: 700; color: var(--iso-red); }
        .ai-loader { display: none; }
    </style>
</head>
<body class="py-4">

<nav class="navbar navbar-light bg-white border-bottom py-3 mb-4 shadow-sm no-print">
    <div class="container">
        <div class="d-flex align-items-center">
            <div class="bg-danger text-white px-3 py-1 fw-bold me-3 rounded shadow-sm">ISO 27001</div>
            <span class="fw-bold text-dark text-uppercase tracking-wider">Interface d'Audit Interne</span>
        </div>
        <div class="d-flex gap-2">
            <a href="/audit/resultat/${audit.id}" class="btn btn-primary btn-sm px-4 fw-bold shadow-sm">
                <i class="bi bi-file-earmark-bar-graph"></i> VOIR RÉSULTATS
            </a>
            <a href="/audit/missions" class="btn btn-outline-dark btn-sm fw-bold">QUITTER</a>
        </div>
    </div>
</nav>

<main class="container">
    <div class="page-header mb-4">
        <h2 class="fw-bold m-0 uppercase">${audit.titre}</h2>

        &lt;%&ndash; CALCUL PROGRESSION GENERALE REELLE (Somme des items faits / total possibles) &ndash;%&gt;
        <c:set var="totalRequirements" value="${fn:length(subClausesList) + fn:length(soaApplicables)}" />
        <c:set var="totalDone" value="${fn:length(auditedClauseIds) + fn:length(auditedControleIds)}" />
        <c:set var="progGlobalPct" value="${totalRequirements > 0 ? (totalDone * 100 / totalRequirements) : 0}" />

        <div class="mt-3 bg-white p-3 rounded shadow-sm border d-inline-block" style="min-width: 350px;">
            <div class="d-flex justify-content-between mb-1 small fw-bold">
                <span class="text-muted">DÉROULEMENT DE L'AUDIT</span>
                <span class="text-danger"><fmt:formatNumber value="${progGlobalPct}" maxFractionDigits="0"/>% COMPLÉTÉ</span>
            </div>
            <div class="progress" style="height: 8px;"><div class="progress-bar bg-danger shadow-sm" style="width: ${progGlobalPct}%"></div></div>
        </div>
    </div>

    <!-- Onglets -->
    <ul class="nav nav-tabs mb-4" id="auditTab">
        <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabClauses"><i class="bi bi-list-check"></i> Exigences (4-10)</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabAnnexe"><i class="bi bi-shield-lock"></i> Mesures Annexe A</button></li>
    </ul>

    <div class="tab-content">
        <!-- ONGLET 1 : CLAUSES -->
        <div class="tab-pane fade show active" id="tabClauses">
            <div class="accordion" id="accAudit">
                <c:forEach var="parent" items="${parentChapters}" varStatus="pStatus">
                    <!-- CALCUL DU % DE CONFORMITE DU CHAPITRE -->
                    <c:set var="subCount" value="0" />
                    <c:set var="confCount" value="0" />
                    <c:forEach var="sub" items="${subClausesList}">
                        <c:if test="${sub.parent.id == parent.id}">
                            <c:set var="subCount" value="${subCount + 1}" />
                            <c:forEach var="c" items="${audit.constats}">
                                <c:if test="${c.clauseIso.id == sub.id && c.type == 'Conforme'}"><c:set var="confCount" value="${confCount + 1}" /></c:if>
                            </c:forEach>
                        </c:if>
                    </c:forEach>
                    <c:set var="cPct" value="${subCount > 0 ? (confCount * 100 / subCount) : 0}" />

                    <div class="accordion-item shadow-sm">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed d-flex justify-content-between" type="button" data-bs-toggle="collapse" data-bs-target="#chapter${pStatus.index}">
                                <div class="w-100 d-flex justify-content-between align-items-center me-3">
                                    <span><strong>Chapitre ${parent.code}</strong> : ${parent.titre}</span>
                                    <div class="text-end" style="width: 160px;">
                                        <div class="progress" style="height: 5px;"><div class="progress-bar bg-success" style="width: ${cPct}%"></div></div>
                                        <small class="text-muted fw-bold" style="font-size: 0.65rem;">CONFORMITÉ : ${cPct}%</small>
                                    </div>
                                </div>
                            </button>
                        </h2>

                        <div id="chapter${pStatus.index}" class="accordion-collapse collapse">
                            <div class="accordion-body p-0">
                                <table class="table table-hover align-middle mb-0">
                                    <tbody>
                                    <c:forEach var="sub" items="${subClausesList}">
                                        <c:if test="${sub.parent.id == parent.id}">
                                            <c:set var="curConstat" value="${null}" />
                                            <c:forEach var="constat" items="${audit.constats}">
                                                <c:if test="${constat.clauseIso.id == sub.id}"><c:set var="curConstat" value="${constat}" /></c:if>
                                            </c:forEach>

                                            <tr id="row_sc_${sub.id}" class="audit-row ${curConstat != null ? 'is-done' : 'not-done'}">
                                                <td width="70" class="ps-4 fw-bold code-tag">${sub.code}</td>
                                                <td><strong>${sub.titre}</strong><br><small class="text-muted italic">${sub.exigences}</small></td>
                                                <td class="text-end pe-4" width="240">
                                                    <c:choose>
                                                        <c:when test="${curConstat == null}">
                                                            <button class="btn btn-dark btn-sm rounded-pill px-4 shadow-sm fw-bold" data-bs-toggle="modal" data-bs-target="#modalSc_${sub.id.toString().replace('-','')}">AUDITER</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="d-flex align-items-center justify-content-end">
                                                                <span class="badge ${curConstat.type == 'Conforme' ? 'bg-success' : 'bg-warning text-dark'} p-2 me-3 rounded-pill px-3 shadow-sm">${curConstat.type}</span>
                                                                <form action="/audit/constat/supprimer" method="post" class="d-inline" onsubmit="return confirm('Réinitialiser cet audit ?')">
                                                                    <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="clauseId" value="${sub.id}">
                                                                    <button type="submit" class="btn btn-link text-danger p-0" title="Effacer pour recommencer"><i class="bi bi-trash-fill"></i></button>
                                                                </form>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>

                                            <!-- MODAL CLAUSE -->
                                            <div class="modal fade" id="modalSc_${sub.id.toString().replace('-','')}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content shadow-lg border-0">
                                                        <form action="/audit/constat/save" method="post">
                                                            <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="clauseId" value="${sub.id}"><input type="hidden" name="source" value="CLAUSE">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title fw-bold">Point d'Audit : Clause ${sub.code}</h5>
                                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <label class="form-label">Statut de conformité</label>
                                                                <select name="type" class="form-select border-2 mb-4" required>
                                                                    <option value="" disabled selected>Verdict...</option>
                                                                    <option value="Conforme">✅ Conforme</option>
                                                                    <option value="NC Mineur">⚠️ NC Mineur</option>
                                                                    <option value="NC Majeur">🚨 NC Majeur</option>
                                                                    <option value="Observation">👁️ Observation</option>
                                                                    <option value="Opportunité d'amélioration">📈 Opportunité d'amélioration</option>
                                                                </select>
                                                                <label class="form-label">Description (Observations et Preuves)</label>
                                                                <textarea id="desc_sc_${sub.id}" name="description" class="form-control border-2 mb-4" rows="3" required placeholder="Faits relevés pendant l'audit..."></textarea>
                                                                <label class="form-label d-flex justify-content-between fw-bold">Recommandation <button type="button" class="btn btn-link btn-sm p-0 text-primary text-decoration-none" onclick="getAiSuggestion('sc_${sub.id}', '${sub.code}')"><i class="bi bi-robot"></i> Aide IA</button></label>
                                                                <textarea id="rec_sc_${sub.id}" name="recommandation" class="form-control border-2 bg-light" rows="3" placeholder="Recommandations d'audit..."></textarea>
                                                                <div id="loader_sc_${sub.id}" class="spinner-border spinner-border-sm text-primary ai-loader mt-2"></div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="submit" class="btn-save-nc">Valider l'exigence</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- ONGLET 2 : ANNEXE A -->
        <div class="tab-pane fade" id="tabAnnexe">
            <div class="card iso-card shadow-sm border-0 overflow-hidden">
                <table class="table align-middle mb-0">
                    <thead class="bg-danger text-white"><tr class="bg-danger text-white"><th class="ps-4 py-3">Code</th><th>Mesure de Sécurité</th><th class="text-center">Action / État</th></tr></thead>
                    <tbody>
                    <c:forEach var="soa" items="${soaApplicables}">
                        <c:set var="isAudA" value="${auditedControleIds.contains(soa.controle.id.toString())}" />
                        <tr id="ann_row_${soa.controle.id}" class="audit-row ${isAudA ? 'is-done' : 'not-done'}">
                            <td width="80" class="ps-4 fw-bold code-tag">${soa.controle.code}</td>
                            <td><strong>${soa.controle.titre}</strong></td>
                            <td class="text-center" width="220">
                                <c:choose>
                                    <c:when test="${!isAudA}">
                                        <button class="btn btn-danger btn-sm rounded-pill px-4 fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#modalA_${soa.id.toString().replace('-','')}">AUDITER</button>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="d-flex align-items-center justify-content-center">
                                            <span class="badge bg-success me-3 px-3 shadow-sm rounded-pill"><i class="bi bi-check-all"></i> VALIDÉ</span>
                                            <form action="/audit/constat/supprimer" method="post" class="d-inline">
                                                <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="controleId" value="${soa.controle.id}">
                                                <button type="submit" class="btn btn-link text-danger p-0 me-1"><i class="bi bi-trash-fill fs-6"></i></button>
                                            </form>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <!-- MODAL ANNEXE A STYLE CORPORATE UNIFIÉ -->
                        <div class="modal fade" id="modalA_${soa.id.toString().replace('-','')}" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content shadow-lg border-0">
                                    <form action="/audit/constat/save" method="post">
                                        <input type="hidden" name="auditId" value="${audit.id}"><input type="hidden" name="controleId" value="${soa.controle.id}"><input type="hidden" name="source" value="ANNEXE_A">
                                        <div class="modal-header">
                                            <h5 class="modal-title fw-bold">Mesure Technique : ${soa.controle.code}</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-4">
                                                <label class="form-label">Niveau de maturité observé (0-5)</label>
                                                <select name="niveauMaturite" class="form-select border-2" required>
                                                    <option value="" disabled selected>Niveau de maturité...</option>
                                                    <option>0 - Inexistant</option><option>1 - Initialisé</option>
                                                    <option>2 - Reproductible</option><option>3 - Défini</option>
                                                    <option>4 - Géré</option><option>5 - Optimisé</option>
                                                    <option>Non applicable</option>
                                                </select>
                                            </div>
                                            <div class="mb-4">
                                                <label class="form-label">Constat et Preuves terrain</label>
                                                <textarea id="desc_a_${soa.id}" name="description" class="form-control border-2" rows="3" required placeholder="Description des faits..."></textarea>
                                            </div>
                                            <div class="mb-2">
                                                <label class="form-label d-flex justify-content-between fw-bold">
                                                    Suggérer une action corrective (IA)
                                                    <button type="button" class="btn btn-link btn-sm p-0 text-danger fw-bold text-decoration-none" onclick="getAiSuggestion('a_${soa.id}', '${soa.controle.code}')">
                                                        <i class="bi bi-robot"></i> Phi-3 Robot
                                                    </button>
                                                </label>
                                                <textarea id="rec_a_${soa.id}" name="recommandation" class="form-control border-2 bg-light" rows="3"></textarea>
                                                <div id="loader_a_${soa.id}" class="spinner-border spinner-border-sm text-danger ai-loader mt-2"></div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="submit" class="btn-save-nc" style="background-color: var(--iso-dark);">Valider l'Annexe A</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // --- 1. PERSISTANCE ONGLETS ---
        const activeTab = localStorage.getItem('lastAuditTab') || '#tabClauses';
        const tabTrigger = document.querySelector('button[data-bs-target="' + activeTab + '"]');
        if (tabTrigger) bootstrap.Tab.getOrCreateInstance(tabTrigger).show();
        document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(b => {
            b.addEventListener('shown.bs.tab', e => localStorage.setItem('lastAuditTab', e.target.getAttribute('data-bs-target')));
        });

        // --- 2. POINTAGE VERS LE SUIVANT ---
        const params = new URLSearchParams(window.location.search);
        if (params.get('lastProcessedId')) {
            const currentTab = localStorage.getItem('lastAuditTab');
            const nextItem = document.querySelector(currentTab + ' .not-done');
            if (nextItem) {
                // Auto-expand accordéon
                const collapseParent = nextItem.closest('.accordion-collapse');
                if (collapseParent && !collapseParent.classList.contains('show')) bootstrap.Collapse.getOrCreateInstance(collapseParent).show();
                nextItem.classList.add('next-up');
                nextItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
                setTimeout(() => nextItem.classList.remove('next-up'), 3000);
            }
        }
    });

    async function getAiSuggestion(fieldId, code) {
        const descF = document.getElementById('desc_' + fieldId);
        const recF = document.getElementById('rec_' + fieldId);
        const loader = document.getElementById('loader_' + fieldId);
        if (!descF.value) return alert("Remplissez d'abord les faits constatés.");

        loader.style.display = 'inline-block';
        recF.placeholder = "Analyse IA...";
        try {
            const res = await fetch('/api/ai/audit-assist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ prompt: descF.value, controlCode: code })
            });
            recF.value = await res.text();
        } catch (e) { alert("Erreur IA locale."); } finally { loader.style.display = 'none'; }
    }
</script>
</body>
</html>--%>

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Audit Interne Professionnel - SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; --iso-gray: #F4F4F4; --success-green: #198754; }
        body { background-color: var(--iso-gray); font-family: 'Inter', sans-serif; color: var(--iso-dark); scroll-behavior: smooth; }

        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; margin-bottom: 30px; }

        /* État des Cartes */
        .iso-card { background: white; border: none; border-radius: 6px; transition: 0.3s; position: relative; overflow: hidden; }
        .iso-card.not-audited { border-left: 5px solid #0dcaf0; }
        .iso-card.is-audited { border-left: 5px solid var(--success-green); opacity: 0.85; background-color: #f8fff9; }
        .iso-card.current-target { border: 2px solid var(--iso-red); box-shadow: 0 0 15px rgba(210, 1, 13, 0.2); }

        .badge-iso { font-size: 0.7rem; letter-spacing: 0.5px; text-transform: uppercase; }
        .nav-tabs { border-bottom: 2px solid #ddd; }
        .nav-tabs .nav-link { color: var(--iso-dark); font-weight: 600; border: none; padding: 12px 20px; border-bottom: 3px solid transparent; }
        .nav-tabs .nav-link.active { color: var(--iso-red); border-bottom-color: var(--iso-red); }

        .btn-audit { border-radius: 50px; font-weight: 700; text-transform: uppercase; font-size: 0.75rem; padding: 8px 20px; }
        .btn-results { background-color: #0d6efd; color: white; font-weight: bold; border: none; padding: 10px 20px; border-radius: 4px; }

        .ai-loader { display: none; margin-left: 10px; }
    </style>
</head>
<body class="py-4">

<nav class="navbar navbar-light bg-white border-bottom py-3 mb-4 shadow-sm no-print">
    <div class="container">
        <div class="d-flex align-items-center">
            <div class="bg-danger text-white px-3 py-1 fw-bold me-3">ISO</div>
            <span class="fw-bold text-dark">SYSTÈME D'AUDIT INTERNE</span>
        </div>
        <div class="d-flex gap-2">
            <a href="/audit/resultat/${audit.id}" class="btn-results btn-sm"><i class="bi bi-file-earmark-pdf"></i> Résultats</a>
            <a href="/audit/missions" class="btn btn-outline-dark btn-sm">Quitter</a>
        </div>
    </div>
</nav>

<main class="container">
    <!-- Barre de Progression -->
    <div class="page-header">
        <h2 class="fw-bold m-0 uppercase">${audit.titre}</h2>
        <c:set var="total" value="${fn:length(clausesList) + fn:length(soaApplicables)}" />
        <c:set var="done" value="${fn:length(auditedClauseIds) + fn:length(auditedControleIds)}" />
        <c:set var="pct" value="${total > 0 ? (done * 100 / total) : 0}" />

        <div class="mt-3 bg-white p-3 rounded shadow-sm border" style="max-width: 400px;">
            <div class="d-flex justify-content-between mb-1">
                <small class="fw-bold">COMPLÉTION</small>
                <small class="fw-bold text-danger"><fmt:formatNumber value="${pct}" maxFractionDigits="0"/>%</small>
            </div>
            <div class="progress" style="height: 6px;">
                <div class="progress-bar bg-danger" style="width: ${pct}%"></div>
            </div>
        </div>
    </div>

    <!-- Navigation Onglets -->
    <ul class="nav nav-tabs mb-4" id="auditTab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" id="clauses-tab" data-bs-toggle="tab" data-bs-target="#tabClauses" type="button" role="tab">Onglet 1 : Clause 4-10</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="annexe-tab" data-bs-toggle="tab" data-bs-target="#tabAnnexe" type="button" role="tab">Onglet 2 : Annexe A</button>
        </li>
    </ul>

    <div class="tab-content">
        <!-- ================= ONGLET : CLAUSES 4-10 ================= -->
        <div class="tab-pane fade show active" id="tabClauses" role="tabpanel">
            <div class="row g-3">
                <c:forEach var="clause" items="${clausesList}">
                    <c:set var="isProcessed" value="${auditedClauseIds.contains(clause.id)}" />
                    <div id="target_CLAUSE_${clause.id}" class="col-12 audit-item" data-id="${clause.id}">
                        <div class="card iso-card ${isProcessed ? 'is-audited' : 'not-audited shadow-sm'}">
                            <div class="card-body p-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="badge ${isProcessed ? 'bg-success' : 'bg-info'} text-white badge-iso me-2">
                                            ${isProcessed ? 'TRAITÉ' : clause.code}
                                    </span>
                                    <span class="fw-bold">${clause.titre}</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <c:if test="${isProcessed}">
                                        <i class="bi bi-check-circle-fill text-success fs-5 me-3"></i>
                                        <!-- Bouton supprimer pour re-traiter -->
                                        <form action="/audit/constat/supprimer" method="post" onsubmit="return confirm('Supprimer ce constat et re-traiter ?')">
                                            <input type="hidden" name="auditId" value="${audit.id}">
                                            <input type="hidden" name="clauseId" value="${clause.id}">
                                            <button type="submit" class="btn btn-link text-danger p-0 me-3"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </c:if>
                                    <button class="btn ${isProcessed ? 'btn-outline-secondary disabled' : 'btn-dark'} btn-audit"
                                            data-bs-toggle="modal" data-bs-target="#modalClause${clause.id}" ${isProcessed ? 'disabled' : ''}>
                                            ${isProcessed ? 'Consulté' : 'Évaluer'}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Clause -->
                    <div class="modal fade" id="modalClause${clause.id}" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <form action="/audit/constat/save" method="post" class="modal-content shadow-lg">
                                <input type="hidden" name="auditId" value="${audit.id}">
                                <input type="hidden" name="clauseId" value="${clause.id}">
                                <input type="hidden" name="source" value="CLAUSE">

                                <div class="modal-header bg-dark text-white">
                                    <h6 class="modal-title fw-bold">Point d'Audit : Clause ${clause.code}</h6>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <label class="form-label">STATUT de l'écart</label>
                                        <select name="type" class="form-select border-2" required>
                                            <option value="" disabled selected>Verdict d'audit...</option>
                                            <option>NC Majeur</option><option>NC Mineur</option>
                                            <option>Observation</option><option>Opportunité d'amélioration</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Observations et preuves</label>
                                        <textarea id="desc_c_${clause.id}" name="description" class="form-control border-2" rows="3" required></textarea>
                                    </div>
                                    <div class="mb-0">
                                        <label class="form-label d-flex justify-content-between">
                                            Recommandation Auditeur
                                            <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold"
                                                    onclick="getAiSuggestion('c_${clause.id}', '${clause.code}')">
                                                <i class="bi bi-robot"></i> Aide IA
                                            </button>
                                        </label>
                                        <textarea id="rec_c_${clause.id}" name="recommandation" class="form-control border-2 bg-light" rows="3"></textarea>
                                        <div id="loader_c_${clause.id}" class="spinner-border spinner-border-sm text-primary ai-loader"></div>
                                    </div>
                                </div>
                                <div class="modal-footer"><button type="submit" class="btn btn-danger w-100 fw-bold">VALIDER</button></div>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- ================= ONGLET : ANNEXE A ================= -->
        <div class="tab-pane fade" id="tabAnnexe" role="tabpanel">
            <div class="row g-3">
                <c:forEach var="soa" items="${soaApplicables}">
                    <c:set var="isProcessedA" value="${auditedControleIds.contains(soa.controle.id)}" />
                    <div id="target_ANNEXE_A_${soa.controle.id}" class="col-12 audit-item" data-id="${soa.controle.id}">
                        <div class="card iso-card ${isProcessedA ? 'is-audited' : 'not-audited shadow-sm'}">
                            <div class="card-body p-3 d-flex justify-content-between align-items-center">
                                <div class="flex-grow-1">
                                    <span class="badge ${isProcessedA ? 'bg-success' : 'bg-danger'} text-white badge-iso me-2">
                                            ${isProcessedA ? 'TERMINÉ' : soa.controle.code}
                                    </span>
                                    <span class="fw-bold">${soa.controle.titre}</span>
                                    <c:if test="${!isProcessedA}">
                                        <div class="text-muted x-small mt-1" style="font-size: 0.75rem;">Justif : ${soa.justification}</div>
                                    </c:if>
                                </div>
                                <div class="d-flex align-items-center">
                                    <c:if test="${isProcessedA}">
                                        <form action="/audit/constat/supprimer" method="post" onsubmit="return confirm('Re-auditer cette mesure ?')">
                                            <input type="hidden" name="auditId" value="${audit.id}">
                                            <input type="hidden" name="controleId" value="${soa.controle.id}">
                                            <button type="submit" class="btn btn-link text-danger p-0 me-3"><i class="bi bi-arrow-counterclockwise"></i></button>
                                        </form>
                                    </c:if>
                                    <button class="btn ${isProcessedA ? 'btn-outline-secondary disabled' : 'btn-danger'} btn-audit"
                                            data-bs-toggle="modal" data-bs-target="#modalA${soa.id}" ${isProcessedA ? 'disabled' : ''}>
                                        Maturité
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Annexe A -->
                    <div class="modal fade" id="modalA${soa.id}" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <form action="/audit/constat/save" method="post" class="modal-content shadow-lg">
                                <input type="hidden" name="auditId" value="${audit.id}">
                                <input type="hidden" name="controleId" value="${soa.controle.id}">
                                <input type="hidden" name="source" value="ANNEXE_A">

                                <div class="modal-header bg-danger text-white">
                                    <h6 class="modal-title fw-bold">Maturité Mesure : ${soa.controle.code}</h6>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <label class="form-label">Niveau observé (0-5)</label>
                                        <select name="niveauMaturite" class="form-select border-2" required>
                                            <option value="" disabled selected>Niveau...</option>
                                            <option>0 - Inexistant</option><option>1 - Initialisé</option>
                                            <option>2 - Reproductible</option><option>3 - Défini</option>
                                            <option>4 - Géré</option><option>5 - Optimisé</option>
                                            <option>Non applicable</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Faits observés (Preuves)</label>
                                        <textarea id="desc_a_${soa.id}" name="description" class="form-control border-2" rows="3" required></textarea>
                                    </div>
                                    <div class="mb-0">
                                        <label class="form-label d-flex justify-content-between">
                                            Recommandation
                                            <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold"
                                                    onclick="getAiSuggestion('a_${soa.id}', '${soa.controle.code}')">
                                                <i class="bi bi-robot"></i> Aide IA
                                            </button>
                                        </label>
                                        <textarea id="rec_a_${soa.id}" name="recommandation" class="form-control border-2 bg-light" rows="3"></textarea>
                                        <div id="loader_a_${soa.id}" class="spinner-border spinner-border-sm text-danger ai-loader"></div>
                                    </div>
                                </div>
                                <div class="modal-footer"><button type="submit" class="btn btn-danger w-100 fw-bold">ENREGISTRER</button></div>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // --- 1. PERSISTANCE DE L'ONGLET ---
        const lastActiveTab = localStorage.getItem('lastAuditTab');
        if (lastActiveTab) {
            const tabEl = document.querySelector('button[data-bs-target="' + lastActiveTab + '"]');
            if (tabEl) {
                bootstrap.Tab.getOrCreateInstance(tabEl).show();
            }
        }
        document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(btn => {
            btn.addEventListener('shown.bs.tab', e => {
                localStorage.setItem('lastAuditTab', e.target.getAttribute('data-bs-target'));
            });
        });

        // --- 2. FOCUS AUTOMATIQUE VERS LE SUIVANT ---
        const urlParams = new URLSearchParams(window.location.search);
        const lastProcessedId = urlParams.get('lastProcessedId');

        if (lastProcessedId) {
            // Chercher l'onglet actif
            const currentTabId = localStorage.getItem('lastAuditTab') || '#tabClauses';
            const items = Array.from(document.querySelectorAll(currentTabId + ' .audit-item'));

            // Trouver l'index de l'élément qu'on vient de traiter
            const lastIdx = items.findIndex(item => item.id.includes(lastProcessedId));

            // S'il existe un suivant dans la liste
            if (lastIdx !== -1 && lastIdx + 1 < items.length) {
                const nextItem = items[lastIdx + 1];
                nextItem.classList.add('current-target');
                nextItem.scrollIntoView({ behavior: 'smooth', block: 'center' });

                // Petit effet de clignotement pour attirer l'oeil
                setTimeout(() => nextItem.classList.remove('current-target'), 3000);
            }
        }
    });

    /**
     * APPEL IA OLLAMA (Phi-3)
     */
    async function getAiSuggestion(fieldId, code) {
        const descField = document.getElementById('desc_' + fieldId);
        const recField = document.getElementById('rec_' + fieldId);
        const loader = document.getElementById('loader_' + fieldId);

        if (!descField.value || descField.value.length < 10) {
            alert("Saisissez d'abord un fait observé (10 car. min) pour obtenir une aide IA.");
            return;
        }

        loader.style.display = 'inline-block';
        recField.placeholder = "Analyse ISO 27001 en cours par l'IA...";

        try {
            const response = await fetch('/api/ai/audit-assist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ prompt: descField.value, controlCode: code })
            });
            const text = await response.text();
            recField.value = text;
        } catch (e) {
            alert("Erreur IA : Vérifiez qu'Ollama est actif.");
        } finally {
            loader.style.display = 'none';
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>


&lt;%&ndash;<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Audit Interne - ISO 27001 | Système de Management</title>
    <!-- CSS Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; --iso-gray: #F4F4F4; }
        body { background-color: var(--iso-gray); font-family: 'Inter', sans-serif; color: var(--iso-dark); }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; margin-bottom: 30px; }
        .iso-card { background: white; border: none; border-radius: 4px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: 0.2s; }
        .iso-card:hover { box-shadow: 0 5px 15px rgba(0,0,0,0.08); }
        .badge-iso { font-size: 0.75rem; letter-spacing: 0.5px; text-transform: uppercase; }
        .nav-tabs { border-bottom: 2px solid #ddd; }
        .nav-tabs .nav-link { color: var(--iso-dark); font-weight: 600; border: none; padding: 12px 20px; border-bottom: 3px solid transparent; }
        .nav-tabs .nav-link.active { color: var(--iso-red); border-bottom-color: var(--iso-red); }
        .soa-info-box { background-color: #f8f9fa; border-radius: 4px; font-size: 0.85rem; border: 1px solid #e9ecef; }
        .modal-header { border-bottom: 2px solid #ddd; }
        .form-label { font-weight: 700; font-size: 0.8rem; text-transform: uppercase; color: #555; }
        .btn-results { background-color: #0d6efd; color: white; font-weight: bold; border: none; padding: 10px 20px; border-radius: 4px; transition: 0.2s; }
        .btn-results:hover { background-color: #0b5ed7; color: white; }
    </style>
</head>
<body class="py-4">

<!-- Navigation -->
<nav class="navbar navbar-light bg-white border-bottom py-3 mb-4 shadow-sm">
    <div class="container">
        <div class="d-flex align-items-center">
            <div class="bg-danger text-white px-3 py-1 fw-bold me-3">ISO</div>
            <span class="fw-bold text-dark text-uppercase">Checklist d'Audit Professionnelle</span>
        </div>
        <div class="d-flex gap-2">
            <a href="/audit/resultat/${audit.id}" class="btn-results btn-sm">
                <i class="bi bi-file-earmark-bar-graph me-1"></i> Voir Résultats
            </a>
            <a href="/audit/missions" class="btn btn-outline-dark btn-sm fw-bold">RETOUR</a>
        </div>
    </div>
</nav>

<main class="container">
    <!-- En-tête avec Progression Dynamique -->
    <div class="page-header mb-4">
        <h2 class="fw-bold m-0 text-uppercase">Mission : ${audit.titre}</h2>

        <c:set var="totalPoints" value="${fn:length(clausesList) + fn:length(soaApplicables)}" />
        <c:set var="pointsAudites" value="${audit.constats.size()}" />
        <c:set var="percent" value="${totalPoints > 0 ? (pointsAudites * 100 / totalPoints) : 0}" />

        <div class="card mt-3 mb-2 border-0 shadow-sm p-3 bg-white" style="max-width: 500px;">
            <div class="d-flex justify-content-between mb-2">
                <span class="small fw-bold text-muted text-uppercase">Progression de l'audit interne</span>
                <span class="small fw-bold text-danger"><fmt:formatNumber value="${percent}" maxFractionDigits="0"/>%</span>
            </div>
            <div class="progress" style="height: 8px;">
                <div class="progress-bar bg-danger" role="progressbar" style="width: ${percent}%"></div>
            </div>
            <small class="text-muted mt-2" style="font-size: 0.7rem;">${pointsAudites} points évalués sur ${totalPoints} au total.</small>
        </div>
    </div>

    <!-- Onglets -->
    <ul class="nav nav-tabs mb-4" id="auditTab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" id="clauses-tab" data-bs-toggle="tab" data-bs-target="#tabClauses" type="button" role="tab">1. Clauses Normatives (4-10)</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="annexe-tab" data-bs-toggle="tab" data-bs-target="#tabAnnexe" type="button" role="tab">2. Mesures Annexe A (SoA)</button>
        </li>
    </ul>

    <div class="tab-content">
        <!-- ONGLET 1 : CLAUSE 4-10 -->
        <div class="tab-pane fade show active" id="tabClauses" role="tabpanel">
            <div class="row g-3">
                <c:forEach var="clause" items="${clausesList}">
                    <div class="col-12">
                        <div class="card iso-card border-start border-4 border-info">
                            <div class="card-body p-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="badge bg-info text-white badge-iso me-2">Chapitre ${clause.code}</span>
                                    <span class="fw-bold">${clause.titre}</span>
                                </div>
                                <button class="btn btn-dark btn-sm fw-bold px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalClause${clause.id}">
                                    <i class="bi bi-pencil-square me-1"></i> ÉVALUER STATUT
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Clause -->
                    <div class="modal fade" id="modalClause${clause.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <form action="/audit/constat/save" method="post" class="modal-content shadow-lg border-0 rounded-3">
                                <input type="hidden" name="auditId" value="${audit.id}">
                                <input type="hidden" name="clauseId" value="${clause.id}">
                                <input type="hidden" name="source" value="CLAUSE">

                                <div class="modal-header bg-dark text-white p-4">
                                    <h5 class="modal-title fw-bold">Statut Exigence : ${clause.code}</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <label class="form-label">STATUT de l'écart</label>
                                        <select name="type" class="form-select border-2" required>
                                            <option value="" disabled selected>Choisir un verdict...</option>
                                            <option value="NC Majeur">NC Majeur</option>
                                            <option value="NC Mineur">NC Mineur</option>
                                            <option value="Observation">Observation</option>
                                            <option value="Opportunité d'amélioration">Opportunité d'amélioration</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label d-flex justify-content-between">
                                            Description du constat (Faits)
                                            <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold" onclick="getAiSuggestion('${clause.id}', 'CLAUSE')">
                                                <i class="bi bi-robot"></i> Aide IA (Phi-3)
                                            </button>
                                        </label>
                                        <textarea id="desc_${clause.id}" name="description" class="form-control border-2" rows="4" placeholder="Qu'avez-vous constaté ?" required></textarea>
                                    </div>
                                    <div class="mb-0">
                                        <label class="form-label">Recommandation proposée</label>
                                        <textarea id="rec_${clause.id}" name="recommandation" class="form-control border-2 bg-light" rows="3" placeholder="Recommandation de l'auditeur..."></textarea>
                                        <div id="loader_${clause.id}" class="spinner-border spinner-border-sm text-primary d-none mt-2" role="status"></div>
                                    </div>
                                </div>
                                <div class="modal-footer border-0 p-3 bg-light">
                                    <button type="submit" class="btn btn-danger w-100 fw-bold py-2 shadow-sm">VALIDER CE CONSTAT</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- ONGLET 2 : ANNEXE A -->
        <div class="tab-pane fade" id="tabAnnexe" role="tabpanel">
            <div class="row g-3">
                <c:forEach var="soa" items="${soaApplicables}">
                    <div class="col-12">
                        <div class="card iso-card border-start border-4 border-danger">
                            <div class="card-body p-3 d-flex justify-content-between align-items-center">
                                <div class="flex-grow-1 pe-4">
                                    <div class="d-flex align-items-center">
                                        <span class="badge bg-danger text-white badge-iso me-2">${soa.controle.code}</span>
                                        <span class="fw-bold">${soa.controle.titre}</span>
                                    </div>
                                    <div class="soa-info-box p-2 mt-2 text-muted"><strong>Justif SoA:</strong> ${soa.justification}</div>
                                </div>
                                <button class="btn btn-danger btn-sm fw-bold px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSoA${soa.id}">
                                    <i class="bi bi-bar-chart-fill me-1"></i> MATURITÉ
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Annexe A -->
                    <div class="modal fade" id="modalSoA${soa.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <form action="/audit/constat/save" method="post" class="modal-content shadow-lg border-0">
                                <input type="hidden" name="auditId" value="${audit.id}">
                                <input type="hidden" name="controleId" value="${soa.controle.id}">
                                <input type="hidden" name="source" value="ANNEXE_A">

                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title fw-bold">Audit : Mesure ${soa.controle.code}</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <label class="form-label">Niveau de maturité observé</label>
                                        <select name="niveauMaturite" class="form-select border-2" required>
                                            <option value="" disabled selected>Niveau (0-5)...</option>
                                            <option>0 - Inexistant</option>
                                            <option>1 - Initialisé</option>
                                            <option>2 - Reproductible</option>
                                            <option>3 - Défini</option>
                                            <option>4 - Géré</option>
                                            <option>5 - Optimisé</option>
                                            <option>Non applicable</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Faits observés et preuves d'audit</label>
                                        <textarea id="desc_a_${soa.id}" name="description" class="form-control border-2" rows="3" placeholder="Saisir la preuve auditée..." required></textarea>
                                    </div>
                                    <div class="mb-0">
                                        <label class="form-label d-flex justify-content-between">
                                            Recommandation Auditeur
                                            <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold" onclick="getAiSuggestion('a_${soa.id}', 'ANNEXE_A')">
                                                <i class="bi bi-robot"></i> Suggérer via Phi-3
                                            </button>
                                        </label>
                                        <textarea id="rec_a_${soa.id}" name="recommandation" class="form-control border-2 bg-light" rows="3" placeholder="Action corrective suggérée par l'IA ou l'auditeur..."></textarea>
                                        <div id="loader_a_${soa.id}" class="spinner-border spinner-border-sm text-danger d-none mt-2" role="status"></div>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light"><button type="submit" class="btn btn-danger w-100 fw-bold">ENREGISTRER</button></div>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</main>

<footer class="text-center py-5 text-muted opacity-75 mt-5">
    <hr class="container"><small>© 2026 GRC Cloud | Engine V1.2.0 | IA Edge Integration</small>
</footer>

<script>
    /**
     * Appelle l'API interne vers Ollama (Phi-3) pour obtenir une recommandation d'audit.
     */
    async function getAiSuggestion(targetId, type) {
        // Cibler la description spécifique au modal
        const descriptionField = document.getElementById('desc_' + targetId);
        const recommandationField = document.getElementById('rec_' + targetId);
        const loader = document.getElementById('loader_' + targetId);

        if(!descriptionField.value || descriptionField.value.length < 10) {
            alert("Veuillez d'abord détailler les faits observés (min 10 car.) pour que l'IA puisse proposer une recommandation pertinente.");
            return;
        }

        // Effet UI
        loader.classList.remove('d-none');
        recommandationField.placeholder = "Génération de la recommandation stratégique en cours...";

        try {
            const response = await fetch('/api/ai/audit-assist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    prompt: descriptionField.value,
                    controlCode: targetId,
                    type: type
                })
            });

            if (!response.ok) throw new Error("Réponse serveur KO");

            const aiResult = await response.text();
            recommandationField.value = aiResult;
            recommandationField.style.height = (recommandationField.scrollHeight) + "px"; // Auto-resize
        } catch (error) {
            console.error("AI Assistant Error:", error);
            alert("L'assistant IA local n'est pas disponible. Vérifiez qu'Ollama tourne sur le port 11434.");
        } finally {
            loader.classList.add('d-none');
            recommandationField.placeholder = "Recommandation proposée.";
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>&ndash;%&gt;

&lt;%&ndash;<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Audit Interne - Checklist de Vérification</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Police Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --iso-red: #D2010D;
            --iso-dark: #212121;
            --iso-gray: #F4F4F4;
        }

        body {
            background-color: var(--iso-gray);
            font-family: 'Inter', sans-serif;
            color: var(--iso-dark);
        }

        .page-header {
            border-left: 5px solid var(--iso-red);
            padding-left: 15px;
            margin-bottom: 30px;
        }

        .iso-card {
            background: white;
            border: none;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: 0.2s;
        }

        .iso-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .badge-iso {
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        /* Onglets style corporate */
        .nav-tabs {
            border-bottom: 2px solid #ddd;
        }
        .nav-tabs .nav-link {
            color: var(--iso-dark);
            font-weight: 600;
            border: none;
            padding: 12px 20px;
            border-bottom: 3px solid transparent;
        }
        .nav-tabs .nav-link.active {
            color: var(--iso-red);
            background-color: transparent;
            border-bottom-color: var(--iso-red);
        }

        .soa-info-box {
            background-color: #f8f9fa;
            border-radius: 4px;
            font-size: 0.85rem;
            border: 1px solid #e9ecef;
        }

        .modal-content {
            border-radius: 4px;
            border: none;
        }
        .modal-header {
            border-bottom: 2px solid #ddd;
        }

        .form-label {
            font-weight: 700;
            font-size: 0.8rem;
            text-transform: uppercase;
            color: #555;
            letter-spacing: 0.5px;
        }

        /* Bouton dynamique vers la page de résultats */
        .btn-results {
            background-color: #0d6efd;
            color: white;
            font-weight: bold;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            box-shadow: 0 4px 6px rgba(13, 110, 253, 0.2);
            transition: 0.2s;
        }
        .btn-results:hover {
            background-color: #0b5ed7;
            color: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body class="py-4">

<!-- Navigation -->
<nav class="navbar navbar-light bg-white border-bottom py-3 mb-4">
    <div class="container">
        <div class="d-flex align-items-center">
            <div class="bg-danger text-white px-3 py-1 fw-bold me-2">ISO</div>
            <span class="fw-bold text-dark text-uppercase">Checklist d'Audit</span>
        </div>
        <div class="d-flex gap-2">
            <!-- Bouton Résultats demandé par ton cahier des charges -->
            <a href="/audit/resultat/${audit.id}" class="btn-results btn-sm">
                <i class="bi bi-file-earmark-bar-graph me-1"></i> Résultat de l'audit
            </a>
            <a href="/audit/missions" class="btn btn-outline-dark btn-sm fw-bold">RETOUR</a>
        </div>
    </div>
</nav>

<main class="container">
    <div class="page-header mb-4">
        <h2 class="fw-bold m-0 text-uppercase">Audit Interne</h2>
        <small class="text-muted">Évaluation et contrôle en cours pour : <strong>${audit.titre}</strong></small>
    </div>

    <!-- Les Onglets -->
    <ul class="nav nav-tabs mb-4" id="auditTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="clauses-tab" data-bs-toggle="tab" data-bs-target="#tabClauses" type="button" role="tab">Onglet : Clause 4-10</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="annexe-tab" data-bs-toggle="tab" data-bs-target="#tabAnnexe" type="button" role="tab">Onglet : Annexe A</button>
        </li>
    </ul>

    <div class="tab-content" id="auditTabContent">

        <!-- ================= ONGLET 1 : CLAUSE 4-10 ================= -->
        <div class="tab-pane fade show active" id="tabClauses" role="tabpanel" aria-labelledby="clauses-tab">
            <div class="row g-3">
                <c:forEach var="clause" items="${clausesList}">
                    <div class="col-12">
                        <div class="card iso-card border-start border-4 border-info">
                            <div class="card-body p-4 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="badge bg-info text-white badge-iso me-2">Chapitre ${clause.code}</span>
                                    <span class="fw-bold text-dark">${clause.titre}</span>
                                    <p class="text-muted small mb-0 mt-1">${clause.description}</p>
                                </div>
                                <div>
                                    <button class="btn btn-dark btn-sm fw-bold px-3" data-bs-toggle="modal" data-bs-target="#modalClause${clause.id}">
                                        <i class="bi bi-shield-fill-exclamation me-1"></i> ÉVALUER STATUT
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal d'audit pour Clause -->
                    <div class="modal fade" id="modalClause${clause.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <form action="/audit/constat/save" method="post" class="modal-content shadow-lg">
                                <input type="hidden" name="auditId" value="${audit.id}">
                                <input type="hidden" name="clauseId" value="${clause.id}">
                                <input type="hidden" name="source" value="CLAUSE">

                                <div class="modal-header bg-dark text-white">
                                    <h5 class="modal-title fw-bold">Audit : Chapitre ${clause.code}</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4">

                                    <div class="mb-3">
                                        <label class="form-label">STATUT de conformité</label>
                                        <select name="type" class="form-select" required>
                                            <option value="" disabled selected>Sélectionner un statut...</option>
                                            <option value="NC Majeur">NC Majeur</option>
                                            <option value="NC Mineur">NC Mineur</option>
                                            <option value="Observation">Observation</option>
                                            <option value="Opportunité d'amélioration">Opportunité d'amélioration</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Constat / Preuves auditées</label>
                                        <textarea name="description" class="form-control" rows="4" placeholder="Décrivez les faits d'audit qui appuient ce statut..." required></textarea>
                                    </div>

                                    <div class="mb-0">
                                        <label class="form-label">Gravité</label>
                                        <select name="gravite" class="form-select">
                                            <option value="FAIBLE">Faible</option>
                                            <option value="MOYENNE" selected>Moyenne</option>
                                            <option value="HAUTE">Haute (Bloquant)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light">
                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Fermer</button>
                                    <button type="submit" class="btn btn-danger btn-sm fw-bold">Valider le constat</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- ================= ONGLET 2 : ANNEXE A (De l'Applicabilité) ================= -->
        <div class="tab-pane fade" id="tabAnnexe" role="tabpanel" aria-labelledby="annexe-tab">
            <div class="row g-3">
                <c:forEach var="soa" items="${soaApplicables}">
                    <div class="col-12">
                        <div class="card iso-card border-start border-4 border-danger">
                            <div class="card-body p-4 d-flex justify-content-between align-items-center">
                                <div class="flex-grow-1 pe-4">
                                    <div class="d-flex align-items-center mb-1">
                                        <span class="badge bg-danger text-white badge-iso me-2">${soa.controle.code}</span>
                                        <span class="fw-bold text-dark">${soa.controle.titre}</span>
                                    </div>
                                    <div class="soa-info-box p-2 my-2">
                                        <strong>Justification d'applicabilité :</strong> ${soa.justification}
                                    </div>
                                    <span class="text-muted small">Domaine : ${soa.controle.domaine}</span>
                                </div>
                                <div class="text-nowrap">
                                    <button class="btn btn-danger btn-sm fw-bold px-3" data-bs-toggle="modal" data-bs-target="#modalSoA${soa.id}">
                                        <i class="bi bi-bar-chart-fill me-1"></i> ÉVALUER MATURITÉ
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal d'audit pour l'Annexe A -->
                    <div class="modal fade" id="modalSoA${soa.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <form action="/audit/constat/save" method="post" class="modal-content shadow-lg">
                                <input type="hidden" name="controleId" value="${soa.controle.id}">
                                <input type="hidden" name="source" value="ANNEXE_A">
                                <input type="hidden" name="auditId" value="${audit.id}">

                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title fw-bold">Audit : ${soa.controle.code}</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4">

                                    <div class="mb-3">
                                        <label class="form-label">Niveau de maturité</label>
                                        <select name="niveauMaturite" class="form-select" required>
                                            <option value="" disabled selected>Sélectionner le niveau...</option>
                                            <option value="0 - Inexistant">0 - Inexistant</option>
                                            <option value="1 - Initialisé">1 - Initialisé</option>
                                            <option value="2 - Reproductible">2 - Reproductible</option>
                                            <option value="3 - Défini">3 - Défini</option>
                                            <option value="4 - Géré">4 - Géré</option>
                                            <option value="5 - Optimisé">5 - Optimisé</option>
                                            <option value="Non applicable">Non applicable</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Observations d'Audit (Faits)</label>
                                        <textarea name="description" class="form-control" rows="3" placeholder="Écarts par rapport au statut déclaré, conformité constatée..." required></textarea>
                                    </div>

                                    <div class="mb-0">
                                        <label class="form-label">Recommandation (Nouveau Champ)</label>
                                        <textarea name="recommandation" class="form-control" rows="3" placeholder="Action corrective suggérée par l'auditeur..." required></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light">
                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Fermer</button>
                                    <button type="submit" class="btn btn-danger btn-sm fw-bold">Valider le constat</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty soaApplicables}">
                    <div class="col-12 text-center text-muted p-5 bg-white shadow-sm">
                        <i class="bi bi-folder-x fs-2 d-block mb-2"></i>
                        Aucun contrôle n'a été déclaré applicable dans le SoA.
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</main>

<footer class="text-center py-5 mt-5 text-muted opacity-75">
    <hr class="container">
    <small>© 2026 Solution SMSI Corporate | Moteur d'Amélioration Continue</small>
</footer>

<!-- JS Bootstrap 5 avec le bundle Popper inclus -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>&ndash;%&gt;

&lt;%&ndash;<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Audit Interne - Réalisation de la Checklist</title>
    <!-- CSS Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --iso-red: #D2010D;
            --iso-dark: #212121;
            --iso-gray: #F4F4F4;
        }
        body {
            background-color: var(--iso-gray);
            font-family: 'Inter', sans-serif;
            color: var(--iso-dark);
        }
        .page-header {
            border-left: 5px solid var(--iso-red);
            padding-left: 15px;
            margin-bottom: 30px;
        }
        .nav-tabs .nav-link {
            color: #6c757d;
            font-weight: 600;
            border-radius: 8px 8px 0 0;
            padding: 12px 20px;
        }
        .nav-tabs .nav-link.active {
            color: var(--iso-red);
            border-bottom: 3px solid var(--iso-red);
        }
        .audit-card {
            background-color: #fff;
            border: none;
            border-radius: 8px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .audit-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
        }
        .modal-content {
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }
        .btn-iso {
            background-color: var(--iso-red);
            color: white;
            font-weight: bold;
            border: none;
        }
        .btn-iso:hover {
            background-color: #a8010a;
            color: white;
        }
        .alert-custom {
            background-color: #fff;
            border-left: 4px solid var(--iso-red);
            border-radius: 0;
        }
    </style>
</head>
<body class="py-5">

<div class="container">

    <!-- En-tête de page exigé -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="page-header">
            <h2 class="fw-bold m-0 text-uppercase">Audit Interne</h2>
            <p class="text-muted mb-0">Mission : <strong>${audit.titre}</strong></p>
        </div>
        <div class="d-flex gap-2">
            <a href="/audit/missions" class="btn btn-outline-dark fw-bold btn-sm">RETOUR</a>
            <!-- Bouton "Résultat de l'audit" exigé -->
            <a href="/audit/resultat/${audit.id}" class="btn btn-iso fw-bold btn-sm">
                <i class="bi bi-file-earmark-bar-graph me-1"></i> RÉSULTAT DE L'AUDIT
            </a>
        </div>
    </div>

    <!-- Message explicatif -->
    <div class="alert alert-custom shadow-sm mb-4">
        <div class="d-flex align-items-center">
            <i class="bi bi-info-circle-fill text-danger fs-4 me-3"></i>
            <div>
                <strong>Auditeur : </strong> Effectuez l'audit sur le terrain en complétant les fiches de constats des deux onglets ci-dessous.
            </div>
        </div>
    </div>

    <!-- Navigation des Onglets demandés -->
    <ul class="nav nav-tabs mb-4 border-0" id="auditTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="clauses-tab" data-bs-toggle="tab" data-bs-target="#tabClauses" type="button" role="tab" aria-controls="tabClauses" aria-selected="true">
                <i class="bi bi-journal-bookmark me-1"></i> ONGLET : CLAUSE 4-10
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="annexe-tab" data-bs-toggle="tab" data-bs-target="#tabAnnexe" type="button" role="tab" aria-controls="tabAnnexe" aria-selected="false">
                <i class="bi bi-shield-check me-1"></i> ONGLET : ANNEXE A (IMPORTÉE DU SOA)
            </button>
        </li>
    </ul>

    <!-- Contenu des Onglets -->
    <div class="tab-content" id="auditTabsContent">

        <!-- ================= ONGLET 1 : CLAUSE 4-10 ================= -->
        <div class="tab-pane fade show active" id="tabClauses" role="tabpanel" aria-labelledby="clauses-tab">
            <div class="row g-3">
                <c:forEach var="c" items="${clausesList}">
                    <div class="col-12">
                        <div class="card audit-card border-0 mb-2">
                            <div class="card-body d-flex justify-content-between align-items-center py-3">
                                <div>
                                    <span class="badge bg-light text-dark border me-2">${c.code}</span>
                                    <span class="fw-bold">${c.titre}</span>
                                </div>
                                <button type="button" class="btn btn-sm btn-dark px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalClause${c.id}">
                                    LEVER STATUT
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Modal d'Ecart Clause 4-10 -->
                    <div class="modal fade" id="modalClause${c.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-lg">
                            <form action="/audit/constat/save" method="post" class="modal-content">
                                <input type="hidden" name="auditId" value="${audit.id}">
                                <input type="hidden" name="clauseId" value="${c.id}">
                                <input type="hidden" name="source" value="CLAUSE">

                                <div class="modal-header bg-dark text-white">
                                    <h5 class="modal-title fw-bold">Audit Clause : ${c.code}</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <!-- Echelle STATUT exigée pour l'onglet Clauses -->
                                        <label class="form-label fw-bold text-uppercase" style="font-size:0.75rem;">STATUT</label>
                                        <select name="type" class="form-select" required>
                                            <option value="" disabled selected>Sélectionnez un statut d'écart...</option>
                                            <option value="NC Majeur">NC Majeur</option>
                                            <option value="NC Mineur">NC Mineur</option>
                                            <option value="Observation">Observation</option>
                                            <option value="Opportunité d'amélioration">Opportunité d'amélioration</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-bold text-uppercase" style="font-size:0.75rem;">Description des faits (Preuve d'audit)</label>
                                        <textarea name="description" class="form-control" rows="4" placeholder="Quels sont les faits objectifs identifiés..." required></textarea>
                                    </div>

                                    <!-- Champ Recommandation exigé -->
                                    <div class="mb-0">
                                        <label class="form-label fw-bold text-uppercase" style="font-size:0.75rem;">Recommandation</label>
                                        <textarea name="recommandation" class="form-control" rows="3" placeholder="Saisir la recommandation de l'auditeur..."></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                                    <button type="submit" class="btn btn-dark fw-bold">ENREGISTRER</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty clausesList}">
                    <div class="text-center py-4 text-muted">Aucune clause disponible dans le référentiel.</div>
                </c:if>
            </div>
        </div>

        <!-- ================= ONGLET 2 : ANNEXE A ================= -->
        <div class="tab-pane fade" id="tabAnnexe" role="tabpanel" aria-labelledby="annexe-tab">
            <div class="row g-3">
                <!-- Seules les données applicables du SoA arrivent ici -->
                <c:forEach var="soa" items="${soaApplicables}">
                    <div class="col-12">
                        <div class="card audit-card border-0 mb-2" style="border-left: 4px solid var(--iso-red) !important;">
                            <div class="card-body d-flex justify-content-between align-items-center py-3">
                                <div>
                                    <span class="badge bg-danger text-white me-2">${soa.controle.code}</span>
                                    <span class="fw-bold">${soa.controle.titre}</span>
                                    <div class="text-muted small mt-1">Garantie par le SoA : ${soa.statutMiseEnOeuvre}</div>
                                </div>
                                <button type="button" class="btn btn-sm btn-iso px-4" data-bs-toggle="modal" data-bs-target="#modalAnnexe${soa.id}">
                                    LEVER MATURITÉ
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Modal d'Ecart Annexe A -->
                    <div class="modal fade" id="modalAnnexe${soa.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-lg">
                            <form action="/audit/constat/save" method="post" class="modal-content">
                                <input type="hidden" name="auditId" value="${audit.id}">
                                <input type="hidden" name="controleId" value="${soa.controle.id}">
                                <input type="hidden" name="source" value="ANNEXE_A">

                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title fw-bold">Audit Contrôle : ${soa.controle.code}</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <!-- Combobox Niveau de maturité exigé pour l'onglet Annexe A -->
                                        <label class="form-label fw-bold text-uppercase" style="font-size:0.75rem;">NIVEAU DE MATURITÉ</label>
                                        <select name="niveauMaturite" class="form-select" required>
                                            <option value="" disabled selected>Sélectionnez un niveau...</option>
                                            <option value="0 - Inexistant">0 - Inexistant</option>
                                            <option value="1 - Initialisé">1 - Initialisé</option>
                                            <option value="2 - Reproductible">2 - Reproductible</option>
                                            <option value="3 - Défini">3 - Défini</option>
                                            <option value="4 - Géré">4 - Géré</option>
                                            <option value="5 - Optimisé">5 - Optimisé</option>
                                            <option value="Non applicable">Non applicable</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-bold text-uppercase" style="font-size:0.75rem;">Description des faits (Preuve d'audit)</label>
                                        <textarea name="description" class="form-control" rows="4" placeholder="Observation du respect des exigences de conformité..." required></textarea>
                                    </div>

                                    <!-- Champ Recommandation exigé -->
                                    <div class="mb-0">
                                        <label class="form-label fw-bold text-uppercase" style="font-size:0.75rem;">Recommandation</label>
                                        <textarea name="recommandation" class="form-control" rows="3" placeholder="Saisir la recommandation pour s'ajuster ou progresser de niveau..."></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                                    <button type="submit" class="btn btn-iso fw-bold">ENREGISTRER</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty soaApplicables}">
                    <div class="col-12 text-center py-4 text-muted">
                        Aucun contrôle applicable défini via le SoA pour cet audit.
                    </div>
                </c:if>
            </div>
        </div>

    </div>

</div>

<!-- JS Bootstrap (indispensable pour activer les Onglets et Modaux) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>&ndash;%&gt;




&lt;%&ndash;<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Réalisation d'Audit - Checklist</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f1f5f9; font-family: 'Inter', sans-serif; }
        .audit-card { border: none; border-radius: 12px; transition: 0.2s; }
        .audit-card:hover { transform: scale(1.01); box-shadow: 0 10px 30px rgba(0,0,0,0.08); }
        .soa-info { background-color: #e2e8f0; font-size: 0.85rem; padding: 10px; border-radius: 8px; }
        .btn-constat { border-radius: 50px; font-weight: 600; padding: 0.4rem 1.2rem; }
        .modal-content { border-radius: 20px; border: none; }
    </style>
</head>
<body class="container py-5">

<div class="d-flex justify-content-between align-items-center mb-5">
    <div>
        <h2 class="fw-bold text-dark"><i class="bi bi-check2-all text-primary me-2"></i>Exécution de l'audit</h2>
        <h5 class="text-muted fw-light">Mission : <strong>${audit.titre}</strong></h5>
    </div>
    <a href="/audit/missions" class="btn btn-secondary rounded-pill"><i class="bi bi-arrow-left"></i> Missions</a>
</div>

<div class="row">
    <c:forEach var="soa" items="${soaList}">
        <div class="col-12 mb-4">
            <div class="card audit-card shadow-sm border-start border-5 border-primary">
                <div class="card-body p-4">
                    <div class="row align-items-center">
                        <div class="col-md-9">
                            <div class="d-flex align-items-center mb-2">
                                <span class="badge bg-dark me-2">CODE: ${soa.controle.code}</span>
                                <h5 class="mb-0 fw-bold">${soa.controle.titre}</h5>
                            </div>
                            <div class="soa-info mb-3">
                                <strong><i class="bi bi-chat-left-dots me-2"></i>Justification d'applicabilité :</strong><br>
                                    ${soa.justification}
                            </div>
                            <span class="badge bg-primary-subtle text-primary border border-primary px-3">
                                    Déclaré : ${soa.statutMiseEnOeuvre}
                                </span>
                        </div>
                        <div class="col-md-3 text-end">
                            <button class="btn btn-danger btn-constat" data-bs-toggle="modal" data-bs-target="#nc${soa.id}">
                                <i class="bi bi-exclamation-triangle"></i> Lever un écart
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL DE CONSTAT ISO -->
        <div class="modal fade" id="nc${soa.id}" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <form action="/audit/constat/save" method="post" class="modal-content shadow-lg">
                    <input type="hidden" name="auditId" value="${audit.id}">
                    <input type="hidden" name="controleId" value="${soa.controle.id}">

                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-megaphone me-2"></i>Nouveau Constat d'Audit</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="alert alert-light border mb-4">
                            <small class="fw-bold text-muted text-uppercase">Point de contrôle :</small><br>
                                ${soa.controle.code} - ${soa.controle.titre}
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Nature de l'écart</label>
                                <select name="type" class="form-select shadow-sm">
                                    <option value="NC_MAJEURE">Non-Conformité Majeure</option>
                                    <option value="NC_MINEURE" selected>Non-Conformité Mineure</option>
                                    <option value="OBSERVATION">Simple Observation</option>
                                    <option value="OPPORTUNITE">Opportunité (Piste d'amélioration)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Niveau de risque</label>
                                <select name="gravite" class="form-select shadow-sm">
                                    <option value="HAUTE">Critique / Haute</option>
                                    <option value="MOYENNE" selected>Moyenne</option>
                                    <option value="FAIBLE">Faible</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-0">
                            <label class="form-label fw-bold">Observations (Faits et Preuves)</label>
                            <textarea name="description" class="form-control shadow-sm" rows="4"
                                      placeholder="Décrivez précisément l'écart constaté et la preuve d'audit..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-danger rounded-pill px-5 shadow-sm">Enregistrer le constat</button>
                    </div>
                </form>
            </div>
        </div>
    </c:forEach>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>&ndash;%&gt;

&lt;%&ndash;
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Réaliser Checklist d'Audit</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="container mt-4 bg-light">

<nav class="mb-4">
    <a href="/audit/missions" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left"></i> Retour aux missions</a>
</nav>

<h3>🔍 Audit : ${audit.titre}</h3>
<div class="alert alert-info border shadow-sm">
    <i class="bi bi-info-circle-fill me-2"></i>
    <strong>Checklist d'audit :</strong> Vérifiez la conformité des contrôles déclarés applicables.
</div>

<c:forEach var="soa" items="${soaList}">
    <div class="card mb-3 border-start border-4 border-primary shadow-sm">
        <div class="card-body">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h6 class="mb-1 fw-bold">${soa.controle.code} - ${soa.controle.titre}</h6>
                    <p class="small text-muted mb-1"><strong>Justification SoA :</strong> ${soa.justification}</p>
                    <span class="badge bg-primary">État déclaré : ${soa.statutMiseEnOeuvre}</span>
                </div>
                <div class="col-md-4 text-end">
                    <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#nc${soa.id}">
                        <i class="bi bi-exclamation-octagon"></i> Lever un constat
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal pour saisir le constat -->
    <div class="modal fade" id="nc${soa.id}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="/audit/constat/save" method="post" class="modal-content">
                <!-- Champs cachés importants -->
                <input type="hidden" name="auditId" value="${audit.id}">
                <input type="hidden" name="controleId" value="${soa.controle.id}">

                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Nouveau Constat : ${soa.controle.code}</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Type de constat</label>
                        <select name="type" class="form-select">
                            <option value="NC_MINEURE">Non-Conformité Mineure</option>
                            <option value="NC_MAJEURE">Non-Conformité Majeure</option>
                            <option value="OBSERVATION">Observation</option>
                            <option value="OPPORTUNITE">Opportunité d'amélioration</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Gravité</label>
                        <select name="gravite" class="form-select">
                            <option value="FAIBLE">Faible</option>
                            <option value="MOYENNE" selected>Moyenne</option>
                            <option value="HAUTE">Haute</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Description de la preuve d'audit</label>
                        <textarea name="description" class="form-control" rows="4" placeholder="Qu'avez-vous observé sur le terrain ?" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-danger">Enregistrer le constat</button>
                </div>
            </form>
        </div>
    </div>
</c:forEach>

<!-- BOOTSTRAP JAVASCRIPT (ESSENTIEL POUR LE MODAL) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>&ndash;%&gt;
--%>
