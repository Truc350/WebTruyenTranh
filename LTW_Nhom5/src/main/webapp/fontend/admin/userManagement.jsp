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
        <jsp:include page="/fontend/admin/HeaderAdmin.jsp"/>
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
                            <tr data-user-id="${user.id}">
                                <td>${user.fullName != null ? user.fullName : 'Chưa cập nhật'}</td>
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
                                               data-points="${user.points} xu"
                                               data-created-at="${user.createdAt}">
                                                Xem chi tiết</a>
                                            <a href="#" class="menu-item upgrade-user"
                                               data-id="${user.id}"
                                               data-name="${user.fullName != null ? user.fullName : 'Chưa cập nhật'}"
                                               data-current-level="${user.membershipLevel != null ? user.membershipLevel : 'Normal'}">Nâng
                                                cấp</a>
                                            <a href="#" class="menu-item permanent-lock"
                                               data-id="${user.id}"
                                               data-name="${user.fullName != null ? user.fullName : 'Chưa cập nhật'}">Khóa
                                                vĩnh viễn</a>
                                        </div>
                                    </div>
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


<script>
    // Tìm kiếm khi nhấn Enter
    document.getElementById('searchInput').addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            document.getElementById('searchForm').submit();
        }
    });

    // Tìm kiếm khi click vào icon
    document.querySelector('.fa-magnifying-glass').addEventListener('click', function () {
        document.getElementById('searchForm').submit();
    });

    // Lọc theo level
    document.getElementById('levelFilter').addEventListener('change', function () {
        document.getElementById('searchForm').submit();
    });


    // Xem chi tiết
    document.querySelectorAll('.view-detail').forEach(item => {
        item.addEventListener('click', e => {
            e.preventDefault();

            const name = item.dataset.name;
            const email = item.dataset.email;
            const phone = item.dataset.phone || 'Chưa cập nhật';
            const level = item.dataset.level;
            // Format số tiền
            const spent = parseFloat(item.dataset.spent) || 0;
            const spentFormatted = spent.toLocaleString('vi-VN') + 'đ';
            // Format điểm
            const points = parseInt(item.dataset.points) || 0;
            const pointsFormatted = points.toLocaleString('vi-VN') + ' xu';

            // Format ngày tháng
            let createdAt = 'Chưa có thông tin';
            if (item.dataset.createdAt && item.dataset.createdAt !== 'null') {
                try {
                    const date = new Date(item.dataset.createdAt);
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

            // Badge cấp độ
            const badge = document.getElementById('detailLevelBadge');
            badge.textContent = level;
            badge.className = 'level-badge level-' + level;

            // Hiện popup
            document.getElementById('detailPopup').style.display = 'flex';
        });
    });

    // Nâng cấp - hiện popup
    document.querySelectorAll('.upgrade-user').forEach(item => {
        item.addEventListener('click', e => {
            e.preventDefault();
            const userId = item.dataset.id;
            const userName = item.dataset.name;
            const currentLevel = item.dataset.currentLevel;

            document.getElementById('upgradeUserId').value = userId;
            document.getElementById('popupUserName').innerText = "Tên: " + userName;
            document.getElementById('upgradeSelect').value = currentLevel;
            document.getElementById('upgradePopup').style.display = 'flex';
        });
    });

    // Hủy nâng cấp
    document.getElementById('upgradeCancel').onclick = function () {
        document.getElementById('upgradePopup').style.display = 'none';
    };


    // Xác nhận nâng cấp
    document.getElementById('upgradeConfirm').addEventListener('click', function () {
        const userId = document.getElementById('upgradeUserId').value;
        const newLevel = document.getElementById('upgradeSelect').value;

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
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi nâng cấp');
            });

        document.getElementById('upgradePopup').style.display = 'none';
    });

    // Khóa vĩnh viễn - hiện popup
    document.querySelectorAll('.permanent-lock').forEach(item => {
        item.addEventListener('click', e => {
            e.preventDefault();
            const userId = item.dataset.id;
            const userName = item.dataset.name;

            document.getElementById('lockUserId').value = userId;
            document.getElementById('lockMessage').textContent =
                `KHÓA VĨNH VIỄN tài khoản "${userName}"?\n\nHành động này KHÔNG THỂ HOÀN TÁC!`;
            document.getElementById('lockPopup').style.display = 'flex';
        });
    });

    // Xác nhận khóa
    document.getElementById('confirmLock').addEventListener('click', function () {
        const userId = document.getElementById('lockUserId').value;

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
                    alert(data.message);
                    location.reload();
                } else {
                    alert('Lỗi: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi khóa tài khoản');
            });

        document.getElementById('lockPopup').style.display = 'none';
    });


    // Phân trang
    (function () {
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
    })();

    // Active sidebar
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
    // ✅ TỰ ĐỘNG CẬP NHẬT DỮ LIỆU SAU MỖI 30 GIÂY
    (function autoRefreshUserData() {
        setInterval(function() {
            // Lưu trạng thái tìm kiếm hiện tại
            const currentSearch = document.getElementById('searchInput').value;
            const currentLevel = document.getElementById('levelFilter').value;

            // Reload trang với params hiện tại
            let url = '${pageContext.request.contextPath}/admin/user-management';
            let params = [];

            if (currentSearch) params.push('search=' + encodeURIComponent(currentSearch));
            if (currentLevel) params.push('level=' + encodeURIComponent(currentLevel));

            if (params.length > 0) {
                url += '?' + params.join('&');
            }

            // Reload silent (không thông báo)
            window.location.href = url;
        }, 5000); // 30 giây = 30,000 ms
    })();
</script>

</body>
</html>