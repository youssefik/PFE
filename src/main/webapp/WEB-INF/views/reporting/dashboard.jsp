<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Direction Dashboard - Corporate SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f4f7f6; font-family: 'Inter', sans-serif; }
        .kpi-card { border: none; border-radius: 12px; }
        .stat-value { font-size: 2.2rem; font-weight: 800; }

        /* HEATMAP STYLING */
        .heatmap-table { table-layout: fixed; width: 100%; border-spacing: 6px; border-collapse: separate; }
        .heatmap-table td { height: 65px; text-align: center; vertical-align: middle; border-radius: 10px; font-weight: 900; font-size: 1.3rem; transition: 0.3s; position: relative; }
        .heatmap-table td:hover { transform: scale(1.05); filter: brightness(1.1); cursor: pointer; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }

        /* Couleurs ISO 27005 */
        .lvl-low      { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; } /* Vert */
        .lvl-medium   { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; } /* Jaune */
        .lvl-high     { background-color: #ffe5d0; color: #854d0e; border: 1px solid #fecba1; } /* Orange */
        .lvl-critical { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; } /* Rouge */

        .axis-label { font-size: 0.75rem; font-weight: bold; color: #6c757d; text-transform: uppercase; }
        .empty-cell { font-weight: 400 !important; opacity: 0.3; font-size: 0.9rem !important; }
    </style>
</head>
<body class="container py-4">

<!-- HEADER NAVIGATION -->
<div class="d-flex justify-content-between align-items-center mb-5">
    <h3 class="fw-bold"><i class="bi bi-shield-lock-fill text-danger me-2"></i>Pilotage Stratégique SMSI</h3>
    <div>
        <button onclick="window.print()" class="btn btn-outline-dark btn-sm me-2"><i class="bi bi-file-earmark-pdf"></i> PDF</button>
        <a href="/dashboard" class="btn btn-dark btn-sm shadow-sm">RETOUR DASHBOARD</a>
    </div>
</div>

<!-- RAPPELS KPI HAUT DE PAGE -->
<div class="row g-4 mb-5">
    <div class="col-md-3">
        <div class="card kpi-card shadow-sm border-start border-primary border-5">
            <div class="card-body">
                <small class="text-muted fw-bold">CONFORMITÉ GLOBALE</small>
                <div class="stat-value text-primary">${stats.complianceRate}%</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card kpi-card shadow-sm border-start border-danger border-5">
            <div class="card-body">
                <small class="text-muted fw-bold">RISQUES CRITIQUES</small>
                <div class="stat-value text-danger">${stats.highRisksCount}</div>
            </div>
        </div>
    </div>
    <div class="col-md-3" onclick="location.href='/planification/logs'">
        <div class="card kpi-card shadow-sm border-start border-success border-5" style="cursor:pointer">
            <div class="card-body">
                <small class="text-muted fw-bold">ACTIFS INVENTORIÉS</small>
                <div class="stat-value text-success">${stats.totalAssets}</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card kpi-card shadow-sm border-start border-warning border-5">
            <div class="card-body">
                <small class="text-muted fw-bold">ACTIONS ACTIONS CLÔTURÉES</small>
                <div class="stat-value text-warning">${stats.closedActions}/${stats.totalActions}</div>
            </div>
        </div>
    </div>
</div>

<div class="row g-4">
    <!-- MATRICE 5x5 DYNAMIQUE -->
    <div class="col-lg-7">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white border-0 py-3">
                <h6 class="mb-0 fw-bold">Cartographie des Risques Inhérents (ISO 27005)</h6>
            </div>
            <div class="card-body">
                <table class="heatmap-table">
                    <!-- On boucle sur l'Impact de 5 (haut) vers 1 (bas) -->
                    <c:forEach var="impactVal" begin="0" end="4">
                        <c:set var="i" value="${5 - impactVal}" />
                        <tr>
                            <td class="axis-label pe-3">Impact ${i}</td>
                            <c:forEach var="p" begin="1" end="5">
                                <c:set var="val" value="${stats.riskDistribution[i][p]}" />
                                <c:set var="score" value="${i * p}" />

                                <%-- Détermination de la classe de couleur --%>
                                <c:choose>
                                    <c:when test="${score >= 15}"><c:set var="colorClass" value="lvl-critical" /></c:when>
                                    <c:when test="${score >= 8}"><c:set var="colorClass" value="lvl-high" /></c:when>
                                    <c:when test="${score >= 4}"><c:set var="colorClass" value="lvl-medium" /></c:when>
                                    <c:otherwise><c:set var="colorClass" value="lvl-low" /></c:otherwise>
                                </c:choose>

                                <%-- CORRECTION : On utilise ${colorClass} ici --%>
                                <td class="${colorClass} ${val == 0 ? 'empty-cell' : ''}"
                                    onclick="if(${val > 0}) window.location.href='/rssi/risques?impact=${i}&proba=${p}'"
                                    style="cursor: ${val > 0 ? 'pointer' : 'default'};">

                                        <%-- On affiche le chiffre seulement s'il est supérieur à 0 --%>
                                    <c:if test="${val > 0}">
                                        ${val}
                                    </c:if>
                                </td>
                            </c:forEach>
                        </tr>
                    </c:forEach>

                    <!-- Ligne des labels de probabilité -->
                    <tr>
                        <td></td>
                        <td class="axis-label pt-3 text-center">Prob 1</td>
                        <td class="axis-label pt-3 text-center">Prob 2</td>
                        <td class="axis-label pt-3 text-center">Prob 3</td>
                        <td class="axis-label pt-3 text-center">Prob 4</td>
                        <td class="axis-label pt-3 text-center">Prob 5</td>
                    </tr>
                </table>

                <!-- LEGENDE SOUS MATRICE -->
                <div class="mt-4 d-flex justify-content-center gap-4">
                    <small><i class="bi bi-square-fill text-danger"></i> Critique</small>
                    <small><i class="bi bi-square-fill text-warning"></i> Significatif</small>
                    <small><i class="bi bi-square-fill text-primary"></i> Modéré</small>
                    <small><i class="bi bi-square-fill text-success"></i> Faible</small>
                </div>
            </div>
        </div>
    </div>

    <!-- RÉSUMÉ IA / CONSEILS -->
    <div class="col-lg-5">
        <div class="card border-0 shadow-sm bg-dark text-white h-100">
            <div class="card-header bg-transparent border-0 pt-4">
                <h5 class="fw-bold"><i class="bi bi-robot me-2 text-info"></i>Assistant Décisionnel</h5>
            </div>
            <div class="card-body">
                <div class="p-3 rounded bg-secondary bg-opacity-25 mb-4">
                    <p class="small mb-0">
                        <strong>Analyse des risques :</strong>
                        Le système détecte <strong>${stats.highRisksCount} risques critiques</strong>.
                        La concentration se situe sur les actifs de type "${stats.totalRisks > 0 ? 'Serveur / Base de données' : 'N/A'}".
                    </p>
                </div>

                <h6>Recommandations du mois :</h6>
                <ul class="small">
                    <c:if test="${stats.highRisksCount > 0}">
                        <li class="mb-2">Prioriser le plan de traitement pour les ${stats.highRisksCount} alertes rouges.</li>
                    </c:if>
                    <c:if test="${stats.complianceRate < 80}">
                        <li class="mb-2">Augmenter la couverture de l'Annexe A sur le thème A.8 (Technologie).</li>
                    </c:if>
                    <li class="mb-2">Vérifier l'historique des backups suite aux 2 nouveaux actifs détectés.</li>
                </ul>

                <div class="mt-auto pt-4">
                    <a href="/rssi/risk-editor" class="btn btn-info btn-sm w-100 fw-bold">CORRIGER LES RISQUES</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Direction Dashboard - ISO 27001</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .kpi-card { border: none; border-radius: 15px; transition: 0.3s; }
        .kpi-card:hover { transform: translateY(-5px); }
        .stat-value { font-size: 2.5rem; font-weight: 800; }
        .chart-container { position: relative; height: 300px; }



        /* Design High-Level de la Matrice */
        .heatmap { table-layout: fixed; width: 100%; border-spacing: 4px; border-collapse: separate; }
        .heatmap td { height: 50px; text-align: center; vertical-align: middle; border-radius: 8px; font-weight: bold; font-size: 1.1rem; transition: 0.3s; }
        .heatmap td:hover { transform: scale(1.1); cursor: pointer; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }

        /* Couleurs dynamiques basées sur le score (Impact x Proba) */
        .risk-lvl-1 { background-color: #2ecc71; color: white; } /* Vert : 1 à 3 */
        .risk-lvl-2 { background-color: #f1c40f; color: #2c3e50; } /* Jaune : 4 à 7 */
        .risk-lvl-3 { background-color: #e67e22; color: white; } /* Orange : 8 à 14 */
        .risk-lvl-4 { background-color: #e74c3c; color: white; } /* Rouge : 15+ */

        .label-axis { font-size: 0.7rem; font-weight: bold; color: #7f8c8d; text-transform: uppercase; }

    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand fw-bold"><i class="bi bi-graph-up-arrow text-success me-2"></i>Tableau de Bord Direction</span>
        <a href="/dashboard" class="btn btn-outline-light btn-sm">Retour</a>
    </div>
</nav>

<div class="container pb-5">

    <!-- Ligne des KPI -->
    <div class="row g-4 mb-5">
        <div class="col-md-3">
            <div class="card kpi-card bg-primary text-white shadow">
                <div class="card-body">
                    <h6 class="text-uppercase small">Taux de Conformité</h6>
                    &lt;%&ndash;<div class="stat-value">${stats.complianceRate}%</div>
                    <div class="progress mt-2" style="height: 5px;">
                        <div class="progress-bar bg-white" style="width: ${stats.complianceRate}%"></div>
                    </div>&ndash;%&gt;
                    <div class="stat-value
                        ${stats.complianceRate > 80 ? 'text-white' : (stats.complianceRate > 50 ? 'text-warning' : 'text-white')}">
                        ${stats.complianceRate}%
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card bg-danger text-white shadow">
                <div class="card-body">
                    <h6 class="text-uppercase small">Risques Critiques</h6>
                    <div class="stat-value">${stats.highRisksCount}</div>
                    <small>Risques avec score ≥ 15</small>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card bg-success text-white shadow">
                <div class="card-body">
                    <h6 class="text-uppercase small">Actions Clôturées</h6>
                    <div class="stat-value">${stats.closedActions} / ${stats.totalActions}</div>
                    <small>Traitement des non-conformités</small>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card bg-white text-dark shadow border-start border-4 border-info">
                <div class="card-body">
                    <h6 class="text-uppercase small text-muted">Actifs Sous Gestion</h6>
                    <div class="stat-value">${stats.totalAssets}</div>
                    <small>Nombre d'actifs inventoriés</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques -->
    <div class="row g-4">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header bg-white fw-bold">État de mise en œuvre du SoA</div>
                <div class="card-body">
                    <canvas id="soaChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header bg-white fw-bold">Santé de l'Amélioration Continue</div>
                <div class="card-body text-center">
                    <canvas id="ncChart" style="max-height: 250px;"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3">
            <h6 class="mb-0 fw-bold"><i class="bi bi-grid-3x3-gap text-danger me-2"></i>Matrice de Criticité ISO 27005 (Réel)</h6>
        </div>
        <div class="card-body">
            <table class="heatmap">
                <!-- Boucle sur l'Impact de 5 vers 1 (Axe Vertical) -->
                <c:forEach var="i" begin="0" end="4">
                    <c:set var="impactVal" value="${5 - i}" />
                    <tr>
                        <td class="label-axis" style="background:none;">I : ${impactVal}</td>

                        <!-- Boucle sur la Probabilité de 1 vers 5 (Axe Horizontal) -->
                        <c:forEach var="probaVal" begin="1" end="5">
                            <c:set var="count" value="${stats.riskDistribution[impactVal][probaVal]}" />
                            <c:set var="score" value="${impactVal * probaVal}" />

                            <!-- Attribution de la couleur selon le score calculé -->
                            <c:set var="colorClass" value="${score >= 15 ? 'risk-lvl-4' : (score >= 8 ? 'risk-lvl-3' : (score >= 4 ? 'risk-lvl-2' : 'risk-lvl-1'))}" />

                            <td class="${colorClass}">
                                <c:if test="${count > 0}">
                                    ${count} <!-- Affiche le nombre de risques réels -->
                                </c:if>
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
                <!-- Labels Probabilité en bas -->
                <tr>
                    <td style="background:none;"></td>
                    <td class="label-axis pt-3 text-center">P:1</td>
                    <td class="label-axis pt-3 text-center">P:2</td>
                    <td class="label-axis pt-3 text-center">P:3</td>
                    <td class="label-axis pt-3 text-center">P:4</td>
                    <td class="label-axis pt-3 text-center">P:5</td>
                </tr>
            </table>
        </div>
    </div>

</div>

<script>
    // 1. Graphique SoA
    const ctxSoa = document.getElementById('soaChart');
    new Chart(ctxSoa, {
        type: 'bar',
        data: {
            labels: ['Applicables', 'Conformes'],
            datasets: [{
                label: 'Nombre de contrôles',
                data: [${stats.applicableControls}, ${stats.conformingControls}],
                backgroundColor: ['#0d6efd', '#198754']
            }]
        },
        options: { maintainAspectRatio: false }
    });

    // 2. Graphique NC
    const ctxNc = document.getElementById('ncChart');
    new Chart(ctxNc, {
        type: 'doughnut',
        data: {
            labels: ['Actions Clôturées', 'En Cours'],
            datasets: [{
                data: [${stats.closedActions}, ${stats.totalActions - stats.closedActions}],
                backgroundColor: ['#198754', '#ffc107']
            }]
        }
    });
</script>
</body>
</html>--%>
