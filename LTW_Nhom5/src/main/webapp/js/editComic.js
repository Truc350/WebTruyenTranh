let currentEditingComicId = null;

document.addEventListener('DOMContentLoaded', function () {
    const editModal = document.getElementById('editModal');
    const editForm = document.getElementById('editForm');
    const updateBtn = editModal.querySelector('.save-btn');
    const cancelBtn = editModal.querySelector('.cancel-btn');

    // XỬ LÝ NÚT SỬA
    document.addEventListener('click', function (e) {
        if (e.target.closest('.edit-btn')) {
            const btn = e.target.closest('.edit-btn');
            const comicId = btn.dataset.comicId;

            if (comicId) {
                console.log('Opening edit modal for comic:', comicId);
                openEditModal(comicId);
            }
        }
    });

    // CLOSE MODAL
    if (cancelBtn) {
        cancelBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            editModal.style.display = 'none';
            resetEditForm();
        });
    }

    // Click ngoài modal
    editModal.addEventListener('click', (e) => {
        if (e.target === editModal) {
            editModal.style.display = 'none';
            resetEditForm();
        }
    });

    setupEditImageUpload();

    // XỬ LÝ NÚT CẬP NHẬT
    updateBtn.addEventListener('click', async (e) => {
        e.preventDefault();
        e.stopPropagation();
        console.log('Update button clicked!');

        if (!validateEditForm()) {
            return;
        }

        if (!currentEditingComicId) {
            showNotification('Không tìm thấy ID truyện', 'error');
            return;
        }

        const formData = new FormData();
        formData.append('comicId', currentEditingComicId);
        formData.append('nameComics', document.querySelector('#editForm [name="nameComics"]').value.trim());
        formData.append('author', document.querySelector('#editForm [name="author"]').value.trim());
        formData.append('publisher', document.querySelector('#editForm [name="publisher"]').value.trim());
        formData.append('description', document.querySelector('#editForm [name="description"]').value.trim());

        const priceStr = document.querySelector('#editForm [name="price"]').value.replace(/[^\d]/g, '');
        formData.append('price', priceStr);
        formData.append('stockQuantity', document.querySelector('#editForm [name="stockQuantity"]').value);
        formData.append('categoryId', document.querySelector('#editForm [name="categoryId"]').value);

        const seriesId = document.querySelector('#editForm [name="seriesId"]').value;
        if (seriesId) formData.append('seriesId', seriesId);

        const volume = document.querySelector('#editForm [name="volume"]').value;
        if (volume) formData.append('volume', volume);

        const coverInput = document.querySelector('#editForm [name="coverImage"]');
        if (coverInput && coverInput.files[0]) {
            formData.append('coverImage', coverInput.files[0]);
        }

        for (let i = 1; i <= 3; i++) {
            const detailInput = document.querySelector(`#editForm [name="detailImage${i}"]`);
            if (detailInput && detailInput.files[0]) {
                formData.append(`detailImage${i}`, detailInput.files[0]);
            }
        }

        updateBtn.disabled = true;
        updateBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang cập nhật...';

        try {
            const url = contextPath + '/admin/products/update';
            const response = await fetch(url, {
                method: 'POST',
                body: formData
            });

            const result = await response.json();

            if (result.success) {
                showNotification('Cập nhật truyện thành công!', 'success');
                editModal.style.display = 'none';
                resetEditForm();

                setTimeout(() => {
                    if (typeof searchProducts === 'function') {
                        searchProducts(currentPage || 1);
                    } else if (typeof loadInitialComicsList === 'function') {
                        loadInitialComicsList();
                    }
                }, 500);
            } else {
                showNotification(result.message || 'Có lỗi xảy ra', 'error');
                if (result.errors && result.errors.length > 0) {
                    showEditErrors(result.errors);
                }
            }
        } catch (error) {
            console.error('Error:', error);
            showNotification('Lỗi kết nối server: ' + error.message, 'error');
        } finally {
            updateBtn.disabled = false;
            updateBtn.innerHTML = 'Cập nhật';
        }
    });
});

// ✅ HÀM MỞ MODAL
async function openEditModal(comicId) {
    const editModal = document.getElementById('editModal');
    currentEditingComicId = comicId;

    editModal.style.display = 'flex';
    const formLeft = editModal.querySelector('.form-left');
    formLeft.innerHTML = '<p style="text-align: center; padding: 40px;"><i class="fas fa-spinner fa-spin"></i> Đang tải...</p>';

    try {
        const url = contextPath + '/admin/products/get?id=' + comicId;
        console.log('📥 Fetching data from:', url);

        const response = await fetch(url);

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        const result = await response.json();

        console.log('📦 Full Response:', result);
        console.log('📦 Comic Data:', result.comic);

        if (result.success && result.comic) {
            await populateEditForm(result.comic);
        } else {
            throw new Error(result.message || 'Không thể tải dữ liệu truyện');
        }
    } catch (error) {
        console.error('❌ Error loading comic:', error);
        showNotification('Lỗi tải dữ liệu: ' + error.message, 'error');
        editModal.style.display = 'none';
    }
}

// ✅ ĐIỀN DỮ LIỆU VÀO FORM
async function populateEditForm(comic) {
    console.log('📝 Populating form with data:', comic);

    const formLeft = document.getElementById('editForm').querySelector('.form-left');

    if (!comic) {
        console.error('Comic data is null/undefined');
        showNotification('Không có dữ liệu truyện', 'error');
        return;
    }

    formLeft.innerHTML = `
        <div class="form-group">
            <label>Tên truyện: <span style="color: red;">*</span></label>
            <input type="text" name="nameComics" required value="${escapeHtml(comic.nameComics || '')}">
        </div>

        <div class="form-group">
            <label>Bộ truyện:</label>
            <select name="seriesId">
                <option value="">⏳ Đang tải bộ truyện...</option>
            </select>
        </div>

        <div class="form-group">
            <label>Thể loại: <span style="color: red;">*</span></label>
            <select name="categoryId" required>
                <option value="">⏳ Đang tải thể loại...</option>
            </select>
        </div>

        <div class="form-group two-columns">
            <div>
                <label>Số lượng: <span style="color: red;">*</span></label>
                <input type="number" name="stockQuantity" min="0" value="${comic.stockQuantity || 0}" required>
            </div>
            <div>
                <label>Giá: <span style="color: red;">*</span></label>
                <input type="text" name="price" placeholder="VD: 25,000" value="${formatPriceInput(comic.price || 0)}" required>
            </div>
        </div>

        <div class="form-group">
            <label>Tác giả: <span style="color: red;">*</span></label>
            <input type="text" name="author" required value="${escapeHtml(comic.author || '')}">
        </div>

        <div class="form-group">
            <label>Nhà xuất bản:</label>
            <input type="text" name="publisher" value="${escapeHtml(comic.publisher || '')}">
        </div>

        <div class="form-group two-columns">
            <div style="flex: 0.9">
                <label>Ngày đăng:</label>
                <input type="date" name="publishedDate" value="${formatDate(comic.createdAt)}" readonly>
            </div>
            <div style="flex: 1">
                <label>Tập:</label>
                <input type="number" name="volume" min="1" placeholder="VD: 1" value="${comic.volume || ''}">
            </div>
        </div>
    `;

    console.log('✅ Form HTML rendered');

    // ✅ CHỜ DOM CẬP NHẬT
    await new Promise(resolve => setTimeout(resolve, 100));

    // ✅ LOAD CATEGORIES VÀ SERIES
    await loadCategoriesForEdit(comic.categoryId);
    await loadSeriesForEdit(comic.seriesId);

    // ✅ LOAD DESCRIPTION
    const descTextarea = document.querySelector('#editModal [name="description"]');
    if (descTextarea) {
        descTextarea.value = comic.description || '';
        console.log('✅ Description loaded');
    }

    // ✅ LOAD ẢNH BÌA (THUMBNAIL) - TỪ COMIC.THUMBNAILURL
    await loadThumbnailImage(comic.thumbnailUrl);

    // ✅ LOAD 3 ẢNH CHI TIẾT - TỪ COMIC_IMAGES
    await loadDetailImages(comic.id);

    console.log('🎉 Form population complete!');
}

// ✅ HÀM LOAD ẢNH BÌA (BOX ĐẦU TIÊN)
async function loadThumbnailImage(thumbnailUrl) {
    console.log('🖼️ Loading thumbnail:', thumbnailUrl);

    if (!thumbnailUrl) {
        console.warn('⚠️ No thumbnail URL');
        return;
    }

    await new Promise(resolve => setTimeout(resolve, 200));

    const imageBoxes = document.querySelectorAll('#editModal .image-upload');
    if (imageBoxes.length === 0) {
        console.error('❌ No image boxes found!');
        return;
    }

    // ✅ BOX ĐẦU TIÊN = ẢNH BÌA
    const thumbnailBox = imageBoxes[0];
    const preview = thumbnailBox.querySelector('.imgPreview');
    const icon = thumbnailBox.querySelector('.icon');
    const label = thumbnailBox.querySelector('.label');

    if (!preview) {
        console.error('❌ No preview element in thumbnail box');
        return;
    }

    // ✅ XỬ LÝ ĐƯỜNG DẪN ẢNH
    let fullImageUrl = thumbnailUrl;

    if (!fullImageUrl.startsWith('http') &&
        !fullImageUrl.startsWith(contextPath) &&
        !fullImageUrl.startsWith('/')) {
        fullImageUrl = contextPath + '/' + fullImageUrl;
    } else if (fullImageUrl.startsWith('/') && !fullImageUrl.startsWith(contextPath)) {
        fullImageUrl = contextPath + fullImageUrl;
    }

    console.log('🔗 Final thumbnail URL:', fullImageUrl);

    // ✅ XỬ LÝ LỖI KHI LOAD ẢNH
    preview.onerror = function () {
        console.error('❌ Failed to load thumbnail:', fullImageUrl);
        preview.style.display = 'none';
        if (icon) icon.style.display = 'block';
        if (label) label.style.display = 'block';
    };

    preview.onload = function () {
        console.log('✅ Thumbnail loaded successfully');
        preview.style.display = 'block';
        if (icon) icon.style.display = 'none';
        if (label) label.style.display = 'none';
    };

    preview.src = fullImageUrl;
    preview.style.position = 'absolute';
    preview.style.top = '0';
    preview.style.left = '0';
    preview.style.width = '100%';
    preview.style.height = '100%';
    preview.style.objectFit = 'cover';
    preview.style.zIndex = '10';
}

// ✅ HÀM LOAD 3 ẢNH CHI TIẾT (BOX 2, 3, 4)
async function loadDetailImages(comicId) {
    console.log('🖼️ Loading detail images for comic:', comicId);

    try {
        const url = contextPath + '/admin/products/images?comicId=' + comicId;
        console.log('📥 Fetching images from:', url);

        const response = await fetch(url);
        const result = await response.json();

        console.log('📦 Images response:', result);

        if (result.success && result.images && result.images.length > 0) {
            await new Promise(resolve => setTimeout(resolve, 200));

            const imageBoxes = document.querySelectorAll('#editModal .image-upload');

            console.log('📸 Images from DB:', result.images.length);
            console.log('🖼️ Image boxes in DOM:', imageBoxes.length);

            if (imageBoxes.length < 2) {
                console.error('❌ Not enough image boxes!');
                return;
            }

            // ✅ BOX 1 = THUMBNAIL (ĐÃ LOAD Ở TRÊN)
            // ✅ BOX 2, 3, 4 = DETAIL IMAGES

            const maxImages = Math.min(result.images.length, 3);

            for (let i = 0; i < maxImages; i++) {
                const img = result.images[i];
                const boxIndex = i + 1; // Box 2, 3, 4
                const box = imageBoxes[boxIndex];

                if (!box) continue;

                const preview = box.querySelector('.imgPreview');
                const icon = box.querySelector('.icon');
                const label = box.querySelector('.label');

                console.log(`📷 Processing detail image ${i + 1}:`, {
                    url: img.imageUrl,
                    type: img.imageType,
                    hasPreview: !!preview
                });

                if (preview && img.imageUrl) {
                    let fullImageUrl = img.imageUrl;

                    if (!fullImageUrl.startsWith('http') &&
                        !fullImageUrl.startsWith(contextPath) &&
                        !fullImageUrl.startsWith('/')) {
                        fullImageUrl = contextPath + '/' + fullImageUrl;
                    } else if (fullImageUrl.startsWith('/') && !fullImageUrl.startsWith(contextPath)) {
                        fullImageUrl = contextPath + fullImageUrl;
                    }

                    console.log(`🔗 Final detail image ${i + 1} URL:`, fullImageUrl);

                    preview.onerror = function () {
                        console.error(`❌ Failed to load detail image ${i + 1}:`, fullImageUrl);
                        preview.style.display = 'none';
                        if (icon) icon.style.display = 'block';
                        if (label) label.style.display = 'block';
                    };

                    preview.onload = function () {
                        console.log(`✅ Detail image ${i + 1} loaded successfully`);
                        preview.style.display = 'block';
                        if (icon) icon.style.display = 'none';
                        if (label) label.style.display = 'none';
                    };

                    preview.src = fullImageUrl;
                    preview.style.position = 'absolute';
                    preview.style.top = '0';
                    preview.style.left = '0';
                    preview.style.width = '100%';
                    preview.style.height = '100%';
                    preview.style.objectFit = 'cover';
                    preview.style.zIndex = '10';
                } else {
                    console.error(`❌ Failed to load detail image ${i + 1}:`, {
                        hasPreview: !!preview,
                        imageUrl: img.imageUrl
                    });
                }
            }
        } else {
            console.warn('⚠️ No detail images found');
        }
    } catch (error) {
        console.error('❌ Error loading detail images:', error);
    }
}

// LOAD CATEGORIES
async function loadCategoriesForEdit(selectedCategoryId) {
    console.log('📋 loadCategoriesForEdit called with:', selectedCategoryId);

    try {
        const url = contextPath + '/admin/categories/list';
        console.log('📥 Fetching categories from:', url);

        const response = await fetch(url);
        const result = await response.json();

        console.log('📦 Categories response:', result);

        const categorySelect = document.querySelector('#editForm [name="categoryId"]');

        if (!categorySelect) {
            console.error('❌ Category select not found!');
            return;
        }

        if (result.success && result.categories) {
            console.log('✅ Categories loaded:', result.categories.length);

            let options = '<option value="">-- Chọn thể loại --</option>';

            result.categories.forEach(cat => {
                const selected = (cat.id == selectedCategoryId) ? 'selected' : '';
                options += `<option value="${cat.id}" ${selected}>${cat.nameCategories}</option>`;

                if (selected) {
                    console.log('✅ Selected category:', cat.nameCategories);
                }
            });

            categorySelect.innerHTML = options;
            console.log('✅ Category select updated');
        } else {
            console.error('❌ Failed to load categories:', result.message);
        }
    } catch (error) {
        console.error('❌ Error loading categories:', error);
    }
}

// LOAD SERIES
async function loadSeriesForEdit(selectedSeriesId) {
    console.log('📚 loadSeriesForEdit called with:', selectedSeriesId);

    try {
        const url = contextPath + '/admin/series/list';
        console.log('📥 Fetching series from:', url);

        const response = await fetch(url);
        const result = await response.json();

        console.log('📦 Series response:', result);

        const seriesSelect = document.querySelector('#editForm [name="seriesId"]');

        if (!seriesSelect) {
            console.error('❌ Series select not found!');
            return;
        }

        if (result.success && result.series) {
            console.log('✅ Series loaded:', result.series.length);

            let options = '<option value="">-- Chọn bộ truyện --</option>';

            result.series.forEach(s => {
                const selected = (s.id == selectedSeriesId) ? 'selected' : '';
                options += `<option value="${s.id}" ${selected}>${s.seriesName}</option>`;

                if (selected) {
                    console.log('✅ Selected series:', s.seriesName);
                }
            });

            seriesSelect.innerHTML = options;
            console.log('✅ Series select updated');
        } else {
            console.error('❌ Failed to load series:', result.message);
        }
    } catch (error) {
        console.error('❌ Error loading series:', error);
    }
}

// SETUP UPLOAD ẢNH MỚI
function setupEditImageUpload() {
    const uploadBoxes = document.querySelectorAll('#editModal .image-upload');

    uploadBoxes.forEach((uploadBox, index) => {
        const input = uploadBox.querySelector('.editImgInput');
        const imgBox = uploadBox.querySelector('.img-box');

        if (!input) {
            const newInput = document.createElement('input');
            newInput.type = 'file';
            newInput.className = 'editImgInput';
            newInput.accept = 'image/*';
            newInput.hidden = true;

            if (index === 0) {
                newInput.name = 'coverImage';
            } else {
                newInput.name = `detailImage${index}`;
            }

            uploadBox.appendChild(newInput);
        }

        const finalInput = uploadBox.querySelector('.editImgInput');
        const preview = uploadBox.querySelector('.imgPreview');
        const icon = uploadBox.querySelector('.icon');
        const label = uploadBox.querySelector('.label');

        if (imgBox) {
            imgBox.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                finalInput.click();
            });
        }

        if (finalInput) {
            finalInput.addEventListener('change', (e) => {
                const file = e.target.files[0];
                if (!file) return;

                const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
                if (!validTypes.includes(file.type)) {
                    showNotification('Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WEBP)', 'error');
                    finalInput.value = '';
                    return;
                }

                const maxSize = 10 * 1024 * 1024;
                if (file.size > maxSize) {
                    showNotification('Kích thước ảnh không được vượt quá 10MB', 'error');
                    finalInput.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = (e) => {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    if (icon) icon.style.display = 'none';
                    if (label) label.style.display = 'none';
                };
                reader.readAsDataURL(file);
            });
        }
    });
}

// VALIDATE FORM
function validateEditForm() {
    const nameComics = document.querySelector('#editForm [name="nameComics"]').value.trim();
    const author = document.querySelector('#editForm [name="author"]').value.trim();
    const categoryId = document.querySelector('#editForm [name="categoryId"]').value;
    const priceInput = document.querySelector('#editForm [name="price"]').value.trim();
    const stockQuantity = document.querySelector('#editForm [name="stockQuantity"]').value;

    const errors = [];

    if (!nameComics) errors.push('Vui lòng nhập tên truyện');
    if (!author) errors.push('Vui lòng nhập tên tác giả');
    if (!categoryId) errors.push('Vui lòng chọn thể loại');

    const price = parseFloat(priceInput.replace(/[^\d]/g, ''));
    if (!priceInput || isNaN(price) || price <= 0) {
        errors.push('Giá phải lớn hơn 0');
    }

    if (!stockQuantity || parseInt(stockQuantity) < 0) {
        errors.push('Số lượng không được âm');
    }

    if (errors.length > 0) {
        showEditErrors(errors);
        return false;
    }

    return true;
}

// RESET FORM
function resetEditForm() {
    currentEditingComicId = null;

    const form = document.getElementById('editForm');
    if (form) form.reset();

    document.querySelectorAll('#editModal .image-upload').forEach(uploadBox => {
        const preview = uploadBox.querySelector('.imgPreview');
        const icon = uploadBox.querySelector('.icon');
        const label = uploadBox.querySelector('.label');

        if (preview) {
            preview.style.display = 'none';
            preview.src = '';
        }
        if (icon) icon.style.display = 'block';
        if (label) label.style.display = 'block';
    });

    const errorMsg = document.querySelector('#editModal .error-message');
    if (errorMsg) errorMsg.remove();
}

// HIỂN THỊ LỖI
function showEditErrors(errors) {
    const errorHtml = errors.map(err => `<li>${err}</li>`).join('');
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.innerHTML = `
        <div style="background: #fee; border: 1px solid #fcc; padding: 15px; border-radius: 5px; margin: 10px 0;">
            <strong style="color: #c33;">Lỗi:</strong>
            <ul style="margin: 5px 0 0 20px; color: #c33;">
                ${errorHtml}
            </ul>
        </div>
    `;

    const modal = document.getElementById('editModal');
    const existingError = modal.querySelector('.error-message');
    if (existingError) existingError.remove();

    const form = document.getElementById('editForm');
    form.parentElement.insertBefore(errorDiv, form);

    setTimeout(() => errorDiv.remove(), 5000);
}

// HIỂN THỊ THÔNG BÁO
function showNotification(message, type = 'info') {
    const oldNotif = document.querySelector('.notification-popup');
    if (oldNotif) oldNotif.remove();

    const notification = document.createElement('div');
    notification.className = 'notification-popup';

    const bgColor = type === 'success' ? '#4caf50' :
        type === 'error' ? '#f44336' :
            type === 'warning' ? '#ff9800' : '#2196f3';

    const icon = type === 'success' ? 'fa-check-circle' :
        type === 'error' ? 'fa-exclamation-circle' :
            type === 'warning' ? 'fa-exclamation-triangle' : 'fa-info-circle';

    notification.innerHTML = `
        <div style="position: fixed; top: 20px; right: 20px; background: ${bgColor}; color: white; padding: 15px 20px; border-radius: 5px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 10000; display: flex; align-items: center; gap: 10px; min-width: 300px; animation: slideInRight 0.3s ease;">
            <i class="fas ${icon}" style="font-size: 20px;"></i>
            <span style="flex: 1;">${message}</span>
            <button onclick="this.parentElement.parentElement.remove()" style="background: none; border: none; color: white; cursor: pointer; font-size: 20px; padding: 0;">×</button>
        </div>
    `;

    document.body.appendChild(notification);

    setTimeout(() => {
        if (notification.parentElement) {
            notification.style.opacity = '0';
            notification.style.transition = 'opacity 0.3s';
            setTimeout(() => notification.remove(), 300);
        }
    }, 5000);
}

// CSS ANIMATION
if (!document.querySelector('#notification-styles')) {
    const style = document.createElement('style');
    style.id = 'notification-styles';
    style.textContent = `
        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
    `;
    document.head.appendChild(style);
}

// HELPER FUNCTIONS
function formatPriceInput(price) {
    return new Intl.NumberFormat('vi-VN').format(price);
}

function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}