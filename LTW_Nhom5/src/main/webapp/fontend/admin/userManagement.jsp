<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleUserMan.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/adminHeader.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<div class="container">
    <!-- Sidebar -->
    <jsp:include page="/fontend/admin/ASide.jsp"/>


    <div class="main-content">
        <%@ include file="HeaderAdmin.jsp" %>
        <h2 class="page-title">Quản lý người dùng</h2>

        <div class="user-management">

            <!-- Search bar -->
            <div class="search-filter-container">
                <form method="get" action="${pageContext.request.contextPath}/admin/user-management" id="searchForm">
                    <div class="search-box">
                        <input type="text"
                               id="searchInput"
                               name="search"
                               placeholder="Tìm kiếm người mua..."
                               value="${param.search != null ? param.search : ''}">
                        <i class="fas fa-magnifying-glass"></i>
                    </div>

                    <select id="levelFilter" name="level" class="level-filter">
                        <option value="">Tất cả cấp độ</option>
                        <option value="Normal" ${param.level == 'Normal' ? 'selected' : ''}>Normal</option>
                        <option value="Silver" ${param.level == 'Silver' ? 'selected' : ''}>Silver</option>
                        <option value="Gold" ${param.level == 'Gold' ? 'selected' : ''}>Gold</option>
                        <option value="Platinum" ${param.level == 'Platinum' ? 'selected' : ''}>Platinum</option>
                    </select>
                </form>
            </div>


            <table id="userTable" class="user-table">
                <thead>
                <tr>
                    <th>Tên khách hàng</th>
                    <th>Email</th>
                    <th>Cấp thành viên</th>
                    <th>Tổng chi tiêu</th>
                    <th>Điểm xu</th>
                    <th></th>
                </tr>
                </thead>

                <tbody id="userTableBody">
                <c:choose>
                    <c:when test="${not empty users}">
                        <c:forEach var="user" items="${users}">
                            <tr data-user-id="${user.id}" class="${!user.isActive ? 'locked-row' : ''}">
                                <td>
                                        ${user.fullName != null ? user.fullName : 'Chưa cập nhật'}
                                    <c:if test="${!user.isActive}">
                                        <br><span class="locked-badge">🔒 Tài khoản đã bị khóa</span>
                                    </c:if>
                                </td>
                                <td>${user.email}</td>
                                <td>
            <span class="badge level-${user.membershipLevel != null ? user.membershipLevel : 'Normal'}">
                    ${user.membershipLevel != null ? user.membershipLevel : 'Normal'}
            </span>
                                </td>
                                <td>
                                    <c:set var="formattedSpent">
                                        <fmt:formatNumber value="${user.totalSpent != null ? user.totalSpent : 0}"
                                                          pattern="#,###"
                                                          groupingUsed="true"/>
                                    </c:set>
                                        ${fn:replace(formattedSpent, ',', '.')}đ
                                </td>
                                <td>${user.points} xu</td>
                                <td class="action-cell">
                                    <c:choose>
                                        <c:when test="${!user.isActive}">
                                            <!-- ✅ User đã bị khóa - KHÔNG hiển thị menu -->
                                            <span style="color: #999; font-size: 14px;">—</span>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- ✅ User bình thường - Hiển thị menu đầy đủ -->
                                            <div class="kebab-menu">
                                                <button class="kebab-btn">⋮</button>
                                                <div class="menu-dropdown">
                                                    <a href="#" class="menu-item view-detail"
                                                       data-id="${user.id}"
                                                       data-name="${user.fullName != null ? user.fullName : 'Chưa cập nhật'}"
                                                       data-email="${user.email}"
                                                       data-phone="${user.phone != null ? user.phone : 'Chưa cập nhật'}"
                                                       data-level="${user.membershipLevel != null ? user.membershipLevel : 'Normal'}"
                                                       data-spent="${user.totalSpent != null ? user.totalSpent : 0}"
                                                       data-points="${user.points}"
                                                       data-created-at="${user.createdAt}">
                                                        Xem chi tiết
                                                    </a>
                                                    <a href="#" class="menu-item upgrade-user"
                                                       data-id="${user.id}"
                                                       data-name="${user.fullName != null ? user.fullName : 'Chưa cập nhật'}"
                                                       data-current-level="${user.membershipLevel != null ? user.membershipLevel : 'Normal'}">
                                                        Nâng cấp
                                                    </a>
                                                    <a href="#" class="menu-item permanent-lock"
                                                       data-id="${user.id}"
                                                       data-name="${user.fullName != null ? user.fullName : 'Chưa cập nhật'}">
                                                        Khóa vĩnh viễn
                                                    </a>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 20px;">
                                Không tìm thấy người dùng nào
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>

                <!-- Phân trang -->
                <tr class="pagination-row">
                    <td colspan="10">
                        <div class="pagination" id="tablePagination">
                            <button class="page-btn user-page" data-page="1">1</button>
                            <button class="page-btn user-page" data-page="2">2</button>
                            <button class="page-btn user-page" data-page="3">3</button>
                        </div>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>

        <!-- Popup -->
        <div id="upgradePopup" class="popup-overlay">
            <div class="popup-box">
                <h3>Nâng cấp thành viên</h3>
                <input type="hidden" id="upgradeUserId" value="">
                <p id="popupUserName"></p>
                <select id="upgradeSelect">
                    <option value="Normal">Thường (0%)</option>
                    <option value="Silver">Bạc (5%)</option>
                    <option value="Gold">Vàng (10%)</option>
                    <option value="Platinum">Kim cương (15%)</option>
                </select>

                <div class="popup-actions">
                    <button id="upgradeConfirm">Xác nhận</button>
                    <button id="upgradeCancel">Hủy</button>
                </div>
            </div>
        </div>

        <!-- Popup Xem chi tiết - IMPROVED -->
        <div id="detailPopup" class="popup-overlay">
            <div class="popup-box">
                <!-- Header -->
                <div class="popup-header">
                    <h3>Thông tin khách hàng</h3>
                </div>

                <!-- Body -->
                <div class="popup-body">
                    <div class="info-row">
                <span class="info-label">
                    Họ tên:
                </span>
                        <span class="info-value" id="detailName"></span>
                    </div>

                    <div class="info-row">
                <span class="info-label">
                    </i>Email:
                </span>
                        <span class="info-value" id="detailEmail"></span>
                    </div>

                    <div class="info-row">
                <span class="info-label">
                    Số điện thoại:
                </span>
                        <span class="info-value" id="detailPhone">Chưa cập nhật</span>
                    </div>

                    <div class="info-row">
                <span class="info-label">
                    Cấp thành viên:
                </span>
                        <span class="info-value">
                    <span class="level-badge" id="detailLevelBadge"></span>
                </span>
                    </div>

                    <div class="info-row">
                <span class="info-label">
                    </i>Tổng chi tiêu:
                </span>
                        <span class="info-value" id="detailSpent" style="color: #28a745; font-weight: 600;"></span>
                    </div>

                    <div class="info-row">
                <span class="info-label">
                    Điểm tích lũy:
                </span>
                        <span class="info-value" id="detailPoints" style="color: #ffc107; font-weight: 600;"></span>
                    </div>

                    <div class="info-row">
                <span class="info-label">
                    </i>Ngày tham gia:
                </span>
                        <span class="info-value" id="detailCreatedAt">01/01/2024</span>
                    </div>
                </div>

                <!-- Footer -->
                <div class="popup-footer">
                    <button class="btn-close" onclick="document.getElementById('detailPopup').style.display='none'">
                        Đóng
                    </button>
                </div>
            </div>
        </div>

        <div id="lockPopup" class="popup-overlay">
            <div class="popup-box">
                <h3>Xác nhận khóa tài khoản</h3>
                <input type="hidden" id="lockUserId" value="">
                <div class="popup-message" id="lockMessage"></div>
                <div class="popup-actions">
                    <button class="btn-cancel" onclick="document.getElementById('lockPopup').style.display='none'">Hủy
                    </button>
                    <button class="btn-danger" id="confirmLock">Khóa vĩnh viễn</button>
                </div>
            </div>
        </div>
    </div>
</div>


<%--<script>--%>
<%--    // Tìm kiếm khi nhấn Enter--%>
<%--    document.getElementById('searchInput').addEventListener('keypress', function (e) {--%>
<%--        if (e.key === 'Enter') {--%>
<%--            e.preventDefault();--%>
<%--            document.getElementById('searchForm').submit();--%>
<%--        }--%>
<%--    });--%>

<%--    // Tìm kiếm khi click vào icon--%>
<%--    document.querySelector('.fa-magnifying-glass').addEventListener('click', function () {--%>
<%--        document.getElementById('searchForm').submit();--%>
<%--    });--%>

<%--    // Lọc theo level--%>
<%--    document.getElementById('levelFilter').addEventListener('change', function () {--%>
<%--        document.getElementById('searchForm').submit();--%>
<%--    });--%>


<%--    // Xem chi tiết--%>
<%--    document.querySelectorAll('.view-detail').forEach(item => {--%>
<%--        item.addEventListener('click', e => {--%>
<%--            e.preventDefault();--%>
<%--            e.stopPropagation();--%>

<%--            const name = item.dataset.name;--%>
<%--            const email = item.dataset.email;--%>
<%--            const phone = item.dataset.phone || 'Chưa cập nhật';--%>
<%--            const level = item.dataset.level;--%>
<%--            // Format số tiền--%>
<%--            const spent = parseFloat(item.dataset.spent) || 0;--%>
<%--            const spentFormatted = spent.toLocaleString('vi-VN') + 'đ';--%>
<%--            // Format điểm--%>
<%--            const points = parseInt(item.dataset.points) || 0;--%>
<%--            const pointsFormatted = points.toLocaleString('vi-VN') + ' xu';--%>

<%--            // Format ngày tháng--%>
<%--            let createdAt = 'Chưa có thông tin';--%>
<%--            if (item.dataset.createdAt && item.dataset.createdAt !== 'null') {--%>
<%--                try {--%>
<%--                    const date = new Date(item.dataset.createdAt);--%>
<%--                    createdAt = date.toLocaleDateString('vi-VN');--%>
<%--                } catch (e) {--%>
<%--                    createdAt = 'Chưa có thông tin';--%>
<%--                }--%>
<%--            }--%>


<%--            document.getElementById('detailName').textContent = name;--%>
<%--            document.getElementById('detailEmail').textContent = email;--%>
<%--            document.getElementById('detailPhone').textContent = phone;--%>
<%--            document.getElementById('detailSpent').textContent = spentFormatted;--%>
<%--            document.getElementById('detailPoints').textContent = pointsFormatted;--%>
<%--            document.getElementById('detailCreatedAt').textContent = createdAt;--%>

<%--            // Badge cấp độ--%>
<%--            const badge = document.getElementById('detailLevelBadge');--%>
<%--            badge.textContent = level;--%>
<%--            badge.className = 'level-badge level-' + level;--%>

<%--            // Đóng menu trước khi hiện popup--%>
<%--            document.querySelectorAll('.menu-dropdown').forEach(menu => {--%>
<%--                menu.classList.remove('show');--%>
<%--            });--%>

<%--            // Hiện popup--%>
<%--            document.getElementById('detailPopup').style.display = 'flex';--%>
<%--        });--%>
<%--    });--%>

<%--    // Nâng cấp - hiện popup--%>
<%--    document.querySelectorAll('.upgrade-user').forEach(item => {--%>
<%--        item.addEventListener('click', e => {--%>
<%--            e.preventDefault();--%>
<%--            e.stopPropagation();--%>

<%--            const userId = item.dataset.id;--%>
<%--            const userName = item.dataset.name;--%>
<%--            const currentLevel = item.dataset.currentLevel;--%>

<%--            document.getElementById('upgradeUserId').value = userId;--%>
<%--            document.getElementById('popupUserName').innerText = "Tên: " + userName;--%>
<%--            document.getElementById('upgradeSelect').value = currentLevel;--%>

<%--            // ✅ Đóng menu kebab trước khi hiện popup--%>
<%--            document.querySelectorAll('.menu-dropdown').forEach(menu => {--%>
<%--                menu.classList.remove('show');--%>
<%--            });--%>

<%--            document.getElementById('upgradePopup').style.display = 'flex';--%>
<%--        });--%>
<%--    });--%>

<%--    // Hủy nâng cấp--%>
<%--    document.getElementById('upgradeCancel').onclick = function () {--%>
<%--        document.getElementById('upgradePopup').style.display = 'none';--%>
<%--    };--%>


<%--    // Xác nhận nâng cấp--%>
<%--    document.getElementById('upgradeConfirm').addEventListener('click', function () {--%>
<%--        const userId = document.getElementById('upgradeUserId').value;--%>
<%--        const newLevel = document.getElementById('upgradeSelect').value;--%>

<%--        fetch('${pageContext.request.contextPath}/admin/user-management', {--%>
<%--            method: 'POST',--%>
<%--            headers: {--%>
<%--                'Content-Type': 'application/x-www-form-urlencoded',--%>
<%--            },--%>
<%--            body: 'action=upgrade&userId=' + userId + '&newLevel=' + newLevel--%>
<%--        })--%>
<%--            .then(response => response.json())--%>
<%--            .then(data => {--%>
<%--                if (data.status === 'success') {--%>
<%--                    alert(data.message);--%>
<%--                    location.reload();--%>
<%--                } else {--%>
<%--                    alert('Lỗi: ' + data.message);--%>
<%--                }--%>
<%--            })--%>
<%--            .catch(error => {--%>
<%--                console.error('Error:', error);--%>
<%--                alert('Có lỗi xảy ra khi nâng cấp');--%>
<%--            });--%>

<%--        document.getElementById('upgradePopup').style.display = 'none';--%>
<%--    });--%>

<%--    // Khóa vĩnh viễn - hiện popup--%>
<%--    document.querySelectorAll('.permanent-lock').forEach(item => {--%>
<%--        item.addEventListener('click', e => {--%>
<%--            e.preventDefault();--%>
<%--            e.stopPropagation();--%>

<%--            const userId = item.dataset.id;--%>
<%--            const userName = item.dataset.name;--%>

<%--            document.getElementById('lockUserId').value = userId;--%>
<%--            document.getElementById('lockMessage').textContent =--%>
<%--                `KHÓA VĨNH VIỄN tài khoản "${userName}"?\n\nHành động này KHÔNG THỂ HOÀN TÁC!`;--%>

<%--            // Đóng menu trước khi hiện popup--%>
<%--            document.querySelectorAll('.menu-dropdown').forEach(menu => {--%>
<%--                menu.classList.remove('show');--%>
<%--            });--%>
<%--            document.getElementById('lockPopup').style.display = 'flex';--%>
<%--        });--%>
<%--    });--%>

<%--    // Xác nhận khóa--%>
<%--    document.getElementById('confirmLock').addEventListener('click', function () {--%>
<%--        const userId = document.getElementById('lockUserId').value;--%>

<%--        fetch('${pageContext.request.contextPath}/admin/user-management', {--%>
<%--            method: 'POST',--%>
<%--            headers: {--%>
<%--                'Content-Type': 'application/x-www-form-urlencoded',--%>
<%--            },--%>
<%--            body: 'action=lock&userId=' + userId--%>
<%--        })--%>
<%--            .then(response => response.json())--%>
<%--            .then(data => {--%>
<%--                if (data.status === 'success') {--%>
<%--                    alert(data.message);--%>
<%--                    location.reload();--%>
<%--                } else {--%>
<%--                    alert('Lỗi: ' + data.message);--%>
<%--                }--%>
<%--            })--%>
<%--            .catch(error => {--%>
<%--                console.error('Error:', error);--%>
<%--                alert('Có lỗi xảy ra khi khóa tài khoản');--%>
<%--            });--%>

<%--        document.getElementById('lockPopup').style.display = 'none';--%>
<%--    });--%>


<%--    // Phân trang--%>
<%--    (function () {--%>
<%--        const ROWS_PER_PAGE = 10;--%>
<%--        const tbody = document.getElementById('userTableBody');--%>
<%--        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row') && r.cells.length > 1);--%>
<%--        const pageButtons = document.querySelectorAll('.user-page');--%>

<%--        function showPage(page) {--%>
<%--            const start = (page - 1) * ROWS_PER_PAGE;--%>
<%--            const end = start + ROWS_PER_PAGE;--%>

<%--            rows.forEach((r, idx) => {--%>
<%--                r.style.display = (idx >= start && idx < end) ? "" : "none";--%>
<%--            });--%>

<%--            pageButtons.forEach(btn => btn.classList.remove('active'));--%>
<%--            document.querySelector(`.user-page[data-page="${page}"]`)?.classList.add('active');--%>
<%--        }--%>

<%--        pageButtons.forEach(btn => {--%>
<%--            btn.addEventListener('click', () => {--%>
<%--                showPage(Number(btn.dataset.page));--%>
<%--            });--%>
<%--        });--%>

<%--        showPage(1);--%>
<%--    })();--%>

<%--    // Active sidebar--%>
<%--    document.addEventListener("DOMContentLoaded", function () {--%>
<%--        const current = window.location.pathname.split("/").pop();--%>
<%--        const links = document.querySelectorAll(".sidebar li a");--%>

<%--        links.forEach(link => {--%>
<%--            const linkPage = link.getAttribute("href");--%>
<%--            if (linkPage === current) {--%>
<%--                link.classList.add("active");--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>
<%--</script>--%>

<%--<script>--%>
<%--    document.addEventListener("DOMContentLoaded", function () {--%>
<%--        const current = window.location.pathname.split("/").pop();--%>
<%--        const links = document.querySelectorAll(".sidebar li a");--%>

<%--        links.forEach(link => {--%>
<%--            const linkPage = link.getAttribute("href");--%>

<%--            if (linkPage === current) {--%>
<%--                link.classList.add("active");--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>
<%--</script>--%>

<%--<script>--%>
<%--    // TỰ ĐỘNG CẬP NHẬT DỮ LIỆU SAU MỖI 30 GIÂY--%>
<%--    (function autoRefreshUserData() {--%>
<%--        setInterval(function() {--%>
<%--            // ✅ KIỂM TRA: Nếu có popup đang mở thì KHÔNG reload--%>
<%--            const hasOpenPopup = document.querySelector('.popup-overlay[style*="display: flex"]');--%>

<%--            if (hasOpenPopup) {--%>
<%--                console.log('Popup đang mở, bỏ qua auto-reload');--%>
<%--                return; // Không reload--%>
<%--            }--%>

<%--            // Lưu trạng thái tìm kiếm hiện tại--%>
<%--            const currentSearch = document.getElementById('searchInput').value;--%>
<%--            const currentLevel = document.getElementById('levelFilter').value;--%>

<%--            // Reload trang với params hiện tại--%>
<%--            let url = '${pageContext.request.contextPath}/admin/user-management';--%>
<%--            let params = [];--%>

<%--            if (currentSearch) params.push('search=' + encodeURIComponent(currentSearch));--%>
<%--            if (currentLevel) params.push('level=' + encodeURIComponent(currentLevel));--%>

<%--            if (params.length > 0) {--%>
<%--                url += '?' + params.join('&');--%>
<%--            }--%>

<%--            // Reload silent (không thông báo)--%>
<%--            window.location.href = url;--%>
<%--        }, 5000); // 30 giây = 30,000 ms--%>
<%--    })();--%>
<%--</script>--%>

<%--<script>--%>
<%--    // XỬ LÝ KEBAB MENU - FIXED HOÀN TOÀN--%>
<%--    document.addEventListener('DOMContentLoaded', function() {--%>
<%--        const kebabButtons = document.querySelectorAll('.kebab-btn');--%>

<%--        // Xử lý click vào nút kebab--%>
<%--        kebabButtons.forEach(btn => {--%>
<%--            btn.addEventListener('click', function(e) {--%>
<%--                e.stopPropagation();--%>

<%--                // Đóng tất cả menu khác--%>
<%--                document.querySelectorAll('.menu-dropdown').forEach(menu => {--%>
<%--                    if (menu !== this.nextElementSibling) {--%>
<%--                        menu.classList.remove('show');--%>
<%--                    }--%>
<%--                });--%>

<%--                // Toggle menu hiện tại--%>
<%--                const dropdown = this.nextElementSibling;--%>
<%--                dropdown.classList.toggle('show');--%>
<%--            });--%>
<%--        });--%>

<%--        // ✅ Đóng menu kebab khi click ra ngoài--%>
<%--        document.addEventListener('click', function(e) {--%>
<%--            // KHÔNG đóng nếu click vào popup--%>
<%--            if (!e.target.closest('.popup-overlay') &&--%>
<%--                !e.target.closest('.kebab-menu')) {--%>
<%--                document.querySelectorAll('.menu-dropdown').forEach(menu => {--%>
<%--                    menu.classList.remove('show');--%>
<%--                });--%>
<%--            }--%>
<%--        });--%>

<%--        // ✅ Ngăn menu kebab đóng khi click vào item--%>
<%--        document.querySelectorAll('.menu-dropdown').forEach(menu => {--%>
<%--            menu.addEventListener('click', function(e) {--%>
<%--                e.stopPropagation();--%>
<%--            });--%>
<%--        });--%>

<%--        // ✅ Xử lý popup overlay - click vào nền đen để đóng--%>
<%--        document.querySelectorAll('.popup-overlay').forEach(popup => {--%>
<%--            popup.addEventListener('click', function(e) {--%>
<%--                if (e.target === this) {--%>
<%--                    this.style.display = 'none';--%>
<%--                    // Đóng menu kebab khi đóng popup--%>
<%--                    document.querySelectorAll('.menu-dropdown').forEach(menu => {--%>
<%--                        menu.classList.remove('show');--%>
<%--                    });--%>
<%--                }--%>
<%--            });--%>
<%--        });--%>

<%--        // ✅ Ngăn click vào popup-box đóng popup--%>
<%--        document.querySelectorAll('.popup-box').forEach(box => {--%>
<%--            box.addEventListener('click', function(e) {--%>
<%--                e.stopPropagation();--%>
<%--            });--%>
<%--        });--%>

<%--        // ✅ QUAN TRỌNG: Đóng menu kebab khi mở popup--%>
<%--        document.querySelectorAll('.upgrade-user, .view-detail, .permanent-lock').forEach(item => {--%>
<%--            item.addEventListener('click', function() {--%>
<%--                // Đóng tất cả menu kebab--%>
<%--                document.querySelectorAll('.menu-dropdown').forEach(menu => {--%>
<%--                    menu.classList.remove('show');--%>
<%--                });--%>
<%--            });--%>
<%--        });--%>
<%--    });--%>
<%--</script>--%>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // ========== PHẦN 1: TÌM KIẾM VÀ LỌC ==========
        document.getElementById('searchInput').addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('searchForm').submit();
            }
        });

        document.querySelector('.fa-magnifying-glass').addEventListener('click', function () {
            document.getElementById('searchForm').submit();
        });

        document.getElementById('levelFilter').addEventListener('change', function () {
            document.getElementById('searchForm').submit();
        });

        // ========== PHẦN 2: XỬ LÝ KEBAB MENU ==========
        const kebabButtons = document.querySelectorAll('.kebab-btn');

        kebabButtons.forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.stopPropagation();

                document.querySelectorAll('.menu-dropdown').forEach(menu => {
                    if (menu !== this.nextElementSibling) {
                        menu.classList.remove('show');
                    }
                });

                const dropdown = this.nextElementSibling;
                dropdown.classList.toggle('show');
            });
        });

        document.addEventListener('click', function (e) {
            if (!e.target.closest('.popup-overlay') && !e.target.closest('.kebab-menu')) {
                document.querySelectorAll('.menu-dropdown').forEach(menu => {
                    menu.classList.remove('show');
                });
            }
        });

        document.querySelectorAll('.menu-dropdown').forEach(menu => {
            menu.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        });

        // ========== PHẦN 3: XỬ LÝ POPUP ==========
        document.querySelectorAll('.popup-overlay').forEach(popup => {
            popup.addEventListener('click', function (e) {
                if (e.target === this) {
                    this.style.display = 'none';
                    document.querySelectorAll('.menu-dropdown').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });
        });

        document.querySelectorAll('.popup-box').forEach(box => {
            box.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        });

        // ========== PHẦN 4: XEM CHI TIẾT ==========
        document.querySelectorAll('.view-detail').forEach(item => {
            item.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                const name = this.dataset.name;
                const email = this.dataset.email;
                const phone = this.dataset.phone || 'Chưa cập nhật';
                const level = this.dataset.level;
                const spent = parseFloat(this.dataset.spent) || 0;
                const spentFormatted = spent.toLocaleString('vi-VN') + 'đ';
                const points = parseInt(this.dataset.points) || 0;
                const pointsFormatted = points.toLocaleString('vi-VN') + ' xu';

                let createdAt = 'Chưa có thông tin';
                if (this.dataset.createdAt && this.dataset.createdAt !== 'null') {
                    try {
                        const date = new Date(this.dataset.createdAt);
                        createdAt = date.toLocaleDateString('vi-VN');
                    } catch (e) {
                        createdAt = 'Chưa có thông tin';
                    }
                }

                document.getElementById('detailName').textContent = name;
                document.getElementById('detailEmail').textContent = email;
                document.getElementById('detailPhone').textContent = phone;
                document.getElementById('detailSpent').textContent = spentFormatted;
                document.getElementById('detailPoints').textContent = pointsFormatted;
                document.getElementById('detailCreatedAt').textContent = createdAt;

                const badge = document.getElementById('detailLevelBadge');
                badge.textContent = level;
                badge.className = 'level-badge level-' + level;

                document.querySelectorAll('.menu-dropdown').forEach(menu => {
                    menu.classList.remove('show');
                });

                document.getElementById('detailPopup').style.display = 'flex';
            });
        });

        // ========== PHẦN 5: NÂNG CẤP ==========
        document.querySelectorAll('.upgrade-user').forEach(item => {
            item.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                const userId = this.dataset.id;
                const userName = this.dataset.name;
                const currentLevel = this.dataset.currentLevel;

                document.getElementById('upgradeUserId').value = userId;
                document.getElementById('popupUserName').innerText = "Tên: " + userName;
                document.getElementById('upgradeSelect').value = currentLevel;

                document.querySelectorAll('.menu-dropdown').forEach(menu => {
                    menu.classList.remove('show');
                });

                document.getElementById('upgradePopup').style.display = 'flex';
            });
        });

        document.getElementById('upgradeCancel').onclick = function () {
            document.getElementById('upgradePopup').style.display = 'none';
        };

        document.getElementById('upgradeConfirm').addEventListener('click', function () {
            const userId = document.getElementById('upgradeUserId').value;
            const newLevel = document.getElementById('upgradeSelect').value;

            // ✅ THÊM: Hiện loading
            this.disabled = true;
            this.textContent = 'Đang xử lý...';

            fetch('${pageContext.request.contextPath}/admin/user-management', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=upgrade&userId=' + userId + '&newLevel=' + newLevel
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert('Lỗi: ' + data.message);
                        this.disabled = false;
                        this.textContent = 'Xác nhận';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi nâng cấp');
                    this.disabled = false;
                    this.textContent = 'Xác nhận';
                });

            document.getElementById('upgradePopup').style.display = 'none';
        });

        // ========== PHẦN 6: KHÓA TÀI KHOẢN (IMPROVED) ==========
        document.querySelectorAll('.permanent-lock').forEach(item => {
            item.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                const userId = this.dataset.id;
                const userName = this.dataset.name;

                // ✅ Hiện loading khi đang kiểm tra
                const loadingAlert = document.createElement('div');
                loadingAlert.style.cssText = 'position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);background:white;padding:20px;border-radius:8px;box-shadow:0 2px 10px rgba(0,0,0,0.3);z-index:9999;';
                loadingAlert.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang kiểm tra vi phạm...';
                document.body.appendChild(loadingAlert);

                // ✅ GỌI API KIỂM TRA VI PHẠM
                fetch('${pageContext.request.contextPath}/admin/user-management', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=check-violation&userId=' + userId
                })
                    .then(response => response.json())
                    .then(data => {
                        // Xóa loading
                        document.body.removeChild(loadingAlert);

                        if (data.hasViolation) {
                            // ✅ User đã vi phạm → Cho phép khóa
                            const violations = data.violations.join('\n• ');

                            document.getElementById('lockUserId').value = userId;
                            document.getElementById('lockMessage').innerHTML =
                                '<strong style="color: #dc3545;">⚠️ KHÓA VĨNH VIỄN TÀI KHOẢN<' + '/strong>' +
                                '<div style="margin: 15px 0; padding: 10px; background: #fff3cd; border-left: 4px solid #ffc107; border-radius: 4px;">' +
                                '<strong>Người dùng:<' + '/strong> ' + userName + '<br>' +
                                '<strong style="color: #dc3545;">Vi phạm phát hiện (' + data.violationCount + '):<' + '/strong><br>' +
                                '• ' + violations.replace(/\\n/g, '<br>• ') +
                                '<' + '/div>' +
                                '<div style="background: #f8d7da; padding: 10px; border-radius: 4px; margin-top: 10px;">' +
                                '<strong style="color: #721c24;">⚠️ CẢNH BÁO:<' + '/strong> Hành động này KHÔNG THỂ HOÀN TÁC!' +
                                '<' + '/div>';

                            // Đóng menu kebab
                            document.querySelectorAll('.menu-dropdown').forEach(menu => {
                                menu.classList.remove('show');
                            });

                            // Hiện popup
                            document.getElementById('lockPopup').style.display = 'flex';

                        } else {
                            // ❌ User chưa vi phạm → Không cho khóa
                            alert(
                                '❌ KHÔNG THỂ KHÓA TÀI KHOẢN\n\n' +
                                '👤 Người dùng: ' + userName + '\n\n' +
                                '📋 Lý do: Chưa có vi phạm nào được ghi nhận\n\n' +
                                '📌 Điều kiện khóa tài khoản:\n' +
                                '   • Hủy ≥ 5 đơn hàng trong 1 giờ\n' +
                                '   • Đăng nhập thất bại ≥ 5 lần liên tiếp\n\n' +
                                '💡 Hệ thống chỉ cho phép khóa tài khoản có hành vi vi phạm rõ ràng.'
                            );

                            // Đóng menu kebab
                            document.querySelectorAll('.menu-dropdown').forEach(menu => {
                                menu.classList.remove('show');
                            });
                        }
                    })
                    .catch(error => {
                        // Xóa loading nếu có lỗi
                        if (document.body.contains(loadingAlert)) {
                            document.body.removeChild(loadingAlert);
                        }

                        console.error('Error:', error);
                        alert('⚠️ Có lỗi xảy ra khi kiểm tra vi phạm.\n\nVui lòng thử lại sau.');
                    });
            });
        });

// ✅ XÁC NHẬN KHÓA (Improved với loading state)
        document.getElementById('confirmLock').addEventListener('click', function () {
            const userId = document.getElementById('lockUserId').value;

            // Disable button và hiện loading
            this.disabled = true;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang khóa...';

            fetch('${pageContext.request.contextPath}/admin/user-management', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=lock&userId=' + userId
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        alert('✅ KHÓA THÀNH CÔNG\n\n' + data.message);
                        location.reload();
                    } else {
                        alert('❌ KHÓA THẤT BẠI\n\n' + data.message);
                        this.disabled = false;
                        this.textContent = 'Khóa vĩnh viễn';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('⚠️ Có lỗi xảy ra khi khóa tài khoản.\n\nVui lòng thử lại sau.');
                    this.disabled = false;
                    this.textContent = 'Khóa vĩnh viễn';
                });

            document.getElementById('lockPopup').style.display = 'none';
        });

        // ========== PHẦN 7: PHÂN TRANG ==========
        const ROWS_PER_PAGE = 10;
        const tbody = document.getElementById('userTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row') && r.cells.length > 1);
        const pageButtons = document.querySelectorAll('.user-page');

        function showPage(page) {
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => {
                r.style.display = (idx >= start && idx < end) ? "" : "none";
            });

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.user-page[data-page="${page}"]`)?.classList.add('active');
        }

        pageButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                showPage(Number(btn.dataset.page));
            });
        });

        showPage(1);

        // ========== PHẦN 8: ACTIVE SIDEBAR ==========
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
    // ✅ AUTO-RELOAD - KHÔNG RELOAD KHI CÓ POPUP
    (function autoRefreshUserData() {
        setInterval(function () {
            const hasOpenPopup = document.querySelector('.popup-overlay[style*="display: flex"]');

            if (hasOpenPopup) {
                return;
            }

            const currentSearch = document.getElementById('searchInput').value;
            const currentLevel = document.getElementById('levelFilter').value;
            let url = '${pageContext.request.contextPath}/admin/user-management';
            let params = [];

            if (currentSearch) params.push('search=' + encodeURIComponent(currentSearch));
            if (currentLevel) params.push('level=' + encodeURIComponent(currentLevel));

            if (params.length > 0) {
                url += '?' + params.join('&');
            }

            window.location.href = url;
        }, 30000); // 30 giây
    })();
</script>

</body>
</html>