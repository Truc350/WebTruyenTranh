// Hằng số
const ROWS_PER_PAGE = 10;
let currentPage = 1;
let totalPages = 1;
let currentKeyword = '';
let deletingCategoryId = null;
let deletingCategoryName = '';

let editingCategoryId = null;

// Lấy context path
function getContextPath() {
    return window.contextPath || '';
}

// Khởi tạo khi trang load
document.addEventListener('DOMContentLoaded', function () {
    console.log('=== Page Loading ===');
    console.log('Context path:', getContextPath());
    console.log('Current URL:', window.location.href);

    initEventListeners();
    setDefaultDate();
    loadCategories(1);
});

// Thiết lập ngày hiện tại
function setDefaultDate() {
    const today = new Date().toISOString().split('T')[0];
    const newDateInput = document.getElementById('newCategoryCreatedDate');
    if (newDateInput) {
        newDateInput.value = today;
        newDateInput.readOnly = true;
    }
}

// Khởi tạo các sự kiện
function initEventListeners() {
    const addBtn = document.querySelector('.add-category-btn');
    if (addBtn) {
        addBtn.addEventListener('click', openAddPopup);
        console.log('Add button listener attached');
    }

    const saveBtn = document.querySelector('#addPopup .save-btn');
    if (saveBtn) {
        saveBtn.addEventListener('click', handleAddCategory);
        console.log('Save button listener attached');
    }

    const searchBtn = document.getElementById('categorySearchBtn');
    if (searchBtn) {
        searchBtn.addEventListener('click', handleSearch);
        console.log('Search button listener attached');
    }

    const searchInput = document.getElementById('categorySearchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                handleSearch();
            }
        });
    }

    // Event listeners cho Delete popup - Sử dụng ID đúng
    const deleteConfirmBtn = document.getElementById('confirmDeleteBtn');
    if (deleteConfirmBtn) {
        deleteConfirmBtn.addEventListener('click', function(e) {
            e.preventDefault();
            handleDeleteCategory();
        });
        console.log('Delete confirm button listener attached');
    } else {
        console.warn('confirmDeleteBtn NOT FOUND');
    }

    const deleteCancelBtn = document.querySelector('#deletePopup .cancel-btn');
    if (deleteCancelBtn) {
        deleteCancelBtn.addEventListener('click', function(e) {
            e.preventDefault();
            closeDeletePopup();
        });
        console.log('Delete cancel button listener attached');
    }

    document.querySelectorAll('.popup-overlay').forEach(overlay => {
        overlay.addEventListener('click', function (e) {
            if (e.target === this) {
                closeAllPopups();
            }
        });
    });
}

function loadCategories(page = 1) {
    const contextPath = getContextPath();
    fetch(`${contextPath}/admin/listCategories?page=${page}&pageSize=10`)
        .then(res => res.json())
        .then(data => {
            console.log("Response:", data);

            if (!data.success) {
                console.error(data.message);
                return;
            }

            const tbody = document.getElementById("categoryTableBody");
            tbody.innerHTML = "";

            const categories = data.categories;

            if (categories.length === 0) {
                tbody.innerHTML = `<tr><td colspan="4">Không có dữ liệu</td></tr>`;
                return;
            }

            categories.forEach(cat => {
                const escapedName = escapeHtml(cat.nameCategories);
                tbody.innerHTML += `
                    <tr>
                        <td>${cat.id}</td>
                        <td>${escapedName}</td>
                        <td class="action-cell">
                            <button class="edit-btn" onclick="openEditPopup(${cat.id})" title="Chỉnh sửa">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </button>
                            <button class="delete-btn"
                                    onclick="openDeletePopup(${cat.id}, '${escapedName.replace(/'/g, "\\'")}')"
                                    title="Xóa">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
            });

            renderPagination(data.currentPage, data.totalPages);
        })
        .catch(err => {
            console.error("Fetch error:", err);
            showMessage('Không thể tải danh sách thể loại!', 'error');
        });
}

// Render phân trang
function renderPagination(current, total) {
    const container = document.getElementById('categoryPaginationContainer');

    if (total <= 1) {
        container.innerHTML = '';
        return;
    }

    let html = '<div class="pagination">';

    html += `<button class="page-btn" ${current === 1 ? 'disabled' : ''} 
             onclick="loadCategories(${current - 1})">
             <i class="fas fa-chevron-left"></i>
             </button>`;

    for (let i = 1; i <= total; i++) {
        if (i === 1 || i === total || (i >= current - 2 && i <= current + 2)) {
            html += `<button class="page-btn ${i === current ? 'active' : ''}" 
                     onclick="loadCategories(${i})">${i}</button>`;
        } else if (i === current - 3 || i === current + 3) {
            html += '<span class="page-dots">...</span>';
        }
    }

    html += `<button class="page-btn" ${current === total ? 'disabled' : ''} 
             onclick="loadCategories(${current + 1})">
             <i class="fas fa-chevron-right"></i>
             </button>`;

    html += '</div>';
    container.innerHTML = html;
}

// Xử lý tìm kiếm
function handleSearch() {
    const input = document.getElementById('categorySearchInput');
    currentKeyword = input.value.trim();
    console.log('Searching with keyword:', currentKeyword);
    loadCategories(1);
}

// Mở popup thêm
function openAddPopup() {
    console.log('Opening add popup');
    document.getElementById('newCategoryName').value = '';
    document.getElementById('newCategoryDesc').value = '';
    setDefaultDate();
    document.getElementById('addPopup').style.display = 'flex';
}

// Đóng popup thêm
function closeAddPopup() {
    document.getElementById('addPopup').style.display = 'none';
}

// Xử lý thêm thể loại
function handleAddCategory() {
    console.log('=== Adding Category ===');
    const name = document.getElementById('newCategoryName').value.trim();
    const description = document.getElementById('newCategoryDesc').value.trim();

    if (!name) {
        showMessage('Vui lòng nhập tên thể loại!', 'error');
        return;
    }

    if (name.length > 100) {
        showMessage('Tên thể loại không được vượt quá 100 ký tự!', 'error');
        return;
    }

    const contextPath = getContextPath();
    const url = `${contextPath}/admin/addCategory`;
    console.log('Adding to URL:', url);

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            name: name,
            description: description
        })
    })
        .then(response => {
            console.log('Add response status:', response.status);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Add response data:', data);
            if (data.success) {
                showMessage(data.message, 'success');
                closeAddPopup();
                loadCategories(1);
            } else {
                showMessage(data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error adding category:', error);
            showMessage('Không thể kết nối đến server! ' + error.message, 'error');
        });
}

// ===== CHỨC NĂNG XÓA =====

// Mở popup xóa
function openDeletePopup(id, name) {
    console.log('Opening delete popup for:', id, name);

    deletingCategoryId = id;
    deletingCategoryName = name;

    // Hiển thị tên thể loại trong popup
    const deleteMessageElement = document.getElementById('deleteCategoryMessage');
    if (deleteMessageElement) {
        deleteMessageElement.textContent = `Bạn có chắc chắn muốn xóa thể loại "${name}"?`;
    }

    // Hiển thị popup
    const deletePopup = document.getElementById('deletePopup');
    if (deletePopup) {
        deletePopup.style.display = 'flex';
    }
}

// Đóng popup xóa
function closeDeletePopup() {
    const deletePopup = document.getElementById('deletePopup');
    if (deletePopup) {
        deletePopup.style.display = 'none';
    }
    deletingCategoryId = null;
    deletingCategoryName = '';
}

// Xử lý xóa thể loại
function handleDeleteCategory() {
    console.log('=== Deleting Category ===');
    console.log('Category ID:', deletingCategoryId);
    console.log('Category Name:', deletingCategoryName);

    if (!deletingCategoryId) {
        showMessage('Không xác định được thể loại cần xóa!', 'error');
        return;
    }

    const contextPath = getContextPath();
    const url = `${contextPath}/admin/deleteCategory`;
    console.log('Deleting at URL:', url);

    // Disable nút để tránh click nhiều lần
    const deleteBtn = document.getElementById('confirmDeleteBtn');
    if (deleteBtn) {
        deleteBtn.disabled = true;
        deleteBtn.textContent = 'Đang xóa...';
    }

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            id: deletingCategoryId
        })
    })
        .then(response => {
            console.log('Delete response status:', response.status);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Delete response data:', data);

            // Reset nút
            if (deleteBtn) {
                deleteBtn.disabled = false;
                deleteBtn.textContent = 'Xóa';
            }

            if (data.success) {
                showMessage(data.message, 'success');
                closeDeletePopup();

                // Reload lại trang hiện tại
                loadCategories(currentPage);
            } else {
                showMessage(data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error deleting category:', error);

            // Reset nút
            if (deleteBtn) {
                deleteBtn.disabled = false;
                deleteBtn.textContent = 'Xóa';
            }

            showMessage('Không thể kết nối đến server! ' + error.message, 'error');
        });
}

// Đóng tất cả popup
function closeAllPopups() {
    document.querySelectorAll('.popup-overlay').forEach(popup => {
        popup.style.display = 'none';
    });
    deletingCategoryId = null;
    deletingCategoryName = '';
}

// Hiển thị thông báo
function showMessage(message, type = 'info') {
    const oldMsg = document.querySelector('.toast-message');
    if (oldMsg) {
        oldMsg.remove();
    }

    const toast = document.createElement('div');
    toast.className = `toast-message toast-${type}`;
    toast.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        <span>${message}</span>
    `;

    document.body.appendChild(toast);
    setTimeout(() => toast.classList.add('show'), 10);
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Escape HTML
function escapeHtml(text) {
    if (!text) return '';
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return String(text).replace(/[&<>"']/g, m => map[m]);
}




function closeEditPopup() {
    const editPopup = document.getElementById('editPopup');
    if (editPopup) {
        editPopup.style.display = 'none';
    }
    editingCategoryId = null;

    // Reset form
    const nameInput = document.getElementById('editCategoryName');
    const descInput = document.getElementById('editCategoryDesc');
    if (nameInput) nameInput.value = '';
    if (descInput) descInput.value = '';
}


function initEditEventListeners() {
    const editSaveBtn = document.getElementById('confirmEditBtn');
    if (editSaveBtn) {
        editSaveBtn.addEventListener('click', function(e) {
            e.preventDefault();
            handleEditCategory();
        });
        console.log('Edit save button listener attached');
    }

    const editCancelBtn = document.querySelector('#editPopup .cancel-btn');
    if (editCancelBtn) {
        editCancelBtn.addEventListener('click', function(e) {
            e.preventDefault();
            closeEditPopup();
        });
        console.log('Edit cancel button listener attached');
    }
}

function openEditPopup(id) {
    console.log('Opening edit popup for ID:', id);

    editingCategoryId = id;

    const contextPath = getContextPath();
    const url = `${contextPath}/admin/getCategoryById?id=${id}`;

    // Hiển thị popup trước
    const editPopup = document.getElementById('editPopup');
    if (editPopup) {
        editPopup.style.display = 'flex';
    }

    // Reset form trước khi load
    const nameInput = document.getElementById('editCategoryName');
    const descInput = document.getElementById('editCategoryDesc');
    if (nameInput) nameInput.value = '';
    if (descInput) descInput.value = '';

    // Gọi API để lấy thông tin thể loại
    fetch(url)
        .then(response => {
            console.log('Get category response status:', response.status);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Category data:', data);

            if (data.success && data.category) {
                const cat = data.category;

                // Điền dữ liệu vào form
                if (nameInput) nameInput.value = cat.nameCategories || '';
                if (descInput) descInput.value = cat.description || '';

            } else {
                showMessage(data.message || 'Không thể tải thông tin thể loại!', 'error');
                closeEditPopup();
            }
        })
        .catch(error => {
            console.error('Error loading category:', error);
            showMessage('Không thể kết nối đến server! ' + error.message, 'error');
            closeEditPopup();
        });
}

/**
 * Xử lý cập nhật thể loại
 */
function handleEditCategory() {
    console.log('=== Updating Category ===');
    console.log('Editing Category ID:', editingCategoryId);

    // Validate ID
    if (!editingCategoryId) {
        showMessage('Không xác định được thể loại cần sửa!', 'error');
        return;
    }

    // Lấy dữ liệu từ form
    const name = document.getElementById('editCategoryName').value.trim();
    const description = document.getElementById('editCategoryDesc').value.trim();

    // Validate tên
    if (!name) {
        showMessage('Vui lòng nhập tên thể loại!', 'error');
        return;
    }

    if (name.length > 100) {
        showMessage('Tên thể loại không được vượt quá 100 ký tự!', 'error');
        return;
    }

    const contextPath = getContextPath();
    const url = `${contextPath}/admin/updateCategory`;
    console.log('Updating at URL:', url);

    // Disable nút để tránh click nhiều lần
    const saveBtn = document.getElementById('confirmEditBtn');
    const originalText = saveBtn ? saveBtn.textContent : 'Lưu';
    if (saveBtn) {
        saveBtn.disabled = true;
        saveBtn.textContent = 'Đang lưu...';
    }

    // Gọi API update
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            id: editingCategoryId,
            name: name,
            description: description
        })
    })
        .then(response => {
            console.log('Update response status:', response.status);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Update response data:', data);

            // Reset nút
            if (saveBtn) {
                saveBtn.disabled = false;
                saveBtn.textContent = originalText;
            }

            if (data.success) {
                showMessage(data.message || 'Cập nhật thể loại thành công!', 'success');
                closeEditPopup();

                // Reload lại danh sách ở trang hiện tại
                if (typeof loadCategories === 'function') {
                    loadCategories(currentPage || 1);
                }
            } else {
                showMessage(data.message || 'Cập nhật thất bại!', 'error');
            }
        })
        .catch(error => {
            console.error('Error updating category:', error);

            // Reset nút
            if (saveBtn) {
                saveBtn.disabled = false;
                saveBtn.textContent = originalText;
            }

            showMessage('Không thể kết nối đến server! ' + error.message, 'error');
        });
}