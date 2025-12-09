<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="../css/adminCss/styleUserMan.css">
    <link rel="stylesheet" href="../css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="../css/adminCss/adminHeader.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
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
                <a href="userManagement.html">
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
            <li>
                <a href="promotion.jsp">
                    <img src="../../img/promo.png" class="icon">
                    <span>Quản lý khuyến mãi</span>
                </a>
            </li>
            <li>
                <a href="report.jsp">
                    <img src="../../img/report.png" class="icon">
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
                        <img src="../../img/admin.png" class="admin-avatar" alt="Admin">
                    </a>
                    <span class="admin-name">Admin</span>
                </div>

                <!-- Nút đăng xuất -->
                <button class="btn-logout" title="Đăng xuất">
                    <a href="../public/login.jsp">
                        <i class="fa-solid fa-right-from-bracket"></i>
                    </a>
                </button>
            </div>
        </header>
        <h2 class="page-title">Quản lý người dùng</h2>

        <div class="user-management">

            <!-- Search bar -->
            <div class="search-filter-container">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Tìm kiếm người mua...">
                    <i class="fas fa-magnifying-glass"></i>
                </div>

                <select id="levelFilter" class="level-filter">
                    <option value="">Tất cả cấp độ</option>
                    <option value="Normal">Normal</option>
                    <option value="Silver">Silver</option>
                    <option value="Gold">Gold</option>
                    <option value="Platinum">Platinum</option>
                </select>
            </div>


            <table id="userTable" class="user-table">
                <thead>
                <tr>
                    <th>Tên khách hàng</th>
                    <th>Email</th>
                    <th>Cấp thành viên</th>
                    <th>Tổng chi tiêu</th>
                    <th>Điểm xu</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody id="userTableBody">
                <tr>
                    <td>Nguyễn Văn A</td>
                    <td>van.a@example.com</td>
                    <td><span class="badge level-Normal">Normal</span></td>
                    <td>1.200.000đ</td>
                    <td>300 xu</td>
                    <td class="action-cell">
                        <div class="kebab-menu">
                            <button class="kebab-btn">⋮</button>
                            <div class="menu-dropdown">
                                <a href="#" class="menu-item view-detail"
                                   data-name="Nguyễn Văn A"
                                   data-email="van.a@example.com"
                                   data-level="Normal"
                                   data-spent="1.200.000đ"
                                   data-points="300 xu">Xem chi tiết</a>
                                <a href="#" class="menu-item upgrade-user" data-name="Nguyễn Văn A">Nâng cấp</a>
                                <a href="#" class="menu-item permanent-lock" data-name="Nguyễn Văn A">Khóa vĩnh viễn</a>
                            </div>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>Nguyễn Văn B</td>
                    <td>van.b@example.com</td>
                    <td><span class="badge level-Silver">Silver</span></td>
                    <td>3.500.000đ</td>
                    <td>950 xu</td>
                    <td class="action-cell">
                        <div class="kebab-menu">
                            <button class="kebab-btn">⋮</button>
                            <div class="menu-dropdown">
                                <a href="#" class="menu-item view-detail"
                                   data-name="Nguyễn Văn B"
                                   data-email="van.b@example.com"
                                   data-level="Silver"
                                   data-spent="3.500.000đ"
                                   data-points="950 xu">Xem chi tiết</a>
                                <a href="#" class="menu-item upgrade-user" data-name="Nguyễn Văn B">Nâng cấp</a>
                                <a href="#" class="menu-item permanent-lock" data-name="Nguyễn Văn B">Khóa vĩnh viễn</a>
                            </div>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>Trần Thị C</td>
                    <td>thi.c@example.com</td>
                    <td><span class="badge level-Gold">Gold</span></td>
                    <td>7.800.000đ</td>
                    <td>1600 xu</td>
                    <td class="action-cell">
                        <div class="kebab-menu">
                            <button class="kebab-btn">⋮</button>
                            <div class="menu-dropdown">
                                <a href="#" class="menu-item view-detail"
                                   data-name="Trần Thị C"
                                   data-email="thi.c@example.com"
                                   data-level="Gold"
                                   data-spent="7.800.000đ"
                                   data-points="1600 xu">Xem chi tiết</a>
                                <a href="#" class="menu-item upgrade-user" data-name="Trần Thị C">Nâng cấp</a>
                                <a href="#" class="menu-item permanent-lock" data-name="Trần Thị C">Khóa vĩnh viễn</a>
                            </div>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>Lê Thị D</td>
                    <td>thi.d@example.com</td>
                    <td><span class="badge level-Platinum">Platinum</span></td>
                    <td>11.200.000đ</td>
                    <td>2200 xu</td>
                    <td class="action-cell">
                        <div class="kebab-menu">
                            <button class="kebab-btn">⋮</button>
                            <div class="menu-dropdown">
                                <a href="#" class="menu-item view-detail"
                                   data-name="Lê Thị D"
                                   data-email="thi.d@example.com"
                                   data-level="Platinum"
                                   data-spent="11.200.000đ"
                                   data-points="2200 xu">Xem chi tiết</a>
                                <a href="#" class="menu-item upgrade-user" data-name="Lê Thị D">Nâng cấp</a>
                                <a href="#" class="menu-item permanent-lock" data-name="Lê Thị D">Khóa vĩnh viễn</a>
                            </div>
                        </div>
                    </td>
                </tr>

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

        <!-- Popup Xem chi tiết -->
        <div id="detailPopup" class="popup-overlay">
            <div class="popup-box" style="width: 500px; text-align:left;">
                <h3>Thông tin khách hàng</h3>
                <div style="margin:20px 0; line-height:1.9; font-size:15px;">
                    <p><strong>Họ tên:</strong> <span id="detailName"></span></p>
                    <p><strong>Email:</strong> <span id="detailEmail"></span></p>
                    <p><strong>Cấp bậc:</strong> <span id="detailLevel"></span></p>
                    <p><strong>Tổng chi tiêu:</strong> <span id="detailSpent"></span></p>
                    <p><strong>Điểm xu:</strong> <span id="detailPoints"></span></p>
                    <hr style="margin:15px 0">
                    <p><small>Ngày đăng ký: 15/03/2024 • Lần hoạt động cuối: 2 giờ trước</small></p>
                </div>
                <div class="popup-actions">
                    <button class="btn-secondary" onclick="document.getElementById('detailPopup').style.display='none'">Đóng</button>
                </div>
            </div>
        </div>

        <div id="lockPopup" class="popup-overlay">
            <div class="popup-box">
                <h3>Xác nhận khóa tài khoản</h3>
                <div class="popup-message" id="lockMessage">
                    KHÓA VĨNH VIỄN tài khoản "Nguyễn Văn A"?\n\nHành động này KHÔNG THỂ HOÀN TÁC!
                </div>
                <div class="popup-actions">
                    <button class="btn-cancel" onclick="document.getElementById('lockPopup').style.display='none'">Hủy</button>
                    <button class="btn-danger" id="confirmLock">Khóa vĩnh viễn</button>
                </div>
            </div>
        </div>

    </div>

</div>


<script>
    let rows = Array.from(document.querySelectorAll("#userTableBody tr"))
        .filter(r => r.querySelector(".upgrade-btn"));
    let popup = document.getElementById("upgradePopup");
    let selectedRow = null;

    rows.forEach(row => {
        row.querySelector(".upgrade-btn").onclick = function () {
            selectedRow = row;
            document.getElementById("popupUserName").innerText =
                "Tên: " + row.cells[0].innerText;
            popup.style.display = "flex";
        }
    });


    document.getElementById("upgradeCancel").onclick = function () {
        popup.style.display = "none";
    };

</script>

<script>
    // Xem chi tiết
    document.querySelectorAll('.view-detail').forEach(item => {
        item.addEventListener('click', e => {
            e.preventDefault();
            document.getElementById('detailName').textContent = item.dataset.name;
            document.getElementById('detailEmail').textContent = item.dataset.email;
            document.getElementById('detailLevel').textContent = item.dataset.level;
            document.getElementById('detailSpent').textContent = item.dataset.spent;
            document.getElementById('detailPoints').textContent = item.dataset.points;
            document.getElementById('detailPopup').style.display = 'flex';
        });
    });

    // Nâng cấp
    document.querySelectorAll('.upgrade-user').forEach(item => {
        item.addEventListener('click', e => {
            e.preventDefault();
            selectedRow = item.closest('tr');
            document.getElementById("popupUserName").innerText = "Tên: " + item.dataset.name;
            document.getElementById("upgradePopup").style.display = "flex";
        });
    });

    // Khóa vĩnh viễn - hiện popup
    let lockTargetName = '';
    document.querySelectorAll('.permanent-lock').forEach(item => {
        item.addEventListener('click', e => {
            e.preventDefault();
            lockTargetName = item.dataset.name;
            document.getElementById('lockMessage').textContent =
                `KHÓA VĨNH VIỄN tài khoản "${lockTargetName}"?\n\nHành động này KHÔNG THỂ HOÀN TÁC!`;
            document.getElementById('lockPopup').style.display = 'flex';
        });
    });

    // Xác nhận khóa
    document.getElementById('confirmLock').addEventListener('click', () => {
        alert(`ĐÃ KHÓA VĨNH VIỄN tài khoản "${lockTargetName}"`);
        document.getElementById('lockPopup').style.display = 'none';
        // Sau này thay alert bằng gọi API thật: fetch('/api/lock-user', {method:'POST', body: JSON.stringify({name: lockTargetName})})
    });
</script>

<script>
    (function () {
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('userTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row'));
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

</body>
</html>