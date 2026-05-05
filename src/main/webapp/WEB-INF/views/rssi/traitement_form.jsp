<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Stratégie de Traitement">

    <style>
        .risk-summary-box {
            background-color: #f8f9fa;
            border-left: 5px solid #D2010D;
            border-radius: 4px;
            padding: 20px;
        }
        .form-label-pro {
            font-weight: 700;
            color: #495057;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            display: block;
            margin-bottom: 8px;
        }
    </style>

    <div class="row justify-content-center">
        <div class="col-lg-9">

            <div class="card card-outline card-danger shadow-lg">
                <div class="card-header">
                    <h3 class="card-title font-weight-bold">
                        <i class="fas fa-shield-alt mr-2 text-danger"></i> Définition du Plan de Traitement
                    </h3>
                    <div class="card-tools">
                        <a href="/rssi/risques" class="btn btn-tool"><i class="fas fa-times"></i></a>
                    </div>
                </div>

                <div class="card-body">
                    <!-- Rappel du risque Brut -->
                    <div class="risk-summary-box mb-4 shadow-sm">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <span class="form-label-pro text-muted">Scénario sous évaluation :</span>
                                <h5 class="font-weight-bold text-dark mb-0">${risque.scenariosRisque}</h5>
                            </div>
                            <div class="col-md-4 text-md-right mt-3 mt-md-0">
                                <span class="badge ${risque.couleurStyle} px-3 py-2 text-lg elevation-1">
                                    SCORE INITIAL : ${risque.niveauRisqueInitial}
                                </span>
                            </div>
                        </div>
                    </div>

                    <form action="/rssi/risques/traiter/save" method="post">
                        <input type="hidden" name="risqueId" value="${risque.id}">

                        <div class="row">
                            <!-- Option de traitement -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label-pro">Option Stratégique (ISO 27005)</label>
                                    <select name="strategie" class="form-control select2 shadow-sm" required style="border-width: 2px;">
                                        <option value="Reduire">🛡️ RÉDUCTION (Mesures de sécurité)</option>
                                        <option value="Transferer">🤝 TRANSFERT (Assurance / Outsource)</option>
                                        <option value="Eviter">🚫 ÉVITEMENT (Suppression de l'activité)</option>
                                        <option value="Accepter">📝 ACCEPTATION (Dérogation Direction)</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Efficacité -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label-pro">Efficacité attendue (Estimation %)</label>
                                    <div class="input-group shadow-sm">
                                        <input type="number" name="efficaciteAttendue" class="form-control" min="1" max="99" value="50" style="border-width: 2px;">
                                        <div class="input-group-append">
                                            <span class="input-group-text bg-white"><strong>% de réduction</strong></span>
                                        </div>
                                    </div>
                                    <small class="text-muted italic">Ce taux réduit mathématiquement le risque résiduel cible.</small>
                                </div>
                            </div>
                        </div>

                        <!-- Plan d'action détaillé -->
                        <div class="form-group mt-3">
                            <label class="form-label-pro">Plan d'Actions & Mesures Correctives</label>
                            <textarea name="planTraitement" class="form-control shadow-sm" rows="5" style="border-width: 2px;"
                                      placeholder="Listez les contrôles techniques ou organisationnels à déployer (ex: A.8.12 Sauvegardes redondantes, A.5.15 Chiffrement des données sensibles...)" required></textarea>
                        </div>

                        <div class="mt-5 border-top pt-4">
                            <div class="row">
                                <div class="col-md-4">
                                    <a href="/rssi/risques" class="btn btn-default btn-block">ANNULER</a>
                                </div>
                                <div class="col-md-8">
                                    <button type="submit" class="btn btn-danger btn-block font-weight-bold elevation-2">
                                        <i class="fas fa-check-circle mr-2"></i> ENREGISTRER LE PLAN DE TRAITEMENT
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Footer pédagogique ISO -->
            <div class="text-center mt-4 mb-5">
                <div class="callout callout-info bg-white d-inline-block text-left py-2 px-4 shadow-sm" style="border-left-color: #17a2b8 !important;">
                    <small class="text-muted">
                        <i class="fas fa-info-circle mr-1 text-info"></i>
                        Conformité <strong>ISO 27001</strong> : La sélection des mesures doit être documentée dans la déclaration d'applicabilité (SoA).
                    </small>
                </div>
            </div>

        </div>
    </div>

</t:layout>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Plan de Traitement | ISO 27001</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #D2010D; --iso-dark: #212121; }
        body { background-color: #f4f4f4; font-family: 'Inter', sans-serif; }

        /* Barre supérieure rouge style ISO */
        .iso-header-red { border-top: 8px solid var(--iso-red); border-radius: 4px; }

        .form-label { font-weight: 700; color: #555; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; }

        /* Bouton Rouge ISO */
        .btn-save {
            background-color: var(--iso-red);
            color: white;
            font-weight: 800;
            padding: 15px;
            border: none;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: 0.3s;
        }
        .btn-save:hover { background-color: var(--iso-dark); color: white; transform: translateY(-2px); }

        .risk-info-box { background-color: #f8f9fa; border: 1px solid #eee; border-radius: 4px; }

        .badge-score { padding: 12px 20px; font-size: 1.1rem; font-weight: 800; border-radius: 4px; }
    </style>
</head>
<body class="py-5">

<div class="container">
    <div class="card shadow-lg border-0 iso-header-red mx-auto" style="max-width: 850px;">

        <div class="card-body p-5">
            <h2 class="fw-bold text-uppercase border-bottom pb-3">Stratégie de Traitement du Risque</h2>

            <div class="risk-info-box p-4 my-4 bg-light border-start border-5 border-danger">
                <div class="row">
                    <div class="col-md-6">
                        <small class="fw-bold text-muted">SCÉNARIO IDENTIFIÉ :</small>
                        <p class="mb-0">${risque.scenariosRisque}</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <span class="badge ${risque.couleurStyle} p-3 fs-6">BRUT : ${risque.niveauRisqueInitial}</span>
                    </div>
                </div>
            </div>

            <form action="/rssi/risques/traiter/save" method="post">
                <input type="hidden" name="risqueId" value="${risque.id}">

                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label">Option de Traitement (ISO 27005)</label>
                        <select name="strategie" class="form-select border-2" required>
                            <option value="Reduire">RÉDUCTION (Mesures de sécurité)</option>
                            <option value="Transferer">TRANSFERT (Assurance / Outsource)</option>
                            <option value="Eviter">ÉVITEMENT (Suppression activité)</option>
                            <option value="Accepter">ACCEPTATION (Accord Direction)</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Efficacité attendue des mesures (%)</label>
                        <div class="input-group">
                            <input type="number" name="efficaciteAttendue" class="form-control border-2" min="1" max="95" value="50">
                            <span class="input-group-text">% de réduction</span>
                        </div>
                        <small class="text-muted">Sert au calcul du risque résiduel cible.</small>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Plan d'Actions de l'Annexe A (Mesures concrètes)</label>
                    <textarea name="planTraitement" class="form-control border-2" rows="4"
                              placeholder="Décrivez les mesures techniques (ex: A.8.12 Sauvegardes, A.5.15 Authentification...)" required></textarea>
                </div>

                <button type="submit" class="btn btn-save w-100 py-3 shadow-lg">
                    VALIDER LE PLAN DE TRAITEMENT
                </button>
            </form>
        </div>
    </div>

    <div class="text-center mt-4 text-muted">
        <small><i class="bi bi-info-circle me-1"></i> Ce formulaire génère l'historique de traitement pour l'audit de certification.</small>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>--%>

<%--
&lt;%&ndash;
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Traitement du Risque - SMSI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .risk-header {
            background: ${risque.score >= 15 ? '#dc3545' : (risque.score >= 8 ? '#ffc107' : '#198754')};
            color: ${risque.score >= 8 && risque.score < 15 ? 'black' : 'white'};
        }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand"><i class="bi bi-shield-fill-exclamation"></i> Traitement des Risques</span>
        <a href="/rssi/risques" class="btn btn-outline-light btn-sm">Annuler</a>
    </div>
</nav>

<div class="container mt-5">
    <div class="card shadow-lg mx-auto" style="max-width: 700px; border: none;">
        <div class="card-header risk-header p-4">
            <h4 class="mb-0"><i class="bi bi-hammer"></i> Plan de traitement</h4>
            <small>Menace : ${risque.menace}</small>
        </div>

        <div class="card-body p-4">
            <!-- Rappel du contexte du risque -->
            <div class="row mb-4 text-center">
                <div class="col-6 border-end">
                    <label class="text-muted small d-block">Actif impacté</label>
                    <strong>${risque.actif.nom}</strong>
                </div>
                <div class="col-6">
                    <label class="text-muted small d-block">Score de risque</label>
                    <span class="badge ${risque.score >= 15 ? 'bg-danger' : (risque.score >= 8 ? 'bg-warning text-dark' : 'bg-success')}">
                        ${risque.score} / 25
                    </span>
                </div>
            </div>

            <hr>

            <form action="/rssi/risques/traiter/save" method="post">
                <input type="hidden" name="risqueId" value="${risque.id}">

                <div class="mb-4">
                    <label class="form-label fw-bold"><i class="bi bi-diagram-3"></i> Stratégie ISO 27001</label>
                    <select name="strategie" class="form-select form-select-lg" required>
                        <option value="Reduire">🛡️ Réduire (Mettre en place des contrôles)</option>
                        <option value="Accepter">🤝 Accepter (Risque résiduel validé)</option>
                        <option value="Transferer">🔄 Transférer (Assurance / Sous-traitant)</option>
                        <option value="Eviter">🚫 Éviter (Supprimer l'activité à risque)</option>
                    </select>
                    <div class="form-text text-muted">Choisissez la méthode de traitement conforme à la clause 6.1.3.</div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold"><i class="bi bi-list-task"></i> Plan d'actions détaillé</label>
                    <textarea name="planTraitement" class="form-control" rows="5"
                              placeholder="Quelles mesures techniques ou organisationnelles vont être prises ?" required></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold"><i class="bi bi-calendar-event"></i> Date cible de fin</label>
                    <input type="date" name="dateCible" class="form-control" required>
                </div>

                <div class="d-grid gap-2 mt-5">
                    <button type="submit" class="btn btn-success btn-lg shadow-sm">
                        <i class="bi bi-check-circle"></i> Valider et enregistrer le plan
                    </button>
                    <a href="/rssi/risques" class="btn btn-link text-muted">Retourner à la liste sans enregistrer</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>&ndash;%&gt;

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Plan de Traitement | ISO 27001</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #D2010D; }
        body { background-color: #f4f4f4; }
        .iso-header-red { border-top: 8px solid var(--iso-red); }
        .strategy-card { border: 2px solid #eee; transition: 0.3s; cursor: pointer; }
        .form-label { font-weight: 700; color: #555; text-transform: uppercase; font-size: 0.8rem; }
        .btn-save { background-color: var(--iso-red); color: white; font-weight: 800; padding: 12px; border: none; }
    </style>
</head>
<body class="py-5">

<div class="container">
    <div class="card shadow-lg border-0 iso-header-red mx-auto" style="max-width: 850px;">
        <div class="card-body p-5">
            <div class="d-flex justify-content-between align-items-start mb-5">
                <div>
                    <h2 class="fw-bold text-uppercase">Traitement du Risque</h2>
                    <p class="text-muted">Élaboration du Plan de Traitement (PTR)</p>
                </div>
                <div class="text-end">
                    <span class="badge ${risque.score >= 15 ? 'bg-danger' : (risque.score >= 8 ? 'bg-warning text-dark' : 'bg-success')} p-3 fs-5">
                        SCORE : ${risque.score}
                    </span>
                </div>
            </div>

            <div class="bg-light p-3 rounded mb-5 d-flex gap-4">
                <div><small class="d-block text-muted">ACTIF IMPACTÉ</small><strong>${risque.actif.nom}</strong></div>
                <div><small class="d-block text-muted">MENACE DÉTECTÉE</small><strong>${risque.menace}</strong></div>
            </div>

            <form action="/rssi/risques/traiter/save" method="post">
                <input type="hidden" name="risqueId" value="${risque.id}">

                <div class="row mb-4">
                    <div class="col-md-12">
                        <label class="form-label">Option de traitement (6.1.3)</label>
                        <select name="strategie" class="form-select form-select-lg" required>
                            <option value="Reduire">Réduire (Mettre en place des mesures de sécurité)</option>
                            <option value="Accepter">Accepter (Validation formelle par la direction)</option>
                            <option value="Transferer">Transférer (Assurance, externalisation)</option>
                            <option value="Eviter">Éviter (Suppression de l'actif ou de l'activité)</option>
                        </select>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Actions de remédiation détaillées</label>
                    <textarea name="planTraitement" class="form-control" rows="4" placeholder="Décrivez les mesures techniques (ex: pare-feu) ou organisationnelles (ex: formation)..." required></textarea>
                </div>

                <div class="row mb-5">
                    <div class="col-md-6">
                        <label class="form-label">Date limite d'application</label>
                        <input type="date" name="dateCible" class="form-control" required>
                    </div>
                </div>

                <div class="d-flex gap-3">
                    <button type="submit" class="btn btn-save flex-grow-1">VALIDER LE PLAN DE TRAITEMENT</button>
                    <a href="/rssi/risques" class="btn btn-light px-4 py-3 fw-bold">ANNULER</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
--%>
