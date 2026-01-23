// =====================================================================
// PAGINATION ĐỘNG - TỰ ĐỘNG TÍNH SỐ TRANG DỰA TRÊN SỐ LƯỢNG ĐƠN HÀNG
// =====================================================================

/**
 * Helper function: Kiểm tra xem row có phải là pagination row không
 */
function isPaginationRow(row) {
    const classList = row.classList;
    return classList.contains('pagination-row') ||
        classList.contains('pagination-row-pickup') ||
        classList.contains('pagination-row-delivering') ||
        classList.contains('pagination-row-delivered') ||
        classList.contains('pagination-row-return') ||
        classList.contains('pagination-row-cancelled');
}
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

    // ✅ SỬ DỤNG isPaginationRow() thay vì hardcode
    const allRows = Array.from(tbody.querySelectorAll('tr')).filter(r => !isPaginationRow(r));

    // Tính số trang cần thiết
    const totalPages = Math.ceil(allRows.length / rowsPerPage);

    console.log(`📊 ${tbodyId}: ${allRows.length} rows, ${totalPages} pages`);

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
    if (totalPages > 0) {
        showPage(1, allRows, paginationContainer, pageButtonClass, rowsPerPage);
    }
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

    // Tìm icon search
    const searchIcon = searchInput.parentElement.querySelector('i.fa-magnifying-glass');

    // Hàm thực hiện search
    const performSearch = function() {
        const keyword = searchInput.value.toLowerCase().trim();

        if (!keyword) {
            // Hiển thị lại TẤT CẢ các rows trước
            const allRows = Array.from(tbody.querySelectorAll('tr')).filter(r => !isPaginationRow(r));
            allRows.forEach(row => row.style.display = '');

            // Sau đó mới reset pagination
            initDynamicPagination(tbodyId, paginationId, pageButtonClass, rowsPerPage);
            return;
        }

        const allRows = Array.from(tbody.querySelectorAll('tr')).filter(r => !isPaginationRow(r));
        const visibleRows = allRows.filter(row => {
            const orderCode = row.cells[0].textContent.toLowerCase();
            const customerName = row.cells[1].textContent.toLowerCase();
            return orderCode.includes(keyword) || customerName.includes(keyword);
        });

        allRows.forEach(row => row.style.display = 'none');
        const totalPages = Math.ceil(visibleRows.length / rowsPerPage);
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

        if (totalPages > 0) {
            showPage(1, visibleRows, paginationContainer, pageButtonClass, rowsPerPage);
        }
    };

    // Nhấn Enter để search
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            performSearch();
        }
    });

    searchInput.addEventListener('input', function() {
        if (this.value.trim() === '') {
            performSearch();
        }
    });

    // Click icon để search
    if (searchIcon) {
        searchIcon.style.cursor = 'pointer';
        searchIcon.addEventListener('click', performSearch);
    }
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
    initSearchWithDynamicPagination('pickupSearch', 'pickupTableBody', 'pickupPagination', 'pickup-page', 5)
    initShipConfirmButtons();

    // 3. TAB ĐANG GIAO
    initDynamicPagination('deliverTableBody', 'deliveringPagination', 'delivering-page', 5);
    initSearchWithDynamicPagination('deliverSearch', 'deliverTableBody', 'deliveringPagination', 'delivering-page', 5);
    initOrderDetailButtons();

    // 4. TAB ĐÃ GIAO
    initDynamicPagination('deliveredTableBody', 'deliveredPagination', 'delivered-page', 5);
    initSearchWithDynamicPagination('deliveredSearch', 'deliveredTableBody', 'deliveredPagination', 'delivered-page', 5);

    // 5. TAB TRẢ HÀNG/HOÀN TIỀN
    initDynamicPagination('returnTableBody', 'returnPagination', 'return-page', 5);
    initSearchWithDynamicPagination('returnSearch', 'returnTableBody', 'returnPagination', 'return-page', 5);

    // 6. TAB ĐƠN BỊ HỦY
    initDynamicPagination('cancelledTableBody', 'cancelledPagination', 'cancelled-page', 5);
    initSearchWithDynamicPagination('cancelledSearch', 'cancelledTableBody', 'cancelledPagination', 'cancelled-page', 5);
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


// =====================================================================
// CHỨC NĂNG TÌM KIẾM
// =====================================================================
/**
 * XỬ LÝ TÌM KIẾM ĐƠN HÀNG THEO TỪNG TAB
 * File này xử lý tìm kiếm cho tất cả các tab trong quản lý đơn hàng
 */

(function () {
    'use strict';

    // ================== CONSTANTS ==================
    const SEARCH_DELAY = 500; // Delay 500ms trước khi search (debounce)

    // Mapping giữa tab và status
    const TAB_STATUS_MAP = {
        'tab-pending': 'Pending',
        'tab-pickup': 'AwaitingPickup',
        'tab-delivering': 'Shipping',
        'tab-delivered': 'Completed',
        'tab-return': 'Returned',
        'tab-cancelled': 'Cancelled'
    };

    // Mapping giữa input search và tbody tương ứng
    const SEARCH_CONFIG = {
        'pendingSearch': {
            status: 'Pending',
            tbody: 'confirmTableBody',
            pagination: 'tablePagination',
            pageButtonClass: 'confirm-page',
            noResultMessage: 'Không tìm thấy đơn hàng nào'
        },
        'pickupSearch': {
            status: 'AwaitingPickup',
            tbody: 'pickupTableBody',
            pagination: 'pickupPagination',
            pageButtonClass: 'pickup-page',
            noResultMessage: 'Không tìm thấy đơn hàng nào'
        },
        'deliverSearch': {
            status: 'Shipping',
            tbody: 'deliverTableBody',
            pagination: 'deliveringPagination',
            pageButtonClass: 'delivering-page',
            noResultMessage: 'Không tìm thấy đơn hàng nào'
        },
        'deliveredSearch': {
            status: 'Completed',
            tbody: 'deliveredTableBody',
            pagination: 'deliveredPagination',
            pageButtonClass: 'delivered-page',
            noResultMessage: 'Không tìm thấy đơn hàng nào'
        },
        'returnSearch': {
            status: 'Returned',
            tbody: 'returnTableBody',
            pagination: 'returnPagination',
            pageButtonClass: 'return-page',
            noResultMessage: 'Không tìm thấy đơn hàng nào'
        },
        'cancelledSearch': {
            status: 'Cancelled',
            tbody: 'cancelledTableBody',
            pagination: 'cancelledPagination',
            pageButtonClass: 'cancelled-page',
            noResultMessage: 'Không tìm thấy đơn hàng nào'
        }
    };

    // ================== DEBOUNCE UTILITY ==================
    let searchTimeouts = {};

    function debounce(func, delay, key) {
        return function (...args) {
            clearTimeout(searchTimeouts[key]);
            searchTimeouts[key] = setTimeout(() => func.apply(this, args), delay);
        };
    }

    // ================== SEARCH FUNCTION ==================
    /**
     * Thực hiện tìm kiếm đơn hàng
     */
    function searchOrders(keyword, config) {
        if (!keyword || keyword.trim() === '') {
            location.reload();
            return;
        }

        const tbody = document.getElementById(config.tbody);          // Dùng config.tbody
        const paginationContainer = document.getElementById(config.pagination); // Dùng config.pagination

        if (!tbody || !paginationContainer) {
            console.error('Không tìm thấy tbody hoặc pagination container');
            return;
        }

        // Hiển thị loading
        showLoading(tbody);

        // Gọi API tìm kiếm
        fetch(`${BASE_URL}/admin/orders?action=searchByTab&keyword=${encodeURIComponent(keyword)}&status=${config.status}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    renderSearchResults(data.orders, tbody, config, paginationContainer);
                } else {
                    showError(tbody, data.error || 'Lỗi khi tìm kiếm');
                }
            })
            .catch(error => {
                console.error('Search error:', error);
                showError(tbody, 'Lỗi kết nối: ' + error.message);
            });
    }

    // ================== RENDER FUNCTIONS ==================
    /**
     * Render kết quả tìm kiếm
     */
    function renderSearchResults(orders, tbody, config, paginationContainer) {
        // Xóa tất cả rows trừ pagination, loading, error, no-result
        const rows = tbody.querySelectorAll('tr');
        rows.forEach(row => {
            if (!isPaginationRow(row)) {
                row.remove();
            }
        });

        if (!orders || orders.length === 0) {
            showNoResults(tbody, config.noResultMessage);
            paginationContainer.innerHTML = '';
            return;
        }

        // Render từng đơn hàng theo tab
        const fragment = document.createDocumentFragment();

        orders.forEach(order => {
            const row = createOrderRow(order, config.status);
            fragment.appendChild(row);
        });

        // Insert trước pagination row - tìm bất kỳ dạng pagination row nào
        const paginationRow = Array.from(tbody.querySelectorAll('tr')).find(row => isPaginationRow(row));
        if (paginationRow) {
            tbody.insertBefore(fragment, paginationRow);
        } else {
            tbody.appendChild(fragment);
        }

        // Gắn lại sự kiện cho các nút
        attachButtonEvents(tbody, config.status);

        // Filter rows với logic đầy đủ
        const allRows = Array.from(tbody.querySelectorAll('tr')).filter(r =>
            !isPaginationRow(r) &&
            !r.classList.contains('loading-row') &&
            !r.classList.contains('error-row') &&
            !r.classList.contains('no-result-row')
        );

        const totalPages = Math.ceil(allRows.length / 5);

        paginationContainer.innerHTML = '';

        for (let i = 1; i <= totalPages; i++) {
            const pageBtn = document.createElement('button');
            pageBtn.className = `page-btn ${config.pageButtonClass}`;
            pageBtn.dataset.page = i;
            pageBtn.textContent = i;

            pageBtn.addEventListener('click', function () {
                showPage(i, allRows, paginationContainer, config.pageButtonClass, 5);
            });

            paginationContainer.appendChild(pageBtn);
        }

        // Hiển thị trang đầu tiên
        if (totalPages > 0) {
            showPage(1, allRows, paginationContainer, config.pageButtonClass, 5);
        }
    }

    /**
     * Tạo row cho đơn hàng theo từng tab
     */
    function createOrderRow(order, status) {
        const tr = document.createElement('tr');

        switch (status) {
            case 'Pending':
                tr.innerHTML = createPendingRow(order);
                break;
            case 'AwaitingPickup':
                tr.innerHTML = createPickupRow(order);
                break;
            case 'Shipping':
                tr.innerHTML = createShippingRow(order);
                break;
            case 'Completed':
                tr.innerHTML = createCompletedRow(order);
                break;
            case 'Returned':
                tr.innerHTML = createReturnedRow(order);
                break;
            case 'Cancelled':
                tr.innerHTML = createCancelledRow(order);
                break;
        }

        return tr;
    }

    // ================== ROW TEMPLATES ==================
    /**
     * Template cho tab CHỜ XÁC NHẬN
     */
    function createPendingRow(order) {
        return `
            <td>${order.orderCode || order.id}</td>
            <td>${order.userName || order.recipientName || ''}</td>
            <td>${order.orderDateFormatted || formatDate(order.orderDate)}</td>
            <td>${order.formattedAmount || formatCurrency(order.totalAmount)}</td>
            <td>${order.paymentMethodDisplay || order.paymentMethod || '—'}</td>
            <td class="product-cell">${order.productSummary || ''}</td>
            <td>${order.fullAddress || order.shippingAddress || ''}</td>
            <td>${order.shippingProvider || '—'}</td>
            <td>
                <button class="confirm-btn" data-order-id="${order.id}">Xác nhận</button>
                <button class="cancel-btn" data-order-id="${order.id}">Hủy</button>
            </td>
        `;
    }

    /**
     * Template cho tab CHỜ LẤY HÀNG
     */
    function createPickupRow(order) {
        return `
            <td>${order.orderCode || order.id}</td>
            <td>${order.userName || order.recipientName || ''}</td>
            <td>${order.formattedAmount || formatCurrency(order.totalAmount)}</td>
            <td>${order.shippingProvider || '—'}</td>
            <td>${order.shippingAddress || ''}</td>
            <td>
                <button class="ship-confirm-btn" data-order-id="${order.id}">
                    Xác nhận đã giao cho ĐVVC
                </button>
            </td>
        `;
    }

    /**
     * Template cho tab ĐANG GIAO
     */
    function createShippingRow(order) {
        return `
            <td>${order.orderCode || order.id}</td>
            <td>${order.userName || order.recipientName || ''}</td>
            <td>${order.shippingProvider || '—'}</td>
            <td class="action-cell">
                <button class="btn-de-detail" data-order-id="${order.id}">
                    Xem chi tiết đơn
                </button>
            </td>
        `;
    }

    /**
     * Template cho tab ĐÃ GIAO
     */
    function createCompletedRow(order) {
        return `
            <td>${order.orderCode || order.id}</td>
            <td>${order.userName || order.recipientName || ''}</td>
            <td>${order.orderDateFormatted || formatDate(order.orderDate)}</td>
            <td>${order.formattedAmount || formatCurrency(order.totalAmount)}</td>
            <td>${order.paymentMethodDisplay || order.paymentMethod || '—'}</td>
            <td>${order.transactionId || '—'}</td>
            <td class="stars">
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-regular fa-star-half-stroke"></i>
            </td>
        `;
    }

    /**
     * Template cho tab TRẢ HÀNG/HOÀN TIỀN
     */
    function createReturnedRow(order) {
        return `
            <td>${order.orderCode || order.id}</td>
            <td>${order.userName || order.recipientName || ''}</td>
            <td>Yêu cầu hoàn trả</td>
            <td><span class="status yellow">Đang xem xét</span></td>
            <td><button class="btn-detail">Xem</button></td>
            <td class="action-buttons">
                <button class="btn-refund" onclick="confirmRefund(this)">Xác nhận hoàn tiền</button>
                <button class="btn-reject" onclick="openRejectPopup(this)">Từ chối</button>
            </td>
        `;
    }

    /**
     * Template cho tab ĐƠN BỊ HỦY
     */
    function createCancelledRow(order) {
        const cancelledBy = order.cancelledBy;
        let cancelledByDisplay = '<span style="color: #999;">N/A</span>';

        if (cancelledBy === 'Admin') {
            cancelledByDisplay = '<span style="color: #dc2626; font-weight: 500;"><i class="fas fa-user-shield"></i> Admin</span>';
        } else if (cancelledBy === 'Customer') {
            cancelledByDisplay = '<span style="color: #2563eb; font-weight: 500;"><i class="fas fa-user"></i> Khách hàng</span>';
        }

        return `
            <td>${order.orderCode || order.id}</td>
            <td>${order.userName || order.recipientName || ''}</td>
            <td>${order.orderDateFormatted || formatDate(order.orderDate)}</td>
            <td>${order.cancellationReason || '<span style="color: #999; font-style: italic;">Không có lý do</span>'}</td>
            <td>${cancelledByDisplay}</td>
            <td>${order.cancelledAtFormatted || formatDate(order.cancelledAt)}</td>
        `;
    }

    // ================== HELPER FUNCTIONS ==================
    /**
     * Format currency
     */
    function formatCurrency(amount) {
        if (!amount) return '0đ';
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    /**
     * Format date
     */
    function formatDate(dateStr) {
        if (!dateStr) return 'N/A';
        const date = new Date(dateStr);
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        return `${day}/${month}/${year} ${hours}:${minutes}`;
    }

    /**
     * Hiển thị loading
     */
    function showLoading(tbody) {
        const rows = tbody.querySelectorAll('tr:not([class*="pagination-row"])');
        rows.forEach(row => row.remove());

        const loadingRow = document.createElement('tr');
        loadingRow.className = 'loading-row';
        loadingRow.innerHTML = `
            <td colspan="10" style="text-align: center; padding: 30px;">
                <i class="fas fa-spinner fa-spin" style="font-size: 24px; color: #3b82f6;"></i>
                <p style="margin-top: 10px; color: #666;">Đang tìm kiếm...</p>
            </td>
        `;

        const paginationRow = tbody.querySelector('[class*="pagination-row"]');
        if (paginationRow) {
            tbody.insertBefore(loadingRow, paginationRow);
        } else {
            tbody.appendChild(loadingRow);
        }
    }

    /**
     * Hiển thị lỗi
     */
    function showError(tbody, message) {
        const rows = tbody.querySelectorAll('tr:not([class*="pagination-row"])');
        rows.forEach(row => row.remove());

        const errorRow = document.createElement('tr');
        errorRow.className = 'error-row';
        errorRow.innerHTML = `
        <td colspan="10" style="text-align: center; padding: 50px 30px;">
            <svg width="120" height="120" viewBox="0 0 24 24" fill="none" 
                 style="margin: 0 auto 20px; display: block; opacity: 0.3;">
                <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="2"/>
                <path d="M21 21l-4.35-4.35" stroke="currentColor" 
                      stroke-width="2" stroke-linecap="round"/>
            </svg>
            <p style="color: #999; font-size: 16px; margin: 0;">${message}</p>
        </td>
    `;

        const paginationRow = tbody.querySelector('[class*="pagination-row"]');
        if (paginationRow) {
            tbody.insertBefore(errorRow, paginationRow);
        } else {
            tbody.appendChild(errorRow);
        }
    }

    /**
     * Hiển thị không có kết quả
     */
    function showNoResults(tbody, message) {
        const rows = tbody.querySelectorAll('tr:not([class*="pagination-row"])');
        rows.forEach(row => row.remove());

        const noResultRow = document.createElement('tr');
        noResultRow.className = 'no-result-row';
        noResultRow.innerHTML = `
            <td colspan="10" style="text-align: center; padding: 50px 30px;">
                <svg width="120" height="120" viewBox="0 0 24 24" fill="none" style="margin: 0 auto 20px; display: block; opacity: 0.3;">
                    <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="2"/>
                    <path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
                <p style="color: #999; font-size: 16px; margin: 0;">${message}</p>
            </td>
        `;

        const paginationRow = tbody.querySelector('[class*="pagination-row"]');
        if (paginationRow) {
            tbody.insertBefore(noResultRow, paginationRow);
        } else {
            tbody.appendChild(noResultRow);
        }
    }

    /**
     * Gắn lại sự kiện cho các nút sau khi render
     */
    function attachButtonEvents(tbody, status) {
        // Xác nhận đơn hàng (tab Pending)
        if (status === 'Pending') {
            tbody.querySelectorAll('.confirm-btn').forEach(btn => {
                btn.addEventListener('click', handleConfirmOrder);
            });

            tbody.querySelectorAll('.cancel-btn').forEach(btn => {
                btn.addEventListener('click', handleCancelOrder);
            });
        }

        // Xác nhận giao ĐVVC (tab AwaitingPickup)
        if (status === 'AwaitingPickup') {
            tbody.querySelectorAll('.ship-confirm-btn').forEach(btn => {
                btn.addEventListener('click', handleShipConfirm);
            });
        }

        // Xem chi tiết (tab Shipping)
        if (status === 'Shipping') {
            tbody.querySelectorAll('.btn-de-detail').forEach(btn => {
                btn.addEventListener('click', function () {
                    const orderId = this.dataset.orderId;
                    showOrderDetailPopup(orderId);
                });
            });
        }
    }

    // ================== EVENT HANDLERS ==================
    /**
     * Xử lý xác nhận đơn hàng
     */
    function handleConfirmOrder(e) {
        const orderId = e.target.dataset.orderId;

        if (confirm('Xác nhận đơn hàng này?')) {
            fetch(BASE_URL + '/admin/orders', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=confirm&orderId=' + orderId
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert('Lỗi: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Lỗi kết nối: ' + error);
                });
        }
    }

    /**
     * Xử lý hủy đơn hàng
     */
    function handleCancelOrder(e) {
        const orderId = e.target.dataset.orderId;
        window.currentCancelOrderId = orderId;
        document.querySelector('.cancel-popup').style.display = 'flex';
        document.querySelector('.cancel-popup textarea').value = '';
    }

    /**
     * Xử lý xác nhận đã giao ĐVVC
     */
    function handleShipConfirm(e) {
        const orderId = e.target.dataset.orderId;

        if (confirm('Xác nhận đã giao cho đơn vị vận chuyển?')) {
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
                        alert(data.message);
                        location.reload();
                    } else {
                        alert('Lỗi: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Lỗi kết nối: ' + error);
                });
        }
    }

    // ================== INITIALIZATION ==================
    /**
     * Khởi tạo tìm kiếm cho tất cả các tab
     */
    function initializeSearch() {
        Object.entries(SEARCH_CONFIG).forEach(([inputId, config]) => {
            const searchInput = document.getElementById(inputId);

            if (searchInput) {
                // Tìm icon search
                const searchIcon = searchInput.parentElement.querySelector('i.fa-magnifying-glass');

                // Hàm perform search
                const performSearch = function() {
                    const keyword = searchInput.value.trim();
                    searchOrders(keyword, config);
                };

                // Nhấn Enter
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        performSearch();
                    }
                });

                // Click icon
                if (searchIcon) {
                    searchIcon.style.cursor = 'pointer';
                    searchIcon.addEventListener('click', performSearch);
                }

                console.log(`✅ Search initialized for: ${inputId}`);
            } else {
                console.warn(`⚠️ Search input not found: ${inputId}`);
            }
        });
    }

    // ================== AUTO INIT ==================
    // Khởi tạo khi DOM đã sẵn sàng
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeSearch);
    } else {
        initializeSearch();
    }

})();
