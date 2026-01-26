<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
    <jsp:include page="/fontend/admin/ASide.jsp"/>


    <div class="main-content">
        <%@ include file="HeaderAdmin.jsp" %>

        <h2 class="page-title">Quản lý series</h2>

        <!-- Toast Notification -->
        <c:if test="${not empty successMessage}">
            <div class="toast-notification success" id="toastNotification">
                <i class="fas fa-check-circle"></i>
                <span>${successMessage}</span>
                <button class="toast-close" onclick="closeToast()">&times;</button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="toast-notification error" id="toastNotification">
                <i class="fas fa-exclamation-circle"></i>
                <span>${errorMessage}</span>
                <button class="toast-close" onclick="closeToast()">&times;</button>
            </div>
        </c:if>

        <div class="search-add-container">
            <form action="${pageContext.request.contextPath}/SeriesManagement" method="get" class="search-box">
                <input type="text" name="keyword" placeholder="Tìm kiếm series..." class="search-input"
                       value="${keyword}">
                <button type="submit"><i class="fas fa-magnifying-glass"></i></button>
            </form>
            <%--            Loc trang thai an hien--%>
            <%-- Lọc trạng thái ẩn hiện --%>
            <div class="filter-container">
                <label for="visibilityFilter" class="filter-label">
                    <i class="fas fa-filter"></i>
                </label>
                <select id="visibilityFilter" class="filter-select">
                    <option value="all" ${empty param.filter || param.filter == 'all' ? 'selected' : ''}>
                        🌐 Tất cả
                    </option>
                    <option value="visible" ${param.filter == 'visible' ? 'selected' : ''}>
                        👁️ Đang hiển thị
                    </option>
                    <option value="hidden" ${param.filter == 'hidden' ? 'selected' : ''}>
                        🔒 Đang ẩn
                    </option>
                </select>
            </div>

            <button class="add-btn" id="openAddModal">
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
                <c:forEach var="s" items="${seriesList}">
                    <tr>
                        <td>${s.id}</td>
                        <td>${s.seriesName}</td>
                        <td>${s.totalVolumes} tập</td>
                        <td>${s.status}</td>
                        <td class="action-cell">
                            <div class="action-wrapper">
                                <button class="edit-series-btn"
                                        data-id="${s.id}"
                                        data-name="${s.seriesName}"
                                        data-vol="${s.totalVolumes}"
                                        data-status="${s.status}"
                                        data-desc="${s.description}"
                                        data-cover="${s.coverUrl}">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>

                                <button class="delete-series-btn"
                                        data-id="${s.id}"
                                        data-name="${s.seriesName}"
                                        title="Xóa series">
                                    <i class="fa-solid fa-trash"></i>
                                </button>

                                <div class="menu-container">
                                    <button class="more-btn">⋮</button>
                                    <div class="dropdown-menu">
                                        <input type="hidden" class="series-id" value="${s.id}">
                                        <label>
                                            <input type="radio" name="display_S${s.id}"
                                                   value="show" ${!s.hidden ? 'checked' : ''}> Hiển thị
                                        </label>
                                        <label>
                                            <input type="radio" name="display_S${s.id}"
                                                   value="hide" ${s.hidden ? 'checked' : ''}> Ẩn đi
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <%--                <tr class="pagination-row">--%>
                <%--                    <td colspan="10">--%>
                <%--                        <div class="pagination">--%>
                <%--                            <c:forEach var="i" begin="1" end="${totalPages}">--%>
                <%--                                <button class="page-btn ${i == currentPage ? 'active' : ''}"--%>
                <%--                                        onclick="window.location.href='${pageContext.request.contextPath}/SeriesManagement?page=${i}'">--%>
                <%--                                        ${i}--%>
                <%--                                </button>--%>
                <%--                            </c:forEach>--%>
                <%--                        </div>--%>
                <%--                    </td>--%>
                <%--                </tr>--%>
                <tr class="pagination-row">
                    <td colspan="10">
                        <div class="pagination">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:set var="pageUrl"
                                       value="${pageContext.request.contextPath}/SeriesManagement?page=${i}"/>
                                <c:if test="${not empty param.filter}">
                                    <c:set var="pageUrl" value="${pageUrl}&filter=${param.filter}"/>
                                </c:if>
                                <c:if test="${not empty keyword}">
                                    <c:set var="pageUrl" value="${pageUrl}&keyword=${keyword}"/>
                                </c:if>

                                <button class="page-btn ${i == currentPage ? 'active' : ''}"
                                        onclick="window.location.href='${pageUrl}'">
                                        ${i}
                                </button>
                            </c:forEach>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- POPUP THÊM SERIES -->
    <form action="${pageContext.request.contextPath}/AddSeriesServlet" method="post" enctype="multipart/form-data"
          id="addSeriesForm">
        <div class="modal-overlay" id="addSeriesModal">
            <div class="modal-box two-column">
                <h3>Thêm series</h3>
                <div class="popup-content">
                    <div class="left-col">
                        <div class="form-group">
                            <label>Tên series *</label>
                            <input type="text" name="seriesName" required>
                        </div>
                        <div class="form-group">
                            <label>Số tập *</label>
                            <input type="number" name="seriesVolumes" required min="1">
                        </div>
                        <div class="form-group">
                            <label>Tình trạng *</label>
                            <select name="seriesStatus" required>
                                <option>Đang phát hành</option>
                                <option>Đã hoàn thành</option>
                            </select>
                        </div>
                    </div>

                    <div class="right-col">
                        <div class="form-group">
                            <label>Ảnh bìa</label>
                            <div class="image-upload-box" id="newSeriesImageBox">
                                <span>+</span>
                                <img id="newSeriesPreview" class="preview-img" style="display:none;">
                            </div>
                            <input type="file" id="newSeriesCoverFile" name="seriesCover" accept="image/*"
                                   style="display:none;">
                        </div>
                        <div class="form-group">
                            <label>Mô tả</label>
                            <textarea name="seriesDescription" rows="6" placeholder="Nhập mô tả..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="button-wrap">
                    <button type="submit" class="save-btn">Lưu</button>
                    <button type="button" class="cancel-btn close-add-series">Hủy</button>
                </div>
            </div>
        </div>
    </form>

    <!-- POPUP SỬA SERIES -->
    <form action="${pageContext.request.contextPath}/EditSeriesServlet" method="post" enctype="multipart/form-data"
          id="editSeriesForm">
        <div class="modal-overlay" id="editSeriesModal">
            <div class="modal-box two-column">
                <h3>Chỉnh sửa series</h3>
                <input type="hidden" id="editSeriesId" name="seriesId">

                <div class="popup-content">
                    <div class="left-col">
                        <div class="form-group">
                            <label>Tên series *</label>
                            <input type="text" id="editSeriesName" name="seriesName" required>
                        </div>
                        <div class="form-group">
                            <label>Số tập *</label>
                            <input type="number" id="editSeriesVolumes" name="seriesVolumes" required min="1">
                        </div>
                        <div class="form-group">
                            <label>Tình trạng *</label>
                            <select id="editSeriesStatus" name="seriesStatus" required>
                                <option>Đang phát hành</option>
                                <option>Đã hoàn thành</option>
                                <option>Tạm dừng</option>
                            </select>
                        </div>
                    </div>

                    <div class="right-col">
                        <div class="form-group">
                            <label>Ảnh bìa</label>
                            <div class="image-upload-box" id="editSeriesImageBox">
                                <span>+</span>
                                <img id="editSeriesPreview" class="preview-img" style="display:none;">
                            </div>
                            <input type="file" id="editSeriesCoverFile" name="seriesCover" accept="image/*"
                                   style="display:none;">
                        </div>
                        <div class="form-group">
                            <label>Mô tả</label>
                            <textarea id="editSeriesDescription" name="seriesDescription" rows="6"></textarea>
                        </div>
                    </div>
                </div>

                <div class="button-wrap">
                    <button type="submit" class="save-btn">Cập nhật</button>
                    <button type="button" class="cancel-btn close-edit-series">Hủy</button>
                </div>
            </div>
        </div>
    </form>

    <!-- POPUP XÁC NHẬN XÓA -->
    <div class="modal-overlay" id="deleteConfirmModal">
        <div class="modal-box confirm-dialog">
            <div class="confirm-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3>Xác nhận xóa series</h3>
            <p>Bạn có chắc chắn muốn xóa series "<span id="deleteSeriesName"></span>" không?</p>
            <p class="warning-text">Hành động này không thể hoàn tác!</p>

            <div class="button-wrap">
                <button class="delete-confirm-btn" id="confirmDeleteBtn">Xóa</button>
                <button class="cancel-btn" id="cancelDeleteBtn">Hủy</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Biến toàn cục để lưu ID series cần xóa
    // Mở popup thêm series
    document.getElementById("openAddModal").addEventListener("click", () => {
        document.getElementById("addSeriesModal").style.display = "flex";
    });

    // Đóng popup thêm
    document.querySelectorAll(".close-add-series").forEach(btn => {
        btn.addEventListener("click", (e) => {
            e.preventDefault();
            document.getElementById("addSeriesModal").style.display = "none";
        });
    });

    // Upload ảnh cho popup THÊM
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
                addBox.querySelector("span").style.display = "none";
            };
            reader.readAsDataURL(addInput.files[0]);
        }
    });

    // Mở popup sửa series
    document.querySelectorAll(".edit-series-btn").forEach(btn => {
        btn.addEventListener("click", () => {
            document.getElementById("editSeriesId").value = btn.dataset.id;
            document.getElementById("editSeriesName").value = btn.dataset.name;
            document.getElementById("editSeriesVolumes").value = btn.dataset.vol;
            document.getElementById("editSeriesStatus").value = btn.dataset.status;
            document.getElementById("editSeriesDescription").value = btn.dataset.desc || "";

            // Hiển thị ảnh cũ
            const editPreview = document.getElementById("editSeriesPreview");
            const editBox = document.getElementById("editSeriesImageBox");
            if (btn.dataset.cover) {
                editPreview.src = btn.dataset.cover;
                editPreview.style.display = "block";
                editBox.querySelector("span").style.display = "none";
            } else {
                editPreview.style.display = "none";
                editBox.querySelector("span").style.display = "block";
            }

            document.getElementById("editSeriesModal").style.display = "flex";
        });
    });

    // Đóng popup sửa
    document.querySelectorAll(".close-edit-series").forEach(btn => {
        btn.addEventListener("click", (e) => {
            e.preventDefault();
            document.getElementById("editSeriesModal").style.display = "none";
        });
    });

    // Upload ảnh cho popup SỬA
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
                editBox.querySelector("span").style.display = "none";
            };
            reader.readAsDataURL(editInput.files[0]);
        }
    });

    // Đóng popup khi click nền
    document.querySelectorAll(".modal-overlay").forEach(overlay => {
        overlay.addEventListener("click", (e) => {
            if (e.target === overlay) {
                overlay.style.display = "none";
            }
        });
    });

    // Menu hiển thị/ẩn series
    document.querySelectorAll(".more-btn").forEach(btn => {
        btn.addEventListener("click", function (e) {
            e.stopPropagation();
            const container = this.parentElement;
            document.querySelectorAll(".menu-container").forEach(m => {
                if (m !== container) m.classList.remove("active");
            });
            container.classList.toggle("active");
        });
    });

    document.addEventListener("click", () => {
        document.querySelectorAll(".menu-container").forEach(m => m.classList.remove("active"));
    });

    // Xử lý hiển thị/ẩn series
    document.querySelectorAll('.dropdown-menu input[type=radio]').forEach(radio => {
        radio.addEventListener('change', function () {
            const seriesId = this.closest('.dropdown-menu').querySelector('.series-id').value;
            const action = this.value;

            fetch('${pageContext.request.contextPath}/SeriesManagement', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: new URLSearchParams({id: seriesId, action: action})
            })
                .then(res => {
                    if (res.ok) {
                        console.log("✅ Cập nhật thành công series " + seriesId + " → " + action);
                    } else {
                        console.error("❌ Có lỗi khi cập nhật");
                    }
                })
                .catch(err => console.error("Fetch error:", err));
        });
    });

    // Active sidebar
    document.addEventListener("DOMContentLoaded", function () {
        const current = window.location.pathname.split("/").pop();
        const links = document.querySelectorAll(".sidebar li a");
        links.forEach(link => {
            const linkPage = link.getAttribute("href");
            if (linkPage === current) link.classList.add("active");
        });
    });
</script>
<%--xoa seri--%>
<script>
    let deleteSeriesId = null;

    document.querySelectorAll(".delete-series-btn").forEach(btn => {
        btn.addEventListener("click", function () {
            deleteSeriesId = this.getAttribute("data-id");
            const seriesName = this.getAttribute("data-name");

            console.log("✅ Delete button clicked");
            console.log("📝 Series ID:", deleteSeriesId);
            console.log("📝 Series Name:", seriesName);

            // Hiển thị tên series trong popup
            document.getElementById("deleteSeriesName").textContent = seriesName;

            // Mở popup xác nhận
            document.getElementById("deleteConfirmModal").style.display = "flex";
        });
    });

    // Xử lý khi click nút XÁC NHẬN XÓA trong popup
    document.getElementById("confirmDeleteBtn").addEventListener("click", function () {
        if (!deleteSeriesId) {
            alert("❌ Không tìm thấy ID series cần xóa!");
            return;
        }

        console.log("🗑️ Confirming delete for ID:", deleteSeriesId);

        // Hiển thị loading
        this.disabled = true;
        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xóa...';

        // Tạo URL xóa
        const deleteUrl = '${pageContext.request.contextPath}/DeleteSeriesServlet?id=' + deleteSeriesId;
        console.log("🔗 Redirecting to:", deleteUrl);

        // Chuyển hướng
        window.location.href = deleteUrl;
    });

    // Xử lý khi click nút HÙY XÓA
    document.getElementById("cancelDeleteBtn").addEventListener("click", function () {
        console.log("❌ Delete cancelled");
        document.getElementById("deleteConfirmModal").style.display = "none";
        deleteSeriesId = null;
    });

    // Đóng popup khi click ra ngoài
    document.getElementById("deleteConfirmModal").addEventListener("click", function (e) {
        if (e.target === this) {
            this.style.display = "none";
            deleteSeriesId = null;
        }
    });

    // Đóng popup khi click nền
    document.querySelectorAll(".modal-overlay").forEach(overlay => {
        overlay.addEventListener("click", (e) => {
            if (e.target === overlay) {
                overlay.style.display = "none";
            }
        });
    });
</script>
<%--xu ly loc--%>
<script>
    // ========== XỬ LÝ BỘ LỌC ==========
    document.addEventListener('DOMContentLoaded', function () {
        const filterSelect = document.getElementById('visibilityFilter');

        if (filterSelect) {
            filterSelect.addEventListener('change', function () {
                const filterValue = this.value;
                const urlParams = new URLSearchParams(window.location.search);

                // Giữ keyword nếu có
                const keyword = urlParams.get('keyword');

                // Tạo URL mới
                let newUrl = '${pageContext.request.contextPath}/SeriesManagement?filter=' + filterValue;

                if (keyword) {
                    newUrl += '&keyword=' + encodeURIComponent(keyword);
                }

                console.log('🔍 Applying filter:', filterValue);
                console.log('🔗 Redirecting to:', newUrl);

                window.location.href = newUrl;
            });
        }
    });
</script>
</body>
</html>