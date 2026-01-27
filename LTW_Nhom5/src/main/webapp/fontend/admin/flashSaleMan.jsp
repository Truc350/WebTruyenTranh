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
    <style>
        /* ========================================
   THÊM: PAGINATION CSS
   ======================================== */

        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            padding: 20px 0;
        }

        .pagination-info {
            color: #666;
            font-size: 14px;
            margin-right: 20px;
        }

        .pagination {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .pagination a,
        .pagination button {
            padding: 8px 12px;
            border: 1px solid #ddd;
            background: white;
            color: #333;
            cursor: pointer;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
            min-width: 36px;
            text-decoration: none;
            text-align: center;
        }

        .pagination a:hover:not(.disabled),
        .pagination button:hover:not(:disabled) {
            background: #f5f5f5;
            border-color: #ff6b6b;
            color: #ff6b6b;
        }

        .pagination a.active {
            background: #ff6b6b;
            color: white;
            border-color: #ff6b6b;
            font-weight: 600;
            pointer-events: none;
        }

        .pagination a.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        .pagination .page-ellipsis {
            padding: 8px 4px;
            color: #999;
            border: none;
            background: transparent;
            cursor: default;
        }

        /* Nút prev/next */
        .pagination .page-prev,
        .pagination .page-next {
            font-weight: 600;
        }

        .pagination .page-prev:hover:not(.disabled),
        .pagination .page-next:hover:not(.disabled) {
            background: #ff6b6b;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <jsp:include page="/fontend/admin/ASide.jsp"/>

    <div class="main-content">
        <%@ include file="HeaderAdmin.jsp" %>

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

            <%-- PHÂN TRANG LOGIC --%>
            <c:set var="itemsPerPage" value="10"/>
            <c:set var="currentPage" value="${param.page != null ? param.page : 1}"/>
            <c:set var="totalItems" value="${flashSales.size()}"/>
            <c:set var="totalPages" value="${(totalItems + itemsPerPage - 1) / itemsPerPage}"/>
            <c:set var="totalPagesInt" value="${totalPages - (totalPages % 1)}"/>

            <%-- Tính toán startIndex và endIndex --%>
            <c:set var="startIndex" value="${(currentPage - 1) * itemsPerPage}"/>
            <c:set var="endIndex" value="${startIndex + itemsPerPage}"/>
            <c:if test="${endIndex > totalItems}">
                <c:set var="endIndex" value="${totalItems}"/>
            </c:if>

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
                            <%-- Lọc danh sách Flash Sale theo trang hiện tại --%>
                            <c:forEach var="fs" items="${flashSales}" varStatus="status">
                                <c:if test="${status.index >= startIndex && status.index < endIndex}">
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
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <%-- PAGINATION --%>
                <c:if test="${totalPagesInt > 1}">
                    <div class="pagination-container">


                        <div class="pagination">
                                <%-- Nút Previous --%>
                            <c:choose>
                                <c:when test="${currentPage <= 1}">
                                    <a class="page-prev disabled">«</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${currentPage - 1}" class="page-prev">«</a>
                                </c:otherwise>
                            </c:choose>

                                <%-- Logic hiển thị số trang --%>
                            <c:choose>
                                <%-- Trường hợp tổng số trang <= 7: hiển thị tất cả --%>
                                <c:when test="${totalPagesInt <= 7}">
                                    <c:forEach var="i" begin="1" end="${totalPagesInt}">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <a class="active">${i}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="?page=${i}">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </c:when>

                                <%-- Trường hợp có nhiều trang: hiển thị có dấu ... --%>
                                <c:otherwise>
                                    <%-- Luôn hiển thị trang 1 --%>
                                    <c:choose>
                                        <c:when test="${currentPage == 1}">
                                            <a class="active">1</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?page=1">1</a>
                                        </c:otherwise>
                                    </c:choose>

                                    <%-- Hiển thị ... nếu currentPage > 3 --%>
                                    <c:if test="${currentPage > 3}">
                                        <span class="page-ellipsis">...</span>
                                    </c:if>

                                    <%-- Hiển thị các trang xung quanh trang hiện tại --%>
                                    <c:forEach var="i" begin="${currentPage - 1}" end="${currentPage + 1}">
                                        <c:if test="${i > 1 && i < totalPagesInt}">
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <a class="active">${i}</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="?page=${i}">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </c:forEach>

                                    <%-- Hiển thị ... nếu currentPage < totalPages - 2 --%>
                                    <c:if test="${currentPage < totalPagesInt - 2}">
                                        <span class="page-ellipsis">...</span>
                                    </c:if>

                                    <%-- Luôn hiển thị trang cuối --%>
                                    <c:choose>
                                        <c:when test="${currentPage == totalPagesInt}">
                                            <a class="active">${totalPagesInt}</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?page=${totalPagesInt}">${totalPagesInt}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>

                                <%-- Nút Next --%>
                            <c:choose>
                                <c:when test="${currentPage >= totalPagesInt}">
                                    <a class="page-next disabled">»</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${currentPage + 1}" class="page-next">»</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
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
            <!-- THÊM: Hidden field lưu ID -->
            <input type="hidden" id="editFlashSaleId" name="id">

            <div class="form-row">
                <div>
                    <label>Tên Flash Sale:</label>
                    <!-- THÊM: ID để dễ dàng lấy giá trị -->
                    <input type="text" id="editFlashSaleName" name="name" required>
                </div>
                <div>
                    <label>Phần trăm giảm:</label>
                    <!-- THÊM: ID để dễ dàng lấy giá trị -->
                    <input type="number" id="editDiscountPercent" name="discountPercent" min="1" max="90" required>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label>Giờ bắt đầu:</label>
                    <!-- THÊM: ID để dễ dàng lấy giá trị -->
                    <input type="datetime-local" id="editStartTime" name="startTime" required>
                </div>
                <div>
                    <label>Giờ kết thúc:</label>
                    <!-- THÊM: ID để dễ dàng lấy giá trị -->
                    <input type="datetime-local" id="editEndTime" name="endTime" required>
                </div>
            </div>

            <h4>Quản lý truyện áp dụng:</h4>

            <!-- THÊM MỚI: TÌM KIẾM VÀ THÊM TRUYỆN (GIỐNG POPUP THÊM) -->
            <div class="comic-search-container">
                <input type="text" id="editComicSearchInput"
                       placeholder="Tìm kiếm để thêm truyện mới vào Flash Sale"
                       class="search-input" autocomplete="off">

                <div id="editSearchResults" class="search-results">
                    <!-- Kết quả tìm kiếm hiển thị ở đây -->
                </div>
            </div>

            <!-- THAY ĐỔI: Từ checkbox list → Danh sách có thể xóa -->
            <div class="selected-comics-list" id="editSelectedProductList">
                <p class="empty-message">Đang tải danh sách truyện...</p>
            </div>

            <div class="flashsale-buttons">
                <button type="button" class="cancel-btn" id="closeEditFlashSale">Hủy</button>
                <!-- THAY ĐỔI: Từ submit → button với ID mới -->
                <button type="button" class="save-btn" id="updateFlashSaleBtn">Cập nhật</button>
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
