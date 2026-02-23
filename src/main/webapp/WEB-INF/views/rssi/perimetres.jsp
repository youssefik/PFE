<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Périmètres</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light container mt-4">
<h2>🏢 Définition du Périmètre du SMSI</h2>
<a href="/dashboard" class="btn btn-secondary mb-3">Retour Dashboard</a>

<div class="card p-3 mb-4 shadow-sm">
    <form action="/rssi/perimetres/save" method="post" class="row g-3">
        <div class="col-md-4">
            <input type="text" name="nom" class="form-control" placeholder="Nom du périmètre (ex: DSI)" required>
        </div>
        <div class="col-md-6">
            <input type="text" name="description" class="form-control" placeholder="Description du contexte">
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-success w-100">Créer</button>
        </div>
    </form>
</div>

<table class="table table-bordered bg-white">
    <thead><tr><th>Nom</th><th>Description</th></tr></thead>
    <tbody>
    <c:forEach var="p" items="${perimetres}">
        <tr><td><strong>${p.nom}</strong></td><td>${p.description}</td></tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>