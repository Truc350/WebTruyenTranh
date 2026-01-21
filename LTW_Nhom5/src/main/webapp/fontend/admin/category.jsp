<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý thể loại</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/fontend/css/adminCss/styleCat.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/fontend/css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/fontend/css/adminCss/adminHeader.css">

    <!-- Toast Message CSS -->
    <style>
        /* Toast Message Styles */
        .toast-message {
            position: fixed;
            top: -100px;
            right: 20px;
            background: white;
            padding: 16px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 10000;
            min-width: 300px;
            transition: top 0.3s ease-in-out;
            font-size: 14px;
        }

        .toast-message.show {
            top: 20px;
        }

        .toast-message i {
            font-size: 20px;
        }

        .toast-success {
            border-left: 4px solid #4caf50;
        }

        .toast-success i {
            color: #4caf50;
        }

        .toast-error {
            border-left: 4px solid #f44336;
        }

        .toast-error i {
            color: #f44336;
        }

        .toast-info {
            border-left: 4px solid #2196f3;
        }

        .toast-info i {
            color: #2196f3;
        }

        .toast-message span {
            flex: 1;
            color: #333;
        }
    </style>
</head>
<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <img src="<%=request.getContextPath()%>/img/logo.png" alt="Logo" class="logo">
            <h2>Comic Store</h2>
        </div>

        <ul>
            <li>
                <a href="dashboard.jsp">
                    <img src="<%=request.getContextPath()%>/img/home.png" class="icon">
                    <span>Trang chủ</span>
                </a>
            </li>
            <li>
                <a href="seriesManagement.jsp">
                    <img src="<%=request.getContextPath()%>/img/series.png" class="icon">
                    <span>Quản lý series</span>
                </a>
            </li>
            <li>
                <a href="productManagement.jsp">
                    <img src="<%=request.getContextPath()%>/img/product.png" class="icon">
                    <span>Quản lý sản phẩm</span>
                </a>
            </li>
            <li>
                <a href="category.jsp" class="active">
                    <img src="<%=request.getContextPath()%>/img/category.png" class="icon">
                    <span>Quản lý thể loại</span>
                </a>
            </li>
            <li>
                <a href="order.jsp">
                    <img src="<%=request.getContextPath()%>/img/order.png" class="icon">
                    <span>Quản lý đơn hàng</span>
                </a>
            </li>
            <li>
                <a href="userManagement.jsp">
                    <img src="<%=request.getContextPath()%>/img/user.png" class="icon">
                    <span>Quản lý người dùng</span>
                </a>
            </li>
            <li>
                <a href="flashSaleMan.jsp">
                    <img src="<%=request.getContextPath()%>/img/flashSale.png" class="icon">
                    <span>Quản lý Flash Sale</span>
                </a>
            </li>
            <li>
                <a href="report.jsp">
                    <img src="<%=request.getContextPath()%>/img/report.png" class="icon">
                    <span>Thống kê</span>
                </a>
            </li>
        </ul>
    </aside>

    <div class="main-content">
        <header class="admin-header">
            <div class="header-right">
                <a href="chatWithCus.jsp">
                    <i class="fa-solid fa-comment"></i>
                </a>

                <div class="admin-profile">
                    <a href="profileAdmin.jsp">
                        <img src="<%=request.getContextPath()%>/img/admin.png" class="admin-avatar" alt="Admin">
                    </a>
                    <span class="admin-name">Admin</span>
                </div>

                <!-- Nút đăng xuất -->
                <button class="btn-logout" title="Đăng xuất">
                    <a href="../public/login_bo.jsp">
                        <i class="fa-solid fa-right-from-bracket"></i>
                    </a>
                </button>
            </div>
        </header>
        <h2 class="page-title">Quản lý thể loại</h2>

        <div class="table-container">
            <div class="search-add">
                <!-- THANH TÌM KIẾM -->
                <div class="search-box">
                    <input type="text"
                           id="categorySearchInput"
                           placeholder="Tìm kiếm thể loại theo tên..."
                           autocomplete="off">
                    <button type="button" id="categorySearchBtn">
                        <i class="fas fa-magnifying-glass"></i>
                    </button>
                </div>

                <!-- NÚT THÊM THỂ LOẠI -->
                <div class="action-buttons">
                    <button class="add-category-btn">+ Thêm thể loại</button>
                </div>
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>Mã thể loại</th>
                    <th>Tên thể loại</th>
<%--                    <th>Mô tả</th>--%>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody id="categoryTableBody">
                <!-- Data sẽ được load bằng JavaScript -->
                <tr><td colspan="4" style="text-align: center;">Đang tải dữ liệu...</td></tr>
                </tbody>
            </table>
        </div>
        <div id="categoryPaginationContainer" class="pagination-container"></div>

        <!--Thêm thể loại-->
        <div class="popup-overlay" id="addPopup">
            <div class="popup-box">
                <h3>Thêm thể loại</h3>
                <label>Tên thể loại:</label>
                <input type="text" id="newCategoryName" placeholder="Nhập tên thể loại">
                <label>Mô tả:</label>
                <textarea id="newCategoryDesc" rows="4" placeholder="Nhập mô tả (tùy chọn)"></textarea>
                <label>Ngày tạo:</label>
                <input type="date" id="newCategoryCreatedDate" readonly>

                <div class="popup-actions">
                    <button class="save-btn">Lưu</button>
                    <button class="cancel-btn" onclick="closeAddPopup()">Hủy</button>
                </div>
            </div>
        </div>

        <!-- Popup SỬA thể loại -->
        <div class="popup-overlay" id="editPopup">
            <div class="popup-box">
                <h3>Chỉnh sửa thể loại</h3>

                <label>Mã thể loại:</label>
                <input type="text" id="editCategoryId" readonly>

                <label>Tên thể loại:</label>
                <input type="text" id="editCategoryName">

                <label>Mô tả:</label>
                <textarea id="editCategoryDesc" rows="4"></textarea>

                <label>Ngày tạo:</label>
                <input type="date" id="editCategoryCreatedDate" readonly>

                <div class="popup-actions">
                    <button class="save-btn">Cập nhật</button>
                    <button class="cancel-btn" onclick="closeEditPopup()">Hủy</button>
                </div>
            </div>
        </div>

        <!-- Xóa thể loại -->
        <div class="popup-overlay" id="deletePopup">
            <div class="popup-box">
                <h3>Bạn có chắc muốn xóa?</h3>
                <p id="deleteCategoryName" style="text-align: center; color: #666; margin: 10px 0;"></p>
                <div class="popup-actions">
                    <button class="save-btn" id="confirmDeleteBtn">Xóa</button>
                    <button class="cancel-btn" onclick="closeDeletePopup()">Hủy</button>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- JavaScript -->
<script>
    // Lấy context path từ JSP và gán vào window để JS file external có thể dùng
    window.contextPath = '<%=request.getContextPath()%>';
    console.log('Context path set to:', window.contextPath);
</script>
<script src="<%=request.getContextPath()%>/js/categoryManagement.js"></script>

</body>
</html>
