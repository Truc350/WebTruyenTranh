// ========== BIẾN TOÀN CỤC ==========
let currentEditId = null;
let debounceTimer = null;
let selectedComicForApply = null;

// ========== KHỞI TẠO KHI DOM LOADED ==========
document.addEventListener("DOMContentLoaded", () => {
    initializeModals();
    initializeAddFlashSale();
    initializeEditFlashSale();
    initializeViewFlashSale();
    initializeDeleteFlashSale();
    initializeSearch();
    initializeSidebar();
});

// ========== SIDEBAR ACTIVE LINK ==========
function initializeSidebar() {
    const current = window.location.pathname.split("/").pop();
    const links = document.querySelectorAll(".sidebar li a");
    links.forEach(link => {
        const linkPage = link.getAttribute("href");
        if (linkPage === current) {
            link.classList.add("active");
        }
    });
}

// ========== MỞ/ĐÓNG POPUP ==========
function initializeModals() {
    // Popup thêm
    document.getElementById("openAddPopup")?.addEventListener("click", () => {
        document.getElementById("addFlashSaleModal").classList.add("show");
    });

    document.getElementById("closeAddFlashSale")?.addEventListener("click", () => {
        document.getElementById("addFlashSaleModal").classList.remove("show");
        resetAddForm();
    });

    // Popup xem
    document.getElementById("closeViewFlashSale")?.addEventListener("click", () => {
        document.getElementById("viewFlashSaleModal").classList.remove("show");
    });

    // Popup xóa
    document.getElementById("closeDeleteFlashSale")?.addEventListener("click", () => {
        document.getElementById("deleteFlashSaleModal").classList.remove("show");
    });

    // Popup chỉnh sửa
    document.getElementById("closeEditFlashSale")?.addEventListener("click", () => {
        closeEditModal();
    });
}

// ========== THÊM FLASH SALE ==========
function initializeAddFlashSale() {
    const comicSearchInput = document.getElementById('comicSearchInput');
    const searchResults = document.getElementById('searchResults');
    const selectedProductList = document.getElementById('selectedProductList');

    // Tìm kiếm khi gõ
    comicSearchInput?.addEventListener('input', function () {
        clearTimeout(debounceTimer);
        const keyword = this.value.trim();

        if (keyword.length < 2) {
            searchResults.style.display = 'none';
            searchResults.innerHTML = '';
            return;
        }

        searchResults.innerHTML = '<div style="padding:15px; text-align:center; color:#888;"><i class="fas fa-spinner fa-spin"></i> Đang tìm kiếm...</div>';
        searchResults.style.display = 'block';

        debounceTimer = setTimeout(() => {
            fetch(contextPath + '/admin/search-comics1?keyword=' + encodeURIComponent(keyword))
                .then(res => res.json())
                .then(data => {
                    searchResults.innerHTML = '';

                    if (data.length === 0) {
                        searchResults.innerHTML = '<div style="padding:15px; text-align:center; color:#888;">Không tìm thấy truyện nào</div>';
                    } else {
                        data.forEach(comic => {
                            const div = document.createElement('div');
                            div.textContent = comic.name;
                            div.style.cssText = 'padding:12px 16px; cursor:pointer; border-bottom:1px solid #eee;';
                            div.onmouseover = () => div.style.backgroundColor = '#f5f5f5';
                            div.onmouseout = () => div.style.backgroundColor = '';
                            div.onclick = () => addComicToAddList(comic.id, comic.name);
                            searchResults.appendChild(div);
                        });
                    }
                    searchResults.style.display = 'block';
                })
                .catch(err => {
                    console.error('Lỗi:', err);
                    searchResults.innerHTML = '<div style="padding:15px; color:red;">Lỗi server</div>';
                    searchResults.style.display = 'block';
                });
        }, 400);
    });

    // Ẩn kết quả khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (searchResults && !comicSearchInput?.contains(e.target) && !searchResults.contains(e.target)) {
            searchResults.style.display = 'none';
        }
    });

    // Nút tạo Flash Sale
    document.getElementById('createFlashSaleBtn')?.addEventListener('click', createFlashSale);
}

function addComicToAddList(id, name) {
    const selectedProductList = document.getElementById('selectedProductList');

    // Kiểm tra trùng
    if (document.getElementById('comic-' + id)) {
        alert('Truyện này đã được thêm rồi!');
        return;
    }

    // Xóa placeholder
    const placeholder = selectedProductList.querySelector('p');
    if (placeholder) placeholder.remove();

    // Tạo item mới
    const item = document.createElement('div');
    item.id = 'comic-' + id;
    item.className = 'comic-item';
    item.style.cssText = `
        display: flex; 
        align-items: center; 
        background: #fafafa; 
        padding: 12px 16px; 
        border-radius: 8px;
        border: 1px solid #eee; 
        margin-bottom: 10px; 
        gap: 12px;
        animation: slideIn 0.3s ease;
    `;

    item.innerHTML = `
        <input type="checkbox" checked disabled style="width: 18px; height: 18px;">
        <span style="flex:1; font-weight:500;">${name}</span>
        <button type="button" class="remove-comic-btn" 
                style="background:#ff4c4c; color:white; border:none; width:30px; height:30px; 
                       border-radius:50%; font-size:18px; cursor:pointer; line-height:1;">×</button>
    `;

    item.querySelector('.remove-comic-btn').onclick = () => {
        item.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => {
            item.remove();
            if (selectedProductList.children.length === 0) {
                selectedProductList.innerHTML = '<p class="empty-message">Chưa có truyện nào được chọn. Hãy tìm và thêm truyện ở trên.</p>';
            }
        }, 300);
    };

    selectedProductList.appendChild(item);

    // Reset search
    document.getElementById('searchResults').style.display = 'none';
    document.getElementById('comicSearchInput').value = '';
}

function createFlashSale() {
    const form = document.getElementById('addFlashSaleForm');
    const name = form.querySelector('input[name="flashSaleName"]')?.value.trim();
    const discountPercent = form.querySelector('input[name="discountPercent"]')?.value.trim();
    const startTime = form.querySelector('input[name="startTime"]')?.value;
    const endTime = form.querySelector('input[name="endTime"]')?.value;

    if (!name || !discountPercent || !startTime || !endTime) {
        alert('Vui lòng nhập đầy đủ thông tin!');
        return;
    }

    const discount = parseFloat(discountPercent);
    if (isNaN(discount) || discount < 1 || discount > 90) {
        alert('Phần trăm giảm phải từ 1% đến 90%!');
        return;
    }

    const selectedItems = document.querySelectorAll('#selectedProductList > div[id^="comic-"]');
    if (selectedItems.length === 0) {
        alert('Vui lòng chọn ít nhất một truyện!');
        return;
    }

    const comicIds = [];
    selectedItems.forEach(item => {
        const comicId = item.id.split('-')[1];
        comicIds.push(comicId);
    });

    const formData = new FormData();
    formData.append('flashSaleName', name);
    formData.append('discountPercent', discountPercent);
    formData.append('startTime', startTime);
    formData.append('endTime', endTime);
    comicIds.forEach(id => formData.append('comicIds', id));

    fetch(contextPath + '/admin/create-flashsale', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert('Tạo Flash Sale thành công!');
                document.getElementById('addFlashSaleModal').classList.remove('show');
                location.reload();
            } else {
                alert('Lỗi: ' + result.message);
            }
        })
        .catch(err => {
            console.error(err);
            alert('Lỗi kết nối server');
        });
}

function resetAddForm() {
    const form = document.getElementById('addFlashSaleForm');
    form.reset();
    document.getElementById('selectedProductList').innerHTML = '<p class="empty-message">Chưa có truyện nào được chọn. Hãy tìm và thêm truyện ở trên.</p>';
    document.getElementById('searchResults').innerHTML = '';
    document.getElementById('searchResults').style.display = 'none';
}

// ========== CHỈNH SỬA FLASH SALE ==========
function initializeEditFlashSale() {
    const editComicSearchInput = document.getElementById('editComicSearchInput');
    const editSearchResults = document.getElementById('editSearchResults');
    const applyBtn = document.getElementById('applySelectedComicBtn');
    const updateBtn = document.getElementById('updateFlashSaleBtn');

    // Tìm kiếm truyện
    editComicSearchInput?.addEventListener('input', function () {
        clearTimeout(debounceTimer);
        const keyword = this.value.trim();

        if (keyword.length < 2) {
            editSearchResults.style.display = 'none';
            editSearchResults.innerHTML = '';
            selectedComicForApply = null;
            return;
        }

        editSearchResults.innerHTML = '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Đang tìm kiếm...</div>';
        editSearchResults.style.display = 'block';

        debounceTimer = setTimeout(() => {
            fetch(contextPath + '/admin/search-comics1?keyword=' + encodeURIComponent(keyword))
                .then(res => res.json())
                .then(data => {
                    editSearchResults.innerHTML = '';

                    if (data.length === 0) {
                        editSearchResults.innerHTML = '<div class="empty-message">Không tìm thấy truyện nào</div>';
                    } else {
                        data.forEach(comic => {
                            const alreadyAdded = document.querySelector(`#editProductList input[data-comic-id="${comic.id}"]`);

                            const div = document.createElement('div');
                            div.className = 'search-result-item';
                            if (alreadyAdded) div.classList.add('selected');

                            div.innerHTML = `
                                <span class="comic-name">${comic.name}</span>
                                ${alreadyAdded ? '<span class="selected-badge">Đã thêm</span>' : ''}
                            `;

                            div.onclick = () => selectComicForApply(comic.id, comic.name, div);
                            editSearchResults.appendChild(div);
                        });
                    }
                    editSearchResults.style.display = 'block';
                })
                .catch(err => {
                    console.error('Lỗi:', err);
                    editSearchResults.innerHTML = '<div class="empty-message" style="color:red;">Lỗi kết nối server</div>';
                });
        }, 400);
    });

    // Nút áp dụng
    applyBtn?.addEventListener('click', () => {
        if (!selectedComicForApply) {
            alert('Vui lòng chọn một truyện từ kết quả tìm kiếm!');
            return;
        }

        const alreadyAdded = document.querySelector(`#editProductList input[data-comic-id="${selectedComicForApply.id}"]`);
        if (alreadyAdded) {
            alert('Truyện này đã có trong danh sách!');
            return;
        }

        addComicToEditList(selectedComicForApply.id, selectedComicForApply.name);

        // Reset
        selectedComicForApply = null;
        editComicSearchInput.value = '';
        editSearchResults.style.display = 'none';
        showSuccessToast('Đã thêm truyện vào danh sách!');
    });

    // Ẩn kết quả khi click ngoài
    document.addEventListener('click', (e) => {
        if (editSearchResults &&
            !editComicSearchInput?.contains(e.target) &&
            !editSearchResults.contains(e.target) &&
            !applyBtn?.contains(e.target)) {
            editSearchResults.style.display = 'none';
        }
    });

    // Mở popup edit
    document.querySelectorAll('.openEditFlashSale').forEach(btn => {
        btn.addEventListener('click', () => openEditModal(btn.dataset.id));
    });

    // Cập nhật Flash Sale
    updateBtn?.addEventListener('click', updateFlashSale);
}

function selectComicForApply(id, name, element) {
    const alreadyAdded = document.querySelector(`#editProductList input[data-comic-id="${id}"]`);

    if (alreadyAdded) {
        alert('Truyện này đã có trong danh sách Flash Sale!');
        return;
    }

    // Bỏ highlight các item khác
    document.querySelectorAll('.search-result-item').forEach(item => {
        item.classList.remove('selected');
    });

    // Highlight item được chọn
    element.classList.add('selected');
    selectedComicForApply = { id, name };
}

function addComicToEditList(id, name) {
    const editProductList = document.getElementById('editProductList');

    // Kiểm tra trùng
    if (editProductList.querySelector(`input[data-comic-id="${id}"]`)) {
        alert('Truyện này đã có trong danh sách!');
        return;
    }

    // Xóa empty message
    const emptyMsg = editProductList.querySelector('p');
    if (emptyMsg) emptyMsg.remove();

    // Tạo label mới
    const label = document.createElement('label');
    label.style.cssText = `
        display: flex;
        align-items: center;
        background: #fafafa;
        padding: 10px 14px;
        border-radius: 8px;
        border: 1px solid #eee;
        gap: 10px;
        margin-bottom: 8px;
        cursor: pointer;
        animation: slideIn 0.3s ease;
    `;

    label.innerHTML = `
        <input type="checkbox" data-comic-id="${id}" checked style="width: 18px; height: 18px; cursor: pointer;">
        <span style="flex: 1;">${name}</span>
        <button type="button" class="remove-comic-edit-btn" 
                style="background:#ff4c4c; color:white; border:none; width:30px; height:30px; 
                       border-radius:50%; font-size:18px; cursor:pointer; line-height:1;">×</button>
    `;

    label.onmouseover = () => label.style.background = '#f3f3f3';
    label.onmouseout = () => label.style.background = '#fafafa';

    // Nút xóa
    label.querySelector('.remove-comic-edit-btn').onclick = (e) => {
        e.stopPropagation();
        if (confirm(`Bạn có chắc muốn xóa "${name}" khỏi danh sách?`)) {
            label.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => {
                label.remove();
                if (editProductList.children.length === 0) {
                    editProductList.innerHTML = '<p style="color:#888; text-align:center;">Chưa áp dụng cho truyện nào</p>';
                }
            }, 300);
        }
    };

    editProductList.appendChild(label);
}

function openEditModal(flashSaleId) {
    currentEditId = flashSaleId?.trim();

    if (!currentEditId) {
        alert('Không tìm thấy ID Flash Sale!');
        return;
    }

    const editProductList = document.getElementById('editProductList');
    editProductList.innerHTML = '<p style="text-align:center; color:#888;">Đang tải...</p>';

    fetch(`${contextPath}/admin/manage-flashsale`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `action=detail&id=${encodeURIComponent(currentEditId)}`
    })
        .then(res => res.json())
        .then(result => {
            if (result.success && result.data) {
                fillEditForm(result.data);
                document.getElementById('editFlashSaleModal').classList.add('show');
            } else {
                alert(result.message || 'Không thể tải thông tin!');
            }
        })
        .catch(err => {
            console.error('Lỗi:', err);
            alert('Lỗi khi tải dữ liệu Flash Sale!');
        });
}

function fillEditForm(data) {
    const form = document.getElementById('editFlashSaleForm');
    const editProductList = document.getElementById('editProductList');

    form.querySelector('input[name="flashSaleName"]').value = data.name || '';
    form.querySelector('input[name="discountPercent"]').value = data.discountPercent || 30;

    try {
        const start = convertToISO(data.startTime);
        const end = convertToISO(data.endTime);
        form.querySelector('input[name="startTime"]').value = start;
        form.querySelector('input[name="endTime"]').value = end;
    } catch (e) {
        console.warn('Không parse được thời gian', e);
    }

    editProductList.innerHTML = '';

    if (data.comics && data.comics.length > 0) {
        data.comics.forEach(comic => {
            const label = document.createElement('label');
            label.style.cssText = `
                display: flex;
                align-items: center;
                background: #fafafa;
                padding: 10px 14px;
                border-radius: 8px;
                border: 1px solid #eee;
                gap: 10px;
                margin-bottom: 8px;
                cursor: pointer;
            `;

            label.innerHTML = `
                <input type="checkbox" data-comic-id="${comic.id}" checked style="width: 18px; height: 18px; cursor: pointer;">
                <span style="flex: 1;">${comic.name}</span>
                <button type="button" class="remove-comic-edit-btn" 
                        style="background:#ff4c4c; color:white; border:none; width:30px; height:30px; 
                               border-radius:50%; font-size:18px; cursor:pointer; line-height:1;">×</button>
            `;

            label.onmouseover = () => label.style.background = '#f3f3f3';
            label.onmouseout = () => label.style.background = '#fafafa';

            label.querySelector('.remove-comic-edit-btn').onclick = (e) => {
                e.stopPropagation();
                if (confirm(`Bạn có chắc muốn xóa "${comic.name}" khỏi danh sách?`)) {
                    label.style.animation = 'slideOut 0.3s ease';
                    setTimeout(() => {
                        label.remove();
                        if (editProductList.children.length === 0) {
                            editProductList.innerHTML = '<p style="color:#888; text-align:center;">Chưa áp dụng cho truyện nào</p>';
                        }
                    }, 300);
                }
            };

            editProductList.appendChild(label);
        });
    } else {
        editProductList.innerHTML = '<p style="color:#888; text-align:center;">Chưa áp dụng cho truyện nào</p>';
    }
}

function updateFlashSale() {
    if (!currentEditId) {
        alert('Không có ID để cập nhật!');
        return;
    }

    const form = document.getElementById('editFlashSaleForm');
    const name = form.querySelector('input[name="flashSaleName"]').value.trim();
    const discountPercent = form.querySelector('input[name="discountPercent"]').value.trim();
    const startTime = form.querySelector('input[name="startTime"]').value;
    const endTime = form.querySelector('input[name="endTime"]').value;

    if (!name || !discountPercent || !startTime || !endTime) {
        alert('Vui lòng điền đầy đủ thông tin!');
        return;
    }

    const discount = parseFloat(discountPercent);
    if (isNaN(discount) || discount < 1 || discount > 90) {
        alert('Phần trăm giảm phải từ 1% đến 90%!');
        return;
    }

    const selectedComicIds = [];
    document.querySelectorAll('#editProductList input[type="checkbox"]:checked').forEach(cb => {
        const comicId = cb.getAttribute('data-comic-id');
        if (comicId) selectedComicIds.push(comicId);
    });

    if (selectedComicIds.length === 0) {
        alert('Vui lòng chọn ít nhất một truyện!');
        return;
    }

    const formData = new FormData();
    formData.append('action', 'update');
    formData.append('id', currentEditId);
    formData.append('name', name);
    formData.append('discountPercent', discountPercent);
    formData.append('startTime', startTime);
    formData.append('endTime', endTime);
    selectedComicIds.forEach(id => formData.append('comicIds', id));

    fetch(`${contextPath}/admin/manage-flashsale`, {
        method: 'POST',
        body: formData
    })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                alert('Cập nhật thành công!');
                closeEditModal();
                location.reload();
            } else {
                alert('Cập nhật thất bại: ' + (result.message || 'Lỗi không xác định'));
            }
        })
        .catch(err => {
            console.error('Lỗi:', err);
            alert('Lỗi kết nối server!');
        });
}

function closeEditModal() {
    document.getElementById('editFlashSaleModal').classList.remove('show');
    currentEditId = null;
    selectedComicForApply = null;
    document.getElementById('editComicSearchInput').value = '';
    document.getElementById('editSearchResults').style.display = 'none';
}

// ========== XEM CHI TIẾT ==========
function initializeViewFlashSale() {
    document.querySelectorAll('.btn-view').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const flashSaleId = btn.dataset.id?.trim();

            if (!flashSaleId) {
                alert('Không tìm thấy ID Flash Sale!');
                return;
            }

            fetch(`${contextPath}/admin/manage-flashsale`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `action=detail&id=${encodeURIComponent(flashSaleId)}`
            })
                .then(res => res.json())
                .then(result => {
                    if (result.success && result.data) {
                        displayFlashSaleDetail(result.data);
                        document.getElementById('viewFlashSaleModal').classList.add('show');
                    } else {
                        alert(result.message || 'Không thể tải thông tin!');
                    }
                })
                .catch(err => {
                    console.error('Lỗi:', err);
                    alert('Có lỗi khi tải thông tin!');
                });
        });
    });
}

function displayFlashSaleDetail(data) {
    const viewInfoBox = document.querySelector('#viewFlashSaleModal .view-info-box');
    if (!viewInfoBox) return;

    const statusText = {
        'active': 'Đang diễn ra',
        'scheduled': 'Sắp diễn ra',
        'ended': 'Đã diễn ra'
    };

    let productsHtml = '';
    if (data.comics && data.comics.length > 0) {
        data.comics.forEach(comic => {
            productsHtml += `
                <div class="item">
                    <span>${comic.name}</span>
                    <span>Giảm: ${comic.discount}%</span>
                </div>
            `;
        });
    } else {
        productsHtml = '<p style="text-align:center; color:#888;">Không có sản phẩm nào</p>';
    }

    viewInfoBox.innerHTML = `
        <p><strong>Mã Flash Sale:</strong> ${data.id}</p>
        <p><strong>Tên Flash Sale:</strong> ${data.name}</p>
        <p><strong>Thời gian:</strong> ${data.startTime} → ${data.endTime}</p>
        <p><strong>Trạng thái:</strong> <span class="status ${data.status}">${statusText[data.status] || data.status}</span></p>
        
        <h4>Sản phẩm áp dụng:</h4>
        <div class="view-product-list">
            ${productsHtml}
        </div>
        
        <div class="flashsale-buttons">
            <button type="button" class="cancel-btn" id="closeViewFlashSale2">Đóng</button>
        </div>
    `;

    document.getElementById('closeViewFlashSale2').addEventListener('click', () => {
        document.getElementById('viewFlashSaleModal').classList.remove('show');
    });
}

// ========== XÓA FLASH SALE ==========
function initializeDeleteFlashSale() {
    const deleteModal = document.getElementById('deleteFlashSaleModal');
    let deleteId = null;

    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            deleteId = btn.dataset.id?.trim();

            if (!deleteId) {
                alert('Không tìm thấy ID để xóa!');
                return;
            }

            deleteModal.style.display = 'flex';
        });
    });

    document.getElementById('confirmDeleteFlashSale')?.addEventListener('click', () => {
        if (!deleteId) return;

        fetch(`${contextPath}/admin/manage-flashsale`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `action=delete&id=${encodeURIComponent(deleteId)}`
        })
            .then(res => res.json())
            .then(data => {
                deleteModal.style.display = 'none';
                alert(data.message || (data.success ? 'Xóa thành công!' : 'Xóa thất bại!'));

                if (data.success) {
                    const row = document.querySelector(`tr[data-id="${deleteId}"]`);
                    if (row) row.remove();

                    const tbody = document.getElementById('flashSaleTableBody');
                    if (tbody && tbody.children.length === 0) {
                        tbody.innerHTML = `
                            <tr>
                                <td colspan="5" style="text-align: center; color: #888;">
                                    Chưa có Flash Sale nào được tạo
                                </td>
                            </tr>
                        `;
                    }
                }
            })
            .catch(err => {
                console.error('Lỗi:', err);
                alert('Có lỗi khi xóa!');
            })
            .finally(() => deleteId = null);
    });
}

// ========== TÌM KIẾM FLASH SALE ==========
function initializeSearch() {
    const searchInput = document.getElementById('searchInput');
    const tbody = document.getElementById('flashSaleTableBody');

    if (!searchInput || !tbody) return;

    const originalContent = tbody.innerHTML;
    const allRows = Array.from(tbody.querySelectorAll('tr')).map(row => ({
        element: row.cloneNode(true),
        name: row.querySelector('td:nth-child(2)')?.textContent.trim().toLowerCase() || ''
    }));

    searchInput.addEventListener('input', function() {
        const keyword = this.value.trim().toLowerCase();

        if (keyword === '') {
            tbody.innerHTML = originalContent;
            reattachEventListeners();
            return;
        }

        const filtered = allRows.filter(row => row.name.includes(keyword));

        if (filtered.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="5" style="text-align: center; color: #888; padding: 30px;">
                        Không tìm thấy Flash Sale nào phù hợp
                    </td>
                </tr>
            `;
        } else {
            tbody.innerHTML = '';
            filtered.forEach(row => {
                tbody.appendChild(row.element.cloneNode(true));
            });
            reattachEventListeners();
        }
    });
}

function reattachEventListeners() {
    // Gắn lại event cho các nút sau khi filter
    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            // Trigger delete logic
        });
    });

    document.querySelectorAll('.btn-view').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            // Trigger view logic
        });
    });

    document.querySelectorAll('.openEditFlashSale').forEach(btn => {
        btn.addEventListener('click', () => {
            openEditModal(btn.dataset.id);
        });
    });
}

// ========== UTILITY FUNCTIONS ==========
function convertToISO(formattedTime) {
    if (!formattedTime) return '';
    const [time, date] = formattedTime.split(' ');
    const [hour, min] = time.split(':');
    const [day, month, year] = date.split('/');
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}T${hour.padStart(2, '0')}:${min.padStart(2, '0')}`;
}

function showSuccessToast(message) {
    const toast = document.createElement('div');
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #28a745;
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 10000;
        animation: slideInRight 0.3s ease;
    `;
    toast.innerHTML = `<i class="fas fa-check-circle"></i> ${message}`;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'slideOutRight 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// ========== CSS ANIMATIONS ==========
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { opacity: 0; transform: translateX(-20px); }
        to { opacity: 1; transform: translateX(0); }
    }

    @keyframes slideOut {
        from { opacity: 1; transform: translateX(0); }
        to { opacity: 0; transform: translateX(20px); }
    }

    @keyframes slideInRight {
        from { opacity: 0; transform: translateX(100px); }
        to { opacity: 1; transform: translateX(0); }
    }

    @keyframes slideOutRight {
        from { opacity: 1; transform: translateX(0); }
        to { opacity: 0; transform: translateX(100px); }
    }
`;
document.head.appendChild(style);