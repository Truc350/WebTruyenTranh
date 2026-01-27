document.addEventListener("DOMContentLoaded", () => {
    // Mở popup thêm
    document.getElementById("openAddPopup").onclick = () => {
        console.log("hello");
        document.getElementById("addFlashSaleModal").classList.add("show");
    };

    // Đóng popup thêm
    document.getElementById("closeAddFlashSale").onclick = () => {
        document.getElementById("addFlashSaleModal").classList.remove("show");
    };

    // Popup xem
    document.querySelectorAll(".btn-view").forEach(btn => {
        btn.onclick = () => {
            document.getElementById("viewFlashSaleModal").classList.add("show");
        };
    });
    document.getElementById("closeViewFlashSale").onclick = () => {
        document.getElementById("viewFlashSaleModal").classList.remove("show");
    };

    // Popup xóa
    document.getElementById("closeDeleteFlashSale").onclick = () => {
        document.getElementById("deleteFlashSaleModal").classList.remove("show");
    };

    // Sidebar active link
    const current = window.location.pathname.split("/").pop();
    const links = document.querySelectorAll(".sidebar li a");
    links.forEach(link => {
        const linkPage = link.getAttribute("href");
        if (linkPage === current) {
            link.classList.add("active");
        }
    });

    // ===== TÌM KIẾM VÀ THÊM TRUYỆN VÀO FLASH SALE =====
    const comicSearchInput = document.getElementById('comicSearchInput');
    const searchResults = document.getElementById('searchResults');
    const selectedProductList = document.getElementById('selectedProductList');

    let debounceTimer;

    // Tìm kiếm khi gõ (tự động sau 400ms)
    comicSearchInput?.addEventListener('input', function () {
        clearTimeout(debounceTimer);
        const keyword = this.value.trim();

        if (keyword.length < 2) {
            searchResults.style.display = 'none';
            searchResults.innerHTML = '';
            return;
        }

        debounceTimer = setTimeout(() => {
            fetch(contextPath + '/admin/search-comics?keyword=' + encodeURIComponent(keyword))
                .then(res => res.json())
                .then(data => {
                    searchResults.innerHTML = '';

                    if (data.length === 0) {
                        searchResults.innerHTML = '<div style="padding:15px; text-align:center; color:#888;">Không tìm thấy truyện nào</div>';
                    } else {
                        data.forEach(comic => {
                            const div = document.createElement('div');
                            div.textContent = comic.name;
                            div.style.padding = '12px 16px';
                            div.style.cursor = 'pointer';
                            div.style.borderBottom = '1px solid #eee';

                            div.onmouseover = () => div.style.backgroundColor = '#f5f5f5';
                            div.onmouseout = () => div.style.backgroundColor = '';

                            div.onclick = () => addComicToList(comic.id, comic.name);

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

    // Thêm truyện vào danh sách đã chọn
    function addComicToList(id, name) {
        if (document.getElementById('comic-' + id)) {
            alert('Truyện này đã được thêm rồi!');
            return;
        }

        const placeholder = selectedProductList.querySelector('p');
        if (placeholder) placeholder.remove();

        const item = document.createElement('div');
        item.id = 'comic-' + id;
        item.style.cssText = `display: flex; align-items: center; background: #fafafa; padding: 12px 16px; border-radius: 8px;
                                border: 1px solid #eee; margin-bottom: 10px; gap: 12px;`;

        item.innerHTML = `
            <span style="flex:1; font-weight:500;">${name}</span>
            <button type="button" style="background:#ff4c4c; color:white; border:none; width:30px; height:30px; border-radius:50%; 
                    font-size:18px; cursor:pointer;">×</button>
        `;

        item.querySelector('button').onclick = () => {
            item.remove();
            if (selectedProductList.children.length === 0) {
                selectedProductList.innerHTML =
                    '<p class="empty-message">Chưa có truyện nào được chọn. Hãy tìm và thêm truyện ở trên.</p>';
            }
        };

        selectedProductList.appendChild(item);

        searchResults.style.display = 'none';
        comicSearchInput.value = '';
    }

    // GỬI DỮ LIỆU TẠO FLASH SALE LÊN SERVER
    document.getElementById('createFlashSaleBtn')?.addEventListener('click', function () {
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
                    alert('Lỗi từ server: ' + result.message);
                }
            })
            .catch(err => {
                console.error(err);
                alert('Lỗi kết nối server');
            });
    });

});


// ========== XÓA FLASH SALE ==========
document.addEventListener('DOMContentLoaded', () => {
    const deleteButtons = document.querySelectorAll('.btn-delete');
    const deleteModal = document.getElementById('deleteFlashSaleModal');
    const closeBtn = document.getElementById('closeDeleteFlashSale');
    const confirmBtn = document.getElementById('confirmDeleteFlashSale');

    let deleteId = null;

    deleteButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            deleteId = btn.dataset.id?.trim() || '';
            console.log('Click delete → ID:', deleteId);

            if (!deleteId) {
                alert('Không tìm thấy ID để xóa!');
                return;
            }

            if (deleteModal) deleteModal.style.display = 'flex';
        });
    });

    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            if (deleteModal) deleteModal.style.display = 'none';
            deleteId = null;
        });
    }

    if (confirmBtn) {
        confirmBtn.addEventListener('click', () => {
            if (!deleteId) {
                alert('Không có ID để xóa!');
                if (deleteModal) deleteModal.style.display = 'none';
                return;
            }

            console.log('Gửi xóa ID:', deleteId);

            fetch(`${contextPath}/admin/manage-flashsale`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `action=delete&id=${encodeURIComponent(deleteId)}`
            })
                .then(res => {
                    if (!res.ok) throw new Error(`Lỗi ${res.status}`);
                    return res.json();
                })
                .then(data => {
                    if (deleteModal) deleteModal.style.display = 'none';
                    alert(data.message || (data.success ? 'Xóa thành công!' : 'Xóa thất bại!'));
                    if (data.success) {
                        const row = document.querySelector(`tr[data-id="${deleteId}"]`);
                        if (row) row.remove();
                    }
                })
                .catch(err => {
                    console.error('Lỗi xóa:', err);
                    alert('Có lỗi khi xóa, kiểm tra console!');
                })
                .finally(() => deleteId = null);
        });
    }
});


// ========== XEM CHI TIẾT FLASH SALE ==========
document.addEventListener('DOMContentLoaded', () => {
    const viewButtons = document.querySelectorAll('.btn-view');
    const viewModal = document.getElementById('viewFlashSaleModal');

    viewButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const flashSaleId = btn.dataset.id?.trim();

            if (!flashSaleId) {
                alert('Không tìm thấy ID Flash Sale!');
                return;
            }

            fetch(`${contextPath}/admin/manage-flashsale?action=detail&id=${flashSaleId}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `action=detail&id=${encodeURIComponent(flashSaleId)}`
            })
                .then(res => {
                    if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
                    return res.json();
                })
                .then(result => {
                    if (result.success && result.data) {
                        displayFlashSaleDetail(result.data);
                        viewModal.classList.add('show');
                    } else {
                        alert(result.message || 'Không thể tải thông tin Flash Sale!');
                    }
                })
                .catch(err => {
                    console.error('Lỗi:', err);
                    alert('Có lỗi khi tải thông tin Flash Sale!');
                });
        });
    });

    document.getElementById('closeViewFlashSale')?.addEventListener('click', () => {
        viewModal.classList.remove('show');
    });
});

// Hàm hiển thị chi tiết Flash Sale (GLOBAL - đặt ngoài để có thể gọi từ mọi nơi)
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
            <button type="button" class="cancel-btn" id="closeViewFlashSale">Đóng</button>
        </div>
    `;

    document.getElementById('closeViewFlashSale').addEventListener('click', () => {
        document.getElementById('viewFlashSaleModal').classList.remove('show');
    });
}


// THAY ĐỔI: CHỈNH SỬA FLASH SALE - THÊM TÌM KIẾM TRUYỆN
document.addEventListener('DOMContentLoaded', () => {
    const editModal = document.getElementById('editFlashSaleModal');
    const editProductList = document.getElementById('editSelectedProductList');
    const updateBtn = document.getElementById('updateFlashSaleBtn');
    const closeEditBtn = document.getElementById('closeEditFlashSale');

    // THÊM: Biến lưu trữ state
    let currentEditId = null;
    let currentEditComics = []; // Lưu danh sách truyện hiện tại

    // ========== MỞ POPUP EDIT ==========
    document.querySelectorAll('.openEditFlashSale').forEach(btn => {
        btn.addEventListener('click', () => {
            currentEditId = btn.dataset.id?.trim();
            if (!currentEditId) {
                alert('Không tìm thấy ID Flash Sale!');
                return;
            }

            // Reset state
            currentEditComics = [];
            editProductList.innerHTML = '<p style="text-align:center; color:#888;">Đang tải...</p>';

            // Fetch dữ liệu
            fetch(`${contextPath}/admin/manage-flashsale`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `action=detail&id=${encodeURIComponent(currentEditId)}`
            })
                .then(res => res.json())
                .then(result => {
                    if (result.success && result.data) {
                        fillEditForm(result.data);
                        editModal.classList.add('show');
                    } else {
                        alert(result.message || 'Không thể tải thông tin!');
                    }
                })
                .catch(err => {
                    console.error('❌ Lỗi:', err);
                    alert('Lỗi khi tải dữ liệu Flash Sale!');
                });
        });
    });

    // ========== ĐIỀN DỮ LIỆU VÀO FORM ==========
    function fillEditForm(data) {
        // Điền thông tin cơ bản
        document.getElementById('editFlashSaleId').value = data.id;
        document.getElementById('editFlashSaleName').value = data.name || '';
        document.getElementById('editDiscountPercent').value = data.discountPercent || 30;

        // Điền thời gian
        try {
            const start = convertToISO(data.startTime);
            const end = convertToISO(data.endTime);
            document.getElementById('editStartTime').value = start;
            document.getElementById('editEndTime').value = end;
        } catch (e) {
            console.warn('⚠️ Không parse được thời gian', e);
        }

        // THAY ĐỔI: Điền danh sách truyện (không phải checkbox nữa)
        editProductList.innerHTML = '';
        currentEditComics = [];

        if (data.comics && data.comics.length > 0) {
            data.comics.forEach(comic => {
                currentEditComics.push({ id: comic.id, name: comic.name });
                addComicToEditList(comic.id, comic.name, false);
            });
        } else {
            editProductList.innerHTML = '<p class="empty-message">Chưa có truyện nào. Hãy tìm và thêm truyện.</p>';
        }
    }

    // ========== THÊM MỚI: TÌM KIẾM TRUYỆN TRONG EDIT ==========
    const editComicSearchInput = document.getElementById('editComicSearchInput');
    const editSearchResults = document.getElementById('editSearchResults');
    let editDebounceTimer;

    editComicSearchInput?.addEventListener('input', function () {
        clearTimeout(editDebounceTimer);
        const keyword = this.value.trim();

        if (keyword.length < 2) {
            editSearchResults.style.display = 'none';
            editSearchResults.innerHTML = '';
            return;
        }

        editDebounceTimer = setTimeout(() => {
            fetch(contextPath + '/admin/search-comics?keyword=' + encodeURIComponent(keyword))
                .then(res => res.json())
                .then(data => {
                    editSearchResults.innerHTML = '';

                    if (data.length === 0) {
                        editSearchResults.innerHTML = '<div style="padding:15px; text-align:center; color:#888;">Không tìm thấy truyện nào</div>';
                    } else {
                        data.forEach(comic => {
                            const div = document.createElement('div');
                            div.textContent = comic.name;
                            div.style.cssText = 'padding:12px 16px; cursor:pointer; border-bottom:1px solid #eee;';

                            div.onmouseover = () => div.style.backgroundColor = '#f5f5f5';
                            div.onmouseout = () => div.style.backgroundColor = '';

                            // THÊM: Click để thêm truyện
                            div.onclick = () => addComicToEditList(comic.id, comic.name, true);

                            editSearchResults.appendChild(div);
                        });
                    }
                    editSearchResults.style.display = 'block';
                })
                .catch(err => {
                    console.error('Lỗi:', err);
                    editSearchResults.innerHTML = '<div style="padding:15px; color:red;">Lỗi server</div>';
                    editSearchResults.style.display = 'block';
                });
        }, 400);
    });

    // Ẩn kết quả khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (editSearchResults &&
            !editComicSearchInput?.contains(e.target) &&
            !editSearchResults.contains(e.target)) {
            editSearchResults.style.display = 'none';
        }
    });

    // ========== THÊM MỚI: HÀM THÊM TRUYỆN VÀO DANH SÁCH ==========
    function addComicToEditList(id, name, checkDuplicate = true) {
        // Kiểm tra trùng
        if (checkDuplicate) {
            const exists = currentEditComics.find(c => c.id === id);
            if (exists) {
                alert('Truyện này đã có trong danh sách!');
                return;
            }
        }

        // Xóa placeholder
        const placeholder = editProductList.querySelector('p.empty-message');
        if (placeholder) placeholder.remove();

        // Thêm vào mảng
        if (checkDuplicate) {
            currentEditComics.push({ id, name });
        }

        // Tạo item HTML
        const item = document.createElement('div');
        item.id = 'edit-comic-' + id;
        item.style.cssText = `display: flex; align-items: center; background: #fafafa; padding: 12px 16px; 
                              border-radius: 8px; border: 1px solid #eee; margin-bottom: 10px; gap: 12px;`;

        item.innerHTML = `
            <span style="flex:1; font-weight:500;">${name}</span>
            <button type="button" class="remove-comic-btn" data-comic-id="${id}"
                    style="background:#ff4c4c; color:white; border:none; width:30px; height:30px; 
                           border-radius:50%; font-size:18px; cursor:pointer;">×</button>
        `;

        // THÊM: Xử lý xóa truyện
        item.querySelector('.remove-comic-btn').onclick = () => {
            item.remove();
            currentEditComics = currentEditComics.filter(c => c.id !== id);

            if (editProductList.children.length === 0) {
                editProductList.innerHTML = '<p class="empty-message">Chưa có truyện nào. Hãy tìm và thêm truyện.</p>';
            }
        };

        editProductList.appendChild(item);
        editSearchResults.style.display = 'none';
        editComicSearchInput.value = '';
    }

    // ========== THAY ĐỔI: CẬP NHẬT FLASH SALE ==========
    updateBtn?.addEventListener('click', (e) => {
        e.preventDefault();

        if (!currentEditId) {
            alert('Không có ID để cập nhật!');
            return;
        }

        // Lấy dữ liệu
        const name = document.getElementById('editFlashSaleName').value.trim();
        const discountPercent = document.getElementById('editDiscountPercent').value.trim();
        const startTime = document.getElementById('editStartTime').value;
        const endTime = document.getElementById('editEndTime').value;

        // Validate
        if (!name || !discountPercent || !startTime || !endTime) {
            alert('Vui lòng điền đầy đủ thông tin!');
            return;
        }

        const discount = parseFloat(discountPercent);
        if (isNaN(discount) || discount < 1 || discount > 90) {
            alert('Phần trăm giảm phải từ 1% đến 90%!');
            return;
        }

        if (currentEditComics.length === 0) {
            alert('Vui lòng chọn ít nhất một truyện!');
            return;
        }

        // THAY ĐỔI: Lấy comic IDs từ mảng currentEditComics (không phải từ checkbox)
        const formData = new FormData();
        formData.append('action', 'update');
        formData.append('id', currentEditId);
        formData.append('name', name);
        formData.append('discountPercent', discountPercent);
        formData.append('startTime', startTime);
        formData.append('endTime', endTime);

        currentEditComics.forEach(comic => {
            formData.append('comicIds', comic.id);
        });

        // Gửi request
        fetch(`${contextPath}/admin/manage-flashsale`, {
            method: 'POST',
            body: formData
        })
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    alert('Cập nhật thành công!');
                    editModal.classList.remove('show');
                    location.reload();
                } else {
                    alert('Cập nhật thất bại: ' + (result.message || 'Lỗi không xác định'));
                }
            })
            .catch(err => {
                console.error('Lỗi:', err);
                alert('Lỗi kết nối server!');
            });
    });

    // Đóng popup
    closeEditBtn?.addEventListener('click', () => {
        editModal.classList.remove('show');
        currentEditId = null;
        currentEditComics = [];
    });
});


// Hàm chuyển đổi thời gian (GLOBAL - đặt ngoài để có thể gọi từ mọi nơi)
function convertToISO(formattedTime) {
    if (!formattedTime) return '';
    const [time, date] = formattedTime.split(' ');
    const [hour, min] = time.split(':');
    const [day, month, year] = date.split('/');
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}T${hour.padStart(2, '0')}:${min.padStart(2, '0')}`;
}


// ========== TÌM KIẾM FLASH SALE ==========
document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('searchInput');
    const flashSaleTableBody = document.getElementById('flashSaleTableBody');

    let originalTableContent = flashSaleTableBody.innerHTML;
    let allFlashSaleRows = [];

    function saveOriginalData() {
        allFlashSaleRows = Array.from(flashSaleTableBody.querySelectorAll('tr')).map(row => {
            return {
                element: row.cloneNode(true),
                id: row.dataset.id || '',
                name: row.querySelector('td:nth-child(2)')?.textContent.trim().toLowerCase() || '',
                time: row.querySelector('td:nth-child(3)')?.textContent.trim() || '',
                status: row.querySelector('td:nth-child(4)')?.textContent.trim() || ''
            };
        });
    }

    saveOriginalData();

    searchInput?.addEventListener('input', function() {
        const keyword = this.value.trim().toLowerCase();

        if (keyword === '') {
            flashSaleTableBody.innerHTML = originalTableContent;
            reattachEventListeners();
            return;
        }

        const filteredRows = allFlashSaleRows.filter(row => {
            return row.name.includes(keyword);
        });

        if (filteredRows.length === 0) {
            flashSaleTableBody.innerHTML = `
                <tr>
                    <td colspan="5" style="text-align: center; color: #888; padding: 30px;">
                        Không tìm thấy Flash Sale nào phù hợp với từ khóa "${searchInput.value}"
                    </td>
                </tr>
            `;
        } else {
            flashSaleTableBody.innerHTML = '';
            filteredRows.forEach(row => {
                const clonedRow = row.element.cloneNode(true);
                flashSaleTableBody.appendChild(clonedRow);
            });

            reattachEventListeners();
        }
    });

    function reattachEventListeners() {
        // Gắn lại event cho nút xóa
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const deleteId = btn.dataset.id?.trim() || '';

                if (!deleteId) {
                    alert('Không tìm thấy ID để xóa!');
                    return;
                }

                const deleteModal = document.getElementById('deleteFlashSaleModal');
                if (deleteModal) {
                    deleteModal.style.display = 'flex';

                    const confirmBtn = document.getElementById('confirmDeleteFlashSale');
                    if (confirmBtn) {
                        const newConfirmBtn = confirmBtn.cloneNode(true);
                        confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);

                        newConfirmBtn.addEventListener('click', () => {
                            handleDelete(deleteId, deleteModal);
                        });
                    }
                }
            });
        });

        // Gắn lại event cho nút xem
        document.querySelectorAll('.btn-view').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const flashSaleId = btn.dataset.id?.trim();

                if (!flashSaleId) {
                    alert('Không tìm thấy ID Flash Sale!');
                    return;
                }

                handleViewDetail(flashSaleId);
            });
        });

        // Gắn lại event cho nút sửa
        document.querySelectorAll('.openEditFlashSale').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const flashSaleId = btn.dataset.id?.trim();

                if (!flashSaleId) {
                    alert('Không tìm thấy ID Flash Sale!');
                    return;
                }

                handleEdit(flashSaleId);
            });
        });
    }

    function handleDelete(deleteId, deleteModal) {
        fetch(`${contextPath}/admin/manage-flashsale`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `action=delete&id=${encodeURIComponent(deleteId)}`
        })
            .then(res => {
                if (!res.ok) throw new Error(`Lỗi ${res.status}`);
                return res.json();
            })
            .then(data => {
                if (deleteModal) deleteModal.style.display = 'none';
                alert(data.message || (data.success ? 'Xóa thành công!' : 'Xóa thất bại!'));

                if (data.success) {
                    allFlashSaleRows = allFlashSaleRows.filter(row => row.id !== deleteId);

                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = originalTableContent;
                    const rowToRemove = tempDiv.querySelector(`tr[data-id="${deleteId}"]`);
                    if (rowToRemove) rowToRemove.remove();
                    originalTableContent = tempDiv.innerHTML;

                    const row = document.querySelector(`tr[data-id="${deleteId}"]`);
                    if (row) row.remove();

                    if (flashSaleTableBody.querySelectorAll('tr').length === 0) {
                        flashSaleTableBody.innerHTML = `
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
                console.error('Lỗi xóa:', err);
                alert('Có lỗi khi xóa, kiểm tra console!');
            });
    }

    function handleViewDetail(flashSaleId) {
        const viewModal = document.getElementById('viewFlashSaleModal');

        fetch(`${contextPath}/admin/manage-flashsale`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `action=detail&id=${encodeURIComponent(flashSaleId)}`
        })
            .then(res => {
                if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
                return res.json();
            })
            .then(result => {
                if (result.success && result.data) {
                    displayFlashSaleDetail(result.data);
                    viewModal.classList.add('show');
                } else {
                    alert(result.message || 'Không thể tải thông tin Flash Sale!');
                }
            })
            .catch(err => {
                console.error('Lỗi:', err);
                alert('Có lỗi khi tải thông tin Flash Sale!');
            });
    }

    function handleEdit(flashSaleId) {
        const editModal = document.getElementById('editFlashSaleModal');
        const editProductList = document.querySelector('#editFlashSaleModal .product-select-list');

        editProductList.innerHTML = '<p style="text-align:center; color:#888;">Đang tải...</p>';

        fetch(`${contextPath}/admin/manage-flashsale`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `action=detail&id=${encodeURIComponent(flashSaleId)}`
        })
            .then(res => res.json())
            .then(result => {
                console.log('Edit data received:', result);
                if (result.success && result.data) {
                    // Gọi hàm fillEditForm GLOBAL
                    fillEditFormGlobal(result.data);
                    editModal.classList.add('show');

                    // Lưu ID để dùng cho update button
                    window.currentEditId = flashSaleId;
                } else {
                    alert(result.message || 'Không thể tải thông tin!');
                }
            })
            .catch(err => {
                console.error('Lỗi:', err);
                alert('Lỗi khi tải dữ liệu Flash Sale!');
            });
    }
});

// Hàm điền form edit GLOBAL (để gọi từ cả phần search và phần edit ban đầu)
function fillEditFormGlobal(data) {
    const form = document.getElementById('editFlashSaleForm');
    const editProductList = document.querySelector('#editFlashSaleModal .product-select-list');

    form.querySelector('input[type="text"]').value = data.name || '';
    form.querySelector('input[type="number"]').value = data.discountPercent || 30;

    try {
        const start = convertToISO(data.startTime);
        const end = convertToISO(data.endTime);
        const timeInputs = form.querySelectorAll('input[type="datetime-local"]');
        timeInputs[0].value = start;
        timeInputs[1].value = end;
    } catch (e) {
        console.warn('Không parse được thời gian', e);
    }

    editProductList.innerHTML = '';
    if (data.comics && data.comics.length > 0) {
        data.comics.forEach(comic => {
            const label = document.createElement('label');
            label.innerHTML = `
                <input type="checkbox" data-comic-id="${comic.id}" checked>
                ${comic.name}
            `;
            editProductList.appendChild(label);
        });
    } else {
        editProductList.innerHTML = '<p style="color:#888; text-align:center;">Chưa áp dụng cho truyện nào</p>';
    }
}