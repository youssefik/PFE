<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Preuves de conformité</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-primary mb-4">
    <div class="container">
        <span class="navbar-brand">📁 Preuves pour : ${soa.controle.code}</span>
        <a href="/compliance/soa" class="btn btn-light btn-sm">Retour SoA</a>
    </div>
</nav>

<div class="container">
    <div class="row">
        <!-- Formulaire d'upload -->
        <div class="col-md-4">
            <div class="card shadow-sm border-0">
                <div class="card-body">
                    <h5 class="card-title">Ajouter une preuve</h5>
                    <form action="/compliance/preuves/upload" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="soaId" value="${soa.id}">
                        <div class="mb-3">
                            <label>Nom de la preuve</label>
                            <input type="text" name="titre" class="form-control" placeholder="ex: Charte Info 2024" required>
                        </div>
                        <div class="mb-3">
                            <label>Type</label>
                            <select name="type" class="form-select">
                                <option value="DOCUMENT">Document (PDF/DOC)</option>
                                <option value="CAPTURE">Capture d'écran</option>
                                <option value="LOG">Extrait de logs</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Fichier</label>
                            <input type="file" name="fichier" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Uploader</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Liste des preuves -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr><th>Titre</th><th>Type</th><th>Date</th><th>Fichier</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${preuves}">
                        <tr>
                            <td><strong>${p.titre}</strong></td>
                            <td><span class="badge bg-info text-dark">${p.type}</span></td>
                            <td class="small">${p.dateAjout}</td>
                            <td>
                                <a href="#" class="btn btn-sm btn-link text-decoration-none">
                                    <i class="bi bi-download"></i> ${p.urlFichier}
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>