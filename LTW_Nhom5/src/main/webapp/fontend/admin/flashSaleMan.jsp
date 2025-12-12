<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Quản lý Flash Sale</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleFlashSale.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/adminHeader.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/adminCss/styleSidebar.css">
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
          <span>Quản lý sản phẩm</span>
        </a>
      </li>
      <li>
        <a href="productManagement.jsp">
          <img src="../../img/product.png" class="icon">
          <span>Quản lý series</span>
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
        <a href="flashSaleMan.html">
          <img src="../../img/flashSale.png" class="icon">
          <span>Quản lý Flash Sale</span>
        </a>
      </li>
<%--      <li>--%>
<%--        <a href="promotion.jsp">--%>
<%--          <img src="../../img/promo.png" class="icon">--%>
<%--          <span>Quản lý khuyến mãi</span>--%>
<%--        </a>--%>
<%--      </li>--%>
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
    <h2 class="page-title">Quản lý Flash Sale</h2>
    <div class="flashSale-page">

      <div class="flashSale-header">
        <div class="search-box">
          <input type="text" id="searchInput" placeholder="Tìm kiếm mã...">
          <i class="fas fa-magnifying-glass"></i>
        </div>

        <button class="btn-add" id="openAddPopup">
          <i class="fas fa-plus"></i> Tạo Flash Sale
        </button>
      </div>

      <!-- Danh sách Flash Sale -->
      <div class="flashSale-list">

        <table class="flashSale-table">
          <thead>
          <tr>
            <th>Mã Flash Sale</th>
            <th>Tên Flash Sale</th>
            <th>Thời gian</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
          </tr>
          </thead>

          <tbody id="flashSaleTableBody">
          <!-- Demo -->
          <tr>
            <td>1</td>
            <td>Flash Sale 10:00 - Mừng Noel</td>
            <td>10:00 24/12/2024 → 12:00 24/12/2024</td>
            <td><span class="status active">Đang diễn ra</span></td>
            <td class="action">
              <button class="btn-view"><i class="fa-solid fa-eye"></i></button>
              <button class="btn-edit openEditFlashSale"><i class="fa-solid fa-pen-to-square"></i></button>
              <button class="btn-delete"><i class="fa-solid fa-trash"></i></button>
            </td>
          </tr>
          <tr>
            <td>2</td>
            <td>Flash Sale 00:00 - New Year</td>
            <td>00:00 01/01/2025 → 02:00 01/01/2025</td>
            <td><span class="status upcoming">Sắp diễn ra</span></td>
            <td class="action">
              <button class="btn-view"><i class="fa-solid fa-eye"></i></button>
              <button class="btn-edit openEditFlashSale"><i class="fa-solid fa-pen-to-square"></i></button>
              <button class="btn-delete"><i class="fa-solid fa-trash"></i></button>
            </td>
          </tr>
          <tr>
            <td>3</td>
            <td>Flash Sale Giữa Tháng</td>
            <td>08:00 10/12/2024 → 09:00 10/12/2024</td>
            <td><span class="status end">Đã diễn ra</span></td>
            <td class="action">
              <button class="btn-view"><i class="fa-solid fa-eye"></i></button>
              <button class="btn-edit openEditFlashSale"><i class="fa-solid fa-pen-to-square"></i></button>
              <button class="btn-delete"><i class="fa-solid fa-trash"></i></button>
            </td>
          </tr>
          </tbody>
        </table>

      </div>
    </div>
  </div>
</div>

<!-- POPUP THÊM FLASH SALE -->
<div class="modal-overlay" id="addFlashSaleModal">
  <div class="modal-flashsale">
    <h3>Tạo Flash Sale</h3>

    <form id="addFlashSaleForm">
      <div class="form-row">
        <div>
          <label>Tên Flash Sale:</label>
          <input type="text" placeholder="Flash Sale 10:00 - Cuối tuần">
        </div>

        <div>
          <label>Giờ bắt đầu:</label>
          <input type="datetime-local">
        </div>

        <div>
          <label>Giờ kết thúc:</label>
          <input type="datetime-local">
        </div>
      </div>

      <h4>Áp dụng cho thể loại:</h4>
      <div class="category-select-list">
        <label><input type="checkbox"> Hành động</label>
        <label><input type="checkbox"> Phiêu lưu</label>
        <label><input type="checkbox"> Lãng mạn</label>
        <label><input type="checkbox"> Học đường</label>
        <label><input type="checkbox"> Kinh dị</label>
        <label><input type="checkbox"> Hài hước</label>
        <label><input type="checkbox"> Giả tưởng</label>
        <label><input type="checkbox"> Trinh thám</label>
      </div>

      <h4>Chọn sản phẩm áp dụng:</h4>

      <div class="product-select-list">
        <label>
          <input type="checkbox">
          Thám tử lừng danh Conan – Tập 12 – Gosho Aoyama
          <input class="percent-input" type="number" min="1" max="90" placeholder="Giảm %">
          <input class="qty-input" type="number" min="1" placeholder="Số lượng">
        </label>

        <label>
          <input type="checkbox">
          One Piece – Tập 100 – Eiichiro Oda
          <input class="percent-input" type="number" min="1" max="90" placeholder="Giảm %">
          <input class="qty-input" type="number" min="1" placeholder="Số lượng">
        </label>

        <label>
          <input type="checkbox">
          One Piece – Tập 203 – Eiichiro Oda
          <input class="percent-input" type="number" min="1" max="90" placeholder="Giảm %">
          <input class="qty-input" type="number" min="1" placeholder="Số lượng">
        </label>
        <label>
          <input type="checkbox">
          One Piece – Tập 401 – Eiichiro Oda
          <input class="percent-input" type="number" min="1" max="90" placeholder="Giảm %">
          <input class="qty-input" type="number" min="1" placeholder="Số lượng">
        </label>
      </div>

      <div class="flashsale-buttons">
        <button type="button" class="cancel-btn" id="closeAddFlashSale">Hủy</button>
        <button type="submit" class="save-btn">Tạo Flash Sale</button>
      </div>
    </form>
  </div>
</div>

<!-- POPUP SỬA -->
<div class="modal-overlay" id="editFlashSaleModal">
  <div class="modal-flashsale">
    <h3>Chỉnh sửa Flash Sale</h3>

    <form id="editFlashSaleForm">
      <div class="form-row">
        <div>
          <label>Tên Flash Sale:</label>
          <input type="text" value="Flash Sale 10:00 - Mừng Noel">
        </div>

        <div>
          <label>Giờ bắt đầu:</label>
          <input type="datetime-local" value="2024-12-24T10:00">
        </div>

        <div>
          <label>Giờ kết thúc:</label>
          <input type="datetime-local" value="2024-12-24T12:00">
        </div>
      </div>

      <h4>Áp dụng cho thể loại:</h4>
      <div class="category-select-list">
        <label><input type="checkbox"> Hành động</label>
        <label><input type="checkbox"> Phiêu lưu</label>
        <label><input type="checkbox"> Lãng mạn</label>
        <label><input type="checkbox"> Học đường</label>
        <label><input type="checkbox"> Kinh dị</label>
        <label><input type="checkbox"> Hài hước</label>
        <label><input type="checkbox"> Giả tưởng</label>
        <label><input type="checkbox"> Trinh thám</label>
      </div>

      <h4>Sản phẩm áp dụng:</h4>

      <div class="product-select-list">
        <label>
          <input type="checkbox" checked>
          Thám tử lừng danh Conan – Tập 12 – Gosho Aoyama
          <input class="percent-input" type="number" value="40" min="1" max="90">
          <input class="qty-input" type="number" value="100" min="1">
        </label>

        <label>
          <input type="checkbox" checked>
          One Piece – Tập 100 – Eiichiro Oda
          <input class="percent-input" type="number" value="50" min="1" max="90">
          <input class="qty-input" type="number" value="50" min="1">
        </label>
      </div>

      <div class="flashsale-buttons">
        <button type="button" class="cancel-btn" id="closeEditFlashSale">Hủy</button>
        <button type="submit" class="save-btn">Cập nhật</button>
      </div>
    </form>
  </div>
</div>

<!-- POPUP XEM CHI TIẾT FLASH SALE -->
<div class="modal-overlay" id="viewFlashSaleModal">
  <div class="modal-flashsale">
    <h3>Chi tiết Flash Sale</h3>

    <div class="view-info-box">

      <p><strong>Mã Flash Sale:</strong> FS001</p>
      <p><strong>Tên Flash Sale:</strong> Flash Sale 10:00 - Mừng Noel</p>
      <p><strong>Thời gian:</strong> 10:00 24/12/2024 → 12:00 24/12/2024</p>
      <p><strong>Trạng thái:</strong> <span class="status active">Đang diễn ra</span></p>

      <h4>Thể loại áp dụng:</h4>
      <ul class="view-category-list">
        <li>Hành động</li>
        <li>Phiêu lưu</li>
        <li>Học đường</li>
      </ul>

      <h4>Sản phẩm áp dụng:</h4>
      <div class="view-product-list">
        <div class="item">
          <span>Thám tử lừng danh Conan – Tập 12 – Gosho Aoyama</span>
          <span>Giảm: 40%</span>
          <span>Số lượng: 100</span>
        </div>

        <div class="item">
          <span>One Piece – Tập 100 – Eiichiro Oda</span>
          <span>Giảm: 50%</span>
          <span>Số lượng: 50</span>
        </div>
      </div>

      <div class="flashsale-buttons">
        <button type="button" class="cancel-btn" id="closeViewFlashSale">Đóng</button>
      </div>
    </div>
  </div>
</div>

<!-- POPUP XÓA FLASH SALE -->
<div class="modal-overlay" id="deleteFlashSaleModal">
  <div class="modal-delete">
    <h3>Xác nhận xóa</h3>
    <p>Bạn có chắc muốn xóa Flash Sale này không?</p>

    <div class="delete-buttons">
      <button class="cancel-btn" id="closeDeleteFlashSale">Hủy</button>
      <button class="delete-confirm-btn" id="confirmDeleteFlashSale">Xóa</button>
    </div>
  </div>
</div>



<script>
  document.getElementById("openAddPopup").onclick = () => {
    document.getElementById("addFlashSaleModal").style.display = "flex";
  }
  document.getElementById("closeAddFlashSale").onclick = () => {
    document.getElementById("addFlashSaleModal").style.display = "none";
  }

  document.querySelectorAll(".openEditFlashSale").forEach(btn => {
    btn.onclick = () => {
      document.getElementById("editFlashSaleModal").style.display = "flex";
    };
  });

  document.getElementById("closeEditFlashSale").onclick = () => {
    document.getElementById("editFlashSaleModal").style.display = "none";
  }

  document.querySelectorAll(".btn-view").forEach(btn => {
    btn.onclick = () => {
      document.getElementById("viewFlashSaleModal").style.display = "flex";
    };
  });

  document.getElementById("closeViewFlashSale").onclick = () => {
    document.getElementById("viewFlashSaleModal").style.display = "none";
  }

  document.querySelectorAll(".btn-delete").forEach(btn => {
    btn.onclick = () => {
      document.getElementById("deleteFlashSaleModal").style.display = "flex";
    };
  });

  document.getElementById("closeDeleteFlashSale").onclick = () => {
    document.getElementById("deleteFlashSaleModal").style.display = "none";
  };
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
