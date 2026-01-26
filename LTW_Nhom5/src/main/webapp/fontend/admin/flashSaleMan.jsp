<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Flash Sale</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleFlashSale.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/adminHeader.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>
    <script src="${pageContext.request.contextPath}/js/flashSaleMan.js"></script>

</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <jsp:include page="/fontend/admin/ASide.jsp"/>
<%--    <aside class="sidebar">--%>
<%--        <div class="sidebar-header">--%>
<%--            <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" class="logo">--%>
<%--            <h2>Comic Store</h2>--%>
<%--        </div>--%>

<%--        <ul>--%>
<%--            <li>--%>
<%--                <a href="dashboard.jsp">--%>
<%--                    <img src="${pageContext.request.contextPath}/img/home.png" class="icon">--%>
<%--                    <span>Trang chủ</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="seriesManagement.jsp">--%>
<%--                    <img src="${pageContext.request.contextPath}/img/series.png" class="icon">--%>
<%--                    <span>Quản lý sản phẩm</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="productManagement.jsp">--%>
<%--                    <img src="${pageContext.request.contextPath}/img/product.png" class="icon">--%>
<%--                    <span>Quản lý series</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="category.jsp">--%>
<%--                    <img src="${pageContext.request.contextPath}/img/category.png" class="icon">--%>
<%--                    <span>Quản lý thể loại</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="order.jsp">--%>
<%--                    <img src="${pageContext.request.contextPath}/img/order.png" class="icon">--%>
<%--                    <span>Quản lý đơn hàng</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="userManagement.jsp">--%>
<%--                    <img src="${pageContext.request.contextPath}/img/user.png" class="icon">--%>
<%--                    <span>Quản lý người dùng</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="flashSaleMan.html">--%>
<%--                    <img src="${pageContext.request.contextPath}/img/flashSale.png" class="icon">--%>
<%--                    <span>Quản lý Flash Sale</span>--%>
<%--                </a>--%>
<%--            </li>--%>

<%--            <li>--%>
<%--                <a href="report.jsp">--%>
<%--                    <img src="${pageContext.request.contextPath}/img/report.png" class="icon">--%>
<%--                    <span>Thống kê</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--        </ul>--%>
<%--    </aside>--%>

    <div class="main-content">
        <%@ include file="HeaderAdmin.jsp" %>
<%--        <header class="admin-header">--%>
<%--            <div class="header-right">--%>
<%--                <a href="chatWithCus.jsp">--%>
<%--                    <i class="fa-solid fa-comment"></i>--%>
<%--                </a>--%>

<%--                <div class="admin-profile">--%>
<%--                    <a href="profileAdmin.jsp">--%>
<%--                        <img src="${pageContext.request.contextPath}/img/admin.png" class="admin-avatar" alt="Admin">--%>
<%--                    </a>--%>
<%--                    <span class="admin-name">Admin</span>--%>
<%--                </div>--%>

<%--                <!-- Nút đăng xuất -->--%>
<%--                <button class="btn-logout" title="Đăng xuất">--%>
<%--                    <a href="../public/login_bo.jsp">--%>
<%--                        <i class="fa-solid fa-right-from-bracket"></i>--%>
<%--                    </a>--%>
<%--                </button>--%>
<%--            </div>--%>
<%--        </header>--%>
        <h2 class="page-title">Quản lý Flash Sale</h2>
        <div class="flashSale-page">

            <div class="flashSale-header">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Tìm kiếm tên Flash Sale">
                    <i class="fas fa-magnifying-glass"></i>
                </div>

                <button class="btn-add" id="openAddPopup">
                    <i class="fas fa-plus"></i> Tạo Flash Sale
                </button>
            </div>


            <div class="flashSale-list">
                <table class="flashSale-table">
                    <thead>
                    <tr>
                        <th>Mã Flash Sale</th>
                        <th>Tên Flash Sale</th>
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>

                    <tbody id="flashSaleTableBody">
                    <c:choose>
                        <c:when test="${empty flashSales}">
                            <tr>
                                <td colspan="5" style="text-align: center; color: #888;">
                                    Chưa có Flash Sale nào được tạo
                                </td>
                            </tr>
                        </c:when>

                        <c:otherwise>

                            <c:forEach var="fs" items="${flashSales}">
                                <tr data-id="${fs.id}">
                                    <td>${fs.id}</td>
                                    <td>${fs.name}</td>
                                    <td>
                                            ${fs.startTimeFormatted} → ${fs.endTimeFormatted}
                                    </td>
                                    <td>
                                <span class="status ${fs.status}">
                                    <c:choose>
                                        <c:when test="${fs.status == 'active'}">Đang diễn ra</c:when>

                                        <c:when test="${fs.status == 'scheduled'}">Sắp diễn ra</c:when>
                                        <c:when test="${fs.status == 'ended'}">Đã diễn ra</c:when>
                                        <c:otherwise>${fs.status}</c:otherwise>
                                    </c:choose>
                                </span>
                                    </td>
                                    <td class="action">
                                        <button class="btn-view" data-id="${fs.id}">
                                            <i class="fa-solid fa-eye"></i>
                                        </button>
                                        <button class="btn-edit openEditFlashSale" data-id="${fs.id}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <button class="btn-delete" data-id="${fs.id}">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<!-- POPUP THÊM FLASH SALE -->
<div class="modal-overlay" id="addFlashSaleModal">
    <div class="modal-flashsale">
        <h3>Tạo Flash Sale</h3>

        <form id="addFlashSaleForm">
            <div class="form-row">
                <div>
                    <label>Tên Flash Sale:</label>
                    <input type="text" name="flashSaleName" placeholder="Nhập tên Flash Sale" required>
                </div>
                <div>
                    <label>Phần trăm giảm:</label>
                    <input class="qty-input" type="number" name="discountPercent" value="30" min="1" max="90" required>
                </div>
            </div>
            <div class="form-row">
                <div>
                    <label>Giờ bắt đầu:</label>
                    <input type="datetime-local" name="startTime" required>
                </div>

                <div>
                    <label>Giờ kết thúc:</label>
                    <input type="datetime-local" name="endTime" required>
                </div>
            </div>

            <h4>Áp dụng cho truyện:</h4>

            <!-- tìm kiếm truyện + hiển thị kết quả ở dưới -->
            <div class="comic-search-container">
                <input type="text" id="comicSearchInput" placeholder="Tìm truyện theo tên truyện muốn Flash Sale"
                       class="search-input" autocomplete="off">

                <div id="searchResults" class="search-results">
                    <!-- result ở đây bằng js -->
                </div>
            </div>

            <!-- Danh sách các truyện hoặc không có flash sale-->
            <div class="selected-comics-list" id="selectedProductList">
                <p class="empty-message"> Chưa có truyện nào được chọn. Hãy tìm và thêm truyện ở trên. </p>
            </div>


            <div class="flashsale-buttons">
                <button type="button" class="cancel-btn" id="closeAddFlashSale">Hủy</button>
                <button type="button" class="save-btn" id="createFlashSaleBtn">Tạo Flash Sale</button>
            </div>
        </form>
    </div>
</div>

<!-- POPUP SỬA -->
<div class="modal-overlay" id="editFlashSaleModal">
    <div class="modal-flashsale">
        <h3>Chỉnh sửa Flash Sale</h3>

        <form id="editFlashSaleForm">
            <div class="form-row">
                <div>
                    <label>Tên Flash Sale:</label>
                    <input type="text" value="Flash Sale 10:00 - Mừng Noel">
                </div>
                <div>
                    <label>Phần trăm giảm:</label>
                    <input type="number" name="discountPercent" min="1" max="90">
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label>Giờ bắt đầu:</label>
                    <input type="datetime-local" value="2024-12-24T10:00">
                </div>

                <div>
                    <label>Giờ kết thúc:</label>
                    <input type="datetime-local" value="2024-12-24T12:00">
                </div>
            </div>


            <h4>Sản phẩm đã áp dụng:</h4>

            <div class="product-select-list">
                <label>
                    <input type="checkbox" checked>
                    Thám tử lừng danh Conan – Tập 12 – Gosho Aoyama
                </label>

                <label>
                    <input type="checkbox" checked>
                    One Piece – Tập 100 – Eiichiro Oda
                </label>
            </div>

            <div class="flashsale-buttons">
                <button type="button" class="cancel-btn" id="closeEditFlashSale">Hủy</button>
                <button type="submit" class="save-btn">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<!-- POPUP XEM CHI TIẾT FLASH SALE -->
<div class="modal-overlay" id="viewFlashSaleModal">
    <div class="modal-flashsale">
        <h3>Chi tiết Flash Sale</h3>

        <div class="view-info-box">

            <p><strong>Mã Flash Sale:</strong> FS001</p>
            <p><strong>Tên Flash Sale:</strong> Flash Sale 10:00 - Mừng Noel</p>
            <p><strong>Thời gian:</strong> 10:00 24/12/2024 → 12:00 24/12/2024</p>
            <p><strong>Trạng thái:</strong> <span class="status active">Đang diễn ra</span></p>


            <h4>Sản phẩm áp dụng:</h4>
            <div class="view-product-list">
                <div class="item">
                    <span>Thám tử lừng danh Conan – Tập 12 – Gosho Aoyama</span>
                    <span>Giảm: 40%</span>
                </div>

                <div class="item">
                    <span>One Piece – Tập 100 – Eiichiro Oda</span>
                    <span>Giảm: 50%</span>
                </div>
            </div>

            <div class="flashsale-buttons">
                <button type="button" class="cancel-btn" id="closeViewFlashSale">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- POPUP XÓA FLASH SALE -->
<div class="modal-overlay" id="deleteFlashSaleModal">
    <div class="modal-delete">
        <h3>Xác nhận xóa</h3>
        <p>Bạn có chắc muốn xóa Flash Sale này không?</p>

        <div class="delete-buttons">
            <button class="cancel-btn" id="closeDeleteFlashSale">Hủy</button>
            <button class="delete-confirm-btn" id="confirmDeleteFlashSale">Xóa</button>
        </div>
    </div>
</div>


</body>
</html>

<%--            <h4>Áp dụng cho thể loại:</h4>--%>
<%--            <div class="category-select-list">--%>
<%--                <label><input type="checkbox"> Hành động</label>--%>
<%--                <label><input type="checkbox"> Phiêu lưu</label>--%>
<%--            </div>--%>