<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Khuyến mãi</title>
    <link rel="stylesheet" href="../css/adminCss/stylePromotion.css">
    <link rel="stylesheet" href="../css/adminCss/adminHeader.css">
    <link rel="stylesheet" href="../css/adminCss/styleSidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <jsp:include page="/fontend/admin/ASide.jsp"/>
<%--    <aside class="sidebar">--%>
<%--        <div class="sidebar-header">--%>
<%--            <img src="../../img/logo.png" alt="Logo" class="logo">--%>
<%--            <h2>Comic Store</h2>--%>
<%--        </div>--%>

<%--        <ul>--%>
<%--            <li>--%>
<%--                <a href="dashboard.jsp">--%>
<%--                <img src="../../img/home.png" class="icon">--%>
<%--                <span>Trang chủ</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="productManagement.jsp">--%>
<%--                    <img src="../../img/product.png" class="icon">--%>
<%--                    <span>Quản lý sản phẩm</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="category.jsp">--%>
<%--                    <img src="../../img/category.png" class="icon">--%>
<%--                    <span>Quản lý thể loại</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="order.jsp">--%>
<%--                    <img src="../../img/order.png" class="icon">--%>
<%--                    <span>Quản lý đơn hàng</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="userManagement.jsp">--%>
<%--                    <img src="../../img/user.png" class="icon">--%>
<%--                    <span>Quản lý người dùng</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--            <li>--%>
<%--                <a href="flashSaleMan.jsp">--%>
<%--                    <img src="../../img/flashSale.png" class="icon">--%>
<%--                    <span>Quản lý Flash Sale</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--&lt;%&ndash;            <li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <a href="promotion.html">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <img src="../../img/promo.png" class="icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <span>Quản lý khuyến mãi</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </li>&ndash;%&gt;--%>
<%--            <li>--%>
<%--                <a href="report.jsp">--%>
<%--                    <img src="../../img/report.png" class="icon">--%>
<%--                    <span>Thống kê</span>--%>
<%--                </a>--%>
<%--            </li>--%>
<%--        </ul>--%>
<%--    </aside>--%>

    <div class="main-content">
        <jsp:include page="/fontend/admin/HeaderAdmin.jsp"/>
<%--        <header class="admin-header">--%>
<%--            <div class="header-right">--%>
<%--                <a href="chatWithCus.jsp">--%>
<%--                    <i class="fa-solid fa-comment"></i>--%>
<%--                </a>--%>

<%--                <div class="admin-profile">--%>
<%--                    <a href="profileAdmin.jsp">--%>
<%--                    <img src="../../img/admin.png" class="admin-avatar" alt="Admin">--%>
<%--                    </a>--%>
<%--                    <span class="admin-name">Admin</span>--%>
<%--                </div>--%>

<%--                <!-- Nút đăng xuất -->--%>
<%--                <button class="btn-logout" title="Đăng xuất">--%>
<%--                    <a href="../public/login_bo.jsp">--%>
<%--                        <i class="fa-solid fa-right-from-bracket"></i>--%>
<%--                    </a>--%>
<%--                </button>--%>
<%--            </div>--%>
<%--        </header>--%>

        <div class="promotion-page">

            <!-- Thanh tìm kiếm + nút thêm -->
            <div class="promo-top">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Tìm kiếm mã...">
                    <i class="fas fa-magnifying-glass"></i>
                </div>

                <button class="btn-add" id="openAddPopup">
                    <i class="fas fa-plus"></i> Thêm mã
                </button>

                <select id="statusFilter">
                    <option value="">Tất cả trạng thái</option>
                    <option value="running">Đang chạy</option>
                    <option value="expired">Hết hạn</option>
                    <option value="out">Hết lượt</option>
                </select>
            </div>

            <!-- Bảng danh sách -->
            <table class="promo-table">
                <thead>
                <tr>
                    <th>Mã giảm giá</th>
                    <th>Giá trị</th>
                    <th>Loại</th>
                    <th>Đã dùng/Tổng</th>
                    <th>Đơn tối thiểu</th>
                    <th>Hạn sử dụng</th>
                    <th>Trạng thái</th>
                    <th></th>
                </tr>
                </thead>

                <tbody id="promoTableBody">
                <tr>
                    <td>NEWUSER10</td>
                    <td>10%</td>
                    <td>Phần trăm</td>
                    <td>54/100</td>
                    <td>0đ</td>
                    <td>01/02/2026</td>
                    <td><span class="status-active">Đang chạy</span></td>
                    <td>
                        <button class="edit-btn" onclick="openEdit('NEWUSER10')"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>

                <tr>
                    <td>SIEUSALE15</td>
                    <td>15%</td>
                    <td>Phần trăm</td>
                    <td>0/50</td>
                    <td>50.000đ</td>
                    <td>08/10/2025</td>
                    <td><span class="status-out">Hết lượt</span></td>
                    <td>
                        <button class="edit-btn" onclick="openEdit('SIEUSALE15')"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>

                <tr>
                    <td>FREESHIP20</td>
                    <td>-20.000đ</td>
                    <td>Cố định</td>
                    <td>120/200</td>
                    <td>199.000đ</td>
                    <td>31/12/2025</td>
                    <td><span class="status-active">Đang chạy</span></td>
                    <td>
                        <button class="edit-btn" onclick="openEdit('FREESHIP20')"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>

                <tr>
                    <td>BLACKFRIDAY50</td>
                    <td>50%</td>
                    <td>Phần trăm</td>
                    <td>80/300</td>
                    <td>500.000đ</td>
                    <td>27/11/2025</td>
                    <td><span class="status-active">Đang chạy</span></td>
                    <td>
                        <button class="edit-btn" onclick="openEdit('BLACKFRIDAY50')"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>

                <tr>
                    <td>WELCOME5</td>
                    <td>15.000đ</td>
                    <td>Cố định</td>
                    <td>70/150</td>
                    <td>80.000đ</td>
                    <td>14/06/2025</td>
                    <td><span class="status-out">Hết lượt</span></td>
                    <td>
                        <button class="edit-btn" onclick="openEdit('WELCOME5')"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>

                <tr>
                    <td>VIPMEMBER30</td>
                    <td>30%</td>
                    <td>Phần trăm</td>
                    <td>40/80</td>
                    <td>100.000đ</td>
                    <td>19/09/2025</td>
                    <td><span class="status-active">Đang chạy</span></td>
                    <td>
                        <button class="edit-btn" onclick="openEdit('VIPMEMBER30')"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>

                <tr>
                    <td>TET2026</td>
                    <td>-50.000đ</td>
                    <td>Cố định</td>
                    <td>200/500</td>
                    <td>199.000đ</td>
                    <td>10/02/2026</td>
                    <td><span class="status-active">Đang chạy</span></td>
                    <td>
                        <button class="edit-btn" onclick="openEdit('TET2026')"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>

                <!-- Phân trang -->
                <tr class="pagination-row">
                    <td colspan="10">
                        <div class="pagination" id="tablePagination">
                            <button class="page-btn pro-page" data-page="1">1</button>
                            <button class="page-btn pro-page" data-page="2">2</button>
                            <button class="page-btn pro-page" data-page="3">3</button>
                        </div>
                    </td>
                </tr>

                </tbody>
            </table>

        </div>
    </div>
</div>
<!-- POPUP THÊM MÃ  -->
<div class="popup-overlay" id="addPopup">
    <div class="popup-box">
        <h3>Thêm mã khuyến mãi</h3>

        <div class="popup-grid">
            <!-- Dòng 1: Mã + Loại -->
            <div>
                <label>Tên mã</label>
                <input type="text" id="addCode" placeholder="NEWUSER10" maxlength="20">
            </div>
            <div>
                <label>Loại</label>
                <select id="addType" required>
                    <option value="">Chọn loại</option>
                    <option value="percent">Phần trăm (%)</option>
                    <option value="fixed">Số tiền (₫)</option>
                </select>
            </div>

            <!-- Dòng 2: Giá trị + Đơn tối thiểu -->
            <div>
                <label>Giá trị giảm</label>
                <input type="number" id="addValue" min="0" placeholder="10 hoặc 20000">
            </div>
            <div>
                <label>Đơn tối thiểu</label>
                <input type="number" id="addMinOrder" min="0" placeholder="0" value="0">
            </div>

            <!-- Dòng 3: Số lượng + Áp dụng cho -->
            <div>
                <label>Số lượng tối đa</label>
                <input type="number" id="addMaxUsage" min="1" value="100">
            </div>
            <div>
                <label>Áp dụng</label>
                <select id="addApply">
                    <option value="all">Toàn bộ sản phẩm</option>
                    <option value="category">Một thể loại</option>
                </select>
            </div>

            <!-- Checkbox 1 lần/khách -->
            <div class="checkbox-row">
                <input type="checkbox" id="addSingleUse">
                <label for="addSingleUse">Mỗi khách chỉ dùng 1 lần</label>
            </div>

            <!-- Chọn thể loại (ẩn mặc định) -->
            <div id="addCategoryBox" style="grid-column: 1 / -1;">
                <label>Thể loại</label>
                <select id="addCategory" disabled>
                    <option value="">-- Chọn thể loại --</option>
                    <option>Trinh thám</option>
                    <option>Hài hước</option>
                    <option>Ngôn tình</option>
                    <option>Hành động</option>
                    <option>Kinh dị</option>
                    <option>Phiêu lưu</option>
                    <option>Học đường</option>
                    <option>Giả tưởng</option>
                </select>
            </div>

            <!-- Ngày bắt đầu + kết thúc -->
            <div class="date-row">
                <div>
                    <label>Từ ngày</label>
                    <input type="date" id="addStart">
                </div>
                <div>
                    <label>Đến ngày</label>
                    <input type="date" id="addEnd">
                </div>
            </div>
        </div>

        <div class="btn-row">
            <button class="btn-cancel" id="closeAddPopup">Hủy</button>
            <button class="btn-save" id="saveAddBtn">Tạo mã</button>
        </div>
    </div>
</div>
<!-- ====================== POPUP SỬA MÃ====================== -->
<div class="popup-overlay" id="editPopup">
    <div class="popup-box">
        <h3>Sửa mã khuyến mãi</h3>
        <div class="popup-grid">
            <!-- Dòng 1: Mã + Loại -->
            <div>
                <label>Tên mã</label>
                <p id="editCode" class="readonly"></p>
            </div>
            <div>
                <label>Loại giảm giá</label>
                <p id="editTypeDisplay" class="readonly"></p>
            </div>

            <!-- Dòng 2: Giá trị + Áp dụng cho (không chỉnh được) -->
            <div>
                <label>Giá trị giảm</label>
                <p id="editValueDisplay" class="readonly"></p>
            </div>
            <div>
                <label>Áp dụng cho</label>
                <p id="editApplyDisplay" class="readonly">Toàn bộ sản phẩm</p>
            </div>

            <!-- Dòng 3: Đơn tối thiểu + Số lượng tối đa -->
            <div>
                <label>Đơn tối thiểu</label>
                <input type="number" id="editMinOrder" min="0" placeholder="0">
            </div>
            <div>
                <label>Số lượng tối đa</label>
                <input type="number" id="editMaxUsage" min="1">
            </div>

            <!-- Checkbox giới hạn 1 lần/khách -->
            <div class="checkbox-row">
                <input type="checkbox" id="editSingleUse">
                <label for="editSingleUse">Mỗi khách chỉ dùng được 1 lần</label>
            </div>

            <!-- Ngày bắt đầu & kết thúc -->
            <div class="date-row">
                <div>
                    <label>Từ ngày</label>
                    <input type="date" id="editStart">
                </div>
                <div>
                    <label>Đến ngày</label>
                    <input type="date" id="editEnd">
                </div>
            </div>
        </div>

        <div class="btn-row">
            <button class="btn-cancel" id="closeEditPopup">Hủy</button>
            <button class="btn-save" id="saveEditBtn">Cập nhật</button>
        </div>
    </div>
</div>

<!-- Popup xác nhận xóa -->
<div class="popup-overlay" id="deleteConfirmPopup">
    <div class="popup-box small">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <h3>Xác nhận xóa</h3>
        <p>Bạn có chắc muốn xóa mã này không?<br></p>
        <div class="btn-row">
            <button class="btn-cancel" id="cancelDeleteBtn">Không</button>
            <button class="btn-save" id="confirmDeleteBtn">Có</button>
        </div>
    </div>
</div>


<script>
    document.addEventListener("DOMContentLoaded", function () {
        const addPopup       = document.getElementById('addPopup');
        const addApply       = document.getElementById('addApply');
        const addCategoryBox = document.getElementById('addCategoryBox');
        const tbody          = document.getElementById('promoTableBody');
        const editPopup      = document.getElementById('editPopup');
        const deletePopup    = document.getElementById('deleteConfirmPopup');

        // Hàm ẩn/hiện thể loại
        const toggleCategory = () => {
            addCategoryBox.classList.toggle('hide', addApply.value !== 'category');
        };

        // Gắn event change
        addApply.addEventListener('change', () => {
            const categorySelect = document.getElementById('addCategory');
            if (addApply.value === 'category') {
                categorySelect.disabled = false;
                categorySelect.style.opacity = '1';
                categorySelect.style.pointerEvents = 'auto';
            } else {
                categorySelect.disabled = true;
                categorySelect.style.opacity = '0.5';
                categorySelect.style.pointerEvents = 'none';
                categorySelect.value = ''; // xóa lựa chọn cũ
            }
        });

        // Mở popup Thêm
        document.getElementById('openAddPopup').onclick = () => {
            addPopup.style.display = 'flex';

            // Reset form
            document.getElementById('addCode').value = '';
            document.getElementById('addType').value = '';
            document.getElementById('addValue').value = '';
            document.getElementById('addMinOrder').value = '0';
            document.getElementById('addMaxUsage').value = '100';
            document.getElementById('addSingleUse').checked = false;
            document.getElementById('addStart').value = '';
            document.getElementById('addEnd').value = '';
            addApply.value = 'all';

            document.getElementById('addCategory').disabled = true;
            document.getElementById('addCategory').style.opacity = '0.5';
            document.getElementById('addCategory').value = '';
        };

        document.getElementById('closeAddPopup').onclick = () => addPopup.style.display = 'none';

        // Tạo mã
        document.getElementById('saveAddBtn').onclick = () => {
            const code = document.getElementById('addCode').value.trim();
            const type = document.getElementById('addType').value;
            const value = document.getElementById('addValue').value;

            if (!code || !type || !value) {
                alert('Vui lòng nhập đầy đủ thông tin bắt buộc!');
                return;
            }
            if (addApply.value === 'category' && !document.getElementById('addCategory').value) {
                alert('Vui lòng chọn thể loại!');
                return;
            }

            alert('Tạo mã thành công!');
            addPopup.style.display = 'none';
        };

        // Popup Sửa
        window.openEdit = function(code) {
            const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row'));
            const row = rows.find(r => r.cells[0].textContent.trim() === code);
            if (!row) return alert('Không tìm thấy mã!');

            document.getElementById('editCode').textContent = row.cells[0].textContent.trim();
            document.getElementById('editValueDisplay').textContent = row.cells[1].textContent.trim();
            document.getElementById('editTypeDisplay').textContent = row.cells[2].textContent.trim();
            document.getElementById('editApplyDisplay').textContent = 'Toàn bộ sản phẩm';

            const minOrder = row.cells[4].textContent.replace(/[^\d]/g, '');
            document.getElementById('editMinOrder').value = minOrder || 0;

            const usage = row.cells[3].textContent.trim();
            const maxUsage = usage.split('/')[1]?.trim() || '100';
            document.getElementById('editMaxUsage').value = maxUsage.replace(/\D/g, '');

            const [d, m, y] = row.cells[5].textContent.trim().split('/');
            document.getElementById('editEnd').value = `${y}-${m.padStart(2,'0')}-${d.padStart(2,'0')}`;

            document.getElementById('editSingleUse').checked = false;
            document.getElementById('editStart').value = '';

            editPopup.style.display = 'flex';
        };

        document.getElementById('closeEditPopup').onclick = () => editPopup.style.display = 'none';
        document.getElementById('saveEditBtn').onclick = () => {
            alert('Cập nhật thành công!');
            editPopup.style.display = 'none';
        };

        // Xóa
        tbody.addEventListener('click', e => {
            if (e.target.closest('.delete-btn')) deletePopup.style.display = 'flex';
        });
        document.getElementById('cancelDeleteBtn').onclick = () => deletePopup.style.display = 'none';
        document.getElementById('confirmDeleteBtn').onclick = () => {
            alert('Đã xóa mã!');
            deletePopup.style.display = 'none';
        };

        // Click ngoài đóng popup
        [addPopup, editPopup, deletePopup].forEach(p => {
            p.addEventListener('click', e => e.target === p && (p.style.display = 'none'));
        });

        // PHÂN TRANG
        const ROWS_PER_PAGE = 5;
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row'));

        document.querySelectorAll('.pro-page').forEach(btn => {
            btn.onclick = () => {
                const page = +btn.dataset.page;
                rows.forEach((row, i) => {
                    row.style.display = (i >= (page-1)*ROWS_PER_PAGE && i < page*ROWS_PER_PAGE) ? '' : 'none';
                });
                document.querySelectorAll('.pro-page').forEach(b => b.classList.toggle('active', +b.dataset.page === page));
            };
        });
        document.querySelector('.pro-page[data-page="1"]')?.click();

        // Active sidebar
        const currentPage = window.location.pathname.split("/").pop();
        document.querySelectorAll(".sidebar a").forEach(link => {
            if (link.getAttribute("href") === currentPage) {
                link.classList.add("active");
            }
        });
    });
</script>
<script>
    (function(){
        let currentPage = 1;
        const ROWS_PER_PAGE = 5;
        const tbody = document.getElementById('promoTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('pagination-row'));
        const pageButtons = document.querySelectorAll('.pro-page');

        function showPage(page){
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;

            rows.forEach((r, idx) => {
                r.style.display = (idx >= start && idx < end) ? "" : "none";
            });

            pageButtons.forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.pro-page[data-page="${page}"]`)?.classList.add('active');

            currentPage = page;
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