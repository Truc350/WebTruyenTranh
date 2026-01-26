<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<header class="admin-header">
    <div class="header-right">
        <a href="${pageContext.request.contextPath}/fontend/admin/chatWithCus.jsp">
            <i class="fa-solid fa-comment"></i>
        </a>

        <!-- Notification -->
        <div class="admin-notification">
            <a href="javascript:void(0)" onclick="toggleNotificationDropdown()">
                <i class="fa-regular fa-bell"></i>
                <c:if test="${unreadNotificationCount > 0}">
            <span class="notification-badge">
                    ${unreadNotificationCount}
            </span>
                </c:if>
            </a>

            <!-- Dropdown -->
            <div id="notificationDropdown" class="notification-dropdown">
                <c:forEach var="n" items="${notifications}">
                    <div class="notification-item"
                         onclick="openNotificationPopup(
                                 '${n.id}',
                                 '${fn:escapeXml(n.message)}'
                                 )">
                        <strong>${n.type}</strong>
                        <p>${n.message}</p>
                        <small>
                            <fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </small>
                    </div>
                </c:forEach>

                <c:if test="${empty notifications}">
                    <div class="notification-empty">Không có thông báo</div>
                </c:if>
            </div>
        </div>


        <div class="admin-profile">
            <a href="${pageContext.request.contextPath}/fontend/admin/profileAdmin.jsp">
                <img src="${pageContext.request.contextPath}/img/admin.png" class="admin-avatar" alt="Admin">
            </a>
            <span class="admin-name">Admin</span>
        </div>

        <!-- Nút đăng xuất -->
        <button class="btn-logout" title="Đăng xuất">
            <a href="${pageContext.request.contextPath}/logout">
                <i class="fa-solid fa-right-from-bracket"></i>
            </a>
        </button>
    </div>
</header>

<script>
    function toggleNotificationDropdown() {
        const drop = document.getElementById("notificationDropdown");
        drop.style.display = drop.style.display === "block" ? "none" : "block";
    }
</script>




