<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Importation Collaborateurs - SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #D2010D; --iso-gray: #F4F4F4; }
        body { background-color: var(--iso-gray); font-family: 'Inter', sans-serif; }
        .card-header { background-color: #212121 !important; color: white; border-bottom: 3px solid var(--iso-red); }
        .btn-iso { background-color: var(--iso-red); color: white; border: none; }
        .btn-iso:hover { background-color: #a8010a; color: white; }
        .search-box { border-radius: 20px; padding-left: 20px; }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-10">

            <!-- Fil d'Ariane (Breadcrumbs) -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="/admin/users">Gestion Utilisateurs</a></li>
                    <li class="breadcrumb-item active">Importation AD</li>
                </ol>
            </nav>

            <!-- Titre Section -->
            <div class="mb-4 border-start border-5 border-danger ps-3">
                <h2 class="fw-bold">Recherche de collaborateurs</h2>
                <p class="text-muted">Interrogation directe de l'annuaire Active Directory</p>
            </div>

            <!-- Barre de Recherche -->
            <div class="card shadow-sm mb-4">
                <div class="card-body bg-white rounded shadow-sm">
                    <form action="/admin/users/search" method="get" class="row g-3">
                        <div class="col-md-9">
                            <input type="text" name="q" value="${param.q}" class="form-control search-box"
                                   placeholder="Nom complet ou identifiant de connexion..." required>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-dark w-100 rounded-pill">
                                <i class="bi bi-search me-2"></i>Rechercher
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Résultats de Recherche -->
            <c:if test="${not empty results}">
                <div class="card shadow-sm border-0">
                    <div class="card-header py-3">
                        <h6 class="mb-0"><i class="bi bi-people-fill me-2"></i>Résultats trouvés dans l'AD</h6>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>Nom Complet</th>
                                <th>Identifiant</th>
                                <th>Email</th>
                                <th style="width: 250px;">Attribuer un rôle SMSI</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="res" items="${results}">
                                <tr>
                                    <td><strong>${res.nomComplet}</strong></td>
                                    <td><code>${res.username}</code></td>
                                    <td class="text-muted small">${res.email}</td>
                                    <td>
                                        <!-- Formulaire d'importation individuelle -->
                                        <form action="/admin/users/import" method="post" class="d-flex gap-2">
                                            <input type="hidden" name="username" value="${res.username}">
                                            <input type="hidden" name="nom" value="${res.nomComplet}">
                                            <input type="hidden" name="email" value="${res.email}">

                                            <select name="role" class="form-select form-select-sm" required>
                                                <option value="" disabled selected>Choisir rôle...</option>
                                                <c:forEach var="role" items="${roles}">
                                                    <option value="${role}">${role}</option>
                                                </c:forEach>
                                            </select>

                                            <button type="submit" class="btn btn-sm btn-iso">
                                                Importer
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty results && not empty param.q}">
                <div class="alert alert-warning text-center">
                    <i class="bi bi-info-circle me-2"></i>Aucun utilisateur trouvé dans l'AD avec ce critère.
                </div>
            </c:if>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>