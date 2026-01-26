<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="currentURI" value="${pageContext.request.requestURI}" />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="profile-container">
    <div class="profile-header">
        <div class="avatar">
            <img src="https://mayweddingstudio.vn/wp-content/uploads/anh-dai-dien-facebook-nu-9.webp" alt="Avatar">
        </div>
        <div class="user-info">
            <h2>Huỳnh Trúc</h2>
            <p class="membership">Thành viên Bạc</p>
            <p class="C-point">C-Point tích lũy: 0</p>
        </div>
    </div>
    <div class="menu">
        <ul>
            <li class="${fn:contains(currentURI, 'updateUser') ? 'active' : ''}">
                <a href="${contextPath}/updateUser" data-page="updateUser">Thông tin tài khoản</a>
            </li>
            <li class="${fn:contains(currentURI, 'change-password') ? 'active' : ''}">
                <a href="${contextPath}/change-password" data-page="change-password">Đổi mật khẩu</a>
            </li>
            <li class="${fn:contains(currentURI, 'points') ? 'active' : ''}">
                <a href="${contextPath}/fontend/nguoiB/points.jsp" data-page="points">Ưu đãi C-Point</a>
            </li>
            <li class="${fn:contains(currentURI, 'order-history') ? 'active' : ''}">
                <a href="${contextPath}/order-history?filter=pending" data-page="order-history">Đơn hàng của tôi</a>
            </li>
            <li class="${fn:contains(currentURI, 'notifications') ? 'active' : ''}">
                <a href="${contextPath}/fontend/nguoiB/notifications.jsp" data-page="notifications">Thông báo</a>
            </li>
            <li class="${fn:contains(currentURI, 'wishlist') ? 'active' : ''}">
                <a href="${contextPath}/wishlist" data-page="wishlist">Sản phẩm yêu thích</a>
            </li>
        </ul>
    </div>
</div>

<script>
    // Backup: Nếu JSTL không set được, dùng JS
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const menuItems = document.querySelectorAll(".menu ul li");

        // Xóa tất cả active trước
        let hasActive = false;
        menuItems.forEach(li => {
            if (li.classList.contains('active')) {
                hasActive = true;
            }
        });

        // Nếu chưa có active nào (JSTL failed), dùng JS
        if (!hasActive) {
            menuItems.forEach(li => {
                const link = li.querySelector('a');
                const dataPage = link.getAttribute('data-page');

                if (currentPath.includes(dataPage)) {
                    li.classList.add('active');
                }
            });
        }
    });
</script>