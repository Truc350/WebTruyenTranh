<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Thống kê</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleReport.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/adminHeader.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <jsp:include page="/fontend/admin/ASide.jsp"/>

    <div class="main-content">
        <!-- Header Admin -->
        <%@ include file="HeaderAdmin.jsp" %>

        <!-- Wrapper cho nội dung thống kê -->
        <div class="report-wrapper">

            <!-- Tiêu đề trang -->
            <h1 class="page-title">
                <i class="fas fa-chart-line"></i>
                Thống kê
            </h1>

            <!-- Bộ lọc thời gian -->
            <div class="filter-time">
                <button class="time-btn active" data-filter="today">Hôm nay</button>
                <button class="time-btn" data-filter="week">Tuần này</button>
                <button class="time-btn" data-filter="month">Tháng này</button>
                <button class="time-btn" data-filter="custom">Tùy chỉnh</button>
                <input type="date" id="startDate" style="display:none;">
                <input type="date" id="endDate" style="display:none;">
            </div>

            <!-- KPI Cards -->
            <div class="kpi-cards">
                <div class="kpi-card" data-chart="revenue">
                    <i class="fas fa-dollar-sign kpi-icon"></i>
                    <div class="kpi-info">
                        <span class="kpi-title">Doanh thu</span>
                        <span class="kpi-value" id="kpi-revenue">0đ</span>
                    </div>
                </div>
                <div class="kpi-card" data-chart="orders">
                    <i class="fas fa-shopping-cart kpi-icon"></i>
                    <div class="kpi-info">
                        <span class="kpi-title">Số đơn hàng</span>
                        <span class="kpi-value" id="kpi-orders">0 đơn</span>
                    </div>
                </div>
                <div class="kpi-card" data-chart="avgValue">
                    <i class="fas fa-chart-line kpi-icon"></i>
                    <div class="kpi-info">
                        <span class="kpi-title">Giá trị đơn trung bình</span>
                        <span class="kpi-value" id="kpi-avg">0đ</span>
                    </div>
                </div>
                <div class="kpi-card">
                    <i class="fas fa-star kpi-icon"></i>
                    <div class="kpi-info">
                        <span class="kpi-title">Sản phẩm bán chạy nhất</span>
                        <span class="kpi-value" id="kpi-best">Chưa có dữ liệu</span>
                    </div>
                </div>
            </div>

            <!-- Chart chính: BAR CHART -->
            <div class="chart-container">
                <h3 id="chart-title">Biểu đồ Doanh thu</h3>
                <canvas id="mainChart"></canvas>
            </div>

            <!-- Bảng top sản phẩm + Doughnut chart -->
            <div class="top-products-wrapper">
                <div class="top-products">
                    <h3>Top 3 sản phẩm bán chạy</h3>
                    <table>
                        <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Đã bán</th>
                        </tr>
                        </thead>
                        <tbody id="top-products-body">
                        <tr>
                            <td colspan="2">Đang tải...</td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="top-products-chart">
                    <canvas id="topProductsChart"></canvas>
                </div>
            </div>
        </div>
        <!-- End report-wrapper -->
    </div>
    <!-- End main-content -->
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // ========== BIẾN TOÀN CỤC ==========
    let mainChart = null;
    let topProductsChart = null;
    let currentChartType = 'revenue';
    let reportData = null;

    // ========== FORMAT SỐ ==========
    function formatCurrency(value) {
        // Xử lý các trường hợp null, undefined, NaN
        if (value === null || value === undefined || isNaN(value)) {
            return '0đ';
        }
        const numValue = Number(value);
        if (numValue === 0) return '0đ';

        return new Intl.NumberFormat('vi-VN').format(Math.round(numValue)) + 'đ';
    }

    function formatNumber(value) {
        // Xử lý các trường hợp null, undefined, NaN
        if (value === null || value === undefined || isNaN(value)) {
            return '0';
        }
        const numValue = Number(value);
        if (numValue === 0) return '0';

        return new Intl.NumberFormat('vi-VN').format(numValue);
    }
    // ========== TẢI DỮ LIỆU AJAX ==========
    function loadReportData(filter, startDate, endDate) {
        const params = new URLSearchParams({filter: filter});

        if (filter === 'custom' && startDate && endDate) {
            params.append('startDate', startDate);
            params.append('endDate', endDate);
        }

        fetch('${pageContext.request.contextPath}/admin/report-data?' + params.toString())
            .then(response => response.json())
            .then(data => {
                console.log('📊 Data loaded:', data);
                reportData = data;
                updateKPICards(data.kpi);
                updateTopProducts(data.topProducts);
                updateChart(currentChartType);
            })
            .catch(error => {
                console.error('❌ Error:', error);
                alert('Lỗi tải dữ liệu!');
            });
    }

    // ========== CẬP NHẬT KPI ==========
    function updateKPICards(kpi) {
        console.log('📈 Updating KPI cards:', kpi);

        const revenueEl = document.getElementById('kpi-revenue');
        const ordersEl = document.getElementById('kpi-orders');
        const avgEl = document.getElementById('kpi-avg');
        const bestEl = document.getElementById('kpi-best');

        if (revenueEl) {
            revenueEl.textContent = formatCurrency(kpi.revenue || 0);
        }

        if (ordersEl) {
            ordersEl.textContent = formatNumber(kpi.totalOrders || 0) + ' đơn';
        }

        if (avgEl) {
            avgEl.textContent = formatCurrency(kpi.avgOrderValue || 0);
        }

        if (bestEl) {
            bestEl.textContent = kpi.bestProduct || 'Chưa có dữ liệu';
        }
    }

    // ========== CẬP NHẬT TOP 3 SẢN PHẨM ==========
    function updateTopProducts(products) {
        const tbody = document.getElementById('top-products-body');

        if (!products || products.length === 0) {
            tbody.innerHTML = '<tr><td colspan="2">Chưa có dữ liệu</td></tr>';
            updateDoughnutChart([]);
            return;
        }

        tbody.innerHTML = products.map(p =>
            `<tr><td>${p.name_comics}</td><td>${formatNumber(p.total_sold)}</td></tr>`
        ).join('');

        updateDoughnutChart(products);
    }

    // ========== BIỂU ĐỒ DOUGHNUT ==========
    function updateDoughnutChart(products) {
        const canvas = document.getElementById('topProductsChart');
        const ctx = canvas.getContext('2d');

        if (topProductsChart) {
            topProductsChart.destroy();
        }

        if (!products || products.length === 0) return;

        topProductsChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: products.map(p => p.name_comics),
                datasets: [{
                    data: products.map(p => p.total_sold),
                    backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '60%',
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom',
                        labels: {font: {size: 12}, padding: 15, usePointStyle: true}
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.label + ': ' + formatNumber(context.parsed) + ' cuốn';
                            }
                        }
                    }
                },
                animation: {duration: 1000, easing: 'easeOutQuart'}
            }
        });
    }

    // ========== BIỂU ĐỒ CHÍNH (BAR CHART) ==========
    function updateChart(type) {
        if (!reportData || !reportData.chartData) return;

        currentChartType = type;
        const canvas = document.getElementById('mainChart');
        const ctx = canvas.getContext('2d');

        if (mainChart) mainChart.destroy();

        let chartData, label, title;

        switch (type) {
            case 'revenue':
                chartData = reportData.chartData.revenue;
                label = 'Doanh thu';
                title = 'Biểu đồ Doanh thu';
                break;
            case 'orders':
                chartData = reportData.chartData.orders;
                label = 'Số đơn hàng';
                title = 'Biểu đồ Số đơn hàng';
                break;
            case 'avgValue':
                chartData = reportData.chartData.avgValue;
                label = 'Giá trị trung bình';
                title = 'Biểu đồ Giá trị đơn trung bình';
                break;
        }

        document.getElementById('chart-title').textContent = title;

        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(0,123,255,0.8)');
        gradient.addColorStop(1, 'rgba(0,123,255,0.2)');

        mainChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: chartData.labels,
                datasets: [{
                    label: label,
                    data: chartData.data,
                    backgroundColor: gradient,
                    borderRadius: 5,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        enabled: true,
                        callbacks: {
                            label: function (context) {
                                let value = context.parsed.y;
                                if (type === 'orders') {
                                    return label + ': ' + formatNumber(value) + ' đơn';
                                } else {
                                    return label + ': ' + formatCurrency(value);
                                }
                            }
                        }
                    }
                },
                animation: {duration: 1000, easing: 'easeOutQuart'},
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                if (type === 'orders') {
                                    return formatNumber(value);
                                } else {
                                    return formatCurrency(value);
                                }
                            }
                        }
                    }
                }
            }
        });
    }

    // ========== CLICK KPI CARD ĐỂ CHUYỂN BIỂU ĐỒ ==========
    document.querySelectorAll('.kpi-card[data-chart]').forEach(card => {
        card.addEventListener('click', function () {
            const chartType = this.getAttribute('data-chart');
            updateChart(chartType);

            // Highlight card được chọn
            document.querySelectorAll('.kpi-card[data-chart]').forEach(c => {
                c.style.border = 'none';
            });
            this.style.border = '2px solid #007bff';
        });
    });

    // ========== BỘ LỌC THỜI GIAN ==========
    const timeButtons = document.querySelectorAll('.time-btn');
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');

    timeButtons.forEach(btn => {
        btn.addEventListener('click', function () {
            timeButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const filter = this.getAttribute('data-filter');

            if (filter === 'custom') {
                startDateInput.style.display = 'inline-block';
                endDateInput.style.display = 'inline-block';
            } else {
                startDateInput.style.display = 'none';
                endDateInput.style.display = 'none';
                loadReportData(filter);
            }
        });
    });

    startDateInput.addEventListener('change', function () {
        if (endDateInput.value) {
            loadReportData('custom', this.value, endDateInput.value);
        }
    });

    endDateInput.addEventListener('change', function () {
        if (startDateInput.value) {
            loadReportData('custom', startDateInput.value, this.value);
        }
    });

    // ========== KHỞI TẠO ==========
    document.addEventListener('DOMContentLoaded', function () {
        loadReportData('today');

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