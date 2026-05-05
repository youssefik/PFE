<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Journal des exécutions (Audit Trail)">

    <div class="row mb-3">
        <div class="col-12">
            <div class="callout callout-info bg-white shadow-sm">
                <h5><i class="fas fa-info-circle mr-2 text-info"></i> Conformité ISO 27001 (A.8.13)</h5>
                <p>Ces enregistrements constituent la preuve de l'exécution régulière des tâches de sécurité planifiées.</p>
            </div>
        </div>
    </div>

    <div class="card card-dark card-outline shadow-sm">
        <div class="card-header border-0">
            <h3 class="card-title font-weight-bold">
                <i class="fas fa-history mr-2"></i> Historique des opérations
            </h3>
            <div class="card-tools">
                <a href="/planification" class="btn btn-tool">
                    <i class="fas fa-calendar-alt mr-1"></i> Retour à la planification
                </a>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped table-valign-middle mb-0">
                    <thead class="bg-light">
                    <tr>
                        <th class="pl-4">Date / Heure</th>
                        <th>Tâche concernée</th>
                        <th>Résultat d'exécution</th>
                        <th>Message / Preuve technique</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="log" items="${logs}">
                        <tr>
                            <td class="pl-4 text-nowrap">
                                <c:if test="${not empty log.dateExecution}">
                                    <fmt:parseDate value="${log.dateExecution}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedLogDate" type="both" />
                                    <span class="font-weight-bold">
                                        <fmt:formatDate value="${parsedLogDate}" pattern="dd/MM/yyyy" />
                                    </span>
                                    <span class="text-muted small ml-1">
                                        <fmt:formatDate value="${parsedLogDate}" pattern="HH:mm:ss" />
                                    </span>
                                </c:if>
                            </td>
                            <td>
                                <span class="badge badge-light border px-2 py-1">
                                    <i class="fas fa-tag mr-1 text-secondary"></i> ${log.titreTache}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${log.statut == 'SUCCES'}">
                                        <span class="badge badge-success px-3 py-2 elevation-1">
                                            <i class="fas fa-check-circle mr-1"></i> SUCCÈS
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger px-3 py-2 elevation-1">
                                            <i class="fas fa-exclamation-triangle mr-1"></i> ERREUR
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="small text-muted italic">
                                <c:out value="${log.message}" default="Aucun message retourné."/>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty logs}">
                <div class="text-center py-5">
                    <i class="fas fa-terminal fa-3x text-muted mb-3"></i>
                    <p class="text-muted">Aucune donnée d'exécution dans le journal pour le moment.</p>
                </div>
            </c:if>
        </div>

        <div class="card-footer bg-white border-top">
            <small class="text-muted">
                <i class="fas fa-lock mr-1"></i> Journal en lecture seule (immuable pour l'auditeur).
            </small>
        </div>
    </div>

</t:layout>

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Historique d'exécution - SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="/planification">Planification</a></li>
            <li class="breadcrumb-item active">Historique</li>
        </ol>
    </nav>

    <div class="card shadow border-0">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-3">
            <h5 class="mb-0"><i class="bi bi-clipboard-data me-2"></i> Journal des exécutions (Audit Trail)</h5>
            <a href="/planification" class="btn btn-outline-light btn-sm">Retour à la planification</a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead class="table-secondary">
                    <tr>
                        <th>Date / Heure</th>
                        <th>Tâche concernée</th>
                        <th>Résultat</th>
                        <th>Message / Preuve</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="log" items="${logs}">
                        <tr>
                            <td class="text-nowrap">
                                <fmt:parseDate value="${log.dateExecution}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedLogDate" type="both" />
                                <fmt:formatDate value="${parsedLogDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </td>
                            <td class="fw-bold">${log.titreTache}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${log.statut == 'SUCCES'}">
                                            <span class="badge bg-success-subtle text-success border border-success">
                                                <i class="bi bi-check-circle-fill"></i> SUCCÈS
                                            </span>
                                    </c:when>
                                    <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger border border-danger">
                                                <i class="bi bi-exclamation-triangle-fill"></i> ERREUR
                                            </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><small class="text-muted">${log.message}</small></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty logs}">
                        <tr>
                            <td colspan="4" class="text-center py-4 text-muted italic">
                                Aucune exécution enregistrée pour le moment.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="mt-4 text-center">
        <p class="small text-muted italic">
            <i class="bi bi-info-circle"></i> Ces logs sont conservés à des fins de conformité ISO 27001 (Mesure A.8.13).
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>--%>
