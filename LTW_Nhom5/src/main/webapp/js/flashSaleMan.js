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
            <input type="checkbox" checked>
            <span style="flex:1; font-weight:500;">${name}</span>
            <input type="number" class="percent-input" min="1" max="90" placeholder="Giảm %" value="30" style="width:100px;">
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

    // ================== PHẦN MỚI: GỬI DỮ LIỆU TẠO FLASH SALE LÊN SERVER ==================
    // Nút Tạo Flash Sale
    // THAY TOÀN BỘ ĐOẠN NÀY TRONG NÚT createFlashSaleBtn
    document.getElementById('createFlashSaleBtn')?.addEventListener('click', function () {
        // === SỬA MỚI: Lấy dữ liệu trực tiếp từ form (ổn định nhất) ===
        const form = document.getElementById('addFlashSaleForm');
        const name = form.querySelector('input[name="flashSaleName"]')?.value.trim();
        const startTime = form.querySelector('input[name="startTime"]')?.value;
        const endTime = form.querySelector('input[name="endTime"]')?.value;

        // Kiểm tra
        if (!name || !startTime || !endTime) {
            alert('Vui lòng nhập đầy đủ tên Flash Sale và thời gian!');
            return;
        }

        // Lấy danh sách truyện (giữ nguyên)
        const selectedItems = document.querySelectorAll('#selectedProductList > div[id^="comic-"]');
        if (selectedItems.length === 0) {
            alert('Vui lòng chọn ít nhất một truyện!');
            return;
        }

        const comicIds = [];
        const percents = [];

        selectedItems.forEach(item => {
            const comicId = item.id.split('-')[1];
            const percentInput = item.querySelector('.percent-input');
            const percent = percentInput?.value.trim() || '30';
            comicIds.push(comicId);
            percents.push(percent);
        });

        // Gửi dữ liệu (giữ nguyên)
        const formData = new FormData();
        formData.append('flashSaleName', name);
        formData.append('startTime', startTime);
        formData.append('endTime', endTime);
        comicIds.forEach(id => formData.append('comicIds', id));
        percents.forEach(p => formData.append('percents', p));

        fetch(contextPath + '/admin/create-flashsale', {
            method: 'POST',

            body: formData
        })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('Tạo Flash Sale thành công!');
                    document.getElementById('addFlashSaleModal').classList.remove('show');
                    // Optional: reset form hoặc reload
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