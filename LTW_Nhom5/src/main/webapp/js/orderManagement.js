// =====================================================================
// PAGINATION ĐỘNG - TỰ ĐỘNG TÍNH SỐ TRANG DỰA TRÊN SỐ LƯỢNG ĐƠN HÀNG
// =====================================================================

/**
 * Hàm khởi tạo phân trang động cho một tab
 * @param {string} tbodyId - ID của tbody
 * @param {string} paginationId - ID của container phân trang
 * @param {string} pageButtonClass - Class của nút trang
 * @param {number} rowsPerPage - Số dòng mỗi trang (mặc định 5)
 */
function initDynamicPagination(tbodyId, paginationId, pageButtonClass, rowsPerPage = 5) {
    const tbody = document.getElementById(tbodyId);
    const paginationContainer = document.getElementById(paginationId);

    if (!tbody || !paginationContainer) {
        console.error(`Không tìm thấy tbody (${tbodyId}) hoặc pagination (${paginationId})`);
        return;
    }

    // Lấy tất cả các dòng (trừ dòng pagination)
    const allRows = Array.from(tbody.querySelectorAll('tr'))
        .filter(r => !r.classList.contains('pagination-row') &&
            !r.classList.contains('pagination-row-pickup') &&
            !r.classList.contains('pagination-row-delivering') &&
            !r.classList.contains('pagination-row-delivered') &&
            !r.classList.contains('pagination-row-return') &&
            !r.classList.contains('pagination-row-cancelled'));

    // Tính số trang cần thiết
    const totalPages = Math.ceil(allRows.length / rowsPerPage);

    // Xóa các nút trang cũ
    paginationContainer.innerHTML = '';

    // Tạo các nút trang mới
    for (let i = 1; i <= totalPages; i++) {
        const pageBtn = document.createElement('button');
        pageBtn.className = `page-btn ${pageButtonClass}`;
        pageBtn.dataset.page = i;
        pageBtn.textContent = i;

        // Thêm sự kiện click
        pageBtn.addEventListener('click', function () {
            showPage(i, allRows, paginationContainer, pageButtonClass, rowsPerPage);
        });

        paginationContainer.appendChild(pageBtn);
    }

    // Hiển thị trang đầu tiên
    showPage(1, allRows, paginationContainer, pageButtonClass, rowsPerPage);
}

/**
 * Hiển thị một trang cụ thể
 */
function showPage(pageNumber, rows, paginationContainer, pageButtonClass, rowsPerPage) {
    const start = (pageNumber - 1) * rowsPerPage;
    const end = start + rowsPerPage;

    // Ẩn/hiện các dòng
    rows.forEach((row, idx) => {
        row.style.display = (idx >= start && idx < end) ? '' : 'none';
    });

    // Cập nhật trạng thái active của các nút
    const pageButtons = paginationContainer.querySelectorAll(`.${pageButtonClass}`);
    pageButtons.forEach(btn => btn.classList.remove('active'));

    const currentBtn = paginationContainer.querySelector(`[data-page="${pageNumber}"]`);
    if (currentBtn) {
        currentBtn.classList.add('active');
    }
}

// =====================================================================
// CHỨC NĂNG XÁC NHẬN ĐÃ GIAO CHO ĐVVC (TAB CHỜ LẤY HÀNG)
// =====================================================================

/**
 * Khởi tạo sự kiện cho các nút "Xác nhận đã giao cho ĐVVC"
 */
function initShipConfirmButtons() {
    document.querySelectorAll('.ship-confirm-btn').forEach(btn => {
        // Xóa event listener cũ (nếu có) để tránh duplicate
        const newBtn = btn.cloneNode(true);
        btn.parentNode.replaceChild(newBtn, btn);

        // Thêm event listener mới
        newBtn.addEventListener('click', function () {
            const orderId = this.dataset.orderId;
            handleShipConfirm(orderId, this);
        });
    });
}

/**
 * Xử lý xác nhận giao cho ĐVVC
 */
function handleShipConfirm(orderId, buttonElement) {
    if (!confirm('Xác nhận đã giao đơn hàng này cho đơn vị vận chuyển?')) {
        return;
    }

    // Hiển thị loading trên button
    const originalText = buttonElement.textContent;
    buttonElement.disabled = true;
    buttonElement.textContent = 'Đang xử lý...';

    // Gửi request
    fetch(`${BASE_URL}/admin/orders`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `action=confirmShipped&orderId=${orderId}`
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Hiển thị thông báo thành công
                showNotification('success', data.message || 'Đã xác nhận giao cho ĐVVC thành công!');

                // Reload trang sau 1 giây để cập nhật dữ liệu
                setTimeout(() => {
                    location.reload();
                }, 1000);
            } else {
                // Hiển thị lỗi
                showNotification('error', 'Lỗi: ' + (data.message || data.error));

                // Khôi phục button
                buttonElement.disabled = false;
                buttonElement.textContent = originalText;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('error', 'Lỗi kết nối: ' + error);

            // Khôi phục button
            buttonElement.disabled = false;
            buttonElement.textContent = originalText;
        });
}

/**
 * Hiển thị notification
 */
function showNotification(type, message) {
    // Tạo element notification
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
            <span>${message}</span>
        </div>
    `;

    // Thêm vào body
    document.body.appendChild(notification);

    // Hiển thị
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);

    // Tự động ẩn sau 3 giây
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

// =====================================================================
// CHỨC NĂNG TÌM KIẾM VỚI PAGINATION ĐỘNG
// =====================================================================

/**
 * Khởi tạo tìm kiếm với pagination động
 */
function initSearchWithDynamicPagination(searchInputId, tbodyId, paginationId, pageButtonClass, rowsPerPage = 5) {
    const searchInput = document.getElementById(searchInputId);
    const tbody = document.getElementById(tbodyId);
    const paginationContainer = document.getElementById(paginationId);

    if (!searchInput || !tbody || !paginationContainer) {
        console.error('Không tìm thấy search input, tbody hoặc pagination container');
        return;
    }

    searchInput.addEventListener('input', function () {
        const keyword = this.value.toLowerCase().trim();

        // Lấy tất cả các dòng
        const allRows = Array.from(tbody.querySelectorAll('tr'))
            .filter(r => !r.classList.contains('pagination-row') &&
                !r.classList.contains('pagination-row-pickup') &&
                !r.classList.contains('pagination-row-delivering') &&
                !r.classList.contains('pagination-row-delivered') &&
                !r.classList.contains('pagination-row-return') &&
                !r.classList.contains('pagination-row-cancelled'));

        // Lọc các dòng phù hợp
        const visibleRows = allRows.filter(row => {
            const orderCode = row.cells[0].textContent.toLowerCase();
            const customerName = row.cells[1].textContent.toLowerCase();

            return orderCode.includes(keyword) || customerName.includes(keyword);
        });

        // Ẩn tất cả các dòng
        allRows.forEach(row => row.style.display = 'none');

        // Tính số trang mới
        const totalPages = Math.ceil(visibleRows.length / rowsPerPage);

        // Cập nhật pagination
        paginationContainer.innerHTML = '';

        for (let i = 1; i <= totalPages; i++) {
            const pageBtn = document.createElement('button');
            pageBtn.className = `page-btn ${pageButtonClass}`;
            pageBtn.dataset.page = i;
            pageBtn.textContent = i;

            pageBtn.addEventListener('click', function () {
                showPage(i, visibleRows, paginationContainer, pageButtonClass, rowsPerPage);
            });

            paginationContainer.appendChild(pageBtn);
        }

        // Hiển thị trang đầu tiên
        if (totalPages > 0) {
            showPage(1, visibleRows, paginationContainer, pageButtonClass, rowsPerPage);
        }
    });
}

// =====================================================================
// KHỞI TẠO KHI TRANG TẢI XONG
// =====================================================================

document.addEventListener('DOMContentLoaded', function () {
    console.log('🚀 Initializing Order Management with Dynamic Pagination...');

    // Khởi tạo pagination động cho từng tab

    // 1. TAB CHỜ XÁC NHẬN
    initDynamicPagination('confirmTableBody', 'tablePagination', 'confirm-page', 5);
    initSearchWithDynamicPagination('pendingSearch', 'confirmTableBody', 'tablePagination', 'confirm-page', 5);

    // 2. TAB CHỜ LẤY HÀNG
    initDynamicPagination('pickupTableBody', 'pickupPagination', 'pickup-page', 5);
    initShipConfirmButtons();

    // 3. TAB ĐANG GIAO
    initDynamicPagination('deliverTableBody', 'deliveringPagination', 'delivering-page', 5);
    initOrderDetailButtons();

    // 4. TAB ĐÃ GIAO
    initDynamicPagination('deliveredTableBody', 'deliveredPagination', 'delivered-page', 5);

    // 5. TAB TRẢ HÀNG/HOÀN TIỀN
    initDynamicPagination('returnTableBody', 'returnPagination', 'return-page', 5);

    // 6. TAB ĐƠN BỊ HỦY
    initDynamicPagination('cancelledTableBody', 'cancelledPagination', 'cancelled-page', 5);
});


// =====================================================================
// QUẢN LÝ TRẠNG THÁI TAB (LƯU VÀ KHÔI PHỤC SAU KHI RELOAD)
// =====================================================================

/**
 * Lưu tab hiện tại vào localStorage
 */
function saveCurrentTab(tabIndex) {
    localStorage.setItem('orderManagementActiveTab', tabIndex);
    console.log('💾 Saved tab:', tabIndex);
}

/**
 * Lấy tab đã lưu từ localStorage
 */
function getSavedTab() {
    const saved = localStorage.getItem('orderManagementActiveTab');
    return saved !== null ? parseInt(saved) : null;
}

/**
 * Xóa tab đã lưu
 */
function clearSavedTab() {
    localStorage.removeItem('orderManagementActiveTab');
}

// =====================================================================
// XỬ LÝ POPUP CHI TIẾT ĐƠN HÀNG (TAB ĐANG GIAO)
// =====================================================================

/**
 * Khởi tạo sự kiện cho các nút "Xem chi tiết đơn"
 */
function initOrderDetailButtons() {
    document.querySelectorAll('.btn-de-detail').forEach(btn => {
        // Xóa event listener cũ
        const newBtn = btn.cloneNode(true);
        btn.parentNode.replaceChild(newBtn, btn);

        // Thêm event listener mới
        newBtn.addEventListener('click', function () {
            const orderId = this.dataset.orderId;
            showOrderDetailPopup(orderId);
        });
    });
}

/**
 * Hiển thị popup chi tiết đơn hàng
 */
function showOrderDetailPopup(orderId) {
    // Hiển thị loading
    showLoadingPopup();

    // Gọi API lấy thông tin đơn hàng
    fetch(`${BASE_URL}/admin/orders?action=detail&orderId=${orderId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success && data.order) {
                renderOrderDetailPopup(data.order);
            } else {
                hideLoadingPopup();
                showNotification('error', 'Không thể tải thông tin đơn hàng: ' + (data.error || 'Lỗi không xác định'));
            }
        })
        .catch(error => {
            console.error('Error fetching order detail:', error);
            hideLoadingPopup();
            showNotification('error', 'Lỗi kết nối: ' + error);
        });
}

/**
 * Render popup với dữ liệu thực
 */
function renderOrderDetailPopup(order) {
    // Tạo popup HTML
    const popupHTML = `
        <div class="order-detail-popup active" id="orderDetailPopup">
            <div class="popup-overlay" onclick="closeOrderDetailPopup()"></div>
            <div class="popup-content">
                <div class="popup-header">
                    <h3>Chi tiết đơn hàng #${order.orderCode}</h3>
                    <button class="close-popup" onclick="closeOrderDetailPopup()">&times;</button>
                </div>
                
                <div class="popup-body">
                    <!-- Thông tin cơ bản -->
                    <div class="info-section">
                        <h4>Thông tin đơn hàng</h4>
                        <div class="info-row">
                            <span class="label">Mã đơn hàng:</span>
                            <span class="value">#${order.orderCode}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">Khách hàng:</span>
                            <span class="value">${order.userName}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">Số điện thoại:</span>
                            <span class="value">${order.shippingPhone}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">Địa chỉ giao hàng:</span>
                            <span class="value">${order.shippingAddress}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">Đơn vị vận chuyển:</span>
                            <span class="value">${order.shippingProvider}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">Ngày đặt:</span>
                            <span class="value">${order.orderDateFormatted}</span>
                        </div>
                    </div>

                    <!-- Sản phẩm -->
                    <div class="info-section">
                        <h4>Sản phẩm (${order.itemCount})</h4>
                        <div class="product-list">
                            ${renderProductList(order.items)}
                        </div>
                    </div>

                    <!-- Thông tin thanh toán -->
                    <div class="info-section">
                        <h4>Thông tin thanh toán</h4>
                        <div class="info-row">
                            <span class="label">Phương thức:</span>
                            <span class="value">${order.paymentMethodDisplay}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">Trạng thái:</span>
                            <span class="value">${order.paymentStatusDisplay}</span>
                        </div>
                        ${order.transactionId ? `
                        <div class="info-row">
                            <span class="label">Mã giao dịch:</span>
                            <span class="value">${order.transactionId}</span>
                        </div>
                        ` : ''}
                        <div class="info-row">
                            <span class="label">Phí vận chuyển:</span>
                            <span class="value">${formatCurrency(order.shippingFee)}</span>
                        </div>
                        ${order.pointUsed > 0 ? `
                        <div class="info-row">
                            <span class="label">Xu đã sử dụng:</span>
                            <span class="value highlight">${order.pointUsed} xu</span>
                        </div>
                        ` : ''}
                        <div class="info-row total">
                            <span class="label">Tổng tiền:</span>
                            <span class="value">${order.formattedAmount}</span>
                        </div>
                    </div>

                    <!-- Timeline trạng thái -->
                    <div class="info-section">
                        <h4>Trạng thái giao hàng</h4>
                        <div class="info-row timeline">
                            ${renderTimeline(order.status)}
                        </div>
                    </div>
                </div>
                
                <div class="popup-footer">
                    <button class="btn-close" onclick="closeOrderDetailPopup()">Đóng</button>
                </div>
            </div>
        </div>
    `;

    // Xóa popup cũ (nếu có)
    const oldPopup = document.getElementById('orderDetailPopup');
    if (oldPopup) {
        oldPopup.remove();
    }

    // Thêm popup mới vào body
    document.body.insertAdjacentHTML('beforeend', popupHTML);

    // Ẩn loading
    hideLoadingPopup();
}

/**
 * Render danh sách sản phẩm
 */
function renderProductList(items) {
    if (!items || items.length === 0) {
        return '<p class="no-items">Không có sản phẩm</p>';
    }

    return items.map(item => `
        <div class="product-item">
            ${item.comicImage ? `
            <div class="product-image">
                <img src="${item.comicImage}" alt="${item.comicName}" onerror="this.src='/images/no-image.png'">
            </div>
            ` : ''}
            <div class="product-info">
                <div class="product-name">${item.comicName}</div>
                <div class="product-details">
                    <span>Số lượng: ${item.quantity}</span>
                    <span>Đơn giá: ${item.formattedPrice}</span>
                </div>
            </div>
            <div class="product-total">
                ${formatCurrency(item.priceAtPurchase * item.quantity)}
            </div>
        </div>
    `).join('');
}

/**
 * Render timeline trạng thái đơn hàng
 */
function renderTimeline(currentStatus) {
    const statuses = [
        {key: 'Pending', label: 'Chờ xác nhận'},
        {key: 'AwaitingPickup', label: 'Chờ lấy hàng'},
        {key: 'Shipping', label: 'Đang giao'},
        {key: 'Completed', label: 'Hoàn thành'}
    ];

    const currentIndex = statuses.findIndex(s => s.key === currentStatus);

    return statuses.map((status, index) => {
        let stepClass = 'step';

        if (index < currentIndex) {
            stepClass += ' done';
        } else if (index === currentIndex) {
            stepClass += ' active';
        }

        const isLast = index === statuses.length - 1;

        return `
            <div class="${stepClass}">
                <div class="circle">${index + 1}</div>
                ${!isLast ? '<div class="line"></div>' : ''}
                <p>${status.label}</p>
            </div>
        `;
    }).join('');
}

/**
 * Đóng popup chi tiết đơn hàng
 */
function closeOrderDetailPopup() {
    const popup = document.getElementById('orderDetailPopup');
    if (popup) {
        popup.classList.remove('active');
        setTimeout(() => {
            popup.remove();
        }, 300);
    }
}

/**
 * Hiển thị loading popup
 */
function showLoadingPopup() {
    const loadingHTML = `
        <div class="loading-popup" id="loadingPopup">
            <div class="loading-spinner"></div>
            <p>Đang tải thông tin đơn hàng...</p>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', loadingHTML);
}

/**
 * Ẩn loading popup
 */
function hideLoadingPopup() {
    const loadingPopup = document.getElementById('loadingPopup');
    if (loadingPopup) {
        loadingPopup.remove();
    }
}

/**
 * Format số tiền - Hiển thị dạng "48.000 đ"
 */
function formatCurrency(amount) {
    // Format số với dấu phân cách hàng nghìn
    const formatted = new Intl.NumberFormat('vi-VN').format(amount);
    // Thêm " đ" (có khoảng trắng) thay vì ₫
    return formatted + ' đ';
}

// Export functions để dùng ở nơi khác
window.initOrderDetailButtons = initOrderDetailButtons;
window.closeOrderDetailPopup = closeOrderDetailPopup;