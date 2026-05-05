<%@tag description="Master Layout CyberPilot SMSI" pageEncoding="UTF-8"%>
<%@attribute name="pageTitle" required="true"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>
<%@taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- Détection robuste de l'URL pour garder le menu actif --%>
<c:set var="uri" value="${requestScope['jakarta.servlet.forward.request_uri']}" />
<c:if test="${empty uri}"><c:set var="uri" value="${pageContext.request.requestURI}" /></c:if>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle} | CyberPilot SMSI</title>

    <!-- Google Font & Icons -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- AdminLTE Style -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">

    <style>
        :root { --iso-red: #D2010D; --iso-dark: #343a40; }
        .main-header { border-bottom: 2px solid var(--iso-red) !important; }
        .logo-box { background-color: var(--iso-red); color: white; padding: 2px 10px; font-weight: 800; border-radius: 3px; }
        .brand-link { border-bottom: 1px solid #4b545c !important; }

        /* Correction SideBar : Forcer le rouge sur l'élément actif */
        .sidebar-dark-primary .nav-sidebar > .nav-item > .nav-link.active,
        .sidebar-dark-primary .nav-treeview > .nav-item > .nav-link.active {
            background-color: var(--iso-red) !important;
            color: white !important;
        }
        /* Style des sous-menus ouverts */
        .nav-treeview > .nav-item > .nav-link { padding-left: 2rem; }
        .nav-item.menu-open > .nav-link:first-child { background-color: rgba(255,255,255,0.05); }
    </style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <!-- NAVBAR -->
    <nav class="main-header navbar navbar-expand navbar-white navbar-light">
        <ul class="navbar-nav">
            <li class="nav-item"><a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a></li>
            <li class="nav-item d-none d-sm-inline-block">
                <span class="nav-link font-weight-bold text-dark text-uppercase">Système de Gestion ISO 27001</span>
            </li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item dropdown">
                <a class="nav-link" data-toggle="dropdown" href="#">
                    <i class="fas fa-user-circle mr-1"></i> ${currentUsername}
                </a>
                <div class="dropdown-menu dropdown-menu-right shadow border-0">
                    <div class="dropdown-header text-center">SESSION ACTIVE</div>
                    <div class="dropdown-divider"></div>
                    <a href="/logout" class="dropdown-item text-danger">
                        <i class="fas fa-sign-out-alt mr-2"></i> Déconnexion
                    </a>
                </div>
            </li>
        </ul>
    </nav>

    <!-- SIDEBAR PRINCIPALE -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="/" class="brand-link">
            <span class="logo-box ml-3">ISO</span>
            <span class="brand-text font-weight-light ml-2">CyberPilot</span>
        </a>

        <div class="sidebar">
            <nav class="mt-3">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="true">

                    <!-- GROUPE 1 : ADMINISTRATION -->
                    <c:if test="${isAdmin}">
                        <li class="nav-item ${fn:contains(uri, '/admin/') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(uri, '/admin/') ? 'active' : ''}">
                                <i class="nav-icon fas fa-user-shield"></i>
                                <p>Administration <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/admin/users" class="nav-link ${fn:contains(uri, '/admin/users') ? 'active' : ''}"><i class="far fa-circle nav-icon"></i><p>Utilisateurs</p></a></li>
                                <li class="nav-item"><a href="/admin/clauses" class="nav-link ${fn:contains(uri, '/admin/clauses') ? 'active' : ''}"><i class="far fa-circle nav-icon"></i><p>Réf. Clauses</p></a></li>
                                <li class="nav-item"><a href="/admin/controles" class="nav-link ${fn:contains(uri, '/admin/controles') ? 'active' : ''}"><i class="far fa-circle nav-icon"></i><p>Réf. Contrôles</p></a></li>
                                <li class="nav-item"><a href="/admin/audit-log" class="nav-link ${fn:contains(uri, '/admin/audit-log') ? 'active' : ''}"><i class="far fa-circle nav-icon"></i><p>Journal d'Audit</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 2 : SECURITÉ & RISQUES (Admin / RSSI) -->
                    <c:if test="${isAdmin || isRSSI}">
                        <li class="nav-item ${fn:contains(uri, '/rssi/') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(uri, '/rssi/') ? 'active' : ''}">
                                <i class="nav-icon fas fa-shield-alt"></i>
                                <p>Sécurité & Risques <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/rssi/perimetres" class="nav-link ${fn:contains(uri, '/rssi/perimetres') ? 'active' : ''}"><i class="fas fa-map-marker-alt nav-icon small"></i><p>Périmètres</p></a></li>
                                <li class="nav-item"><a href="/rssi/actifs" class="nav-link ${fn:contains(uri, '/rssi/actifs') ? 'active' : ''}"><i class="fas fa-boxes nav-icon small"></i><p>Inventaire Actifs</p></a></li>
                                <li class="nav-item"><a href="/rssi/assets-editor" class="nav-link ${fn:contains(uri, '/rssi/assets-editor') ? 'active' : ''}"><i class="fas fa-edit nav-icon small"></i><p>Éditeur Actifs</p></a></li>
                                <li class="nav-item"><a href="/rssi/risques" class="nav-link ${fn:contains(uri, '/rssi/risques') ? 'active' : ''}"><i class="fas fa-biohazard nav-icon small"></i><p>Analyses Risques</p></a></li>
                                <li class="nav-item"><a href="/rssi/risk-editor" class="nav-link ${fn:contains(uri, '/rssi/risk-editor') ? 'active' : ''}"><i class="fas fa-table nav-icon small"></i><p>Éditeur ISO 27005</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 3 : CONFORMITÉ IT -->
                    <c:if test="${isAdmin || isRSSI || isPilote}">
                        <li class="nav-item ${fn:contains(uri, '/compliance/soa') || fn:contains(uri, '/compliance/editor') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(uri, '/compliance/soa') || fn:contains(uri, '/compliance/editor') ? 'active' : ''}">
                                <i class="nav-icon fas fa-laptop-code"></i>
                                <p>IT & Conformité <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/compliance/soa" class="nav-link ${fn:contains(uri, '/compliance/soa') ? 'active' : ''}"><i class="far fa-clipboard nav-icon"></i><p>Déclaration (SoA)</p></a></li>
                                <li class="nav-item"><a href="/compliance/editor" class="nav-link ${fn:contains(uri, '/compliance/editor') ? 'active' : ''}"><i class="fas fa-magic nav-icon small"></i><p>Éditeur Rapide</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 4 : AUDIT & AMÉLIORATION -->
                    <c:if test="${isAdmin || isRSSI || isAuditeur}">
                        <li class="nav-item ${fn:contains(uri, '/audit/') || fn:contains(uri, '/compliance/improvement') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(uri, '/audit/') || fn:contains(uri, '/compliance/improvement') ? 'active' : ''}">
                                <i class="nav-icon fas fa-clipboard-check"></i>
                                <p>Audit & Services <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/audit/missions" class="nav-link ${fn:contains(uri, '/audit/missions') ? 'active' : ''}"><i class="fas fa-search nav-icon small"></i><p>Missions d'Audit</p></a></li>
                                <li class="nav-item"><a href="/compliance/improvement" class="nav-link ${fn:contains(uri, '/compliance/improvement') ? 'active' : ''}"><i class="fas fa-chart-line nav-icon small"></i><p>Journal Amélioration</p></a></li>
                                <li class="nav-item"><a href="/audit/actions-correctives" class="nav-link ${fn:contains(uri, '/audit/actions-correctives') ? 'active' : ''}"><i class="fas fa-tools nav-icon small"></i><p>Actions Correctives</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 5 : SÉCURITÉ OPÉRATIONNELLE -->
                    <c:if test="${isAdmin || isRSSI}">
                        <li class="nav-item ${fn:contains(uri, '/planification') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(uri, '/planification') ? 'active' : ''}">
                                <i class="nav-icon fas fa-tasks"></i>
                                <p>Opérations <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/planification" class="nav-link ${fn:contains(uri, '/planification') && !fn:contains(uri, '/logs') ? 'active' : ''}"><i class="far fa-calendar-alt nav-icon"></i><p>Planification</p></a></li>
                                <li class="nav-item"><a href="/planification/logs" class="nav-link ${fn:contains(uri, '/planification/logs') ? 'active' : ''}"><i class="fas fa-history nav-icon small"></i><p>Logs d'exécution</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 6 : INSIGHTS -->
                    <c:if test="${isAdmin || isRSSI || isDirection}">
                        <li class="nav-header">INSIGHTS</li>
                        <li class="nav-item">
                            <a href="/reporting/dashboard" class="nav-link ${fn:contains(uri, '/reporting/') ? 'active' : ''}">
                                <i class="nav-icon fas fa-chart-bar"></i>
                                <p>Tableau de Bord KPIs</p>
                            </a>
                        </li>
                    </c:if>

                </ul>
            </nav>
        </div>
    </aside>

    <!-- CONTENU DYNAMIQUE -->
    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-12">
                        <h1 class="m-0 font-weight-bold text-dark border-bottom pb-2">${pageTitle}</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">
                <jsp:doBody/>
            </div>
        </section>
    </div>

    <!-- FOOTER -->
    <footer class="main-footer">
        <div class="float-right d-none d-sm-inline">Pilotage ISO 27001 v2.0</div>
        <strong>Copyright &copy; 2026 <a href="#" style="color:var(--iso-red)">CyberPilot</a>.</strong> All rights reserved.
    </footer>
</div>

<!-- SCRIPTS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>

</body>
</html>

<%--<%@tag description="Master Layout CyberPilot SMSI" pageEncoding="UTF-8"%>
<%@attribute name="pageTitle" required="true"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>
<%@taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

&lt;%&ndash;<c:set var="currentUri" value="${requestScope['jakarta.servlet.forward.request_uri']}" />&ndash;%&gt;
<c:set var="currentUri" value="${pageContext.request.requestURI}" />

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle} | CyberPilot SMSI</title>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">

    <style>
        :root { --iso-red: #D2010D; --iso-dark: #343a40; }
        .main-header { border-bottom: 2px solid var(--iso-red) !important; }
        .logo-box { background-color: var(--iso-red); color: white; padding: 2px 10px; font-weight: 800; border-radius: 3px; }

        /* Correction : Sidebar selection */
        .sidebar-dark-primary .nav-sidebar > .nav-item > .nav-link.active,
        .nav-pills .nav-link.active {
            background-color: var(--iso-red) !important;
            color: white !important;
        }

        /* Style des sous-menus actifs */
        .nav-treeview > .nav-item > .nav-link.active {
            background-color: rgba(255,255,255,0.1) !important;
            border-left: 3px solid var(--iso-red);
            color: white !important;
        }
        .brand-link { border-bottom: 1px solid #4b545c !important; }
    </style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <!-- NAVBAR -->
    <nav class="main-header navbar navbar-expand navbar-white navbar-light">
        <ul class="navbar-nav">
            <li class="nav-item"><a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a></li>
            <li class="nav-item d-none d-sm-inline-block"><span class="nav-link font-weight-bold text-dark">SYSTÈME DE GESTION ISO 27001</span></li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item dropdown">
                <a class="nav-link" data-toggle="dropdown" href="#">
                    <i class="far fa-user-circle mr-1"></i> ${currentUsername}
                </a>
                <div class="dropdown-menu dropdown-menu-right">
                    <a href="/logout" class="dropdown-item text-danger"><i class="fas fa-sign-out-alt mr-2"></i> Déconnexion</a>
                </div>
            </li>
        </ul>
    </nav>

    <!-- SIDEBAR -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="/" class="brand-link">
            <span class="logo-box ml-3">ISO</span>
            <span class="brand-text font-weight-light ml-2">CyberPilot</span>
        </a>

        <div class="sidebar">
            <nav class="mt-3">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="true">

                    <!-- GROUPE 1 : ADMINISTRATION -->
                    <c:if test="${isAdmin}">
                        <li class="nav-item ${fn:contains(currentUri, '/admin/') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(currentUri, '/admin/') ? 'active' : ''}">
                                <i class="nav-icon fas fa-user-shield"></i>
                                <p>Administration <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/admin/users" class="nav-link ${fn:contains(currentUri, '/admin/users') ? 'active' : ''}"><i class="far fa-circle nav-icon text-danger"></i><p>Utilisateurs</p></a></li>
                                <li class="nav-item"><a href="/admin/clauses" class="nav-link ${fn:contains(currentUri, '/admin/clauses') ? 'active' : ''}"><i class="far fa-circle nav-icon"></i><p>Référentiel Clauses</p></a></li>
                                <li class="nav-item"><a href="/admin/controles" class="nav-link ${fn:contains(currentUri, '/admin/controles') ? 'active' : ''}"><i class="far fa-circle nav-icon"></i><p>Référentiel Contrôles</p></a></li>
                                <li class="nav-item"><a href="/admin/audit-log" class="nav-link ${fn:contains(currentUri, '/admin/audit-log') ? 'active' : ''}"><i class="far fa-circle nav-icon"></i><p>Journal d'Audit</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 2 : SECURITÉ & RISQUES -->
                    <c:if test="${isAdmin || isRSSI}">
                        <li class="nav-item ${fn:contains(currentUri, '/rssi/') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(currentUri, '/rssi/') ? 'active' : ''}">
                                <i class="nav-icon fas fa-shield-alt"></i>
                                <p>Sécurité & Risques <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/rssi/perimetres" class="nav-link ${fn:contains(currentUri, '/rssi/perimetres') ? 'active' : ''}"><i class="fas fa-map-marker-alt nav-icon small"></i><p>Périmètres SMSI</p></a></li>
                                <li class="nav-item"><a href="/rssi/actifs" class="nav-link ${fn:contains(currentUri, '/rssi/actifs') ? 'active' : ''}"><i class="fas fa-boxes nav-icon small"></i><p>Inventaire Actifs</p></a></li>
                                <li class="nav-item"><a href="/rssi/assets-editor" class="nav-link ${fn:contains(currentUri, '/rssi/assets-editor') ? 'active' : ''}"><i class="fas fa-edit nav-icon small"></i><p>Éditeur Actifs</p></a></li>
                                <li class="nav-item"><a href="/rssi/risques" class="nav-link ${fn:contains(currentUri, '/rssi/risques') ? 'active' : ''}"><i class="fas fa-biohazard nav-icon small"></i><p>Analyses Risques</p></a></li>
                                <li class="nav-item"><a href="/rssi/risk-editor" class="nav-link ${fn:contains(currentUri, '/rssi/risk-editor') ? 'active' : ''}"><i class="fas fa-table nav-icon small"></i><p>Éditeur ISO 27005</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 3 : CONFORMITÉ IT -->
                    <c:if test="${isAdmin || isRSSI || isPilote}">
                        <li class="nav-item ${fn:contains(currentUri, '/compliance/soa') || fn:contains(currentUri, '/compliance/editor') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(currentUri, '/compliance/') ? 'active' : ''}">
                                <i class="nav-icon fas fa-laptop-code"></i>
                                <p>IT & Conformité <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/compliance/soa" class="nav-link ${fn:contains(currentUri, '/compliance/soa') ? 'active' : ''}"><i class="far fa-clipboard nav-icon"></i><p>Déclaration (SoA)</p></a></li>
                                <li class="nav-item"><a href="/compliance/editor" class="nav-link ${fn:contains(currentUri, '/compliance/editor') ? 'active' : ''}"><i class="fas fa-magic nav-icon"></i><p>Éditeur Rapide</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 4 : AUDIT & AMELIORATION -->
                    <c:if test="${isAdmin || isRSSI || isAuditeur}">
                        <li class="nav-item ${fn:contains(currentUri, '/audit/') || fn:contains(currentUri, '/compliance/improvement') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(currentUri, '/audit/') || fn:contains(currentUri, '/compliance/improvement') ? 'active' : ''}">
                                <i class="nav-icon fas fa-clipboard-check"></i>
                                <p>Audit & Services <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/audit/missions" class="nav-link ${fn:contains(currentUri, '/audit/missions') ? 'active' : ''}"><i class="fas fa-search nav-icon"></i><p>Missions d'Audit</p></a></li>
                                <li class="nav-item"><a href="/compliance/improvement" class="nav-link ${fn:contains(currentUri, '/compliance/improvement') ? 'active' : ''}"><i class="fas fa-chart-line nav-icon"></i><p>Journal d'Amélioration</p></a></li>
                                <li class="nav-item"><a href="/audit/actions-correctives" class="nav-link ${fn:contains(currentUri, '/audit/actions-correctives') ? 'active' : ''}"><i class="fas fa-tools nav-icon"></i><p>Actions Correctives</p></a></li>
                                <c:set var="currentUri" value="${requestScope['jakarta.servlet.forward.request_uri']}" />
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 5 : OPERATIONS -->
                    <c:if test="${isAdmin || isRSSI}">
                        <li class="nav-item ${fn:contains(currentUri, '/planification') ? 'menu-open' : ''}">
                            <a href="#" class="nav-link ${fn:contains(currentUri, '/planification') ? 'active' : ''}">
                                <i class="nav-icon fas fa-tasks"></i>
                                <p>Opérations <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/planification" class="nav-link ${fn:contains(currentUri, '/planification') && !fn:contains(currentUri, '/logs') ? 'active' : ''}"><i class="far fa-calendar-alt nav-icon"></i><p>Planification</p></a></li>
                                <li class="nav-item"><a href="/planification/logs" class="nav-link ${fn:contains(currentUri, '/planification/logs') ? 'active' : ''}"><i class="fas fa-history nav-icon"></i><p>Historique exécutions</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <c:if test="${isAdmin || isRSSI || isDirection}">
                        <li class="nav-header">INSIGHTS</li>
                        <li class="nav-item">
                            <a href="/reporting/dashboard" class="nav-link ${fn:contains(currentUri, '/reporting/') ? 'active' : ''}">
                                <i class="nav-icon fas fa-chart-bar"></i>
                                <p>Tableau de Bord KPIs</p>
                            </a>
                        </li>
                    </c:if>

                </ul>
            </nav>
        </div>
    </aside>

    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid">
                <h1 class="m-0 font-weight-bold text-dark">${pageTitle}</h1>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">
                <jsp:doBody/>
            </div>
        </section>
    </div>

    <footer class="main-footer">
        <div class="float-right d-none d-sm-inline">Solutions CyberPilot SMSI</div>
        <strong>&copy; 2026 <a href="#" style="color:var(--iso-red)">CyberPilot</a>.</strong> Alignée ISO 27001.
    </footer>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>

</body>
</html>--%>

<%--
<%@tag description="Master Layout CyberPilot" pageEncoding="UTF-8"%>
<%@attribute name="pageTitle" required="true"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>
<%@taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle} | CyberPilot SMSI</title>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">

    <style>
        :root { --iso-red: #D2010D; }
        .main-header { border-bottom: 2px solid var(--iso-red) !important; }
        .logo-box { background-color: var(--iso-red); color: white; padding: 2px 10px; font-weight: 800; border-radius: 3px; }
        .nav-sidebar .nav-link.active { background-color: var(--iso-red) !important; color: white !important; }
        .nav-treeview > .nav-item > .nav-link.active { background-color: rgba(255,255,255,0.1) !important; color: #fff !important; border-left: 3px solid var(--iso-red); }
        .brand-link { border-bottom: 1px solid #4b545c !important; }
    </style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <!-- NAVBAR -->
    <nav class="main-header navbar navbar-expand navbar-white navbar-light">
        <ul class="navbar-nav">
            <li class="nav-item"><a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a></li>
            <li class="nav-item d-none d-sm-inline-block"><span class="nav-link font-weight-bold text-dark">SYSTÈME DE GESTION ISO 27001</span></li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item dropdown">
                <a class="nav-link" data-toggle="dropdown" href="#">
                    <i class="fas fa-user-circle mr-1"></i> ${currentUsername}
                </a>
                <div class="dropdown-menu dropdown-menu-right">
                    <a href="/logout" class="dropdown-item text-danger"><i class="fas fa-sign-out-alt mr-2"></i> Déconnexion</a>
                </div>
            </li>
        </ul>
    </nav>

    <!-- SIDEBAR -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="#" class="brand-link">
            <span class="logo-box ml-3">ISO</span>
            <span class="brand-text font-weight-light ml-2">CyberPilot</span>
        </a>

        <div class="sidebar">
            <nav class="mt-3">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="true">

                    <!-- GROUPE 1 : ADMINISTRATION (Visible Admin) -->
                    <c:if test="${isAdmin}">
                        <li class="nav-item">
                            <a href="#" class="nav-link">
                                <i class="nav-icon fas fa-cogs"></i>
                                <p>Administration <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/admin/users" class="nav-link"><i class="far fa-circle nav-icon text-danger"></i><p>Utilisateurs</p></a></li>
                                <li class="nav-item"><a href="/admin/clauses" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Référentiel Clauses</p></a></li>
                                <li class="nav-item"><a href="/admin/controles" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Référentiel Contrôles</p></a></li>
                                <li class="nav-item"><a href="/admin/audit-log" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Journal d'Audit</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 2 : SECURITÉ & RISQUES (Admin / RSSI) -->
                    <c:if test="${isAdmin || isRSSI}">
                        <li class="nav-item">
                            <a href="#" class="nav-link">
                                <i class="nav-icon fas fa-shield-alt"></i>
                                <p>Sécurité & Risques <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/rssi/perimetres" class="nav-link"><i class="far fa-circle nav-icon text-info"></i><p>Périmètres</p></a></li>
                                <li class="nav-item"><a href="/rssi/actifs" class="nav-link"><i class="far fa-circle nav-icon text-info"></i><p>Inventaire</p></a></li>
                                <li class="nav-item"><a href="/rssi/assets-editor" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Éditeur Massif</p></a></li>
                                <li class="nav-item"><a href="/rssi/risques" class="nav-link"><i class="far fa-circle nav-icon text-warning"></i><p>Analyses Risques</p></a></li>
                                <li class="nav-item"><a href="/rssi/risk-editor" class="nav-link"><i class="far fa-circle nav-icon text-warning"></i><p>Éditeur ISO 27005</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 3 : CONFORMITÉ -->
                    <c:if test="${isAdmin || isRSSI || isPilote}">
                        <li class="nav-item">
                            <a href="#" class="nav-link">
                                <i class="nav-icon fas fa-check-double"></i>
                                <p>Conformité <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/compliance/soa" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Déclaration (SoA)</p></a></li>
                                <li class="nav-item"><a href="/compliance/editor" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Éditeur Rapide</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 4 : AUDIT & ACTIONS -->
                    <c:if test="${isAdmin || isRSSI || isAuditeur}">
                        <li class="nav-item">
                            <a href="#" class="nav-link">
                                <i class="nav-icon fas fa-clipboard-list"></i>
                                <p>Audit & Amélioration <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/audit/missions" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Missions d'Audit</p></a></li>
                                <li class="nav-item"><a href="/compliance/improvement" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Journal Amélioration</p></a></li>
                                <li class="nav-item"><a href="/audit/actions-correctives" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Actions Correctives</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 5 : OPERATIONS -->
                    <c:if test="${isAdmin || isRSSI}">
                        <li class="nav-item">
                            <a href="#" class="nav-link">
                                <i class="nav-icon fas fa-sync-alt"></i>
                                <p>Opérations <i class="right fas fa-angle-left"></i></p>
                            </a>
                            <ul class="nav nav-treeview">
                                <li class="nav-item"><a href="/planification" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Planification</p></a></li>
                                <li class="nav-item"><a href="/planification/logs" class="nav-link"><i class="far fa-circle nav-icon"></i><p>Historique d'exécution</p></a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- GROUPE 6 : REPORTING -->
                    <c:if test="${isAdmin || isRSSI || isDirection}">
                        <li class="nav-header">INSIGHTS</li>
                        <li class="nav-item">
                            <a href="/reporting/dashboard" class="nav-link">
                                <i class="nav-icon fas fa-chart-line"></i>
                                <p>Tableaux de Bord KPIs</p>
                            </a>
                        </li>
                    </c:if>

                </ul>
            </nav>
        </div>
    </aside>

    <!-- CONTENU -->
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <h1 class="m-0 font-weight-bold text-dark">${pageTitle}</h1>
            </div>
        </div>
        <section class="content">
            <div class="container-fluid">
                <jsp:doBody/>
            </div>
        </section>
    </div>

    <footer class="main-footer"><strong>&copy; 2026 CyberPilot SMSI.</strong></footer>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
</body>
</html>--%>
