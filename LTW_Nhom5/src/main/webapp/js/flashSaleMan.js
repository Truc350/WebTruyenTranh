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

    // Popup sửa
    document.querySelectorAll(".openEditFlashSale").forEach(btn => {
        btn.onclick = () => {
            document.getElementById("editFlashSaleModal").classList.add("show");
        };
    });
    document.getElementById("closeEditFlashSale").onclick = () => {
        document.getElementById("editFlashSaleModal").classList.remove("show");
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
    // document.querySelectorAll(".btn-delete").forEach(btn => {
    //     btn.onclick = () => {
    //         document.getElementById("deleteFlashSaleModal").classList.add("show");
    //     };
    // });
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

    // ===== TÌM KIẾM VÀ THÊM TRUYỆN VÀO FLASH SALE (giữ nguyên như bạn đã làm) =====
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
    // Nút Tạo Flash Sale

    document.getElementById('createFlashSaleBtn')?.addEventListener('click', function () {
        const form = document.getElementById('addFlashSaleForm');
        const name = form.querySelector('input[name="flashSaleName"]')?.value.trim();
        const discountPercent = form.querySelector('input[name="discountPercent"]')?.value.trim(); // ← THÊM MỚI
        const startTime = form.querySelector('input[name="startTime"]')?.value;
        const endTime = form.querySelector('input[name="endTime"]')?.value;

        // Kiểm tra
        if (!name || !discountPercent || !startTime || !endTime) {
            alert('Vui lòng nhập đầy đủ thông tin!');
            return;
        }

        // Validate discount percent
        const discount = parseFloat(discountPercent);
        if (isNaN(discount) || discount < 1 || discount > 90) {
            alert('Phần trăm giảm phải từ 1% đến 90%!');
            return;
        }

        // Lấy danh sách truyện
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

        // Gửi dữ liệu
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


// cái này delete flash sale

// flashSaleMan.js
document.addEventListener('DOMContentLoaded', () => {
    const deleteButtons = document.querySelectorAll('.btn-delete');
    const deleteModal = document.getElementById('deleteFlashSaleModal');
    const closeBtn = document.getElementById('closeDeleteFlashSale');
    const confirmBtn = document.getElementById('confirmDeleteFlashSale');

    let deleteId = null;

    // Mở modal xóa
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

    // Đóng modal
    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            if (deleteModal) deleteModal.style.display = 'none';
            deleteId = null;
        });
    }

    // Xác nhận xóa
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



//  xem chi tiết
// Xử lý nút xem chi tiết
// Thêm đoạn code này vào file flashSaleMan.js

document.addEventListener('DOMContentLoaded', () => {
    // Xử lý nút xem chi tiết
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

            // Gọi API để lấy chi tiết
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

    // Đóng popup xem chi tiết
    document.getElementById('closeViewFlashSale')?.addEventListener('click', () => {
        viewModal.classList.remove('show');
    });
});

// Hàm hiển thị chi tiết Flash Sale lên popup
function displayFlashSaleDetail(data) {
    const viewInfoBox = document.querySelector('#viewFlashSaleModal .view-info-box');

    if (!viewInfoBox) return;

    // Chuyển đổi trạng thái sang tiếng Việt
    const statusText = {
        'active': 'Đang diễn ra',
        'scheduled': 'Sắp diễn ra',
        'ended': 'Đã diễn ra'
    };

    // Tạo HTML cho danh sách sản phẩm
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

    // Cập nhật nội dung popup
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

    // Gắn lại sự kiện đóng cho nút mới tạo
    document.getElementById('closeViewFlashSale').addEventListener('click', () => {
        document.getElementById('viewFlashSaleModal').classList.remove('show');
    });
}

//edit cho từng cái flash sale
// ========== SỬA JAVASCRIPT - Edit Flash Sale ==========

document.addEventListener('DOMContentLoaded', () => {
    const editModal = document.getElementById('editFlashSaleModal');
    const editProductList = document.querySelector('#editFlashSaleModal .product-select-list'); // ← SỬA SELECTOR
    const updateBtn = document.querySelector('#editFlashSaleModal .save-btn'); // ← SỬA SELECTOR
    const closeEditBtn = document.getElementById('closeEditFlashSale');

    let currentEditId = null;

    // Mở popup + load dữ liệu từ API detail
    document.querySelectorAll('.openEditFlashSale').forEach(btn => {
        btn.addEventListener('click', () => {
            currentEditId = btn.dataset.id?.trim();
            if (!currentEditId) {
                alert('Không tìm thấy ID Flash Sale!');
                return;
            }

            editProductList.innerHTML = '<p style="text-align:center; color:#888;">Đang tải...</p>';

            fetch(`${contextPath}/admin/manage-flashsale`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `action=detail&id=${encodeURIComponent(currentEditId)}`
            })
                .then(res => res.json())
                .then(result => {
                    console.log('Data nhận được:', result);
                    if (result.success && result.data) {
                        fillEditForm(result.data);
                        editModal.classList.add('show');
                    } else {
                        alert(result.message || 'Không thể tải thông tin!');
                    }
                })
                .catch(err => {
                    console.error('Lỗi:', err);
                    alert('Lỗi khi tải dữ liệu Flash Sale!');
                });
        });
    });

    // Đóng popup
    closeEditBtn?.addEventListener('click', () => {
        editModal.classList.remove('show');
        currentEditId = null;
    });

    // Hàm điền dữ liệu vào form
    function fillEditForm(data) {
        // ← SỬA: Lấy đúng input từ form edit
        const form = document.getElementById('editFlashSaleForm');

        // Thông tin cơ bản
        form.querySelector('input[type="text"]').value = data.name || '';
        form.querySelector('input[type="number"]').value = data.discountPercent || 30; // ← SỬA: discountPercent thay vì discount

        // Thời gian (chuyển định dạng từ "HH:mm dd/MM/yyyy" sang ISO)
        try {
            const start = convertToISO(data.startTime);
            const end = convertToISO(data.endTime);
            const timeInputs = form.querySelectorAll('input[type="datetime-local"]');
            timeInputs[0].value = start;
            timeInputs[1].value = end;
        } catch (e) {
            console.warn('Không parse được thời gian', e);
        }

        // Danh sách comics đang áp dụng
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

    // Submit cập nhật
    updateBtn?.addEventListener('click', (e) => {
        e.preventDefault();

        if (!currentEditId) return alert('Không có ID để cập nhật!');

        const form = document.getElementById('editFlashSaleForm');
        const name = form.querySelector('input[type="text"]').value.trim();
        const discountPercent = form.querySelector('input[type="number"]').value.trim();
        const timeInputs = form.querySelectorAll('input[type="datetime-local"]');
        const startTime = timeInputs[0].value;
        const endTime = timeInputs[1].value;

        if (!name || !discountPercent || !startTime || !endTime) {
            alert('Vui lòng điền đầy đủ thông tin!');
            return;
        }

        // Validate discount percent
        const discount = parseFloat(discountPercent);
        if (isNaN(discount) || discount < 1 || discount > 90) {
            alert('Phần trăm giảm phải từ 1% đến 90%!');
            return;
        }

        // Lấy danh sách comicIds còn lại (chỉ những cái vẫn được tick)
        const selectedComicIds = [];
        editProductList.querySelectorAll('input[type="checkbox"]:checked').forEach(cb => {
            const comicId = cb.getAttribute('data-comic-id');
            if (comicId) selectedComicIds.push(comicId);
        });

        const formData = new FormData();
        formData.append('action', 'update');
        formData.append('id', currentEditId);
        formData.append('name', name);
        formData.append('discountPercent', discountPercent);
        formData.append('startTime', startTime);
        formData.append('endTime', endTime);
        selectedComicIds.forEach(id => formData.append('comicIds', id));

        // ← THÊM LOG ĐỂ DEBUG
        console.log('=== FormData gửi đi ===');
        for (let [key, value] of formData.entries()) {
            console.log(key + ': ' + value);
        }

        console.log('Gửi update với data:', {
            id: currentEditId,
            name,
            discountPercent,
            startTime,
            endTime,
            comicIds: selectedComicIds
        });

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
                console.error('Lỗi update:', err);
                alert('Lỗi kết nối server!');
            });
    });
});

// Hàm chuyển đổi thời gian từ "HH:mm dd/MM/yyyy" sang ISO format
function convertToISO(formattedTime) {
    if (!formattedTime) return '';
    const [time, date] = formattedTime.split(' ');
    const [hour, min] = time.split(':');
    const [day, month, year] = date.split('/');
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}T${hour.padStart(2, '0')}:${min.padStart(2, '0')}`;
}