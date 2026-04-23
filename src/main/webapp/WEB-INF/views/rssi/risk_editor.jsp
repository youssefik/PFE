<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>ISO 27005 - Registre des Risques</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        /* --- Styles inchangés --- */
        html, body { height: 100%; margin: 0; padding: 0; overflow: hidden; background-color: #f8f9fa; }
        .main-container { height: 100vh; display: flex; flex-direction: column; }
        .header-bar { height: 50px; background: #fff; padding: 0 20px; border-bottom: 2px solid #dc3545; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .filter-bar { height: 60px; background: #fff; padding: 0 20px; border-bottom: 1px solid #dee2e6; display: flex; align-items: center; gap: 15px; flex-shrink: 0; }
        #hot-container-wrapper { flex-grow: 1; position: relative; width: 100%; overflow: hidden; }
        #hot-container { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .vertical-cat { background-color: #e8f5e9 !important; color: #1b5e20 !important; font-weight: bold !important; text-align: center !important; vertical-align: middle !important; border-right: 2px solid #2e7d32 !important; padding: 0 !important; }
        .cat-text { writing-mode: vertical-rl; transform: rotate(180deg); white-space: nowrap; display: inline-block; padding: 10px 5px; font-size: 11px; text-transform: uppercase; }
        .handsontable thead tr:nth-child(1) th { background-color: #c00000 !important; color: white !important; font-size: 14px; }
        .handsontable thead tr:nth-child(2) th { background-color: #002060 !important; color: white !important; font-size: 12px; }
        .handsontable thead tr:nth-child(3) th { background-color: #595959 !important; color: white !important; }
        .handsontable thead tr:nth-child(4) th { background-color: #bdd7ee !important; color: #002060 !important; font-size: 10px; }
        .risk-faible { background-color: #92d050 !important; text-align: center; font-weight: bold; }
        .risk-modere { background-color: #ffff00 !important; text-align: center; font-weight: bold; }
        .risk-significatif { background-color: #ffc000 !important; text-align: center; font-weight: bold; }
        .risk-critique { background-color: #ff0000 !important; color: white !important; text-align: center; font-weight: bold; }

        /* Toast */
        .toast-notif {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 9999;
            display: none;
            padding: 10px 20px;
            border-radius: 5px;
            color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="d-flex gap-2">
        <button class="btn btn-outline-dark btn-sm" onclick="openHistory()">
            <i class="bi bi-clock-history"></i> Historique des versions
        </button>
        <button class="btn btn-success btn-sm px-4" onclick="saveData()">
            <i class="bi bi-cloud-check"></i> Enregistrer
        </button>

        <a href="/rssi/risk-editor/sync-to-excel" class="btn btn-outline-success btn-sm shadow-sm">
            <i class="bi bi-arrow-repeat"></i> Sync BD -> Excel
        </a>
    </div>

    <!-- PANNEAU LATÉRAL : HISTORIQUE DES VERSIONS (Bootstrap 5 Offcanvas) -->
    <div class="offcanvas offcanvas-end" tabindex="-1" id="historyPanel" style="width: 400px;">
        <div class="offcanvas-header bg-dark text-white">
            <h5 class="offcanvas-title"><i class="bi bi-archive"></i> Versions Archivées</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
        </div>
        <div class="offcanvas-body p-0">
            <div class="list-group list-group-flush" id="historyList">
                <!-- Les versions seront injectées ici par JavaScript -->
                <div class="p-4 text-center text-muted">Chargement de l'historique...</div>
            </div>
        </div>
        <div class="offcanvas-footer p-3 bg-light border-top">
            <small class="text-muted italic"><i class="bi bi-info-circle"></i> Chaque enregistrement génère un fichier de traçabilité conforme ISO 27001.</small>
        </div>
    </div>
<%--
    <div class="header-bar">
        <h5 class="m-0 fw-bold"><i class="bi bi-shield-lock-fill text-danger"></i> Registre ISO 27005</h5>
        <button class="btn btn-success btn-sm px-4" onclick="saveData()">Enregistrer</button>
        <a href="/rssi/risk-editor/sync-to-excel" class="btn btn-outline-success btn-sm shadow-sm">
            <i class="bi bi-arrow-repeat"></i> Sync BD -> Excel
        </a>
    </div>
--%>
    <div class="filter-bar">
        <div class="input-group input-group-sm" style="width: 250px;">
            <span class="input-group-text"><i class="bi bi-search"></i></span>
            <input type="text" id="searchBox" class="form-control" placeholder="Rechercher..." oninput="applyFilters()">
        </div>
        <select id="filterCat" class="form-select form-select-sm" style="width: 220px;" onchange="applyFilters()">
            <option value="">Toutes les catégories</option>
        </select>
        <select id="filterRisk" class="form-select form-select-sm" style="width: 180px;" onchange="applyFilters()">
            <option value="">Tous les risques</option>
            <option value="critique">🔴 Critique (>35)</option>
            <option value="significatif">🟠 Significatif (24-35)</option>
            <option value="modere">🟡 Modéré (13-23)</option>
            <option value="faible">🟢 Faible (≤12)</option>
        </select>
        <button class="btn btn-outline-secondary btn-sm" onclick="resetFilters()">Réinitialiser</button>
        <span class="ms-auto badge bg-secondary" id="countLabel">Risques : 0</span>
    </div>
    <div id="hot-container-wrapper">
        <div id="hot-container"></div>
    </div>
</div>

<!-- Modal pour ajouter une catégorie -->
<div class="modal fade" id="categoryModal" tabindex="-1">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Ajouter une ligne avec catégorie</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <select id="categorySelect" class="form-select mb-2">
                    <option value="">Sélectionner une catégorie existante</option>
                </select>
                <div class="input-group">
                    <input type="text" id="newCategoryInput" class="form-control" placeholder="Ou nouvelle catégorie">
                    <button class="btn btn-outline-secondary" type="button" id="addNewCategoryBtn">Ajouter</button>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-primary" id="confirmCategory">OK</button>
            </div>
        </div>
    </div>
</div>

<!-- Toast -->
<div id="toast" class="toast-notif"></div>




<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>
<script>
    let hot;
    let allData = [];               // données brutes (toutes)
    let effectiveCategoriesAll = []; // catégories effectives pour allData
    let filteredData = [];          // données après filtrage
    let filteredEffective = [];     // catégories effectives pour filteredData
    let updating = false;           // flag pour éviter les boucles

    // Modal Bootstrap
    let categoryModal;

    // Valeur par défaut pour une nouvelle ligne
    const defaultRow = {
        categorie: '',
        menaces: '',
        origine: '',
        actifs: '',
        ref: '',
        proprio: '',
        scenario: '',
        vulner: '',
        d: 1,
        i: 1,
        c: 1,
        impOrg: 1,
        impJur: 1,
        impImg: 1,
        impFin: 1,
        proba: 1,
        grav: 1,
        scoreRes: 1,
        optionTrait: 'Traiter (réduire)',
        actions: '',
        besoinC: 1,
        probC: 1,
        gravC: 1,
        scoreCible: 1,
        optionApres: ''
    };

    // En-têtes imbriqués (identique)
    const nestedHeaders = [
        [{label: 'REGISTRE DES RISQUES DE SÉCURITÉ DE L\'INFORMATION', colspan: 25}],
        [{label: 'IDENTIFICATION DU RISQUE', colspan: 8}, {label: 'APPRÉCIATION DES RISQUES', colspan: 10}, {label: 'TRAITEMENT DU RISQUE', colspan: 7}],
        ['Catégorie', 'Menaces', 'Origine', 'Actifs', 'Réf.', 'Proprio', 'Scénario', 'Vulnérabilité', 'D','I','C', 'Imp.Org','Imp.Jur','Imp.Img','Imp.Fin', 'Prob.','Grav.','Score', 'Option', 'Actions', 'Bes.C','Prob.C','Grav.C','Score C', 'Fin'],
        ['', '', '', '', '', '', '', '', '','','', '','','','', '','','', '', '', '','','','', '']
    ];

    // ========== Fonctions utilitaires ==========
    function computeEffectiveCategories(data) {
        let effective = [];
        let lastValid = '';
        for (let i = 0; i < data.length; i++) {
            let cat = data[i].categorie;
            if (cat && typeof cat === 'string' && cat.trim() !== '') {
                lastValid = cat.trim();
            }
            effective.push(lastValid);
        }
        return effective;
    }

    function calculateMergesFromEffective(effective) {
        let merges = [];
        if (!effective.length) return merges;
        let start = 0;
        for (let i = 1; i <= effective.length; i++) {
            if (i === effective.length || effective[i] !== effective[start]) {
                if (i - start > 1) merges.push({ row: start, col: 0, rowspan: i - start, colspan: 1 });
                start = i;
            }
        }
        return merges;
    }

    function showToast(message, type = 'success') {
        const toast = document.getElementById('toast');
        toast.style.display = 'block';
        toast.style.backgroundColor = type === 'success' ? '#28a745' : (type === 'error' ? '#dc3545' : '#ffc107');
        toast.style.color = 'white';
        toast.textContent = message;
        setTimeout(() => { toast.style.display = 'none'; }, 3000);
    }

    // Mise à jour de l'affichage avec les données filtrées
    function refreshDisplay() {
        if (!hot) return;
        updating = true;
        hot.loadData(filteredData);
        hot.updateSettings({
            mergeCells: calculateMergesFromEffective(filteredEffective),
            effectiveCategories: filteredEffective
        });
        updating = false;
        document.getElementById('countLabel').innerText = 'Risques : ' + filteredData.length;
    }

    // Appliquer les filtres (catégorie, risque, recherche)
    function applyFilters() {
        const searchText = document.getElementById('searchBox').value.toLowerCase();
        let selectedCat = document.getElementById('filterCat').value;
        const selectedRisk = document.getElementById('filterRisk').value;
        if (selectedCat) selectedCat = selectedCat.trim();

        console.group('🔍 Application des filtres');
        console.log('Filtre catégorie :', selectedCat || 'aucun');
        console.log('Filtre risque    :', selectedRisk || 'aucun');
        console.log('Recherche texte  :', searchText || 'aucun');

        const indices = [];
        for (let i = 0; i < allData.length; i++) {
            const item = allData[i];
            const effCat = effectiveCategoriesAll[i];
            let ok = true;
            if (searchText && !JSON.stringify(item).toLowerCase().includes(searchText)) ok = false;
            if (ok && selectedCat && effCat !== selectedCat) ok = false;
            if (ok && selectedRisk) {
                const score = parseInt(item.scoreRes) || 0;
                if (selectedRisk === 'faible' && score > 12) ok = false;
                else if (selectedRisk === 'modere' && (score <= 12 || score > 23)) ok = false;
                else if (selectedRisk === 'significatif' && (score <= 23 || score > 35)) ok = false;
                else if (selectedRisk === 'critique' && score <= 35) ok = false;
            }
            if (ok) {
                indices.push(i);
                console.log(`✅ ${item.ref} (score=${item.scoreRes}, cat_eff="${effCat}")`);
            } else {
                console.log(`❌ ${item.ref} (score=${item.scoreRes}, cat_eff="${effCat}")`);
            }
        }
        filteredData = indices.map(i => allData[i]);
        filteredEffective = indices.map(i => effectiveCategoriesAll[i]);

        console.log(`📊 Données filtrées : ${filteredData.length} sur ${allData.length}`);
        console.groupEnd();

        refreshDisplay();
    }

    function resetFilters() {
        document.getElementById('searchBox').value = '';
        document.getElementById('filterCat').value = '';
        document.getElementById('filterRisk').value = '';
        applyFilters();
    }

    // ========== Fonctions d'édition des données ==========
    function insertRowAbove() {
        const selected = hot.getSelectedLast();
        if (!selected) {
            showToast('Veuillez sélectionner une ligne', 'warning');
            return;
        }
        const rowIndex = selected[0]; // index dans filteredData
        if (!filteredData[rowIndex]) return;
        const selectedRef = filteredData[rowIndex].ref;
        const originalIndex = allData.findIndex(d => d.ref === selectedRef);
        if (originalIndex === -1) return;

        const newRow = { ...defaultRow };
        newRow.categorie = effectiveCategoriesAll[originalIndex];
        allData.splice(originalIndex, 0, newRow);
        effectiveCategoriesAll = computeEffectiveCategories(allData);
        applyFilters();
        showToast('Ligne insérée au-dessus');
    }

    function insertRowBelow() {
        const selected = hot.getSelectedLast();
        if (!selected) {
            showToast('Veuillez sélectionner une ligne', 'warning');
            return;
        }
        const rowIndex = selected[0];
        if (!filteredData[rowIndex]) return;
        const selectedRef = filteredData[rowIndex].ref;
        const originalIndex = allData.findIndex(d => d.ref === selectedRef);
        if (originalIndex === -1) return;

        const newRow = { ...defaultRow };
        newRow.categorie = effectiveCategoriesAll[originalIndex];
        allData.splice(originalIndex + 1, 0, newRow);
        effectiveCategoriesAll = computeEffectiveCategories(allData);
        applyFilters();
        showToast('Ligne insérée en dessous');
    }


    function blurActiveElement() {
        if (document.activeElement && document.activeElement.blur) {
            document.activeElement.blur();
        }
    }

    function openCategoryModal() {
        blurActiveElement(); // 👈 retirer le focus
        const uniqueCats = [...new Set(effectiveCategoriesAll)].filter(c => c && c !== '').sort();
        const select = document.getElementById('categorySelect');
        select.innerHTML = '<option value="">Sélectionner une catégorie existante</option>';
        uniqueCats.forEach(c => select.add(new Option(c, c)));
        document.getElementById('newCategoryInput').value = '';
        categoryModal.show();
    }

    function generateRef(category) {
        // Prendre les 3 premiers caractères alphanumériques
        let prefix = category.replace(/[^a-zA-Z0-9]/g, '').toUpperCase().substring(0, 3);
        if (prefix.length < 3) prefix = prefix + "X";
        // Compter combien de refs commencent par ce préfixe
        let count = allData.filter(r => r.ref && r.ref.startsWith(prefix)).length + 1;
        return `${prefix}-${count}`;
    }

    function addRowWithCategory(category) {
        if (!category) {
            showToast('Veuillez choisir une catégorie', 'warning');
            return;
        }
        let insertIndex = allData.length;
        for (let i = allData.length - 1; i >= 0; i--) {
            if (effectiveCategoriesAll[i] === category) {
                insertIndex = i + 1;
                break;
            }
        }
        // const newRow = { ...defaultRow, categorie: category };
        const newRow = { ...defaultRow, categorie: category, ref: generateRef(category) };
        allData.splice(insertIndex, 0, newRow);
        effectiveCategoriesAll = computeEffectiveCategories(allData);
        applyFilters();
        showToast(`Ligne ajoutée avec catégorie "${category}"`);
    }

    // ========== Gestion du modal ==========
    document.getElementById('addNewCategoryBtn').addEventListener('click', function() {
        const newCat = document.getElementById('newCategoryInput').value.trim();
        if (newCat) {
            const select = document.getElementById('categorySelect');
            const option = document.createElement('option');
            option.value = newCat;
            option.textContent = newCat;
            option.selected = true;
            select.appendChild(option);
        }
    });

    let pendingCategory = null;



    document.getElementById('confirmCategory').addEventListener('click', function() {
        const select = document.getElementById('categorySelect');
        let category = select.value;
        const newCat = document.getElementById('newCategoryInput').value.trim();
        if (newCat) category = newCat;
        if (!category) {
            showToast('Veuillez choisir une catégorie', 'warning');
            return;
        }
        pendingCategory = category;
        // Déplacer le focus avant de fermer le modal
        document.body.focus();  // ou document.activeElement.blur()
        categoryModal.hide();
    });


    // Lorsque le modal a fini de se fermer, exécute l'ajout
    document.getElementById('categoryModal').addEventListener('hidden.bs.modal', function() {
        if (pendingCategory) {
            addRowWithCategory(pendingCategory);
            pendingCategory = null;
        }
    });
    // ========== Alignement ==========
    function applyAlignment(className) {
        const selected = hot.getSelected();
        if (!selected) return;
        const [startRow, startCol, endRow, endCol] = selected[0];
        for (let r = startRow; r <= endRow; r++) {
            for (let c = startCol; c <= endCol; c++) {
                let cellMeta = hot.getCellMeta(r, c);
                let classes = cellMeta.className ? cellMeta.className.split(' ') : [];
                classes = classes.filter(cls => !cls.startsWith('htLeft') && !cls.startsWith('htCenter') && !cls.startsWith('htRight') && !cls.startsWith('htJustify'));
                classes.push(className);
                hot.setCellMeta(r, c, 'className', classes.join(' '));
            }
        }
        hot.render();
        showToast('Alignement appliqué');
    }

    function propagateCategoriesToData() {
        let lastValid = '';
        for (let i = 0; i < allData.length; i++) {
            let cat = allData[i].categorie;
            if (cat && typeof cat === 'string' && cat.trim() !== '') {
                lastValid = cat.trim();
            }
            if (lastValid !== '') {
                allData[i].categorie = lastValid;
            }
        }
        console.log("🔄 Après propagation :", allData.map(d => ({ref: d.ref, cat: d.categorie})));
    }

    // ========== Sauvegarde ==========
    // function saveData() {
    //     if (allData && allData.length > 0) {
    //         fetch('/rssi/risk-editor/save', {
    //             method: 'POST',
    //             headers: {'Content-Type': 'application/json'},
    //             body: JSON.stringify(allData)
    //         })
    //             .then(res => res.text())
    //             .then(msg => {
    //                 if (msg.includes("SUCCESS")) {
    //                     showToast('✅ Sauvegarde réussie !');
    //                 } else {
    //                     showToast('❌ Erreur : ' + msg, 'error');
    //                 }
    //             })
    //             .catch(err => {
    //                 console.error(err);
    //                 showToast('Erreur réseau', 'error');
    //             });
    //     } else {
    //         showToast('Aucune donnée à sauvegarder', 'warning');
    //     }
    // }


    function saveData() {
        if (allData && allData.length > 0) {
            propagateCategoriesToData();

            showToast('🔄 Création de la version et sauvegarde BD...', 'warning');

            fetch('/rssi/risk-editor/save', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(allData)
            })
                .then(res => res.text())
                .then(msg => {
                    if (msg.includes("SUCCESS")) {
                        showToast('✅ Données sauvegardées et version archivée !');
                        // Actualiser la liste de l'historique si le panneau est ouvert
                        loadHistory();
                    } else {
                        showToast('❌ Erreur : ' + msg, 'error');
                    }
                })
                .catch(err => {
                    console.error(err);
                    showToast('Erreur réseau', 'error');
                });
        }
    }

    // FONCTION POUR RÉCUPÉRER L'HISTORIQUE
    function openHistory() {
        const myOffcanvas = new bootstrap.Offcanvas(document.getElementById('historyPanel'));
        myOffcanvas.show();
        loadHistory();
    }


    function loadHistory() {
        fetch('/rssi/risk-editor/history')
            .then(res => res.json())
            .then(data => {
                const list = document.getElementById('historyList');
                if (!data || data.length === 0) {
                    list.innerHTML = '<div class="p-4 text-center">Aucune archive disponible.</div>';
                    return;
                }

                // NOTE LE \ DEVANT LE $ : C'est la clé de la correction
                list.innerHTML = data.map(file => `
                <div class="list-group-item list-group-item-action p-3">
                    <div class="d-flex w-100 justify-content-between align-items-center">
                        <div style="max-width: 80%;">
                            <h6 class="mb-1 text-dark fw-bold" style="font-size: 0.85rem; word-break: break-all;">
                                <i class="bi bi-file-earmark-spreadsheet-fill text-success me-2"></i> \${file.name}
                            </h6>
                            <div class="text-muted" style="font-size: 0.75rem;">
                                <i class="bi bi-calendar3 me-1"></i> Généré le : \${file.date}
                            </div>
                        </div>
                        <a href="/rssi/risk-editor/download-version?name=\${file.name}"
                           class="btn btn-sm btn-outline-danger border-0 fs-5" title="Télécharger">
                            <i class="bi bi-download"></i>
                        </a>
                    </div>
                </div>
            `).join('');
            })
            .catch(err => {
                console.error("Erreur historique:", err);
                document.getElementById('historyList').innerHTML = '<div class="p-3 text-danger">Erreur de chargement</div>';
            });
    }
/*
    function loadHistory() {
        fetch('/rssi/risk-editor/history')
            .then(res => res.json())
            .then(files => {
                const list = document.getElementById('historyList');
                if (files.length === 0) {
                    list.innerHTML = '<div class="p-4 text-center">Aucune version trouvée.</div>';
                    return;
                }

                list.innerHTML = files.map(filename => `
                    <div class="list-group-item list-group-item-action p-3">
                        <div class="d-flex w-100 justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-1 text-primary"><i class="bi bi-file-earmark-spreadsheet"></i> ${filename}</h6>
                                <small class="text-muted">Type: Registre des risques</small>
                            </div>
                            <a href="/rssi/risk-editor/download-version?name=${filename}" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-download"></i>
                            </a>
                        </div>
                    </div>
                `).join('');
            });
    }
*/


    /*
        function saveData() {
            if (allData && allData.length > 0) {
                // Propager les catégories avant envoi
                propagateCategoriesToData();
                console.log("📤 Données après propagation (allData) :", JSON.parse(JSON.stringify(allData)));
                console.log("Nombre d'éléments :", allData.length);

                fetch('/rssi/risk-editor/save', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(allData)
                })
                    .then(res => res.text())
                    .then(msg => {
                        console.log("✅ Réponse serveur :", msg);
                        if (msg.includes("SUCCESS")) {
                            showToast('✅ Sauvegarde réussie !');
                            // Recharger les données depuis le serveur
                            fetch('/rssi/risk-editor/data-json')
                                .then(res => res.json())
                                .then(data => init(data))
                                .catch(err => console.error("Erreur rechargement :", err));
                        } else {
                            showToast('❌ Erreur : ' + msg, 'error');
                        }
                    })
                    .catch(err => {
                        console.error("❌ Erreur réseau :", err);
                        showToast('Erreur réseau', 'error');
                    });
            } else {
                showToast('Aucune donnée à sauvegarder', 'warning');
            }
        }
    */


    // ========== Initialisation ==========
    function init(data) {
        console.group('📥 Chargement initial des données');
        console.log('Données brutes reçues :', data);
        console.log('Nombre de risques :', data.length);

        allData = data;
        effectiveCategoriesAll = computeEffectiveCategories(allData);
        console.log('Catégories effectives calculées :', effectiveCategoriesAll);

        const uniqueCats = [...new Set(effectiveCategoriesAll)].filter(c => c && c !== '').sort();
        const catSelect = document.getElementById('filterCat');
        catSelect.innerHTML = '<option value="">Toutes les catégories</option>';
        uniqueCats.forEach(c => catSelect.add(new Option(c, c)));
        console.log('Catégories uniques :', uniqueCats);
        console.groupEnd();

        const container = document.getElementById('hot-container');
        // Définition explicite des colonnes dans l'ordre des en-têtes (25 colonnes)
        const columns = [
            { data: 'categorie' },
            { data: 'menaces' },
            { data: 'origine' },
            { data: 'actifs' },
            { data: 'ref' },
            { data: 'proprio' },
            { data: 'scenario' },
            { data: 'vulner' },
            { data: 'd', type: 'numeric' },      // Doit matcher e.getValD() -> r.put("d", ...)
            { data: 'i', type: 'numeric' },
            { data: 'c', type: 'numeric' },
            { data: 'impOrg', type: 'numeric' },
            { data: 'impJur', type: 'numeric' },
            { data: 'impImg', type: 'numeric' },
            { data: 'impFin', type: 'numeric' },
            { data: 'proba', type: 'numeric' },
            { data: 'grav', type: 'numeric' },
            { data: 'scoreRes', readOnly: true },
            { data: 'optionTrait', type: 'dropdown', source: ['Accepter', 'Surveiller / Accepter avec suivi', 'Traiter (réduire)', 'Éviter / Transférer'] },
            { data: 'actions' },
            { data: 'besoinC', type: 'numeric' },
            { data: 'probC', type: 'numeric' },
            { data: 'gravC', type: 'numeric' },
            { data: 'scoreCible', type: 'numeric', readOnly: true },
            { data: 'optionApres', readOnly: true }
        ];

        // Fonction pour déterminer l'option en fonction du score (seuils fournis)
        function getOptionFromScore(score) {
            if (score <= 12) return 'Accepter';
            if (score <= 23) return 'Surveiller / Accepter avec suivi';
            if (score <= 35) return 'Traiter (réduire)';
            return 'Éviter / Transférer';
        }

        // Fonction de recalcul pour une ligne donnée
        function recalcRow(rowData) {
            // Score résiduel
            let d = parseInt(rowData.d) || 1;
            let i = parseInt(rowData.i) || 1;
            let c = parseInt(rowData.c) || 1;
            let proba = parseInt(rowData.proba) || 1;
            let grav = parseInt(rowData.grav) || 1;
            let maxDIC = Math.max(d, i, c);
            let scoreRes = maxDIC * proba * grav;
            rowData.scoreRes = scoreRes;
            rowData.optionTrait = getOptionFromScore(scoreRes);

            // Score cible
            let besoinC = parseInt(rowData.besoinC) || 1;
            let probC = parseInt(rowData.probC) || 1;
            let gravC = parseInt(rowData.gravC) || 1;
            let scoreCible = besoinC * probC * gravC;
            rowData.scoreCible = scoreCible;
            rowData.optionApres = getOptionFromScore(scoreCible);
        }



        hot = new Handsontable(container, {
            data: allData,
            columns: columns,
            nestedHeaders: nestedHeaders,
            licenseKey: 'non-commercial-and-evaluation',
            stretchH: 'all',
            width: '100%',
            height: '100%',
            rowHeaders: true,
            undo: true,
            colWidths: [60, 250, 60, 150, 70, 100, 250, 200, 30, 30, 30, 30, 30, 30, 30, 40, 40, 60, 150, 200, 40, 40, 40, 60, 100],
            manualColumnResize: true,
            mergeCells: calculateMergesFromEffective(effectiveCategoriesAll),
            effectiveCategories: effectiveCategoriesAll,
            cells: function() { return { renderer: customRenderer }; },
            contextMenu: {
                items: {
                    'cut': { name: 'Couper' },
                    'copy': { name: 'Copier' },
                    'copy_with_column_headers': { name: 'Copier avec en-têtes' },
                    'paste': { name: 'Coller' },
                    'separator1': '---------',
                    'add_category': {
                        name: 'Ajouter une ligne (choisir catégorie)',
                        callback: openCategoryModal
                    },
                    'separator2': '---------',
                    'row_above_custom': {
                        name: 'Insérer une ligne au-dessus (même catégorie)',
                        callback: insertRowAbove
                    },
                    'row_below_custom': {
                        name: 'Insérer une ligne en dessous (même catégorie)',
                        callback: insertRowBelow
                    },
                    'remove_row': {
                        name: 'Supprimer la ligne',
                        callback: function() {
                            const selected = hot.getSelected();
                            if (selected) {
                                const rowsToDelete = [...new Set(selected.map(r => r[0]))].sort((a,b)=>b-a);
                                for (let r of rowsToDelete) {
                                    if (filteredData[r] && filteredData[r].ref) {
                                        const ref = filteredData[r].ref;
                                        const idx = allData.findIndex(d => d.ref === ref);
                                        if (idx !== -1) allData.splice(idx, 1);
                                    }
                                }
                                effectiveCategoriesAll = computeEffectiveCategories(allData);
                                applyFilters();
                                showToast('Ligne(s) supprimée(s)');
                            }
                        }
                    },
                    'separator3': '---------',
                    'merge_categories': {
                        name: 'Fusionner les catégories identiques',
                        callback: function() {
                            const currentEffective = filteredEffective;
                            this.updateSettings({ mergeCells: calculateMergesFromEffective(currentEffective) });
                            showToast('Fusions recalculées');
                        }
                    },
                    'separator4': '---------',
                    'alignment': {
                        name: 'Alignement',
                        submenu: {
                            items: [
                                { key: 'alignment:left', name: 'Gauche', callback: () => applyAlignment('htLeft') },
                                { key: 'alignment:center', name: 'Centre', callback: () => applyAlignment('htCenter') },
                                { key: 'alignment:right', name: 'Droite', callback: () => applyAlignment('htRight') },
                                { key: 'alignment:justify', name: 'Justifier', callback: () => applyAlignment('htJustify') }
                            ]
                        }
                    },
                    'separator5': '---------',
                    'undo': { name: 'Annuler (Ctrl+Z)' },
                    'redo': { name: 'Rétablir (Ctrl+Y)' },
                    'separator6': '---------',
                    'filter_by_value': { name: 'Filtrer par valeur' },
                    'filter_clear': { name: 'Effacer les filtres' }
                }
            },
            afterChange: function(changes, source) {
                if (updating) return;
                if (source !== 'loadData' && changes) {
                    // Récupérer les lignes modifiées et recalculer
                    const affectedRows = new Set();
                    for (let change of changes) {
                        const row = change[0];
                        const prop = change[1];
                        // Seules les colonnes qui influencent les scores déclenchent le recalcul
                        if (['d', 'i', 'c', 'proba', 'grav', 'besoinC', 'probC', 'gravC'].includes(prop)) {
                            affectedRows.add(row);
                        }
                    }
                    // Appliquer le recalcul sur les lignes concernées
                    for (let row of affectedRows) {
                        if (filteredData[row]) {
                            recalcRow(filteredData[row]);
                            // Mettre à jour dans allData
                            const ref = filteredData[row].ref;
                            if (ref) {
                                const idx = allData.findIndex(d => d.ref === ref);
                                if (idx !== -1) {
                                    Object.assign(allData[idx], filteredData[row]);
                                }
                            }
                        }
                    }
                    // Recharger les données modifiées
                    applyFilters(); // cela mettra à jour l'affichage
                }
            }

        });
        filteredData = allData;
        filteredEffective = effectiveCategoriesAll;
        refreshDisplay();
    }

    // Renderer personnalisé
    function customRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        if (col === 0) {
            td.className = 'vertical-cat';
            const effective = instance.getSettings().effectiveCategories;
            if (effective && effective[row]) {
                td.innerHTML = '<div class="cat-text">' + effective[row] + '</div>';
            } else {
                td.innerHTML = '<div class="cat-text">' + (value || '') + '</div>';
            }
        }
        if (prop === 'scoreRes' || prop === 'scoreCible') {
            const v = parseInt(value) || 0;
            td.classList.remove('risk-faible', 'risk-modere', 'risk-significatif', 'risk-critique');
            if (v > 35) td.classList.add('risk-critique');
            else if (v >= 24) td.classList.add('risk-significatif');
            else if (v >= 13) td.classList.add('risk-modere');
            else if (v > 0) td.classList.add('risk-faible');
        }
    }

    // Chargement des données (uniquement depuis le serveur)
    fetch('/rssi/risk-editor/data-json')
        .then(res => {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(data => {
            console.log('✅ Données chargées depuis le serveur');
            init(data);
        })
        .catch(err => {
            console.error('❌ Erreur de chargement des données :', err);
            alert('Impossible de charger les données depuis le serveur.');
        });

    // Initialiser le modal après chargement du DOM
    document.addEventListener('DOMContentLoaded', () => {
        categoryModal = new bootstrap.Modal(document.getElementById('categoryModal'));
    });
</script>
</body>
</html>


<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>ISO 27005 - Registre des Risques</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        /* Styles inchangés (copiés depuis la version précédente) */
        html, body { height: 100%; margin: 0; padding: 0; overflow: hidden; background-color: #f8f9fa; }
        .main-container { height: 100vh; display: flex; flex-direction: column; }
        .header-bar { height: 50px; background: #fff; padding: 0 20px; border-bottom: 2px solid #dc3545; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .filter-bar { height: 60px; background: #fff; padding: 0 20px; border-bottom: 1px solid #dee2e6; display: flex; align-items: center; gap: 15px; flex-shrink: 0; }
        #hot-container-wrapper { flex-grow: 1; position: relative; width: 100%; overflow: hidden; }
        #hot-container { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .vertical-cat { background-color: #e8f5e9 !important; color: #1b5e20 !important; font-weight: bold !important; text-align: center !important; vertical-align: middle !important; border-right: 2px solid #2e7d32 !important; padding: 0 !important; }
        .cat-text { writing-mode: vertical-rl; transform: rotate(180deg); white-space: nowrap; display: inline-block; padding: 10px 5px; font-size: 11px; text-transform: uppercase; }
        .handsontable thead tr:nth-child(1) th { background-color: #c00000 !important; color: white !important; font-size: 14px; }
        .handsontable thead tr:nth-child(2) th { background-color: #002060 !important; color: white !important; font-size: 12px; }
        .handsontable thead tr:nth-child(3) th { background-color: #595959 !important; color: white !important; }
        .handsontable thead tr:nth-child(4) th { background-color: #bdd7ee !important; color: #002060 !important; font-size: 10px; }
        .risk-faible { background-color: #92d050 !important; text-align: center; font-weight: bold; }
        .risk-modere { background-color: #ffff00 !important; text-align: center; font-weight: bold; }
        .risk-significatif { background-color: #ffc000 !important; text-align: center; font-weight: bold; }
        .risk-critique { background-color: #ff0000 !important; color: white !important; text-align: center; font-weight: bold; }
    </style>
</head>
<body>
<div class="main-container">
    <div class="header-bar">
        <h5 class="m-0 fw-bold"><i class="bi bi-shield-lock-fill text-danger"></i> Registre ISO 27005</h5>
        <button class="btn btn-success btn-sm px-4" onclick="saveData()">Enregistrer</button>
    </div>
    <div class="filter-bar">
        <div class="input-group input-group-sm" style="width: 250px;">
            <span class="input-group-text"><i class="bi bi-search"></i></span>
            <input type="text" id="searchBox" class="form-control" placeholder="Rechercher..." oninput="applyFilters()">
        </div>
        <select id="filterCat" class="form-select form-select-sm" style="width: 220px;" onchange="applyFilters()">
            <option value="">Toutes les catégories</option>
        </select>
        <select id="filterRisk" class="form-select form-select-sm" style="width: 180px;" onchange="applyFilters()">
            <option value="">Tous les risques</option>
            <option value="critique">🔴 Critique (>35)</option>
            <option value="significatif">🟠 Significatif (24-35)</option>
            <option value="modere">🟡 Modéré (13-23)</option>
            <option value="faible">🟢 Faible (≤12)</option>
        </select>
        <button class="btn btn-outline-secondary btn-sm" onclick="resetFilters()">Réinitialiser</button>
        <span class="ms-auto badge bg-secondary" id="countLabel">Risques : 0</span>
    </div>
    <div id="hot-container-wrapper">
        <div id="hot-container"></div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>
<script>
    let hot;
    let allData = [];
    let effectiveCategoriesAll = [];
    let filteredData = [];
    let filteredEffective = [];

    const nestedHeaders = [
        [{label: 'REGISTRE DES RISQUES DE SÉCURITÉ DE L\'INFORMATION', colspan: 25}],
        [{label: 'IDENTIFICATION DU RISQUE', colspan: 8}, {label: 'APPRÉCIATION DES RISQUES', colspan: 10}, {label: 'TRAITEMENT DU RISQUE', colspan: 7}],
        ['Catégorie', 'Menaces', 'Origine', 'Actifs', 'Réf.', 'Proprio', 'Scénario', 'Vulnérabilité', 'D','I','C', 'Imp.Org','Imp.Jur','Imp.Img','Imp.Fin', 'Prob.','Grav.','Score', 'Option', 'Actions', 'Bes.C','Prob.C','Grav.C','Score C', 'Fin'],
        ['', '', '', '', '', '', '', '', '','','', '','','','', '','','', '', '', '','','','', '']
    ];

    // Propager les catégories : la dernière valeur non nulle s'applique aux suivantes
    function computeEffectiveCategories(data) {
        let effective = [];
        let lastValid = '';
        for (let i = 0; i < data.length; i++) {
            let cat = data[i].categorie;
            if (cat && typeof cat === 'string' && cat.trim() !== '') {
                lastValid = cat.trim();
            }
            effective.push(lastValid);
        }
        return effective;
    }

    function calculateMergesFromEffective(effective) {
        let merges = [];
        if (!effective.length) return merges;
        let start = 0;
        for (let i = 1; i <= effective.length; i++) {
            if (i === effective.length || effective[i] !== effective[start]) {
                if (i - start > 1) merges.push({ row: start, col: 0, rowspan: i - start, colspan: 1 });
                start = i;
            }
        }
        return merges;
    }

    function customRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        if (col === 0) {
            td.className = 'vertical-cat';
            const effective = instance.getSettings().effectiveCategories;
            if (effective && effective[row]) {
                td.innerHTML = '<div class="cat-text">' + effective[row] + '</div>';
            } else {
                td.innerHTML = '<div class="cat-text">' + (value || '') + '</div>';
            }
        }
        if (prop === 'scoreRes' || prop === 'scoreCible') {
            const v = parseInt(value) || 0;
            td.classList.remove('risk-faible', 'risk-modere', 'risk-significatif', 'risk-critique');
            if (v > 35) td.classList.add('risk-critique');
            else if (v >= 24) td.classList.add('risk-significatif');
            else if (v >= 13) td.classList.add('risk-modere');
            else if (v > 0) td.classList.add('risk-faible');
        }
    }

    function refreshDisplay() {
        if (!hot) return;
        hot.loadData(filteredData);
        hot.updateSettings({
            mergeCells: calculateMergesFromEffective(filteredEffective),
            effectiveCategories: filteredEffective
        });
        document.getElementById('countLabel').innerText = 'Risques : ' + filteredData.length;
    }

    function applyFilters() {
        const searchText = document.getElementById('searchBox').value.toLowerCase();
        let selectedCat = document.getElementById('filterCat').value;
        const selectedRisk = document.getElementById('filterRisk').value;
        if (selectedCat) selectedCat = selectedCat.trim();

        console.group('🔍 Application des filtres');
        console.log('Filtre catégorie :', selectedCat || 'aucun');
        console.log('Filtre risque    :', selectedRisk || 'aucun');
        console.log('Recherche texte  :', searchText || 'aucun');

        const indices = [];
        for (let i = 0; i < allData.length; i++) {
            const item = allData[i];
            const effCat = effectiveCategoriesAll[i];
            let ok = true;
            if (searchText && !JSON.stringify(item).toLowerCase().includes(searchText)) ok = false;
            if (ok && selectedCat && effCat !== selectedCat) ok = false;
            if (ok && selectedRisk) {
                const score = parseInt(item.scoreRes) || 0;
                if (selectedRisk === 'faible' && score > 12) ok = false;
                else if (selectedRisk === 'modere' && (score <= 12 || score > 23)) ok = false;
                else if (selectedRisk === 'significatif' && (score <= 23 || score > 35)) ok = false;
                else if (selectedRisk === 'critique' && score <= 35) ok = false;
            }
            if (ok) indices.push(i);
        }
        filteredData = indices.map(i => allData[i]);
        filteredEffective = indices.map(i => effectiveCategoriesAll[i]);

        console.log('📊 Données filtrées : ' + filteredData.length + ' sur ' + allData.length);
        console.groupEnd();

        refreshDisplay();
    }

    function resetFilters() {
        document.getElementById('searchBox').value = '';
        document.getElementById('filterCat').value = '';
        document.getElementById('filterRisk').value = '';
        applyFilters();
    }

    function saveData() {
        if (hot) {
            const fullData = hot.getSourceData();
            console.log('Sauvegarde :', fullData);
            alert('Sauvegarde effectuée (console)');
        }
    }

    function init(data) {
        console.group('📥 Chargement initial des données');
        console.log('Données brutes reçues :', data);
        console.log('Nombre de risques :', data.length);

        allData = data;
        effectiveCategoriesAll = computeEffectiveCategories(allData);
        console.log('Catégories effectives calculées :', effectiveCategoriesAll);

        const uniqueCats = [...new Set(effectiveCategoriesAll)].filter(c => c && c !== '').sort();
        const catSelect = document.getElementById('filterCat');
        catSelect.innerHTML = '<option value="">Toutes les catégories</option>';
        uniqueCats.forEach(c => catSelect.add(new Option(c, c)));
        console.log('Catégories uniques :', uniqueCats);
        console.groupEnd();

        const container = document.getElementById('hot-container');
        hot = new Handsontable(container, {
            data: allData,
            nestedHeaders: nestedHeaders,
            licenseKey: 'non-commercial-and-evaluation',
            stretchH: 'all',
            width: '100%',
            height: '100%',
            rowHeaders: true,
            colWidths: [60, 250, 60, 150, 70, 100, 250, 200, 30, 30, 30, 30, 30, 30, 30, 40, 40, 60, 150, 200, 40, 40, 40, 60, 100],
            manualColumnResize: true,
            mergeCells: calculateMergesFromEffective(effectiveCategoriesAll),
            effectiveCategories: effectiveCategoriesAll,
            cells: function() { return { renderer: customRenderer }; },
            afterChange: function(changes, source) {
                // Pour éviter les récursions, on ne fait rien ici.
                // Si vous voulez permettre l'édition, décommentez avec précaution.
            }
        });
        filteredData = allData;
        filteredEffective = effectiveCategoriesAll;
        refreshDisplay();
    }

    // Chargement depuis le serveur (pas de fallback statique)
    fetch('/rssi/risk-editor/data-json')
        .then(res => {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(data => {
            console.log('✅ Données chargées depuis le serveur');
            init(data);
        })
        .catch(err => {
            console.error('❌ Erreur de chargement des données :', err);
            alert('Impossible de charger les données depuis le serveur. Vérifiez la console.');
            // Optionnel : afficher un message d'erreur dans le conteneur
            const container = document.getElementById('hot-container');
            container.innerHTML = '<div class="alert alert-danger m-3">Erreur de chargement des données. Vérifiez que le serveur répond.</div>';
        });
</script>
</body>
</html>--%>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>ISO 27005 - Registre des Risques</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        /* --- Styles inchangés --- */
        html, body { height: 100%; margin: 0; padding: 0; overflow: hidden; background-color: #f8f9fa; }
        .main-container { height: 100vh; display: flex; flex-direction: column; }
        .header-bar { height: 50px; background: #fff; padding: 0 20px; border-bottom: 2px solid #dc3545; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .filter-bar { height: 60px; background: #fff; padding: 0 20px; border-bottom: 1px solid #dee2e6; display: flex; align-items: center; gap: 15px; flex-shrink: 0; }
        #hot-container-wrapper { flex-grow: 1; position: relative; width: 100%; overflow: hidden; }
        #hot-container { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .vertical-cat { background-color: #e8f5e9 !important; color: #1b5e20 !important; font-weight: bold !important; text-align: center !important; vertical-align: middle !important; border-right: 2px solid #2e7d32 !important; padding: 0 !important; }
        .cat-text { writing-mode: vertical-rl; transform: rotate(180deg); white-space: nowrap; display: inline-block; padding: 10px 5px; font-size: 11px; text-transform: uppercase; }
        .handsontable thead tr:nth-child(1) th { background-color: #c00000 !important; color: white !important; font-size: 14px; }
        .handsontable thead tr:nth-child(2) th { background-color: #002060 !important; color: white !important; font-size: 12px; }
        .handsontable thead tr:nth-child(3) th { background-color: #595959 !important; color: white !important; }
        .handsontable thead tr:nth-child(4) th { background-color: #bdd7ee !important; color: #002060 !important; font-size: 10px; }
        .risk-faible { background-color: #92d050 !important; text-align: center; font-weight: bold; }
        .risk-modere { background-color: #ffff00 !important; text-align: center; font-weight: bold; }
        .risk-significatif { background-color: #ffc000 !important; text-align: center; font-weight: bold; }
        .risk-critique { background-color: #ff0000 !important; color: white !important; text-align: center; font-weight: bold; }
    </style>
</head>
<body>
<div class="main-container">
    <div class="header-bar">
        <h5 class="m-0 fw-bold"><i class="bi bi-shield-lock-fill text-danger"></i> Registre ISO 27005</h5>
        <button class="btn btn-success btn-sm px-4" onclick="saveData()">Enregistrer</button>
    </div>
    <div class="filter-bar">
        <div class="input-group input-group-sm" style="width: 250px;">
            <span class="input-group-text"><i class="bi bi-search"></i></span>
            <input type="text" id="searchBox" class="form-control" placeholder="Rechercher..." oninput="applyFilters()">
        </div>
        <select id="filterCat" class="form-select form-select-sm" style="width: 220px;" onchange="applyFilters()">
            <option value="">Toutes les catégories</option>
        </select>
        <select id="filterRisk" class="form-select form-select-sm" style="width: 180px;" onchange="applyFilters()">
            <option value="">Tous les risques</option>
            <option value="critique">🔴 Critique (>35)</option>
            <option value="significatif">🟠 Significatif (24-35)</option>
            <option value="modere">🟡 Modéré (13-23)</option>
            <option value="faible">🟢 Faible (≤12)</option>
        </select>
        <button class="btn btn-outline-secondary btn-sm" onclick="resetFilters()">Réinitialiser</button>
        <span class="ms-auto badge bg-secondary" id="countLabel">Risques : 0</span>
    </div>
    <div id="hot-container-wrapper">
        <div id="hot-container"></div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>
<script>
    // ==================== DONNÉES STATIQUES (fallback) ====================
    const staticData = [
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-1",
            "menaces": "Incendie \n(foudre, court circuit, matériel inflammable, surchauffe, Propagation de l'incendie en provenance des bâtiments adjacents)",
            "origine": "A, D, E",
            "actifs": "Site, Matériel, Logiciel, Personnel, Document",
            "d": 4,
            "i": 2,
            "c": 2,
            "proba": 1,
            "grav": 4,
            "scoreRes": 16,
            "besoinC": 4,
            "probC": 1,
            "gravC": 3,
            "scoreCible": 12,
            "optionApres": "Accepter",
            "proprio": "IT Manager",
            "scenario": "Incendie dans le bâtiment principal, entrainant l'indisponibilité de site et l'interruption des opérations administratives, commerciales et métier",
            "vulner": "Manque de maintenance preventifs des systèmes de détection d'incendie",
            "mesures": "Contact avec Casanearshore\nPlan d'évacuation \nPlan de continuité d'activité\nExtincteur de feu\nFormation des collaborateurs à l'utilisation des extincteurs\ndes tests des détecteurs et des tests d'évacuation sont régulièrement menés par le gestionnaire du site\nPCA sur iKoula ou Azure pour les services importants\nTest réguliers du PCA",
            "optionTrait": "Surveiller / Accepter avec suivi",
            "actions": "1) Maintenance préventive des systèmes de détection d'incendie, Mise en place d'un plan de maintenance\n2) Eaboration d'une procédure de gestion des incendies",
            "impOrg": 4,
            "impJur": 2,
            "impImg": 1,
            "impFin": 1
        },
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-2",
            "menaces": "Incendie \n(foudre, court circuit, matériel inflammable, surchauffe, Propagation de l'incendie en provenance des bâtiments adjacents)",
            "origine": "A, D, E",
            "actifs": "Site, Matériel, Logiciel, Personnel, Document",
            "d": 4,
            "i": 2,
            "c": 3,
            "proba": 1,
            "grav": 3,
            "scoreRes": 12,
            "besoinC": 1,
            "probC": 1,
            "gravC": 1,
            "scoreCible": 1,
            "optionApres": "Accepter",
            "proprio": "",
            "scenario": "Blessures ou décès d'employés",
            "vulner": "Non-respect des consignes de sécurité par les employés",
            "mesures": "Contact avec Casanearshore\nPlan d'évacuation \nExtincteur de feu\nFormation des collaborateurs à l'utilisation des extincteurs\ndes tests des détecteurs et des tests d'évacuation sont régulièrement menés par le gestionnaire du site",
            "optionTrait": "Accepter",
            "actions": "",
            "impOrg": 3,
            "impJur": 1,
            "impImg": 1,
            "impFin": 1
        },
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-3",
            "menaces": "Dégât des eaux \n(Fuite des équipements de climatisation, fuite d'une canalisation, montée du niveau d'eau, …)",
            "origine": "A, D, E",
            "actifs": "Site, Matériel, Réseau, Document",
            "d": 4,
            "i": 1,
            "c": 3,
            "proba": 2,
            "grav": 3,
            "scoreRes": 24,
            "besoinC": 4,
            "probC": 1,
            "gravC": 2,
            "scoreCible": 8,
            "optionApres": "Accepter",
            "proprio": "IT Manager",
            "scenario": "Fuite d'eau des systèmes de plomberie internes affectant la disponibilité des serveurs et les équipements réseau et des documents",
            "vulner": "Erreurs lors de l'installation ou de la réparation des systèmes de plomberie",
            "mesures": "Intervention des tiers maîtrisée (accompagnement)\nConsignes de sécurité du Datacenter formalisées et affichées dans le local\nLe local Datacenter est doté d'un faux plancher",
            "optionTrait": "Traiter (réduire)",
            "actions": "Révision et audit des systèmes de plomberie, installation de détecteurs de fuite d'eau",
            "impOrg": 1,
            "impJur": 1,
            "impImg": 1,
            "impFin": 3
        },
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-4",
            "menaces": "Accident majeur\n(explosion de sites à proximité, attaque terroriste, Accident, Crash, Vandalisme/sabotage, ...)",
            "origine": "A, D, E",
            "actifs": "Site, Matériel, Logiciel, Personnel, Document",
            "d": 4,
            "i": 1,
            "c": 2,
            "proba": 2,
            "grav": 3,
            "scoreRes": 24,
            "besoinC": 4,
            "probC": 1,
            "gravC": 2,
            "scoreCible": 8,
            "optionApres": "Accepter",
            "proprio": "",
            "scenario": "Attentats terroristes causant des blessures ou décès d'employés, l'indisponibilité des locaux et crach de matériel",
            "vulner": "Insuffisance des mesures de sécurité physiques",
            "mesures": "Agent de sécurité \nAccès par badge\nCaméra de surveillance",
            "optionTrait": "Traiter (réduire)",
            "actions": "Renforcement des mesures de sécurité physiques, ajout de personnel de sécurité, simulation d'attaques",
            "impOrg": 1,
            "impJur": 1,
            "impImg": 1,
            "impFin": 3
        },
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-5",
            "menaces": "Accident majeur\n(explosion de sites à proximité, attaque terroriste, Accident, Crash, Vandalisme/sabotage, ...)",
            "origine": "A, D, E",
            "actifs": "Site, Matériel, Logiciel, Personnel, Document",
            "d": 3,
            "i": 2,
            "c": 1,
            "proba": 2,
            "grav": 3,
            "scoreRes": 18,
            "besoinC": 3,
            "probC": 1,
            "gravC": 2,
            "scoreCible": 6,
            "optionApres": "Accepter",
            "proprio": "RSSI",
            "scenario": "Restrictions d'accès gouvernementales aux locaux en raison d'une enquête criminelle ou de sécurité nationale",
            "vulner": "Insuffisance des mesures de sécurité physiques",
            "mesures": "PCA",
            "optionTrait": "Surveiller / Accepter avec suivi",
            "actions": "Coordination étroite avec les autorités pour des mesures de sécurité accrues, mise à jour régulière du PCA",
            "impOrg": 1,
            "impJur": 1,
            "impImg": 3,
            "impFin": 1
        },
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-6",
            "menaces": "Accident majeur\n(explosion de sites à proximité, attaque terroriste, Accident, Crash, Vandalisme/sabotage, ...)",
            "origine": "A, D, E",
            "actifs": "Site, Matériel, Logiciel, Personnel, Document",
            "d": 4,
            "i": 1,
            "c": 3,
            "proba": 2,
            "grav": 3,
            "scoreRes": 24,
            "besoinC": 4,
            "probC": 1,
            "gravC": 2,
            "scoreCible": 8,
            "optionApres": "Accepter",
            "proprio": "",
            "scenario": "Intrusion dans les locaux de l'entreprise et Sabotage d'équipement, Vol de matériel ou de fichier confidentiel",
            "vulner": "Insuffisance des mesures de sécurité physiques",
            "mesures": "Agent de sécurité \nAccès par badge\nCaméra de surveillance\nLes collaborateurs emportent leurs ordinateurs portables en dehors des heures de travail",
            "optionTrait": "Traiter (réduire)",
            "actions": "Amélioration des systèmes de sécurité physiques, renforcement des procédures d'accès, formation des collaborateurs",
            "impOrg": 3,
            "impJur": 1,
            "impImg": 1,
            "impFin": 1
        },
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-7",
            "menaces": "Destruction de matériel ou de support \n(Négligence commise lors du transport du matériel, choc physique, variation de l'alimentation, matières inappropriées, défaut d'entretien ou d'utilisation,…)",
            "origine": "A, D, E",
            "actifs": "Matériel, Logiciel",
            "d": 4,
            "i": 1,
            "c": 0,
            "proba": 2,
            "grav": 3,
            "scoreRes": 24,
            "besoinC": 4,
            "probC": 1,
            "gravC": 2,
            "scoreCible": 8,
            "optionApres": "Accepter",
            "proprio": "RSSI",
            "scenario": "Endommagement  intentionnel d'équipement (Serveur, PC) par un employé malveillant",
            "vulner": "Absence de matériel backup",
            "mesures": "Accès restreint aux salles serveurs aux personnes autorisées.\nBackup de donnée sur OneDrive et",
            "optionTrait": "Traiter (réduire)",
            "actions": "Mise en place de matériel de backup supplémentaire, renforcement des contrôles d'accès",
            "impOrg": 1,
            "impJur": 1,
            "impImg": 1,
            "impFin": 3
        },
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-8",
            "menaces": "Destruction de matériel ou de support \n(Négligence commise lors du transport du matériel, choc physique, variation de l'alimentation, matières inappropriées, défaut d'entretien ou d'utilisation,…)",
            "origine": "A, D, E",
            "actifs": "Matériel, Logiciel",
            "d": 4,
            "i": 1,
            "c": 1,
            "proba": 2,
            "grav": 3,
            "scoreRes": 24,
            "besoinC": 4,
            "probC": 1,
            "gravC": 2,
            "scoreCible": 8,
            "optionApres": "Accepter",
            "proprio": "RSSI",
            "scenario": "Endommagement de matériels suite à une variation brusque de l'alimentation",
            "vulner": "Absence ou Dysfonctionnement de Stabilisateur de tension",
            "mesures": "Contact avec Casanearshore\nStabilisateur de tension",
            "optionTrait": "Traiter (réduire)",
            "actions": "Installation de stabilisateurs de tension supplémentaires, maintenance régulière des équipements électriques",
            "impOrg": 3,
            "impJur": 1,
            "impImg": 1,
            "impFin": 1
        },
        {
            "categorie": "1-Sinistres physiques (PHY)",
            "ref": "PHY-9",
            "menaces": "Destruction de matériel ou de support \n(Négligence commise lors du transport du matériel, choc physique, variation de l'alimentation, matières inappropriées, défaut d'entretien ou d'utilisation,…)",
            "origine": "A, D, E",
            "actifs": "Matériel, Logiciel",
            "d": 4,
            "i": 0,
            "c": 2,
            "proba": 2,
            "grav": 3,
            "scoreRes": 24,
            "besoinC": 4,
            "probC": 1,
            "gravC": 2,
            "scoreCible": 8,
            "optionApres": "Accepter",
            "proprio": "IT Manager",
            "scenario": "Endommagement de matériels ou de supports suite à un contact avec des matières non appropriées lors d'un transport ou de l'installation de matériel",
            "vulner": "Négligence des consignes de constructeur",
            "mesures": "",
            "optionTrait": "Traiter (réduire)",
            "actions": "Formation renforcée sur les consignes de constructeur, audit régulier des pratiques de transport et d'installation",
            "impOrg": 1,
            "impJur": 1,
            "impImg": 1,
            "impFin": 3
        },
        {
            "categorie": "2-Evènements naturels (NAT)",
            "ref": "NAT-1",
            "menaces": "Phénomène climatique\n(Extrême  chaleur, froid, humidité, vent, sécheresse)",
            "origine": "E",
            "actifs": "Matériel",
            "d": 4,
            "i": 1,
            "c": 0,
            "proba": 2,
            "grav": 3,
            "scoreRes": 24,
            "besoinC": 4,
            "probC": 1,
            "gravC": 2,
            "scoreCible": 8,
            "optionApres": "Accepter",
            "proprio": "IT Manager",
            "scenario": "Surchauffe en salle machine suite à une augementation de température affectant les équipements",
            "vulner": "Sensibilité aux variations de température",
            "mesures": "Redondance de la climatisation\nUn détecteur de température est installé à l'extérieur de salle serveur et salle réseau",
            "optionTrait": "Traiter (réduire)",
            "actions": "Ajouter des systèmes de refroidissement supplémentaires.\n Mettre en place des alarmes de température plus sensibles.\n Maintenance régulière des systèmes de climatisation",
            "impOrg": 2,
            "impJur": 1,
            "impImg": 1,
            "impFin": 3
        }
    ];

    let hot;
    let allData = [];               // données brutes (toutes)
    let effectiveCategoriesAll = []; // catégories effectives pour allData
    let filteredData = [];          // données après filtrage
    let filteredEffective = [];     // catégories effectives pour filteredData

    // En-têtes imbriqués (identique)
    const nestedHeaders = [
        [{label: 'REGISTRE DES RISQUES DE SÉCURITÉ DE L\'INFORMATION', colspan: 25}],
        [{label: 'IDENTIFICATION DU RISQUE', colspan: 8}, {label: 'APPRÉCIATION DES RISQUES', colspan: 10}, {label: 'TRAITEMENT DU RISQUE', colspan: 7}],
        ['Catégorie', 'Menaces', 'Origine', 'Actifs', 'Réf.', 'Proprio', 'Scénario', 'Vulnérabilité', 'D','I','C', 'Imp.Org','Imp.Jur','Imp.Img','Imp.Fin', 'Prob.','Grav.','Score', 'Option', 'Actions', 'Bes.C','Prob.C','Grav.C','Score C', 'Fin'],
        ['', '', '', '', '', '', '', '', '','','', '','','','', '','','', '', '', '','','','', '']
    ];

    // Calcule les catégories effectives (propagation)
    function computeEffectiveCategories(data) {
        let effective = [];
        let lastValid = '';
        for (let i = 0; i < data.length; i++) {
            let cat = data[i].categorie;
            if (cat && typeof cat === 'string' && cat.trim() !== '') {
                lastValid = cat.trim();
            }
            effective.push(lastValid);
        }
        return effective;
    }

    // Calcule les fusions à partir des catégories effectives
    function calculateMergesFromEffective(effective) {
        let merges = [];
        if (!effective.length) return merges;
        let start = 0;
        for (let i = 1; i <= effective.length; i++) {
            if (i === effective.length || effective[i] !== effective[start]) {
                if (i - start > 1) merges.push({ row: start, col: 0, rowspan: i - start, colspan: 1 });
                start = i;
            }
        }
        return merges;
    }

    // Renderer personnalisé
    function customRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        if (col === 0) {
            td.className = 'vertical-cat';
            const effective = instance.getSettings().effectiveCategories;
            if (effective && effective[row]) {
                td.innerHTML = '<div class="cat-text">' + effective[row] + '</div>';
            } else {
                td.innerHTML = '<div class="cat-text">' + (value || '') + '</div>';
            }
        }
        if (prop === 'scoreRes' || prop === 'scoreCible') {
            const v = parseInt(value) || 0;
            td.classList.remove('risk-faible', 'risk-modere', 'risk-significatif', 'risk-critique');
            if (v > 35) td.classList.add('risk-critique');
            else if (v >= 24) td.classList.add('risk-significatif');
            else if (v >= 13) td.classList.add('risk-modere');
            else if (v > 0) td.classList.add('risk-faible');
        }
    }

    // Mise à jour de l'affichage avec les données filtrées
    function refreshDisplay() {
        if (!hot) return;
        hot.loadData(filteredData);
        hot.updateSettings({
            mergeCells: calculateMergesFromEffective(filteredEffective),
            effectiveCategories: filteredEffective
        });
        document.getElementById('countLabel').innerText = 'Risques : ' + filteredData.length;
    }

    // Filtrage combiné (catégorie, risque, recherche texte) avec logs
    function applyFilters() {
        const searchText = document.getElementById('searchBox').value.toLowerCase();
        let selectedCat = document.getElementById('filterCat').value;
        const selectedRisk = document.getElementById('filterRisk').value;
        if (selectedCat) selectedCat = selectedCat.trim();

        console.group('🔍 Application des filtres');
        console.log('Filtre catégorie :', selectedCat || 'aucun');
        console.log('Filtre risque    :', selectedRisk || 'aucun');
        console.log('Recherche texte  :', searchText || 'aucun');

        const indices = [];
        for (let i = 0; i < allData.length; i++) {
            const item = allData[i];
            const effCat = effectiveCategoriesAll[i];
            let ok = true;

            // Recherche texte
            if (searchText && !JSON.stringify(item).toLowerCase().includes(searchText)) ok = false;
            // Catégorie
            if (ok && selectedCat && effCat !== selectedCat) ok = false;
            // Niveau de risque
            if (ok && selectedRisk) {
                const score = parseInt(item.scoreRes) || 0;
                if (selectedRisk === 'faible' && score > 12) ok = false;
                else if (selectedRisk === 'modere' && (score <= 12 || score > 23)) ok = false;
                else if (selectedRisk === 'significatif' && (score <= 23 || score > 35)) ok = false;
                else if (selectedRisk === 'critique' && score <= 35) ok = false;
            }
            if (ok) {
                indices.push(i);
                console.log(`✅ ${item.ref} (score=${item.scoreRes}, cat_eff="${effCat}")`);
            } else {
                console.log(`❌ ${item.ref} (score=${item.scoreRes}, cat_eff="${effCat}")`);
            }
        }
        filteredData = indices.map(i => allData[i]);
        filteredEffective = indices.map(i => effectiveCategoriesAll[i]);

        console.log(`📊 Données filtrées : ${filteredData.length} sur ${allData.length}`);
        console.groupEnd();

        refreshDisplay();
    }

    function resetFilters() {
        document.getElementById('searchBox').value = '';
        document.getElementById('filterCat').value = '';
        document.getElementById('filterRisk').value = '';
        applyFilters();
    }

    function saveData() {
        if (hot) {
            const fullData = hot.getSourceData(); // données actuellement affichées
            console.log('Sauvegarde :', fullData);
            alert('Sauvegarde effectuée (console)');
        }
    }

    // Initialisation avec les données (soit du serveur, soit des données statiques)
    function init(data) {
        console.group('📥 Chargement initial des données');
        console.log('Données brutes reçues :', data);
        console.log('Nombre de risques :', data.length);

        allData = data;
        effectiveCategoriesAll = computeEffectiveCategories(allData);
        console.log('Catégories effectives calculées :', effectiveCategoriesAll);

        // Remplir le sélecteur de catégories avec les catégories effectives uniques
        const uniqueCats = [...new Set(effectiveCategoriesAll)].filter(c => c && c !== '').sort();
        const catSelect = document.getElementById('filterCat');
        catSelect.innerHTML = '<option value="">Toutes les catégories</option>';
        uniqueCats.forEach(c => catSelect.add(new Option(c, c)));
        console.log('Catégories uniques :', uniqueCats);
        console.groupEnd();

        const container = document.getElementById('hot-container');
        hot = new Handsontable(container, {
            data: allData,
            nestedHeaders: nestedHeaders,
            licenseKey: 'non-commercial-and-evaluation',
            stretchH: 'all',
            width: '100%',
            height: '100%',
            rowHeaders: true,
            colWidths: [60, 250, 60, 150, 70, 100, 250, 200, 30, 30, 30, 30, 30, 30, 30, 40, 40, 60, 150, 200, 40, 40, 40, 60, 100],
            manualColumnResize: true,
            mergeCells: calculateMergesFromEffective(effectiveCategoriesAll),
            effectiveCategories: effectiveCategoriesAll,
            cells: function() { return { renderer: customRenderer }; },
            afterChange: function(changes, source) {
                // Pour éviter les boucles, on ne fait rien ici dans cette version stable.
                // Les modifications ne sont pas persistées pour le moment.
            }
        });
        // Afficher toutes les données par défaut
        filteredData = allData;
        filteredEffective = effectiveCategoriesAll;
        refreshDisplay();
    }

    // Chargement des données (appel serveur + fallback)
    fetch('/rssi/risk-editor/data-json')
        .then(res => {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(data => {
            console.log('✅ Données chargées depuis le serveur');
            init(data);
        })
        .catch(err => {
            console.warn('⚠️ Erreur serveur, utilisation des données statiques', err);
            init(staticData);
        });
</script>
</body>
</html>--%>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>ISO 27005 - Registre des Risques</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { background-color: #f1f3f5; font-family: 'Segoe UI', sans-serif; overflow: hidden; }
        #hot-container { height: 75vh; width: 100%; background: white; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }

        /* Headers style */
        .handsontable thead tr:nth-child(1) th { background-color: #FF0000 !important; color: white !important; font-weight: bold; }
        .handsontable thead tr:nth-child(2) th { background-color: #002060 !important; color: white !important; }
        .handsontable thead tr:nth-child(3) th { background-color: #7d0b13 !important; color: white !important; }
        .handsontable thead tr:nth-child(4) th { background-color: #BDD7EE !important; color: #002060 !important; font-size: 10px; }

        /* Vertical category column */
        .handsontable td.vertical-cat {
            background-color: #C6EFCE !important;
            color: #006100 !important;
            writing-mode: vertical-rl !important;
            transform: rotate(180deg) !important;
            text-align: center !important;
            vertical-align: middle !important;
            font-weight: bold !important;
            border: 1px solid #000 !important;
        }

        /* Score colors */
        .risk-faible { background-color: #92d050 !important; text-align: center; font-weight: bold; }
        .risk-modere { background-color: #ffff00 !important; text-align: center; font-weight: bold; }
        .risk-significatif { background-color: #ffc000 !important; text-align: center; font-weight: bold; }
        .risk-critique { background-color: #ff0000 !important; color: white !important; text-align: center; font-weight: bold; }
        .disabled-cell { background-color: #e9ecef !important; color: #6c757d !important; }

        .toolbar { background: white; padding: 10px; border-bottom: 3px solid #dc3545; }
        .filter-section { background: #f8f9fa; padding: 8px 20px; border-bottom: 1px solid #dee2e6; }
    </style>
</head>
<body>

<div class="toolbar d-flex justify-content-between align-items-center">
    <h5 class="mb-0 fw-bold"><i class="bi bi-shield-lock-fill text-danger"></i> Gestion des Risques ISO 27005</h5>
    <div class="btn-group gap-2">
        <button onclick="saveRiskData()" class="btn btn-success btn-sm"><i class="bi bi-save"></i> Sauvegarder</button>
        <a href="/dashboard" class="btn btn-secondary btn-sm">Retour</a>
    </div>
</div>

<div class="filter-section d-flex align-items-center gap-3">
    <div class="input-group input-group-sm" style="max-width: 400px;">
        <span class="input-group-text bg-white"><i class="bi bi-tag"></i></span>
        <select id="filterCategory" class="form-select" onchange="applyFilters()">
            <option value="">Toutes les catégories</option>
        </select>
    </div>
    <div class="input-group input-group-sm" style="max-width: 300px;">
        <span class="input-group-text bg-white"><i class="bi bi-exclamation-triangle"></i></span>
        <select id="filterRisk" class="form-select" onchange="applyFilters()">
            <option value="">Tous les risques (Score)</option>
            <option value="critique">🔴 Critique (> 35)</option>
            <option value="significatif">🟠 Significatif (24-35)</option>
            <option value="modere">🟡 Modéré (13-23)</option>
            <option value="faible">🟢 Faible (≤ 12)</option>
        </select>
    </div>
    <button class="btn btn-outline-secondary btn-sm" onclick="resetFilters()">Effacer</button>
</div>

<div id="hot-container"></div>

<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>

<script>
    let hot;
    let masterData = []; // Réserve de données originales (source de vérité)

    const nestedHeaders = [
        [{label: 'Programme de gestion des risques', colspan: 25}],
        [{label: '', colspan: 8}, {label: 'APPRÉCIATION DU RISQUE', colspan: 10}, {label: 'TRAITEMENT DU RISQUE', colspan: 7}],
        ['Catégorie', 'Menaces', 'Origine', 'Actifs', 'Réf.', 'Proprio', 'Scénario', 'Vulnér.',
            {label: 'Besoins', colspan: 3}, {label: 'Impacts (1-4)', colspan: 4}, 'Prob.', 'Grav.', 'Risque Rés.',
            'Option', 'Mesures Correctives', 'Besoins C.', 'Prob C.', 'Grav C.', 'Score C.', 'Option F.'],
        ['', '', '', '', '', '', '', '', 'D', 'I', 'C', 'Org', 'Jur', 'Img', 'Fin', '', '', '', '', '', '', '', '', '', '']
    ];

    function calculateMerges(data) {
        if (!data || data.length === 0) return [];
        let merges = [];
        let startRow = 0;
        for (let i = 1; i <= data.length; i++) {
            let current = (data[i - 1]) ? data[i - 1].categorie : "";
            let next = (i < data.length) ? data[i].categorie : null;
            if (next !== current || i === data.length) {
                let span = i - startRow;
                if (span > 1) merges.push({ row: startRow, col: 0, rowspan: span, colspan: 1 });
                startRow = i;
            }
        }
        return merges;
    }

    function professionalRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);

        const rowData = instance.getSourceDataAtRow(row);
        if (!rowData) return;

        // Colonne Catégorie
        if (col === 0) {
            td.className = 'vertical-cat';
        }

        // Coloration des Scores (Résiduel et Cible)
        if (prop === 'scoreRes' || prop === 'scoreCible') {
            const val = parseInt(value) || 0;
            td.classList.remove('risk-faible', 'risk-modere', 'risk-significatif', 'risk-critique');
            if (val > 0) {
                if (val <= 12) td.classList.add('risk-faible');
                else if (val <= 23) td.classList.add('risk-modere');
                else if (val <= 35) td.classList.add('risk-significatif');
                else td.classList.add('risk-critique');
            }
        }

        // Cellules grisées si Option = Accepter
        if (rowData.optionTrait === 'Accepter' && col >= 19) {
            td.classList.add('disabled-cell');
        }

        td.style.border = "1px solid #ccc";
    }

    // --- LOGIQUE DE FILTRAGE FIXÉE ---
    function applyFilters() {
        const selectedCat = document.getElementById('filterCategory').value;
        const selectedRisk = document.getElementById('filterRisk').value;

        // On part TOUJOURS de masterData pour filtrer
        const filtered = masterData.filter(item => {
            const matchesCat = !selectedCat || item.categorie === selectedCat;
            let matchesRisk = true;

            if (selectedRisk) {
                const s = parseInt(item.scoreRes) || 0;
                if (selectedRisk === 'faible') matchesRisk = s <= 12;
                else if (selectedRisk === 'modere') matchesRisk = (s > 12 && s <= 23);
                else if (selectedRisk === 'significatif') matchesRisk = (s > 23 && s <= 35);
                else if (selectedRisk === 'critique') matchesRisk = s > 35;
            }
            return matchesCat && matchesRisk;
        });

        // Mise à jour de Handsontable avec les données filtrées
        hot.loadData(filtered);

        // Recalcul important des fusions sur le nouveau set de données
        hot.updateSettings({
            mergeCells: calculateMerges(filtered)
        });
    }

    function resetFilters() {
        document.getElementById('filterCategory').value = "";
        document.getElementById('filterRisk').value = "";
        applyFilters();
    }

    // Chargement initial
    fetch('/rssi/risk-editor/data-json')
        .then(res => res.json())
        .then(data => {
            masterData = data; // Stockage original

            // Remplir le select des catégories
            const uniqueCats = [...new Set(data.map(i => i.categorie))].filter(Boolean).sort();
            const catSelect = document.getElementById('filterCategory');
            uniqueCats.forEach(c => catSelect.add(new Option(c, c)));

            // Config Handsontable
            const container = document.getElementById('hot-container');
            hot = new Handsontable(container, {
                data: masterData,
                nestedHeaders: nestedHeaders,
                licenseKey: 'non-commercial-and-evaluation',
                rowHeaders: true,
                colWidths: [50, 250, 60, 150, 70, 100, 250, 200, 30, 30, 30, 30, 30, 30, 30, 45, 45, 60, 150, 200, 45, 45, 45, 60, 100],
                stretchH: 'all',
                manualColumnResize: true,
                mergeCells: calculateMerges(masterData),
                columns: [
                    { data: 'categorie', readOnly: true },
                    { data: 'menaces' }, { data: 'origine' }, { data: 'actifs' },
                    { data: 'ref', readOnly: true }, { data: 'proprio' },
                    { data: 'scenario' }, { data: 'vulner' },
                    { data: 'd', type: 'numeric' }, { data: 'i', type: 'numeric' }, { data: 'c', type: 'numeric' },
                    { data: 'impOrg' }, { data: 'impJur' }, { data: 'impImg' }, { data: 'impFin' },
                    { data: 'proba', type: 'numeric' }, { data: 'grav', type: 'numeric' },
                    { data: 'scoreRes', readOnly: true, type: 'numeric' },
                    { data: 'optionTrait', type: 'dropdown', source: ['Traiter (réduire)', 'Accepter', 'Surveiller / Accepter avec suivi', 'Transférer'] },
                    { data: 'actions' },
                    { data: 'besoinC', type: 'numeric' }, { data: 'probC', type: 'numeric' }, { data: 'gravC', type: 'numeric' },
                    { data: 'scoreCible', readOnly: true, type: 'numeric' },
                    { data: 'optionApres', readOnly: true }
                ],
                renderer: professionalRenderer,
                afterChange: function(changes, source) {
                    if (source === 'loadData' || !changes) return;

                    changes.forEach(([row, prop, oldVal, newVal]) => {
                        const rowData = this.getSourceDataAtRow(row);

                        // Recalcul Score Résiduel : Max(D,I,C) * Proba * Grav
                        if (['d', 'i', 'c', 'proba', 'grav'].includes(prop)) {
                            const maxDIC = Math.max(parseInt(rowData.d)||1, parseInt(rowData.i)||1, parseInt(rowData.c)||1);
                            const res = maxDIC * (parseInt(rowData.proba)||1) * (parseInt(rowData.grav)||1);
                            this.setDataAtRowProp(row, 'scoreRes', res, 'auto');
                        }

                        // Recalcul Score Cible
                        if (['besoinC', 'probC', 'gravC'].includes(prop)) {
                            const sc = (parseInt(rowData.besoinC)||1) * (parseInt(rowData.probC)||1) * (parseInt(rowData.gravC)||1);
                            this.setDataAtRowProp(row, 'scoreCible', sc, 'auto');
                        }
                    });

                    // Indispensable pour garder masterData à jour même pendant un filtrage
                    if (source !== 'auto') {
                        masterData = this.getSourceData();
                    }
                }
            });
        });

    function saveRiskData() {
        const currentData = hot.getSourceData();
        fetch('/rssi/risk-editor/save', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(currentData)
        }).then(res => res.text()).then(msg => {
            if(msg.includes("SUCCESS")) alert("🚀 Enregistrement réussi !");
            else alert("Erreur lors de la sauvegarde.");
        });
    }
</script>
</body>
</html>--%>



<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>ISO 27005 - Registre de Gestion des Risques</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { background-color: #f1f3f5; font-family: 'Segoe UI', sans-serif; }
        #hot-container {
            height: 70vh;
            width: 100%;
            margin-top: 10px;
            background: white;
            overflow: hidden;
            border-radius: 8px;
        }
        .toolbar {
            background: white;
            padding: 8px 15px;
            border-bottom: 2px solid #dc3545;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }
        .toolbar button i { margin-right: 5px; }
        .filter-bar {
            background: #f8f9fa;
            padding: 10px 15px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
            border-bottom: 1px solid #dee2e6;
        }
        /* Styles des headers */
        .handsontable thead tr:nth-child(1) th { background-color: #FF0000 !important; color: white !important; font-size: 14px !important; }
        .handsontable thead tr:nth-child(2) th { background-color: #002060 !important; color: white !important; font-size: 12px !important; }
        .handsontable thead tr:nth-child(3) th { background-color: #7d0b13 !important; color: white !important; }
        .handsontable thead tr:nth-child(4) th { background-color: #BDD7EE !important; color: #002060 !important; font-weight: bold !important; font-size: 9px !important; }

        .handsontable td.vertical-cat {
            background-color: #C6EFCE !important; color: #006100 !important;
            writing-mode: vertical-rl !important; transform: rotate(180deg) !important;
            text-align: center !important; font-weight: bold !important;
            border: 1px solid #000 !important;
        }

        .risk-faible { background-color: #92d050 !important; font-weight: bold; text-align: center; }
        .risk-modere { background-color: #ffff00 !important; font-weight: bold; text-align: center; }
        .risk-significatif { background-color: #ffc000 !important; font-weight: bold; text-align: center; }
        .risk-critique { background-color: #ff0000 !important; color: white !important; font-weight: bold; text-align: center; }
        .disabled-cell { background-color: #f3f4f6 !important; color: #9ca3af !important; }
        .currentRow { background-color: rgba(0, 120, 215, 0.1) !important; }
        .currentCol { background-color: rgba(0, 120, 215, 0.05) !important; }
        .htLeft { text-align: left !important; }
        .htCenter { text-align: center !important; }
        .htRight { text-align: right !important; }
        .htJustify { text-align: justify !important; }
    </style>
</head>
<body>

<!-- Barre d'outils principale -->
<div class="toolbar">
    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-shield-check-fill text-danger"></i> Registre de Gestion des Risques</h5>
    <div class="ms-auto d-flex gap-2">
        <button onclick="insertRowAbove()" class="btn btn-outline-primary btn-sm"><i class="bi bi-plus-lg"></i> Au-dessus</button>
        <button onclick="insertRowBelow()" class="btn btn-outline-primary btn-sm"><i class="bi bi-plus-lg"></i> En dessous</button>
        <button onclick="openCategoryModal()" class="btn btn-outline-success btn-sm"><i class="bi bi-plus-circle"></i> Ajouter catégorie</button>
        <button onclick="saveRiskData()" class="btn btn-success btn-sm"><i class="bi bi-save"></i> Enregistrer</button>
        <a href="/dashboard" class="btn btn-secondary btn-sm"><i class="bi bi-arrow-left"></i> Retour</a>
    </div>
</div>

<!-- Barre de filtres -->
<div class="filter-bar">
    <div class="d-flex align-items-center gap-1">
        <i class="bi bi-funnel"></i>
        <span>Catégorie :</span>
        <select id="filterCategory" class="form-select form-select-sm" style="width: auto;">
            <option value="">Toutes</option>
        </select>
    </div>
    <div class="d-flex align-items-center gap-1">
        <i class="bi bi-bar-chart"></i>
        <span>Risque :</span>
        <select id="filterRisk" class="form-select form-select-sm" style="width: auto;">
            <option value="">Tous</option>
            <option value="faible">Faible (≤12)</option>
            <option value="modere">Modéré (13-23)</option>
            <option value="significatif">Significatif (24-35)</option>
            <option value="critique">Critique (>35)</option>
        </select>
    </div>
    <button id="clearFilters" class="btn btn-outline-secondary btn-sm"><i class="bi bi-eraser"></i> Effacer</button>
</div>

<div id="hot-container"></div>

<!-- Modal pour choisir une catégorie -->
<div class="modal fade" id="categoryModal" tabindex="-1">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Ajouter une ligne avec catégorie</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <select id="categorySelect" class="form-select mb-2">
                    <option value="">Sélectionner une catégorie existante</option>
                </select>
                <div class="input-group">
                    <input type="text" id="newCategoryInput" class="form-control" placeholder="Ou nouvelle catégorie">
                    <button class="btn btn-outline-secondary" type="button" id="addNewCategoryBtn">Ajouter</button>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-primary" id="confirmCategory">OK</button>
            </div>
        </div>
    </div>
</div>

<!-- Toast pour notifications -->
<div id="toast" style="position: fixed; bottom: 20px; right: 20px; z-index: 9999; display: none;"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>

<script>
    let hot;
    let originalData = [];
    let lastSelectedCell = null;
    let categoryModal;

    // Initialisation du modal Bootstrap
    document.addEventListener('DOMContentLoaded', function() {
        categoryModal = new bootstrap.Modal(document.getElementById('categoryModal'));
    });

    // Configuration de l'en-tête imbriqué (4 lignes)
    const nestedHeaders = [
        [{label: 'Programme de gestion des risques', colspan: 25}],
        [{label: '', colspan: 8}, {label: 'APPRÉCIATION DE RISQUE', colspan: 10}, {label: 'TRAITEMENT DE RISQUE', colspan: 7}],
        ['Menaces', 'Origine', 'Actifs', 'REF', 'Proprio', 'Scenario', 'Vulnér.', 'Mesures',
            {label: 'Besoin sécurité', colspan: 3}, {label: 'Impact', colspan: 4}, 'Proba', 'Grav.', 'Risque Rés.',
            'Option', 'Actions', 'Besoin C.', 'P. Cible', 'G. Cible', 'Risque C.', 'Option A.'],
        ['', '', '', '', '', '', '', '', 'D', 'I', 'C', 'Org', 'Jurid', 'Img', 'Fin', '', '', '', '', '', '', '', '', '', '']
    ];

    // Définition des colonnes (25 colonnes)
    const columns = [
        { data: 'categorie', width: 45 },
        { data: 'menaces', width: 220 },
        { data: 'origine', width: 60 },
        { data: 'actifs', width: 140 },
        { data: 'ref', width: 60 },
        { data: 'proprio', width: 100 },
        { data: 'scenario', width: 250 },
        { data: 'vulner', width: 150 },
        { data: 'd', width: 25 },
        { data: 'i', width: 25 },
        { data: 'c', width: 25 },
        { data: 'impOrg', width: 25 },
        { data: 'impJur', width: 25 },
        { data: 'impImg', width: 25 },
        { data: 'impFin', width: 25 },
        { data: 'proba', width: 35 },
        { data: 'grav', width: 35 },
        { data: 'scoreRes', readOnly: true },
        { type: 'dropdown', data: 'optionTrait', source: ['Accepter', 'Surveiller / Accepter avec suivi', 'Traiter (réduire)' , 'Éviter / Transférer'] },
        { data: 'actions', width: 220 },
        { data: 'besoinC', width: 35 },
        { data: 'probC', width: 35 },
        { data: 'gravC', width: 35 },
        { data: 'scoreCible', readOnly: true },
        { data: 'optionApres', readOnly: true }
    ];

    // Valeurs par défaut pour une nouvelle ligne
    const defaultRow = {
        categorie: '',
        menaces: '',
        origine: '',
        actifs: '',
        ref: '',
        proprio: '',
        scenario: '',
        vulner: '',
        d: 1,
        i: 1,
        c: 1,
        impOrg: 1,
        impJur: 1,
        impImg: 1,
        impFin: 1,
        proba: 1,
        grav: 1,
        scoreRes: 1,
        optionTrait: 'Traiter (réduire)',
        actions: '',
        besoinC: 1,
        probC: 1,
        gravC: 1,
        scoreCible: 1,
        optionApres: ''
    };

    // --- Fonctions de calcul des fusions pour la colonne catégorie ---
    function calculateRiskMerges(data) {
        if (!data || data.length === 0) return [];
        let merges = [];
        let startRow = 0;
        let currentCat = data[0].categorie;
        for (let i = 1; i <= data.length; i++) {
            let nextCat = (i < data.length) ? data[i].categorie : null;
            if (nextCat !== currentCat || i === data.length) {
                let rowspan = i - startRow;
                if (rowspan > 1) merges.push({ row: startRow, col: 0, rowspan: rowspan, colspan: 1 });
                currentCat = nextCat;
                startRow = i;
            }
        }
        return merges;
    }

    // --- Renderer personnalisé avec gestion d'erreur ---
    function riskRenderer(instance, td, row, col, prop, value, cellProperties) {
        try {
            const baseRenderer = cellProperties.type === 'dropdown'
                ? Handsontable.renderers.DropdownRenderer
                : Handsontable.renderers.TextRenderer;
            baseRenderer.apply(this, arguments);

            const rowData = instance.getSourceDataAtRow(row);
            if (!rowData) return;

            if (col === 0) {
                td.classList.add('vertical-cat');
            }

            if (prop === 'scoreRes' || prop === 'scoreCible') {
                const val = parseInt(value) || 0;
                td.classList.remove('risk-faible', 'risk-modere', 'risk-significatif', 'risk-critique');
                if (val > 0) {
                    if (val <= 12) td.classList.add('risk-faible');
                    else if (val <= 23) td.classList.add('risk-modere');
                    else if (val <= 35) td.classList.add('risk-significatif');
                    else td.classList.add('risk-critique');
                }
            }

            if (rowData.optionTrait === 'Accepter' && col >= 19 && col <= 24) {
                td.classList.add('disabled-cell');
            } else {
                td.classList.remove('disabled-cell');
            }

            td.style.border = '1px solid #000';
        } catch (e) {
            console.error('Erreur dans riskRenderer :', e, { row, col, prop, value });
            td.textContent = value || '';
        }
    }

    // --- Fonctions d'insertion de ligne (simple) ---
    function insertRowAbove() {
        const selected = hot.getSelectedLast();
        let index = 0;
        if (selected) {
            index = selected[0];
        } else {
            index = hot.countRows();
        }
        hot.alter('insert_row_above', index, 1);
        const categoryAbove = hot.getDataAtRowProp(index + 1, 'categorie') || '';
        hot.setDataAtRowProp(index, 'categorie', categoryAbove);
        for (let prop in defaultRow) {
            hot.setDataAtRowProp(index, prop, defaultRow[prop], 'auto');
        }
        showToast('Ligne insérée au-dessus');
    }

    function insertRowBelow() {
        const selected = hot.getSelectedLast();
        let index = hot.countRows() - 1;
        if (selected) {
            index = selected[2];
        }
        hot.alter('insert_row_below', index, 1);
        const newRowIndex = index + 1;
        const categoryBelow = hot.getDataAtRowProp(index, 'categorie') || '';
        hot.setDataAtRowProp(newRowIndex, 'categorie', categoryBelow);
        for (let prop in defaultRow) {
            hot.setDataAtRowProp(newRowIndex, prop, defaultRow[prop], 'auto');
        }
        showToast('Ligne insérée en dessous');
    }

    // --- Gestion du modal de catégorie ---
    function openCategoryModal(targetRow, targetCol) {
        // Mémoriser la cellule cible (si appelée depuis le menu contextuel) - pas utilisé ici mais on garde
        if (targetRow !== undefined && targetCol !== undefined) {
            // On pourrait s'en servir mais on va simplement insérer à la fin du groupe
        }
        populateCategoryModal();
        categoryModal.show();
    }

    function populateCategoryModal() {
        // Récupérer toutes les catégories existantes (distinctes)
        const allData = hot.getData();
        const categories = [...new Set(allData.map(row => row[0]).filter(c => c && c.trim() !== ''))];
        const select = document.getElementById('categorySelect');
        select.innerHTML = '<option value="">Sélectionner une catégorie existante</option>';
        categories.forEach(cat => {
            const option = document.createElement('option');
            option.value = cat;
            option.textContent = cat;
            select.appendChild(option);
        });
        document.getElementById('newCategoryInput').value = '';
    }

    document.getElementById('addNewCategoryBtn').addEventListener('click', function() {
        const newCat = document.getElementById('newCategoryInput').value.trim();
        if (newCat) {
            const select = document.getElementById('categorySelect');
            const option = document.createElement('option');
            option.value = newCat;
            option.textContent = newCat;
            option.selected = true;
            select.appendChild(option);
        }
    });

    document.getElementById('confirmCategory').addEventListener('click', function() {
        const select = document.getElementById('categorySelect');
        let category = select.value;
        const newCatInput = document.getElementById('newCategoryInput').value.trim();
        if (newCatInput) {
            category = newCatInput;
        }
        if (!category) {
            showToast('Veuillez choisir ou saisir une catégorie', 'warning');
            return;
        }
        categoryModal.hide();
        // Insérer une ligne avec cette catégorie
        addRowWithCategory(category);
    });

    // Fonction pour insérer une ligne avec une catégorie donnée
    function addRowWithCategory(category) {
        try {
            // Déterminer où insérer la ligne
            const allData = hot.getData();
            // Chercher la dernière ligne ayant cette catégorie (colonne 0)
            let lastIndex = -1;
            for (let i = 0; i < allData.length; i++) {
                if (allData[i][0] === category) {
                    lastIndex = i;
                }
            }
            let insertIndex;
            if (lastIndex !== -1) {
                insertIndex = lastIndex + 1; // après la dernière occurrence
            } else {
                // Nouvelle catégorie : insérer à la fin
                insertIndex = allData.length;
            }

            // Insérer la ligne à l'index calculé
            hot.alter('insert_row_below', insertIndex, 1);
            const newRowIndex = insertIndex;

            // Créer la nouvelle ligne avec les valeurs par défaut
            const newRow = { ...defaultRow, categorie: category };
            for (let prop in newRow) {
                hot.setDataAtRowProp(newRowIndex, prop, newRow[prop], 'auto');
            }

            // Sélectionner la nouvelle ligne (colonne 1 par exemple)
            hot.selectCell(newRowIndex, 1);
            showToast('Ligne ajoutée avec succès.');
        } catch (e) {
            console.error(e);
            showToast('Erreur : ' + e.message, 'error');
        }
    }

    // Raccourci pour le bouton
    window.openCategoryModal = openCategoryModal;

    // --- Toast personnalisé ---
    function showToast(message, type = 'success') {
        const toast = document.getElementById('toast');
        toast.style.display = 'block';
        toast.style.backgroundColor = type === 'success' ? '#28a745' : (type === 'error' ? '#dc3545' : '#ffc107');
        toast.style.color = 'white';
        toast.style.padding = '10px 20px';
        toast.style.borderRadius = '5px';
        toast.style.boxShadow = '0 2px 10px rgba(0,0,0,0.2)';
        toast.textContent = message;
        setTimeout(() => { toast.style.display = 'none'; }, 3000);
    }

    window.insertRowAbove = insertRowAbove;
    window.insertRowBelow = insertRowBelow;

    // --- Chargement des données depuis le serveur ---
    fetch('/rssi/risk-editor/data-json')
        .then(res => res.json())
        .then(data => {
            originalData = data;
            initHandsontable(data);
            populateCategoryFilter(data);
        })
        .catch(err => {
            console.error('Erreur chargement données :', err);
            showToast('Erreur de chargement des données', 'error');
        });

    // --- Initialisation de Handsontable ---
    function initHandsontable(data) {
        const container = document.getElementById('hot-container');

        hot = new Handsontable(container, {
            data: data,
            nestedHeaders: nestedHeaders,
            licenseKey: 'non-commercial-and-evaluation',
            rowHeaders: true,
            colHeaders: true,
            manualColumnResize: true,
            stretchH: 'all',
            columns: columns,
            mergeCells: calculateRiskMerges(data),
            cells: function(row, col) {
                return { renderer: riskRenderer };
            },
            filters: true,
            columnSorting: true,
            undo: true,
            manualRowMove: true, // Permet de déplacer les lignes par glisser-déposer
            allowInsertRow: false,
            allowRemoveRow: true,
            contextMenu: {
                items: {
                    'cut': { name: 'Couper' },
                    'copy': { name: 'Copier' },
                    'copy_with_column_headers': { name: 'Copier avec en-têtes' },
                    'paste': { name: 'Coller' },
                    'separator1': '---------',
                    'add_category': {
                        name: 'Ajouter une ligne (choisir catégorie)',
                        callback: function() {
                            openCategoryModal();
                        }
                    },
                    'separator2': '---------',
                    'row_above_custom': {
                        name: 'Insérer une ligne au-dessus (même catégorie)',
                        callback: insertRowAbove
                    },
                    'row_below_custom': {
                        name: 'Insérer une ligne en dessous (même catégorie)',
                        callback: insertRowBelow
                    },
                    'remove_row': {
                        name: 'Supprimer la ligne',
                        callback: function() {
                            const selected = this.getSelected();
                            if (selected) {
                                const rows = selected.map(r => r[0]).sort((a,b) => b-a);
                                rows.forEach(row => this.alter('remove_row', row, 1));
                                showToast('Ligne(s) supprimée(s)');
                            }
                        }
                    },
                    'separator3': '---------',
                    'merge_categories': {
                        name: 'Fusionner les catégories identiques',
                        callback: function() {
                            const currentData = this.getData();
                            this.updateSettings({ mergeCells: calculateRiskMerges(currentData) });
                            showToast('Fusions recalculées');
                        }
                    },
                    'separator4': '---------',
                    'alignment': {
                        name: 'Alignement',
                        submenu: {
                            items: [
                                {
                                    key: 'alignment:left',
                                    name: 'Gauche',
                                    callback: function() {
                                        applyAlignment('htLeft');
                                    }
                                },
                                {
                                    key: 'alignment:center',
                                    name: 'Centre',
                                    callback: function() {
                                        applyAlignment('htCenter');
                                    }
                                },
                                {
                                    key: 'alignment:right',
                                    name: 'Droite',
                                    callback: function() {
                                        applyAlignment('htRight');
                                    }
                                },
                                {
                                    key: 'alignment:justify',
                                    name: 'Justifier',
                                    callback: function() {
                                        applyAlignment('htJustify');
                                    }
                                }
                            ]
                        }
                    },
                    'separator5': '---------',
                    'undo': { name: 'Annuler (Ctrl+Z)' },
                    'redo': { name: 'Rétablir (Ctrl+Y)' },
                    'separator6': '---------',
                    'filter_by_value': { name: 'Filtrer par valeur' },
                    'filter_clear': { name: 'Effacer les filtres' }
                }
            },
            currentRowClassName: 'currentRow',
            currentColClassName: 'currentCol'
        });

        // Mémoriser la dernière cellule cliquée
        hot.addHook('afterOnCellMouseDown', function(event, coords) {
            if (coords.row >= 0 && coords.col >= 0) {
                lastSelectedCell = coords;
            }
        });

        // Hook afterChange avec protection
        hot.addHook('afterChange', function(changes, source) {
            if (source === 'auto' || !changes) return;
            changes.forEach(([row, prop, oldVal, newVal]) => {
                try {
                    const rd = this.getSourceDataAtRow(row);
                    if (!rd) return;
                    if (['d', 'i', 'c', 'proba', 'grav'].includes(prop)) {
                        const d = parseInt(rd.d) || 1;
                        const i = parseInt(rd.i) || 1;
                        const c = parseInt(rd.c) || 1;
                        const p = parseInt(rd.proba) || 1;
                        const g = parseInt(rd.grav) || 1;
                        const res = Math.max(d, i, c) * p * g;
                        this.setDataAtRowProp(row, 'scoreRes', res, 'auto');
                        this.setDataAtRowProp(row, 'optionApres', res <= 12 ? 'Accepter' : ((res >= 13 && res < 23 )  ? 'Surveiller / Accepter avec suivi' :  (res >= 24 && res < 35 ) ? 'Traiter (réduire)'  : 'Éviter / Transférer') , 'auto');
                    }
                    if (['besoinC', 'probC', 'gravC'].includes(prop)) {
                        const b = parseInt(rd.besoinC) || 1;
                        const pc = parseInt(rd.probC) || 1;
                        const gc = parseInt(rd.gravC) || 1;
                        const scoreC = b * pc * gc;
                        this.setDataAtRowProp(row, 'scoreCible', scoreC, 'auto');
                        this.setDataAtRowProp(row, 'optionApres', scoreC <= 12 ? 'Accepter' : ((scoreC >= 13 && scoreC < 23 )  ? 'Surveiller / Accepter avec suivi' :  (scoreC >= 24 && scoreC < 35 ) ? 'Traiter (réduire)'  : 'Éviter / Transférer') , 'auto');
                    }
                } catch (e) {
                    console.error('Erreur dans afterChange :', e, { row, prop });
                }
            });
        });

        // Recalculer les fusions après modification de la catégorie
        hot.addHook('afterSetDataAtCell', function(changes) {
            if (!changes) return;
            if (changes.some(c => c[1] === 'categorie')) {
                const currentData = this.getData();
                this.updateSettings({ mergeCells: calculateRiskMerges(currentData) });
            }
        });

        // Fonction d'alignement
        function applyAlignment(className) {
            const selected = hot.getSelected();
            if (!selected) return;
            const [startRow, startCol, endRow, endCol] = selected[0];
            for (let r = startRow; r <= endRow; r++) {
                for (let c = startCol; c <= endCol; c++) {
                    let cellMeta = hot.getCellMeta(r, c);
                    let classes = cellMeta.className ? cellMeta.className.split(' ') : [];
                    classes = classes.filter(cls => !cls.startsWith('htLeft') && !cls.startsWith('htCenter') && !cls.startsWith('htRight') && !cls.startsWith('htJustify'));
                    classes.push(className);
                    hot.setCellMeta(r, c, 'className', classes.join(' '));
                }
            }
            hot.render();
            showToast('Alignement appliqué');
        }
    }

    // --- Peupler le filtre par catégorie ---
    function populateCategoryFilter(data) {
        const categories = [...new Set(data.map(item => item.categorie))];
        const select = document.getElementById('filterCategory');
        categories.forEach(cat => {
            const option = document.createElement('option');
            option.value = cat;
            option.textContent = cat;
            select.appendChild(option);
        });
    }

    // --- Gestion des filtres ---
    document.getElementById('filterCategory').addEventListener('change', applyFilters);
    document.getElementById('filterRisk').addEventListener('change', applyFilters);
    document.getElementById('clearFilters').addEventListener('click', function() {
        document.getElementById('filterCategory').value = '';
        document.getElementById('filterRisk').value = '';
        hot.loadData(originalData);
        hot.updateSettings({ mergeCells: calculateRiskMerges(originalData) });
        showToast('Filtres effacés');
    });




    function applyFilters() {
        const category = document.getElementById('filterCategory').value;
        const riskLevel = document.getElementById('filterRisk').value;

        // Si aucun filtre sélectionné, on recharge toutes les données
        if (!category && !riskLevel) {
            hot.loadData(originalData);
            hot.updateSettings({ mergeCells: calculateRiskMerges(originalData) });
            showToast('Filtres réinitialisés');
            return;
        }

        // Filtrage combiné (ET)
        let filtered = originalData.filter(item => {
            // Filtre par catégorie (si une catégorie est choisie)
            if (category && item.categorie !== category) return false;

            // Filtre par niveau de risque (si un niveau est choisi)
            if (riskLevel) {
                const score = parseInt(item.scoreRes) || 0;
                switch (riskLevel) {
                    case 'faible':
                        if (score > 12) return false;
                        break;
                    case 'modere':
                        if (score <= 12 || score > 23) return false;
                        break;
                    case 'significatif':
                        if (score <= 23 || score > 35) return false;
                        break;
                    case 'critique':
                        if (score <= 35) return false;
                        break;
                }
            }
            return true; // la ligne satisfait tous les filtres actifs
        });

        // Mise à jour de la table
        hot.loadData(filtered);
        hot.updateSettings({ mergeCells: calculateRiskMerges(filtered) });

        // Notification
        if (filtered.length === 0) {
            showToast('Aucune ligne ne correspond aux filtres', 'warning');
        } else {
            showToast(`Affichage de ${filtered.length} ligne(s)`);
        }
    }


    // --- Sauvegarde des données ---
    function saveRiskData() {
        const fullData = hot.getData();
        fetch('/rssi/risk-editor/save', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(fullData)
        })
            .then(res => res.text())
            .then(msg => {
                if(msg.includes("SUCCESS")) showToast('Sauvegardé avec succès');
                else showToast('Erreur lors de la sauvegarde', 'error');
            })
            .catch(err => showToast('Erreur réseau', 'error'));
    }
</script>
</body>
</html>

&lt;%&ndash;<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>&ndash;%&gt;
&lt;%&ndash;<%@ taglib uri="jakarta.tags.core" prefix="c" %>&ndash;%&gt;
&lt;%&ndash;<!DOCTYPE html>&ndash;%&gt;
&lt;%&ndash;<html lang="fr">&ndash;%&gt;
&lt;%&ndash;<head>&ndash;%&gt;
&lt;%&ndash;    <meta charset="UTF-8">&ndash;%&gt;
&lt;%&ndash;    <title>ISO 27005 - Registre de Gestion des Risques</title>&ndash;%&gt;

&lt;%&ndash;    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.css">&ndash;%&gt;
&lt;%&ndash;    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">&ndash;%&gt;
&lt;%&ndash;    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">&ndash;%&gt;

&lt;%&ndash;    <style>&ndash;%&gt;
&lt;%&ndash;        body { background-color: #f1f3f5; font-family: 'Segoe UI', sans-serif; }&ndash;%&gt;
&lt;%&ndash;        #hot-container {&ndash;%&gt;
&lt;%&ndash;            height: 70vh;&ndash;%&gt;
&lt;%&ndash;            width: 100%;&ndash;%&gt;
&lt;%&ndash;            margin-top: 10px;&ndash;%&gt;
&lt;%&ndash;            background: white;&ndash;%&gt;
&lt;%&ndash;            overflow: hidden;&ndash;%&gt;
&lt;%&ndash;            border-radius: 8px;&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        .toolbar {&ndash;%&gt;
&lt;%&ndash;            background: white;&ndash;%&gt;
&lt;%&ndash;            padding: 8px 15px;&ndash;%&gt;
&lt;%&ndash;            border-bottom: 2px solid #dc3545;&ndash;%&gt;
&lt;%&ndash;            display: flex;&ndash;%&gt;
&lt;%&ndash;            gap: 10px;&ndash;%&gt;
&lt;%&ndash;            flex-wrap: wrap;&ndash;%&gt;
&lt;%&ndash;            align-items: center;&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        .toolbar button i { margin-right: 5px; }&ndash;%&gt;
&lt;%&ndash;        .filter-bar {&ndash;%&gt;
&lt;%&ndash;            background: #f8f9fa;&ndash;%&gt;
&lt;%&ndash;            padding: 10px 15px;&ndash;%&gt;
&lt;%&ndash;            display: flex;&ndash;%&gt;
&lt;%&ndash;            gap: 15px;&ndash;%&gt;
&lt;%&ndash;            flex-wrap: wrap;&ndash;%&gt;
&lt;%&ndash;            align-items: center;&ndash;%&gt;
&lt;%&ndash;            border-bottom: 1px solid #dee2e6;&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        /* Styles des headers */&ndash;%&gt;
&lt;%&ndash;        .handsontable thead tr:nth-child(1) th { background-color: #FF0000 !important; color: white !important; font-size: 14px !important; }&ndash;%&gt;
&lt;%&ndash;        .handsontable thead tr:nth-child(2) th { background-color: #002060 !important; color: white !important; font-size: 12px !important; }&ndash;%&gt;
&lt;%&ndash;        .handsontable thead tr:nth-child(3) th { background-color: #7d0b13 !important; color: white !important; }&ndash;%&gt;
&lt;%&ndash;        .handsontable thead tr:nth-child(4) th { background-color: #BDD7EE !important; color: #002060 !important; font-weight: bold !important; font-size: 9px !important; }&ndash;%&gt;

&lt;%&ndash;        .handsontable td.vertical-cat {&ndash;%&gt;
&lt;%&ndash;            background-color: #C6EFCE !important; color: #006100 !important;&ndash;%&gt;
&lt;%&ndash;            writing-mode: vertical-rl !important; transform: rotate(180deg) !important;&ndash;%&gt;
&lt;%&ndash;            text-align: center !important; font-weight: bold !important;&ndash;%&gt;
&lt;%&ndash;            border: 1px solid #000 !important;&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;

&lt;%&ndash;        .risk-faible { background-color: #92d050 !important; font-weight: bold; text-align: center; }&ndash;%&gt;
&lt;%&ndash;        .risk-modere { background-color: #ffff00 !important; font-weight: bold; text-align: center; }&ndash;%&gt;
&lt;%&ndash;        .risk-significatif { background-color: #ffc000 !important; font-weight: bold; text-align: center; }&ndash;%&gt;
&lt;%&ndash;        .risk-critique { background-color: #ff0000 !important; color: white !important; font-weight: bold; text-align: center; }&ndash;%&gt;
&lt;%&ndash;        .disabled-cell { background-color: #f3f4f6 !important; color: #9ca3af !important; }&ndash;%&gt;
&lt;%&ndash;        .currentRow { background-color: rgba(0, 120, 215, 0.1) !important; }&ndash;%&gt;
&lt;%&ndash;        .currentCol { background-color: rgba(0, 120, 215, 0.05) !important; }&ndash;%&gt;
&lt;%&ndash;        .htLeft { text-align: left !important; }&ndash;%&gt;
&lt;%&ndash;        .htCenter { text-align: center !important; }&ndash;%&gt;
&lt;%&ndash;        .htRight { text-align: right !important; }&ndash;%&gt;
&lt;%&ndash;        .htJustify { text-align: justify !important; }&ndash;%&gt;
&lt;%&ndash;    </style>&ndash;%&gt;
&lt;%&ndash;</head>&ndash;%&gt;
&lt;%&ndash;<body>&ndash;%&gt;

&lt;%&ndash;<!-- Barre d'outils principale -->&ndash;%&gt;
&lt;%&ndash;<div class="toolbar">&ndash;%&gt;
&lt;%&ndash;    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-shield-check-fill text-danger"></i> Registre de Gestion des Risques</h5>&ndash;%&gt;
&lt;%&ndash;    <div class="ms-auto d-flex gap-2">&ndash;%&gt;
&lt;%&ndash;        <button onclick="insertRowAbove()" class="btn btn-outline-primary btn-sm"><i class="bi bi-plus-lg"></i> Au-dessus</button>&ndash;%&gt;
&lt;%&ndash;        <button onclick="insertRowBelow()" class="btn btn-outline-primary btn-sm"><i class="bi bi-plus-lg"></i> En dessous</button>&ndash;%&gt;
&lt;%&ndash;        <button onclick="openThreatModal()" class="btn btn-outline-success btn-sm"><i class="bi bi-plus-circle"></i> Ajouter menace</button>&ndash;%&gt;
&lt;%&ndash;        <button onclick="saveRiskData()" class="btn btn-success btn-sm"><i class="bi bi-save"></i> Enregistrer</button>&ndash;%&gt;
&lt;%&ndash;        <a href="/dashboard" class="btn btn-secondary btn-sm"><i class="bi bi-arrow-left"></i> Retour</a>&ndash;%&gt;
&lt;%&ndash;    </div>&ndash;%&gt;
&lt;%&ndash;</div>&ndash;%&gt;

&lt;%&ndash;<!-- Barre de filtres -->&ndash;%&gt;
&lt;%&ndash;<div class="filter-bar">&ndash;%&gt;
&lt;%&ndash;    <div class="d-flex align-items-center gap-1">&ndash;%&gt;
&lt;%&ndash;        <i class="bi bi-funnel"></i>&ndash;%&gt;
&lt;%&ndash;        <span>Catégorie :</span>&ndash;%&gt;
&lt;%&ndash;        <select id="filterCategory" class="form-select form-select-sm" style="width: auto;">&ndash;%&gt;
&lt;%&ndash;            <option value="">Toutes</option>&ndash;%&gt;
&lt;%&ndash;        </select>&ndash;%&gt;
&lt;%&ndash;    </div>&ndash;%&gt;
&lt;%&ndash;    <div class="d-flex align-items-center gap-1">&ndash;%&gt;
&lt;%&ndash;        <i class="bi bi-bar-chart"></i>&ndash;%&gt;
&lt;%&ndash;        <span>Risque :</span>&ndash;%&gt;
&lt;%&ndash;        <select id="filterRisk" class="form-select form-select-sm" style="width: auto;">&ndash;%&gt;
&lt;%&ndash;            <option value="">Tous</option>&ndash;%&gt;
&lt;%&ndash;            <option value="faible">Faible (≤12)</option>&ndash;%&gt;
&lt;%&ndash;            <option value="modere">Modéré (13-23)</option>&ndash;%&gt;
&lt;%&ndash;            <option value="significatif">Significatif (24-35)</option>&ndash;%&gt;
&lt;%&ndash;            <option value="critique">Critique (>35)</option>&ndash;%&gt;
&lt;%&ndash;        </select>&ndash;%&gt;
&lt;%&ndash;    </div>&ndash;%&gt;
&lt;%&ndash;    <button id="clearFilters" class="btn btn-outline-secondary btn-sm"><i class="bi bi-eraser"></i> Effacer</button>&ndash;%&gt;
&lt;%&ndash;</div>&ndash;%&gt;

&lt;%&ndash;<div id="hot-container"></div>&ndash;%&gt;

&lt;%&ndash;<!-- Modal pour choisir une menace -->&ndash;%&gt;
&lt;%&ndash;<div class="modal fade" id="threatModal" tabindex="-1">&ndash;%&gt;
&lt;%&ndash;    <div class="modal-dialog modal-sm">&ndash;%&gt;
&lt;%&ndash;        <div class="modal-content">&ndash;%&gt;
&lt;%&ndash;            <div class="modal-header">&ndash;%&gt;
&lt;%&ndash;                <h5 class="modal-title">Ajouter une menace</h5>&ndash;%&gt;
&lt;%&ndash;                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>&ndash;%&gt;
&lt;%&ndash;            </div>&ndash;%&gt;
&lt;%&ndash;            <div class="modal-body">&ndash;%&gt;
&lt;%&ndash;                <select id="threatSelect" class="form-select mb-2">&ndash;%&gt;
&lt;%&ndash;                    <option value="">Sélectionner une menace existante</option>&ndash;%&gt;
&lt;%&ndash;                </select>&ndash;%&gt;
&lt;%&ndash;                <div class="input-group">&ndash;%&gt;
&lt;%&ndash;                    <input type="text" id="newThreatInput" class="form-control" placeholder="Ou nouvelle menace">&ndash;%&gt;
&lt;%&ndash;                    <button class="btn btn-outline-secondary" type="button" id="addNewThreatBtn">Ajouter</button>&ndash;%&gt;
&lt;%&ndash;                </div>&ndash;%&gt;
&lt;%&ndash;            </div>&ndash;%&gt;
&lt;%&ndash;            <div class="modal-footer">&ndash;%&gt;
&lt;%&ndash;                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>&ndash;%&gt;
&lt;%&ndash;                <button type="button" class="btn btn-primary" id="confirmThreat">OK</button>&ndash;%&gt;
&lt;%&ndash;            </div>&ndash;%&gt;
&lt;%&ndash;        </div>&ndash;%&gt;
&lt;%&ndash;    </div>&ndash;%&gt;
&lt;%&ndash;</div>&ndash;%&gt;

&lt;%&ndash;<!-- Toast pour notifications -->&ndash;%&gt;
&lt;%&ndash;<div id="toast" style="position: fixed; bottom: 20px; right: 20px; z-index: 9999; display: none;"></div>&ndash;%&gt;

&lt;%&ndash;<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>&ndash;%&gt;
&lt;%&ndash;<script src="https://cdn.jsdelivr.net/npm/handsontable@14.0.0/dist/handsontable.full.min.js"></script>&ndash;%&gt;

&lt;%&ndash;<script>&ndash;%&gt;
&lt;%&ndash;    let hot;&ndash;%&gt;
&lt;%&ndash;    let originalData = [];&ndash;%&gt;
&lt;%&ndash;    let lastSelectedCell = null;&ndash;%&gt;
&lt;%&ndash;    let threatModal;&ndash;%&gt;
&lt;%&ndash;    let pendingThreatRow = null; // pour savoir si on insère à partir d'une ligne spécifique (optionnel)&ndash;%&gt;

&lt;%&ndash;    // Initialisation du modal Bootstrap&ndash;%&gt;
&lt;%&ndash;    document.addEventListener('DOMContentLoaded', function() {&ndash;%&gt;
&lt;%&ndash;        threatModal = new bootstrap.Modal(document.getElementById('threatModal'));&ndash;%&gt;
&lt;%&ndash;    });&ndash;%&gt;

&lt;%&ndash;    // Configuration de l'en-tête imbriqué (4 lignes)&ndash;%&gt;
&lt;%&ndash;    const nestedHeaders = [&ndash;%&gt;
&lt;%&ndash;        [{label: 'Programme de gestion des risques', colspan: 25}],&ndash;%&gt;
&lt;%&ndash;        [{label: '', colspan: 8}, {label: 'APPRÉCIATION DE RISQUE', colspan: 10}, {label: 'TRAITEMENT DE RISQUE', colspan: 7}],&ndash;%&gt;
&lt;%&ndash;        ['Menaces', 'Origine', 'Actifs', 'REF', 'Proprio', 'Scenario', 'Vulnér.', 'Mesures',&ndash;%&gt;
&lt;%&ndash;            {label: 'Besoin sécurité', colspan: 3}, {label: 'Impact', colspan: 4}, 'Proba', 'Grav.', 'Risque Rés.',&ndash;%&gt;
&lt;%&ndash;            'Option', 'Actions', 'Besoin C.', 'P. Cible', 'G. Cible', 'Risque C.', 'Option A.'],&ndash;%&gt;
&lt;%&ndash;        ['', '', '', '', '', '', '', '', 'D', 'I', 'C', 'Org', 'Jurid', 'Img', 'Fin', '', '', '', '', '', '', '', '', '', '']&ndash;%&gt;
&lt;%&ndash;    ];&ndash;%&gt;

&lt;%&ndash;    // Définition des colonnes (25 colonnes)&ndash;%&gt;
&lt;%&ndash;    const columns = [&ndash;%&gt;
&lt;%&ndash;        { data: 'categorie', width: 45 },&ndash;%&gt;
&lt;%&ndash;        { data: 'menaces', width: 220 },&ndash;%&gt;
&lt;%&ndash;        { data: 'origine', width: 60 },&ndash;%&gt;
&lt;%&ndash;        { data: 'actifs', width: 140 },&ndash;%&gt;
&lt;%&ndash;        { data: 'ref', width: 60, readOnly: true },&ndash;%&gt;
&lt;%&ndash;        { data: 'proprio', width: 100 },&ndash;%&gt;
&lt;%&ndash;        { data: 'scenario', width: 250 },&ndash;%&gt;
&lt;%&ndash;        { data: 'vulner', width: 150 },&ndash;%&gt;
&lt;%&ndash;        { data: 'd', width: 25 },&ndash;%&gt;
&lt;%&ndash;        { data: 'i', width: 25 },&ndash;%&gt;
&lt;%&ndash;        { data: 'c', width: 25 },&ndash;%&gt;
&lt;%&ndash;        { data: 'impOrg', width: 25 },&ndash;%&gt;
&lt;%&ndash;        { data: 'impJur', width: 25 },&ndash;%&gt;
&lt;%&ndash;        { data: 'impImg', width: 25 },&ndash;%&gt;
&lt;%&ndash;        { data: 'impFin', width: 25 },&ndash;%&gt;
&lt;%&ndash;        { data: 'proba', width: 35 },&ndash;%&gt;
&lt;%&ndash;        { data: 'grav', width: 35 },&ndash;%&gt;
&lt;%&ndash;        { data: 'scoreRes', readOnly: true },&ndash;%&gt;
&lt;%&ndash;        { type: 'dropdown', data: 'optionTrait', source: ['Réduire', 'Accepter', 'Transférer'] },&ndash;%&gt;
&lt;%&ndash;        { data: 'actions', width: 220 },&ndash;%&gt;
&lt;%&ndash;        { data: 'besoinC', width: 35 },&ndash;%&gt;
&lt;%&ndash;        { data: 'probC', width: 35 },&ndash;%&gt;
&lt;%&ndash;        { data: 'gravC', width: 35 },&ndash;%&gt;
&lt;%&ndash;        { data: 'scoreCible', readOnly: true },&ndash;%&gt;
&lt;%&ndash;        { data: 'optionApres', readOnly: true }&ndash;%&gt;
&lt;%&ndash;    ];&ndash;%&gt;

&lt;%&ndash;    // Valeurs par défaut pour une nouvelle ligne&ndash;%&gt;
&lt;%&ndash;    const defaultRow = {&ndash;%&gt;
&lt;%&ndash;        categorie: '',&ndash;%&gt;
&lt;%&ndash;        menaces: '',&ndash;%&gt;
&lt;%&ndash;        origine: '',&ndash;%&gt;
&lt;%&ndash;        actifs: '',&ndash;%&gt;
&lt;%&ndash;        ref: '',&ndash;%&gt;
&lt;%&ndash;        proprio: '',&ndash;%&gt;
&lt;%&ndash;        scenario: '',&ndash;%&gt;
&lt;%&ndash;        vulner: '',&ndash;%&gt;
&lt;%&ndash;        d: 1,&ndash;%&gt;
&lt;%&ndash;        i: 1,&ndash;%&gt;
&lt;%&ndash;        c: 1,&ndash;%&gt;
&lt;%&ndash;        impOrg: 1,&ndash;%&gt;
&lt;%&ndash;        impJur: 1,&ndash;%&gt;
&lt;%&ndash;        impImg: 1,&ndash;%&gt;
&lt;%&ndash;        impFin: 1,&ndash;%&gt;
&lt;%&ndash;        proba: 1,&ndash;%&gt;
&lt;%&ndash;        grav: 1,&ndash;%&gt;
&lt;%&ndash;        scoreRes: 1,&ndash;%&gt;
&lt;%&ndash;        optionTrait: 'Réduire',&ndash;%&gt;
&lt;%&ndash;        actions: '',&ndash;%&gt;
&lt;%&ndash;        besoinC: 1,&ndash;%&gt;
&lt;%&ndash;        probC: 1,&ndash;%&gt;
&lt;%&ndash;        gravC: 1,&ndash;%&gt;
&lt;%&ndash;        scoreCible: 1,&ndash;%&gt;
&lt;%&ndash;        optionApres: ''&ndash;%&gt;
&lt;%&ndash;    };&ndash;%&gt;

&lt;%&ndash;    // --- Fonctions de calcul des fusions pour la colonne catégorie ---&ndash;%&gt;
&lt;%&ndash;    function calculateRiskMerges(data) {&ndash;%&gt;
&lt;%&ndash;        if (!data || data.length === 0) return [];&ndash;%&gt;
&lt;%&ndash;        let merges = [];&ndash;%&gt;
&lt;%&ndash;        let startRow = 0;&ndash;%&gt;
&lt;%&ndash;        let currentCat = data[0].categorie;&ndash;%&gt;
&lt;%&ndash;        for (let i = 1; i <= data.length; i++) {&ndash;%&gt;
&lt;%&ndash;            let nextCat = (i < data.length) ? data[i].categorie : null;&ndash;%&gt;
&lt;%&ndash;            if (nextCat !== currentCat || i === data.length) {&ndash;%&gt;
&lt;%&ndash;                let rowspan = i - startRow;&ndash;%&gt;
&lt;%&ndash;                if (rowspan > 1) merges.push({ row: startRow, col: 0, rowspan: rowspan, colspan: 1 });&ndash;%&gt;
&lt;%&ndash;                currentCat = nextCat;&ndash;%&gt;
&lt;%&ndash;                startRow = i;&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        return merges;&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    // --- Renderer personnalisé avec gestion d'erreur ---&ndash;%&gt;
&lt;%&ndash;    function riskRenderer(instance, td, row, col, prop, value, cellProperties) {&ndash;%&gt;
&lt;%&ndash;        try {&ndash;%&gt;
&lt;%&ndash;            const baseRenderer = cellProperties.type === 'dropdown'&ndash;%&gt;
&lt;%&ndash;                ? Handsontable.renderers.DropdownRenderer&ndash;%&gt;
&lt;%&ndash;                : Handsontable.renderers.TextRenderer;&ndash;%&gt;
&lt;%&ndash;            baseRenderer.apply(this, arguments);&ndash;%&gt;

&lt;%&ndash;            const rowData = instance.getSourceDataAtRow(row);&ndash;%&gt;
&lt;%&ndash;            if (!rowData) return;&ndash;%&gt;

&lt;%&ndash;            if (col === 0) {&ndash;%&gt;
&lt;%&ndash;                td.classList.add('vertical-cat');&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;

&lt;%&ndash;            if (prop === 'scoreRes' || prop === 'scoreCible') {&ndash;%&gt;
&lt;%&ndash;                const val = parseInt(value) || 0;&ndash;%&gt;
&lt;%&ndash;                td.classList.remove('risk-faible', 'risk-modere', 'risk-significatif', 'risk-critique');&ndash;%&gt;
&lt;%&ndash;                if (val > 0) {&ndash;%&gt;
&lt;%&ndash;                    if (val <= 12) td.classList.add('risk-faible');&ndash;%&gt;
&lt;%&ndash;                    else if (val <= 23) td.classList.add('risk-modere');&ndash;%&gt;
&lt;%&ndash;                    else if (val <= 35) td.classList.add('risk-significatif');&ndash;%&gt;
&lt;%&ndash;                    else td.classList.add('risk-critique');&ndash;%&gt;
&lt;%&ndash;                }&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;

&lt;%&ndash;            if (rowData.optionTrait === 'Accepter' && col >= 19 && col <= 24) {&ndash;%&gt;
&lt;%&ndash;                td.classList.add('disabled-cell');&ndash;%&gt;
&lt;%&ndash;            } else {&ndash;%&gt;
&lt;%&ndash;                td.classList.remove('disabled-cell');&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;

&lt;%&ndash;            td.style.border = '1px solid #000';&ndash;%&gt;
&lt;%&ndash;        } catch (e) {&ndash;%&gt;
&lt;%&ndash;            console.error('Erreur dans riskRenderer :', e, { row, col, prop, value });&ndash;%&gt;
&lt;%&ndash;            td.textContent = value || '';&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    // --- Fonctions d'insertion de ligne (simple) ---&ndash;%&gt;
&lt;%&ndash;    function insertRowAbove() {&ndash;%&gt;
&lt;%&ndash;        const selected = hot.getSelectedLast();&ndash;%&gt;
&lt;%&ndash;        let index = 0;&ndash;%&gt;
&lt;%&ndash;        if (selected) {&ndash;%&gt;
&lt;%&ndash;            index = selected[0];&ndash;%&gt;
&lt;%&ndash;        } else {&ndash;%&gt;
&lt;%&ndash;            index = hot.countRows();&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        hot.alter('insert_row_above', index, 1);&ndash;%&gt;
&lt;%&ndash;        const categoryAbove = hot.getDataAtRowProp(index + 1, 'categorie') || '';&ndash;%&gt;
&lt;%&ndash;        hot.setDataAtRowProp(index, 'categorie', categoryAbove);&ndash;%&gt;
&lt;%&ndash;        for (let prop in defaultRow) {&ndash;%&gt;
&lt;%&ndash;            hot.setDataAtRowProp(index, prop, defaultRow[prop], 'auto');&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        showToast('Ligne insérée au-dessus');&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    function insertRowBelow() {&ndash;%&gt;
&lt;%&ndash;        const selected = hot.getSelectedLast();&ndash;%&gt;
&lt;%&ndash;        let index = hot.countRows() - 1;&ndash;%&gt;
&lt;%&ndash;        if (selected) {&ndash;%&gt;
&lt;%&ndash;            index = selected[2];&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        hot.alter('insert_row_below', index, 1);&ndash;%&gt;
&lt;%&ndash;        const newRowIndex = index + 1;&ndash;%&gt;
&lt;%&ndash;        const categoryBelow = hot.getDataAtRowProp(index, 'categorie') || '';&ndash;%&gt;
&lt;%&ndash;        hot.setDataAtRowProp(newRowIndex, 'categorie', categoryBelow);&ndash;%&gt;
&lt;%&ndash;        for (let prop in defaultRow) {&ndash;%&gt;
&lt;%&ndash;            hot.setDataAtRowProp(newRowIndex, prop, defaultRow[prop], 'auto');&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        showToast('Ligne insérée en dessous');&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    // --- Gestion du modal de menace ---&ndash;%&gt;
&lt;%&ndash;    function openThreatModal(targetRow, targetCol) {&ndash;%&gt;
&lt;%&ndash;        // Mémoriser la cellule cible (si appelée depuis le menu contextuel)&ndash;%&gt;
&lt;%&ndash;        if (targetRow !== undefined && targetCol !== undefined) {&ndash;%&gt;
&lt;%&ndash;            pendingThreatRow = { row: targetRow, col: targetCol };&ndash;%&gt;
&lt;%&ndash;        } else {&ndash;%&gt;
&lt;%&ndash;            // Utiliser la sélection ou la dernière cellule cliquée&ndash;%&gt;
&lt;%&ndash;            const selected = hot.getSelectedLast();&ndash;%&gt;
&lt;%&ndash;            if (selected) {&ndash;%&gt;
&lt;%&ndash;                pendingThreatRow = { row: selected[0], col: selected[1] };&ndash;%&gt;
&lt;%&ndash;            } else if (lastSelectedCell) {&ndash;%&gt;
&lt;%&ndash;                pendingThreatRow = lastSelectedCell;&ndash;%&gt;
&lt;%&ndash;            } else {&ndash;%&gt;
&lt;%&ndash;                pendingThreatRow = null; // insertion à la fin sans référence&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        populateThreatModal();&ndash;%&gt;
&lt;%&ndash;        threatModal.show();&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    function populateThreatModal() {&ndash;%&gt;
&lt;%&ndash;        // Récupérer toutes les menaces existantes (distinctes)&ndash;%&gt;
&lt;%&ndash;        const allData = hot.getData();&ndash;%&gt;
&lt;%&ndash;        const menaces = [...new Set(allData.map(row => row[1]).filter(m => m && m.trim() !== ''))];&ndash;%&gt;
&lt;%&ndash;        const select = document.getElementById('threatSelect');&ndash;%&gt;
&lt;%&ndash;        select.innerHTML = '<option value="">Sélectionner une menace existante</option>';&ndash;%&gt;
&lt;%&ndash;        menaces.forEach(menace => {&ndash;%&gt;
&lt;%&ndash;            const option = document.createElement('option');&ndash;%&gt;
&lt;%&ndash;            option.value = menace;&ndash;%&gt;
&lt;%&ndash;            option.textContent = menace;&ndash;%&gt;
&lt;%&ndash;            select.appendChild(option);&ndash;%&gt;
&lt;%&ndash;        });&ndash;%&gt;
&lt;%&ndash;        document.getElementById('newThreatInput').value = '';&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    document.getElementById('addNewThreatBtn').addEventListener('click', function() {&ndash;%&gt;
&lt;%&ndash;        const newMenace = document.getElementById('newThreatInput').value.trim();&ndash;%&gt;
&lt;%&ndash;        if (newMenace) {&ndash;%&gt;
&lt;%&ndash;            const select = document.getElementById('threatSelect');&ndash;%&gt;
&lt;%&ndash;            const option = document.createElement('option');&ndash;%&gt;
&lt;%&ndash;            option.value = newMenace;&ndash;%&gt;
&lt;%&ndash;            option.textContent = newMenace;&ndash;%&gt;
&lt;%&ndash;            option.selected = true;&ndash;%&gt;
&lt;%&ndash;            select.appendChild(option);&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;    });&ndash;%&gt;

&lt;%&ndash;    document.getElementById('confirmThreat').addEventListener('click', function() {&ndash;%&gt;
&lt;%&ndash;        const select = document.getElementById('threatSelect');&ndash;%&gt;
&lt;%&ndash;        let menace = select.value;&ndash;%&gt;
&lt;%&ndash;        const newMenaceInput = document.getElementById('newThreatInput').value.trim();&ndash;%&gt;
&lt;%&ndash;        if (newMenaceInput) {&ndash;%&gt;
&lt;%&ndash;            menace = newMenaceInput;&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        if (!menace) {&ndash;%&gt;
&lt;%&ndash;            showToast('Veuillez choisir ou saisir une menace', 'warning');&ndash;%&gt;
&lt;%&ndash;            return;&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;        threatModal.hide();&ndash;%&gt;
&lt;%&ndash;        // Insérer une ligne avec cette menace&ndash;%&gt;
&lt;%&ndash;        addThreatWithMenace(menace);&ndash;%&gt;
&lt;%&ndash;    });&ndash;%&gt;

&lt;%&ndash;    // Fonction pour insérer une ligne avec une menace donnée&ndash;%&gt;
&lt;%&ndash;    function addThreatWithMenace(menace) {&ndash;%&gt;
&lt;%&ndash;        try {&ndash;%&gt;
&lt;%&ndash;            // Déterminer où insérer la ligne&ndash;%&gt;
&lt;%&ndash;            let insertIndex;&ndash;%&gt;
&lt;%&ndash;            const allData = hot.getData();&ndash;%&gt;
&lt;%&ndash;            // Chercher la dernière ligne ayant cette menace (pour regrouper)&ndash;%&gt;
&lt;%&ndash;            let lastIndex = -1;&ndash;%&gt;
&lt;%&ndash;            for (let i = 0; i < allData.length; i++) {&ndash;%&gt;
&lt;%&ndash;                if (allData[i][1] === menace) { // colonne menaces à l'index 1&ndash;%&gt;
&lt;%&ndash;                    lastIndex = i;&ndash;%&gt;
&lt;%&ndash;                }&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;
&lt;%&ndash;            if (lastIndex !== -1) {&ndash;%&gt;
&lt;%&ndash;                insertIndex = lastIndex + 1; // après la dernière occurrence&ndash;%&gt;
&lt;%&ndash;            } else {&ndash;%&gt;
&lt;%&ndash;                // Nouvelle menace : insérer à la fin&ndash;%&gt;
&lt;%&ndash;                insertIndex = allData.length;&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;

&lt;%&ndash;            // Récupérer la catégorie à utiliser (si on a une ligne de référence, on prend sa catégorie)&ndash;%&gt;
&lt;%&ndash;            let category = '';&ndash;%&gt;
&lt;%&ndash;            if (pendingThreatRow && pendingThreatRow.row !== undefined) {&ndash;%&gt;
&lt;%&ndash;                category = hot.getDataAtRowProp(pendingThreatRow.row, 'categorie') || '';&ndash;%&gt;
&lt;%&ndash;                if (!category) {&ndash;%&gt;
&lt;%&ndash;                    // chercher dans les lignes fusionnées&ndash;%&gt;
&lt;%&ndash;                    for (let r = pendingThreatRow.row - 1; r >= 0; r--) {&ndash;%&gt;
&lt;%&ndash;                        const cat = hot.getDataAtRowProp(r, 'categorie');&ndash;%&gt;
&lt;%&ndash;                        if (cat) { category = cat; break; }&ndash;%&gt;
&lt;%&ndash;                    }&ndash;%&gt;
&lt;%&ndash;                }&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;
&lt;%&ndash;            // Si pas de catégorie trouvée, prendre la première du tableau ou laisser vide&ndash;%&gt;
&lt;%&ndash;            if (!category && allData.length > 0) {&ndash;%&gt;
&lt;%&ndash;                category = allData[0][0]; // première catégorie&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;

&lt;%&ndash;            // Insérer la ligne à l'index calculé&ndash;%&gt;
&lt;%&ndash;            hot.alter('insert_row', insertIndex, 1);&ndash;%&gt;
&lt;%&ndash;            const newRowIndex = insertIndex;&ndash;%&gt;

&lt;%&ndash;            // Créer la nouvelle ligne avec les valeurs par défaut&ndash;%&gt;
&lt;%&ndash;            const newRow = { ...defaultRow, categorie: category, menaces: menace };&ndash;%&gt;
&lt;%&ndash;            for (let prop in newRow) {&ndash;%&gt;
&lt;%&ndash;                hot.setDataAtRowProp(newRowIndex, prop, newRow[prop], 'auto');&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;

&lt;%&ndash;            // Sélectionner la nouvelle ligne&ndash;%&gt;
&lt;%&ndash;            hot.selectCell(newRowIndex, 1);&ndash;%&gt;
&lt;%&ndash;            showToast('Menace ajoutée avec succès.');&ndash;%&gt;
&lt;%&ndash;        } catch (e) {&ndash;%&gt;
&lt;%&ndash;            console.error(e);&ndash;%&gt;
&lt;%&ndash;            showToast('Erreur : ' + e.message, 'error');&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    // Raccourci pour le bouton&ndash;%&gt;
&lt;%&ndash;    window.openThreatModal = openThreatModal;&ndash;%&gt;

&lt;%&ndash;    // --- Toast personnalisé ---&ndash;%&gt;
&lt;%&ndash;    function showToast(message, type = 'success') {&ndash;%&gt;
&lt;%&ndash;        const toast = document.getElementById('toast');&ndash;%&gt;
&lt;%&ndash;        toast.style.display = 'block';&ndash;%&gt;
&lt;%&ndash;        toast.style.backgroundColor = type === 'success' ? '#28a745' : (type === 'error' ? '#dc3545' : '#ffc107');&ndash;%&gt;
&lt;%&ndash;        toast.style.color = 'white';&ndash;%&gt;
&lt;%&ndash;        toast.style.padding = '10px 20px';&ndash;%&gt;
&lt;%&ndash;        toast.style.borderRadius = '5px';&ndash;%&gt;
&lt;%&ndash;        toast.style.boxShadow = '0 2px 10px rgba(0,0,0,0.2)';&ndash;%&gt;
&lt;%&ndash;        toast.textContent = message;&ndash;%&gt;
&lt;%&ndash;        setTimeout(() => { toast.style.display = 'none'; }, 3000);&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    window.insertRowAbove = insertRowAbove;&ndash;%&gt;
&lt;%&ndash;    window.insertRowBelow = insertRowBelow;&ndash;%&gt;

&lt;%&ndash;    // --- Chargement des données depuis le serveur ---&ndash;%&gt;
&lt;%&ndash;    fetch('/rssi/risk-editor/data-json')&ndash;%&gt;
&lt;%&ndash;        .then(res => res.json())&ndash;%&gt;
&lt;%&ndash;        .then(data => {&ndash;%&gt;
&lt;%&ndash;            originalData = data;&ndash;%&gt;
&lt;%&ndash;            initHandsontable(data);&ndash;%&gt;
&lt;%&ndash;            populateCategoryFilter(data);&ndash;%&gt;
&lt;%&ndash;        })&ndash;%&gt;
&lt;%&ndash;        .catch(err => {&ndash;%&gt;
&lt;%&ndash;            console.error('Erreur chargement données :', err);&ndash;%&gt;
&lt;%&ndash;            showToast('Erreur de chargement des données', 'error');&ndash;%&gt;
&lt;%&ndash;        });&ndash;%&gt;

&lt;%&ndash;    // --- Initialisation de Handsontable ---&ndash;%&gt;
&lt;%&ndash;    function initHandsontable(data) {&ndash;%&gt;
&lt;%&ndash;        const container = document.getElementById('hot-container');&ndash;%&gt;

&lt;%&ndash;        hot = new Handsontable(container, {&ndash;%&gt;
&lt;%&ndash;            data: data,&ndash;%&gt;
&lt;%&ndash;            nestedHeaders: nestedHeaders,&ndash;%&gt;
&lt;%&ndash;            licenseKey: 'non-commercial-and-evaluation',&ndash;%&gt;
&lt;%&ndash;            rowHeaders: true,&ndash;%&gt;
&lt;%&ndash;            colHeaders: true,&ndash;%&gt;
&lt;%&ndash;            manualColumnResize: true,&ndash;%&gt;
&lt;%&ndash;            stretchH: 'all',&ndash;%&gt;
&lt;%&ndash;            columns: columns,&ndash;%&gt;
&lt;%&ndash;            mergeCells: calculateRiskMerges(data),&ndash;%&gt;
&lt;%&ndash;            cells: function(row, col) {&ndash;%&gt;
&lt;%&ndash;                return { renderer: riskRenderer };&ndash;%&gt;
&lt;%&ndash;            },&ndash;%&gt;
&lt;%&ndash;            filters: true,&ndash;%&gt;
&lt;%&ndash;            columnSorting: true,&ndash;%&gt;
&lt;%&ndash;            undo: true,&ndash;%&gt;
&lt;%&ndash;            manualRowMove: true, // Permet de déplacer les lignes par glisser-déposer&ndash;%&gt;
&lt;%&ndash;            allowInsertRow: false,&ndash;%&gt;
&lt;%&ndash;            allowRemoveRow: true,&ndash;%&gt;
&lt;%&ndash;            contextMenu: {&ndash;%&gt;
&lt;%&ndash;                items: {&ndash;%&gt;
&lt;%&ndash;                    'cut': { name: 'Couper' },&ndash;%&gt;
&lt;%&ndash;                    'copy': { name: 'Copier' },&ndash;%&gt;
&lt;%&ndash;                    'copy_with_column_headers': { name: 'Copier avec en-têtes' },&ndash;%&gt;
&lt;%&ndash;                    'paste': { name: 'Coller' },&ndash;%&gt;
&lt;%&ndash;                    'separator1': '---------',&ndash;%&gt;
&lt;%&ndash;                    'add_threat': {&ndash;%&gt;
&lt;%&ndash;                        name: 'Ajouter une menace (choisir)',&ndash;%&gt;
&lt;%&ndash;                        callback: function() {&ndash;%&gt;
&lt;%&ndash;                            const cell = this.getSelectedLast();&ndash;%&gt;
&lt;%&ndash;                            if (cell) {&ndash;%&gt;
&lt;%&ndash;                                openThreatModal(cell[0], cell[1]);&ndash;%&gt;
&lt;%&ndash;                            } else if (lastSelectedCell) {&ndash;%&gt;
&lt;%&ndash;                                openThreatModal(lastSelectedCell.row, lastSelectedCell.col);&ndash;%&gt;
&lt;%&ndash;                            } else {&ndash;%&gt;
&lt;%&ndash;                                openThreatModal();&ndash;%&gt;
&lt;%&ndash;                            }&ndash;%&gt;
&lt;%&ndash;                        }&ndash;%&gt;
&lt;%&ndash;                    },&ndash;%&gt;
&lt;%&ndash;                    'separator2': '---------',&ndash;%&gt;
&lt;%&ndash;                    'row_above_custom': {&ndash;%&gt;
&lt;%&ndash;                        name: 'Insérer une ligne au-dessus (même catégorie)',&ndash;%&gt;
&lt;%&ndash;                        callback: insertRowAbove&ndash;%&gt;
&lt;%&ndash;                    },&ndash;%&gt;
&lt;%&ndash;                    'row_below_custom': {&ndash;%&gt;
&lt;%&ndash;                        name: 'Insérer une ligne en dessous (même catégorie)',&ndash;%&gt;
&lt;%&ndash;                        callback: insertRowBelow&ndash;%&gt;
&lt;%&ndash;                    },&ndash;%&gt;
&lt;%&ndash;                    'remove_row': {&ndash;%&gt;
&lt;%&ndash;                        name: 'Supprimer la ligne',&ndash;%&gt;
&lt;%&ndash;                        callback: function() {&ndash;%&gt;
&lt;%&ndash;                            const selected = this.getSelected();&ndash;%&gt;
&lt;%&ndash;                            if (selected) {&ndash;%&gt;
&lt;%&ndash;                                const rows = selected.map(r => r[0]).sort((a,b) => b-a);&ndash;%&gt;
&lt;%&ndash;                                rows.forEach(row => this.alter('remove_row', row, 1));&ndash;%&gt;
&lt;%&ndash;                                showToast('Ligne(s) supprimée(s)');&ndash;%&gt;
&lt;%&ndash;                            }&ndash;%&gt;
&lt;%&ndash;                        }&ndash;%&gt;
&lt;%&ndash;                    },&ndash;%&gt;
&lt;%&ndash;                    'separator3': '---------',&ndash;%&gt;
&lt;%&ndash;                    'merge_categories': {&ndash;%&gt;
&lt;%&ndash;                        name: 'Fusionner les catégories identiques',&ndash;%&gt;
&lt;%&ndash;                        callback: function() {&ndash;%&gt;
&lt;%&ndash;                            const currentData = this.getData();&ndash;%&gt;
&lt;%&ndash;                            this.updateSettings({ mergeCells: calculateRiskMerges(currentData) });&ndash;%&gt;
&lt;%&ndash;                            showToast('Fusions recalculées');&ndash;%&gt;
&lt;%&ndash;                        }&ndash;%&gt;
&lt;%&ndash;                    },&ndash;%&gt;
&lt;%&ndash;                    'separator4': '---------',&ndash;%&gt;
&lt;%&ndash;                    'alignment': {&ndash;%&gt;
&lt;%&ndash;                        name: 'Alignement',&ndash;%&gt;
&lt;%&ndash;                        submenu: {&ndash;%&gt;
&lt;%&ndash;                            items: [&ndash;%&gt;
&lt;%&ndash;                                {&ndash;%&gt;
&lt;%&ndash;                                    key: 'alignment:left',&ndash;%&gt;
&lt;%&ndash;                                    name: 'Gauche',&ndash;%&gt;
&lt;%&ndash;                                    callback: function() {&ndash;%&gt;
&lt;%&ndash;                                        applyAlignment('htLeft');&ndash;%&gt;
&lt;%&ndash;                                    }&ndash;%&gt;
&lt;%&ndash;                                },&ndash;%&gt;
&lt;%&ndash;                                {&ndash;%&gt;
&lt;%&ndash;                                    key: 'alignment:center',&ndash;%&gt;
&lt;%&ndash;                                    name: 'Centre',&ndash;%&gt;
&lt;%&ndash;                                    callback: function() {&ndash;%&gt;
&lt;%&ndash;                                        applyAlignment('htCenter');&ndash;%&gt;
&lt;%&ndash;                                    }&ndash;%&gt;
&lt;%&ndash;                                },&ndash;%&gt;
&lt;%&ndash;                                {&ndash;%&gt;
&lt;%&ndash;                                    key: 'alignment:right',&ndash;%&gt;
&lt;%&ndash;                                    name: 'Droite',&ndash;%&gt;
&lt;%&ndash;                                    callback: function() {&ndash;%&gt;
&lt;%&ndash;                                        applyAlignment('htRight');&ndash;%&gt;
&lt;%&ndash;                                    }&ndash;%&gt;
&lt;%&ndash;                                },&ndash;%&gt;
&lt;%&ndash;                                {&ndash;%&gt;
&lt;%&ndash;                                    key: 'alignment:justify',&ndash;%&gt;
&lt;%&ndash;                                    name: 'Justifier',&ndash;%&gt;
&lt;%&ndash;                                    callback: function() {&ndash;%&gt;
&lt;%&ndash;                                        applyAlignment('htJustify');&ndash;%&gt;
&lt;%&ndash;                                    }&ndash;%&gt;
&lt;%&ndash;                                }&ndash;%&gt;
&lt;%&ndash;                            ]&ndash;%&gt;
&lt;%&ndash;                        }&ndash;%&gt;
&lt;%&ndash;                    },&ndash;%&gt;
&lt;%&ndash;                    'separator5': '---------',&ndash;%&gt;
&lt;%&ndash;                    'undo': { name: 'Annuler (Ctrl+Z)' },&ndash;%&gt;
&lt;%&ndash;                    'redo': { name: 'Rétablir (Ctrl+Y)' },&ndash;%&gt;
&lt;%&ndash;                    'separator6': '---------',&ndash;%&gt;
&lt;%&ndash;                    'filter_by_value': { name: 'Filtrer par valeur' },&ndash;%&gt;
&lt;%&ndash;                    'filter_clear': { name: 'Effacer les filtres' }&ndash;%&gt;
&lt;%&ndash;                }&ndash;%&gt;
&lt;%&ndash;            },&ndash;%&gt;
&lt;%&ndash;            currentRowClassName: 'currentRow',&ndash;%&gt;
&lt;%&ndash;            currentColClassName: 'currentCol'&ndash;%&gt;
&lt;%&ndash;        });&ndash;%&gt;

&lt;%&ndash;        // Mémoriser la dernière cellule cliquée&ndash;%&gt;
&lt;%&ndash;        hot.addHook('afterOnCellMouseDown', function(event, coords) {&ndash;%&gt;
&lt;%&ndash;            if (coords.row >= 0 && coords.col >= 0) {&ndash;%&gt;
&lt;%&ndash;                lastSelectedCell = coords;&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;
&lt;%&ndash;        });&ndash;%&gt;

&lt;%&ndash;        // Hook afterChange avec protection&ndash;%&gt;
&lt;%&ndash;        hot.addHook('afterChange', function(changes, source) {&ndash;%&gt;
&lt;%&ndash;            if (source === 'auto' || !changes) return;&ndash;%&gt;
&lt;%&ndash;            changes.forEach(([row, prop, oldVal, newVal]) => {&ndash;%&gt;
&lt;%&ndash;                try {&ndash;%&gt;
&lt;%&ndash;                    const rd = this.getSourceDataAtRow(row);&ndash;%&gt;
&lt;%&ndash;                    if (!rd) return;&ndash;%&gt;
&lt;%&ndash;                    if (['d', 'i', 'c', 'proba', 'grav'].includes(prop)) {&ndash;%&gt;
&lt;%&ndash;                        const d = parseInt(rd.d) || 1;&ndash;%&gt;
&lt;%&ndash;                        const i = parseInt(rd.i) || 1;&ndash;%&gt;
&lt;%&ndash;                        const c = parseInt(rd.c) || 1;&ndash;%&gt;
&lt;%&ndash;                        const p = parseInt(rd.proba) || 1;&ndash;%&gt;
&lt;%&ndash;                        const g = parseInt(rd.grav) || 1;&ndash;%&gt;
&lt;%&ndash;                        const res = Math.max(d, i, c) * p * g;&ndash;%&gt;
&lt;%&ndash;                        this.setDataAtRowProp(row, 'scoreRes', res, 'auto');&ndash;%&gt;
&lt;%&ndash;                    }&ndash;%&gt;
&lt;%&ndash;                    if (['besoinC', 'probC', 'gravC'].includes(prop)) {&ndash;%&gt;
&lt;%&ndash;                        const b = parseInt(rd.besoinC) || 1;&ndash;%&gt;
&lt;%&ndash;                        const pc = parseInt(rd.probC) || 1;&ndash;%&gt;
&lt;%&ndash;                        const gc = parseInt(rd.gravC) || 1;&ndash;%&gt;
&lt;%&ndash;                        const scoreC = b * pc * gc;&ndash;%&gt;
&lt;%&ndash;                        this.setDataAtRowProp(row, 'scoreCible', scoreC, 'auto');&ndash;%&gt;
&lt;%&ndash;                        this.setDataAtRowProp(row, 'optionApres', scoreC <= 12 ? 'Accepter' : 'Réduire', 'auto');&ndash;%&gt;
&lt;%&ndash;                    }&ndash;%&gt;
&lt;%&ndash;                } catch (e) {&ndash;%&gt;
&lt;%&ndash;                    console.error('Erreur dans afterChange :', e, { row, prop });&ndash;%&gt;
&lt;%&ndash;                }&ndash;%&gt;
&lt;%&ndash;            });&ndash;%&gt;
&lt;%&ndash;        });&ndash;%&gt;

&lt;%&ndash;        // Recalculer les fusions après modification de la catégorie&ndash;%&gt;
&lt;%&ndash;        hot.addHook('afterSetDataAtCell', function(changes) {&ndash;%&gt;
&lt;%&ndash;            if (!changes) return;&ndash;%&gt;
&lt;%&ndash;            if (changes.some(c => c[1] === 'categorie')) {&ndash;%&gt;
&lt;%&ndash;                const currentData = this.getData();&ndash;%&gt;
&lt;%&ndash;                this.updateSettings({ mergeCells: calculateRiskMerges(currentData) });&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;
&lt;%&ndash;        });&ndash;%&gt;

&lt;%&ndash;        // Fonction d'alignement&ndash;%&gt;
&lt;%&ndash;        function applyAlignment(className) {&ndash;%&gt;
&lt;%&ndash;            const selected = hot.getSelected();&ndash;%&gt;
&lt;%&ndash;            if (!selected) return;&ndash;%&gt;
&lt;%&ndash;            const [startRow, startCol, endRow, endCol] = selected[0];&ndash;%&gt;
&lt;%&ndash;            for (let r = startRow; r <= endRow; r++) {&ndash;%&gt;
&lt;%&ndash;                for (let c = startCol; c <= endCol; c++) {&ndash;%&gt;
&lt;%&ndash;                    let cellMeta = hot.getCellMeta(r, c);&ndash;%&gt;
&lt;%&ndash;                    let classes = cellMeta.className ? cellMeta.className.split(' ') : [];&ndash;%&gt;
&lt;%&ndash;                    classes = classes.filter(cls => !cls.startsWith('htLeft') && !cls.startsWith('htCenter') && !cls.startsWith('htRight') && !cls.startsWith('htJustify'));&ndash;%&gt;
&lt;%&ndash;                    classes.push(className);&ndash;%&gt;
&lt;%&ndash;                    hot.setCellMeta(r, c, 'className', classes.join(' '));&ndash;%&gt;
&lt;%&ndash;                }&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;
&lt;%&ndash;            hot.render();&ndash;%&gt;
&lt;%&ndash;            showToast('Alignement appliqué');&ndash;%&gt;
&lt;%&ndash;        }&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    // --- Peupler le filtre par catégorie ---&ndash;%&gt;
&lt;%&ndash;    function populateCategoryFilter(data) {&ndash;%&gt;
&lt;%&ndash;        const categories = [...new Set(data.map(item => item.categorie))];&ndash;%&gt;
&lt;%&ndash;        const select = document.getElementById('filterCategory');&ndash;%&gt;
&lt;%&ndash;        categories.forEach(cat => {&ndash;%&gt;
&lt;%&ndash;            const option = document.createElement('option');&ndash;%&gt;
&lt;%&ndash;            option.value = cat;&ndash;%&gt;
&lt;%&ndash;            option.textContent = cat;&ndash;%&gt;
&lt;%&ndash;            select.appendChild(option);&ndash;%&gt;
&lt;%&ndash;        });&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    // --- Gestion des filtres ---&ndash;%&gt;
&lt;%&ndash;    document.getElementById('filterCategory').addEventListener('change', applyFilters);&ndash;%&gt;
&lt;%&ndash;    document.getElementById('filterRisk').addEventListener('change', applyFilters);&ndash;%&gt;
&lt;%&ndash;    document.getElementById('clearFilters').addEventListener('click', function() {&ndash;%&gt;
&lt;%&ndash;        document.getElementById('filterCategory').value = '';&ndash;%&gt;
&lt;%&ndash;        document.getElementById('filterRisk').value = '';&ndash;%&gt;
&lt;%&ndash;        hot.loadData(originalData);&ndash;%&gt;
&lt;%&ndash;        hot.updateSettings({ mergeCells: calculateRiskMerges(originalData) });&ndash;%&gt;
&lt;%&ndash;        showToast('Filtres effacés');&ndash;%&gt;
&lt;%&ndash;    });&ndash;%&gt;

&lt;%&ndash;    function applyFilters() {&ndash;%&gt;
&lt;%&ndash;        const category = document.getElementById('filterCategory').value;&ndash;%&gt;
&lt;%&ndash;        const riskLevel = document.getElementById('filterRisk').value;&ndash;%&gt;
&lt;%&ndash;        let filtered = originalData.filter(item => {&ndash;%&gt;
&lt;%&ndash;            if (category && item.categorie !== category) return false;&ndash;%&gt;
&lt;%&ndash;            if (riskLevel) {&ndash;%&gt;
&lt;%&ndash;                const score = parseInt(item.scoreRes) || 0;&ndash;%&gt;
&lt;%&ndash;                if (riskLevel === 'faible' && score > 12) return false;&ndash;%&gt;
&lt;%&ndash;                if (riskLevel === 'modere' && (score <= 12 || score > 23)) return false;&ndash;%&gt;
&lt;%&ndash;                if (riskLevel === 'significatif' && (score <= 23 || score > 35)) return false;&ndash;%&gt;
&lt;%&ndash;                if (riskLevel === 'critique' && score <= 35) return false;&ndash;%&gt;
&lt;%&ndash;            }&ndash;%&gt;
&lt;%&ndash;            return true;&ndash;%&gt;
&lt;%&ndash;        });&ndash;%&gt;
&lt;%&ndash;        hot.loadData(filtered);&ndash;%&gt;
&lt;%&ndash;        hot.updateSettings({ mergeCells: calculateRiskMerges(filtered) });&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;

&lt;%&ndash;    // --- Sauvegarde des données ---&ndash;%&gt;
&lt;%&ndash;    function saveRiskData() {&ndash;%&gt;
&lt;%&ndash;        const fullData = hot.getData();&ndash;%&gt;
&lt;%&ndash;        fetch('/rssi/risk-editor/save', {&ndash;%&gt;
&lt;%&ndash;            method: 'POST',&ndash;%&gt;
&lt;%&ndash;            headers: {'Content-Type': 'application/json'},&ndash;%&gt;
&lt;%&ndash;            body: JSON.stringify(fullData)&ndash;%&gt;
&lt;%&ndash;        })&ndash;%&gt;
&lt;%&ndash;            .then(res => res.text())&ndash;%&gt;
&lt;%&ndash;            .then(msg => {&ndash;%&gt;
&lt;%&ndash;                if(msg.includes("SUCCESS")) showToast('Sauvegardé avec succès');&ndash;%&gt;
&lt;%&ndash;                else showToast('Erreur lors de la sauvegarde', 'error');&ndash;%&gt;
&lt;%&ndash;            })&ndash;%&gt;
&lt;%&ndash;            .catch(err => showToast('Erreur réseau', 'error'));&ndash;%&gt;
&lt;%&ndash;    }&ndash;%&gt;
&lt;%&ndash;</script>&ndash;%&gt;
&lt;%&ndash;</body>&ndash;%&gt;
&lt;%&ndash;</html>:&ndash;%&gt;--%>
