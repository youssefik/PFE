<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Contrôles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
<h2>🛠️ Gestion des Contrôles ISO 27001</h2>
<a href="/dashboard" class="btn btn-secondary mb-3">Retour Dashboard</a>

<div class="card p-3 mb-4 shadow-sm">
    <form action="/admin/controles/save" method="post" class="row g-3">
        <div class="col-md-2">
            <label>Code</label>
            <input type="text" name="code" class="form-control" placeholder="A.5.1" required>
        </div>
        <div class="col-md-4">
            <label>Titre</label>
            <input type="text" name="titre" class="form-control" placeholder="Politique de sécurité" required>
        </div>
        <div class="col-md-3">
            <label>Clause Parent</label>
            <select name="clauseISO.id" class="form-select" required>
                <c:forEach var="cl" items="${clauses}">
                    <option value="${cl.id}">${cl.code} - ${cl.titre}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label>&nbsp;</label>
            <button type="submit" class="btn btn-success d-block w-100">Ajouter le contrôle</button>
        </div>
    </form>
</div>

<table class="table table-hover border">
    <thead class="table-light">
    <tr><th>Code</th><th>Titre</th><th>Clause associée</th><th>Domaine</th></tr>
    </thead>
    <tbody>
    <c:forEach var="ctrl" items="${controles}">
        <tr>
            <td><strong>${ctrl.code}</strong></td>
            <td>${ctrl.titre}</td>
            <td><span class="badge bg-secondary">${ctrl.clauseISO.code}</span></td>
            <td>${ctrl.domaine}</td>
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
    <title>Gestion des Contrôles | ISO 27001</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #D2010D; }
        body { background-color: #f4f4f4; }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; }
        .card-iso { border-top: 4px solid var(--iso-red); }
        .form-label { font-weight: 700; font-size: 0.85rem; color: #555; text-transform: uppercase; }
        .btn-iso { background-color: var(--iso-red); color: white; font-weight: bold; border-radius: 0; }
        .btn-iso:hover { background-color: #a8010a; color: white; }
        .table th { font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; }
    </style>
</head>
<body class="container py-5">
<div class="d-flex justify-content-between align-items-center mb-5">
    <div class="page-header">
        <h2 class="fw-bold m-0">MESURES DE SÉCURITÉ (ANNEXE A)</h2>
        <small class="text-muted">Référentiel des contrôles techniques et organisationnels</small>
    </div>
    <a href="/dashboard" class="btn btn-dark btn-sm px-4 fw-bold">RETOUR</a>
</div>

<div class="card shadow-sm card-iso mb-5 border-0">
    <div class="card-body p-4">
        <form action="/admin/controles/save" method="post" class="row g-3">
            <div class="col-md-2">
                <label class="form-label">Référence</label>
                <input type="text" name="code" class="form-control" placeholder="A.5.1" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Intitulé du contrôle</label>
                <input type="text" name="titre" class="form-control" placeholder="ex: Inventaire des actifs" required>
            </div>
            <div class="col-md-3">
                <label class="form-label">Lien Clause ISO</label>
                <select name="clauseISO.id" class="form-select" required>
                    <c:forEach var="cl" items="${clauses}">
                        <option value="${cl.id}">${cl.code} - ${cl.titre}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-iso w-100">AJOUTER LE CONTRÔLE</button>
            </div>
        </form>
    </div>
</div>

<div class="card border-0 shadow-sm overflow-hidden">
    <table class="table table-hover mb-0">
        <thead class="table-light">
        <tr>
            <th class="ps-4">Code</th>
            <th>Titre du Contrôle</th>
            <th>Clause associée</th>
            <th>Domaine</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="ctrl" items="${controles}">
            <tr class="align-middle">
                <td class="ps-4"><strong style="color: var(--iso-red);">${ctrl.code}</strong></td>
                <td class="fw-semibold">${ctrl.titre}</td>
                <td><span class="badge bg-light text-dark border">${ctrl.clauseISO.code}</span></td>
                <td class="text-muted small">${ctrl.domaine}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>