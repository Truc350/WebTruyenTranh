<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- DEBUG MODE: Thêm ?debug=true vào URL để xem thông tin debug -->
<c:if test="${pageContext.request.getParameter('debug') == 'true'}">
    <div style="background: #fff3cd; padding: 15px; margin: 10px; border: 2px solid #ffc107; border-radius: 5px;">
        <strong>🐛 DEBUG INFO:</strong><br>
        Notifications count: ${fn:length(notifications)}<br>
        Unread count: ${unreadNotificationCount}<br>
        Admin session: ${not empty sessionScope.admin ? '✅ YES' : '❌ NO'}<br>
        <c:if test="${not empty notifications}">
            First notification: ${notifications[0].title}<br>
        </c:if>
    </div>
</c:if>

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

            <!-- Notification Dropdown -->
            <div id="notificationDropdown" class="notification-dropdown">
                <!-- Header với nút đánh dấu tất cả đã đọc -->
                <div class="notification-header">
                    <h4>Thông báo (${fn:length(notifications)})</h4>
                    <c:if test="${unreadNotificationCount > 0}">
                        <a href="javascript:void(0)" onclick="markAllAsRead()" title="Đánh dấu tất cả đã đọc">
                            <i class="fa-solid fa-check-double"></i>
                        </a>
                    </c:if>
                </div>

                <!-- Danh sách thông báo -->
                <!-- Danh sách thông báo -->
                <c:forEach var="n" items="${notifications}">
                    <div class="notification-item ${n.isRead ? '' : 'unread'}"
                         onclick="openNotificationDetail(${n.id}, '${fn:escapeXml(n.message)}')">
                        <div class="notification-content">
                            <!-- SỬA: Hiển thị type thay vì title -->
                            <strong>
                                <c:choose>
                                    <c:when test="${n.type == 'USER_VIOLATION'}">⚠️ Vi phạm quy định</c:when>
                                    <c:when test="${n.type == 'ORDER'}">📦 Đơn hàng</c:when>
                                    <c:when test="${n.type == 'SYSTEM'}">ℹ️ Hệ thống</c:when>
                                    <c:otherwise>${n.type}</c:otherwise>
                                </c:choose>
                            </strong>
                            <!-- Hiển thị message (có thể nhiều dòng) -->
                            <p style="white-space: pre-line;">${n.message}</p>
                            <small>
                                <i class="fa-regular fa-clock"></i>
                                    ${n.formattedCreatedAt}
                            </small>
                        </div>
                        <c:if test="${!n.isRead}">
                            <span class="unread-dot"></span>
                        </c:if>
                    </div>
                </c:forEach>

                <c:if test="${empty notifications}">
                    <div class="notification-empty">
                        <i class="fa-regular fa-bell-slash"></i>
                        <p>Không có thông báo</p>
                    </div>
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
        const dropdown = document.getElementById("notificationDropdown");
        dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
    }

    // Đóng dropdown khi click bên ngoài
    window.addEventListener('click', function(e) {
        const dropdown = document.getElementById('notificationDropdown');
        const notificationDiv = document.querySelector('.admin-notification');

        if (!notificationDiv.contains(e.target)) {
            dropdown.style.display = 'none';
        }
    });

    /**
     * ✅ SỬA: Đơn giản hóa vì không có relatedId/relatedType
     */
    function openNotificationDetail(id, message) {
        // Hiển thị thông báo
        alert(message);

        // Đánh dấu đã đọc và reload
        markAsRead(id, function() {
            setTimeout(() => location.reload(), 300);
        });
    }

    /**
     * Đánh dấu 1 thông báo đã đọc
     */
    function markAsRead(notificationId, callback) {
        fetch('${pageContext.request.contextPath}/admin/mark-notification-read?id=' + notificationId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    console.log('✅ Marked notification #' + notificationId + ' as read');
                    if (callback) callback();
                } else {
                    console.error('❌ Failed to mark as read:', data.error);
                }
            })
            .catch(err => {
                console.error('❌ Error marking as read:', err);
            });
    }

    /**
     * Đánh dấu tất cả thông báo đã đọc
     */
    function markAllAsRead() {
        if (confirm('Đánh dấu tất cả thông báo đã đọc?')) {
            fetch('${pageContext.request.contextPath}/admin/mark-all-notifications-read')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        console.log('✅ Marked all notifications as read');
                        location.reload();
                    } else {
                        console.error('❌ Failed to mark all as read:', data.error);
                    }
                })
                .catch(err => {
                    console.error('❌ Error marking all as read:', err);
                });
        }
    }

</script>




