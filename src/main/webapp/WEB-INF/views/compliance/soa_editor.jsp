<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Éditeur Professionnel SoA">

    <%-- Imports spécifiques à Handsontable --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">

    <style>
        /* Conteneur pour maximiser la visibilité de l'éditeur */
        .editor-wrapper {
            height: calc(100vh - 210px); /* Hauteur dynamique */
            min-height: 550px;
            background: white;
            position: relative;
        }

        #hot-container { width: 100%; height: 100%; }

        /* STYLE DES ENTÊTES GRISE (Excel Style) */
        .handsontable th {
            background-color: #e9ecef !important;
            color: #495057 !important;
            font-weight: bold !important;
            border: 1px solid #dee2e6 !important;
            vertical-align: middle !important;
        }

        /* LIGNES ROUGES ISO (Titres de sections) */
        .handsontable td.iso-chapter-row {
            background-color: #D2010D !important;
            color: white !important;
            font-weight: bold !important;
            text-transform: uppercase !important;
            border-bottom: 1px solid #000 !important;
        }

        /* CELLULES DE STATUT */
        .handsontable td.status-green {
            background-color: #C6EFCE !important;
            color: #006100 !important;
            font-weight: bold !important;
            text-align: center !important;
        }

        .handsontable td.status-red {
            background-color: #f8d7da !important;
            color: #721c24 !important;
            font-weight: bold !important;
            text-align: center !important;
        }

        .handsontable td { vertical-align: middle !important; border: 1px solid #dee2e6 !important; font-size: 12px; }
        .hiddenCol { display: none; }

        .htMiddle { vertical-align: middle !important; }
    </style>

    <div class="card card-outline card-danger shadow-sm">
        <div class="card-header border-bottom">
            <h3 class="card-title mt-1">
                <i class="fas fa-table mr-2 text-danger"></i>
                <strong>Registre de Conformité SoA</strong>
                <small class="ml-2 text-muted d-none d-sm-inline">| Edition directe (Excel Sync)</small>
            </h3>

            <div class="card-tools d-flex">
                <button onclick="saveData()" class="btn btn-success font-weight-bold mr-2 shadow-sm">
                    <i class="fas fa-save mr-1"></i> ENREGISTRER & SYNC
                </button>
                <div class="dropdown mr-2">
                    <button class="btn btn-outline-dark dropdown-toggle" type="button" data-toggle="dropdown">
                        <i class="fas fa-exchange-alt mr-1"></i> Synchronisation
                    </button>
                    <div class="dropdown-menu dropdown-menu-right">
                        <a class="dropdown-item" href="javascript:syncAction('/compliance/sync/import')">
                            <i class="fas fa-download mr-2 text-primary"></i> Importer d'Excel (DDA.xlsx)
                        </a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="/compliance/soa">
                            <i class="fas fa-eye mr-2"></i> Mode Lecture / Preuves
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="card-body p-0">
            <div id="hot-container-wrapper" class="editor-wrapper">
                <div id="hot-container"></div>
            </div>
        </div>

        <div class="card-footer bg-light py-2">
            <div class="row text-muted small">
                <div class="col-md-6 italic">
                    <i class="fas fa-info-circle mr-1 text-danger"></i> Utilisez le clic-droit pour ajouter/supprimer des lignes.
                </div>
                <div class="col-md-6 text-right font-weight-bold">
                    Standard : ISO/IEC 27001:2022
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts Handsontable -->
    <script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>

    <script>
        let hot;
        const colHeaders = ['Thème', 'Mesure de sécurité', 'Applicabilité', 'Justification', 'Preuve', 'Mise en place?', 'Responsable', 'StyleData'];

        function soaRenderer(instance, td, row, col, prop, value, cellProperties) {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            const dataRow = instance.getDataAtRow(row);
            const code = dataRow[0] ? dataRow[0].toString().trim() : "";
            const styleBD = dataRow[7] ? dataRow[7].toString() : "";

            td.className = 'htMiddle';
            td.style.backgroundColor = '';
            td.style.color = '';

            // 1. Titres de sections (Chapitres ISO)
            if (code && (code.includes(",") || !code.includes("."))) {
                td.classList.add('iso-chapter-row');
            }
            // 2. OUI/NON/EN COURS
            else if ((col === 2 || col === 5)) {
                if (value === "OUI" || value === "Oui") td.classList.add('status-green');
                else if (value === "NON" || value === "Non") td.classList.add('status-red');
                else if (value === "EN COURS") {
                    td.style.backgroundColor = '#FFF3CD';
                    td.style.color = '#856404';
                    td.style.fontWeight = 'bold';
                    td.style.textAlign = 'center';
                }
            }

            // Wrapping
            if (col === 1 || col === 3 || col === 4) td.style.whiteSpace = 'normal';
        }

        // Chargement dynamique
        fetch('/compliance/editor/data')
            .then(res => res.json())
            .then(data => {
                if (data.length > 0 && (data[0][0] === "Thème")) data.shift();

                const container = document.getElementById('hot-container');
                hot = new Handsontable(container, {
                    data: data,
                    colHeaders: colHeaders,
                    rowHeaders: true,
                    stretchH: 'all',
                    height: '100%',
                    manualColumnResize: true,
                    contextMenu: true,
                    mergeCells: true,
                    licenseKey: 'non-commercial-and-evaluation',
                    columns: [
                        { width: 70 }, // Thème
                        { width: 280 }, // Mesure
                        { type: 'dropdown', source: ['OUI', 'NON'], width: 100 },
                        { width: 300 }, // Justification
                        { width: 250 }, // Preuve
                        { type: 'dropdown', source: ['OUI', 'NON', 'EN COURS'], width: 100 },
                        { width: 120 }, // Responsable
                        { width: 0.1, className: 'hiddenCol' }
                    ],
                    cells: function() { return { renderer: soaRenderer }; },
                    afterInit: function() { applyDynamicMerges(this); }
                });
            });

        function applyDynamicMerges(instance) {
            const d = instance.getData();
            let merges = [];
            for(let i=0; i<d.length; i++) {
                let code = d[i][0] ? d[i][0].toString() : "";
                if (code && (code.includes(",") || !code.includes("."))) {
                    merges.push({ row: i, col: 0, rowspan: 1, colspan: 7 });
                }
            }
            instance.updateSettings({ mergeCells: merges });
        }

        function saveData() {
            const btn = event.target;
            const originalHtml = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Sync...';
            btn.disabled = true;

            const payload = [colHeaders, ...hot.getData()];

            fetch('/compliance/editor/save', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(payload)
            }).then(res => {
                alert("✅ Registre SoA sauvegardé et synchronisé !");
                location.reload();
            }).catch(err => {
                alert("Erreur réseau");
                btn.innerHTML = originalHtml;
                btn.disabled = false;
            });
        }

        function syncAction(url) {
            if(confirm("Lancer l'importation ? Cela mettra à jour la BD à partir du fichier Excel.")) {
                fetch(url).then(res => res.text()).then(msg => { alert(msg); location.reload(); });
            }
        }
    </script>
</t:layout>

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>SoA ISO 27001 - Édition Professionnelle</title>

    <!-- CSS Dependencies -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Inter, sans-serif; }
        #hot-container { height: 75vh; width: 100%; margin-top: 10px; background: white; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }

        /* HEADER GRILLAGE (Style Excel Image) */
        .handsontable th {
            background-color: #a6a6a6 !important; /* Gris entête */
            color: white !important;
            font-weight: bold !important;
            border: 1px solid #777 !important;
            vertical-align: middle !important;
        }

        /* LIGNES ROUGES ISO (Titres de sections) */
        .handsontable td.iso-chapter-row {
            background-color: #D2010D !important; /* Le Rouge de votre image */
            color: white !important;
            font-weight: bold !important;
            text-transform: uppercase !important;
            border-bottom: 1px solid #000 !important;
        }

        /* CELLULES VERTES "OUI" */
        .handsontable td.status-green {
            background-color: #C6EFCE !important;
            color: #006100 !important;
            font-weight: bold !important;
            text-align: center !important;
        }

        .handsontable td.status-red {
            background-color: #b10f6b !important;
            color: #ffffff !important;
            font-weight: bold !important;
            text-align: center !important;
        }

        .handsontable td { vertical-align: middle !important; border: 1px solid #bfbfbf !important; font-size: 12px; }
        .hiddenCol { display: none; }

        .action-bar { background: white; padding: 15px; border-radius: 12px; margin-bottom: 10px; border-bottom: 4px solid #D2010D; }
    </style>
</head>
<body>

<div class="container-fluid p-4">
    <div class="action-bar d-flex justify-content-between align-items-center shadow-sm">
        <div>
            <h4 class="mb-0 fw-bold"><i class="bi bi-shield-check text-danger"></i> Registre de Conformité SoA</h4>
            <small class="text-muted">Structure basée sur le référentiel DDA.xlsx</small>
        </div>
        <div class="btn-group gap-2">
            <button onclick="saveData()" class="btn btn-success fw-bold px-4"><i class="bi bi-save"></i> ENREGISTRER (BD + EXCEL)</button>


                <button class="btn btn-outline-dark" onclick="syncAction('/compliance/sync/import')">
                    <i class="bi bi-upload"></i> IMPORTER DEPUIS EXCEL
                </button>

&lt;%&ndash;                <div class="dropdown">
                <button class="btn btn-outline-dark dropdown-toggle" data-bs-toggle="dropdown">Synchronisation</button>
                <ul class="dropdown-menu shadow">
                    <li><a class="dropdown-item" href="javascript:syncAction('/compliance/sync/export')">Sync vers Excel</a></li>
                    <li><a class="dropdown-item" href="javascript:syncAction('/compliance/sync/import')">Import depuis Excel</a></li>
                </ul>
            </div>&ndash;%&gt;
            <a href="/compliance/soa" class="btn btn-secondary px-3">Retour</a>
        </div>
    </div>

    <!-- Le Tableau -->
    <div id="hot-container"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>

<script>
    let hot;
    const colHeaders = ['Thème', 'Mesure de sécurité', 'Applicabilité', 'Justification', 'Preuve', 'Mise en place?', 'Responsable', 'StyleData'];

    function soaRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        const dataRow = instance.getDataAtRow(row);
        const code = dataRow[0] ? dataRow[0].toString().trim() : "";
        const styleBD = dataRow[7] ? dataRow[7].toString() : "";

        // Nettoyage avant application
        td.className = '';
        td.style.backgroundColor = '';
        td.style.color = '';

        // 1. Détection des lignes de titres (Ex: "5, MESURES...")
        // Une ligne de titre contient une virgule ou n'a pas de point
        if (code && (code.includes(",") || !code.includes("."))) {
            td.classList.add('iso-chapter-row');
        }
        // 2. Gestion des colonnes "OUI" (Indices 2 et 5)
        else if ((col === 2 || col === 5) && (value === "OUI" || value === "Oui")) {
            td.classList.add('status-green');
        }

        else if ((col === 2 || col === 5) && (value === "NON" || value === "NON")) {
            td.classList.add('status-red');
        }

        // 3. Application des styles personnalisés de la BD (si existent)
        if (!td.classList.contains('iso-chapter-row') && styleBD && styleBD.includes("|")) {
            const colors = styleBD.split('|');
            td.style.backgroundColor = colors[0];
            td.style.color = colors[1];
        }

        // Alignement et wrapping
        if (col === 1 || col === 3 || col === 4) td.style.whiteSpace = 'normal';
        td.style.verticalAlign = 'middle';
    }

    // Chargement dynamique
    fetch('/compliance/editor/data')
        .then(res => res.json())
        .then(data => {
            // Supprimer l'entête s'il vient dans les données JSON
            if (data.length > 0 && (data[0][0] === "Thème" || data[0][1] === "Mesure")) data.shift();

            const container = document.getElementById('hot-container');
            hot = new Handsontable(container, {
                data: data,
                colHeaders: colHeaders,
                rowHeaders: true,
                stretchH: 'all',
                manualColumnResize: true,
                contextMenu: true,
                mergeCells: true,
                licenseKey: 'non-commercial-and-evaluation',
                columns: [
                    { width: 70 }, // Thème
                    { width: 250 }, // Mesure
                    { type: 'dropdown', source: ['OUI', 'NON'], width: 100 }, // Applicabilité
                    { width: 300 }, // Justification
                    { width: 250 }, // Preuve
                    { type: 'dropdown', source: ['OUI', 'NON', 'EN COURS'], width: 100 }, // Mise en place
                    { width: 120 }, // Responsable
                    { width: 0.1, className: 'hiddenCol' } // StyleData caché
                ],
                cells: function() { return { renderer: soaRenderer }; },
                afterInit: function() {
                    applyDynamicMerges(this);
                }
            });
        });

    // Fonction de fusion pour les lignes rouges (Fusionne les 7 premières colonnes)
    function applyDynamicMerges(instance) {
        const d = instance.getData();
        let merges = [];
        for(let i=0; i<d.length; i++) {
            let code = d[i][0] ? d[i][0].toString() : "";
            if (code && (code.includes(",") || !code.includes("."))) {
                merges.push({ row: i, col: 0, rowspan: 1, colspan: 7 });
            }
        }
        instance.updateSettings({ mergeCells: merges });
    }


    function saveData() {
        // hot.getData() renvoie les lignes sans l'en-tête graphique rouge
        const tableContent = hot.getData();

        // On n'ajoute colHeaders QUE si le Java ne l'attend pas.
        // Ici, le Java l'attend pour faire son filtre.
        const payload = [colHeaders, ...tableContent];

        fetch('/compliance/editor/save', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(payload)
        }).then(res => {
            alert("✅ Sauvegarde effectuée. Rechargez la page.");
            location.reload(); // Obligatoire pour recalculer les fusions propres
        });
    }

/*
    function saveData() {
        // Récupérer TOUTES les données du tableau
        const tableData = hot.getData();

        // Construire le payload complet (En-tête + Données)
        const payload = [colHeaders, ...tableData];

        fetch('/compliance/editor/save', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
            .then(res => res.text())
            .then(msg => {
                if(msg.includes("SUCCESS")) {
                    alert("✅ Données sauvegardées et nouveau contrôle créé si nécessaire !");
                    // Optionnel: Recharger les données pour voir l'ID généré en base
                    location.reload();
                } else {
                    alert("❌ Erreur : " + msg);
                }
            });
    }
*/

/*    function saveData() {
        const fullData = [colHeaders, ...hot.getData()];

        // Validation basique (Si NON sans justification)
        const allRows = hot.getData();
        for (let i = 0; i < allRows.length; i++) {
            if (allRows[i][0] && allRows[i][0].includes(".") && allRows[i][2] === "NON") {
                if (!allRows[i][3] || allRows[i][3].length < 5) {
                    alert("L'ISO 27001 exige une justification pour chaque contrôle non-applicable (Ligne " + (i+1) + ")");
                    return;
                }
            }
        }

        fetch('/compliance/editor/save', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(fullData)
        }).then(res => res.text()).then(msg => {
            if(msg.includes("SUCCESS")) alert("✅ Registre sauvegardé et synchronisé !");
            else alert("❌ Erreur : " + msg);
        });
    }*/

    function applyColorToSelection(bg, text) {
        const sel = hot.getSelected();
        if (!sel) return;
        const style = bg ? (bg + "|" + text) : "";
        for (let r = Math.min(sel[0][0], sel[0][2]); r <= Math.max(sel[0][0], sel[0][2]); r++) {
            hot.setDataAtCell(r, 7, style);
        }
    }

    function syncAction(url) {
        if(confirm("Lancer l'opération sur le fichier Excel ?")) {
            fetch(url).then(res => res.text()).then(msg => { alert(msg); location.reload(); });
        }
    }
</script>
</body>
</html>
--%>

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>SoA Professional Editor - ISO 27001</title>
    <!-- CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@0.34.0/dist/handsontable.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { background-color: #f1f3f5; font-family: 'Segoe UI', sans-serif; }
        #hot-container { height: 78vh; width: 100%; margin-top: 5px; background: white; box-shadow: 0 10px 40px rgba(0,0,0,0.1); }

        .handsontable th {
            background-color: #FF0000 !important;
            color: white !important;
            font-weight: bold !important;
            text-align: center !important;
            vertical-align: middle !important;
            border: 1px solid #000 !important;
        }

        /* PRIORITÉ ABSOLUE AU VERT POUR LA COLONNE 0 */
        .handsontable td.objective-cell {
            background-color: #C6EFCE !important; /* Vert */
            color: #006100 !important;
            writing-mode: vertical-rl !important;
            transform: rotate(180deg) !important;
            text-align: center !important;
            vertical-align: middle !important;
            font-weight: bold !important;
            white-space: normal !important;
            border: 1px solid #000 !important;
        }



        /* STYLE JAUNE UNIQUEMENT SI PAS COLONNE 0 */
        .handsontable td.title-row-cell {
            background-color: #FFF2CC !important; /* Jaune */
            color: #843C0C !important;
            font-weight: bold !important;
            border-right: none !important;
        }

        .handsontable td { vertical-align: middle !important; border: 1px solid #000 !important; padding: 8px !important; font-size: 12px; }
        .handsontable .hiddenCol { display: none; }



        .handsontable td.title-row-cell:first-child { border-left: 1px solid #000 !important; }
        .handsontable td.title-row-cell:last-child { border-right: 1px solid #000 !important; }


        .action-bar {
            background: white; padding: 15px; border-radius: 12px;
            margin-bottom: 10px; border-bottom: 4px solid #dc3545;
        }
    </style>
</head>
<body>

<div class="container-fluid p-4">
    <div class="action-bar d-flex justify-content-between align-items-center shadow-sm">
        <div>
            <h4 class="mb-0 fw-bold text-dark"><i class="bi bi-shield-lock text-danger"></i> Éditeur de Conformité SoA</h4>
            <p class="text-muted small mb-0">Saisie libre autorisée pour les Objectifs | Fusions auto</p>
        </div>
        <div class="btn-group gap-2">
            <button onclick="saveData()" class="btn btn-success px-4 shadow-sm">
                <i class="bi bi-cloud-check-fill"></i> Sauvegarder
            </button>

            <div class="dropdown">
                <button class="btn btn-primary dropdown-toggle shadow-sm" type="button" data-bs-toggle="dropdown">
                    <i class="bi bi-palette"></i> Couleur sélection
                </button>
                <ul class="dropdown-menu shadow">
                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="applyColorToSelection('#007bff', '#ffffff')"><i class="bi bi-square-fill text-primary me-2"></i>Bleu</a></li>
                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="applyColorToSelection('#dc3545', '#ffffff')"><i class="bi bi-square-fill text-danger me-2"></i>Rouge</a></li>
                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="applyColorToSelection('#28a745', '#ffffff')"><i class="bi bi-square-fill text-success me-2"></i>Vert</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="applyColorToSelection('', '')">Réinitialiser</a></li>
                </ul>
            </div>

            <div class="dropdown">
                <button class="btn btn-outline-dark dropdown-toggle shadow-sm" type="button" data-bs-toggle="dropdown">
                    <i class="bi bi-file-earmark-spreadsheet"></i> Synchronisation Excel
                </button>
                <ul class="dropdown-menu shadow">
                    <li><a class="dropdown-item" href="javascript:syncAction('/compliance/sync/export')"><i class="bi bi-download me-2"></i>Exporter</a></li>
                    <li><a class="dropdown-item" href="javascript:syncAction('/compliance/sync/import')"><i class="bi bi-upload me-2"></i>Importer</a></li>
                </ul>
            </div>

            <a href="/dashboard" class="btn btn-secondary px-3 shadow-sm"><i class="bi bi-arrow-left-circle"></i> Retour</a>
        </div>
    </div>

    <div id="hot-container"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/handsontable@0.34.0/dist/handsontable.min.js"></script>

<script>
    let hot;
    const colHeaders = ['Objectifs', 'Contrôle', 'Mesure du contrôle', 'Applicabilité', 'Justification', 'En place?', 'Dispositif', 'Responsable', 'StyleData'];

/*    const chapterMap = {
        "5": "5 - Politiques de sécurité", "6": "6 - Organisation de la sécurité",
        "7": "7 - Sécurité des RH", "8": "8 - Gestion des actifs", "9": "9 - Contrôle d'accès"
    };*/

    // Remplacez votre chapterMap dans soa_editor.jsp
    const chapterMap = {
        "5": "A.5 Organisationnels",
        "6": "A.6 Personnes",
        "7": "A.7 Physiques",
        "8": "A.8 Technologiques"
    };

    // Amélioration de la sauvegarde (Mandatory Justification)
    function saveData() {
        const allData = hot.getData();

        // FILTRAGE : On ne garde que les lignes qui sont de VRAIS contrôles
        const filteredData = allData.filter((row, index) => {
            const code = row[1] ? row[1].toString().trim() : "";

            // 1. Ignorer si le code est vide ou est l'en-tête "Code"
            if (code === "" || code === "Contrôle" || code === "Code") return false;

            // 2. LOGIQUE CLÉ : Les lignes de titre comme "5.1" ont un seul point
            // donc leur longueur après split('.') est de 2.
            // Les vrais contrôles comme "5.1.1" ou "A.5.1" ont au moins deux points (longueur >= 3).
            const codeParts = code.split('.');
            if (codeParts.length < 3) {
                console.log("Ligne de titre ignorée pour la sauvegarde :", code);
                return false;
            }

            // 3. (Optionnel) Vérification supplémentaire : Si applicabilité et justification sont vides, on n'enregistre pas
            const applicable = row[3];
            if (!applicable) return false;

            return true;
        });

        console.log("Nombre de lignes envoyées au serveur :", filteredData.length);

        // Validation des exclusions (on utilise filteredData maintenant)
        for (let i = 0; i < filteredData.length; i++) {
            const code = filteredData[i][1];
            const applicable = filteredData[i][3];
            const justification = filteredData[i][4];

            if (applicable === 'Non' && (!justification || justification.trim().length < 5)) {
                alert("⚠️ Erreur sur " + code + " : Une justification est obligatoire pour une exclusion.");
                return;
            }
        }

        // On envoie les headers + les données filtrées
        const payload = [colHeaders, ...filteredData];

        fetch('/compliance/editor/save', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(payload)
        })
            .then(res => res.text())
            .then(msg => {
                if(msg.includes("SUCCESS")) alert("✅ Données enregistrées ! (Lignes de titres exclues)");
                else alert("❌ Erreur : " + msg);
            });
    }


    // --- ALGORITHME DE FUSION DYNAMIQUE ---
    function calculateMerges(data) {
        let merges = [];
        let currentChapter = null;
        let startRow = 0;

        for (let i = 0; i < data.length; i++) {
            let code = data[i][1] ? data[i][1].toString().trim() : "";
            let objManual = data[i][0] ? data[i][0].toString().trim() : "";

            // On considère un nouveau bloc si le premier chiffre change
            // OU si l'utilisateur a saisi manuellement un texte dans la colonne 0
            let chapter = code.split('.')[0];

            if (chapter !== currentChapter || (objManual !== "" && i !== startRow)) {
                if (currentChapter !== null && i - startRow > 0) {
                    merges.push({ row: startRow, col: 0, rowspan: i - startRow, colspan: 1 });
                }
                currentChapter = chapter;
                startRow = i;
            }

            // Fusion Horizontale pour titres X.X (Colonnes 2 à 7)
            if (code !== "" && code.split('.').length === 2) {
                merges.push({ row: i, col: 2, rowspan: 1, colspan: 6 });
            }
        }
        // Bloc final
        if (data.length - startRow > 0) merges.push({ row: startRow, col: 0, rowspan: data.length - startRow, colspan: 1 });
        return merges;
    }


    function soaRenderer(instance, td, row, col, prop, value, cellProperties) {
        if (cellProperties.type === 'dropdown') {
            Handsontable.renderers.DropdownRenderer.apply(this, arguments);
        } else {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
        }

        const rowData = instance.getDataAtRow(row);
        const code = rowData[1] ? rowData[1].toString().trim() : "";
        const styleBD = rowData[8] ? rowData[8].toString() : "";

        // Nettoyage complet pour éviter les mélanges au scroll
        td.classList.remove('objective-cell', 'title-row-cell');
        td.style.backgroundColor = '';
        td.style.color = '';

        // --- LOGIQUE DE PRIORITÉ DES COULEURS ---

        // 1. PRIORITÉ SUPRÊME : Colonne 0 (Objectifs) -> Toujours Vert
        if (col === 0) {
            td.classList.add('objective-cell');
        }
        // 2. PRIORITÉ STYLE PERSONNALISÉ (BD) -> Uniquement si ce n'est pas la col 0
        else if (styleBD && styleBD.indexOf('|') > 0) {
            const colors = styleBD.split('|');
            td.style.backgroundColor = colors[0];
            td.style.color = colors[1];
            td.style.fontWeight = 'bold';
        }
        // 3. STYLE TITRE X.X -> Jaune (Uniquement si ce n'est pas la col 0)
        else if (code && code.split('.').length === 2) {
            td.classList.add('title-row-cell');
        }

        td.style.verticalAlign = 'middle';
        td.style.border = "1px solid #000";
    }

    function applyColorToSelection(bg, text) {
        const sel = hot.getSelected();
        if (!sel) return;
        const start = Math.min(sel[0], sel[2]);
        const end = Math.max(sel[0], sel[2]);
        const styleString = bg ? (bg + "|" + text) : "";
        for (let r = start; r <= end; r++) {
            hot.setDataAtCell(r, 8, styleString);
        }
        hot.render();
    }

    fetch('/compliance/editor/data')
        .then(res => res.json())
        .then(data => {
            if (data.length > 0 && (data[0][1] === "Contrôle" || data[0][1] === "Code")) data.shift();

            hot = new Handsontable(document.getElementById('hot-container'), {
                data: data,
                colHeaders: colHeaders,
                rowHeaders: true,
                height: '100%',
                width: '100%',
                stretchH: 'all',
                manualColumnResize: true,
                mergeCells: calculateMerges(data),
                contextMenu: {
                    items: {
                        "row_above": {}, "row_below": {}, "remove_row": {},
                        "sep1": "---------",
                        "alignment": {},
                        "sep2": "---------",
                        "make_blue": { name: '🔵 Bleu', callback: function() { applyColorToSelection("#007bff", "#ffffff"); }},
                        "make_red": { name: '🔴 Rouge', callback: function() { applyColorToSelection("#dc3545", "#ffffff"); }},
                        "reset": { name: '🔄 Reset Style', callback: function() { applyColorToSelection("", ""); }}
                    }
                },
                columns: [
                    { width: 65, readOnly: false }, // MAINTENANT MODIFIABLE
                    { width: 80 },
                    { width: 300 },
                    { type: 'dropdown', source: ['Oui', 'Non'], width: 90 },
                    { width: 350, className: 'htJustify' },
                    { type: 'dropdown', source: ['Oui', 'Non'], width: 90 },
                    { width: 250 },
                    { width: 140 },
                    { width: 0.1, className: 'hiddenCol' }
                ],
                cells: function(row, col) {
                    let cp = { renderer: soaRenderer };
                    let rowData = this.instance.getDataAtRow(row);
                    let code = rowData[1] ? rowData[1].toString().trim() : "";
                    if (code.split('.').length === 2 && col > 2 && col < 8) cp.readOnly = true;
                    return cp;
                },
                afterChange: function(changes, source) {
                    if (source === 'edit' || source === 'paste') {
                        // Recalcul des fusions après modification
                        this.updateSettings({ mergeCells: calculateMerges(this.getData()) });
                    }
                }
            });

            // Initialisation automatique des noms si vide
            const d = hot.getData();
            for(let i=0; i<d.length; i++) {
                let c = d[i][1] ? d[i][1].toString().split('.')[0] : "";
                if (c && chapterMap[c] && !d[i][0]) {
                    let merges = calculateMerges(d);
                    if (merges.find(m => m.row === i && m.col === 0)) {
                        hot.setDataAtCell(i, 0, chapterMap[c]);
                    }
                }
            }
        });

/*    function saveData() {
        const fullData = [colHeaders, ...hot.getData()];
        fetch('/compliance/editor/save', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(fullData)
        }).then(res => res.text()).then(msg => {
            if(msg.includes("SUCCESS")) alert("✅ Données enregistrées !");
        });
    }*/

    function syncAction(url) {
        if(confirm("Lancer la synchronisation ?")) {
            fetch(url).then(res => res.text()).then(msg => { alert(msg); location.reload(); });
        }
    }
</script>
</body>
</html>--%>
