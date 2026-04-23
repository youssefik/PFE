<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SoA - Déclaration d'Applicabilité</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-primary mb-4 shadow-sm">
    <div class="container">
        <span class="navbar-brand"><i class="bi bi-list-check"></i> Déclaration d'Applicabilité (SoA)</span>
        <a href="/dashboard" class="btn btn-light btn-sm">Retour</a>
    </div>
</nav>

<!-- Ajoutez ceci juste avant le tableau dans soa.jsp -->
<div class="row mb-4">
    <!-- Stat : Taux d'applicabilité -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm bg-primary text-white text-center p-3">
            <h2 class="fw-bold mb-0">${stats.percentApplicable}%</h2>
            <small class="text-uppercase opacity-75">Contrôles Applicables</small>
        </div>
    </div>
    <!-- Stat : État d'avancement -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm bg-success text-white text-center p-3">
            <h2 class="fw-bold mb-0">${stats.percentConforme}%</h2>
            <small class="text-uppercase opacity-75">Conformité Globale</small>
        </div>
    </div>
    <!-- Stat : Risques Liés -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm bg-warning text-dark text-center p-3">
            <h2 class="fw-bold mb-0">${stats.countPreuves}</h2>
            <small class="text-uppercase opacity-75">Preuves Collectées</small>
        </div>
    </div>
    <!-- Stat : Signatures -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm bg-dark text-white text-center p-3">
            <h2 class="fw-bold mb-0">${signatures.size()}</h2>
            <small class="text-uppercase opacity-75">Validations Direction</small>
        </div>
    </div>
</div>
<div class="container-fluid px-4">
    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th>Code</th>
                    <th>Contrôle Annexe A</th>
                    <th>Applicable</th>
                    <th>État Mise en œuvre</th>
                    <th>Justification</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ctrl" items="${controles}">
                    <c:set var="soa" value="${null}" />
                    <%-- On cherche l'élément SoA lié à ce contrôle --%>
                    <c:forEach var="item" items="${soaElements}">
                        <c:if test="${item.controle.id == ctrl.id}">
                            <c:set var="soa" value="${item}" />
                        </c:if>
                    </c:forEach>

                    <tr>
                        <td><strong>${ctrl.code}</strong></td>
                        <td>
                            <div class="fw-bold">${ctrl.titre}</div>
                            <small class="text-muted">${ctrl.domaine}</small>
                        </td>
                        <td>
                                <span class="badge ${soa.applicable ? 'bg-success' : 'bg-secondary'}">
                                        ${soa != null ? (soa.applicable ? 'OUI' : 'NON') : 'A définir'}
                                </span>
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${soa.statutMiseEnOeuvre == 'Oui'}">
                                    <span class="badge bg-success">CONFORME</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">NON CONFORME</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="small">${soa.justification}</td>
                        <td>
                            <!-- Bouton pour ouvrir un modal de mise à jour (Simplifié ici par un lien) -->
                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modal${ctrl.id}">
                                <i class="bi bi-pencil"></i> Éditer
                            </button>

                            <!-- MODAL DE MISE À JOUR -->
                            <div class="modal fade" id="modal${ctrl.id}" tabindex="-1">
                                <div class="modal-dialog">
                                    <form action="/compliance/soa/update" method="post" class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Mise à jour : ${ctrl.code}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="controleId" value="${ctrl.id}">
                                            <div class="mb-3">
                                                <label class="form-label">Applicabilité</label>
                                                <select name="applicable" class="form-select">
                                                    <option value="true" ${soa.applicable ? 'selected' : ''}>Oui (Applicable)</option>
                                                    <option value="false" ${soa != null && !soa.applicable ? 'selected' : ''}>Non (Exclu)</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Statut de mise en œuvre</label>
                                                <select name="statut" class="form-select">
                                                    <option value="NON_DEMARRE">Non démarré</option>
                                                    <option value="EN_COURS">En cours / Partiel</option>
                                                    <option value="CONFORME">Conforme / Appliqué</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Justification</label>
                                                <textarea name="justification" class="form-control" rows="3">${soa.justification}</textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="submit" class="btn btn-primary">Enregistrer</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <c:if test="${soa != null}">
                                <a href="/compliance/preuves/${soa.id}" class="btn btn-sm btn-warning">
                                    <i class="bi bi-folder2-open"></i> Preuves
                                    <span class="badge bg-white text-dark ms-1">${soa.preuves.size()}</span>
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- SECTION APPROBATIONS / SIGNATURES -->
<div class="card mt-5 border-0 shadow-sm rounded-4">
    <div class="card-header bg-dark text-white p-3">
        <h5 class="mb-0"><i class="bi bi-pen-fill me-2"></i>Approbation du Document (Signature Electronique)</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <!-- Liste des signataires actuels -->
            <div class="col-md-7">
                <h6>Historique des signatures :</h6>
                <div class="list-group list-group-flush">

                    <c:forEach var="s" items="${signatures}">
                        <div class="list-group-item">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <i class="bi bi-check-circle-fill text-success"></i> <strong>${s.nomSignataire}</strong>
                                    <div class="text-muted small mt-1">"${s.commentaire}"</div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <img src="${s.imageSignature}" alt="Signature" style="height: 50px; background: white;" class="border p-1">
                                    <div class="extra-small text-muted" style="font-size: 0.7rem;">le ${s.dateSignature}</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty signatures}">
                        <p class="text-muted italic small">Aucune signature pour le moment.</p>
                    </c:if>
                </div>
            </div>

            <!-- Formulaire pour signer -->
            <div class="col-md-5 border-start">
                <h6>Dessinez votre signature :</h6>
                <form action="/signature/sign" method="post" id="signature-form">
                    <input type="hidden" name="type" value="SOA">
                    <input type="hidden" name="imageSignature" id="imageSignatureInput">

                    <div class="mb-2 bg-light border rounded shadow-inner" style="height: 150px; position: relative;">
                        <canvas id="signature-pad" style="width: 100%; height: 100%; cursor: crosshair;"></canvas>
                        <button type="button" class="btn btn-sm btn-link text-danger position-absolute top-0 end-0" onclick="clearSignature()">Effacer</button>
                    </div>

                    <div class="mb-3">
                        <textarea name="commentaire" class="form-control form-control-sm" placeholder="Observations (obligatoire)..." required></textarea>
                    </div>

                    <button type="button" onclick="validateAndSubmit()" class="btn btn-primary w-100 rounded-pill shadow-sm">
                        <i class="bi bi-pencil-square me-1"></i> Signer et Approuver
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let canvas = document.getElementById('signature-pad');
    let signaturePad = new SignaturePad(canvas, {
        backgroundColor: 'rgba(255, 255, 255, 0)' // Fond transparent
    });

    // Ajuster la résolution du canvas
    function resizeCanvas() {
        const ratio =  Math.max(window.devicePixelRatio || 1, 1);
        canvas.width = canvas.offsetWidth * ratio;
        canvas.height = canvas.offsetHeight * ratio;
        canvas.getContext("2d").scale(ratio, ratio);
        signaturePad.clear();
    }
    window.onresize = resizeCanvas;
    resizeCanvas();

    function clearSignature() {
        signaturePad.clear();
    }

    function validateAndSubmit() {
        if (signaturePad.isEmpty()) {
            alert("Veuillez dessiner votre signature avant de valider.");
            return;
        }

        // Convertir le dessin en Base64
        const dataURL = signaturePad.toDataURL();
        document.getElementById('imageSignatureInput').value = dataURL;

        // Soumettre le formulaire
        document.getElementById('signature-form').submit();
    }
</script>
</body>
</html>
