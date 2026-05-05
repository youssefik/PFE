<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Actions Correctives & Amélioration">

    <div class="nc-page"> <%-- Wrapper pour isoler le CSS --%>
        <style>
            .nc-page .section-header { border-left: 6px solid #d2010d; padding-left: 1rem; margin-bottom: 2rem; }
            .nc-page .nc-card { border: none; border-radius: 8px; transition: 0.3s; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }

            /* Isolation ciblée des onglets de contenu */
            .nc-page .nav-pills .nav-link {
                color: #495057; font-weight: 600; background-color: #fff; margin-right: 10px; border: 1px solid #dee2e6;
            }
            .nc-page .nav-pills .nav-link.active {
                background-color: #d2010d !important; color: white !important;
            }
        </style>

        <div class="section-header mt-2">
            <p class="text-muted">Gestion du plan d'action correctives suite aux audits (Clause 10.2).</p>
        </div>

        <ul class="nav nav-pills mb-4" id="actionTabs" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" data-toggle="pill" href="#tabClauses">
                    <i class="fas fa-file-alt mr-2"></i> Exigences Clauses
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="pill" href="#tabAnnexe">
                    <i class="fas fa-shield-alt mr-2"></i> Mesures Annexe A
                </a>
            </li>
        </ul>

        <div class="tab-content" id="actionTabsContent">
            <%-- Contenu de vos onglets --%>
            <div class="tab-pane fade show active" id="tabClauses" role="tabpanel">
                 <%-- Tableaux ici... --%>
                 <div class="row">
                    <c:forEach var="nc" items="${ncsClauses}">
                        <c:set var="currentNC" value="${nc}" scope="request" />
                        <c:set var="ncColor" value="primary" scope="request" />
                        <c:set var="targetPoint" value="${nc.constat.clauseIso.code}" scope="request" />
                        <div class="col-md-6 mb-3">
                            <%@ include file="includes/nc_card_template.jsp" %>
                        </div>
                    </c:forEach>
                 </div>
            </div>
            <%-- Reste du contenu identique... --%>
        </div>
    </div>

    <%-- Le script IA --%>
    <script>
                function askOllama(btn) {
            const id = btn.getAttribute('data-id');
            const description = btn.getAttribute('data-desc');
            const code = btn.getAttribute('data-code');
            const textarea = document.getElementById('cause_' + id);

            textarea.value = "⚡ Analyse par l'IA en cours...";
            textarea.disabled = true;
            btn.disabled = true;

            fetch('/api/ai/suggest-nc', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ desc: description, code: code })
            })
            .then(response => {
                if (!response.ok) throw new Error('Erreur serveur ' + response.status);
                return response.text();
            })
            .then(data => {
                textarea.value = data;
                textarea.disabled = false;
                btn.disabled = false;
            })
            .catch(error => {
                console.error('Erreur Ollama:', error);
                textarea.value = "❌ Erreur IA. Détails : " + error.message;
                textarea.disabled = false;
                btn.disabled = false;
            });
        }

    </script>
</t:layout>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Actions Correctives & Amélioration">

    &lt;%&ndash; Styles spécifiques pour le métier des Non-Conformités &ndash;%&gt;
    <style>
        .section-header { border-left: 6px solid #d2010d; padding-left: 1rem; margin-bottom: 2rem; }
        .nc-card { border: none; border-radius: 8px; transition: 0.3s; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .nav-pills .nav-link { color: #495057; font-weight: 600; background-color: #fff; margin-right: 10px; border: 1px solid #dee2e6; }
        .nav-pills .nav-link.active { background-color: #d2010d !important; color: white !important; }
        .ai-assist-box { background-color: #f1f5f9; border-radius: 12px; padding: 15px; border: 1px dashed #cbd5e1; }
    </style>

    <div class="section-header">
        <h2 class="font-weight-bold">Suivi des Non-Conformités (Clause 10.2)</h2>
        <p class="text-muted">Gestion du plan d'action correctives suite aux audits et contrôles.</p>
    </div>

    <!-- Navigation par Onglets (BS4 style) -->
    <ul class="nav nav-pills mb-4" id="actionTabs" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="tab-clauses-link" data-toggle="pill" href="#tabClauses" role="tab">
                <i class="fas fa-file-alt mr-2"></i> Exigences Clauses (4-10)
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-annexe-link" data-toggle="pill" href="#tabAnnexe" role="tab">
                <i class="fas fa-shield-alt mr-2"></i> Mesures Annexe A
            </a>
        </li>
    </ul>

    <div class="tab-content" id="actionTabsContent">

        <!-- ================= ONGLET CLAUSES 4-10 ================= -->
        <div class="tab-pane fade show active" id="tabClauses" role="tabpanel">

            <!-- Table des constats en attente -->
            <div class="card card-outline card-secondary shadow-sm">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-clock mr-2"></i>Constats Clauses en attente d'ouverture</h3>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover table-valign-middle mb-0">
                        <thead class="bg-light">
                            <tr><th class="pl-4">Verdict</th><th>Exigence</th><th>Observation</th><th class="text-center">Action</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ct" items="${constatsClausesPending}">
                            <tr>
                                <td class="pl-4">
                                    <span class="badge ${ct.type.contains('Majeur') ? 'badge-danger' : 'badge-warning'}">${ct.type}</span>
                                </td>
                                <td><strong>${ct.clauseIso.code}</strong></td>
                                <td class="small text-muted text-truncate" style="max-width: 300px;">${ct.description}</td>
                                <td class="text-center">
                                    <button class="btn btn-xs btn-dark shadow-sm" data-toggle="modal" data-target="#modalNC${ct.id}">Ouvrir une NC</button>
                                </td>
                            </tr>
                            <c:set var="currentConstat" value="${ct}" scope="request"/>
                            <jsp:include page="includes/modal_nc.jsp" />
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <h5 class="mt-4 mb-3 font-weight-bold text-dark"><i class="fas fa-tasks mr-2"></i>NC Ouvertes (Plan d'action en cours)</h5>
            <div class="row">
                <c:forEach var="nc" items="${ncsClauses}">
                    <c:set var="currentNC" value="${nc}" scope="request" />
                    <c:set var="ncColor" value="primary" scope="request" />
                    <c:set var="targetPoint" value="${nc.constat.clauseIso.code}" scope="request" />
                    <div class="col-md-6 mb-3">
                        <%@ include file="includes/nc_card_template.jsp" %>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- ================= ONGLET ANNEXE A ================= -->
        <div class="tab-pane fade" id="tabAnnexe" role="tabpanel">

            <div class="card card-outline card-danger shadow-sm">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-exclamation-triangle mr-2"></i>Faiblesses techniques détectées</h3>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover table-valign-middle mb-0">
                        <thead class="bg-light">
                            <tr><th class="pl-4">Maturité</th><th>Contrôle</th><th>Écart</th><th class="text-center">Action</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ct" items="${constatsAnnexePending}">
                            <tr>
                                <td class="pl-4"><span class="badge badge-danger">${ct.niveauMaturite}</span></td>
                                <td><strong>${ct.controle.code}</strong></td>
                                <td class="small text-muted">${ct.description}</td>
                                <td class="text-center">
                                    <button class="btn btn-xs btn-danger" data-toggle="modal" data-target="#modalNC${ct.id}">Traiter l'écart</button>
                                </td>
                            </tr>
                            <c:set var="currentConstat" value="${ct}" scope="request"/>
                            <jsp:include page="includes/modal_nc.jsp" />
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <h5 class="mt-4 mb-3 font-weight-bold text-danger"><i class="fas fa-tools mr-2"></i>Remédiations Annexe A</h5>
            <div class="row">
                <c:forEach var="nc" items="${ncsAnnexe}">
                    <c:set var="currentNC" value="${nc}" scope="request" />
                    <c:set var="ncColor" value="danger" scope="request" />
                    <c:set var="targetPoint" value="${nc.constat.controle.code}" scope="request" />
                    <div class="col-md-6 mb-3">
                        <%@ include file="includes/nc_card_template.jsp" %>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- IA ASSIST SCRIPT (Ollama Integration) -->
    <script>
        function askOllama(btn) {
            const id = btn.getAttribute('data-id');
            const description = btn.getAttribute('data-desc');
            const code = btn.getAttribute('data-code');
            const textarea = document.getElementById('cause_' + id);

            textarea.value = "⚡ Analyse par l'IA en cours...";
            textarea.disabled = true;
            btn.disabled = true;

            fetch('/api/ai/suggest-nc', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ desc: description, code: code })
            })
            .then(response => {
                if (!response.ok) throw new Error('Erreur serveur ' + response.status);
                return response.text();
            })
            .then(data => {
                textarea.value = data;
                textarea.disabled = false;
                btn.disabled = false;
            })
            .catch(error => {
                console.error('Erreur Ollama:', error);
                textarea.value = "❌ Erreur IA. Détails : " + error.message;
                textarea.disabled = false;
                btn.disabled = false;
            });
        }
    </script>

</t:layout>--%>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Actions Correctives - ISO 27001</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root { --iso-red: #dc3545; --iso-dark: #1e293b; --iso-gray: #f8f9fc; }
        body { background-color: var(--iso-gray); font-family: 'Inter', sans-serif; }

        .section-header { border-left: 6px solid var(--iso-red); padding-left: 1rem; margin-bottom: 2rem; }
        .nc-card { border: none; border-radius: 16px; transition: 0.3s; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .nav-pills .nav-link.active { background-color: var(--iso-red); }
        .nav-pills .nav-link { color: var(--iso-dark); font-weight: 600; border: 1px solid #dee2e6; margin-right: 10px; }

        /* Badges de sévérité */
        .badge-nc-majeur { background-color: #7f1d1d; color: #fecaca; }
        .badge-nc-mineur { background-color: #fef3c7; color: #92400e; }

        .ai-assist-box { background-color: #f1f5f9; border-radius: 12px; padding: 15px; border: 1px dashed #cbd5e1; }

        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
        }
    </style>
</head>
<body class="">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container">
            <span class="navbar-brand fw-bold">
                <i class="bi bi-arrow-repeat text-info me-2"></i> Actions Correctives (ACT)
            </span>
        <a href="/dashboard" class="btn btn-outline-light btn-sm">Retour Dashboard</a>
    </div>
</nav>

<div class="container pb-5">
    <div class="section-header">
        <h2 class="fw-bold">Suivi des Non-Conformités</h2>
        <p class="text-muted">Gestion du plan d'amélioration continue selon la Clause 10.2</p>
    </div>

    <!-- Navigation par Source -->
    <ul class="nav nav-pills mb-4 justify-content-center" id="actionTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabClauses"><i class="bi bi-file-earmark-text"></i> Exigences Clauses (4-10)</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabAnnexe"><i class="bi bi-shield-lock"></i> Mesures Annexe A</button>
        </li>
    </ul>

    <div class="tab-content">
        <!-- ================= ONGLET CLAUSES 4-10 ================= -->
        <div class="tab-pane fade show active" id="tabClauses">

            <h5 class="fw-bold mb-3 mt-4 text-secondary"><i class="bi bi-clock-history"></i> Constats sur clauses en attente</h5>
            <div class="card mb-5 border-0 shadow-sm overflow-hidden">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                    <tr><th class="ps-4">Verdict</th><th>Exigence</th><th>Observation</th><th class="text-center">Action</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="ct" items="${constatsClausesPending}">
                        <tr>
                            <td class="ps-4">
                                <span class="badge ${ct.type.contains('Majeur') ? 'bg-danger' : 'bg-warning text-dark'}">${ct.type}</span>
                            </td>
                            <td><strong>${ct.clauseIso.code}</strong></td>
                            <td class="small text-muted">${ct.description}</td>
                            <td class="text-center">
                                <button class="btn btn-sm btn-dark rounded-pill" data-bs-toggle="modal" data-bs-target="#modalNC${ct.id}">Ouvrir NC</button>
                            </td>
                        </tr>
                        <c:set var="currentConstat" value="${ct}" scope="request"/>
                        <jsp:include page="includes/modal_nc.jsp" />
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <h5 class="fw-bold mb-3 text-secondary"><i class="bi bi-kanban"></i> NC Ouvertes (Clauses)</h5>
            <c:forEach var="nc" items="${ncsClauses}">
                <c:set var="currentNC" value="${nc}" scope="request" />
                <c:set var="ncColor" value="primary" scope="request" />
                <c:set var="targetPoint" value="${nc.constat.clauseIso.code}" scope="request" />
                <%@ include file="includes/nc_card_template.jsp" %>
            </c:forEach>
        </div>

        <!-- ================= ONGLET ANNEXE A ================= -->
        <div class="tab-pane fade" id="tabAnnexe">

            <h5 class="fw-bold mb-3 mt-4 text-danger"><i class="bi bi-exclamation-octagon"></i> Faiblesses techniques en attente</h5>
            <div class="card mb-5 border-0 shadow-sm overflow-hidden">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                    <tr><th class="ps-4">Maturité</th><th>Contrôle</th><th>Écart identifié</th><th class="text-center">Action</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="ct" items="${constatsAnnexePending}">
                        <tr>
                            <td class="ps-4">
                                <span class="badge bg-danger">${ct.niveauMaturite}</span>
                            </td>
                            <td><strong>${ct.controle.code}</strong></td>
                            <td class="small text-muted">${ct.description}</td>
                            <td class="text-center">
                                <button class="btn btn-sm btn-danger rounded-pill" data-bs-toggle="modal" data-bs-target="#modalNC${ct.id}">Ouvrir NC</button>
                            </td>
                        </tr>
                        <c:set var="currentConstat" value="${ct}" scope="request"/>
                        <jsp:include page="includes/modal_nc.jsp" />
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <h5 class="fw-bold mb-3 text-danger"><i class="bi bi-tools"></i> Plans de Remédiation (Annexe A)</h5>
            <c:forEach var="nc" items="${ncsAnnexe}">
                <c:set var="currentNC" value="${nc}" scope="request" />
                <c:set var="ncColor" value="danger" scope="request" />
                <c:set var="targetPoint" value="${nc.constat.controle.code}" scope="request" />
                <%@ include file="includes/nc_card_template.jsp" %>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Scripts Ollama JS ... (Identiques à votre version précédente) -->
<script>
    // ... fonction askOllama(this) ...

    function askOllama(btn) {
        // 1. Récupération des données depuis les attributs 'data-'
        const id = btn.getAttribute('data-id');
        const description = btn.getAttribute('data-desc');
        const code = btn.getAttribute('data-code');

        const textarea = document.getElementById('cause_' + id);
        const originalText = textarea.value;

        // UI Feedback
        textarea.value = "⚡ Analyse par l'IA locale (Phi-3) en cours via Ollama...";
        textarea.disabled = true;
        btn.disabled = true;

        // 2. Envoi en POST pour éviter les problèmes d'URL trop longue
        const requestData = {
            desc: description,
            code: code
        };

        fetch('/api/ai/suggest-nc', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData)
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Le serveur a renvoyé une erreur ' + response.status);
                }
                return response.text();
            })
            .then(data => {
                textarea.value = data;
                textarea.disabled = false;
                btn.disabled = false;
            })
            .catch(error => {
                console.error('Erreur Ollama:', error);
                textarea.value = "❌ Erreur de connexion à l'IA. \nVérifiez :\n1. Que l'application Ollama est ouverte.\n2. Que le modèle phi3:mini est chargé.\n\nDétails : " + error.message;
                textarea.disabled = false;
                btn.disabled = false;
            });
    }

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>--%>




<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<%@ taglib uri="jakarta.tags.core" prefix="c" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="fr">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <title>SMSI - Suivi des Actions Correctives</title>--%>
<%--    <!-- Bootstrap 5 CSS -->--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <!-- Bootstrap Icons -->--%>
<%--    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">--%>
<%--    <style>--%>
<%--        body {--%>
<%--            background-color: #f8f9fc;--%>
<%--            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;--%>
<%--        }--%>

<%--        /* Style pour le titre principal */--%>
<%--        h3.fw-bold.text-secondary {--%>
<%--            color: #1e293b !important;--%>
<%--            font-size: 1.75rem;--%>
<%--            letter-spacing: -0.02em;--%>
<%--            border-left: 6px solid #dc3545;--%>
<%--            padding-left: 1rem;--%>
<%--            margin-bottom: 2rem !important;--%>
<%--        }--%>

<%--        /* Carte principale de suivi */--%>
<%--        .card.nc-card {--%>
<%--            border: none;--%>
<%--            border-radius: 20px;--%>
<%--            background: white;--%>
<%--            transition: all 0.3s ease;--%>
<%--            box-shadow: 0 10px 30px rgba(0,0,0,0.05) !important;--%>
<%--        }--%>

<%--        .card.nc-card:hover {--%>
<%--            box-shadow: 0 15px 40px rgba(220, 53, 69, 0.1) !important;--%>
<%--        }--%>

<%--        /* En-tête de la carte avec la référence */--%>
<%--        .card-header.bg-white {--%>
<%--            background: white !important;--%>
<%--            border-bottom: 1px solid #edf2f7 !important;--%>
<%--            padding: 1.25rem 1.5rem !important;--%>
<%--        }--%>

<%--        .card-header .h5 {--%>
<%--            font-size: 1.25rem;--%>
<%--            font-weight: 700;--%>
<%--            color: #dc3545 !important;--%>
<%--            letter-spacing: -0.01em;--%>
<%--        }--%>

<%--        /* Badge pour l'audit lié */--%>
<%--        .badge.bg-light.text-secondary.border {--%>
<%--            background: #f1f5f9 !important;--%>
<%--            color: #475569 !important;--%>
<%--            border: none !important;--%>
<%--            padding: 0.6rem 1rem;--%>
<%--            font-weight: 500;--%>
<%--            font-size: 0.8rem;--%>
<%--            border-radius: 50px;--%>
<%--        }--%>

<%--        /* Section gauche - Écart et cause */--%>
<%--        .bg-light.rounded {--%>
<%--            background-color: #f8fafc !important;--%>
<%--            border: 1px solid #e9eef3 !important;--%>
<%--            border-radius: 16px !important;--%>
<%--            padding: 1.5rem !important;--%>
<%--        }--%>

<%--        .border-start.border-3.border-danger {--%>
<%--            border-left-width: 4px !important;--%>
<%--            border-left-color: #dc3545 !important;--%>
<%--        }--%>

<%--        /* Titres des sections */--%>
<%--        .text-uppercase.text-danger {--%>
<%--            color: #dc3545 !important;--%>
<%--            font-size: 0.7rem;--%>
<%--            font-weight: 700;--%>
<%--            letter-spacing: 0.05em;--%>
<%--            margin-bottom: 0.75rem;--%>
<%--        }--%>

<%--        .text-uppercase.text-muted {--%>
<%--            color: #64748b !important;--%>
<%--            font-size: 0.7rem;--%>
<%--            font-weight: 700;--%>
<%--            letter-spacing: 0.05em;--%>
<%--            margin-bottom: 0.75rem;--%>
<%--        }--%>

<%--        /* Contenu texte */--%>
<%--        p.small.text-dark {--%>
<%--            color: #1e293b !important;--%>
<%--            font-size: 0.9rem;--%>
<%--            line-height: 1.6;--%>
<%--            margin-bottom: 1.5rem;--%>
<%--        }--%>

<%--        p.small.fst-italic.text-secondary {--%>
<%--            color: #475569 !important;--%>
<%--            font-size: 0.9rem;--%>
<%--            line-height: 1.6;--%>
<%--            background: white;--%>
<%--            padding: 1rem;--%>
<%--            border-radius: 12px;--%>
<%--            border: 1px dashed #cbd5e1;--%>
<%--        }--%>

<%--        /* Tableau des actions */--%>
<%--        .table-actions {--%>
<%--            background: white;--%>
<%--            border-radius: 16px;--%>
<%--            overflow: hidden;--%>
<%--            border: 1px solid #edf2f7;--%>
<%--        }--%>

<%--        .table-actions thead th {--%>
<%--            background-color: #f8fafc;--%>
<%--            color: #64748b;--%>
<%--            font-size: 0.7rem;--%>
<%--            font-weight: 700;--%>
<%--            text-transform: uppercase;--%>
<%--            letter-spacing: 0.03em;--%>
<%--            padding: 1rem;--%>
<%--            border-bottom: 1px solid #e2e8f0;--%>
<%--        }--%>

<%--        .table-actions tbody tr {--%>
<%--            border-bottom: 1px solid #edf2f7;--%>
<%--        }--%>

<%--        .table-actions tbody tr:last-child {--%>
<%--            border-bottom: none;--%>
<%--        }--%>

<%--        .table-actions td {--%>
<%--            padding: 1rem;--%>
<%--            vertical-align: middle;--%>
<%--            font-size: 0.9rem;--%>
<%--        }--%>

<%--        /* Badges de statut */--%>
<%--        .badge.rounded-pill {--%>
<%--            padding: 0.5rem 1rem;--%>
<%--            font-weight: 500;--%>
<%--            font-size: 0.75rem;--%>
<%--        }--%>

<%--        .bg-warning {--%>
<%--            background-color: #fbbf24 !important;--%>
<%--            color: #1e293b !important;--%>
<%--        }--%>

<%--        .bg-success {--%>
<%--            background-color: #10b981 !important;--%>
<%--            color: white !important;--%>
<%--        }--%>

<%--        /* Bouton Clôturer */--%>
<%--        .btn-outline-success {--%>
<%--            border: 1px solid #10b981;--%>
<%--            color: #10b981;--%>
<%--            border-radius: 50px;--%>
<%--            padding: 0.25rem 1rem;--%>
<%--            font-size: 0.75rem;--%>
<%--            font-weight: 600;--%>
<%--            transition: all 0.2s;--%>
<%--        }--%>

<%--        .btn-outline-success:hover {--%>
<%--            background-color: #10b981;--%>
<%--            color: white;--%>
<%--        }--%>

<%--        /* Bouton Ajouter une action */--%>
<%--        .btn-primary.rounded-pill {--%>
<%--            background: linear-gradient(135deg, #3b82f6, #2563eb);--%>
<%--            border: none;--%>
<%--            padding: 0.5rem 1.25rem;--%>
<%--            font-size: 0.85rem;--%>
<%--            font-weight: 600;--%>
<%--            letter-spacing: 0.02em;--%>
<%--            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);--%>
<%--        }--%>

<%--        .btn-primary.rounded-pill:hover {--%>
<%--            transform: translateY(-2px);--%>
<%--            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.3);--%>
<%--        }--%>

<%--        /* Message quand aucune action */--%>
<%--        .text-center.text-muted.small.py-4 {--%>
<%--            color: #94a3b8 !important;--%>
<%--            font-style: italic;--%>
<%--            padding: 2rem !important;--%>
<%--        }--%>

<%--        /* MODAL STYLING */--%>
<%--        .modal-content {--%>
<%--            border: none;--%>
<%--            border-radius: 24px;--%>
<%--            overflow: hidden;--%>
<%--        }--%>

<%--        .modal-header.bg-danger {--%>
<%--            background: linear-gradient(135deg, #dc3545, #b02a37) !important;--%>
<%--            padding: 1.5rem;--%>
<%--        }--%>

<%--        .modal-header.bg-danger .modal-title {--%>
<%--            font-size: 1.2rem;--%>
<%--            font-weight: 700;--%>
<%--        }--%>

<%--        .modal-header.bg-primary {--%>
<%--            background: linear-gradient(135deg, #3b82f6, #2563eb) !important;--%>
<%--            padding: 1.5rem;--%>
<%--        }--%>

<%--        .modal-header.bg-primary .modal-title {--%>
<%--            font-size: 1.2rem;--%>
<%--            font-weight: 700;--%>
<%--        }--%>

<%--        .modal-body {--%>
<%--            padding: 2rem;--%>
<%--        }--%>

<%--        .modal-footer {--%>
<%--            padding: 1.5rem;--%>
<%--            border-top: 1px solid #e9eef3;--%>
<%--        }--%>

<%--        /* Fix pour les modals */--%>
<%--        .modal, .modal * {--%>
<%--            writing-mode: horizontal-tb !important;--%>
<%--            transform: none !important;--%>
<%--        }--%>

<%--        /* Style pour le bouton IA */--%>
<%--        .btn-outline-primary {--%>
<%--            border: 1px solid #3b82f6;--%>
<%--            color: #3b82f6;--%>
<%--            border-radius: 0 50px 50px 0;--%>
<%--            padding: 0.5rem 1rem;--%>
<%--            font-weight: 500;--%>
<%--            transition: all 0.2s;--%>
<%--        }--%>

<%--        .btn-outline-primary:hover {--%>
<%--            background: linear-gradient(135deg, #3b82f6, #2563eb);--%>
<%--            color: white;--%>
<%--            border-color: transparent;--%>
<%--            transform: translateY(-2px);--%>
<%--            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);--%>
<%--        }--%>

<%--        /* Style pour l'input-group */--%>
<%--        .input-group {--%>
<%--            border-radius: 12px;--%>
<%--            overflow: hidden;--%>
<%--            box-shadow: 0 2px 8px rgba(0,0,0,0.05);--%>
<%--        }--%>

<%--        .input-group .form-control {--%>
<%--            border-right: none;--%>
<%--            border-radius: 12px 0 0 12px;--%>
<%--            border: 1px solid #e2e8f0;--%>
<%--        }--%>

<%--        .input-group .form-control:focus {--%>
<%--            border-color: #3b82f6;--%>
<%--            box-shadow: none;--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>

<%--<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">--%>
<%--    <div class="container">--%>
<%--        <span class="navbar-brand fw-bold"><i class="bi bi-arrow-repeat text-info me-2"></i> Amélioration Continue (PDCA)</span>--%>
<%--        <a href="/dashboard" class="btn btn-outline-light btn-sm"><i class="bi bi-house-door"></i> Retour Dashboard</a>--%>
<%--    </div>--%>
<%--</nav>--%>

<%--<div class="container pb-5">--%>

<%--    <!-- SECTION 1 : CONSTATS EN ATTENTE -->--%>
<%--    <div class="card mb-5 shadow-sm border-top border-warning border-4">--%>
<%--        <div class="card-header bg-white py-3">--%>
<%--            <h5 class="mb-0 text-dark fw-bold">--%>
<%--                <i class="bi bi-clipboard-pulse text-warning me-2"></i>Nouveaux constats à valider--%>
<%--            </h5>--%>
<%--        </div>--%>
<%--        <div class="card-body p-0">--%>
<%--            <div class="table-responsive">--%>
<%--                <table class="table table-hover align-middle mb-0">--%>
<%--                    <thead class="table-light">--%>
<%--                    <tr>--%>
<%--                        <th class="ps-4">Sévérité</th>--%>
<%--                        <th>Contrôle</th>--%>
<%--                        <th>Faits identifiés lors de l'audit</th>--%>
<%--                        <th class="text-center">Action</th>--%>
<%--                    </tr>--%>
<%--                    </thead>--%>
<%--                    <tbody>--%>
<%--                    <c:forEach var="ct" items="${constatsEnAttente}">--%>
<%--                        <tr>--%>
<%--                            <td class="ps-4">--%>
<%--                                <c:choose>--%>
<%--                                    <c:when test="${not empty ct.type}">--%>
<%--                                        <span class="badge ${ct.type == 'Conforme' ? 'bg-success' : (ct.type == 'Observation' ? 'bg-info' : (ct.type == 'NC Mineur' ? 'bg-warning' : 'bg-danger'))} me-3 px-3 py-2 rounded-pill shadow-sm">--%>
<%--                                            <i class="bi ${ct.type == 'Conforme' ? 'bi-check-all' : (ct.type == 'Observation' ? 'bi-eye' : (ct.type == 'NC Mineur' ? 'bi-exclamation-triangle' : 'bi-x-octagon'))}"></i>--%>
<%--                                            ${ct.type}--%>
<%--                                        </span>--%>
<%--                                    </c:when>--%>
<%--                                    <c:otherwise>--%>
<%--                                            <span class="badge--%>
<%--                                                ${ct.niveauMaturite == 'Non applicable' ? 'bg-secondary' :--%>
<%--                                                  (ct.niveauMaturite.contains('0') ? 'bg-danger' :--%>
<%--                                                  (ct.niveauMaturite.contains('1') ? 'bg-danger' :--%>
<%--                                                  (ct.niveauMaturite.contains('2') ? 'bg-warning text-dark' :--%>
<%--                                                  (ct.niveauMaturite.contains('3') ? 'bg-warning text-dark' :--%>
<%--                                                  (ct.niveauMaturite.contains('4') ? 'bg-success' :--%>
<%--                                                  (ct.niveauMaturite.contains('5') ? 'bg-success' : 'bg-secondary'))))))}--%>
<%--                                                me-3 px-3 py-2 rounded-pill shadow-sm">--%>
<%--                                                <i class="bi--%>
<%--                                                    ${ct.niveauMaturite == 'Non applicable' ? 'bi-dash-circle' :--%>
<%--                                                     (ct.niveauMaturite.contains('0') ? 'bi-0-circle' :--%>
<%--                                                     (ct.niveauMaturite.contains('1') ? 'bi-1-circle' :--%>
<%--                                                     (ct.niveauMaturite.contains('2') ? 'bi-2-circle' :--%>
<%--                                                     (ct.niveauMaturite.contains('3') ? 'bi-3-circle' :--%>
<%--                                                     (ct.niveauMaturite.contains('4') ? 'bi-4-circle' :--%>
<%--                                                     (ct.niveauMaturite.contains('5') ? 'bi-5-circle' : 'bi-question-circle'))))))}">--%>
<%--                                                </i>--%>
<%--                                                ${ct.niveauMaturite}--%>
<%--                                            </span>--%>
<%--                                    </c:otherwise>--%>
<%--                                </c:choose>--%>
<%--                            </td>--%>
<%--                            <td><span class="badge bg-light text-dark border">CODE: ${ct.controle.code}</span></td>--%>
<%--                            <td class="small text-muted">${ct.description}</td>--%>
<%--                            <td class="text-center">--%>
<%--                                <button class="btn btn-sm btn-dark px-3 rounded-pill" data-bs-toggle="modal" data-bs-target="#modalNC${ct.id}">--%>
<%--                                    <i class="bi bi-folder-plus me-1"></i> Ouvrir NC--%>
<%--                                </button>--%>
<%--                            </td>--%>
<%--                        </tr>--%>

<%--                        <!-- Modal Ouvrir NC avec bouton IA intégré -->--%>
<%--                        <div class="modal fade" id="modalNC${ct.id}" tabindex="-1" aria-hidden="true">--%>
<%--                            <div class="modal-dialog modal-dialog-centered">--%>
<%--                                <div class="modal-content shadow-lg">--%>
<%--                                    <form action="/audit/constat/valider-nc" method="post">--%>
<%--                                        <input type="hidden" name="constatId" value="${ct.id}">--%>
<%--                                        <div class="modal-header bg-danger text-white border-0">--%>
<%--                                            <h5 class="modal-title fw-bold"><i class="bi bi-exclamation-triangle-fill me-2"></i>Validation Non-Conformité</h5>--%>
<%--                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>--%>
<%--                                        </div>--%>
<%--                                        <div class="modal-body p-4">--%>
<%--                                            <div class="p-3 bg-light rounded small border mb-4">--%>
<%--                                                <strong>OBSERVATION DE L'AUDITEUR :</strong><br> ${ct.description}--%>
<%--                                            </div>--%>
<%--                                            <div class="p-3 bg-light rounded small border mb-4">--%>
<%--                                                <strong>RECOMMANDATION DE L'AUDITEUR :</strong><br> ${ct.recommandation}--%>
<%--                                            </div>--%>

<%--                                            <div class="mb-3">--%>
<%--                                                <label class="form-label fw-bold">Référence Interne</label>--%>
<%--                                                <input type="text" name="reference" class="form-control" placeholder="ex: NC-2024-SYS-01" required>--%>
<%--                                            </div>--%>
<%--                                            <div class="mb-0">--%>
<%--                                                <label class="form-label fw-bold">Analyse de la cause racine</label>--%>
<%--                                                <div class="input-group">--%>
<%--                                                    <!-- textarea avec un ID dynamique -->--%>
<%--                                                    <textarea id="cause_${ct.id}" name="cause" class="form-control" rows="4" placeholder="Pourquoi cet écart a-t-il été rendu possible ?" required></textarea>--%>

<%--                                                    <!-- Bouton Robot avec stockage sécurisé des données -->--%>
<%--                                                    <button type="button" class="btn btn-outline-primary"--%>
<%--                                                            id="btn_ai_${ct.id}"--%>
<%--                                                            data-id="${ct.id}"--%>
<%--                                                            data-desc="<c:out value='${ct.description}'/>"--%>
<%--                                                            data-code="<c:out value='${ct.controle.code}'/>"--%>
<%--                                                            onclick="askOllama(this)">--%>
<%--                                                        <i class="bi bi-robot"></i> Aide IA--%>
<%--                                                    </button>--%>
<%--                                                </div>--%>
<%--                                                <small class="form-text text-muted mt-2">L'IA peut vous suggérer une analyse des causes racines.</small>--%>
<%--                                            </div>--%>
<%--                                        </div>--%>
<%--                                        <div class="modal-footer bg-light border-0">--%>
<%--                                            <button type="submit" class="btn btn-danger w-100 rounded-pill py-2 shadow-sm">Valider et Transférer au Plan d'Action</button>--%>
<%--                                        </div>--%>
<%--                                    </form>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </c:forEach>--%>
<%--                    <c:if test="${empty constatsEnAttente}">--%>
<%--                        <tr><td colspan="4" class="text-center py-4 text-muted"><i class="bi bi-check-all fs-2"></i><br>Aucun nouveau constat.</td></tr>--%>
<%--                    </c:if>--%>
<%--                    </tbody>--%>
<%--                </table>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- SECTION 2 : NON-CONFORMITÉS OUVERTES -->--%>
<%--    <h3 class="mb-4 fw-bold text-secondary"><i class="bi bi-kanban me-2"></i>Suivi des Actions Correctives</h3>--%>

<%--    <div class="row">--%>
<%--        <c:forEach var="nc" items="${ncs}">--%>
<%--            <div class="col-12 mb-4">--%>
<%--                <div class="card nc-card shadow-sm border-start border-danger border-5 h-100 border-0">--%>
<%--                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">--%>
<%--                        <span class="h5 mb-0 text-danger fw-bold"><i class="bi bi-folder-fill me-2"></i>Ref: ${nc.reference}</span>--%>
<%--                        <span class="badge bg-light text-secondary border">Audit lié: ${nc.constat.audit.titre}</span>--%>
<%--                    </div>--%>

<%--                    <div class="card-body pt-0">--%>
<%--                        <div class="row g-4">--%>
<%--                            <div class="col-md-5">--%>
<%--                                <div class="p-3 bg-light rounded border-start border-3 border-danger h-100">--%>
<%--                                    <h6 class="fw-bold small text-uppercase text-danger mb-2">L'écart (Contrôle ${nc.constat.controle.code})</h6>--%>
<%--                                    <p class="small text-dark mb-3">${nc.constat.description}</p>--%>

<%--                                    <h6 class="fw-bold small text-uppercase text-muted mb-2">Cause Racine Identifiée</h6>--%>
<%--                                    <p class="small fst-italic text-secondary">${nc.causeRacine}</p>--%>
<%--                                </div>--%>
<%--                            </div>--%>

<%--                            <div class="col-md-7 ps-md-4">--%>
<%--                                <div class="d-flex justify-content-between align-items-center mb-3">--%>
<%--                                    <h6 class="fw-bold mb-0 text-primary">Actions engagées</h6>--%>
<%--                                    <button class="btn btn-sm btn-primary rounded-pill px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#addAct${nc.id}">--%>
<%--                                        <i class="bi bi-plus-lg me-1"></i>Ajouter une action--%>
<%--                                    </button>--%>
<%--                                </div>--%>

<%--                                <table class="table table-sm table-actions mb-0">--%>
<%--                                    <thead>--%>
<%--                                    <tr>--%>
<%--                                        <th>Mesure corrective</th>--%>
<%--                                        <th>Echéance</th>--%>
<%--                                        <th class="text-end">Statut</th>--%>
<%--                                    </tr>--%>
<%--                                    </thead>--%>
<%--                                    <tbody>--%>
<%--                                    <c:forEach var="act" items="${nc.actions}">--%>
<%--                                        <tr class="action-item">--%>
<%--                                            <td class="small fw-medium py-2">${act.titre} <br><small class="text-muted">Resp: ${act.responsable}</small></td>--%>
<%--                                            <td class="small align-middle"><i class="bi bi-calendar-event me-1"></i> ${act.dateEcheance}</td>--%>
<%--                                            <td class="text-end align-middle">--%>
<%--                                                <!-- Si l'action n'est pas terminée, on affiche le bouton pour la clôturer -->--%>
<%--                                                <c:if test="${act.statut != 'TERMINE'}">--%>
<%--                                                    <form action="/audit/action/cloturer/${act.id}" method="post" style="display:inline;">--%>
<%--                                                        <button type="submit" class="btn btn-sm btn-outline-success me-1 py-0 px-2" title="Marquer comme terminé">--%>
<%--                                                            <i class="bi bi-check-lg"></i> Clôturer--%>
<%--                                                        </button>--%>
<%--                                                    </form>--%>
<%--                                                    <span class="badge rounded-pill bg-warning text-dark">${act.statut}</span>--%>
<%--                                                </c:if>--%>

<%--                                                <!-- Si elle est terminée, on affiche juste le badge vert -->--%>
<%--                                                <c:if test="${act.statut == 'TERMINE'}">--%>
<%--                                                    <span class="badge rounded-pill bg-success">--%>
<%--                                                        <i class="bi bi-check-all"></i> ${act.statut}--%>
<%--                                                    </span>--%>
<%--                                                </c:if>--%>
<%--                                            </td>--%>
<%--                                        </tr>--%>
<%--                                    </c:forEach>--%>
<%--                                    <c:if test="${empty nc.actions}">--%>
<%--                                        <tr><td colspan="3" class="text-center text-muted small py-4">Aucune action définie. Cliquer sur "Ajouter".</td></tr>--%>
<%--                                    </c:if>--%>
<%--                                    </tbody>--%>
<%--                                </table>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- MODAL POUR AJOUTER UNE ACTION CORRECTIVE -->--%>
<%--            <div class="modal fade" id="addAct${nc.id}" tabindex="-1" aria-hidden="true">--%>
<%--                <div class="modal-dialog modal-dialog-centered">--%>
<%--                    <div class="modal-content shadow-lg border-0">--%>
<%--                        <form action="/audit/action/save" method="post">--%>
<%--                            <input type="hidden" name="ncId" value="${nc.id}">--%>
<%--                            <div class="modal-header bg-primary text-white border-0">--%>
<%--                                <h5 class="modal-title fw-bold"><i class="bi bi-lightning-charge me-2"></i>Planifier une Action Corrective</h5>--%>
<%--                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>--%>
<%--                            </div>--%>
<%--                            <div class="modal-body p-4">--%>
<%--                                <p class="text-muted small mb-4">Engagement d'une mesure pour corriger la NC : <strong>${nc.reference}</strong></p>--%>

<%--                                <div class="mb-3">--%>
<%--                                    <label class="form-label fw-bold">Description de l'action</label>--%>
<%--                                    <textarea name="titre" class="form-control shadow-sm" rows="3" placeholder="Quelle mesure technique ou organisationnelle allez-vous prendre ?" required></textarea>--%>
<%--                                </div>--%>

<%--                                <div class="row">--%>
<%--                                    <div class="col-md-6 mb-3">--%>
<%--                                        <label class="form-label fw-bold">Responsable</label>--%>
<%--                                        <div class="input-group">--%>
<%--                                            <span class="input-group-text"><i class="bi bi-person"></i></span>--%>
<%--                                            <input type="text" name="responsable" class="form-control" placeholder="ex: RSSI / Admin IT" required>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
<%--                                    <div class="col-md-6 mb-3">--%>
<%--                                        <label class="form-label fw-bold">Délai (Deadline)</label>--%>
<%--                                        <div class="input-group">--%>
<%--                                            <span class="input-group-text"><i class="bi bi-clock"></i></span>--%>
<%--                                            <input type="date" name="dateEcheance" class="form-control" required>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                            <div class="modal-footer bg-light border-0">--%>
<%--                                <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Annuler</button>--%>
<%--                                <button type="submit" class="btn btn-primary px-5 rounded-pill shadow">Engager l'action</button>--%>
<%--                            </div>--%>
<%--                        </form>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:forEach>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- Script pour l'assistant IA Ollama -->--%>
<%--<script>--%>


<%--        function askOllama(btn) {--%>
<%--        // 1. Récupération des données depuis les attributs 'data-'--%>
<%--        const id = btn.getAttribute('data-id');--%>
<%--        const description = btn.getAttribute('data-desc');--%>
<%--        const code = btn.getAttribute('data-code');--%>

<%--        const textarea = document.getElementById('cause_' + id);--%>
<%--        const originalText = textarea.value;--%>

<%--        // UI Feedback--%>
<%--        textarea.value = "⚡ Analyse par l'IA locale (Phi-3) en cours via Ollama...";--%>
<%--        textarea.disabled = true;--%>
<%--        btn.disabled = true;--%>

<%--        // 2. Envoi en POST pour éviter les problèmes d'URL trop longue--%>
<%--        const requestData = {--%>
<%--        desc: description,--%>
<%--        code: code--%>
<%--    };--%>

<%--        fetch('/api/ai/suggest-nc', {--%>
<%--        method: 'POST',--%>
<%--        headers: {--%>
<%--        'Content-Type': 'application/json'--%>
<%--    },--%>
<%--        body: JSON.stringify(requestData)--%>
<%--    })--%>
<%--        .then(response => {--%>
<%--        if (!response.ok) {--%>
<%--        throw new Error('Le serveur a renvoyé une erreur ' + response.status);--%>
<%--    }--%>
<%--        return response.text();--%>
<%--    })--%>
<%--        .then(data => {--%>
<%--        textarea.value = data;--%>
<%--        textarea.disabled = false;--%>
<%--        btn.disabled = false;--%>
<%--    })--%>
<%--        .catch(error => {--%>
<%--        console.error('Erreur Ollama:', error);--%>
<%--        textarea.value = "❌ Erreur de connexion à l'IA. \nVérifiez :\n1. Que l'application Ollama est ouverte.\n2. Que le modèle phi3:mini est chargé.\n\nDétails : " + error.message;--%>
<%--        textarea.disabled = false;--%>
<%--        btn.disabled = false;--%>
<%--    });--%>
<%--    }--%>
<%--</script>--%>

<%--<!-- JS Bootstrap -->--%>
<%--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>--%>

<%--</body>--%>
<%--</html>--%>