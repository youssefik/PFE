<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - SMSI ISO 27001</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            height: 100 vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            width: 100%;
            max-width: 400px;
            padding: 2rem;
            border-radius: 1rem;
            border: none;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .login-icon {
            font-size: 3rem;
            color: #0d6efd;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

<div class="card login-card text-center">
    <div class="card-body">
        <!-- Icône et Titre -->
        <div class="login-icon">
            <i class="bi bi-shield-lock-fill"></i>
        </div>
        <h3 class="card-title mb-1">SMSI ISO 27001</h3>
        <p class="text-muted mb-4">Système de suivi de conformité</p>

        <!-- Messages d'erreur ou de déconnexion -->
        <c:if test="${param.error != null}">
            <div class="alert alert-danger d-flex align-items-center py-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <small>Identifiants AD incorrects.</small>
            </div>
        </c:if>

        <c:if test="${param.logout != null}">
            <div class="alert alert-success d-flex align-items-center py-2" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <small>Vous avez été déconnecté.</small>
            </div>
        </c:if>

        <!-- Formulaire de connexion -->
        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-floating mb-3 text-start">
                <input type="text" name="username" class="form-control" id="userInput" placeholder="Utilisateur AD" required>
                <label for="userInput"><i class="bi bi-person"></i> Utilisateur AD</label>
            </div>

            <div class="form-floating mb-4 text-start">
                <input type="password" name="password" class="form-control" id="passInput" placeholder="Mot de passe" required>
                <label for="passInput"><i class="bi bi-key"></i> Mot de passe</label>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 mb-3 shadow-sm">
                <i class="bi bi-box-arrow-in-right"></i> Se connecter
            </button>

            <p class="text-muted small">
                Authentification via Active Directory<br>
                <span class="badge bg-light text-dark border">test.local</span>
            </p>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>