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
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Mesures de Sécurité (Annexe A)">

    <!-- Formulaire d'ajout rapide -->
    <div class="card card-outline card-danger shadow-sm mb-4">
        <div class="card-body">
            <form action="/admin/controles/save" method="post" class="row">
                <div class="col-md-2 mb-2">
                    <label class="small font-weight-bold text-uppercase">Référence</label>
                    <input type="text" name="code" class="form-control" placeholder="A.5.1" required>
                </div>
                <div class="col-md-4 mb-2">
                    <label class="small font-weight-bold text-uppercase">Intitulé du contrôle</label>
                    <input type="text" name="titre" class="form-control" placeholder="ex: Inventaire des actifs" required>
                </div>
                <div class="col-md-3 mb-2">
                    <label class="small font-weight-bold text-uppercase">Lien Clause ISO</label>
                    <select name="clauseISO.id" class="form-control" required>
                        <c:forEach var="cl" items="${clauses}">
                            <option value="${cl.id}">${cl.code} - ${cl.titre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3 d-flex align-items-end mb-2">
                    <button type="submit" class="btn btn-danger btn-block font-weight-bold">AJOUTER LE CONTRÔLE</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Liste des contrôles -->
    <div class="card shadow-sm overflow-hidden">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="bg-light">
                <tr>
                    <th class="pl-4">Code</th>
                    <th>Titre du Contrôle</th>
                    <th>Clause associée</th>
                    <th>Domaine</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ctrl" items="${controles}">
                    <tr>
                        <td class="pl-4"><strong class="text-danger">${ctrl.code}</strong></td>
                        <td class="font-weight-bold">${ctrl.titre}</td>
                        <td><span class="badge badge-light border text-dark">${ctrl.clauseISO.code}</span></td>
                        <td class="text-muted small">${ctrl.domaine}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</t:layout>