// ===== deleteComic.js =====
console.log('✅ deleteComic.js loading...');

window.singleComicToDelete = null;
// let deleteModalInitialized = false;
function initDeleteConfirmModal() {
    console.log('🔧 Initializing delete confirm modal...');

    const confirmDeleteModal = document.getElementById('confirmDeleteModal');

    if (!confirmDeleteModal) {
        console.error('❌ confirmDeleteModal NOT FOUND!');
        return;
    }

    // Nút Cancel
    confirmDeleteModal.querySelectorAll('.cancel-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            confirmDeleteModal.style.display = 'none';
            window.singleComicToDelete = null;
        });
    });

    // Nút Xác nhận xóa
    confirmDeleteModal.querySelectorAll('.delete-confirm-btn').forEach(btn => {
        btn.addEventListener('click', async () => {
            await performDelete();
        });
    });

    // Đóng khi click ngoài
    confirmDeleteModal.addEventListener('click', (e) => {
        if (e.target === confirmDeleteModal) {
            confirmDeleteModal.style.display = 'none';
            window.singleComicToDelete = null;
        }
    });

    console.log('✅ Delete modal initialized');
}

window.showDeleteConfirmation = function(comicId, comicName) {
    console.log('🗑️ showDeleteConfirmation called - ID:', comicId);

    if (!comicId) {
        alert('Lỗi: Không tìm thấy ID truyện');
        return;
    }

    window.singleComicToDelete = { id: comicId, name: comicName };

    const confirmBox = document.querySelector('#confirmDeleteModal .confirm-box p');
    if (confirmBox) {
        confirmBox.innerHTML = 'Bạn có chắc muốn xóa truyện <strong>"' + comicName + '"</strong> không?';
    }

    document.getElementById('confirmDeleteModal').style.display = 'flex';
};

async function performDelete() {
    console.log('🗑️ performDelete called');

    if (!window.singleComicToDelete) {
        alert('Không có truyện được chọn');
        return;
    }

    const confirmBtn = document.querySelector('#confirmDeleteModal .delete-confirm-btn');
    const originalText = confirmBtn.innerHTML;
    confirmBtn.disabled = true;
    confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xóa...';

    try {
        const comicId = window.singleComicToDelete.id;

        if (typeof contextPath === 'undefined') {
            throw new Error('contextPath không tồn tại!');
        }

        // ✅ THAY ĐỔI: Gửi dạng URL-encoded thay vì FormData
        const params = new URLSearchParams();
        params.append('comicIds', comicId);

        const response = await fetch(contextPath + '/admin/products/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        });

        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }

        const result = await response.json();
        console.log('📦 Result:', result);

        if (result.success) {
            alert(result.message || 'Xóa thành công!');
            document.getElementById('confirmDeleteModal').style.display = 'none';
            window.singleComicToDelete = null;

            setTimeout(() => {
                if (typeof searchProducts === 'function' && typeof currentPage !== 'undefined') {
                    searchProducts(currentPage);
                } else if (typeof loadInitialComicsList === 'function') {
                    loadInitialComicsList();
                } else {
                    location.reload();
                }
            }, 300);
        } else {
            alert(result.message || 'Có lỗi xảy ra');
        }
    } catch (error) {
        console.error('❌ Error:', error);
        alert('Lỗi: ' + error.message);
    } finally {
        confirmBtn.disabled = false;
        confirmBtn.innerHTML = originalText;
    }
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDeleteConfirmModal);
} else {
    initDeleteConfirmModal();
}

console.log('✅✅✅ deleteComic.js LOADED COMPLETELY! ✅✅✅');