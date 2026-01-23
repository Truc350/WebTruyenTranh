<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
            <li class="active"><a href="${pageContext.request.contextPath}/updateUser">Thông tin tài khoản</a></li>
            <li><a href="${pageContext.request.contextPath}/change-password">Đổi mật khẩu</a></li>
            <li><a href="${pageContext.request.contextPath}/fontend/nguoiB/points.jsp">Ưu đãi C-Point</a></li>
            <li><a href="${pageContext.request.contextPath}/order-history?filter=pending">Đơn hàng của tôi</a></li>
            <li><a href="${pageContext.request.contextPath}/fontend/nguoiB/notifications.jsp">Thông báo</a></li>
            <li><a href="${pageContext.request.contextPath}/wishlist">Sản phẩm yêu thích</a></li>
        </ul>
    </div>
</div>

<script>
    const currentPath = window.location.pathname;
    document.querySelectorAll(".menu ul li a").forEach(link => {
        if (currentPath.includes(link.getAttribute("href"))) {
            link.parentElement.classList.add("active");
        } else {
            link.parentElement.classList.remove("active");
        }
    });
</script>
