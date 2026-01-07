<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Quản lý series</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/adminHeader.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSerieMan.css">
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
                    <a href="../public/login_bo.jsp">
                        <i class="fa-solid fa-right-from-bracket"></i>
                    </a>
                </button>
            </div>
        </header>
        <h2 class="page-title">Quản lý series</h2>

        <div class="search-add-container">
            <div class="search-box">
                <input type="text" placeholder="Tìm kiếm series..." class="search-input">
                <i class="fas fa-magnifying-glass"></i>
            </div>

            <button class="add-btn">
                <i class="fa-solid fa-plus"></i> Thêm series mới
            </button>
        </div>


        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>Mã Series</th>
                    <th>Tên Series</th>
                    <th>Số tập</th>
                    <th>Tình trạng</th>
                    <th></th>
                </tr>
                </thead>

                <tbody id="seriesTableBody">
                <!-- Tạm dữ liệu mẫu -->
                <tr>
                    <td>SR001</td>
                    <td>Thám tử lừng danh Conan</td>
                    <td>105 tập</td>
                    <td>Đang phát hành</td>
                    <td class="action-cell">
                        <div class="action-wrapper">
                            <button class="edit-series-btn" data-id="SR001" data-name="Thám tử lừng danh Conan"
                                    data-vol="105" data-status="Đang phát hành">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </button>

                            <div class="menu-container">
                                <button class="more-btn">⋮</button>
                                <div class="dropdown-menu">
                                    <label><input type="radio" name="display_S001" checked> Hiển thị</label>
                                    <label><input type="radio" name="display_S001"> Ẩn series</label>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>SR002</td>
                    <td>One Piece</td>
                    <td>110 tập</td>
                    <td>Đang phát hành</td>
                    <td class="action-cell">
                        <div class="action-wrapper">
                            <button class="edit-series-btn" data-id="SR002" data-name="One Piece" data-vol="110"
                                    data-status="Đang phát hành">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </button>

                            <div class="menu-container">
                                <button class="more-btn">⋮</button>
                                <div class="dropdown-menu">
                                    <label><input type="radio" name="display_S001" checked> Hiển thị</label>
                                    <label><input type="radio" name="display_S001"> Ẩn series</label>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>

                <tr class="pagination-row">
                    <td colspan="10">
                        <div class="pagination">
                            <button class="page-btn product-page" data-page="1">1</button>
                            <button class="page-btn product-page" data-page="2">2</button>
                            <button class="page-btn product-page" data-page="3">3</button>
                        </div>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>

        <!-- POPUP THÊM SERIES -->
        <form action="${pageContext.request.contextPath}/AddSeriesServlet" method="post" enctype="multipart/form-data">
            <div class="modal-overlay" id="addSeriesModal">
                <div class="modal-box two-column">

                    <h3>Thêm series mới</h3>

                    <div class="popup-content">

                        <!-- Cột trái -->
                        <div class="left-col">

                            <div class="form-group">
                                <label>Tên series</label>
                                <input type="text" id="newSeriesName" name="seriesName" required>
                            </div>

                            <div class="form-group">
                                <label>Số tập</label>
                                <input type="number" id="newSeriesVolumes" name="seriesVolumes" required min="1">
                            </div>

                            <div class="form-group">
                                <label>Tình trạng</label>
                                <select id="newSeriesStatus" name="seriesStatus">
                                    <option>Đang phát hành</option>
                                    <option>Đã hoàn thành</option>
                                </select>
                            </div>

                            <div class="form-group" >
                                <label>Ngày đăng</label>
                                <input type="date">
                            </div>

                        </div>

                        <!-- Cột phải -->
                        <div class="right-col">

                            <div class="form-group">
                                <label>Ảnh bìa</label>
                                <div class="image-upload-box" id="newSeriesImageBox">
                                    <span>+</span>
                                    <img id="newSeriesPreview" class="preview-img" style="display:none;">
                                </div>
                                <input type="file" id="newSeriesCoverFile" name="seriesCover" accept="image/*" style="display:none;">
                            </div>

                            <div class="form-group">
                                <label>Mô tả</label>
                                <textarea id="newSeriesDescription" name="seriesDescription" rows="6"
                                          placeholder="Nhập mô tả..."></textarea>
                            </div>

                        </div>

                    </div>

                    <div class="button-wrap">
                        <button class="save-btn" id="saveNewSeries">Lưu</button>
                        <button class="cancel-btn close-add-series">Hủy</button>
                    </div>

                </div>
            </div>
        </form>



        <!-- POPUP SỬA SERIES -->
        <div class="modal-overlay" id="editSeriesModal">
            <div class="modal-box two-column">

                <h3>Chỉnh sửa series</h3>

                <div class="popup-content">

                    <!-- Cột trái -->
                    <div class="left-col">

                        <div class="form-group">
                            <label>Tên series</label>
                            <input type="text" id="editSeriesName">
                        </div>

                        <div class="form-group">
                            <label>Số tập</label>
                            <input type="number" id="editSeriesVolumes">
                        </div>

                        <div class="form-group">
                            <label>Tình trạng</label>
                            <select id="editSeriesStatus">
                                <option>Đang phát hành</option>
                                <option>Đã hoàn thành</option>
                                <option>Tạm dừng</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Ngày đăng</label>
                            <input type="date">
                        </div>

                    </div>

                    <!-- Cột phải -->
                    <div class="right-col">

                        <div class="form-group">
                            <label>Ảnh bìa</label>
                            <div class="image-upload-box" id="editSeriesImageBox">
                                <span>+</span>
                                <img src="https://cdn1.fahasa.com/media/catalog/product/t/h/tham-tu-lung-danh-conan_bia_tap-103.jpg">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Mô tả</label>
                            <textarea id="editSeriesDescription" rows="6">Bộ truyện trinh thám nổi tiếng của Gosho Aoyama.</textarea>
                        </div>

                    </div>

                </div>

                <div class="button-wrap">
                    <button class="save-btn" id="saveEditSeries">Cập nhật</button>
                    <button class="cancel-btn close-edit-series">Hủy</button>
                </div>

            </div>
        </div>


    </div>
</div>

<script>
    /* ================= MỞ POPUP THÊM SERIES ================= */
    document.querySelector(".add-btn").addEventListener("click", () => {
        document.getElementById("addSeriesModal").style.display = "flex";
    });

    document.querySelectorAll(".close-add-series").forEach(btn => {
        btn.addEventListener("click", () => {
            document.getElementById("addSeriesModal").style.display = "none";
        });
    });

    /* ================= MỞ POPUP SỬA SERIES ================= */
    document.querySelectorAll(".edit-series-btn").forEach(btn => {
        btn.addEventListener("click", (e) => {

            document.getElementById("editSeriesName").value = btn.dataset.name;
            document.getElementById("editSeriesVolumes").value = btn.dataset.vol;
            document.getElementById("editSeriesStatus").value = btn.dataset.status;

            document.getElementById("editSeriesModal").style.display = "flex";
        });
    });

    document.querySelectorAll(".close-edit-series").forEach(btn => {
        btn.addEventListener("click", () => {
            document.getElementById("editSeriesModal").style.display = "none";
        });
    });

    /* ================= ĐÓNG POPUP KHI CLICK NỀN ================= */
    document.querySelectorAll(".modal-overlay").forEach(overlay => {
        overlay.addEventListener("click", (e) => {
            if (e.target === overlay) {
                overlay.style.display = "none";
            }
        });
    });

    /* ================= ACTIVE SIDEBAR ================= */
    document.addEventListener("DOMContentLoaded", function () {
        const current = window.location.pathname.split("/").pop();
        const links = document.querySelectorAll(".sidebar li a");

        links.forEach(link => {
            const linkPage = link.getAttribute("href");
            if (linkPage === current) link.classList.add("active");
        });
    });

    document.querySelectorAll(".more-btn").forEach(btn => {
        btn.addEventListener("click", function (e) {
            e.stopPropagation();

            const container = this.parentElement;

            // Đóng tất cả menu khác
            document.querySelectorAll(".menu-container").forEach(m => {
                if (m !== container) m.classList.remove("active");
            });

            // Toggle menu hiện tại
            container.classList.toggle("active");
        });
    });

    // Đóng menu khi click ra ngoài
    document.addEventListener("click", () => {
        document.querySelectorAll(".menu-container").forEach(m => m.classList.remove("active"));
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
    (function () {
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('seriesTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row'));
        const pageButtons = document.querySelectorAll('.product-page');

        function showPage(page) {
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => {
                r.style.display = (idx >= start && idx < end) ? "" : "none";
            });

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.product-page[data-page="${page}"]`)?.classList.add('active');
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
    // ===== POPUP THÊM SERIES =====
    const addBox = document.getElementById("newSeriesImageBox");
    const addInput = document.getElementById("newSeriesCoverFile");
    const addPreview = document.getElementById("newSeriesPreview");

    addBox.addEventListener("click", () => addInput.click());

    addInput.addEventListener("change", () => {
        if (addInput.files && addInput.files[0]) {
            const reader = new FileReader();
            reader.onload = e => {
                addPreview.src = e.target.result;
                addPreview.style.display = "block";
            };
            reader.readAsDataURL(addInput.files[0]);
        }
    });

    // ===== POPUP SỬA SERIES =====
    const editBox = document.getElementById("editSeriesImageBox");
    const editInput = document.getElementById("editSeriesCoverFile");
    const editPreview = document.getElementById("editSeriesPreview");

    editBox.addEventListener("click", () => editInput.click());

    editInput.addEventListener("change", () => {
        if (editInput.files && editInput.files[0]) {
            const reader = new FileReader();
            reader.onload = e => {
                editPreview.src = e.target.result;
                editPreview.style.display = "block";
            };
            reader.readAsDataURL(editInput.files[0]);
        }
    });
</script>


</body>
</html>
