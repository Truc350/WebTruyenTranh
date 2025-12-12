<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý thể loại</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleCat.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/adminHeader.css">
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
                <a href="category.html">
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
        <h2 class="page-title">Quản lý thể loại</h2>

        <div class="search-add-container">
            <div class="search-box">
            <input type="text" placeholder="Tìm kiếm thể loại..." class="search-input">
            <i class="fas fa-magnifying-glass"></i>
            </div>

            <button class="add-btn">
                <span>+</span> Thêm thể loại
            </button>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Mã thể loại</th>
                    <th>Tên thể loại</th>
                    <th></th>
                </tr>
                </thead>
                <tbody id="catTableBody">
                <tr>
                    <td>CT01</td>
                    <td>Hành động</td>
                    <td class="action-buttons">
                        <button class="edit-btn" data-id="CT01"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn" data-id="CT01"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>
                <tr>
                    <td>CT02</td>
                    <td>Trinh thám</td>
                    <td class="action-buttons">
                        <button class="edit-btn" data-id="CT02"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn" data-id="CT02"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>
                <tr>
                    <td>CT03</td>
                    <td>Học đường</td>
                    <td class="action-buttons">
                        <button class="edit-btn" data-id="CT03"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn" data-id="CT03"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>
                <tr>
                    <td>CT04</td>
                    <td>Kinh dị</td>
                    <td class="action-buttons">
                        <button class="edit-btn" data-id="CT04"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn" data-id="CT04"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>

                <tr class="pagination-row">
                    <td colspan="10">
                        <div class="pagination">
                            <button class="page-btn cat-page" data-page="1">1</button>
                            <button class="page-btn cat-page" data-page="2">2</button>
                            <button class="page-btn cat-page" data-page="3">3</button>
                        </div>
                    </td>
                </tr>

                </tbody>
            </table>

        </div>
        <!--Thêm thể loại-->
        <div class="popup-overlay" id="addPopup">
            <div class="popup-box">
                <h3>Thêm thể loại</h3>
                <label>Tên thể loại:</label>
                <input type="text" id="newCategoryName">
                <label>Mô tả:</label>
                <textarea id="newCategoryDesc" rows="4"></textarea>
                <label>Ngày tạo:</label>
                <input type="date" id="newCategoryCreatedDate">

                <div class="popup-actions">
                    <button class="save-btn">Lưu</button>
                    <button class="cancel-btn" onclick="closeAddPopup()">Hủy</button>
                </div>
            </div>
        </div>

<!--        Sửa-->
        <!-- Popup SỬA thể loại -->
        <div class="popup-overlay" id="editPopup">
            <div class="popup-box">
                <h3>Chỉnh sửa thể loại</h3>

                <label>Mã thể loại:</label>
                <input type="text" id="editCategoryId" readonly>

                <label>Tên thể loại:</label>
                <input type="text" id="editCategoryName">

                <label>Mô tả:</label>
                <textarea id="editCategoryDesc" rows="4"></textarea>

                <label>Ngày tạo:</label>
                <input type="date" id="editCategoryCreatedDate">

                <div class="popup-actions">
                    <button class="save-btn">Cập nhật</button>
                    <button class="cancel-btn" onclick="closeEditPopup()">Hủy</button>
                </div>
            </div>
        </div>

        <!--        Xóa thể loại-->
        <div class="popup-overlay" id="deletePopup">
            <div class="popup-box">
                <h3>Bạn có chắc muốn xóa?</h3>
                <div class="popup-actions">
                    <button class="save-btn">Xóa</button>
                    <button class="cancel-btn" onclick="closeDeletePopup()">Hủy</button>
                </div>
            </div>
        </div>


    </div>
</div>


<!--js của popup thêm và xóa-->
<script>
    function openAddPopup() {
        document.getElementById("addPopup").style.display = "flex";
    }

    function closeAddPopup() {
        document.getElementById("addPopup").style.display = "none";
    }

    function openDeletePopup() {
        document.getElementById("deletePopup").style.display = "flex";
    }

    function closeDeletePopup() {
        document.getElementById("deletePopup").style.display = "none";
    }

    // Gán sự kiện cho nút Thêm thể loại
    document.querySelector(".add-btn").addEventListener("click", openAddPopup);

    // Gán sự kiện cho nút Xóa trong bảng (tất cả nút Delete)
    document.querySelectorAll(".delete-btn").forEach(btn => {
        btn.addEventListener("click", openDeletePopup);
    });
</script>

<script>
    (function(){
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('catTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row'));
        const pageButtons = document.querySelectorAll('.cat-page');

        function showPage(page){
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => {
                r.style.display = (idx >= start && idx < end) ? "" : "none";
            });

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.cat-page[data-page="${page}"]`)?.classList.add('active');
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

<!--js popup sửa-->
<script>
    // Dữ liệu giả để demo (sau này bạn sẽ lấy từ database)
    const categories = {
        "CT01": { name: "Hành động", desc: "Thể loại truyện hành động, đánh nhau, phiêu lưu...", created: "2025-01-15" },
        "CT02": { name: "Trinh thám", desc: "Truyện suy luận, phá án, bí ẩn...", created: "2025-01-20" },
        "CT03": { name: "Học đường", desc: "Truyện tình cảm tuổi học trò, cuộc sống sinh viên...", created: "2025-02-01" },
        "CT04": { name: "Kinh dị", desc: "Ma quỷ, kinh dị, rùng rợn...", created: "2025-02-10" }
    };

    // Mở popup SỬA
    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.dataset.id;
            const cat = categories[id];

            document.getElementById('editCategoryId').value = id;
            document.getElementById('editCategoryName').value = cat.name;
            document.getElementById('editCategoryDesc').value = cat.desc;
            document.getElementById('editCategoryCreatedDate').value = cat.created;

            document.getElementById('editPopup').style.display = 'flex';
        });
    });

    // Đóng popup SỬA
    function closeEditPopup() {
        document.getElementById('editPopup').style.display = 'none';
    }

    // Đóng tất cả popup khi click ngoài (tùy chọn - rất pro)
    document.querySelectorAll('.popup-overlay').forEach(overlay => {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) {
                this.style.display = 'none';
            }
        });
    });
</script>

</body>
</html>