<%--
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
</html>--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Périmètre du SMSI">

    <%-- Styles spécifiques pour le marquage ISO --%>
    <style>
        .page-header-desc { border-left: 5px solid #D2010D; padding-left: 15px; margin-bottom: 30px; }
    </style>

    <div class="row mb-4">
        <div class="col-12">
            <div class="page-header-desc">
                <p class="text-muted mb-0"><strong>Clause 4.3</strong> : Détermination du périmètre et des limites physiques/logiques du Système de Gestion de la Sécurité de l'Information.</p>
            </div>
        </div>
    </div>

    <!-- FORMULAIRE DE CRÉATION -->
    <div class="card card-outline card-danger shadow-sm mb-4">
        <div class="card-header">
            <h3 class="card-title font-weight-bold"><i class="fas fa-plus mr-2"></i> Ajouter un périmètre d'application</h3>
        </div>
        <div class="card-body">
            <form action="/rssi/perimetres/save" method="post" class="row">
                <div class="col-md-4 form-group">
                    <label class="font-weight-bold small text-uppercase">Nom du périmètre</label>
                    <input type="text" name="nom" class="form-control" placeholder="ex: DSI, Site Principal, Infrastructure Cloud..." required>
                </div>
                <div class="col-md-6 form-group">
                    <label class="font-weight-bold small text-uppercase">Description / Contexte</label>
                    <input type="text" name="description" class="form-control" placeholder="Détaillez les limites physiques et logiques concernées...">
                </div>
                <div class="col-md-2 d-flex align-items-end mb-3">
                    <button type="submit" class="btn btn-danger btn-block font-weight-bold elevation-1">
                        <i class="fas fa-save mr-1"></i> CRÉER
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- LISTE DES PÉRIMÈTRES -->
    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover table-striped table-valign-middle mb-0">
                <thead class="bg-dark">
                <tr>
                    <th class="pl-4">Identifiant / Nom</th>
                    <th>Description du contexte</th>
                    <th class="text-right pr-4">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${perimetres}">
                    <tr>
                        <td class="pl-4 font-weight-bold text-danger text-uppercase">
                            <i class="fas fa-map-marker-alt mr-2 text-muted"></i> ${p.nom}
                        </td>
                        <td class="text-muted font-italic">${p.description}</td>
                        <td class="text-right pr-4">
                                <%-- Ajout possible d'un bouton supprimer/éditer plus tard --%>
                            <span class="badge badge-light border">Actif</span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <c:if test="${empty perimetres}">
            <div class="card-body text-center py-5">
                <i class="fas fa-globe-africa fa-3x text-muted mb-3"></i>
                <p class="text-muted font-italic">Aucun périmètre défini pour le moment.</p>
            </div>
        </c:if>
    </div>

</t:layout>


<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Périmètre du SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root { --iso-red: #D2010D; }
        body { background-color: #f4f4f4; }
        .logo-box { background: var(--iso-red); color: white; padding: 5px 12px; font-weight: 800; margin-right: 10px; }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; margin-bottom: 40px; }
        .btn-iso { background-color: var(--iso-red); color: white; font-weight: bold; border-radius: 0; border: none; }
    </style>
</head>
<body class="py-5">
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-5">
        <div class="page-header">
            <h2 class="fw-bold m-0 text-uppercase">Périmètre du SMSI</h2>
            <small class="text-muted">Clause 4.3 : Détermination du périmètre</small>
        </div>
        <a href="/dashboard" class="btn btn-outline-dark fw-bold btn-sm">RETOUR</a>
    </div>

    <div class="card border-0 shadow-sm mb-5" style="border-top: 4px solid var(--iso-red) !important;">
        <div class="card-body p-4">
            <form action="/rssi/perimetres/save" method="post" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold small">Nom du périmètre</label>
                    <input type="text" name="nom" class="form-control" placeholder="DSI, Site de Production..." required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small">Description / Contexte</label>
                    <input type="text" name="description" class="form-control" placeholder="Limites physiques et logiques">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-iso w-100">CRÉER</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card border-0 shadow-sm overflow-hidden">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
            <tr><th class="ps-4 py-3">Périmètre</th><th>Description</th></tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${perimetres}">
                <tr>
                    <td class="ps-4 fw-bold text-uppercase" style="color: var(--iso-red);">${p.nom}</td>
                    <td class="text-muted">${p.description}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>--%>
