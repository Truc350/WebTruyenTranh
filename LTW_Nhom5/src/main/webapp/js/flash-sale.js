/**
 * Flash Sale Page - Main JavaScript
 * Xử lý countdown timer và các tương tác
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 Flash Sale JS loaded');

    // ============================================
    // 1. COUNTDOWN TIMER
    // ============================================
    initCountdown();

    // ============================================
    // 2. SLOT TIME INTERACTIONS
    // ============================================
    initSlotInteractions();

    // ============================================
    // 3. PRODUCT CARD ANIMATIONS
    // ============================================
    initProductCards();
});

/**
 * Khởi tạo countdown timer ban đầu (từ JSP)
 */
function initCountdown() {
    initCountdownDynamic();
}

/**
 * Khởi tạo countdown động (hỗ trợ cả start và end)
 */
function initCountdownDynamic() {
    const countdownElement = document.getElementById('countdown');
    const endTimeInput = document.getElementById('flashSaleEndTimeMillis');

    if (!countdownElement || !endTimeInput) {
        console.log('⚠️ No countdown element found');
        return;
    }

    const targetTime = parseInt(endTimeInput.value);
    const countdownType = endTimeInput.dataset.countdownType || 'end';

    if (!targetTime || isNaN(targetTime)) {
        console.error('❌ Invalid target time');
        return;
    }

    console.log(`⏰ Countdown initialized (${countdownType}), target time:`, new Date(targetTime));

    // Clear previous interval
    if (window.currentCountdownInterval) {
        clearInterval(window.currentCountdownInterval);
    }

    function updateCountdown() {
        const now = new Date().getTime();
        const distance = targetTime - now;

        if (distance < 0) {
            if (countdownType === 'start') {
                // Flash Sale vừa bắt đầu
                countdownElement.innerHTML = '<div class="expired">🎉 Flash Sale đã bắt đầu!</div>';
            } else {
                // Flash Sale đã kết thúc
                countdownElement.innerHTML = '<div class="expired">⏰ Flash Sale đã kết thúc!</div>';
            }

            clearInterval(window.currentCountdownInterval);

            // Reload trang sau 3 giây
            setTimeout(() => {
                console.log('🔄 Reloading page...');
                location.reload();
            }, 3000);
            return;
        }

        // Tính toán thời gian
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        // Cập nhật từng ô thời gian
        const hoursElement = document.getElementById('hours');
        const minutesElement = document.getElementById('minutes');
        const secondsElement = document.getElementById('seconds');

        // Nếu có ngày, thêm vào giờ
        const totalHours = days * 24 + hours;

        if (hoursElement) hoursElement.textContent = totalHours.toString().padStart(2, '0');
        if (minutesElement) minutesElement.textContent = minutes.toString().padStart(2, '0');
        if (secondsElement) secondsElement.textContent = seconds.toString().padStart(2, '0');
    }

    // Cập nhật ngay lập tức
    updateCountdown();

    // Cập nhật mỗi giây
    window.currentCountdownInterval = setInterval(updateCountdown, 1000);
}

/**
 * Khởi tạo tương tác cho các slot thời gian
 */
function initSlotInteractions() {
    const slots = document.querySelectorAll('.slot');

    if (slots.length === 0) {
        console.log('⚠️ No time slots found');
        return;
    }

    slots.forEach(slot => {
        slot.addEventListener('click', function() {
            const flashSaleId = this.dataset.flashsaleId;
            const status = this.dataset.status;

            console.log('🎯 Clicked slot:', {
                id: flashSaleId,
                status: status
            });

            // Load dữ liệu cho tất cả các trạng thái
            loadFlashSaleComics(flashSaleId);

            // Cập nhật active state cho slot
            slots.forEach(s => s.classList.remove('active'));
            this.classList.add('active');
        });

        // Hover effect
        slot.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px) scale(1.05)';
        });

        slot.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });

    console.log(`✅ Initialized ${slots.length} time slots`);
}

/**
 * Load danh sách comics của Flash Sale
 */
async function loadFlashSaleComics(flashSaleId) {
    const productsContainer = document.getElementById('flashSaleProducts');
    const countdownWrap = document.querySelector('.countdown-wrap');
    const flashSaleHeaderContainer = document.querySelector('.flash-sale-header');

    if (!productsContainer) {
        console.error('❌ Products container not found');
        return;
    }

    // Hiển thị loading
    productsContainer.innerHTML = `
        <div class="loading-container" style="grid-column: 1 / -1; text-align: center; padding: 60px;">
            <i class="fas fa-spinner fa-spin" style="font-size: 48px; color: #ff3b30;"></i>
            <p style="margin-top: 20px; font-size: 18px; color: #666;">Đang tải sản phẩm...</p>
        </div>
    `;

    try {
        const contextPath = window.location.pathname.split('/')[1] ? '/' + window.location.pathname.split('/')[1] : '';
        const response = await fetch(`${contextPath}/api/flash-sale/${flashSaleId}/comics`);

        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        const data = await response.json();

        if (!data.success) {
            throw new Error(data.message || 'Failed to load data');
        }

        const flashSale = data.data.flashSale;
        const comics = data.data.comics;

        console.log('✅ Loaded Flash Sale:', flashSale);
        console.log('✅ Comics count:', comics.length);

        // CẬP NHẬT TÊN FLASH SALE
        if (flashSaleHeaderContainer) {
            const discountPercent = Math.round(flashSale.discountPercent || 0);
            flashSaleHeaderContainer.innerHTML = `
                <h2 class="flash-sale-name">${flashSale.name}</h2>
                <p class="flash-sale-description">Giảm giá đến <strong>${discountPercent}%</strong></p>
            `;
        }

        // CẬP NHẬT COUNTDOWN theo Flash Sale được chọn
        updateCountdownForFlashSale(flashSale, countdownWrap);

        // Render danh sách comics
        renderComics(comics, productsContainer, contextPath);

        // Khởi tạo lại animations cho product cards
        initProductCards();

    } catch (error) {
        console.error('❌ Error loading Flash Sale:', error);
        productsContainer.innerHTML = `
            <div class="error-container" style="grid-column: 1 / -1; text-align: center; padding: 60px;">
                <i class="fas fa-exclamation-triangle" style="font-size: 48px; color: #ff4444;"></i>
                <p style="margin-top: 20px; font-size: 18px; color: #666;">
                    Không thể tải dữ liệu. Vui lòng thử lại sau!
                </p>
            </div>
        `;
        showNotification('Lỗi khi tải dữ liệu Flash Sale!', 'error');
    }
}

/**
 * Cập nhật countdown cho Flash Sale được chọn
 */
function updateCountdownForFlashSale(flashSale, countdownWrap) {
    if (!countdownWrap) {
        console.error('❌ Countdown wrap not found');
        return;
    }

    const countdownLabel = countdownWrap.querySelector('.countdown-label');
    const countdown = countdownWrap.querySelector('.countdown');
    const status = flashSale.status;
    const startTimeMillis = flashSale.startTimeMillis;
    const endTimeMillis = flashSale.endTimeMillis;

    console.log('🔄 Updating countdown for Flash Sale:', {
        id: flashSale.id,
        name: flashSale.name,
        status: status,
        startTime: new Date(startTimeMillis),
        endTime: new Date(endTimeMillis)
    });

    // Xử lý theo status
    if (status === 'scheduled') {
        // Flash Sale chưa bắt đầu - đếm ngược đến startTime
        if (countdownLabel) {
            countdownLabel.textContent = 'Bắt đầu sau';
            countdownLabel.style.color = '#ff9800';
        }

        if (countdown) {
            countdown.innerHTML = `
                <div class="time-box" id="hours">00</div>
                <span class="sep">:</span>
                <div class="time-box" id="minutes">00</div>
                <span class="sep">:</span>
                <div class="time-box" id="seconds">00</div>
            `;
        }

        // Update hidden input với startTime
        updateHiddenCountdownInput(startTimeMillis, 'start', countdownWrap);

    } else if (status === 'active') {
        // Flash Sale đang diễn ra - đếm ngược đến endTime
        if (countdownLabel) {
            countdownLabel.textContent = 'Kết thúc trong';
            countdownLabel.style.color = '#4caf50';
        }

        if (countdown) {
            countdown.innerHTML = `
                <div class="time-box" id="hours">00</div>
                <span class="sep">:</span>
                <div class="time-box" id="minutes">00</div>
                <span class="sep">:</span>
                <div class="time-box" id="seconds">00</div>
            `;
        }

        // Update hidden input với endTime
        updateHiddenCountdownInput(endTimeMillis, 'end', countdownWrap);

    } else if (status === 'ended') {
        // Flash Sale đã kết thúc
        if (countdownLabel) {
            countdownLabel.textContent = '';
        }

        if (countdown) {
            countdown.innerHTML = '<div class="expired">⏰ Flash Sale đã kết thúc!</div>';
        }

        // Clear countdown interval
        if (window.currentCountdownInterval) {
            clearInterval(window.currentCountdownInterval);
            window.currentCountdownInterval = null;
        }

        return; // Không init countdown
    }

    // Reinitialize countdown
    initCountdownDynamic();
}

/**
 * Cập nhật hidden input cho countdown
 */
function updateHiddenCountdownInput(timeMillis, countdownType, countdownWrap) {
    let hiddenInput = document.getElementById('flashSaleEndTimeMillis');

    if (!hiddenInput) {
        hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.id = 'flashSaleEndTimeMillis';
        countdownWrap.appendChild(hiddenInput);
    }

    hiddenInput.value = timeMillis;
    hiddenInput.dataset.countdownType = countdownType;

    console.log('✅ Updated countdown input:', {
        time: new Date(timeMillis),
        type: countdownType
    });
}

/**
 * Render danh sách comics
 */
function renderComics(comics, container, contextPath) {
    if (!comics || comics.length === 0) {
        container.innerHTML = `
            <div class="no-products" style="grid-column: 1 / -1; text-align: center; padding: 60px;">
                <i class="fas fa-box-open" style="font-size: 64px; color: #ccc; margin-bottom: 20px;"></i>
                <p style="font-size: 18px; color: #666;">Không có sản phẩm trong Flash Sale này</p>
            </div>
        `;
        return;
    }

    let html = '';

    comics.forEach(comic => {
        const soldPercent = Math.min((comic.sold_count / 100) * 100, 100);
        const discountPercent = Math.round(comic.discount_percent);

        // Kiểm tra có deal tốt hơn không
        const hasBetterDeal = comic.has_better_deal === true;
        const betterDealBadge = hasBetterDeal ?
            `<div class="better-deal-badge">
                <i class="fas fa-fire"></i> Giảm tốt nhất: ${discountPercent}%
            </div>` : '';

        html += `
            <a href="${contextPath}/comic-detail?id=${comic.id}">
                <div class="product-card ${hasBetterDeal ? 'has-better-deal' : ''}">
                    ${betterDealBadge}
                    <img src="${comic.image_url}"
                         alt="${comic.name}"
                         class="product-image"
                         onerror="this.src='${contextPath}/img/no-image.png'" />

                    <h3 class="product-title">${comic.name}</h3>

                    <div class="price-section">
                        <span class="price">
                            ${formatCurrency(comic.flash_price)}
                        </span>
                        <span class="discount">-${discountPercent}%</span>
                    </div>

                    <div class="price-section">
                        <span class="old-price">
                            ${formatCurrency(comic.original_price)}
                        </span>
                    </div>

                    <div class="progress-bar">
                        <div class="progress-fill" style="width: 0%;"></div>
                    </div>
                    <div class="sold-text">Đã bán ${comic.sold_count}</div>

                    <button class="add-to-cart" onclick="addToCart(${comic.id}, event)">
                        <i class="fas fa-cart-plus"></i> Thêm giỏ hàng
                    </button>
                </div>
            </a>
        `;
    });

    container.innerHTML = html;

    // Animate progress bars after render
    setTimeout(() => {
        const progressBars = container.querySelectorAll('.progress-fill');
        comics.forEach((comic, index) => {
            if (progressBars[index]) {
                const soldPercent = Math.min((comic.sold_count / 100) * 100, 100);
                progressBars[index].style.width = `${soldPercent}%`;
            }
        });
    }, 100);
}

/**
 * Khởi tạo tương tác cho product cards
 */
function initProductCards() {
    const productCards = document.querySelectorAll('.product-card');

    if (productCards.length === 0) {
        console.log('⚠️ No product cards found');
        return;
    }

    productCards.forEach(card => {
        // Animate progress bar khi scroll vào view
        const progressBar = card.querySelector('.progress-fill');
        if (progressBar) {
            const targetWidth = progressBar.style.width;
            progressBar.style.width = '0%';

            // Sử dụng Intersection Observer để animate khi visible
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        setTimeout(() => {
                            progressBar.style.width = targetWidth;
                        }, 100);
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });

            observer.observe(card);
        }

        // Hover effect cho card
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px)';
            this.style.boxShadow = '0 12px 24px rgba(0,0,0,0.2)';
        });

        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)';
        });
    });

    console.log(`✅ Initialized ${productCards.length} product cards`);
}

/**
 * Hàm thêm vào giỏ hàng (được gọi từ nút trong JSP)
 */
async function addToCart(comicId, event) {
    // Prevent link navigation
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }

    console.log('🛒 Adding to cart, comic ID:', comicId);

    try {
        // Lấy contextPath
        const contextPath = window.location.pathname.split('/')[1] ? '/' + window.location.pathname.split('/')[1] : '';

        // Gửi GET request đến servlet (vì CartServlet chỉ xử lý GET)
        const url = `${contextPath}/cart?action=add&comicId=${comicId}&quantity=1&buyNow=false&ajax=true`;

        const response = await fetch(url, {
            method: 'GET',
            credentials: 'same-origin' // Gửi cookie session
        });

        // Kiểm tra response
        if (response.ok) {
            showNotification('✅ Đã thêm vào giỏ hàng!', 'success');
            updateCartCount();
        } else {
            showNotification('❌ Có lỗi xảy ra khi thêm vào giỏ hàng!', 'error');
        }

    } catch (error) {
        console.error('❌ Error adding to cart:', error);
        showNotification('❌ Có lỗi xảy ra khi thêm vào giỏ hàng!', 'error');
    }
}

/**
 * Cập nhật số lượng giỏ hàng (nếu có)
 */
function updateCartCount() {
    const cartCountElement = document.querySelector('.cart-count');
    if (cartCountElement) {
        const currentCount = parseInt(cartCountElement.textContent) || 0;
        cartCountElement.textContent = currentCount + 1;

        // Animation
        cartCountElement.style.transform = 'scale(1.3)';
        setTimeout(() => {
            cartCountElement.style.transform = 'scale(1)';
        }, 200);
    }
}

/**
 * Hiển thị notification
 */
function showNotification(message, type = 'info') {
    // Tìm hoặc tạo notification container
    let notificationContainer = document.getElementById('flash-notification-container');

    if (!notificationContainer) {
        notificationContainer = document.createElement('div');
        notificationContainer.id = 'flash-notification-container';
        notificationContainer.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            max-width: 400px;
        `;
        document.body.appendChild(notificationContainer);
    }

    // Tạo notification element
    const notification = document.createElement('div');
    notification.className = `flash-notification ${type}`;
    notification.style.cssText = `
        background: ${type === 'success' ? '#4CAF50' : type === 'error' ? '#f44336' : '#2196F3'};
        color: white;
        padding: 16px 24px;
        margin-bottom: 10px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        gap: 12px;
        animation: slideIn 0.3s ease;
        font-size: 14px;
        font-weight: 500;
    `;

    // Icon
    const icon = document.createElement('span');
    icon.innerHTML = type === 'success' ? '✓' : type === 'error' ? '✕' : 'ℹ';
    icon.style.cssText = `
        font-size: 20px;
        font-weight: bold;
    `;

    // Message
    const messageSpan = document.createElement('span');
    messageSpan.textContent = message;

    notification.appendChild(icon);
    notification.appendChild(messageSpan);
    notificationContainer.appendChild(notification);

    // Tự động xóa sau 3 giây
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

/**
 * Format number thành tiền tệ
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'decimal'
    }).format(amount) + '₫';
}

// CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }

    .flash-notification {
        transition: all 0.3s ease;
    }

    .flash-notification:hover {
        transform: scale(1.02);
        cursor: pointer;
    }

    .loading-container, .error-container {
        min-height: 300px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }
    
    /* Better Deal Badge */
    .better-deal-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        color: white;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: bold;
        z-index: 2;
        box-shadow: 0 2px 8px rgba(245, 87, 108, 0.4);
        animation: pulse 2s infinite;
    }

    .better-deal-badge i {
        margin-right: 4px;
        animation: fire 1s infinite;
    }

    @keyframes pulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.05);
        }
    }

    @keyframes fire {
        0%, 100% {
            transform: rotate(0deg);
        }
        25% {
            transform: rotate(-10deg);
        }
        75% {
            transform: rotate(10deg);
        }
    }

    .product-card.has-better-deal {
        border: 2px solid #f5576c;
        box-shadow: 0 4px 20px rgba(245, 87, 108, 0.3);
    }
    
    .product-card {
        position: relative;
    }
    
    .expired {
        color: #f44336;
        font-weight: bold;
        font-size: 16px;
        padding: 10px;
        text-align: center;
    }
`;
document.head.appendChild(style);

// Export functions để có thể gọi từ inline onclick
window.addToCart = addToCart;
window.FlashSale = {
    showNotification,
    formatCurrency,
    updateCartCount,
    loadFlashSaleComics
};

console.log('✅ Flash Sale module ready');