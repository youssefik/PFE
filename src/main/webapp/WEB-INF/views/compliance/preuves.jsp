<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Preuves : ${soa.controle.code}">

    <!-- En-tête informatif sur le contrôle ISO -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="info-box shadow-sm border-left border-danger" style="border-left-width: 5px !important;">
                <span class="info-box-icon bg-danger elevation-1"><i class="fas fa-shield-alt"></i></span>
                <div class="info-box-content">
                    <span class="info-box-text text-uppercase font-weight-bold">Contrôle Annexe A</span>
                    <span class="info-box-number text-lg">${soa.controle.code} - ${soa.controle.titre}</span>
                </div>
                <div class="ml-auto align-self-center pr-3">
                    <a href="/compliance/soa" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-chevron-left mr-1"></i> Retour à la SoA
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- FORMULAIRE D'UPLOAD -->
        <div class="col-md-4">
            <div class="card card-outline card-danger shadow-sm">
                <div class="card-header">
                    <h3 class="card-title font-weight-bold"><i class="fas fa-cloud-upload-alt mr-2"></i> Ajouter un élément</h3>
                </div>
                <div class="card-body">
                    <form action="/compliance/preuves/upload" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="soaId" value="${soa.id}">

                        <div class="form-group">
                            <label class="small font-weight-bold">Titre du document</label>
                            <input type="text" name="titre" class="form-control" placeholder="ex: Charte de Sécurité 2024" required>
                        </div>

                        <div class="form-group">
                            <label class="small font-weight-bold">Catégorie</label>
                            <select name="type" class="form-control select2">
                                <option value="DOCUMENT">Document (PDF, DOCX, ...)</option>
                                <option value="CAPTURE">Capture d'écran (Evidence visuelle)</option>
                                <option value="LOG">Extrait de logs ou Rapport</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="small font-weight-bold">Fichier source</label>
                            <div class="custom-file">
                                <input type="file" name="fichier" class="custom-file-input" id="customFile" required>
                                <label class="custom-file-label" for="customFile">Choisir le fichier</label>
                            </div>
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn btn-danger btn-block shadow-sm">
                                <i class="fas fa-upload mr-1"></i> Uploader la preuve
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- LISTE DES PREUVES DÉPOSÉES -->
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark">
                    <h3 class="card-title font-weight-bold"><i class="fas fa-copy mr-2"></i> Répertoire des preuves collectées</h3>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover table-valign-middle mb-0">
                        <thead class="bg-light">
                        <tr>
                            <th class="pl-4">Nom de la preuve</th>
                            <th>Type</th>
                            <th>Date de dépôt</th>
                            <th class="text-right pr-4">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="p" items="${preuves}">
                            <tr>
                                <td class="pl-4 font-weight-bold text-dark">
                                    <i class="far fa-file-alt text-muted mr-2"></i>${p.titre}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.type eq 'DOCUMENT'}">
                                            <span class="badge badge-primary"><i class="fas fa-file-pdf mr-1"></i> Document</span>
                                        </c:when>
                                        <c:when test="${p.type eq 'CAPTURE'}">
                                            <span class="badge badge-info"><i class="fas fa-image mr-1"></i> Capture</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary"><i class="fas fa-terminal mr-1"></i> ${p.type}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="small text-muted italic">${p.dateAjout}</td>
                                <td class="text-right pr-4">
                                        <%-- Utilisation de download link --%>
                                    <a href="${p.urlFichier}" class="btn btn-sm btn-outline-danger shadow-sm" download>
                                        <i class="fas fa-download"></i> Télécharger
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty preuves}">
                            <tr>
                                <td colspan="4" class="text-center py-5 text-muted">
                                    <i class="fas fa-folder-open fa-3x mb-3"></i><br>
                                    Aucune preuve n'a encore été déposée pour ce contrôle.
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Script pour afficher le nom du fichier choisi dans l'input -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const fileInput = document.querySelector('.custom-file-input');
            const fileLabel = document.querySelector('.custom-file-label');
            if(fileInput){
                fileInput.addEventListener('change', function(e){
                    var fileName = e.target.files[0].name;
                    fileLabel.innerHTML = fileName;
                });
            }
        });
    </script>

</t:layout>

<%--
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
</html>--%>
