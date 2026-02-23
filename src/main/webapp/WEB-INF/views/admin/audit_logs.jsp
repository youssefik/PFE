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
</html>