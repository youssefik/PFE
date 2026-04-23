<%--
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
</html>--%>



<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Authentification | SMSI ISO 27001</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --iso-red: #D2010D;
            --iso-dark: #212121;
            --iso-gray-bg: #F4F4F4;
        }

        body {
            background-color: var(--iso-gray-bg);
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        .login-container {
            width: 100%;
            max-width: 450px;
            padding: 15px;
        }

        .login-card {
            background: white;
            border: none;
            border-top: 6px solid var(--iso-red); /* Barre rouge ISO en haut */
            border-radius: 4px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .login-header {
            padding: 40px 40px 20px 40px;
            text-align: center;
        }

        .logo-box {
            background-color: var(--iso-red);
            color: white;
            padding: 10px 20px;
            font-weight: 800;
            font-size: 1.5rem;
            display: inline-block;
            margin-bottom: 20px;
            letter-spacing: 2px;
        }

        .login-title {
            font-weight: 700;
            color: var(--iso-dark);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 1.2rem;
            margin-bottom: 5px;
        }

        .login-body {
            padding: 20px 40px 40px 40px;
        }

        /* Formulaire style ISO */
        .form-control {
            border-radius: 2px;
            border: 1px solid #ddd;
            padding: 12px 15px;
            font-size: 0.95rem;
        }

        .form-control:focus {
            border-color: var(--iso-red);
            box-shadow: none;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            color: #666;
            margin-bottom: 8px;
        }

        .btn-iso-login {
            background-color: var(--iso-red);
            color: white;
            border: none;
            border-radius: 2px;
            padding: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 10px;
        }

        .btn-iso-login:hover {
            background-color: var(--iso-dark);
            color: white;
            transform: translateY(-2px);
        }

        .ad-info {
            background-color: #f8f9fa;
            border: 1px solid #eee;
            padding: 15px;
            border-radius: 4px;
            margin-top: 25px;
            text-align: center;
        }

        .alert {
            border-radius: 2px;
            font-size: 0.85rem;
            font-weight: 500;
            border: none;
        }

        .alert-danger { background-color: #ffebee; color: #c62828; }
        .alert-success { background-color: #e8f5e9; color: #2e7d32; }

    </style>
</head>
<body>

<div class="login-container">
    <div class="card login-card">
        <div class="login-header">
            <!-- Carré Rouge Logo ISO -->
            <div class="logo-box">ISO</div>
            <h1 class="login-title">SMSI 27001</h1>
            <p class="text-muted small">Information Security Management System</p>
        </div>

        <div class="login-body">
            <!-- Messages de notification -->
            <c:if test="${param.error != null}">
                <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-exclamation-octagon-fill me-2"></i>
                    <div>Échec d'authentification AD : Identifiants invalides.</div>
                </div>
            </c:if>

            <c:if test="${param.logout != null}">
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-shield-check me-2"></i>
                    <div>Session fermée avec succès.</div>
                </div>
            </c:if>

            <!-- Formulaire -->
            <form method="post" action="${pageContext.request.contextPath}/login">
                <div class="mb-3">
                    <label class="form-label">Utilisateur Active Directory</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-person text-muted"></i></span>
                        <input type="text" name="username" class="form-control border-start-0" placeholder="ex: j.doe" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Mot de passe</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-key text-muted"></i></span>
                        <input type="password" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-iso-login shadow">
                    Se connecter au système <i class="bi bi-arrow-right ms-2"></i>
                </button>
            </form>

            <!-- Informations AD -->
            <div class="ad-info">
                <div class="text-muted small mb-1">Domaine d'authentification</div>
                <span class="badge bg-white text-dark border fw-bold">TEST.LOCAL</span>
                <div class="mt-2 small text-muted">
                    <i class="bi bi-info-circle me-1"></i> Accès réservé au personnel autorisé.
                </div>
            </div>
        </div>
    </div>

    <div class="text-center mt-4">
        <small class="text-muted">© 2026 Corporate SMSI Tool | Compliance Standard v3.0</small>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>