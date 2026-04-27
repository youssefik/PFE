<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Journal d'Amélioration Sécurité | ISO 27001</title>
    <!-- CSS Dependencies -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; overflow: hidden; }
        .main-container { height: 100vh; display: flex; flex-direction: column; }

        /* Barre d'action style Corporate */
        .action-bar {
            background: white; padding: 15px 25px;
            border-bottom: 4px solid #D2010D;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        #hot-container-wrapper { flex-grow: 1; position: relative; padding: 20px; }
        #hot-container { width: 100%; height: 100%; background: white; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }

        /* Handsontable Styling pour correspondre à ton image */
        .handsontable th {
            background-color: #f2f2f2 !important;
            color: #333 !important;
            font-weight: bold !important;
            border: 1px solid #ccc !important;
        }

        /* Classes de statut dynamiques */
        .status-nok { background-color: #D2010D !important; color: white !important; font-weight: bold; text-align: center; }
        .status-ok { background-color: #C6EFCE !important; color: #006100 !important; font-weight: bold; text-align: center; }
    </style>
</head>
<body>

<div class="main-container">
    <div class="action-bar d-flex justify-content-between align-items-center">
        <div>
            <h5 class="mb-0 fw-bold"><i class="bi bi-arrow-repeat text-danger"></i> Journal d'amélioration continue (PDCA)</h5>
            <small class="text-muted">Synchronisation bidirectionnelle : Base de Données <-> Excel</small>
        </div>
        <div class="d-flex gap-2">
            <button onclick="saveData()" class="btn btn-success btn-sm px-4 fw-bold">
                <i class="bi bi-cloud-arrow-up-fill"></i> ENREGISTRER & SYNC
            </button>
            <a href="/dashboard" class="btn btn-secondary btn-sm px-3">
                <i class="bi bi-house-door"></i> Quitter
            </a>
        </div>
    </div>

    <div id="hot-container-wrapper">
        <div id="hot-container"></div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>

<script>
    let hot;
    const colHeaders = [
        'Numéro', 'Action corrective/amélioration', "Date d'enregistrement",
        "Responsable d'Action", "Analyse de cause", "Statut de l'action",
        "Date de clôture", "Efficacité de l'action"
    ];

    // RENDERER PERSONNALISÉ POUR LES COULEURS (OK/NOK)
    function customRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);

        // Si on est sur la colonne Statut (Index 5)
        if (col === 5) {
            if (value === 'NOK') {
                td.className = 'status-nok';
            } else if (value === 'OK') {
                td.className = 'status-ok';
            }else if (value == 'EN_COURS') {
                td.style.backgroundColor = '#FFF3CD'; // Jaune clair pour EN_COURS
                td.style.color = '#856404';
                td.style.fontWeight = 'bold';
                td.style.textAlign = 'center';
            }
        }

        if (col === 7) {
            if (value === 'NOK') {
                td.className = 'status-nok';
            } else if (value === 'OK') {
                td.className = 'status-ok';
            }else if (value == 'EN_COURS') {
                td.style.backgroundColor = '#FFF3CD'; // Jaune clair pour EN_COURS
                td.style.color = '#856404';
                td.style.fontWeight = 'bold';
                td.style.textAlign = 'center';
            }
        }
        td.style.verticalAlign = 'middle';
    }

    // Fonction de rendu pour gérer les retours à la ligne (\n)
    function htmlRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        if (value) {
            // Remplace les \n par des balises <br> pour l'affichage HTML
            td.style.whiteSpace = 'pre-line';
            td.style.fontSize = '11px';
        }
    }

    // CHARGEMENT INITIAL
    fetch('/compliance/improvement/data')
        .then(res => res.json())
        .then(data => {
            const container = document.getElementById('hot-container');
            hot = new Handsontable(container, {
                data: data,
                colHeaders: colHeaders,
                rowHeaders: true,
                stretchH: 'all',
                height: '100%',
                autoWrapRow: true,
                manualColumnResize: true,
                licenseKey: 'non-commercial-and-evaluation',
                contextMenu: true, // Permet d'ajouter/supprimer des lignes
                columns: [
                    { data: 'numero', width: 60 },
                    {
                        data: 'action',
                        width: 300,
                        className: 'htMiddle',
                        renderer: htmlRenderer // Permet l'affichage multi-ligne
                    },
                    {
                        data: 'dateBesoin',
                        width: 130,
                        className: 'htCenter htMiddle',
                        renderer: htmlRenderer
                    },
                    { data: 'responsable', width: 120 },
                    {
                        data: 'analyseCause',
                        width: 250,
                        renderer: htmlRenderer
                    },
                    { data: 'statut', type: 'dropdown', source: ['OK', 'NOK', 'EN_COURS'], width: 100 },
                    { data: 'dateCloture', width: 120 },
                    { data: 'efficacite', width: 150 }
                ],

                /*
                                columns: [
                                    { data: 'numero', width: 60 },
                                    {
                                        data: 'action',
                                        width: 300,
                                        renderer: function(instance, td, row, col, prop, value, cellProperties) {
                                            Handsontable.renderers.TextRenderer.apply(this, arguments);
                                            td.style.whiteSpace = 'pre-line'; // Respecte les sauts de ligne \n
                                        }
                                    },
                                    {
                                        data: 'dateBesoin',
                                        width: 120,
                                        renderer: function(instance, td, row, col, prop, value, cellProperties) {
                                            Handsontable.renderers.TextRenderer.apply(this, arguments);
                                            td.style.whiteSpace = 'pre-line';
                                            td.style.color = '#0056b3'; // Optionnel : Bleu pour les dates
                                        }
                                    },
                                    { data: 'responsable', width: 120 },
                                    { data: 'analyseCause', width: 250 },
                                    { data: 'statut', type: 'dropdown', source: ['OK', 'NOK'], width: 100 },
                                    { data: 'dateCloture', width: 120 },
                                    { data: 'efficacite', width: 150 }
                                ],
                */

                cells: function() {
                    return { renderer: customRenderer };
                }
            });
        });

    const defaultRow = {
        numero: '',
        action: '',
        dateBesoin: '',
        responsable: '',
        analyseCause: '',
        statut: 'EN_COURS', // <--- Force EN_COURS ici
        dateCloture: '',
        efficacite: ''
    };



    function saveData() {
        const tableData = hot.getData();
        // Transformation des lignes en objets JSON mappés par clé
        const payload = tableData.map(row => ({
            numero: row[0],
            action: row[1],
            dateBesoin: row[2],
            responsable: row[3],
            analyseCause: row[4],
            statut: row[5],
            dateCloture: row[6],
            efficacite: row[7]
        }));

        fetch('/compliance/improvement/save', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(payload)
        })
            .then(res => res.text())
            .then(msg => {
                if (msg === "SUCCESS") {
                    alert("✅ Journal sauvegardé en Base de Données et synchronisé avec Journal_Amelioration.xlsx");
                    location.reload();
                } else {
                    alert("❌ Erreur : " + msg);
                }
            });
    }
</script>

</body>
</html>