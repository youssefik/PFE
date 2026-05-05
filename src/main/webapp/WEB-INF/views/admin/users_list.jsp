<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout pageTitle="Gestion des utilisateurs">

    <div class="card card-outline card-danger shadow-sm">
        <div class="card-header">
            <h3 class="card-title font-weight-bold">Gestion des Accès SMSI</h3>
        </div>

        <div class="card-body p-0">
            <c:if test="${not empty users}">
                <table class="table table-striped table-valign-middle mb-0">
                    <thead class="thead-light">
                    <tr>
                        <th>Collaborateur</th>
                        <th>Email / Service</th>
                        <th>Dernière connexion</th>
                        <th>Rôle actuel</th>
                        <th>Changer le rôle</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>
                                <div class="font-weight-bold text-dark">${user.username}</div>
                                <small class="text-muted">${user.nomComplet}</small>
                            </td>
                            <td>
                                <div>${user.email}</div>
                                <small class="badge badge-light">${user.service} - ${user.fonction}</small>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty user.derniereConnexion}">
                                        <%-- Correction : On n'utilise plus fmt:formatDate car LocalDateTime n'est pas supporté --%>
                                        <span class="small">
                                            <i class="far fa-clock mr-1"></i>
                                            ${user.derniereConnexion.toString().replace('T', ' ').substring(0, 16)}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">Jamais connecté</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="badge badge-danger text-uppercase">
                                        ${user.role}
                                </span>
                            </td>
                            <td>
                                    <%-- Formulaire vers votre @PostMapping("/admin/users/update-role") --%>
                                <form action="/admin/users/update-role" method="post" class="form-inline">
                                        <%-- L'ID est un UUID, JSP va le transformer en String automatiquement ici --%>
                                    <input type="hidden" name="userId" value="${user.id}">

                                    <select name="newRole" class="form-control form-control-sm mr-2" style="width: 150px;">
                                        <c:forEach var="role" items="${allRoles}">
                                            <%-- Comparaison entre Enum et Enum --%>
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

            <c:if test="${empty users}">
                <div class="p-5 text-center text-muted">
                    <i class="fas fa-users-slash fa-3x mb-3"></i>
                    <p>Aucun utilisateur trouvé dans la base.</p>
                </div>
            </c:if>
        </div>
    </div>

</t:layout>