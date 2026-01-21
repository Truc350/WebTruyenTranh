<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

    <header class="admin-header">
        <div class="header-right">
            <a href="${pageContext.request.contextPath}/fontend/admin/chatWithCus.jsp">
                <i class="fa-solid fa-comment"></i>
            </a>

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



