<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des utilisateurs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>

<body>
<div class="container mt-4">
    <h2 class="section-title">Gestion des Accès SMSI</h2>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <table class="table align-middle">
                <thead class="table-light">
                <tr>
                    <th>Collaborateur (AD)</th>
                    <th>Email</th>
                    <th>Dernière connexion</th>
                    <th>Rôle actuel</th>
                    <th>Changer le rôle</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>
                            <div class="fw-bold">${user.username}</div>
                            <small class="text-muted">${user.nomComplet}</small>
                        </td>
                        <td>${user.email}</td>
                        <td><fmt:formatDate value="${user.derniereConnexion}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>
                            <span class="badge bg-danger">${user.role}</span>
                        </td>
                        <td>
                            <!-- Formulaire rapide pour changer le rôle -->
                            <form action="/admin/users/update-role" method="post" class="d-flex gap-2">
                                <input type="hidden" name="userId" value="${user.id}">
                                <select name="newRole" class="form-select form-select-sm" style="width: 150px;">
                                    <c:forEach var="role" items="${allRoles}">
                                        <option value="${role}" ${user.role == role ? 'selected' : ''}>${role}</option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-sm btn-dark">Valider</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>