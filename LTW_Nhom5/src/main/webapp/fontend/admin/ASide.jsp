<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


    <aside class="sidebar">
        <div class="sidebar-header">
            <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" class="logo">
            <h2>Comic Store</h2>
        </div>

        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <img src="${pageContext.request.contextPath}/img/home.png" class="icon">
                    <span>Trang chủ</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/fontend/admin/productManagement.jsp">
                    <img src="${pageContext.request.contextPath}/img/series.png" class="icon">
                    <span>Quản lý sản phẩm</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/SeriesManagement?filter=all">
                    <img src="${pageContext.request.contextPath}/img/product.png" class="icon">
                    <span>Quản lý series</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/CategoryManagement">
                    <img src="${pageContext.request.contextPath}/img/category.png" class="icon">
                    <span>Quản lý thể loại</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/orders">
                    <img src="${pageContext.request.contextPath}/img/order.png" class="icon">
                    <span>Quản lý đơn hàng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/user-management">
                    <img src="${pageContext.request.contextPath}/img/user.png" class="icon">
                    <span>Quản lý người dùng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/manage-flashsale">
                    <img src="${pageContext.request.contextPath}/img/flashSale.png" class="icon">
                    <span>Quản lý Flash Sale</span>
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/fontend/admin/report.jsp">
                    <img src="${pageContext.request.contextPath}/img/report.png" class="icon">
                    <span>Thống kê</span>
                </a>
            </li>
        </ul>
    </aside>

