<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Rapport d'Audit Final">

    <style>
        /* Styles spécifiques au rapport d'audit */
        .report-header-box { border-left: 5px solid #D2010D; background: #fff; padding: 20px; margin-bottom: 25px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }

        /* Badges de maturité personnalisés */
        .badge-mat { padding: 8px 12px; font-size: 0.9rem; border-radius: 4px; width: 100%; display: block; text-align: center; font-weight: bold; }
        .mat-high { background-color: #28a745; color: white; }
        .mat-med { background-color: #ffc107; color: #333; }
        .mat-low { background-color: #dc3545; color: white; }

        .recommendation-box { background-color: #fffef0; border: 1px solid #ffeeba; border-left: 4px solid #ffc107; padding: 10px; border-radius: 4px; font-style: italic; color: #856404; }

        @media print {
            .no-print, .main-sidebar, .main-header, .main-footer { display: none !important; }
            .content-wrapper { margin-left: 0 !important; }
            .card { border: 1px solid #ddd !important; box-shadow: none !important; }
        }
    </style>

    <!-- Header de Mission -->
    <div class="report-header-box d-flex justify-content-between align-items-center">
        <div>
            <h4 class="font-weight-bold mb-1"><i class="fas fa-file-contract text-danger mr-2"></i> ${audit.titre}</h4>
            <p class="text-muted mb-0 small">
                Mission ID: <strong>#${audit.id.toString().substring(0,8)}</strong> |
                Statut : <span class="badge badge-success px-3">${audit.statut}</span>
            </p>
        </div>
        <div class="no-print">
            <button onclick="window.print()" class="btn btn-dark">
                <i class="fas fa-print mr-2"></i> Imprimer le Rapport
            </button>
        </div>
    </div>

    <!-- Structure par Onglets -->
    <div class="card card-danger card-outline card-tabs shadow-sm">
        <div class="card-header p-0 pt-1 border-bottom-0">
            <ul class="nav nav-tabs" id="auditTabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="clauses-tab" data-toggle="pill" href="#resClauses" role="tab">
                        <i class="fas fa-list-ol mr-2"></i>Synthèse Clauses (4-10)
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="annexe-tab" data-toggle="pill" href="#resAnnexe" role="tab">
                        <i class="fas fa-shield-alt mr-2"></i>Maturité Annexe A
                    </a>
                </li>
            </ul>
        </div>

        <div class="card-body">
            <div class="tab-content" id="auditTabsContent">

                <!-- ================= ONGLET : RÉSULTAT CLAUSE 4-10 ================= -->
                <div class="tab-pane fade show active" id="resClauses" role="tabpanel">
                    <h5 class="mb-4 text-dark font-weight-bold"><i class="fas fa-check-circle text-primary mr-2"></i>Verdict de conformité normative</h5>
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="thead-dark">
                        <tr>
                            <th style="width: 100px;">Réf.</th>
                            <th>Chapitre Normatif</th>
                            <th>Verdict de l'Auditeur</th>
                            <th>Observations détaillées</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="c" items="${resultatsClauses}">
                            <tr>
                                <td class="font-weight-bold text-center bg-light">${c.clauseIso.code}</td>
                                <td>${c.clauseIso.titre}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.type eq 'NC Majeur'}"><span class="badge badge-danger px-3 py-2 w-100">NON-CONFORMITÉ MAJEURE</span></c:when>
                                        <c:when test="${c.type eq 'NC Mineur'}"><span class="badge badge-warning px-3 py-2 w-100">NON-CONFORMITÉ MINEURE</span></c:when>
                                        <c:when test="${c.type eq 'Conforme'}"><span class="badge badge-success px-3 py-2 w-100">CONFORME</span></c:when>
                                        <c:otherwise><span class="badge badge-info px-3 py-2 w-100">${c.type}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><p class="mb-0 small text-justify">${c.description}</p></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- ================= ONGLET : RÉSULTAT ANNEXE A ================= -->
                <div class="tab-pane fade" id="resAnnexe" role="tabpanel">
                    <h5 class="mb-4 text-dark font-weight-bold"><i class="fas fa-chart-bar text-danger mr-2"></i>Score de Maturité des Mesures Techniques</h5>
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle">
                            <thead class="thead-light">
                            <tr>
                                <th style="width: 80px;">Code</th>
                                <th>Mesure de Sécurité</th>
                                <th style="width: 180px;">Maturité (0-5)</th>
                                <th>Évidence & Constat</th>
                                <th>Recommandations d'Amélioration</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="a" items="${resultatsAnnexeA}">
                                <tr>
                                    <td class="text-center font-weight-bold bg-light">${a.controle.code}</td>
                                    <td><strong>${a.controle.titre}</strong></td>
                                    <td>
                                        <c:set var="mValue" value="${a.niveauMaturite}" />
                                        <c:choose>
                                            <c:when test="${mValue.startsWith('4') || mValue.startsWith('5')}">
                                                <span class="badge-mat mat-high">${mValue}</span>
                                            </c:when>
                                            <c:when test="${mValue.startsWith('0') || mValue.startsWith('1')}">
                                                <span class="badge-mat mat-low">${mValue}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-mat mat-med">${mValue}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><small class="text-muted">${a.description}</small></td>
                                    <td>
                                        <div class="recommendation-box small">
                                            <i class="far fa-lightbulb mr-1"></i> ${a.recommandation}
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
        <div class="card-footer bg-white border-top text-center text-muted small">
            Signature Électronique Validée | Rapport généré le : <strong>30/04/2026</strong>
        </div>
    </div>

</t:layout>

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport d'Audit - Résultats</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; }
        body { background-color: #f4f7f6; font-family: 'Inter', sans-serif; }
        .report-header { background: white; border-bottom: 5px solid var(--iso-red); padding: 30px; margin-bottom: 30px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .nav-pills .nav-link.active { background-color: var(--iso-red); }
        .nav-pills .nav-link { color: var(--iso-dark); font-weight: bold; border: 1px solid #dee2e6; margin-right: 10px; }

        /* Badges Maturité Dynamiques */
        .mat-high { background-color: #198754; color: white; }
        .mat-med { background-color: #ffc107; color: black; }
        .mat-low { background-color: #dc3545; color: white; }

        .recommendation-box { background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 10px; font-style: italic; }
        .table-custom thead { background-color: var(--iso-dark); color: white; }
    </style>
</head>
<body>

<div class="report-header">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <h1 class="fw-bold m-0"><i class="bi bi-file-earmark-check"></i> RÉSULTAT DE L'AUDIT</h1>
            <p class="text-muted mb-0">Mission : <strong>${audit.titre}</strong> | Statut : <span class="badge bg-success">${audit.statut}</span></p>
        </div>
        <div class="no-print">
            <button onclick="window.print()" class="btn btn-dark"><i class="bi bi-printer"></i> Imprimer</button>
            <a href="/audit/missions" class="btn btn-outline-dark">Retour</a>
        </div>
    </div>
</div>

<div class="container">
    <!-- Onglets de résultats -->
    <ul class="nav nav-pills mb-4 justify-content-center" id="resultTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#resClauses">Resultat Clause 4-10</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#resAnnexe">Resultat Annexe A</button>
        </li>
    </ul>

    <div class="tab-content bg-white p-4 shadow-sm rounded">

        <!-- ================= ONGLET : RÉSULTAT CLAUSE 4-10 ================= -->
        <div class="tab-pane fade show active" id="resClauses">
            <h4 class="mb-4 fw-bold text-primary">Synthèse des Chapitres Normatifs</h4>
            <table class="table table-hover align-middle table-custom">
                <thead>
                <tr>
                    <th>Référence</th>
                    <th>Point Audité</th>
                    <th>STATUT (Verdict)</th>
                    <th>Observations de l'auditeur</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${resultatsClauses}">
                    <tr>
                        <td class="fw-bold">${c.clauseIso.code}</td>
                        <td>${c.clauseIso.titre}</td>
                        <td>
                            <c:choose>
                                <c:when test="${c.type == 'NC Majeur'}"><span class="badge bg-danger">NC Majeure</span></c:when>
                                <c:when test="${c.type == 'NC Mineur'}"><span class="badge bg-warning text-dark">NC Mineure</span></c:when>
                                <c:otherwise><span class="badge bg-info">${c.type}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><small>${c.description}</small></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- ================= ONGLET : RÉSULTAT ANNEXE A ================= -->
        <div class="tab-pane fade" id="resAnnexe">
            <h4 class="mb-4 fw-bold text-danger">Maturité des Mesures de Sécurité</h4>
            <div class="table-responsive">
                <table class="table table-bordered align-middle table-custom">
                    <thead>
                    <tr>
                        <th style="width: 100px;">Code</th>
                        <th>Contrôle de l'Annexe A</th>
                        <th style="width: 180px;">Niveau de Maturité</th>
                        <th>Description des Faits</th>
                        <th>Recommandations</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="a" items="${resultatsAnnexeA}">
                        <tr>
                            <td class="text-center fw-bold bg-light">${a.controle.code}</td>
                            <td><strong>${a.controle.titre}</strong></td>
                            <td class="text-center">
                                <!-- Logique de couleur selon la maturité -->
                                <c:set var="mClass" value="${a.niveauMaturite.startsWith('4') || a.niveauMaturite.startsWith('5') ? 'mat-high' : (a.niveauMaturite.startsWith('0') || a.niveauMaturite.startsWith('1') ? 'mat-low' : 'mat-med')}" />
                                <span class="badge ${mClass} w-100 py-2">${a.niveauMaturite}</span>
                            </td>
                            <td><small>${a.description}</small></td>
                            <td>
                                <div class="recommendation-box small">
                                    <i class="bi bi-lightbulb"></i> ${a.recommandation}
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<footer class="mt-5 mb-5 text-center text-muted">
    <hr class="container">
    <p class="small">Logiciel SMSI Corporate - Signature Electronique Intégrée</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>--%>
