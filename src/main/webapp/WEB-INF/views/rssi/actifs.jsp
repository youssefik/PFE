<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Inventaire du Patrimoine SMSI">

    <%-- Style spécifique au référentiel EBIOS / Inventaire --%>
    <style>
        .form-section-title {
            font-size: 0.7rem;
            font-weight: 800;
            color: #D2010D;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }

        /* Style de la table EBIOS */
        .table-ebios { font-size: 0.85rem; background-color: white; border: 1px solid #dee2e6; }
        .table-ebios thead th {
            background-color: #5D6D7E !important;
            color: white !important;
            text-align: center;
            vertical-align: middle !important;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.7rem;
            border: 1px solid rgba(255,255,255,0.2) !important;
        }
        .header-besoins { background-color: #D2010D !important; }
        .header-supports { background-color: #34495E !important; }

        .dic-cell { font-weight: 800; text-align: center; background-color: #fdf2f2 !important; width: 40px; }
        .support-cell { color: #555; font-size: 0.8rem; }
        .activity-tag { background: #eee; font-weight: 700; color: #333; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; }
    </style>

    <!-- FORMULAIRE D'AJOUT -->
    <div class="card card-outline card-danger shadow-sm mb-4">
        <div class="card-header">
            <h3 class="card-title font-weight-bold"><i class="fas fa-plus-square mr-2 text-danger"></i> Déclarer un Actif</h3>
        </div>
        <div class="card-body">
            <form action="/rssi/actifs/save" method="post">
                <div class="row">
                    <!-- SECTION METIER -->
                    <div class="col-12"><div class="form-section-title">Contexte Métier & Patrimoine</div></div>
                    <div class="col-md-2 form-group">
                        <label class="small font-weight-bold">Activité</label>
                        <input type="text" name="activite" class="form-control form-control-sm" placeholder="ex: DSI" required>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="small font-weight-bold">Processus</label>
                        <input type="text" name="processus" class="form-control form-control-sm" placeholder="ex: Facturation" required>
                    </div>
                    <div class="col-md-4 form-group">
                        <label class="small font-weight-bold">Actif Informationnel</label>
                        <input type="text" name="nom" class="form-control form-control-sm" placeholder="ex: Données RH" required>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="small font-weight-bold">Périmètre ISO</label>
                        <select name="perimetreId" class="form-control form-control-sm">
                            <c:forEach var="p" items="${perimetres}"><option value="${p.id}">${p.nom}</option></c:forEach>
                        </select>
                    </div>

                    <!-- SECTION BESOINS (DIC) -->
                    <div class="col-12 mt-2"><div class="form-section-title">Besoins de Sécurité (DIC)</div></div>
                    <div class="col-md-4">
                        <div class="row">
                            <div class="col-4 form-group">
                                <label class="small font-weight-bold">Dispo</label>
                                <input type="number" name="disponibilite" class="form-control form-control-sm text-center font-weight-bold" min="1" max="4" value="1">
                            </div>
                            <div class="col-4 form-group">
                                <label class="small font-weight-bold">Integ</label>
                                <input type="number" name="integrite" class="form-control form-control-sm text-center font-weight-bold" min="1" max="4" value="1">
                            </div>
                            <div class="col-4 form-group">
                                <label class="small font-weight-bold">Confid</label>
                                <input type="number" name="confidentialite" class="form-control form-control-sm text-center font-weight-bold" min="1" max="4" value="1">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8 form-group">
                        <label class="small font-weight-bold">Conséquence si violation (Événement Redouté)</label>
                        <input type="text" name="impact" class="form-control form-control-sm" placeholder="Impact sur les opérations...">
                    </div>

                    <!-- SECTION SUPPORTS -->
                    <div class="col-12 mt-2"><div class="form-section-title">Actifs Supports Associés</div></div>
                    <div class="col-md-2 form-group"><input type="text" name="logiciel" class="form-control form-control-sm" placeholder="Logiciel / Appli"></div>
                    <div class="col-md-2 form-group"><input type="text" name="materiel" class="form-control form-control-sm" placeholder="Serveur / Matériel"></div>
                    <div class="col-md-2 form-group"><input type="text" name="personnel" class="form-control form-control-sm" placeholder="Resp. Personnel"></div>
                    <div class="col-md-2 form-group"><input type="text" name="local" class="form-control form-control-sm" placeholder="Local / Zone"></div>
                    <div class="col-md-2 form-group"><input type="text" name="reseau" class="form-control form-control-sm" placeholder="VLAN / Zone Réseau"></div>

                    <div class="col-md-2 form-group">
                        <button type="submit" class="btn btn-danger btn-sm btn-block font-weight-bold elevation-1">
                            <i class="fas fa-save mr-1"></i> AJOUTER
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- TABLEAU RÉCAPITULATIF -->
    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered align-middle table-ebios mb-0">
                    <thead>
                    <tr>
                        <th rowspan="2">Activité</th>
                        <th rowspan="2">Processus</th>
                        <th rowspan="2" style="width: 200px;">Actif informationnel</th>
                        <th colspan="3" class="header-besoins">Besoins Sécu</th>
                        <th colspan="5" class="header-supports">Actif support</th>
                        <th rowspan="2">Conséquences Business</th>
                    </tr>
                    <tr>
                        <th class="header-besoins">D</th>
                        <th class="header-besoins">I</th>
                        <th class="header-besoins">C</th>
                        <th class="header-supports">Log.</th>
                        <th class="header-supports">Mat.</th>
                        <th class="header-supports">Pers.</th>
                        <th class="header-supports">Loc.</th>
                        <th class="header-supports">Rés.</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="a" items="${actifs}">
                        <tr>
                            <td class="text-center"><span class="activity-tag">${a.activite}</span></td>
                            <td class="font-weight-bold text-muted small">${a.processus}</td>
                            <td class="font-weight-bold text-dark">${a.nom}</td>

                            <td class="dic-cell text-danger">${a.disponibilite}</td>
                            <td class="dic-cell text-danger">${a.integrite}</td>
                            <td class="dic-cell text-danger">${a.confidentialite}</td>

                            <td class="support-cell">${a.logicielSupport}</td>
                            <td class="support-cell">${a.materielSupport}</td>
                            <td class="support-cell">${a.personnelSupport}</td>
                            <td class="support-cell">${a.localSupport}</td>
                            <td class="support-cell">${a.reseauSupport}</td>

                            <td class="small bg-light">
                                <c:choose>
                                    <c:when test="${not empty a.evenementRedoute}">
                                        <i class="fas fa-exclamation-triangle text-danger mr-1"></i> ${a.evenementRedoute}
                                    </c:when>
                                    <c:otherwise><span class="text-muted small">Non évalué</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <c:if test="${empty actifs}">
                <div class="p-5 text-center text-muted italic bg-white">
                    <i class="fas fa-search fa-3x mb-3 text-light"></i><br>
                    L'inventaire est actuellement vide pour ce périmètre.
                </div>
            </c:if>
        </div>
    </div>
</t:layout>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inventaire du Patrimoine SMSI | Corporate Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; --iso-gray: #F4F4F4; }
        body { background-color: var(--iso-gray); font-family: 'Inter', sans-serif; color: var(--iso-dark); }

        .navbar { border-bottom: 3px solid var(--iso-red); background-color: white !important; }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; margin-bottom: 2rem; }

        /* Style des cartes */
        .iso-card { border-radius: 8px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .form-section-title { font-size: 0.75rem; font-weight: 800; color: var(--iso-red); text-transform: uppercase; letter-spacing: 1px; border-bottom: 1px solid #ddd; padding-bottom: 5px; margin-bottom: 15px; }

        /* Style de la table calqué sur l'Excel */
        .table-ebios { border: 1px solid #ddd; font-size: 0.85rem; background-color: white; }
        .table-ebios thead th {
            background-color: #5D6D7E !important; color: white !important;
            text-align: center; vertical-align: middle;
            font-weight: 600; text-transform: uppercase; font-size: 0.7rem;
            border: 1px solid #ffffff33 !important;
        }
        .header-besoins { background-color: var(--iso-red) !important; }
        .header-supports { background-color: #34495E !important; }

        .dic-cell { font-weight: 800; text-align: center; background-color: #FDF2F2 !important; width: 40px; }
        .support-cell { color: #666; font-size: 0.8rem; }
        .activity-tag { background: #eee; font-weight: 700; color: #333; padding: 2px 8px; border-radius: 4px; }

        .btn-iso { background-color: var(--iso-red); color: white; font-weight: bold; border-radius: 4px; transition: 0.3s; }
        .btn-iso:hover { background-color: #a8010a; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(210, 1, 13, 0.2); }
    </style>
</head>
<body class="py-4">

<nav class="navbar navbar-light bg-white sticky-top mb-4 shadow-sm">
    <div class="container-fluid px-5">
        <div class="d-flex align-items-center">
            <div class="bg-danger text-white px-3 py-1 fw-bold me-3 rounded shadow-sm">ISO</div>
            <span class="fw-bold text-dark text-uppercase tracking-wider">Asset Management (EBIOS RM)</span>
        </div>
        <a href="/dashboard" class="btn btn-outline-dark btn-sm fw-bold">RETOUR DASHBOARD</a>
    </div>
</nav>

<main class="container-fluid px-5">

    <div class="page-header">
        <h2 class="fw-bold m-0 uppercase">Inventaire et Classification des Actifs</h2>
        <p class="text-muted">Analyse de la relation entre Processus Métier et Actifs Supports</p>
    </div>

    <!-- FORMULAIRE D'AJOUT COMPLEXE -->
    <div class="card iso-card mb-5">
        <div class="card-body p-4">
            <form action="/rssi/actifs/save" method="post">
                <div class="row g-3">
                    <!-- SECTION METIER -->
                    <div class="col-md-12"><div class="form-section-title">Contexte Métier & Patrimoine</div></div>
                    <div class="col-md-2">
                        <label class="form-label small fw-bold">Activité</label>
                        <input type="text" name="activite" class="form-control form-control-sm" placeholder="ex: DSP" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-bold">Processus</label>
                        <input type="text" name="processus" class="form-control form-control-sm" placeholder="ex: Prestation Client" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-bold">Actif Informationnel</label>
                        <input type="text" name="nom" class="form-control form-control-sm" placeholder="ex: Données clients" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-bold">Périmètre</label>
                        <select name="perimetreId" class="form-select form-select-sm">
                            <c:forEach var="p" items="${perimetres}"><option value="${p.id}">${p.nom}</option></c:forEach>
                        </select>
                    </div>

                    <!-- SECTION BESOINS -->
                    <div class="col-md-12 mt-4"><div class="form-section-title">Besoins de Sécurité (Impact cas de non respect)</div></div>
                    <div class="col-md-4">
                        <div class="d-flex gap-2">
                            <div class="flex-grow-1">
                                <label class="small fw-bold">Dispo (D)</label>
                                <input type="number" name="disponibilite" class="form-control form-control-sm text-center" min="1" max="4" value="1">
                            </div>
                            <div class="flex-grow-1">
                                <label class="small fw-bold">Integ (I)</label>
                                <input type="number" name="integrite" class="form-control form-control-sm text-center" min="1" max="4" value="1">
                            </div>
                            <div class="flex-grow-1">
                                <label class="small fw-bold">Confid (C)</label>
                                <input type="number" name="confidentialite" class="form-control form-control-sm text-center" min="1" max="4" value="1">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <label class="form-label small fw-bold">Évènement redouté (Impact Business)</label>
                        <input type="text" name="impact" class="form-control form-control-sm" placeholder="ex: Une divulgation pourrait entrainer une perte d'image...">
                    </div>

                    <!-- SECTION SUPPORTS -->
                    <div class="col-md-12 mt-4"><div class="form-section-title">Description des Actifs Supports</div></div>
                    <div class="col-md-2">
                        <input type="text" name="logiciel" class="form-control form-control-sm" placeholder="Logiciel (ex: SIEM)">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="materiel" class="form-control form-control-sm" placeholder="Matériel (ex: Serveur)">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="personnel" class="form-control form-control-sm" placeholder="Personnel">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="local" class="form-control form-control-sm" placeholder="Localisation">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="reseau" class="form-control form-control-sm" placeholder="Réseau (Vlan)">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-iso btn-sm w-100 fw-bold">AJOUTER</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- TABLEAU RÉCAPITULATIF (DYNAMIQUE) -->
    <div class="card border-0 shadow-sm overflow-hidden">
        <div class="table-responsive">
            <table class="table table-bordered align-middle table-ebios mb-0">
                <thead>
                <tr>
                    <th rowspan="2">Activité</th>
                    <th rowspan="2">Processus</th>
                    <th rowspan="2">Actif informationnel</th>
                    <th colspan="3" class="header-besoins">Besoin de sécurité</th>
                    <th colspan="5" class="header-supports">Actif support</th>
                    <th rowspan="2">Évènement redouté</th>
                </tr>
                <tr>
                    <th class="header-besoins">D</th>
                    <th class="header-besoins">I</th>
                    <th class="header-besoins">C</th>
                    <th class="header-supports">Logiciel</th>
                    <th class="header-supports">Matériel</th>
                    <th class="header-supports">Pers.</th>
                    <th class="header-supports">Local</th>
                    <th class="header-supports">Réseau</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="a" items="${actifs}">
                    <tr>
                        <td class="text-center"><span class="activity-tag">${a.activite}</span></td>
                        <td class="fw-bold text-muted">${a.processus}</td>
                        <td class="fw-bold text-dark">${a.nom}</td>

                        <!-- DIC -->
                        <td class="dic-cell text-danger">${a.disponibilite}</td>
                        <td class="dic-cell text-danger">${a.integrite}</td>
                        <td class="dic-cell text-danger">${a.confidentialite}</td>

                        <!-- Supports -->
                        <td class="support-cell">${a.logicielSupport}</td>
                        <td class="support-cell">${a.materielSupport}</td>
                        <td class="support-cell">${a.personnelSupport}</td>
                        <td class="support-cell">${a.localSupport}</td>
                        <td class="support-cell">${a.reseauSupport}</td>

                        <td class="small p-3 bg-light" style="max-width: 300px; line-height: 1.4">
                            <c:choose>
                                <c:when test="${not empty a.evenementRedoute}">
                                    <i class="bi bi-exclamation-triangle-fill text-danger me-1"></i> ${a.evenementRedoute}
                                </c:when>
                                <c:otherwise><span class="text-muted small">Aucun impact renseigné</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty actifs}">
                    <tr>
                        <td colspan="12" class="text-center py-5 text-muted italic">
                            <i class="bi bi-folder-x fs-2 d-block mb-2"></i>
                            L'inventaire est actuellement vide. Veuillez charger le fichier Excel ou saisir manuellement.
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

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inventaire des Actifs | ISO 27005 & EBIOS RM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; }
        body { background-color: #f4f4f4; font-family: 'Inter', sans-serif; }
        .page-header { border-left: 5px solid var(--iso-red); padding-left: 15px; margin-bottom: 2rem; }
        .iso-card { border-top: 4px solid var(--iso-red); border-radius: 8px; border:none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }

        /* Table Style image Excel */
        .table-custom thead th {
            background-color: #5d6d7e; color: white;
            font-size: 0.75rem; text-transform: uppercase;
            text-align: center; border: 1px solid #ffffff33;
        }
        .header-besoins { background-color: #D2010D !important; } /* Rouge pour D-I-C */
        .header-supports { background-color: #34495e !important; }

        .badge-dic { width: 25px; height: 25px; line-height: 25px; display: inline-block; border-radius: 4px; font-weight: bold; font-size: 0.7rem; }
        .small-txt { font-size: 0.75rem; line-height: 1.2; }
    </style>
</head>
<body class="py-4">

<main class="container-fluid px-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="page-header">
            <h2 class="fw-bold m-0 uppercase">Inventaire du Patrimoine</h2>
            <small class="text-muted">Liaison Processus Métier / Actifs Supports (Haut Niveau)</small>
        </div>
        <a href="/dashboard" class="btn btn-dark btn-sm fw-bold">RETOUR</a>
    </div>

    <!-- Formulaire d'ajout rapide -->
    <div class="card iso-card mb-5 shadow-sm">
        <div class="card-body p-4">
            <form action="/rssi/actifs/save" method="post" class="row g-3">
                <div class="col-md-2">
                    <label class="form-label small fw-bold">Activité</label>
                    <input type="text" name="activite" class="form-control form-control-sm" placeholder="ex: DSP" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold">Processus</label>
                    <input type="text" name="processus" class="form-control form-control-sm" placeholder="ex: Prestation" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold">Actif Informationnel</label>
                    <input type="text" name="nom" class="form-control form-control-sm" placeholder="Nom de l'actif" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold">Besoins (D-I-C)</label>
                    <div class="d-flex gap-1">
                        <input type="number" name="disponibilite" class="form-control form-control-sm text-center" min="1" max="4" value="1">
                        <input type="number" name="integrite" class="form-control form-control-sm text-center" min="1" max="4" value="1">
                        <input type="number" name="confidentialite" class="form-control form-control-sm text-center" min="1" max="4" value="1">
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold">Périmètre</label>
                    <select name="perimetreId" class="form-select form-select-sm">
                        <c:forEach var="p" items="${perimetres}"><option value="${p.id}">${p.nom}</option></c:forEach>
                    </select>
                </div>

                <!-- Supports -->
                <div class="col-md-2"><input type="text" name="logiciel" class="form-control form-control-sm" placeholder="Logiciel"></div>
                <div class="col-md-2"><input type="text" name="materiel" class="form-control form-control-sm" placeholder="Matériel"></div>
                <div class="col-md-2"><input type="text" name="personnel" class="form-control form-control-sm" placeholder="Personnel"></div>
                <div class="col-md-3"><input type="text" name="impact" class="form-control form-control-sm" placeholder="Evènement redouté (Impact)"></div>

                <div class="col-md-3">
                    <button type="submit" class="btn btn-danger btn-sm w-100 fw-bold shadow-sm">AJOUTER À LA CARTOGRAPHIE</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Tableau type Excel Haut Niveau -->
    <div class="card border-0 shadow-sm overflow-hidden">
        <table class="table table-bordered align-middle table-custom mb-0">
            <thead>
            <tr>
                <th rowspan="2" class="align-middle">Activité</th>
                <th rowspan="2" class="align-middle">Processus</th>
                <th rowspan="2" class="align-middle">Actif Informationnel</th>
                <th colspan="3" class="header-besoins">Besoins de Sécurité</th>
                <th colspan="5" class="header-supports">Actifs Supports</th>
                <th rowspan="2" class="align-middle">Evènement Redouté</th>
            </tr>
            <tr>
                <th class="header-besoins small">D</th>
                <th class="header-besoins small">I</th>
                <th class="header-besoins small">C</th>
                <th class="header-supports small">Logiciel</th>
                <th class="header-supports small">Matériel</th>
                <th class="header-supports small">Pers.</th>
                <th class="header-supports small">Local</th>
                <th class="header-supports small">Réseau</th>
            </tr>
            </thead>
            <tbody class="bg-white">
            <c:forEach var="a" items="${actifs}">
                <tr class="small-txt">
                    <td class="fw-bold text-center">${a.activite}</td>
                    <td>${a.processus}</td>
                    <td class="fw-bold">${a.nom}</td>

                    <!-- DIC -->
                    <td class="text-center fw-bold bg-light">${a.disponibilite}</td>
                    <td class="text-center fw-bold bg-light">${a.integrite}</td>
                    <td class="text-center fw-bold bg-light">${a.confidentialite}</td>

                    <!-- Supports -->
                    <td class="text-muted">${a.logicielSupport}</td>
                    <td class="text-muted">${a.materielSupport}</td>
                    <td class="text-muted">${a.personnelSupport}</td>
                    <td class="text-muted">${a.localSupport}</td>
                    <td class="text-muted">${a.reseauSupport}</td>

                    <td class="small italic text-danger">${a.evenementRedoute}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>--%>
