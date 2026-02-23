<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SMSI ISO 27001 - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .menu-card { transition: transform 0.2s; cursor: pointer; }
        .menu-card:hover { transform: scale(1.02); }
        .role-badge { font-size: 0.8em; }
    </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">🛡️ Système SMSI ISO 27001</span>
        <div class="text-white">
            <span class="me-3">👤 ${username}</span>
            <a href="/logout" class="btn btn-outline-danger btn-sm">Déconnexion</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow-sm p-3">
                <h5>Mes Rôles :
                    <c:forEach var="role" items="${authorities}">
                        <span class="badge bg-primary role-badge">${role.authority}</span>
                    </c:forEach>
                </h5>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- BLOC 1 : ADMINISTRATION (Rôles ADMIN ou RSSI) -->
        <c:if test="${isAdmin || isRSSI}">
            <div class="col-md-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0"><i class="bi bi-gear-fill"></i> Administration</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted small">Référentiels et traçabilité système.</p>
                        <a href="/admin/clauses" class="btn btn-outline-secondary btn-sm w-100 mb-2 text-start">
                            <i class="bi bi-book"></i> Référentiel Clauses ISO
                        </a>
                        <a href="/admin/controles" class="btn btn-outline-secondary btn-sm w-100 mb-2 text-start">
                            <i class="bi bi-list-stars"></i> Référentiel Contrôles
                        </a>
                        <c:if test="${isAdmin}">
                            <a href="/admin/audit-log" class="btn btn-warning btn-sm w-100 text-start">
                                <i class="bi bi-journal-text"></i> Journal d'Audit (Logs)
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- BLOC 2 : GOUVERNANCE & RISQUES (Rôle RSSI ou ADMIN) -->
        <c:if test="${isRSSI || isAdmin}">
            <div class="col-md-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0"><i class="bi bi-shield-exclamation"></i> Risques</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted small">Gestion des actifs et analyse d'impact.</p>
                        <a href="/rssi/perimetres" class="btn btn-outline-danger btn-sm w-100 mb-2 text-start">
                            <i class="bi bi-geo-alt"></i> Périmètres du SMSI
                        </a>
                        <a href="/rssi/actifs" class="btn btn-outline-danger btn-sm w-100 mb-2 text-start">
                            <i class="bi bi-pc-display"></i> Inventaire des Actifs
                        </a>
                        <a href="/rssi/risques" class="btn btn-danger btn-sm w-100 text-start">
                            <i class="bi bi-graph-down-arrow"></i> Analyse des Risques
                        </a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- BLOC 3 : CONFORMITÉ (NOUVEAU - SPRINT 3) -->
        <!-- Accessible au RSSI, ADMIN et PILOTES de contrôle -->
        <c:if test="${isRSSI || isAdmin || isPilote}">
            <div class="col-md-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-check-all"></i> Conformité</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted small">Déclaration d'applicabilité et preuves.</p>
                        <a href="/compliance/soa" class="btn btn-primary btn-sm w-100 mb-2 text-start">
                            <i class="bi bi-clipboard-check"></i> Déclaration (SoA)
                        </a>
                        <!-- Sprint 4 à venir -->
                        <button class="btn btn-outline-primary btn-sm w-100 text-start" disabled>
                            <i class="bi bi-file-earmark-arrow-up"></i> Collecte des Preuves
                        </button>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Section Accès restreint (Auditeurs/Direction) -->
        <div class="col-md-4">
            <div class="card h-100 shadow-sm menu-card border-info">
                <div class="card-body">
                    <h5 class="card-title">📊 Reporting & Suivi</h5>
                    <p class="card-text text-muted">Accès aux tableaux de bord (Sprint 6).</p>
                    <button class="btn btn-info btn-sm w-100" disabled>Bientôt disponible</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>