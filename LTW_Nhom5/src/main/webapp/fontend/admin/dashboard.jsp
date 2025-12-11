<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ</title>
    <link rel="stylesheet" href="../css/adminCss/styleDashboard.css">
    <link rel="stylesheet" href="../css/adminCss/adminHeader.css">
    <link rel="stylesheet" href="../css/adminCss/styleSidebar.css">
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
                <a href="dashboard.html">
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

        <div class="dashboard">
            <h2>Tổng quan cửa hàng</h2>

            <div class="stats-grid">
                <div class="stat-card">
                    <i class="fa-solid fa-book"></i>
                    <div>
                        <h3>200</h3>
                        <p>Truyện đang bán</p>
                    </div>
                </div>
                <div class="stat-card">
                    <i class="fa-solid fa-receipt"></i>
                    <div>
                        <h3>132</h3>
                        <p>Đơn hàng</p>
                    </div>
                </div>
                <div class="stat-card">
                    <i class="fa-solid fa-sack-dollar"></i>
                    <div>
                        <h3>18.000.000đ</h3>
                        <p>Doanh thu tháng</p>
                    </div>
                </div>
                <div class="stat-card">
                    <i class="fa-solid fa-user"></i>
                    <div>
                        <h3>45</h3>
                        <p>Khách hàng mới</p>
                    </div>
                </div>
            </div>

            <div class="chart-section">
                <h3>Doanh thu 12 tháng</h3>
                <canvas id="yearRevenueChart"></canvas>
            </div>

            <div class="bestseller-section">
                <h3>Top 10 sản phẩm bán chạy nhất tháng</h3>
                <table class="bestseller-table">
                    <thead>
                    <tr>
                        <th>Top</th>
                        <th>Sản phẩm</th>
                        <th>Số lượng bán</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr><td>1</td><td>One Piece - Tập 102</td><td>320</td></tr>
                    <tr><td>2</td><td>Attack on Titan - Tập 34</td><td>290</td></tr>
                    <tr><td>3</td><td>Conan - Tập 101</td><td>250</td></tr>
                    <tr><td>4</td><td>Jujutsu Kaisen - Tập 20</td><td>220</td></tr>
                    <tr><td>5</td><td>Demon Slayer - Tập 15</td><td>200</td></tr>
                    <tr><td>6</td><td>Naruto - Tập 45</td><td>185</td></tr>
                    <tr><td>7</td><td>Spy x Family - Tập 8</td><td>160</td></tr>
                    <tr><td>8</td><td>Chainsaw Man - Tập 12</td><td>150</td></tr>
                    <tr><td>9</td><td>Blue Lock - Tập 10</td><td>140</td></tr>
                    <tr><td>10</td><td>Solo Leveling - Tập 5</td><td>130</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    const ctx = document.getElementById('yearRevenueChart').getContext('2d');

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'],
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: [5, 7, 6, 8, 9, 12, 10, 11, 13, 14, 15, 16],
                fill: true,
                borderColor: '#007bff',
                backgroundColor: 'rgba(78,115,223,0.2)',
                tension: 0.3,
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 5,
                        callback: value => value + 'M'
                    },
                    suggestedMax: 20
                }
            }
        }
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

</body>
</html>