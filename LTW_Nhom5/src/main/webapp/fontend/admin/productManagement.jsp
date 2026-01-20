<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Load danh sách thể loại và bộ truyện --%>
<jsp:useBean id="categoryDAO" class="vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao"/>
<jsp:useBean id="seriesDAO" class="vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO"/>

<c:set var="categories" value="${categoryDAO.allCategories}"/>
<c:set var="seriesList" value="${seriesDAO.allSeries}"/>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/stylePro.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/adminHeader.css">
</head>
<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <img src="../../img/logo.png" alt="Logo" class="logo">
            <h2>Comic Store</h2>
        </div>

        <ul>
            <li>
                <a href="dashboard.jsp">
                    <img src="../../img/home.png" class="icon">
                    <span>Trang chủ</span>
                </a>
            </li>
            <li>
                <a href="seriesManagement.jsp">
                    <img src="../../img/series.png" class="icon">
                    <span>Quản lý series</span>
                </a>
            </li>
            <li>
                <a href="productManagement.jsp">
                    <img src="../../img/product.png" class="icon">
                    <span>Quản lý sản phẩm</span>
                </a>
            </li>
            <li>
                <a href="category.jsp">
                    <img src="../../img/category.png" class="icon">
                    <span>Quản lý thể loại</span>
                </a>
            </li>
            <li>
                <a href="order.jsp">
                    <img src="../../img/order.png" class="icon">
                    <span>Quản lý đơn hàng</span>
                </a>
            </li>
            <li>
                <a href="userManagement.jsp">
                    <img src="../../img/user.png" class="icon">
                    <span>Quản lý người dùng</span>
                </a>
            </li>
            <li>
                <a href="flashSaleMan.jsp">
                    <img src="../../img/flashSale.png" class="icon">
                    <span>Quản lý Flash Sale</span>
                </a>
            </li>
            <%--            <li>--%>
            <%--                <a href="promotion.jsp">--%>
            <%--                    <img src="../../img/promo.png" class="icon">--%>
            <%--                    <span>Quản lý khuyến mãi</span>--%>
            <%--                </a>--%>
            <%--            </li>--%>
            <li>
                <a href="report.jsp">
                    <img src="../../img/report.png" class="icon">
                    <span>Thống kê</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main content -->
    <main class="main-content">
        <header class="admin-header">
            <div class="header-right">
                <a href="chatWithCus.jsp">
                    <i class="fa-solid fa-comment"></i>
                </a>

                <div class="admin-profile">
                    <a href="profileAdmin.jsp">
                        <img src="../../img/admin.png" class="admin-avatar" alt="Admin">
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
        <h2 class="page-title">Quản lý sản phẩm</h2>

        <div class="table-container">

            <div class="search-add">
                <div class="search-box">
                    <input type="text" id="mainSearchInput" name="keyword" placeholder="Tìm kiếm truyện..."
                           value="${param.keyword}">
                    <button type="submit" onclick="searchProducts()">
                        <i class="fas fa-magnifying-glass"></i>
                    </button>
                </div>

                <div class="action-buttons">
                    <button class="add-btn">+ Thêm truyện</button>
                    <%--                    <button class="delete-btn">Xóa truyện</button>--%>
                </div>
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>Mã truyện</th>
                    <th>Tên truyện</th>
                    <th>Bộ truyện</th>
                    <th>Thể loại</th>
                    <th>Tác giả</th>
                    <th>Giá</th>
                    <th>Còn trong kho</th>
                    <th>Đánh giá</th>
                    <th></th>
                </tr>
                </thead>
                <tbody id="productTableBody">
                </tbody>
            </table>
        </div>


        <!-- POPUP THÊM TRUYỆN -->
        <div class="modal-overlay" id="addModal">
            <div class="modal-rectangle">
                <h3>Thêm truyện mới</h3>
                <form id="addForm" class="form-horizontal" enctype="multipart/form-data">
                    <div class="form-left">

                        <div class="form-group">
                            <label>Tên truyện: <span style="color: red;">*</span></label>
                            <input type="text" name="nameComics" required>
                        </div>

                        <div class="form-group">
                            <label>Bộ truyện:</label>
                            <select name="seriesId">
                                <option value="" selected>-- Chọn bộ truyện --</option>
                                <c:forEach var="series" items="${seriesList}">
                                    <option value="${series.id}">${series.seriesName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Thể loại: <span style="color: red;">*</span></label>
                            <select name="categoryId" required>
                                <option value="" selected disabled>-- Chọn thể loại --</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}">${category.nameCategories}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group two-columns">
                            <div>
                                <label>Số lượng: <span style="color: red;">*</span></label>
                                <input type="number" name="stockQuantity" min="0" value="0" required>
                            </div>

                            <div>
                                <label>Giá: <span style="color: red;">*</span></label>
                                <input type="text" name="price" placeholder="VD: 25,000" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Tác giả: <span style="color: red;">*</span></label>
                            <input type="text" name="author" required>
                        </div>

                        <div class="form-group">
                            <label>Nhà xuất bản:</label>
                            <input type="text" name="publisher">
                        </div>

                        <div class="form-group two-columns">
                            <div style="flex: 0.9">
                                <label>Ngày đăng:</label>
                                <input type="date">
                            </div>

                            <div style="flex: 1">
                                <label>Tập:</label>
                                <input type="number" name="volume" min="1" placeholder="VD: 1">
                            </div>
                        </div>
                    </div>

                    <div class="form-right">
                        <div class="images-grid">

                            <!-- ẢNH BÌA -->
                            <div class="image-upload">
                                <input type="file" class="imgInput" name="coverImage" accept="image/*" hidden>
                                <div class="img-box">
                                    <i class="icon">+</i>
                                    <span class="label">Ảnh bìa</span>
                                    <img class="imgPreview">
                                </div>
                            </div>

                            <!-- ẢNH TRANG 1 -->
                            <div class="image-upload">
                                <input type="file" class="imgInput" name="detailImage1" accept="image/*" hidden>
                                <div class="img-box">
                                    <i class="icon">+</i>
                                    <span class="label">Trang chi tiết 1</span>
                                    <img class="imgPreview">
                                </div>
                            </div>

                            <!-- ẢNH TRANG 2 -->
                            <div class="image-upload">
                                <input type="file" class="imgInput" name="detailImage2" accept="image/*" hidden>
                                <div class="img-box">
                                    <i class="icon">+</i>
                                    <span class="label">Trang chi tiết 2</span>
                                    <img class="imgPreview">
                                </div>
                            </div>

                            <!-- ẢNH TRANG 3 -->
                            <div class="image-upload">
                                <input type="file" class="imgInput" name="detailImage3" accept="image/*" hidden>
                                <div class="img-box">
                                    <i class="icon">+</i>
                                    <span class="label">Trang chi tiết 3</span>
                                    <img class="imgPreview">
                                </div>
                            </div>

                        </div>

                        <div class="form-group">
                            <label>Mô tả ngắn:</label>
                            <textarea name="description" rows="6" placeholder="Nhập mô tả ngắn..."></textarea>
                        </div>
                    </div>
                </form>

                <div class="form-buttons">
                    <button type="button" class="save-btn">Lưu</button>
                    <button type="button" class="cancel-btn">Hủy</button>
                </div>
            </div>
        </div>

        <!-- POPUP SỬA TRUYỆN -->
        <div class="modal-overlay" id="editModal">
            <div class="modal-rectangle">
                <h3>Chỉnh sửa truyện</h3>

                <form id="editForm" class="form-horizontal">
                    <div class="form-left">
                        <!-- Sẽ được populate bởi JavaScript -->
                    </div>

                    <div class="form-right">
                        <div class="images-grid">
                            <!-- ẢNH BÌA -->
                            <div class="image-upload">
                                <input type="file" class="editImgInput" name="coverImage" accept="image/*" hidden>
                                <div class="img-box">
                                    <i class="icon">+</i>
                                    <span class="label">Ảnh bìa</span>
                                    <img class="imgPreview">
                                </div>
                            </div>

                            <!-- ẢNH CHI TIẾT 1 -->
                            <div class="image-upload">
                                <input type="file" class="editImgInput" name="detailImage1" accept="image/*" hidden>
                                <div class="img-box">
                                    <i class="icon">+</i>
                                    <span class="label">Trang 1</span>
                                    <img class="imgPreview">
                                </div>
                            </div>

                            <!-- ẢNH CHI TIẾT 2 -->
                            <div class="image-upload">
                                <input type="file" class="editImgInput" name="detailImage2" accept="image/*" hidden>
                                <div class="img-box">
                                    <i class="icon">+</i>
                                    <span class="label">Trang 2</span>
                                    <img class="imgPreview">
                                </div>
                            </div>

                            <!-- ẢNH CHI TIẾT 3 -->
                            <div class="image-upload">
                                <input type="file" class="editImgInput" name="detailImage3" accept="image/*" hidden>
                                <div class="img-box">
                                    <i class="icon">+</i>
                                    <span class="label">Trang 3</span>
                                    <img class="imgPreview">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Mô tả ngắn:</label>
                            <textarea name="description" rows="6" placeholder="Nhập mô tả..."></textarea>
                        </div>
                    </div>
                </form>

                <div class="form-buttons">
                    <button type="button" class="cancel-btn">Hủy</button>
                    <button type="button" class="save-btn">Cập nhật</button>
                </div>
            </div>
        </div>


        <!-- POPUP XÓA TRUYỆN -->
<%--        <div class="modal-overlay" id="deleteModal">--%>
<%--            <div class="delete-modal">--%>
<%--                <h3>Xóa truyện</h3>--%>

<%--                <div class="search-bar">--%>
<%--                    <input type="text" id="searchInput" placeholder="Tìm truyện để xóa...">--%>
<%--                    <button id="searchBtn" class="search-icon">--%>
<%--                        <i class="fa-solid fa-magnifying-glass"></i>--%>
<%--                    </button>--%>
<%--                </div>--%>

<%--                <div class="delete-list">--%>
<%--                    <label><input type="checkbox"> Thám tử lừng danh Conan – Tập 15 – Gosho Aoyama</label>--%>
<%--                    <label><input type="checkbox"> Doraemon – Tập 30 – Fujiko F. Fujio</label>--%>
<%--                    <label><input type="checkbox"> One Piece – Tập 100 – Eiichiro Oda</label>--%>
<%--                    <label><input type="checkbox"> Attack on Titan – Tập 17 – Hajime Isayama</label>--%>
<%--                    <label><input type="checkbox"> Naruto – Tập 300 – Masashi Kishimoto</label>--%>
<%--                    <label><input type="checkbox"> Bleach – Tập 70 – Tite Kubo</label>--%>
<%--                    <label><input type="checkbox"> Spy x Family – Tập 12 – Tatsuya Endo</label>--%>
<%--                    <label><input type="checkbox"> Bleach – Tập 40 – Tite Kubo</label>--%>
<%--                    <label><input type="checkbox"> Spy x Family– Tập 45 – Tatsuya Endo</label>--%>
<%--                    <label><input type="checkbox"> Bleach– Tập 80 – Tite Kubo</label>--%>
<%--                    <label><input type="checkbox"> Spy x Family– Tập 50 – Tatsuya Endo</label>--%>
<%--                </div>--%>

<%--                <div class="delete-buttons">--%>
<%--                    <button class="cancel-btn">Hủy</button>--%>
<%--                    <button class="delete-confirm-btn">Xóa</button>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
        deleteBtnMain

        <!-- POPUP XÁC NHẬN XÓA -->
        <div class="modal-overlay" id="confirmDeleteModal">
            <div class="confirm-box">
                <p>Bạn có chắc muốn xóa truyện không?</p>
                <div class="confirm-buttons">
                    <button class="cancel-btn">Hủy</button>
                    <button class="delete-confirm-btn">Xác nhận</button>
                </div>
            </div>
        </div>

        <!-- POPUP REVIEW -->
        <div class="modal-overlay review-popup" id="review-TT001">
            <div class="modal-rectangle">

                <div class="review-list">
                    <div class="review-item">
                        <p><strong>Nguyễn Văn A</strong> -
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                        </p>

                        <p class="review-date">08/11/2024</p>

                        <p>Shop đóng gói cẩn thận, bọc nilon và seal đều rất chu đáo, còn bọc thêm chống sốc và bìa cứng
                            để truyện không bị hư hại gì. Nhất định sẽ mua lại ạ :3</p>
                        <div>
                            <img src="../../img/review1.png" alt="review">
                            <img src="../../img/review2.png" alt="review">
                            <img src="../../img/review3.png" alt="review">
                        </div>
                    </div>

                    <div class="review-item">
                        <p><strong>Trần Thị B</strong> -
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i></p>

                        <p class="review-date">08/11/2024</p>

                        <p>Shop giao hàng nhanh chóng gói hàng cũng kỹ lưỡng nha chu đáo nhắn tin với khách.</p>
                        <div>
                            <img src="../../img/review4.png" alt="review">
                        </div>
                    </div>

                    <div class="review-item">
                        <p><strong>Trần Thị B</strong> -
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i></p>

                        <p class="review-date">08/11/2024</p>

                        <p>Shop giao hàng nhanh chóng gói hàng cũng kỹ lưỡng nha chu đáo nhắn tin với khách.</p>
                        <div>
                            <img src="../../img/review4.png" alt="review">
                        </div>
                    </div>
                </div>

                <div class="form-buttons">
                    <button type="button" class="cancel-btn close-review-btn">Đóng</button>
                </div>
            </div>
        </div>
        <div id="paginationContainer" class="pagination-container"></div>
    </main>


</div>
<%--ti kiem tram--%>
<script>
    let currentPage = 1;

    function searchProducts(page = 1) {
        const keyword = document.getElementById('mainSearchInput').value.trim();
        const tbody = document.getElementById('productTableBody');

        // Hiển thị loading
        tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 40px;">' +
            '<i class="fas fa-spinner fa-spin" style="font-size: 32px; color: #ff4c4c;"></i>' +
            '<p style="margin-top: 10px;">Đang tìm kiếm...</p></td></tr>';

        // Gọi API
        const url = '${pageContext.request.contextPath}/admin/products/search?keyword=' +
            encodeURIComponent(keyword) + '&page=' + page;

        console.log('Calling API:', url); // DEBUG

        fetch(url)
            .then(response => {
                console.log('Response status:', response.status); // DEBUG
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Data received:', data); // DEBUG
                currentPage = data.currentPage;
                updateTable(data.comics);
                updatePagination(data.currentPage, data.totalPages);

                bindEventListeners();
            })
            .catch(error => {
                console.error('Error:', error);
                tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 40px; color: #f44336;">' +
                    '<i class="fas fa-exclamation-triangle" style="font-size: 32px;"></i>' +
                    '<p style="margin-top: 10px;">Có lỗi xảy ra: ' + error.message + '</p></td></tr>';
            });
    }

    function updateTable(comics) {
        const tbody = document.getElementById('productTableBody');

        if (!comics || comics.length === 0) {
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 40px; color: #999;">' +
                '<i class="fas fa-inbox" style="font-size: 48px; display: block; margin-bottom: 10px;"></i>' +
                '<p style="margin: 0; font-size: 16px;">Không tìm thấy truyện nào</p></td></tr>';
            return;
        }

        let html = '';

        comics.forEach(function (comic) {
            html += '<tr>' +
                '<td>' + comic.id + '</td>' +
                '<td>' + comic.nameComics + '</td>' +
                '<td>' + (comic.seriesName || '-') + '</td>' +
                '<td>' + (comic.categoryName || 'Chưa phân loại') + '</td>' +
                '<td>' + (comic.author || '-') + '</td>' +
                '<td>' + formatPrice(comic.price) + ' đ</td>' +
                '<td>' + comic.stockQuantity + ' quyển</td>' +
                '<td class="review-cell">' +
                '<button class="view-review-btn" data-comic="' + comic.id + '" title="Xem review">' +
                '<i class="fa-solid fa-eye"></i>' +
                '</button>' +
                '</td>' +
                '<td class="action-cell">' +
                '<button class="edit-btn" data-comic-id="' + comic.id + '" title="Chỉnh sửa">' +
                '<i class="fa-solid fa-pen-to-square"></i>' +
                '</button>' +
                '<button class="trash-btn" data-comic-id="' + comic.id + '" title="Xóa truyện">' +
                '<i class="fa-solid fa-trash"></i>' +
                '</button>' +
                '<div class="menu-container">' +
                '<button class="more-btn">⋮</button>' +
                '<div class="dropdown-menu">' +
                '<label><input type="radio" name="display-' + comic.id + '" checked> Hiển thị</label>' +
                '<label><input type="radio" name="display-' + comic.id + '"> Ẩn sản phẩm</label>' +
                '</div>' +
                '</div>' +
                '</td>' +
                '</tr>';
        });

        tbody.innerHTML = html;
    }

    function updatePagination(currentPage, totalPages, totalComics) {
        const paginationContainer = document.getElementById('paginationContainer');

        if (totalPages <= 1) {
            paginationContainer.style.display = 'none';
            return;
        }

        paginationContainer.style.display = 'block';

        // BỎ phần pagination-wrapper và pagination-info
        let paginationHtml = '<div class="pagination">';

        if (currentPage > 1) {
            paginationHtml += '<button class="page-btn nav-btn" onclick="searchProducts(1)">⏮</button>';
            paginationHtml += '<button class="page-btn nav-btn" onclick="searchProducts(' + (currentPage - 1) + ')">◀</button>';
        } else {
            paginationHtml += '<button class="page-btn nav-btn" disabled>⏮</button>';
            paginationHtml += '<button class="page-btn nav-btn" disabled>◀</button>';
        }

        const maxVisible = 5;
        let startPage = Math.max(1, currentPage - Math.floor(maxVisible / 2));
        let endPage = Math.min(totalPages, startPage + maxVisible - 1);
        if (endPage - startPage < maxVisible - 1) {
            startPage = Math.max(1, endPage - maxVisible + 1);
        }

        if (startPage > 1) {
            paginationHtml += '<button class="page-btn" onclick="searchProducts(1)">1</button>';
            if (startPage > 2) paginationHtml += '<span>...</span>';
        }

        for (let i = startPage; i <= endPage; i++) {
            const activeClass = i === currentPage ? 'active' : '';
            paginationHtml += '<button class="page-btn ' + activeClass + '" onclick="searchProducts(' + i + ')">' + i + '</button>';
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) paginationHtml += '<span>...</span>';
            paginationHtml += '<button class="page-btn" onclick="searchProducts(' + totalPages + ')">' + totalPages + '</button>';
        }

        if (currentPage < totalPages) {
            paginationHtml += '<button class="page-btn nav-btn" onclick="searchProducts(' + (currentPage + 1) + ')">▶</button>';
            paginationHtml += '<button class="page-btn nav-btn" onclick="searchProducts(' + totalPages + ')">⏭</button>';
        } else {
            paginationHtml += '<button class="page-btn nav-btn" disabled>▶</button>';
            paginationHtml += '<button class="page-btn nav-btn" disabled>⏭</button>';
        }

        paginationHtml += '</div>';

        paginationContainer.innerHTML = paginationHtml;
    }

    function formatPrice(price) {
        return new Intl.NumberFormat('vi-VN').format(price);
    }

    // HÀM BIND LẠI EVENT LISTENERS SAU KHI RENDER
    function bindEventListeners() {
        // 1. Bind event cho nút "Xem review"
        document.querySelectorAll('.view-review-btn').forEach(btn => {
            btn.addEventListener('click', function () {
                const comicId = this.dataset.comic;
                const popup = document.getElementById(`review-${comicId}`);
                if (popup) {
                    popup.style.display = 'flex';
                } else {
                    alert('Popup review cho truyện ID ' + comicId + ' chưa được tạo!');
                }
            });
        });

        // 2. Bind event cho nút "Sửa"
        document.querySelectorAll('.edit-btn').forEach(btn => {
            btn.addEventListener('click', function () {
                const comicId = this.dataset.comicId;
                console.log('Edit comic ID:', comicId);
                document.getElementById('editModal').style.display = 'flex';
            });
        });

        // 3. Bind event cho nút "Xóa" - ĐOẠN MỚI
        document.querySelectorAll('.trash-btn').forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                const comicId = this.dataset.comicId;
                const comicRow = this.closest('tr');
                const comicName = comicRow.querySelector('td:nth-child(2)').textContent;

                console.log('🗑️ Delete button clicked for comic ID:', comicId, 'Name:', comicName);

                // Gọi hàm từ deleteComic.js
                if (typeof window.showDeleteConfirmation === 'function') {
                    window.showDeleteConfirmation(comicId, comicName);
                } else {
                    console.error('❌ showDeleteConfirmation not found!');
                    // Fallback nếu script chưa load
                    const confirmDelete = confirm('Bạn có chắc muốn xóa truyện "' + comicName + '" không?');
                    if (confirmDelete) {
                        window.deleteComicDirect(comicId);
                    }
                }
            });
        });

        // 4. Bind event cho menu "Hiện/Ẩn"
        document.querySelectorAll('.more-btn').forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                document.querySelectorAll('.dropdown-menu').forEach(m => m.style.display = 'none');

                const menu = this.nextElementSibling;
                const rect = this.getBoundingClientRect();

                menu.style.display = 'block';
                menu.style.top = rect.bottom + 'px';
                menu.style.left = (rect.right - menu.offsetWidth) + 'px';
            });
        });
    }

    // Tìm kiếm khi nhấn Enter
    document.getElementById('mainSearchInput').addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            searchProducts(1);
        }
    });

    // BIND EVENT CHO CÁC PHẦN TỬ BAN ĐẦU (TỪ HTML TĨnh)
    document.addEventListener('DOMContentLoaded', function () {
        bindEventListeners();
    });


    async function deleteComic(comicId) {
        try {
            const response = await fetch(contextPath + '/admin/products/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({id: comicId})
            });

            const result = await response.json();

            if (result.success) {
                alert('Xóa truyện thành công!');
                // Reload lại danh sách
                searchProducts(currentPage);
            } else {
                alert('Lỗi: ' + (result.message || 'Không thể xóa truyện'));
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi xóa truyện');
        }
    }

</script>

<!--action của hiện/ ẩn sản phẩm-->
<script>
    document.querySelectorAll('.more-btn').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.stopPropagation();
            document.querySelectorAll('.dropdown-menu').forEach(m => m.style.display = 'none');

            const menu = this.nextElementSibling;
            const rect = this.getBoundingClientRect();

            menu.style.display = 'block';
            menu.style.top = rect.bottom + 'px';
            menu.style.left = (rect.right - menu.offsetWidth) + 'px';
        });
    });

    document.addEventListener('click', () => {
        document.querySelectorAll('.dropdown-menu').forEach(m => m.style.display = 'none');
    });
</script>

<!--THEM TRUYEN-->
<script>
    const addBtn = document.querySelector('.add-btn');
    const modal = document.getElementById('addModal');
    const cancelBtn = document.querySelector('.cancel-btn');

    if (addBtn) {
        addBtn.addEventListener('click', () => {
            modal.style.display = 'flex';
        });
    }

    if (modal) {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
</script>

<script>
    // === MỞ POPUP SỬA ===
    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.getElementById('editModal').style.display = 'flex';
        });
    });

    // === MỞ POPUP XÓA ===
    // const deleteBtnMain = document.querySelector('.delete-btn');
    // if (deleteBtnMain) {
    //     deleteBtnMain.addEventListener('click', () => {
    //         document.getElementById('deleteModal').style.display = 'flex';
    //     });
    // }

    // === ĐÓNG POPUP KHI NHẤN HỦY ===
    document.querySelectorAll('.cancel-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const modal = e.target.closest('.modal-overlay');
            if (modal) {
                modal.style.display = 'none';
            }
        });
    });

    // === KHI NHẤN XÓA TRONG POPUP DANH SÁCH ===
    // document.querySelectorAll('.delete-confirm-btn').forEach(btn => {
    //     btn.addEventListener('click', () => {
    //         document.getElementById('confirmDeleteModal').style.display = 'flex';
    //     });
    // });

    // === TÌM KIẾM TRUYỆN TRONG POPUP XÓA ===
    // const searchInput = document.getElementById('searchInput');
    // const searchBtn = document.getElementById('searchBtn');
    // const deleteList = document.querySelector('.delete-list');
    //
    // if (searchBtn && searchInput && deleteList) {
    //     searchBtn.addEventListener('click', () => {
    //         const keyword = searchInput.value.toLowerCase().trim();
    //         const labels = deleteList.querySelectorAll('label');
    //         labels.forEach(label => {
    //             const text = label.textContent.toLowerCase();
    //             label.style.display = text.includes(keyword) ? 'block' : 'none';
    //         });
    //     });
    //
    //     searchInput.addEventListener('keypress', e => {
    //         if (e.key === 'Enter') searchBtn.click();
    //     });
    // }
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const current = window.location.pathname.split("/").pop();
        const links = document.querySelectorAll(".sidebar li a");

        links.forEach(link => {
            const linkPage = link.getAttribute("href");
            if (linkPage === current) {
                link.classList.add("active");
            }
        });
    });
</script>

<script>
    document.querySelectorAll('.view-review-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const comicId = btn.dataset.comic;
            const popup = document.getElementById(`review-${comicId}`);
            if (popup) popup.style.display = 'flex';
        });
    });

    document.querySelectorAll('.close-review-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            btn.closest('.review-popup').style.display = 'none';
        });
    });

    document.querySelectorAll('.review-popup').forEach(popup => {
        popup.addEventListener('click', (e) => {
            if (e.target === popup) popup.style.display = 'none';
        });
    });
</script>

<!--Upload 4 anh cho truyen-->
<script>
    document.querySelectorAll(".image-upload").forEach(box => {
        const input = box.querySelector(".imgInput");
        const preview = box.querySelector(".imgPreview");
        const label = box.querySelector(".label");
        const icon = box.querySelector(".icon");
        const imgBox = box.querySelector(".img-box");

        if (imgBox && input) {
            imgBox.addEventListener("click", () => input.click());

            input.addEventListener("change", () => {
                const file = input.files[0];
                if (!file) return;

                const reader = new FileReader();
                reader.onload = e => {
                    preview.src = e.target.result;
                    preview.style.display = "block";
                    if (icon) icon.style.display = "none";
                    if (label) label.style.display = "none";
                };
                reader.readAsDataURL(file);
            });
        }
    });
</script>

<!--SUA TRUYEN-->
<script>
    document.querySelectorAll("#editModal .image-upload .img-box").forEach((box) => {
        box.addEventListener("click", () => {
            const input = box.parentElement.querySelector(".editImgInput");
            if (input) input.click();
        });
    });

    document.querySelectorAll(".editImgInput").forEach((input) => {
        input.addEventListener("change", () => {
            const file = input.files[0];
            if (file) {
                const img = input.parentElement.querySelector(".imgPreview");
                if (img) img.src = URL.createObjectURL(file);
            }
        });
    });
</script>

<!-- ===== DEFINE CONTEXT PATH ===== -->
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>




<!-- ===== LOAD DANH SÁCH BAN ĐẦU ===== -->
<script>

    document.addEventListener('DOMContentLoaded', function () {

        console.log('🔄 Loading initial comics list...');
        loadInitialComicsList();
    });


    async function loadInitialComicsList() {
        const tbody = document.getElementById('productTableBody');

        tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 40px;">' +
            '<i class="fas fa-spinner fa-spin" style="font-size: 32px; color: #ff4c4c;"></i>' +
            '<p style="margin-top: 10px;">Đang tải danh sách truyện...</p></td></tr>';

        try {
            const url = contextPath + '/admin/products/list?page=1';
            console.log('📥 Fetching from:', url);

            const response = await fetch(url);
            if (!response.ok) throw new Error('HTTP error! status: ' + response.status);

            const data = await response.json();
            console.log('📦 Data received:', data);

            if (data.success && data.comics) {
                console.log('✅ Comics count:', data.comics.length);
                updateTable(data.comics);
                updatePagination(1, data.totalPages || 1, data.totalComics || data.comics.length);
                bindEventListeners();
            } else {
                tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 40px; color: #f44336;">' +
                    '<p>Không thể tải dữ liệu</p></td></tr>';
            }
        } catch (error) {
            console.error('❌ Error:', error);
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 40px; color: #f44336;">' +
                '<i class="fas fa-exclamation-triangle" style="font-size: 32px;"></i>' +
                '<p style="margin-top: 10px;">Lỗi: ' + error.message + '</p></td></tr>';
        }
    }
</script>

<!-- Script thêm truyện mới -->
<script src="${pageContext.request.contextPath}/js/addComic.js"></script>
<!-- Script chỉnh sửa truyện -->
<script src="${pageContext.request.contextPath}/js/editComic.js"></script>
<!-- Script xóa truyện -->
<script src="${pageContext.request.contextPath}/js/deleteComic.js"></script>
</body>
</html>


</body>
</html>