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
<!DOCTYPE html>
<html>
<head>
    <title>Journal d'Audit | ISO 27001</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; }
        body { background-color: #f4f4f4; font-family: 'Inter', sans-serif; }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; margin-bottom: 30px; }
        .table { background: white; border-radius: 4px; overflow: hidden; }
        .table thead { background-color: #eee; color: var(--iso-dark); }
        .badge-user { background-color: white; color: var(--iso-red); border: 1px solid var(--iso-red); font-weight: 600; }
        .btn-back { color: var(--iso-dark); text-decoration: none; font-weight: 600; transition: 0.3s; }
        .btn-back:hover { color: var(--iso-red); }
    </style>
</head>
<body class="container py-5">
<div class="d-flex justify-content-between align-items-center mb-4">
    <div class="page-header">
        <h2 class="fw-bold m-0 text-uppercase" style="letter-spacing: 1px;">Journal d'Audit</h2>
        <small class="text-muted">Traçabilité des actions sur le SMSI</small>
    </div>
    <a href="/dashboard" class="btn-back"><i class="bi bi-arrow-left"></i> RETOUR DASHBOARD</a>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <table class="table table-hover mb-0">
            <thead>
            <tr>
                <th class="ps-4">Date</th>
                <th>Utilisateur</th>
                <th>Action effectuée</th>
                <th>Entité cible</th>
                <th class="text-center">ID</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="log" items="${logs}">
                <tr class="align-middle">
                    <td class="ps-4 text-muted">${log.dateCreation}</td>
                    <td><span class="badge badge-user p-2">${log.utilisateur}</span></td>
                    <td><span class="fw-bold text-dark">${log.action}</span></td>
                    <td><span class="text-uppercase small fw-semibold">${log.typeEntite}</span></td>
                    <td class="text-center text-muted"><small>#${log.idEntite}</small></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>