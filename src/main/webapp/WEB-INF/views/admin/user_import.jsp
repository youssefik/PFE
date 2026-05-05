<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %> <%-- CETTE LIGNE EST CRUCIALE --%>


<t:layout pageTitle="Gestion des utilisateurs">

    <div class="container mt-4">
        <h2 class="section-title">Gestion des Accès SMSI</h2>

        <div class="card shadow-sm border-0">
            <div class="card-body">
                    <%-- Protection : On vérifie si la liste users n'est pas nulle avant de boucler --%>
                <c:if test="${not empty users}">
                    <table class="table align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>Collaborateur (AD)</th>
                            <th>Email</th>
                            <th>Dernière connexion</th>
                            <th>Rôle actuel</th>
                            <th>Changer le rôle</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>
                                    <div class="fw-bold">${user.username}</div>
                                    <small class="text-muted">${user.nomComplet}</small>
                                </td>
                                <td>${user.email}</td>
                                <td>
                                        <%-- SÉCURITÉ : On ne formate la date QUE si elle n'est pas nulle --%>
                                    <c:choose>
                                        <c:when test="${not empty user.derniereConnexion}">
                                            <fmt:formatDate value="${user.derniereConnexion}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">Jamais connecté</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge bg-danger text-uppercase">${user.role}</span>
                                </td>
                                <td>
                                    <form action="/admin/users/update-role" method="post" class="d-flex gap-2">
                                        <input type="hidden" name="userId" value="${user.id}">

                                        <select name="newRole" class="form-select form-select-sm" style="width: 150px;">
                                                <%-- Protection : Vérification de la liste des rôles --%>
                                            <c:forEach var="role" items="${allRoles}">
                                                <%-- Comparaison EL sécurisée --%>
                                                <option value="${role}" ${user.role eq role ? 'selected' : ''}>
                                                        ${role}
                                                </option>
                                            </c:forEach>
                                        </select>

                                        <button type="submit" class="btn btn-sm btn-dark">Valider</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                    <%-- Message si aucune donnée n'arrive du controller --%>
                <c:if test="${empty users}">
                    <div class="alert alert-info border-0 shadow-sm text-center">
                        <i class="bi bi-info-circle me-2"></i> Aucun collaborateur trouvé ou erreur de chargement des données.
                    </div>
                </c:if>
            </div>
        </div>
    </div>

</t:layout>