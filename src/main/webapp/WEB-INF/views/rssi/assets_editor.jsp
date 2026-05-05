<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Éditeur de Cartographie du Patrimoine">

    <%-- Imports spécifiques à Handsontable --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">

    <style>
        /* Conteneur pour l'éditeur avec calcul de hauteur dynamique */
        .hot-wrapper {
            height: calc(100vh - 220px);
            min-height: 550px;
            background: white;
            position: relative;
        }

        #hot-container { width: 100%; height: 100%; }

        /* Style des entêtes calqué sur EBIOS RM */
        .handsontable th {
            background-color: #5D6D7E !important;
            color: white !important;
            font-weight: bold !important;
            font-size: 11px !important;
            border: 1px solid #444 !important;
            vertical-align: middle !important;
        }

        /* Colonnes DIC (Besoins de sécurité) en Rouge */
        .header-dic { background-color: #D2010D !important; }

        /* Colonnes Supports en Bleu sombre */
        .header-sup { background-color: #34495E !important; }

        /* Cellules de données */
        .handsontable td { vertical-align: middle !important; border: 1px solid #dee2e6 !important; font-size: 12px; }
        .dic-value { font-weight: 800; text-align: center; background-color: #FDF2F2 !important; color: #D2010D !important; }

        /* Fix pour le centrage horizontal des headers AdminLTE compatibles */
        .htCenter { text-align: center !important; }
    </style>

    <div class="card card-outline card-danger shadow-sm">
        <div class="card-header border-bottom">
            <h3 class="card-title mt-1">
                <i class="fas fa-boxes mr-2 text-danger"></i>
                <strong>Ateliers 1 & 2 : Missions & Actifs Supports</strong>
                <small class="ml-2 text-muted d-none d-md-inline">| Méthode EBIOS RM</small>
            </h3>

            <div class="card-tools d-flex">
                <button onclick="saveAssets()" class="btn btn-success font-weight-bold mr-2 shadow-sm px-4">
                    <i class="fas fa-save mr-2"></i> ENREGISTRER & SYNC
                </button>
                <div class="btn-group">
                    <a href="/rssi/actifs" class="btn btn-outline-dark">
                        <i class="fas fa-list-ul mr-1"></i> Consulter l'Inventaire
                    </a>
                </div>
            </div>
        </div>

        <div class="card-body p-0">
            <div id="hot-container-wrapper" class="hot-wrapper">
                <div id="hot-container"></div>
            </div>
        </div>

        <div class="card-footer bg-light py-2">
            <div class="row">
                <div class="col-md-8 text-muted small italic">
                    <i class="fas fa-mouse-pointer mr-1"></i> Double-cliquez pour éditer une cellule. Utilisez le clic-droit pour ajouter des lignes métier.
                </div>
                <div class="col-md-4 text-right">
                    <span class="badge badge-secondary px-2">Format: DIC (1-4)</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts Handsontable -->
    <script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>

    <script>
        let hot;
        const container = document.getElementById('hot-container');

        const nestedHeaders = [
            ['Activité', 'Processus', 'Actif informationnel', {label: 'Besoin de sécurité (DIC)', colspan: 3}, {label: 'Description Actifs Supports', colspan: 5}, 'Evènement redouté'],
            ['', '', '', 'D', 'I', 'C', 'Logiciel', 'Matériel', 'Personnel', 'Local', 'Réseau', '']
        ];

        const columns = [
            { data: 'activite', width: 80, className: 'htCenter font-weight-bold' },
            { data: 'processus', width: 140 },
            { data: 'nom', width: 180, className: 'font-weight-bold text-dark' },
            { data: 'd', type: 'numeric', width: 40, className: 'dic-value' },
            { data: 'i', type: 'numeric', width: 40, className: 'dic-value' },
            { data: 'c', type: 'numeric', width: 40, className: 'dic-value' },
            { data: 'logiciel', width: 130 },
            { data: 'materiel', width: 130 },
            { data: 'personnel', width: 110 },
            { data: 'local', width: 100 },
            { data: 'reseau', width: 100 },
            { data: 'impact', width: 250, className: 'small' }
        ];

        fetch('/rssi/assets-editor/data')
            .then(res => res.json())
            .then(data => {
                hot = new Handsontable(container, {
                    data: data,
                    colHeaders: true,
                    rowHeaders: true,
                    nestedHeaders: nestedHeaders,
                    columns: columns,
                    stretchH: 'all',
                    height: '100%',
                    autoWrapRow: true,
                    manualColumnResize: true,
                    licenseKey: 'non-commercial-and-evaluation',
                    contextMenu: true,
                    afterGetColHeader: function(col, TH) {
                        // Coloration spécifique des colonnes EBIOS
                        if (col >= 3 && col <= 5) {
                            TH.style.backgroundColor = '#D2010D'; // Rouge pour le besoin de sécu
                            TH.style.color = 'white';
                        }
                        if (col >= 6 && col <= 10) {
                            TH.style.backgroundColor = '#34495E'; // Bleu pour les supports
                            TH.style.color = 'white';
                        }
                    }
                });
            });

        function saveAssets() {
            const btn = event.target;
            const originalHtml = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Sauvegarde...';
            btn.disabled = true;

            const tableData = hot.getData();
            const payload = tableData.map(row => ({
                activite: row[0],
                processus: row[1],
                nom: row[2],
                d: row[3],
                i: row[4],
                c: row[5],
                logiciel: row[6],
                materiel: row[7],
                personnel: row[8],
                local: row[9],
                reseau: row[10],
                impact: row[11]
            }));

            fetch('/rssi/assets-editor/save', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(payload)
            }).then(res => res.text()).then(msg => {
                if(msg.includes("SUCCESS")) {
                    alert("✅ Cartographie sauvegardée avec succès.");
                    location.reload();
                } else {
                    alert("❌ Erreur : " + msg);
                    btn.innerHTML = originalHtml;
                    btn.disabled = false;
                }
            }).catch(err => {
                alert("Erreur de communication avec le serveur.");
                btn.innerHTML = originalHtml;
                btn.disabled = false;
            });
        }
    </script>

</t:layout>

<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Éditeur d'Inventaire EBIOS | Corporate SMSI</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { background-color: #f1f3f5; font-family: 'Inter', sans-serif; overflow: hidden; }
        .main-container { height: 100vh; display: flex; flex-direction: column; }

        .header-pro { background: white; padding: 15px 30px; border-bottom: 4px solid #D2010D; }

        /* Grillage Style IMAGE EXCEL */
        #hot-container { background: white; }
        .handsontable th {
            background-color: #5D6D7E !important; color: white !important;
            font-weight: bold !important; font-size: 11px !important;
            border: 1px solid #444 !important;
        }
        .header-dic { background-color: #D2010D !important; }
        .header-sup { background-color: #34495E !important; }

        /* Cellules de données */
        .handsontable td { vertical-align: middle !important; border: 1px solid #ccc !important; font-size: 12px; }
        .dic-value { font-weight: 800; text-align: center; background-color: #FDF2F2 !important; }
    </style>
</head>
<body>

<div class="main-container">
    <div class="header-pro d-flex justify-content-between align-items-center">
        <div>
            <h4 class="mb-0 fw-bold"><i class="bi bi-box-seam text-danger"></i> Cartographie du Patrimoine (Asset Mapping)</h4>
            <p class="text-muted small mb-0">Atelier 1 & 2 : Missions, Processus et Actifs Supports</p>
        </div>
        <div class="btn-group gap-2">
            <button onclick="saveAssets()" class="btn btn-success px-4 fw-bold shadow-sm">
                <i class="bi bi-cloud-check-fill"></i> ENREGISTRER & SYNC
            </button>
            <a href="/rssi/actifs" class="btn btn-outline-dark">Consulter l'Inventaire</a>
            <a href="/dashboard" class="btn btn-secondary">Retour</a>
        </div>
    </div>

    <div id="hot-container-wrapper" class="flex-grow-1 p-3">
        <div id="hot-container"></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>

<script>
    let hot;
    const container = document.getElementById('hot-container');

    const nestedHeaders = [
        ['Activité', 'Processus', 'Actif informationnel', {label: 'Besoin de sécurité', colspan: 3}, {label: 'Description Actifs Supports', colspan: 5}, 'Evènement redouté'],
        ['', '', '', 'D', 'I', 'C', 'Logiciel', 'Matériel', 'Personnel', 'Local', 'Réseau', '']
    ];

    const columns = [
        { data: 'activite', width: 80, className: 'htCenter fw-bold' },
        { data: 'processus', width: 140 },
        { data: 'nom', width: 180, className: 'fw-bold' },
        { data: 'd', type: 'numeric', width: 35, className: 'dic-value text-danger' },
        { data: 'i', type: 'numeric', width: 35, className: 'dic-value text-danger' },
        { data: 'c', type: 'numeric', width: 35, className: 'dic-value text-danger' },
        { data: 'logiciel', width: 130 },
        { data: 'materiel', width: 130 },
        { data: 'personnel', width: 100 },
        { data: 'local', width: 100 },
        { data: 'reseau', width: 100 },
        { data: 'impact', width: 250, className: 'small' }
    ];

    fetch('/rssi/assets-editor/data')
        .then(res => res.json())
        .then(data => {
            hot = new Handsontable(container, {
                data: data,
                colHeaders: true,
                rowHeaders: true,
                nestedHeaders: nestedHeaders,
                columns: columns,
                stretchH: 'all',
                height: '100%',
                autoWrapRow: true,
                manualColumnResize: true,
                licenseKey: 'non-commercial-and-evaluation',
                contextMenu: true,
                afterGetColHeader: function(col, TH) {
                    // Application des couleurs sur les headers imbriqués
                    if (col >= 3 && col <= 5) TH.style.backgroundColor = '#D2010D'; // Rouge DIC
                    if (col >= 6 && col <= 10) TH.style.backgroundColor = '#34495E'; // Bleu Supports
                }
            });
        });

    function saveAssets() {
        const tableData = hot.getData();
        const payload = tableData.map(row => ({
            activite: row[0],
            processus: row[1],
            nom: row[2],
            d: row[3],
            i: row[4],
            c: row[5],
            logiciel: row[6],
            materiel: row[7],
            personnel: row[8],
            local: row[9],
            reseau: row[10],
            impact: row[11]
        }));

        fetch('/rssi/assets-editor/save', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(payload)
        }).then(res => res.text()).then(msg => {
            if(msg.includes("SUCCESS")) alert("✅ Inventaire sauvegardé en base de données !");
            else alert("❌ " + msg);
        });
    }
</script>
</body>
</html>--%>
