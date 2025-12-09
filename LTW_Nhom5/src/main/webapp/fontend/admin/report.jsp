<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Thống kê</title>
    <link rel="stylesheet" href="../css/adminCss/styleReport.css">
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
            <li>
                <a href="promotion.jsp">
                    <img src="../../img/promo.png" class="icon">
                    <span>Quản lý khuyến mãi</span>
                </a>
            </li>
            <li>
                <a href="report.html">
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

        <!-- Bộ lọc thời gian -->
        <div class="filter-time">
            <button class="time-btn active">Hôm nay</button>
            <button class="time-btn">Tuần này</button>
            <button class="time-btn">Tháng này</button>
            <button class="time-btn">Tùy chỉnh</button>
            <input type="date" id="startDate" style="display:none;">
            <input type="date" id="endDate" style="display:none;">
        </div>

        <!-- KPI Cards -->
        <div class="kpi-cards">
            <div class="kpi-card">
                <i class="bi bi-currency-dollar kpi-icon"></i>
                <div class="kpi-info">
                    <span class="kpi-title">Doanh thu</span>
                    <span class="kpi-value">12,450,000đ</span>
                </div>
            </div>
            <div class="kpi-card">
                <i class="bi bi-bag kpi-icon"></i>
                <div class="kpi-info">
                    <span class="kpi-title">Số đơn hàng</span>
                    <span class="kpi-value">128 đơn</span>
                </div>
            </div>
            <div class="kpi-card">
                <i class="bi bi-graph-up kpi-icon"></i>
                <div class="kpi-info">
                    <span class="kpi-title">Giá trị đơn trung bình</span>
                    <span class="kpi-value">97,000đ</span>
                </div>
            </div>
            <div class="kpi-card">
                <i class="bi bi-star kpi-icon"></i>
                <div class="kpi-info">
                    <span class="kpi-title">Sản phẩm bán chạy nhất</span>
                    <span class="kpi-value">One Piece tập 105</span>
                </div>
            </div>
        </div>

        <!-- Chart chính: Doanh thu -->
        <div class="chart-container">
            <canvas id="revenueChart"></canvas>
        </div>

        <!-- Bảng top sản phẩm + Doughnut chart -->
        <div class="top-products-wrapper">
            <div class="top-products">
                <h3>Top sản phẩm bán chạy</h3>
                <table>
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đã bán</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>Conan tập 91</td>
                        <td>128</td>
                    </tr>
                    <tr>
                        <td>Doraemon 45</td>
                        <td>103</td>
                    </tr>
                    <tr>
                        <td>Blue Lock 14</td>
                        <td>95</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="top-products-chart">
                <canvas id="topProductsChart"></canvas>
            </div>
        </div>
</div>
</div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Chart chính: Doanh thu gradient + bo góc + animation + tooltip
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(0,123,255,0.8)');
        gradient.addColorStop(1, 'rgba(0,123,255,0.2)');

        const revenueChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['01/11','02/11','03/11','04/11','05/11','06/11','07/11'],
                datasets: [{
                    label: 'Doanh thu',
                    data: [1200000, 1500000, 1000000, 2000000, 1800000, 2200000, 1900000],
                    backgroundColor: gradient,
                    borderRadius: 5,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    tooltip: { enabled: true }
                },
                animation: {
                    duration: 1000,
                    easing: 'easeOutQuart'
                },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });

        // Chart phụ: Doughnut top sản phẩm
        const topCtx = document.getElementById('topProductsChart').getContext('2d');
        const topProductsChart = new Chart(topCtx, {
            type: 'doughnut',
            data: {
                labels: ['Conan tập 91', 'Doraemon 45', 'Blue Lock 14'],
                datasets: [{
                    data: [128, 103, 95],
                    backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
                    borderWidth: 2,
                    borderColor: '#fff',
                    hoverBorderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '50%', // Tạo lỗ tròn đẹp
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom',
                        labels: {
                            font: { size: 13 },
                            padding: 20,
                            usePointStyle: true
                        }
                    },
                    tooltip: { enabled: false }, // Tắt tooltip
                    datalabels: { display: false }
                },
                events: [], // Tắt mọi sự kiện click/hover
                hover: { mode: null }, // Tắt hover
                animation: {
                    duration: 1200,
                    easing: 'easeOutQuart'
                }
            }
        });

        // Bộ lọc thời gian (demo)
        const buttons = document.querySelectorAll('.time-btn');
        buttons.forEach(btn => {
            btn.addEventListener('click', () => {
                buttons.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                const start = document.getElementById('startDate');
                const end = document.getElementById('endDate');
                if(btn.textContent === 'Tùy chỉnh') {
                    start.style.display = 'inline-block';
                    end.style.display = 'inline-block';
                } else {
                    start.style.display = 'none';
                    end.style.display = 'none';
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

</body>
</html>