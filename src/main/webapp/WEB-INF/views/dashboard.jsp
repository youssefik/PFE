<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<%@ taglib uri="jakarta.tags.core" prefix="c" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="fr">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <title>SMSI ISO 27001 - Armoire 3D</title>--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">--%>

<%--    <style>--%>
<%--        body { margin: 0; background: radial-gradient(circle, #f0f0f0 0%, #bdc3c7 100%); overflow: hidden; font-family: sans-serif; }--%>

<%--        /* Navbar overlay */--%>
<%--        .ui-overlay {--%>
<%--            position: absolute; top: 0; left: 0; width: 100%; z-index: 100;--%>
<%--            pointer-events: none; /* Laisse passer les clics vers la 3D */--%>
<%--        }--%>
<%--        .ui-overlay * { pointer-events: auto; }--%>

<%--        /* Contenu à l'intérieur de l'armoire */--%>
<%--        .locker-content {--%>
<%--            width: 300px; height: 400px;--%>
<%--            background: white; border: 2px solid #ddd;--%>
<%--            padding: 20px; box-sizing: border-box;--%>
<%--            box-shadow: inset 0 0 50px rgba(0,0,0,0.1);--%>
<%--            display: flex; flex-direction: column;--%>
<%--        }--%>

<%--        .locker-header {--%>
<%--            border-bottom: 3px solid #cc0000;--%>
<%--            margin-bottom: 15px; padding-bottom: 5px;--%>
<%--            color: #cc0000; font-weight: bold;--%>
<%--        }--%>

<%--        .btn-module {--%>
<%--            text-align: left; margin-bottom: 8px; font-size: 0.9rem;--%>
<%--            border: 1px solid #eee; transition: 0.3s;--%>
<%--        }--%>
<%--        .btn-module:hover { background: #cc0000 !important; color: white !important; }--%>

<%--        /* Style de l'instruction */--%>
<%--        .instruction {--%>
<%--            position: absolute; bottom: 20px; width: 100%; text-align: center;--%>
<%--            color: #666; font-size: 0.9rem; pointer-events: none;--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>

<%--<div class="ui-overlay">--%>
<%--    <nav class="navbar navbar-dark bg-dark shadow-sm">--%>
<%--        <div class="container">--%>
<%--            <span class="navbar-brand fw-bold"><i class="bi bi-shield-lock-fill text-danger"></i> SMSI ISO 27001</span>--%>
<%--            <div class="text-white">--%>
<%--                <small class="me-3">${username}</small>--%>
<%--                <a href="/logout" class="btn btn-outline-danger btn-sm">Quitter</a>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </nav>--%>
<%--</div>--%>

<%--<div class="instruction">--%>
<%--    <i class="bi bi-mouse"></i> Glissez pour faire pivoter l'armoire | Cliquez sur une porte pour l'ouvrir--%>
<%--</div>--%>

<%--<!-- Conteneurs masqués pour le contenu des portes (utilisés par Three.js) -->--%>
<%--<div id="html-content" style="display: none;">--%>

<%--    <!-- Contenu Administration -->--%>
<%--    <div id="content-admin" class="locker-content">--%>
<%--        <div class="locker-header">ADMINISTRATION</div>--%>
<%--        <a href="/admin/clauses" class="btn btn-light btn-module"><i class="bi bi-book me-2"></i>Clauses ISO</a>--%>
<%--        <a href="/admin/controles" class="btn btn-light btn-module"><i class="bi bi-list-check me-2"></i>Contrôles</a>--%>
<%--        <a href="/admin/audit-log" class="btn btn-danger btn-sm mt-auto">Journal d'Audit</a>--%>
<%--    </div>--%>

<%--    <!-- Contenu Risques -->--%>
<%--    <div id="content-risks" class="locker-content">--%>
<%--        <div class="locker-header">GESTION DES RISQUES</div>--%>
<%--        <a href="/rssi/perimetres" class="btn btn-light btn-module"><i class="bi bi-geo-alt me-2"></i>Périmètres</a>--%>
<%--        <a href="/rssi/actifs" class="btn btn-light btn-module"><i class="bi bi-pc-display me-2"></i>Inventaire</a>--%>
<%--        <a href="/rssi/risques" class="btn btn-light btn-module"><i class="bi bi-shield-exclamation me-2"></i>Analyses</a>--%>
<%--        <a href="/rssi/risk-editor" class="btn btn-danger btn-sm mt-auto">Éditeur Risques</a>--%>
<%--    </div>--%>

<%--    <!-- Contenu Conformité -->--%>
<%--    <div id="content-compliance" class="locker-content">--%>
<%--        <div class="locker-header">CONFORMITÉ</div>--%>
<%--        <a href="/compliance/soa" class="btn btn-light btn-module"><i class="bi bi-clipboard-check me-2"></i>Déclaration SoA</a>--%>
<%--        <a href="/compliance/editor" class="btn btn-danger btn-sm mt-auto">Éditeur Rapide</a>--%>
<%--    </div>--%>

<%--    <!-- Contenu Audit -->--%>
<%--    <div id="content-audit" class="locker-content">--%>
<%--        <div class="locker-header">AUDIT & AMÉLIORATION</div>--%>
<%--        <a href="/audit/missions" class="btn btn-light btn-module"><i class="bi bi-calendar-check me-2"></i>Missions</a>--%>
<%--        <a href="/audit/actions-correctives" class="btn btn-light btn-module"><i class="bi bi-tools me-2"></i>Actions</a>--%>
<%--        <div class="mt-auto text-center text-muted small"><i class="bi bi-arrow-repeat"></i> PDCA</div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- Chargement de Three.js -->--%>
<%--<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>--%>
<%--<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/renderers/CSS3DRenderer.js"></script>--%>
<%--<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>--%>
<%--<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>--%>

<%--<script>--%>
<%--    let scene, camera, renderer, cssRenderer, controls;--%>
<%--    const lockers = [];--%>

<%--    init();--%>
<%--    animate();--%>

<%--    function init() {--%>
<%--        scene = new THREE.Scene();--%>

<%--        // Caméra--%>
<%--        camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 5000);--%>
<%--        camera.position.set(0, 200, 1200);--%>

<%--        // Renderer CSS3D (pour les éléments HTML)--%>
<%--        cssRenderer = new THREE.CSS3DRenderer();--%>
<%--        cssRenderer.setSize(window.innerWidth, window.innerHeight);--%>
<%--        document.body.appendChild(cssRenderer.domElement);--%>

<%--        // Controls (Rotation de l'armoire)--%>
<%--        controls = new THREE.OrbitControls(camera, cssRenderer.domElement);--%>
<%--        controls.enableDamping = true;--%>
<%--        controls.dampingFactor = 0.05;--%>

<%--        // Création de l'armoire (Groupe central)--%>
<%--        const cabinet = new THREE.Group();--%>
<%--        scene.add(cabinet);--%>

<%--        // Configuration des modules (ID contenu, position X)--%>
<%--        const modules = [--%>
<%--                <c:if test="${isAdmin}">{ id: 'content-admin', x: -480, label: 'ADMIN' },</c:if>--%>
<%--                <c:if test="${isRSSI || isAdmin}">{ id: 'content-risks', x: -160, label: 'RISQUES' },</c:if>--%>
<%--                <c:if test="${isRSSI || isAdmin || isPilote}">{ id: 'content-compliance', x: 160, label: 'CONFORMITÉ' },</c:if>--%>
<%--                <c:if test="${isAuditeur || isRSSI || isAdmin}">{ id: 'content-audit', x: 480, label: 'AUDIT' }</c:if>--%>
<%--        ];--%>

<%--        modules.forEach((mod, index) => {--%>
<%--            const lockerGroup = createLocker(mod.id, mod.label);--%>
<%--            lockerGroup.position.x = mod.x;--%>
<%--            cabinet.add(lockerGroup);--%>
<%--        });--%>

<%--        window.addEventListener('resize', onWindowResize);--%>
<%--    }--%>

<%--    function createLocker(elementId, labelText) {--%>
<%--        const group = new THREE.Group();--%>

<%--        // 1. Fond blanc de l'armoire (le fond du casier)--%>
<%--        const element = document.getElementById(elementId);--%>
<%--        element.style.display = 'block';--%>
<%--        const object = new THREE.CSS3DObject(element);--%>
<%--        group.add(object);--%>

<%--        // 2. La Porte Rouge--%>
<%--        const doorEl = document.createElement('div');--%>
<%--        doorEl.style.width = '300px';--%>
<%--        doorEl.style.height = '400px';--%>
<%--        doorEl.style.backgroundColor = '#cc0000';--%>
<%--        doorEl.style.border = '4px solid white';--%>
<%--        doorEl.style.display = 'flex';--%>
<%--        doorEl.style.alignItems = 'center';--%>
<%--        doorEl.style.justifyContent = 'center';--%>
<%--        doorEl.style.cursor = 'pointer';--%>
<%--        doorEl.style.boxShadow = '10px 0 20px rgba(0,0,0,0.2)';--%>

<%--        doorEl.innerHTML = `--%>
<%--            <div style="text-align:center; color:white;">--%>
<%--                <div style="font-size:40px; margin-bottom:10px;"><i class="bi bi-door-closed"></i></div>--%>
<%--                <div style="font-weight:bold; letter-spacing:2px;">${labelText}</div>--%>
<%--                <div style="margin-top:20px; width:10px; height:50px; background:#ddd; margin-left:260px; border-radius:5px;"></div>--%>
<%--            </div>--%>
<%--        `;--%>

<%--        const doorObj = new THREE.CSS3DObject(doorEl);--%>

<%--        // Pivot de la porte (pour qu'elle s'ouvre sur le côté)--%>
<%--        const doorPivot = new THREE.Group();--%>
<%--        doorPivot.position.set(-150, 0, 10); // Placer le pivot sur le bord gauche--%>
<%--        doorObj.position.set(150, 0, 0); // Décaler la porte par rapport au pivot--%>
<%--        doorPivot.add(doorObj);--%>

<%--        group.add(doorPivot);--%>

<%--        // Interaction ouverture/fermeture--%>
<%--        let isOpen = false;--%>
<%--        doorEl.addEventListener('click', (e) => {--%>
<%--            e.stopPropagation();--%>
<%--            if(!isOpen) {--%>
<%--                gsap.to(doorPivot.rotation, { y: -Math.PI * 0.7, duration: 1.2, ease: "power2.inOut" });--%>
<%--            } else {--%>
<%--                gsap.to(doorPivot.rotation, { y: 0, duration: 1, ease: "power2.inOut" });--%>
<%--            }--%>
<%--            isOpen = !isOpen;--%>
<%--        });--%>

<%--        return group;--%>
<%--    }--%>

<%--    function onWindowResize() {--%>
<%--        camera.aspect = window.innerWidth / window.innerHeight;--%>
<%--        camera.updateProjectionMatrix();--%>
<%--        cssRenderer.setSize(window.innerWidth, window.innerHeight);--%>
<%--    }--%>

<%--    function animate() {--%>
<%--        requestAnimationFrame(animate);--%>
<%--        controls.update();--%>
<%--        cssRenderer.render(scene, camera);--%>
<%--    }--%>
<%--</script>--%>

<%--</body>--%>
<%--</html>--%>


<%--version 2--%>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SMSI ISO 27001 - Dashboard</title>

    <!-- CSS Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --brand-red: #D32F2F;
            --brand-red-dark: #B71C1C;
            --brand-white: #ffffff;
            --bg-light: #fcfcfc;
        }

        body {
            background-color: var(--bg-light);
            font-family: 'Inter', sans-serif;
            color: #2d3436;
            overflow-x: hidden;
        }

        /* Container pour le fond 3D */
        #canvas-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: radial-gradient(circle at center, #ffffff 0%, #f1f1f1 100%);
        }

        .navbar {
            background-color: var(--brand-white) !important;
            border-bottom: 4px solid var(--brand-red);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 1rem 0;
        }

        .navbar-brand {
            color: var(--brand-red) !important;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }

        .card {
            border: none;
            border-radius: 16px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(211, 47, 47, 0.05);
        }

        .menu-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 40px rgba(211, 47, 47, 0.12) !important;
            border-color: var(--brand-red);
        }

        .card-header {
            background-color: var(--brand-red) !important;
            color: white !important;
            border-radius: 16px 16px 0 0 !important;
            font-weight: 700;
            border-bottom: none;
            padding: 1.25rem;
        }

        .btn-brand {
            background-color: var(--brand-red);
            color: white;
            border-radius: 10px;
            transition: all 0.3s;
            border: none;
            font-weight: 600;
        }

        .btn-brand:hover {
            background-color: var(--brand-red-dark);
            color: white;
            transform: scale(1.03);
            box-shadow: 0 4px 10px rgba(211, 47, 47, 0.3);
        }

        .btn-outline-brand {
            color: var(--brand-red);
            border: 1.5px solid var(--brand-red);
            border-radius: 10px;
            font-weight: 500;
        }

        .btn-outline-brand:hover {
            background-color: var(--brand-red);
            color: white;
        }

        .role-badge {
            background-color: rgba(211, 47, 47, 0.08);
            color: var(--brand-red);
            border: 1px solid var(--brand-red);
            font-weight: 600;
            padding: 8px 15px;
        }

        /* Animation d'entrée */
        .fade-in-up {
            animation: fadeInUp 0.7s ease-out forwards;
            opacity: 0;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<!-- Fond 3D Animé -->
<div id="canvas-container"></div>

<nav class="navbar navbar-light sticky-top mb-5">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="bi bi-shield-lock-fill me-2"></i>SMSI PROTECT
        </a>
        <div class="d-flex align-items-center">
            <span class="me-4 fw-bold text-dark"><i class="bi bi-person-circle text-danger me-1"></i> ${username}</span>
            <a href="/logout" class="btn btn-outline-brand btn-sm px-4 shadow-sm">DECONNEXION</a>
        </div>
    </div>
</nav>

<div class="container">
    <!-- Header Profil -->
    <div class="row mb-5 fade-in-up">
        <div class="col-12">
            <div class="card shadow-sm p-3">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-cpu text-danger me-2"></i>Espace de Travail Sécurisé</h5>
                    <div>
                        <c:forEach var="role" items="${authorities}">
                            <span class="badge role-badge rounded-pill ms-2">${role.authority}</span>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- ADMINISTRATION -->
        <c:if test="${isAdmin}">
            <div class="col-md-3 fade-in-up" style="animation-delay: 0.1s;">
                <div class="card h-100 shadow-sm menu-card">
                    <div class="card-header text-center">
                        <i class="bi bi-gear-fill fs-3 d-block mb-1"></i>
                        <h5 class="mb-0">Administration</h5>
                    </div>
                    <div class="card-body">
                        <a href="/admin/clauses" class="btn btn-outline-brand btn-sm w-100 mb-2 text-start"><i class="bi bi-book me-2"></i>Référentiel Clauses</a>
                        <a href="/admin/controles" class="btn btn-outline-brand btn-sm w-100 mb-2 text-start"><i class="bi bi-list-stars me-2"></i>Référentiel Contrôles</a>
                        <a href="/admin/audit-log" class="btn btn-brand btn-sm w-100 mt-2"><i class="bi bi-journal-text me-2"></i>Journal d'Audit</a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- RISQUES -->
        <c:if test="${isRSSI || isAdmin}">
            <div class="col-md-3 fade-in-up" style="animation-delay: 0.2s;">
                <div class="card h-100 shadow-sm menu-card">
                    <div class="card-header text-center">
                        <i class="bi bi-shield-exclamation fs-3 d-block mb-1"></i>
                        <h5 class="mb-0">Risques</h5>
                    </div>
                    <div class="card-body">
                        <a href="/rssi/perimetres" class="btn btn-outline-brand btn-sm w-100 mb-2 text-start"><i class="bi bi-geo-alt me-2"></i>Périmètres</a>
                        <a href="/rssi/actifs" class="btn btn-outline-brand btn-sm w-100 mb-2 text-start"><i class="bi bi-pc-display me-2"></i>Inventaire Actifs</a>
                        <a href="/rssi/risques" class="btn btn-outline-brand btn-sm w-100 mb-2 text-start"><i class="bi bi-graph-down-arrow me-2"></i>Analyse des Risques</a>
                        <a href="/rssi/risk-editor" class="btn btn-brand btn-sm w-100 text-start"><i class="bi bi-pencil-square me-2"></i>Éditeur des Risques</a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- CONFORMITÉ -->
        <c:if test="${isRSSI || isAdmin || isPilote}">
            <div class="col-md-3 fade-in-up" style="animation-delay: 0.3s;">
                <div class="card h-100 shadow-sm menu-card">
                    <div class="card-header text-center">
                        <i class="bi bi-check-all fs-3 d-block mb-1"></i>
                        <h5 class="mb-0">Conformité</h5>
                    </div>
                    <div class="card-body">
                        <a href="/compliance/soa" class="btn btn-outline-brand btn-sm w-100 mb-2 text-start"><i class="bi bi-clipboard-check me-2"></i>Déclaration (SoA)</a>
                        <a href="/compliance/editor" class="btn btn-brand btn-sm w-100 text-start shadow-sm"><i class="bi bi-table me-2"></i>Éditeur Rapide</a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- AUDIT -->
        <c:if test="${isAuditeur || isRSSI || isAdmin}">
            <div class="col-md-3 fade-in-up" style="animation-delay: 0.4s;">
                <div class="card h-100 shadow-sm menu-card">
                    <div class="card-header text-center">
                        <i class="bi bi-search fs-3 d-block mb-1"></i>
                        <h5 class="mb-0">Audit Interne</h5>
                    </div>
                    <div class="card-body">
                        <a href="/audit/missions" class="btn btn-outline-brand btn-sm w-100 mb-2 text-start"><i class="bi bi-calendar-check me-2"></i>Missions d'Audit</a>
                        <a href="/audit/actions-correctives" class="btn btn-brand btn-sm w-100 text-start shadow-sm"><i class="bi bi-tools me-2"></i>Actions Correctives</a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- REPORTING -->
    <c:if test="${isAdmin || isRSSI || isDirection}">
        <div class="row mt-5 fade-in-up" style="animation-delay: 0.5s;">
            <div class="col-12">
                <div class="card border-0 shadow-sm overflow-hidden">
                    <div class="row g-0 align-items-center">
                        <div class="col-md-2 bg-danger text-white text-center py-4">
                            <i class="bi bi-graph-up-arrow fs-1"></i>
                        </div>
                        <div class="col-md-7 p-4">
                            <h4 class="fw-bold mb-1">Pilotage & Reporting Direction</h4>
                            <p class="text-muted mb-0">Indicateurs de maturité, conformité globale et KPI sécurité.</p>
                        </div>
                        <div class="col-md-3 p-4 text-center">
                            <a href="/reporting/dashboard" class="btn btn-brand btn-lg w-100 shadow">
                                <i class="bi bi-eye me-2"></i>Voir les KPIs
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<footer class="text-center py-5 mt-5 text-muted opacity-75">
    <small>&copy; 2024 - Solution SMSI Intégrée | Charte Qualité & Sécurité</small>
</footer>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>

<script>
    // Animation 3D de fond (Points interconnectés)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });

    renderer.setSize(window.innerWidth, window.innerHeight);
    document.getElementById('canvas-container').appendChild(renderer.domElement);

    const geometry = new THREE.BufferGeometry();
    const vertices = [];
    for (let i = 0; i < 2000; i++) {
        vertices.push(THREE.MathUtils.randFloatSpread(2500));
        vertices.push(THREE.MathUtils.randFloatSpread(2500));
        vertices.push(THREE.MathUtils.randFloatSpread(2500));
    }
    geometry.setAttribute('position', new THREE.Float32BufferAttribute(vertices, 3));

    const material = new THREE.PointsMaterial({ color: 0xD32F2F, size: 3, transparent: true, opacity: 0.3 });
    const points = new THREE.Points(geometry, material);
    scene.add(points);

    camera.position.z = 1000;

    function animate() {
        requestAnimationFrame(animate);
        points.rotation.x += 0.0003;
        points.rotation.y += 0.0003;
        renderer.render(scene, camera);
    }

    window.addEventListener('resize', () => {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    });

    animate();
</script>

</body>
</html>--%>

<%--version 1--%>
<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<%@ taglib uri="jakarta.tags.core" prefix="c" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <title>SMSI ISO 27001 - Dashboard</title>--%>
<%--    <!-- CSS Bootstrap 5 -->--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <!-- Bootstrap Icons (INDISPENSABLE) -->--%>
<%--    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">--%>
<%--    <style>--%>
<%--        body { background-color: #f8f9fa; }--%>
<%--        .menu-card { transition: transform 0.2s, box-shadow 0.2s; cursor: pointer; border-radius: 12px; }--%>
<%--        .menu-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }--%>
<%--        .role-badge { font-size: 0.8em; border-radius: 20px; padding: 5px 12px; }--%>
<%--        .navbar-brand { font-weight: bold; letter-spacing: 1px; }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<nav class="navbar navbar-dark bg-dark mb-4 shadow-sm">--%>
<%--    <div class="container">--%>
<%--        <span class="navbar-brand"><i class="bi bi-shield-check"></i> SYSTÈME SMSI ISO 27001</span>--%>
<%--        <div class="text-white">--%>
<%--            <span class="me-3"><i class="bi bi-person-circle"></i> ${username}</span>--%>
<%--            <a href="/logout" class="btn btn-outline-danger btn-sm rounded-pill">Déconnexion</a>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</nav>--%>

<%--<div class="container">--%>
<%--    <div class="row mb-4">--%>
<%--        <div class="col-12">--%>
<%--            <div class="card shadow-sm border-0" style="border-left: 5px solid #0d6efd !important;">--%>
<%--                <div class="card-body py-2">--%>
<%--                    <h6 class="mb-0">Profil Sécurisé :--%>
<%--                        <c:forEach var="role" items="${authorities}">--%>
<%--                            <span class="badge bg-primary role-badge ms-2">${role.authority}</span>--%>
<%--                        </c:forEach>--%>
<%--                    </h6>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <div class="row g-4">--%>
<%--        <!-- BLOC 1 : ADMINISTRATION (ADMIN) -->--%>
<%--        <c:if test="${isAdmin}">--%>
<%--            <div class="col-md-3">--%>
<%--                <div class="card h-100 shadow-sm border-0 menu-card">--%>
<%--                    <div class="card-header bg-dark text-white text-center py-3">--%>
<%--                        <h5 class="mb-0"><i class="bi bi-gear-fill"></i> Administration</h5>--%>
<%--                    </div>--%>
<%--                    <div class="card-body">--%>
<%--                        <a href="/admin/clauses" class="btn btn-outline-secondary btn-sm w-100 mb-2 text-start"><i class="bi bi-book me-2"></i>Référentiel Clauses</a>--%>
<%--                        <a href="/admin/controles" class="btn btn-outline-secondary btn-sm w-100 mb-2 text-start"><i class="bi bi-list-stars me-2"></i>Référentiel Contrôles</a>--%>
<%--                        <a href="/admin/audit-log" class="btn btn-warning btn-sm w-100 text-start fw-bold"><i class="bi bi-journal-text me-2"></i>Journal d'Audit</a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:if>--%>

<%--        <!-- BLOC 2 : RISQUES (RSSI / ADMIN) -->--%>
<%--        <c:if test="${isRSSI || isAdmin}">--%>
<%--            <div class="col-md-3">--%>
<%--                <div class="card h-100 shadow-sm border-0 menu-card">--%>
<%--                    <div class="card-header bg-danger text-white text-center py-3">--%>
<%--                        <h5 class="mb-0"><i class="bi bi-shield-exclamation"></i> Risques</h5>--%>
<%--                    </div>--%>
<%--                    <div class="card-body">--%>
<%--                        <a href="/rssi/perimetres" class="btn btn-outline-danger btn-sm w-100 mb-2 text-start"><i class="bi bi-geo-alt me-2"></i>Périmètres du SMSI</a>--%>
<%--                        <a href="/rssi/actifs" class="btn btn-outline-danger btn-sm w-100 mb-2 text-start"><i class="bi bi-pc-display me-2"></i>Inventaire des Actifs</a>--%>
<%--                        <a href="/rssi/risques" class="btn btn-outline-danger btn-sm w-100 text-start mb-2 shadow-sm"><i class="bi bi-pc-display me-2"></i>Analyse des Risques</a>--%>
<%--                        <a href="/rssi/risk-editor" class="btn btn-danger btn-sm w-100 text-start"><i class="bi bi-shield-exclamation me-2"></i>Éditeur des Risques</a>--%>

<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:if>--%>

<%--        <!-- BLOC 3 : CONFORMITÉ (RSSI / ADMIN / PILOTE) -->--%>
<%--        <c:if test="${isRSSI || isAdmin || isPilote}">--%>
<%--            <div class="col-md-3">--%>
<%--                <div class="card h-100 shadow-sm border-0 menu-card">--%>
<%--                    <div class="card-header bg-primary text-white text-center py-3">--%>
<%--                        <h5 class="mb-0"><i class="bi bi-check-all"></i> Conformité</h5>--%>
<%--                    </div>--%>
<%--                    <div class="card-body">--%>
<%--                        <a href="/compliance/soa" class="btn btn-outline-primary btn-sm w-100 mb-2 text-start"><i class="bi bi-clipboard-check me-2"></i>Déclaration (SoA)</a>--%>
<%--                        <a href="/compliance/editor" class="btn btn-primary btn-sm w-100 text-start shadow-sm"><i class="bi bi-table me-2"></i>Éditeur Rapide</a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:if>--%>

<%--        <!-- BLOC 4 : AUDIT & AMÉLIORATION (NOUVEAU - SPRINT 5) -->--%>
<%--        <c:if test="${isAuditeur || isRSSI || isAdmin}">--%>
<%--            <div class="col-md-3">--%>
<%--                <div class="card h-100 shadow-sm border-0 menu-card" style="border-top: 5px solid #0dcaf0 !important;">--%>
<%--                    <div class="card-header bg-info text-white text-center py-3">--%>
<%--                        <h5 class="mb-0 text-dark fw-bold"><i class="bi bi-search"></i> Audit Interne</h5>--%>
<%--                    </div>--%>
<%--                    <div class="card-body">--%>
<%--                        <a href="/audit/missions" class="btn btn-outline-info btn-sm w-100 mb-2 text-start text-dark fw-bold"><i class="bi bi-calendar-check me-2"></i>Missions d'Audit</a>--%>
<%--                        <a href="/audit/actions-correctives" class="btn btn-info btn-sm w-100 text-start text-white shadow-sm fw-bold"><i class="bi bi-tools me-2"></i>Actions Correctives</a>--%>
<%--                    </div>--%>
<%--                    <div class="card-footer bg-white border-0 text-center pb-3">--%>
<%--                        <small class="text-muted"><i class="bi bi-arrow-repeat"></i> PDCA : Check & Act</small>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:if>--%>

<%--        <!-- BLOC 5 : PILOTAGE OPÉRATIONNEL (NOUVEAU - BACKUPS & TÂCHES) -->--%>
<%--        <c:if test="${isRSSI || isAdmin}">--%>
<%--            <div class="col-md-3">--%>
<%--                <div class="card h-100 shadow-sm border-0 menu-card" style="border-top: 5px solid #6f42c1 !important;">--%>
<%--                    <div class="card-header bg-dark text-white text-center py-3">--%>
<%--                        <h5 class="mb-0"><i class="bi bi-cpu-fill"></i> Sécurité Opérationnelle</h5>--%>
<%--                    </div>--%>
<%--                    <div class="card-body">--%>
<%--                        <p class="text-muted small text-center">Maintenance et Backups programmés.</p>--%>

<%--                        <a href="/planification" class="btn btn-outline-dark btn-sm w-100 mb-2 text-start">--%>
<%--                            <i class="bi bi-calendar-check me-2 text-primary"></i>Planification des Tâches--%>
<%--                        </a>--%>

<%--                        <a href="/planification/logs" class="btn btn-outline-dark btn-sm w-100 mb-2 text-start">--%>
<%--                            <i class="bi bi-clipboard-data me-2 text-info"></i>Historique d'exécution--%>
<%--                        </a>--%>

<%--                        <div class="mt-3 p-2 bg-light rounded border text-center">--%>
<%--                            <c:choose>--%>
<%--                                <c:when test="${not empty nextTask}">--%>
<%--                                    <small class="text-uppercase fw-bold text-muted" style="font-size: 0.7rem;">PROCHAINE ACTION : ${nextTask.titre}</small>--%>
<%--                                    <div class="text-primary fw-bold">--%>
<%--                                        <fmt:parseDate value="${nextTask.prochaineExecution}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />--%>
<%--                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />--%>
<%--                                    </div>--%>
<%--                                </c:when>--%>
<%--                                <c:otherwise>--%>
<%--                                    <small class="text-muted">Aucune tâche planifiée</small>--%>
<%--                                </c:otherwise>--%>
<%--                            </c:choose>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                    <div class="card-footer bg-white border-0 text-center pb-3">--%>
<%--                        <small class="text-muted"><i class="bi bi-shield-check"></i> Mesure ISO 27001 : A.8.13</small>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:if>--%>


<%--        <c:if test="${isAdmin || isRSSI || isDirection}">--%>
<%--            <div class="col-md-3">--%>
<%--                <div class="card h-100 shadow-sm border-0">--%>
<%--                    <div class="card-header bg-success text-white">--%>
<%--                        <h5 class="mb-0"><i class="bi bi-graph-up"></i> Pilotage & Reporting</h5>--%>
<%--                    </div>--%>
<%--                    <div class="card-body text-center">--%>
<%--                        <p class="text-muted small">Vision globale de la conformité pour la Direction.</p>--%>
<%--                        <a href="/reporting/dashboard" class="btn btn-success btn-lg w-100 shadow-sm">--%>
<%--                            <i class="bi bi-eye"></i> Consulter les KPIs--%>
<%--                        </a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:if>--%>
<%--    </div>--%>
<%--</div>--%>
<%--<!-- JS Bootstrap -->--%>
<%--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>--%>
<%--</body>--%>
<%--</html>--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>SMSI ISO 27001 - Corporate Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --iso-red: #D2010D; /* Le rouge officiel ISO */
            --iso-dark: #212121;
            --iso-gray: #F4F4F4;
            --iso-light: #FFFFFF;
        }

        body {
            background-color: var(--iso-gray);
            font-family: 'Inter', sans-serif;
            color: var(--iso-dark);
        }

        /* Navbar style ISO */
        .navbar {
            background-color: white !important;
            border-bottom: 1px solid #ddd;
            padding: 15px 0;
        }

        .navbar-brand img { height: 45px; } /* Simulant le logo ISO */

        .logo-box {
            background-color: var(--iso-red);
            color: white;
            padding: 5px 12px;
            font-weight: 800;
            text-transform: uppercase;
            display: inline-block;
            margin-right: 15px;
        }

        /* Cartes de navigation "Explore by sector" style */
        .iso-card {
            background: white;
            border: none;
            border-radius: 4px; /* Coins légèrement arrondis comme l'image */
            transition: all 0.3s ease;
            height: 100%;
            text-align: center;
            padding: 40px 20px;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }

        .iso-card i {
            font-size: 3.5rem;
            color: var(--iso-red);
            margin-bottom: 20px;
            transition: color 0.3s ease;
        }

        .iso-card h5 {
            font-weight: 700;
            color: var(--iso-dark);
            font-size: 1.1rem;
            margin-bottom: 15px;
            transition: color 0.3s ease;
        }

        /* Effet de l'image : La carte devient rouge au survol */
        .iso-card:hover {
            background-color: var(--iso-red);
            transform: translateY(-5px);
        }

        .iso-card:hover i,
        .iso-card:hover h5{
            color: white !important;
        }

        /* Style des liens à l'intérieur une fois la carte "ouverte" (ou via menu) */
        .btn-link-iso {
            color: var(--iso-dark);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            display: block;
            margin: 5px 0;
        }

        .btn-link-iso:hover { color: var(--iso-light); }

        .section-title {
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 30px;
            border-left: 5px solid var(--iso-red);
            padding-left: 15px;
        }

        .user-badge {
            font-size: 0.8rem;
            font-weight: 600;
            color: #666;
            border-right: 1px solid #ddd;
            padding-right: 15px;
        }




        /* Style spécifique pour le bloc d'alerte interne à la carte */
        .action-alert {
            background-color: #f8f9fa;
            border-radius: 4px;
            color: var(--iso-dark);
            transition: all 0.3s ease;
        }

        /* Quand on survole la carte (qui devient rouge), le petit bloc s'adapte */
        .iso-card:hover .action-alert {
            background-color: rgba(255, 255, 255, 0.2); /* Blanc semi-transparent sur fond rouge */
            color: white !important;
        }

        /* Style pour la référence ISO en bas */
        .iso-ref-tag {
            font-size: 0.7rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #999;
            transition: color 0.3s ease;
        }

        .iso-card:hover .iso-ref-tag {
            color: rgba(255, 255, 255, 0.8) !important;
        }

        /* Correction pour les icônes dans les liens */
        .btn-link-iso i {
            font-size: 1rem !important; /* On réduit la taille des icônes de liens par rapport à l'icône principale */
            margin-bottom: 0 !important;
        }
    </style>
</head>
<body>

<!-- Navbar calquée sur le style de l'image -->
<nav class="navbar navbar-light sticky-top mb-5">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="#">
            <div class="logo-box">ISO</div>
            <span class="d-none d-lg-inline text-dark fw-bold">SMSI 27001 DASHBOARD</span>
        </a>

        <div class="d-flex align-items-center">
            <span class="user-badge me-3">
                <i class="bi bi-person me-1"></i> ${username}
            </span>
            <a href="/logout" class="text-danger fw-bold text-decoration-none small ms-3">DÉCONNEXION</a>
        </div>
    </div>
</nav>

<div class="container">
    <h2 class="section-title">Explore by module</h2>

    <div class="row g-4">

        <!-- ADMINISTRATION -->
        <c:if test="${isAdmin}">
            <div class="col-md-3">
                <div class="iso-card shadow-sm">
                    <i class="bi bi-gear"></i>
                    <h5>Administration</h5>
                    <div class="mt-2">
                        <a href="/admin/clauses" class="btn-link-iso">Référentiel Clauses</a>
                        <a href="/admin/controles" class="btn-link-iso">Référentiel Contrôles</a>
                        <a href="/admin/audit-log" class="btn-link-iso">Journal d'Audit</a>
                        <a href="/admin/users" class="btn-link-iso text-muted">Gestion des utilisateurs</a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- RISQUES (Le style "Health" de votre image) -->
        <c:if test="${isRSSI || isAdmin}">
            <div class="col-md-3">
                <!-- On simule ici la carte active/hover par défaut si vous voulez, sinon le CSS gère le hover -->
                <div class="iso-card shadow-sm">
                    <i class="bi bi-shield-check"></i>
                    <h5>Safety, Security & Risks</h5>
                    <div class="mt-2">
                        <a href="/rssi/perimetres" class="btn-link-iso">Périmètres SMSI</a>
                        <a href="/rssi/actifs" class="btn-link-iso">Inventaire Actifs</a>
                        <a href="/rssi/risques" class="btn-link-iso">Analyses Risques</a>
                        <a href="/rssi/risk-editor" class="btn-link-iso text-muted">Éditeur Risques</a>

                    </div>
                </div>
            </div>
        </c:if>

        <!-- IT / CONFORMITÉ -->
        <c:if test="${isRSSI || isAdmin || isPilote}">
            <div class="col-md-3">
                <div class="iso-card shadow-sm">
                    <i class="bi bi-cpu"></i>
                    <h5>IT & Technologies</h5>
                    <div class="mt-2">
                        <a href="/compliance/soa" class="btn-link-iso">Déclaration (SoA)</a>
                        <a href="/compliance/editor" class="btn-link-iso">Éditeur Rapide</a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- AUDIT -->
        <c:if test="${isAuditeur || isRSSI || isAdmin}">
            <div class="col-md-3">
                <div class="iso-card shadow-sm">
                    <i class="bi bi-search"></i>
                    <h5>Management & Services</h5>
                    <div class="mt-2">
                        <a href="/audit/missions" class="btn-link-iso">Missions d'Audit</a>
                        <a href="/compliance/improvement" class="btn-link-iso">Journal d'Amélioration</a>
                        <a href="/audit/actions-correctives" class="btn-link-iso">Actions Correctives</a>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${isRSSI || isAdmin}">
            <div class="col-md-3">
                <!-- Utilisation de la classe 'iso-card' pour l'effet de survol rouge -->
                <div class="iso-card shadow-sm">
                    <!-- Icône filaire style ISO -->
                    <i class="bi bi-gear-wide-connected"></i>
                    <h5>Sécurité Opérationnelle</h5>

                    <div class="mt-2 w-100">
                        <a href="/planification" class="btn-link-iso">
                            <i class="bi bi-calendar-check me-2"></i>Planification
                        </a>
                        <a href="/planification/logs" class="btn-link-iso">
                            <i class="bi bi-clipboard-data me-2"></i>Historique d'exécution
                        </a>
                    </div>

                    <!-- Bloc "Prochaine Action" adapté pour rester lisible lors du survol -->
                    <div class="next-action-container mt-3 w-100">
                        <c:choose>
                            <c:when test="${not empty nextTask}">
                                <div class="action-alert p-2">
                                    <small class="text-uppercase d-block fw-bold opacity-75" style="font-size: 0.65rem;">
                                        Prochaine action :
                                    </small>
                                    <div class="fw-bold" style="font-size: 0.85rem;">
                                            ${nextTask.titre}
                                    </div>
                                    <div class="small">
                                        <fmt:parseDate value="${nextTask.prochaineExecution}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <small class="text-muted opacity-50">Aucune tâche planifiée</small>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Référence ISO en bas de carte -->
                    <div class="mt-auto pt-3">
                        <small class="iso-ref-tag">ISO 27001 : A.8.13</small>
                    </div>
                </div>
            </div>
        </c:if>

    </div>




    <!-- REPORTING (Pleine largeur en bas comme un pied de page d'action) -->
    <c:if test="${isAdmin || isRSSI || isDirection}">
        <div class="row mt-5">
            <div class="col-12">
                <div class="p-5 bg-white shadow-sm d-flex justify-content-between align-items-center border-top border-5 border-danger">
                    <div>
                        <h3 class="fw-bold mb-1">Insights & News</h3>
                        <p class="text-muted mb-0">Consultez les indicateurs de performance et la maturité globale du système.</p>
                    </div>
                    <a href="/reporting/dashboard" class="btn btn-danger btn-lg px-5 py-3 fw-bold shadow">
                        CONSULTER LES KPIs
                    </a>
                </div>
            </div>
        </div>
    </c:if>

</div>

<footer class="py-5 text-center mt-5">
    <hr class="container">
    <p class="text-muted small">© 2026 Corporate SMSI Solution - Alignée sur les standards ISO</p>
</footer>

</body>
</html>