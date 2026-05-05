<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Administration Clauses ISO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
<h2>📚 Référentiel des Clauses ISO 27001</h2>
<a href="/dashboard" class="btn btn-secondary mb-3">Retour Dashboard</a>

<div class="card p-3 mb-4">
    <h4>Ajouter une Clause</h4>
    <form action="/admin/clauses/save" method="post" class="row g-3">
        <div class="col-md-2"><input type="text" name="code" class="form-control" placeholder="Code (ex: 4.1)" required></div>
        <div class="col-md-4"><input type="text" name="titre" class="form-control" placeholder="Titre" required></div>
        <div class="col-md-4"><input type="text" name="description" class="form-control" placeholder="Description"></div>
        <div class="col-md-2"><button type="submit" class="btn btn-primary w-100">Enregistrer</button></div>
    </form>
</div>

<table class="table table-striped">
    <thead><tr><th>Code</th><th>Titre</th><th>Description</th></tr></thead>
    <tbody>
    <c:forEach var="c" items="${clauses}">
        <tr><td>${c.code}</td><td>${c.titre}</td><td>${c.description}</td></tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>--%>



<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Référentiel des Clauses ISO 27001">

    <div class="card card-outline card-danger shadow-sm mb-4">
        <div class="card-header"><h3 class="card-title">Nouvelle Clause</h3></div>
        <div class="card-body">
            <form action="/admin/clauses/save" method="post" class="row">
                <div class="col-md-2 mb-2">
                    <input type="text" name="code" class="form-control" placeholder="Ex: 4.1" required>
                </div>
                <div class="col-md-4 mb-2">
                    <input type="text" name="titre" class="form-control" placeholder="Titre de la clause" required>
                </div>
                <div class="col-md-4 mb-2">
                    <input type="text" name="description" class="form-control" placeholder="Description courte">
                </div>
                <div class="col-md-2 mb-2">
                    <button type="submit" class="btn btn-danger btn-block font-weight-bold">ENREGISTRER</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-striped mb-0">
                <thead class="bg-light text-uppercase small font-weight-bold">
                <tr>
                    <th class="pl-4" style="width: 100px;">Code</th>
                    <th>Titre</th>
                    <th>Description</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${clauses}">
                    <tr>
                        <td class="pl-4 font-weight-bold text-danger">${c.code}</td>
                        <td class="font-weight-bold">${c.titre}</td>
                        <td class="text-muted small">${c.description}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</t:layout>