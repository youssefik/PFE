<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accueil</title>
</head>
<body>
<h2>Bienvenue, ${username} !</h2>

<h3>Vos rôles :</h3>
<ul>
    <c:forEach var="role" items="${authorities}">
        <li>${role.authority}</li>
    </c:forEach>
</ul>

<hr>
<h3>Liens de test :</h3>
<ul>
    <li><a href="${pageContext.request.contextPath}/">Accueil</a></li>
    <li><a href="${pageContext.request.contextPath}/user">Zone User</a></li>
    <li><a href="${pageContext.request.contextPath}/admin">Zone Admin</a></li>
    <li><a href="${pageContext.request.contextPath}/public/info">Info publique</a></li>
    <li><a href="${pageContext.request.contextPath}/debug">Debug</a></li>
    <li><a href="${pageContext.request.contextPath}/logout">Déconnexion</a></li>
</ul>
</body>
</html>