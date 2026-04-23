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
</html>