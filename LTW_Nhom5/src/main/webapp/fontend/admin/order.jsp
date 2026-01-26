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
                    <input type="text" id="pendingSearch" class="search-input"
                           placeholder="Tìm kiếm theo mã đơn hoặc tên khách hàng..." class="search-input">
                    <i class="fas fa-magnifying-glass"></i>
                </div>
                <button class="confirm-all-btn">Xác nhận tất cả</button>
            </div>

            <!-- Bảng đơn hàng -->
            <div class="table-scroll-wrapper">
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

                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
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
                    <input type="text" id="pickupSearch" class="search-input"
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

                            </div>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>

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
                        <th>Ngày đặt</th>
                        <th>Lý do hủy</th>
                        <th>Người hủy</th>
                        <th>Ngày hủy</th>
                    </tr>
                    </thead>

                    <tbody id="cancelledTableBody">

                    <c:choose>
                        <c:when test="${not empty ordersByStatus['Cancelled']}">
                            <c:forEach items="${ordersByStatus['Cancelled']}" var="order">
                                <tr>
                                    <td>${order.orderCode}</td>
                                    <td>${order.userName}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                            <%-- LÝ DO HỦY TỪ ORDER_HISTORY --%>
                                        <c:choose>
                                            <c:when test="${not empty order.cancellationReason}">
                                                ${order.cancellationReason}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #999; font-style: italic;">Không có lý do</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                            <%-- NGƯỜI HỦY (ADMIN/CUSTOMER) --%>
                                        <c:choose>
                                            <c:when test="${not empty order.cancelledBy}">
                                                <c:choose>
                                                    <c:when test="${order.cancelledBy eq 'Admin'}">
                                                        <span style="color: #dc2626; font-weight: 500;">
                                                            <i class="fas fa-user-shield"></i> Admin
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${order.cancelledBy eq 'Customer'}">
                                                        <span style="color: #2563eb; font-weight: 500;">
                                                            <i class="fas fa-user"></i> Khách hàng
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${order.cancelledBy}
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #999;">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td><fmt:formatDate value="${order.cancelledAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr class="no-result-message">
                                <td colspan="6" style="text-align: center; padding: 30px; color: #999;">
                                    <i class="fas fa-inbox"
                                       style="font-size: 48px; margin-bottom: 10px; display: block;"></i>
                                    Chưa có đơn hàng nào bị hủy
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>


                    <!-- Phân trang -->
                    <tr class="pagination-row-cancelled">
                        <td colspan="10">
                            <div class="pagination" id="cancelledPagination">

                            </div>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>

    </div>


</div>

<script src="${pageContext.request.contextPath}/js/orderManagement.js"></script>
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

<!--CHUỂN TRANG GIŨA CÁC TAB-->
<script>
    const tabs = document.querySelectorAll(".tab-item");
    const tabContents = document.querySelectorAll(".tab-content");

    function showTab(index, saveState = true) {
        tabs.forEach(t => t.classList.remove("active"));
        if (tabs[index]) tabs[index].classList.add("active");

        tabContents.forEach((c, i) => {
            c.style.display = (i === index) ? "" : "none";
        });

        // LƯU TAB HIỆN TẠI VÀO LOCALSTORAGE
        if (saveState && typeof saveCurrentTab === 'function') {
            saveCurrentTab(index);
        }
    }

    // Gắn sự kiện click cho tab
    tabs.forEach((tab, index) => {
        tab.addEventListener("click", () => {
            showTab(index, true); // Lưu state khi user click
        });
    });

    // KHÔI PHỤC TAB ĐÃ LƯU HOẶC MẶC ĐỊNH TAB 0
    document.addEventListener('DOMContentLoaded', function () {
        let tabToShow = 0; // Mặc định tab đầu tiên

        // Kiểm tra có tab đã lưu không
        if (typeof getSavedTab === 'function') {
            const savedTab = getSavedTab();
            if (savedTab !== null && savedTab >= 0 && savedTab < tabs.length) {
                tabToShow = savedTab;
                console.log('📌 Khôi phục tab đã lưu:', tabToShow);
            }
        }

        // Hiển thị tab (không lưu lại để tránh loop)
        showTab(tabToShow, false);
    });
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

</script>

<!--DON BI HUY-->

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
    let currentCancelOrderId = null;

    document.querySelectorAll('.cancel-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            currentCancelOrderId = this.dataset.orderId;
            document.querySelector('.cancel-popup').style.display = 'flex';
            document.querySelector('.cancel-popup textarea').value = ''; // Reset textarea
        });
    });

    // Đóng popup
    document.querySelector('.close-popup').addEventListener('click', function () {
        document.querySelector('.cancel-popup').style.display = 'none';
        currentCancelOrderId = null;
    });

    // Xác nhận hủy - GỬI LÝ DO LÊN SERVER
    document.querySelector('.confirm-cancel').addEventListener('click', function () {
        if (!currentCancelOrderId) {
            alert('Không xác định được đơn hàng cần hủy');
            return;
        }

        const reason = document.querySelector('.cancel-popup textarea').value.trim();

        if (!reason) {
            alert('Vui lòng nhập lý do hủy');
            return;
        }

        // Gửi request với lý do hủy
        fetch(BASE_URL + '/admin/orders', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=cancel&orderId=' + currentCancelOrderId + '&reason=' + encodeURIComponent(reason)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    document.querySelector('.cancel-popup').style.display = 'none';
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
    document.querySelector('.confirm-all-btn').addEventListener('click', function () {

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

<script>
    // Thêm effect khi scroll
    document.addEventListener('DOMContentLoaded', function () {
        const scrollWrapper = document.querySelector('.table-scroll-wrapper');
        if (scrollWrapper) {
            scrollWrapper.addEventListener('scroll', function () {
                if (this.scrollLeft > 0) {
                    this.classList.add('scrolled');
                } else {
                    this.classList.remove('scrolled');
                }
            });
        }
    });

    // ============================================
    // PASTE ĐOẠN NÀY VÀO CONSOLE ĐỂ DEBUG
    // ============================================

    console.log('🔍 KIỂM TRA SCROLL PANE...');

    const wrapper = document.querySelector('#tab-pending .table-scroll-wrapper');
    const table = document.querySelector('#tab-pending .order-table');

    if (!wrapper) {
        console.error('❌ Không tìm thấy .table-scroll-wrapper');
    } else {
        console.log('✅ Tìm thấy wrapper');

        // Kiểm tra kích thước
        console.log('📏 KÍCH THƯỚC:');
        console.log('  Wrapper clientWidth:', wrapper.clientWidth + 'px');
        console.log('  Wrapper scrollWidth:', wrapper.scrollWidth + 'px');
        console.log('  Table offsetWidth:', table.offsetWidth + 'px');

        // Kiểm tra có overflow không
        const hasOverflow = wrapper.scrollWidth > wrapper.clientWidth;
        console.log('📊 CÓ OVERFLOW:', hasOverflow ? '✅ CÓ' : '❌ KHÔNG');

        if (!hasOverflow) {
            console.warn('⚠️ TABLE CHƯA ĐỦ RỘNG ĐỂ SCROLL!');
            console.log('💡 Table cần rộng hơn:', wrapper.clientWidth + 'px');
            console.log('💡 Table hiện tại:', table.offsetWidth + 'px');
        }

        // Kiểm tra CSS
        const wrapperStyle = window.getComputedStyle(wrapper);


        const tableStyle = window.getComputedStyle(table);


        // Đếm số cột
        const columns = table.querySelectorAll('thead th').length;


        // Tính tổng width các cột
        let totalWidth = 0;
        table.querySelectorAll('thead th').forEach((th, i) => {
            const w = th.offsetWidth;
            totalWidth += w;
            console.log(`  Cột ${i + 1}: ${w}px - ${th.textContent.trim()}`);
        });


        // GỢI Ý FIX
        console.log('');
        if (!hasOverflow) {
            const suggestedWidth = wrapper.clientWidth + 500;
        }
    }
</script>
</body>
</html>