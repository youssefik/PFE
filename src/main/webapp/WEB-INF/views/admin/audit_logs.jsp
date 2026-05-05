<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Journal d'Audit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
<h2>📜 Journal d'Audit du Système</h2>
<a href="/dashboard" class="btn btn-secondary mb-3">Retour Dashboard</a>

<table class="table table-bordered table-hover">
    <thead class="table-dark">
    <tr>
        <th>Date</th>
        <th>Utilisateur</th>
        <th>Action</th>
        <th>Entité</th>
        <th>ID Entité</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="log" items="${logs}">
        <tr>
            <td>${log.dateCreation}</td>
            <td><span class="badge bg-info">${log.utilisateur}</span></td>
            <td><strong>${log.action}</strong></td>
            <td>${log.typeEntite}</td>
            <td><small>${log.idEntite}</small></td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>--%>



<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Journal d'Audit">

    <div class="row mb-3">
        <div class="col-12">
            <p class="text-muted"><i class="fas fa-info-circle mr-1"></i> Traçabilité complète des actions effectuées sur le SMSI.</p>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="bg-dark text-white">
                <tr>
                    <th class="pl-4">Date</th>
                    <th>Utilisateur</th>
                    <th>Action effectuée</th>
                    <th>Entité cible</th>
                    <th class="text-center">ID</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="log" items="${logs}">
                    <tr class="align-middle">
                        <td class="pl-4 text-muted small">${log.dateCreation}</td>
                        <td><span class="badge border border-danger text-danger p-2"><i class="fas fa-user mr-1"></i> ${log.utilisateur}</span></td>
                        <td><span class="font-weight-bold">${log.action}</span></td>
                        <td><span class="text-uppercase small font-weight-bold text-secondary">${log.typeEntite}</span></td>
                        <td class="text-center text-muted"><small>#${log.idEntite}</small></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</t:layout>