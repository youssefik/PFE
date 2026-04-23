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
<!DOCTYPE html>
<html>
<head>
    <title>Clauses ISO 27001</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #D2010D; }
        body { background-color: #f4f4f4; }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; }
        .iso-card-form { border-top: 4px solid var(--iso-red); border-radius: 0; }
        .btn-iso { background-color: var(--iso-red); color: white; border-radius: 0; font-weight: bold; border: none; }
        .btn-iso:hover { background-color: #a8010a; color: white; }
        .clause-code { color: var(--iso-red); font-weight: 800; }
    </style>
</head>
<body class="container py-5">
<div class="d-flex justify-content-between align-items-center mb-5">
    <div class="page-header">
        <h2 class="fw-bold m-0">RÉFÉRENTIEL DES CLAUSES</h2>
        <small class="text-muted">Standard ISO/IEC 27001:2022</small>
    </div>
    <a href="/dashboard" class="btn btn-outline-dark btn-sm fw-bold px-3">RETOUR</a>
</div>

<!-- Formulaire Ajout -->
<div class="card shadow-sm iso-card-form mb-5">
    <div class="card-body p-4">
        <h5 class="fw-bold mb-4">Ajouter une nouvelle clause</h5>
        <form action="/admin/clauses/save" method="post" class="row g-3">
            <div class="col-md-2">
                <input type="text" name="code" class="form-control" placeholder="Ex: 4.1" required>
            </div>
            <div class="col-md-4">
                <input type="text" name="titre" class="form-control" placeholder="Titre de la clause" required>
            </div>
            <div class="col-md-4">
                <input type="text" name="description" class="form-control" placeholder="Description courte">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-iso w-100">ENREGISTRER</button>
            </div>
        </form>
    </div>
</div>

<!-- Table Clauses -->
<div class="card border-0 shadow-sm">
    <table class="table table-hover mb-0">
        <thead class="table-light">
        <tr>
            <th class="ps-4" style="width: 100px;">Code</th>
            <th>Titre</th>
            <th>Description</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="c" items="${clauses}">
            <tr>
                <td class="ps-4 clause-code">${c.code}</td>
                <td class="fw-bold">${c.titre}</td>
                <td class="text-muted">${c.description}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>