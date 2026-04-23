<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventaire des Actifs - SMSI</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .cid-badge { width: 30px; display: inline-block; text-align: center; font-weight: bold; }
        .table-vcenter td { vertical-align: middle; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand"><i class="bi bi-shield-check"></i> SMSI ISO 27001</span>
        <a href="/dashboard" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Dashboard</a>
    </div>
</nav>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-box-seam"></i> Inventaire des Actifs</h2>
        <span class="badge bg-secondary">${actifs.size()} Actifs répertoriés</span>
    </div>

    <!-- Formulaire d'ajout -->
    <div class="card shadow-sm mb-5">
        <div class="card-header bg-white">
            <h5 class="mb-0">Ajouter un nouvel actif</h5>
        </div>
        <div class="card-body">
            <!-- Dans la carte de formulaire d'ajout -->
            <form action="/rssi/actifs/save" method="post" class="row g-3">
                <!-- 1. Nom -->
                <div class="col-md-3">
                    <label class="form-label">Nom de l'actif</label>
                    <input type="text" name="nom" class="form-control" required>
                </div>

                <!-- 2. Type -->
                <div class="col-md-2">
                    <label class="form-label">Type</label>
                    <select name="type" class="form-select">
                        <option value="Matériel">Matériel</option>
                        <option value="Logiciel">Logiciel</option>
                        <option value="Données">Données</option>
                    </select>
                </div>

                <!-- 3. Propriétaire (AJOUTÉ POUR CORRIGER L'ERREUR) -->
                <div class="col-md-3">
                    <label class="form-label">Propriétaire / Responsable</label>
                    <input type="text" name="proprietaire" class="form-control" placeholder="ex: DSI, RH..." required>
                </div>

                <!-- 4. Criticités CID -->
                <div class="col-md-1">
                    <label class="form-label">C</label>
                    <input type="number" name="confidentialite" class="form-control" min="1" max="3" value="1">
                </div>
                <div class="col-md-1">
                    <label class="form-label">I</label>
                    <input type="number" name="integrite" class="form-control" min="1" max="3" value="1">
                </div>
                <div class="col-md-1">
                    <label class="form-label">D</label>
                    <input type="number" name="disponibilite" class="form-control" min="1" max="3" value="1">
                </div>

                <!-- 5. Périmètre -->
                <div class="col-md-3">
                    <label class="form-label">Périmètre</label>
                    <select name="perimetreId" class="form-select" required>
                        <c:forEach var="p" items="${perimetres}">
                            <option value="${p.id}">${p.nom}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label">&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100">Ajouter</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Tableau des données -->
    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover table-vcenter mb-0">
                <thead class="table-light">
                <tr>
                    <th>Nom de l'actif</th>
                    <th>Type</th>
                    <th class="text-center">C</th>
                    <th class="text-center">I</th>
                    <th class="text-center">D</th>
                    <th>Périmètre</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="actif" items="${actifs}">
                    <tr>
                        <td><strong>${actif.nom}</strong></td>
                        <td><span class="text-muted small">${actif.type}</span></td>

                        <!-- Confidentialité -->
                        <td class="text-center">
                                <span class="badge cid-badge ${actif.confidentialite == 3 ? 'bg-danger' : (actif.confidentialite == 2 ? 'bg-warning text-dark' : 'bg-success')}">
                                        ${actif.confidentialite}
                                </span>
                        </td>
                        <!-- Intégrité -->
                        <td class="text-center">
                                <span class="badge cid-badge ${actif.integrite == 3 ? 'bg-danger' : (actif.integrite == 2 ? 'bg-warning text-dark' : 'bg-success')}">
                                        ${actif.integrite}
                                </span>
                        </td>
                        <!-- Disponibilité -->
                        <td class="text-center">
                                <span class="badge cid-badge ${actif.disponibilite == 3 ? 'bg-danger' : (actif.disponibilite == 2 ? 'bg-warning text-dark' : 'bg-success')}">
                                        ${actif.disponibilite}
                                </span>
                        </td>

                        <td><span class="badge border text-dark bg-white">${actif.perimetre.nom}</span></td>
                        <td class="text-end">
                            <button class="btn btn-sm btn-outline-danger" title="Supprimer">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty actifs}">
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">
                            <i class="bi bi-info-circle"></i> Aucun actif inventorié pour le moment.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inventaire des Actifs | ISO 27001</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; }
        body { background-color: #f4f4f4; font-family: 'Inter', sans-serif; }
        .logo-box { background: var(--iso-red); color: white; padding: 5px 12px; font-weight: 800; margin-right: 10px; }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; }
        .iso-card { border-top: 4px solid var(--iso-red); border-radius: 0; border-bottom: none; border-left: none; border-right: none; }
        .btn-iso { background-color: var(--iso-red); color: white; font-weight: bold; border-radius: 0; border: none; }
        .btn-iso:hover { background-color: #a8010a; color: white; }
        .cid-badge { width: 28px; height: 28px; line-height: 28px; display: inline-block; border-radius: 50%; font-weight: bold; font-size: 0.8rem; }
    </style>
</head>
<body>

<nav class="navbar navbar-light bg-white border-bottom py-3 mb-4">
    <div class="container">
        <div class="d-flex align-items-center">
            <div class="logo-box">ISO</div>
            <span class="fw-bold text-dark text-uppercase">Asset Management</span>
        </div>
        <a href="/dashboard" class="btn btn-outline-dark btn-sm fw-bold">RETOUR</a>
    </div>
</nav>

<main class="container">
    <div class="page-header mb-4">
        <h2 class="fw-bold m-0 text-uppercase">Patrimoine Informationnel</h2>
        <p class="text-muted">Identification des actifs et évaluation de leur importance (ISO 27005)</p>
    </div>

    <div class="card shadow-sm iso-card mb-5">
        <div class="card-body p-4">
            <h6 class="fw-bold mb-3 text-uppercase text-muted">Évaluation de la valeur des actifs</h6>
            <form action="/rssi/actifs/save" method="post" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label small fw-bold">Nom de l'actif</label>
                    <input type="text" name="nom" class="form-control" placeholder="ex: Serveur ERP" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold">Type d'Actif (ISO)</label>
                    <select name="type" class="form-select">
                        <option value="Informationnel">Informationnel (Bases de données)</option>
                        <option value="Physique">Physique (Serveurs, Terminaux)</option>
                        <option value="Logiciel">Logiciel (Applications)</option>
                        <option value="Humain">Humain (Compétences clés)</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold">Propriétaire (Asset Owner)</label>
                    <input type="text" name="proprietaire" class="form-control" required>
                </div>

                <!-- Criticités avec Tooltips expliquant l'impact (EBIOS Atelier 1) -->
                <div class="col-md-4">
                    <label class="form-label small fw-bold text-danger">Besoins de Sécurité (DIC : 1 à 4)</label>
                    <div class="d-flex gap-2">
                        <div class="flex-grow-1">
                            <input type="number" name="confidentialite" class="form-control text-center" min="1" max="4" value="1" title="Confidentialité">
                            <small class="text-muted" style="font-size:0.6rem">Secret</small>
                        </div>
                        <div class="flex-grow-1">
                            <input type="number" name="integrite" class="form-control text-center" min="1" max="4" value="1" title="Intégrité">
                            <small class="text-muted" style="font-size:0.6rem">Exactitude</small>
                        </div>
                        <div class="flex-grow-1">
                            <input type="number" name="disponibilite" class="form-control text-center" min="1" max="4" value="1" title="Disponibilité">
                            <small class="text-muted" style="font-size:0.6rem">Service</small>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-bold">Périmètre d'application</label>
                    <select name="perimetreId" class="form-select" required>
                        <c:forEach var="p" items="${perimetres}">
                            <option value="${p.id}">${p.nom}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-12 text-end border-top pt-3">
                    <button type="submit" class="btn btn-iso px-4">ENREGISTRER L'ACTIF</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Tableau -->
    <div class="card border-0 shadow-sm overflow-hidden">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
            <tr>
                <th class="ps-4">Actif</th>
                <th>Type / Propriétaire</th>
                <th class="text-center">Criticités (C-I-D)</th>
                <th>Périmètre</th>
                <th class="text-end pe-4">Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="actif" items="${actifs}">
                <tr>
                    <td class="ps-4">
                        <div class="fw-bold">${actif.nom}</div>
                    </td>
                    <td>
                        <small class="text-uppercase text-muted fw-bold" style="font-size: 0.7rem;">${actif.type}</small>
                        <div class="small">${actif.proprietaire}</div>
                    </td>
                    <td class="text-center">
                        <span class="cid-badge ${actif.confidentialite == 3 ? 'bg-danger text-white' : 'bg-light border text-dark'}">${actif.confidentialite}</span>
                        <span class="cid-badge ${actif.integrite == 3 ? 'bg-danger text-white' : 'bg-light border text-dark'}">${actif.integrite}</span>
                        <span class="cid-badge ${actif.disponibilite == 3 ? 'bg-danger text-white' : 'bg-light border text-dark'}">${actif.disponibilite}</span>
                    </td>
                    <td><span class="badge bg-white text-dark border p-2 fw-normal">${actif.perimetre.nom}</span></td>
                    <td class="text-end pe-4">
                        <button class="btn btn-sm btn-outline-danger border-0"><i class="bi bi-trash"></i></button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>