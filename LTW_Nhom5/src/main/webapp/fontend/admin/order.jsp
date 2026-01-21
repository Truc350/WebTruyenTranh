<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleOrder.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/adminHeader.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

</head>
<body>

<script>
    // Định nghĩa BASE_URL để dùng cho tất cả fetch
    const BASE_URL = '${pageContext.request.contextPath}';
</script>

<div class="container">

    <!-- Sidebar -->
    <jsp:include page="/fontend/admin/ASide.jsp"/>


    <div class="main-content">
        <jsp:include page="/fontend/admin/HeaderAdmin.jsp"/>
        <h2 class="page-title">Quản lý đơn hàng</h2>

        <!-- Thanh trạng thái đơn hàng -->
        <div class="order-tabs">
            <span class="tab-item active">Chờ xác nhận</span>
            <span class="tab-item">Chờ lấy hàng</span>
            <span class="tab-item">Đang giao</span>
            <span class="tab-item">Đã giao</span>
            <span class="tab-item">Trả hàng / Hoàn tiền</span>
            <span class="tab-item">Đơn bị hủy</span>
        </div>

        <!--        TAB CHỜ XÁC NHẬN-->
        <!-- Thanh tìm kiếm + chọn đơn vị vận chuyển -->
        <div class="tab-content" id="tab-pending">
            <div class="order-controls">
                <div class="search-box">
                    <input type="text" id="pendingSearch"
                           placeholder="Tìm kiếm theo mã đơn hoặc tên khách hàng..." class="search-input">
                    <i class="fas fa-magnifying-glass"></i>
                </div>
                <button class="confirm-all-btn">Xác nhận tất cả</button>
            </div>

            <!-- Bảng đơn hàng -->
            <div class="table-wrapper">
                <table class="order-table">
                    <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Thanh toán</th>
                        <th>Sản phẩm</th>
                        <th>Địa chỉ giao hàng</th>
                        <th>Đơn vị vận chuyển</th>
                        <th></th>
                    </tr>
                    </thead>

                    <tbody id="confirmTableBody">

                    <c:forEach items="${ordersByStatus['Pending']}" var="order" varStatus="status">
                        <tr>
                            <td>${order.orderCode}</td>
                            <td>${order.userName}</td>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                            <td>${order.formattedAmount}</td>
                            <td>${order.paymentMethodDisplay}</td>
                            <td class="product-cell">${order.productSummary}</td>
                            <td>${order.fullAddress}</td>
                            <td>${order.shippingProvider}</td>
                            <td>
                                <button class="confirm-btn" data-order-id="${order.id}">Xác nhận</button>
                                <button class="cancel-btn" data-order-id="${order.id}">Hủy</button>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Pagination -->
                    <tr class="pagination-row">
                        <td colspan="10">
                            <div class="pagination" id="tablePagination">
                                <button class="page-btn confirm-page" data-page="1">1</button>
                                <button class="page-btn confirm-page" data-page="2">2</button>
                                <button class="page-btn confirm-page" data-page="3">3</button>
                                <button class="page-btn confirm-page" data-page="4">4</button>
                            </div>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>

            <div class="cancel-popup" style="display:none;">
                <div class="popup-box">
                    <h3>Lý do hủy đơn</h3>
                    <textarea placeholder="Nhập lý do..." rows="3"></textarea>
                    <div class="popup-actions">
                        <button class="close-popup">Đóng</button>
                        <button class="confirm-cancel">Xác nhận hủy</button>
                    </div>
                </div>
            </div>

        </div>


        <!--        TAB CHỜ LẤY HÀNG-->
        <!-- ========== TAB 2: CHỜ LẤY HÀNG ========== -->
        <div class="tab-content" id="tab-pickup" style="display:none;">
            <!-- Thanh tìm kiếm -->
            <div class="order-controls">
                <div class="search-box">
                    <input type="text" class="search-input" placeholder="Tìm kiếm theo mã đơn hoặc tên khách hàng...">
                    <i class="fas fa-magnifying-glass"></i>
                </div>
            </div>

            <!-- Bảng đơn hàng -->
            <div class="table-wrapper">
                <table class="order-table">
                    <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Đơn vị vận chuyển</th>
                        <th>Địa chỉ giao hàng</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="pickupTableBody">

                    <c:forEach items="${ordersByStatus['AwaitingPickup']}" var="order">
                        <tr>
                            <td>${order.orderCode}</td>
                            <td>${order.userName}</td>
                            <td>${order.formattedAmount}</td>
                            <td>${order.shippingProvider}</td>
                            <td>${order.shippingAddress}</td>
                            <td>
                                <button class="ship-confirm-btn" data-order-id="${order.id}">
                                    Xác nhận đã giao cho ĐVVC
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Pagination -->
                    <tr class="pagination-row-pickup">
                        <td colspan="10">
                            <div class="pagination" id="pickupPagination">
                                <button class="page-btn pickup-page" data-page="1">1</button>
                                <button class="page-btn pickup-page" data-page="2">2</button>
                                <button class="page-btn pickup-page" data-page="3">3</button>
                                <button class="page-btn pickup-page" data-page="4">4</button>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>


        <!-- ========== TAB 3: ĐANG GIAO ========== -->
        <div class="tab-content" id="tab-delivering" style="display:none;">

            <!-- Thanh tìm kiếm -->
            <div class="order-controls delivering-controls">
                <div class="search-box">
                    <input type="text" id="deliverSearch" class="search-input"
                           placeholder="Tìm kiếm theo mã đơn hoặc tên khách hàng...">
                    <i class="fas fa-magnifying-glass"></i>
                </div>
            </div>

            <!-- Bảng đơn hàng -->
            <div class="table-wrapper">
                <table class="order-table">
                    <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Đơn vị vận chuyển</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="deliverTableBody">
                    <c:forEach items="${ordersByStatus['Shipping']}" var="order">
                        <tr>
                            <td>${order.orderCode}</td>
                            <td>${order.userName}</td>
                            <td>${order.shippingProvider}</td>
                            <td class="action-cell">
                                <button class="btn-de-detail" data-order-id="${order.id}">
                                    Xem chi tiết đơn
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Pagination -->
                    <tr class="pagination-row-delivering">
                        <td colspan="10">
                            <div class="pagination" id="deliveringPagination">
                                <button class="page-btn delivering-page" data-page="1">1</button>
                                <button class="page-btn delivering-page" data-page="2">2</button>
                                <button class="page-btn delivering-page" data-page="3">3</button>
                                <button class="page-btn delivering-page" data-page="4">4</button>
                            </div>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>

        <!-- ========== TAB 4: ĐÃ GIAO ========== -->
        <div class="tab-content" id="tab-delivered" style="display:none;">

            <!-- Thanh tìm kiếm -->
            <div class="order-controls delivered-controls">
                <div class="search-box">
                    <input type="text" id="deliveredSearch" class="search-input"
                           placeholder="Tìm kiếm theo mã đơn hoặc tên khách hàng...">
                    <i class="fas fa-magnifying-glass"></i>
                </div>
            </div>

            <!-- Bảng đơn hàng -->
            <div class="table-wrapper">
                <table class="order-table">
                    <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Ngày giao thành công</th>
                        <th>Tổng tiền</th>
                        <th>Phương thức thanh toán</th>
                        <th>Mã giao dịch</th>
                        <th>Đánh giá</th>
                    </tr>
                    </thead>

                    <tbody id="deliveredTableBody">
                    <c:forEach items="${ordersByStatus['Completed']}" var="order">
                        <tr>
                            <td>${order.orderCode}</td>
                            <td>${order.userName}</td>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                            <td>${order.formattedAmount}</td>
                            <td>${order.paymentMethodDisplay}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty order.transactionId}">
                                        ${order.transactionId}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="stars">
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-regular fa-star-half-stroke"></i>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Phân trang -->
                    <tr class="pagination-row-delivered">
                        <td colspan="10">
                            <div class="pagination" id="deliveredPagination">
                                <button class="page-btn delivered-page" data-page="1">1</button>
                                <button class="page-btn delivered-page" data-page="2">2</button>
                                <button class="page-btn delivered-page" data-page="3">3</button>
                                <button class="page-btn delivered-page" data-page="4">4</button>
                            </div>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>


        <!-- ========== TAB 5: TRẢ HÀNG/ HOAN TIEN ========== -->
        <div class="tab-content" id="tab-return" style="display:none;">

            <!-- Thanh tìm kiếm -->
            <div class="order-controls return-controls">
                <div class="search-box">
                    <input type="text" id="returnSearch" class="search-input"
                           placeholder="Tìm kiếm theo mã đơn hoặc tên khách hàng...">
                    <i class="fas fa-magnifying-glass"></i>
                </div>
            </div>

            <!-- Bảng đơn hàng -->
            <div class="table-wrapper">
                <table class="order-table">
                    <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Lý do hoàn trả</th>
                        <th>Tình trạng xử lý</th>
                        <th>Chi tiết</th>
                        <th></th>
                    </tr>
                    </thead>

                    <tbody id="returnTableBody">

                    <!-- Ví dụ đơn đang xem xét -->
                    <tr data-status="pending">
                        <td>DH00210</td>
                        <td>Phạm Ngọc Mai</td>
                        <td>Bìa truyện bị rách</td>

                        <!-- Trạng thái -->
                        <td>
                            <span class="status yellow">Đang xem xét</span>
                        </td>

                        <!-- Nút Xem chi tiết -->
                        <td>
                            <button class="btn-detail">Xem</button>
                        </td>

                        <!-- Nút Xác nhận hoàn tiền -->
                        <td class="action-buttons">
                            <button class="btn-refund" onclick="confirmRefund(this)">Xác nhận hoàn tiền</button>
                            <button class="btn-reject" onclick="openRejectPopup(this)">Từ chối</button>
                        </td>
                    </tr>

                    <!-- Ví dụ đơn đã hoàn -->
                    <tr>
                        <td>DH00211</td>
                        <td>Nguyễn Quang Hải</td>
                        <td>Giao nhầm sản phẩm</td>

                        <td>
                            <span class="status green">Đã hoàn tiền</span>
                        </td>

                        <td>
                            <button class="btn-detail">Xem</button>
                        </td>

                        <td>
                            <!-- Nút không xuất hiện -->
                        </td>
                    </tr>

                    <!-- Ví dụ đơn từ chối -->
                    <tr>
                        <td>DH00212</td>
                        <td>Nguyễn Văn Lý</td>
                        <td>Không thích nữa</td>

                        <td>
                            <span class="status red">Đã từ chối: Không đủ điều kiện</span>
                        </td>

                        <td>
                            <button class="btn-detail">Xem</button>
                        </td>

                        <td>
                            <!-- Nút không xuất hiện -->
                        </td>
                    </tr>

                    <!-- Phân trang -->
                    <tr class="pagination-row-return">
                        <td colspan="10">
                            <div class="pagination" id="returnPagination">
                                <button class="page-btn return-page" data-page="1">1</button>
                                <button class="page-btn return-page" data-page="2">2</button>
                                <button class="page-btn return-page" data-page="3">3</button>
                            </div>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>

        <!-- POPUP TỪ CHỐI HOÀN TIỀN -->
        <!-- POPUP TỪ CHỐI HOÀN TIỀN -->
        <div class="popup-desk-overlay" id="rejectPopup">
            <div class="popup-desk-box">
                <h3>Từ chối yêu cầu hoàn tiền</h3>

                <div class="popup-desk-content">
                    <p><strong>Mã đơn:</strong> <span id="rejectOrderId"></span></p>
                    <p><strong>Khách hàng:</strong> <span id="rejectCustomer"></span></p>

                    <label>Lý do từ chối <span>*</span></label>
                    <textarea id="rejectReason"
                              placeholder="Nhập lý do chi tiết để gửi thông báo cho khách hàng..."></textarea>
                </div>

                <div class="popup-desk-actions">
                    <button type="button" class="btn-cancel"
                            onclick="document.getElementById('rejectPopup').style.display='none'">Hủy
                    </button>
                    <button type="button" class="btn-save" onclick="confirmReject()">Xác nhận từ chối</button>
                </div>
            </div>
        </div>

        <div class="return-popup" id="returnPopup">
            <div class="popup-header">
                <h3>Chi tiết đơn hoàn</h3>
                <span class="popup-close-btn" id="closePopup">×</span>
            </div>

            <div class="popup-content">
                <div class="popup-row">
                    <span class="label">Sản phẩm:</span>
                    <span class="value">Thám tử lừng danh Conan tập 156</span>
                </div>

                <div class="popup-row">
                    <span class="label">Số lượng:</span>
                    <span class="value">1</span>
                </div>

                <div class="popup-row">
                    <span class="label">Lý do hoàn:</span>
                    <span class="value">Sách bị rách</span>
                </div>

                <div class="popup-row">
                    <span class="label">Minh chứng:</span>
                    <span class="value"><a href="#" class="proof-link">Xem ảnh / video</a></span>
                </div>

                <div class="popup-row">
                    <span class="label">Số tiền hoàn:</span>
                    <span class="value">24.500đ</span>
                </div>

                <div class="popup-row">
                    <span class="label">Ngày yêu cầu hoàn trả:</span>
                    <span class="value">7/11/2025</span>
                </div>
            </div>

            <div class="popup-footer">
                <button class="popup-close" id="closePopupBtn">Đóng</button>
            </div>
        </div>

        <!-- ========== TAB 6: DON BI HUY ========== -->
        <div class="tab-content" id="tab-cancelled" style="display:none;">

            <!-- Thanh tìm kiếm -->
            <div class="order-controls cancelled-controls">
                <div class="search-box">
                    <input type="text" id="cancelledSearch" class="search-input"
                           placeholder="Tìm kiếm theo mã đơn hoặc tên khách hàng...">
                    <i class="fas fa-magnifying-glass"></i>
                </div>
            </div>

            <!-- Bảng đơn hàng -->
            <div class="table-wrapper">
                <table class="order-table">
                    <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Lý do hủy</th>
                        <th>Người hủy</th>
                        <th>Ngày hủy</th>
                    </tr>
                    </thead>

                    <tbody id="cancelledTableBody">

                    <!-- DỮ LIỆU MẪU -->
                    <tr>
                        <td>DH00901</td>
                        <td>Trần Minh Hào</td>
                        <td>Đổi ý</td>
                        <td>Khách hàng</td>
                        <td>05/11/2025</td>
                    </tr>

                    <tr>
                        <td>DH00902</td>
                        <td>Ngô Thị Hạnh</td>
                        <td>Sản phẩm giao chậm</td>
                        <td>Khách hàng</td>
                        <td>04/11/2025</td>
                    </tr>

                    <tr>
                        <td>DH00903</td>
                        <td>Bùi Tuấn Khang</td>
                        <td>Không liên hệ được khách</td>
                        <td>Admin</td>
                        <td>03/11/2025</td>
                    </tr>

                    <!-- Phân trang -->
                    <tr class="pagination-row-cancelled">
                        <td colspan="10">
                            <div class="pagination" id="cancelledPagination">
                                <button class="page-btn cancelled-page" data-page="1">1</button>
                                <button class="page-btn cancelled-page" data-page="2">2</button>
                                <button class="page-btn cancelled-page" data-page="3">3</button>
                                <button class="page-btn cancelled-page" data-page="4">4</button>
                            </div>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <!-- ====================== POPUP CHI TIẾT ĐƠN HÀNG ====================== -->
    <div class="order-detail-popup" id="popup-DH00201" style="display:none;">
        <div class="popup-content">
            <div class="popup-header">
                <h3>Chi tiết đơn hàng</h3>
                <button class="close-popup">&times;</button>
            </div>
            <div class="popup-body">
                <div class="info-row"><span class="label">Mã đơn hàng:</span><span class="value">DH00201</span></div>
                <div class="info-row"><span class="label">Khách hàng:</span><span class="value">Nguyễn Minh Khôi</span>
                </div>
                <div class="info-row"><span class="label">Đơn vị vận chuyển:</span><span class="value">Giao nhanh</span>
                </div>
                <div class="info-row">
                    <span class="label">Trạng thái giao hàng:</span>
                    <span class="value status"><span class="status-text">Đang giao</span><span
                            class="status-icon"></span></span>
                </div>
                <div class="info-row timeline">
                    <div class="step done">
                        <div class="circle">1</div>
                        <div class="line"></div>
                        <p>Đã xác nhận</p></div>
                    <div class="step active">
                        <div class="circle">2</div>
                        <div class="line"></div>
                        <p>Đang giao</p></div>
                    <div class="step">
                        <div class="circle">3</div>
                        <p>Hoàn thành</p></div>
                </div>
            </div>
            <div class="popup-footer">
                <button class="btn-close">Đóng</button>
            </div>
        </div>
    </div>


</div>


<!--xu li chuyen tab-->

<!--khi nhan huy don => hiện form dien-->
<script>
    document.querySelectorAll(".cancel-btn").forEach(btn => {
        btn.addEventListener("click", () => {
            document.querySelector(".cancel-popup").style.display = "flex";
        });
    });
    document.querySelector(".close-popup").addEventListener("click", () => {
        document.querySelector(".cancel-popup").style.display = "none";
    });
</script>

<!--Chuyển trang của tab CHỜ XÁC NHẬN-->
<script>
    const ROWS_PER_PAGE = 5;
    const tbody = document.getElementById('confirmTableBody');
    const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row'));
    const pageButtons = document.querySelectorAll('.confirm-page');

    function showPage(page) {
        const start = (page - 1) * ROWS_PER_PAGE;
        const end = start + ROWS_PER_PAGE;

        rows.forEach((r, idx) => {
            r.style.display = (idx >= start && idx < end) ? "" : "none";
        });

        pageButtons.forEach(btn => btn.classList.remove('active'));
        document.querySelector(`.confirm-page[data-page="${page}"]`)?.classList.add('active');
    }

    pageButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            showPage(Number(btn.dataset.page));
        });
    });

    showPage(1);


</script>

<script>
    (function () {
        const searchInput = document.getElementById('pendingSearch');
        const tbody = document.getElementById('confirmTableBody');

        // Lấy tất cả row trừ dòng phân trang
        const allRows = Array.from(tbody.querySelectorAll('tr'))
            .filter(r => !r.classList.contains('pagination-row'));

        searchInput.addEventListener('input', function () {
            const keyword = this.value.toLowerCase().trim();

            let visibleRows = [];

            allRows.forEach(row => {
                const orderCode = row.cells[0].textContent.toLowerCase();
                const customerName = row.cells[1].textContent.toLowerCase();

                const match =
                    orderCode.includes(keyword) ||
                    customerName.includes(keyword);

                row.style.display = match ? '' : 'none';

                if (match) visibleRows.push(row);
            });

            // Sau khi search → reset phân trang về trang 1
            resetPaginationAfterSearch(visibleRows);
        });

        function resetPaginationAfterSearch(rows) {
            const ROWS_PER_PAGE = 5;
            rows.forEach((row, index) => {
                row.style.display = index < ROWS_PER_PAGE ? '' : 'none';
            });

            document.querySelectorAll('.confirm-page')
                .forEach(btn => btn.classList.remove('active'));

            document.querySelector('.confirm-page[data-page="1"]')
                ?.classList.add('active');
        }
    })();
</script>



<!--TAB CHỜ LẤY HÀNG-->
<script>

    (function () {
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('pickupTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row-pickup'));
        const pageButtons = document.querySelectorAll('.pickup-page');

        function showPage(page) {
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => {
                r.style.display = (idx >= start && idx < end) ? "" : "none";
            });

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.pickup-page[data-page="${page}"]`)?.classList.add('active');
        }

        pageButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                showPage(Number(btn.dataset.page));
            });
        });

        showPage(1);

    })();

</script>


<!--TAB ĐANG GIAO-->
<script>
    (function () {
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('deliverTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row-delivering'));
        const pageButtons = document.querySelectorAll('.delivering-page');

        function showPage(page) {
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => {
                r.style.display = (idx >= start && idx < end) ? "" : "none";
            });

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.delivering-page[data-page="${page}"]`)?.classList.add('active');
        }

        pageButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                showPage(Number(btn.dataset.page));
            });
        });

        showPage(1);

    })();
</script>

<!--POPUP XEM CHI TIET DON O TAB DANG GIAO-->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const overlay = document.getElementById('popupOverlay');

        // MỞ POPUP
        document.querySelectorAll('.btn-de-detail').forEach(btn => {
            btn.addEventListener('click', function () {
                const targetId = this.getAttribute('data-target');
                const popup = document.getElementById(targetId);
                if (popup) {
                    popup.style.display = 'block';
                    overlay.style.display = 'block';
                    document.body.style.overflow = 'hidden';   // chặn scroll
                }
            });
        });

        // ĐÓNG POPUP
        function closeAllPopups() {
            document.querySelectorAll('.order-detail-popup').forEach(p => p.style.display = 'none');
            overlay.style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Nút X, nút Đóng, overlay
        document.querySelectorAll('.close-popup, .btn-close').forEach(el => {
            el.addEventListener('click', closeAllPopups);
        });
        overlay.addEventListener('click', closeAllPopups);
    });
</script>


<!--TAB ĐÃ GIAO-->
<script>
    (function () {
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('deliveredTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row-delivered'));
        const pageButtons = document.querySelectorAll('.delivered-page');

        function showPage(page) {
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => {
                r.style.display = (idx >= start && idx < end) ? "" : "none";
            });

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.delivered-page[data-page="${page}"]`)?.classList.add('active');
        }

        pageButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                showPage(Number(btn.dataset.page));
            });
        });

        showPage(1);
    })();
</script>


<!--CHUỂN TRANG GIŨA CÁC TAB-->
<script>

    const tabs = document.querySelectorAll(".tab-item");
    const tabContents = document.querySelectorAll(".tab-content");

    // Hiển thị tab theo index: 0 = chờ xác nhận, 1 = chờ lấy hàng, ...
    function showTab(index) {
        // Xóa active
        tabs.forEach(t => t.classList.remove("active"));
        if (tabs[index]) tabs[index].classList.add("active");

        // Ẩn mọi nội dung, chỉ show cái index
        tabContents.forEach((c, i) => {
            if (i === index) c.style.display = ""; // show (mặc định)
            else c.style.display = "none";
        });
    }

    // Gắn sự kiện click cho tab
    tabs.forEach((tab, index) => {
        tab.addEventListener("click", () => {
            showTab(index);
            // Nếu cần focus vào search input tương ứng:
            const targetContent = tabContents[index];
            const input = targetContent ? targetContent.querySelector('.search-input') : null;
            if (input) input.focus();
        });
    });

    // Khởi tạo: show tab đầu (Chờ xác nhận)
    showTab(0);

</script>

<!--TRA TIEN/ HOAN TIEN-->
<script>

    /* --- POPUP CHI TIẾT --- */
    document.addEventListener("click", e => {
        if (e.target.classList.contains("btn-detail")) {
            document.getElementById("returnPopup").style.display = "block";
        }
    });
    document.getElementById("closePopup").onclick = () => {
        document.getElementById("returnPopup").style.display = "none";
    };

    document.getElementById("closePopupBtn").onclick = () => {
        document.getElementById("returnPopup").style.display = "none";
    };


    /* --- XÁC NHẬN HOÀN TIỀN --- */
    document.addEventListener("click", e => {
        if (e.target.classList.contains("btn-refund")) {
            const row = e.target.closest("tr");
            if (confirm("Xác nhận hoàn tiền cho đơn này?")) {
                row.querySelector(".status").textContent = "Đã hoàn tiền";
                row.querySelector(".status").classList.remove("yellow");
                row.querySelector(".status").classList.add("green");
                e.target.remove();
            }
        }
    });

    let currentRejectRow = null;

    window.openRejectPopup = function (btn) {
        currentRejectRow = btn.closest('tr');
        const orderId = currentRejectRow.cells[0].textContent;
        const customer = currentRejectRow.cells[1].textContent;

        document.getElementById('rejectOrderId').textContent = orderId;
        document.getElementById('rejectCustomer').textContent = customer;
        document.getElementById('rejectReason').value = '';

        document.getElementById('rejectPopup').style.display = 'flex';
    };

    window.confirmReject = function () {
        const reason = document.getElementById('rejectReason').value.trim();
        if (!reason) {
            alert('Vui lòng nhập lý do từ chối!');
            return;
        }

        if (currentRejectRow) {
            currentRejectRow.dataset.status = 'rejected';
            currentRejectRow.cells[3].innerHTML = '<span class="status red">Đã từ chối</span>';
            currentRejectRow.cells[5].innerHTML = `<span class="rejected-note">Đã từ chối: ${reason}</span>`;
        }

        document.getElementById('rejectPopup').style.display = 'none';
        alert('Đã từ chối yêu cầu hoàn tiền!');
    };

    window.confirmRefund = function (btn) {
        if (!confirm('Xác nhận hoàn tiền cho đơn hàng này?')) return;

        const row = btn.closest('tr');
        row.dataset.status = 'refunded';
        row.cells[3].innerHTML = '<span class="status green">Đã hoàn tiền</span>';
        row.cells[5].innerHTML = '-';
        alert('Đã hoàn tiền thành công!');
    };


    /* --- PHÂN TRANG --- */
    (function () {
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('returnTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row-return'));
        const pageButtons = document.querySelectorAll('.return-page');

        function showPage(page) {
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => r.style.display = (idx >= start && idx < end) ? "" : "none");

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.return-page[data-page="${page}"]`)?.classList.add('active');
        }

        pageButtons.forEach(btn => btn.addEventListener("click", () => showPage(Number(btn.dataset.page))));
        showPage(1);
    })();

</script>

<!--DON BI HUY-->
<script>
    (function () {
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('cancelledTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row-cancelled'));
        const pageButtons = document.querySelectorAll('.cancelled-page');

        function showPage(page) {
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => {
                r.style.display = (idx >= start && idx < end) ? "" : "none";
            });

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.cancelled-page[data-page="${page}"]`)?.classList.add('active');
        }

        pageButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                showPage(Number(btn.dataset.page));
            });
        });

        showPage(1);
    })();


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

<%--TAB CHO XAC NHAN--%>
<%--TAB CHO XAC NHAN--%>
<script>
    // Xác nhận đơn hàng
    document.querySelectorAll('.confirm-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const orderId = this.dataset.orderId;

            if (confirm('Xác nhận đơn hàng này?')) {
                fetch(BASE_URL + '/admin/orders', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=confirm&orderId=' + orderId
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert(data.message);
                            location.reload();
                        } else {
                            alert('Lỗi: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Lỗi kết nối: ' + error);
                    });
            }
        });
    });

    // Hủy đơn hàng
    document.querySelectorAll('.cancel-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const orderId = this.dataset.orderId;
            document.querySelector('.cancel-popup').style.display = 'flex';
            document.querySelector('.cancel-popup').dataset.orderId = orderId;
        });
    });

    // Xác nhận hủy
    document.querySelector('.confirm-cancel').addEventListener('click', function () {
        const orderId = document.querySelector('.cancel-popup').dataset.orderId;
        const reason = document.querySelector('.cancel-popup textarea').value;

        if (!reason.trim()) {
            alert('Vui lòng nhập lý do hủy');
            return;
        }

        fetch(BASE_URL + '/admin/orders', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=cancel&orderId=' + orderId + '&reason=' + encodeURIComponent(reason)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    location.reload();
                } else {
                    alert('Lỗi: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Lỗi kết nối: ' + error);
            });
    });
</script>

<script>
    // XÁC NHẬN TẤT CẢ ĐơN HÀNG TRONG TAB CHỜ XÁC NHẬN
    document.querySelector('.confirm-all-btn').addEventListener('click', function() {

        if (!confirm('Bạn có chắc muốn xác nhận TẤT CẢ đơn hàng đang chờ xác nhận?')) {
            return;
        }

        // Hiển thị loading
        this.disabled = true;
        this.textContent = 'Đang xử lý...';

        const btn = this; // Lưu reference để dùng trong callback

        // Gửi request xác nhận tất cả
        fetch(BASE_URL + '/admin/orders', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=confirmAll'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message || 'Đã xác nhận thành công tất cả đơn hàng!');
                    location.reload();
                } else {
                    alert('Lỗi: ' + (data.message || data.error));
                    btn.disabled = false;
                    btn.textContent = 'Xác nhận tất cả';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Lỗi kết nối: ' + error);
                btn.disabled = false;
                btn.textContent = 'Xác nhận tất cả';
            });
    });
</script>

<%--TAB CHO LAY HANG--%>
<script>
    // TAB CHỜ LẤY HÀNG - Xác nhận đã giao cho ĐVVC
    document.querySelectorAll('.ship-confirm-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const orderId = this.dataset.orderId;

            if (confirm('Xác nhận đã giao cho đơn vị vận chuyển?')) {
                fetch(`${BASE_URL}/admin/orders`, {  // ✅ DÙNG BASE_URL
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=confirmShipped&orderId=${orderId}`
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert(data.message);
                            location.reload();
                        } else {
                            alert('Lỗi: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Lỗi kết nối: ' + error);
                    });
            }
        });
    });
</script>

</body>
</html>