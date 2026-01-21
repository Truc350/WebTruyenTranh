<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/UserBCss/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<jsp:include page="/fontend/public/header.jsp"/>

<main>
    <jsp:include page="/fontend/nguoiB/ASideUser.jsp"/>

    <div class="order-history-container">
        <h2>Đơn hàng của tôi</h2>
        <div class="order-filters">
            <div class="filter-tabs">
                <button class="scroll-btn scroll-left" title="Cuộn trái">&lt;</button>
                <div class="tabs-container">
                    <button class="filter-tab" data-filter="pending">Chờ xác nhận</button>
                    <button class="filter-tab" data-filter="shipping">Vận chuyển</button>
                    <button class="filter-tab" data-filter="delivery">Chờ giao hàng</button>
                    <button class="filter-tab active" data-filter="completed">Hoàn thành</button>
                    <button class="filter-tab" data-filter="canceled">Đã hủy</button>
                    <button class="filter-tab" data-filter="refund">Trả hàng/Hoàn tiền</button>
                </div>
                <button class="scroll-btn scroll-right" title="Cuộn phải">&gt;</button>
            </div>
        </div>
        <div class="orders-list">
            <div class="order-item" data-status="completed">
                <div class="order-header">
                    <span class="order-id">ID đơn hàng: #10000095</span>
                    <span class="order-date">09/11/2025</span>
                    <span class="order-status completed">Hoàn thành</span>
                </div>
                <div class="order-content">
                    <div class="product-item">
                        <img src="https://product.hstatic.net/200000343865/product/thanh-pho-len-day-cot-2_b38b1803c2894d72ba2852cacb606a78_master.jpg"
                             alt="truyen tranh" class="product-img">
                        <div class="product-info">
                            <h3>Doraemon - Nobita và cuộc phiêu lưu <br> ở thành phố dây cót</h3>
                            <p class="product-quantity">Số lượng: x1</p>
                            <div class="price-details">
                                <span class="original-price">100.000đ</span>
                                <span class="discount-price">95.000đ</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="order-total">
                    <span>Tổng tiền: <strong>95.000đ</strong></span>
                </div>
                <div class="order-actions">
                    <a href="${pageContext.request.contextPath}/cart">
                        <button class="action-btn buy-again">Mua lại</button>
                    </a>
                    <button id="Evaluate" class="action-btn contact-seller">Đánh giá</button>
                </div>
            </div>

            <div class="no-orders" style="display: none; text-align: center; padding: 60px 20px; color: #666; font-size: 16px;">
                <div style="margin-bottom: 20px;">
                    <img src="https://png.pngtree.com/png-clipart/20230418/original/pngtree-order-confirm-line-icon-png-image_9065104.png"
                         alt="No orders" style="width: 120px; height: auto;">
                </div>
                <p style="margin: 0; font-weight: 500; color: #555;">Bạn chưa có đơn hàng nào cả</p>
            </div>
        </div>
    </div>

    <!-- Popup đánh giá -->
    <div class="popup-backdrop-review" style="display: none;"></div>
    <div class="container-write-review" style="display: none;">
        <div class="header-review">
            <p id="title">VIẾT ĐÁNH GIÁ SẢN PHẨM</p>
            <div class="rating-stars" id="rating-stars">
                <span data-value="1">★</span>
                <span data-value="2">★</span>
                <span data-value="3">★</span>
                <span data-value="4">★</span>
                <span data-value="5">★</span>
            </div>
        </div>
        <div class="field">
            <label for="comment" class="nameDisplay">Nhận xét</label>
            <textarea id="comment" placeholder="Nhập nhận xét của bạn"></textarea>
        </div>
        <div class="field-img">
            <label for="image-upload" class="nameDisplay">Tải ảnh</label>
            <input type="file" id="image-upload" accept="image/*" multiple/>
            <div id="image-preview"></div>
        </div>
        <div class="actions-write-review">
            <button class="cancel-review btn-reivew">Hủy</button>
            <button class="submit-review btn-reivew primary">Gửi nhận xét</button>
        </div>
    </div>
</main>

<jsp:include page="/fontend/public/Footer.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const tabsContainer = document.querySelector('.tabs-container');
        const scrollLeftBtn = document.querySelector('.scroll-left');
        const scrollRightBtn = document.querySelector('.scroll-right');
        const filterTabs = document.querySelectorAll('.filter-tab');
        const orderItems = document.querySelectorAll('.order-item');
        const noOrdersMessage = document.querySelector('.no-orders');

        scrollLeftBtn.addEventListener('click', () => {
            tabsContainer.scrollBy({left: -150, behavior: 'smooth'});
        });

        scrollRightBtn.addEventListener('click', () => {
            tabsContainer.scrollBy({left: 150, behavior: 'smooth'});
        });

        filterTabs.forEach(tab => {
            tab.addEventListener('click', function () {
                filterTabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');

                const filterValue = this.getAttribute('data-filter');
                let visibleCount = 0;

                orderItems.forEach(item => {
                    const status = item.getAttribute('data-status');
                    if (filterValue === 'all' || status === filterValue) {
                        item.style.display = 'block';
                        visibleCount++;
                    } else {
                        item.style.display = 'none';
                    }
                });

                noOrdersMessage.style.display = visibleCount === 0 ? 'block' : 'none';
            });
        });

        document.querySelector('.filter-tab.active').click();

        // Popup đánh giá
        const reviewContainer = document.querySelector('.container-write-review');
        const popupBackdropReview = document.querySelector('.popup-backdrop-review');
        const evaluateBtn = document.querySelector('#Evaluate');
        const cancelReviewBtn = document.querySelector('.cancel-review');
        const submitReviewBtn = document.querySelector('.submit-review');

        if (evaluateBtn) {
            evaluateBtn.addEventListener('click', () => {
                reviewContainer.style.display = 'block';
                popupBackdropReview.style.display = 'block';
            });
        }

        function closeReviewPopup() {
            reviewContainer.style.display = 'none';
            popupBackdropReview.style.display = 'none';
        }

        cancelReviewBtn.addEventListener('click', closeReviewPopup);
        popupBackdropReview.addEventListener('click', closeReviewPopup);

        const ratingStars = document.querySelectorAll('#rating-stars span');
        ratingStars.forEach(star => {
            star.addEventListener('click', () => {
                const value = star.getAttribute('data-value');
                ratingStars.forEach(s => s.classList.remove('active'));
                for (let i = 0; i < value; i++) {
                    ratingStars[i].classList.add('active');
                }
            });
        });

        document.querySelector('#image-upload').addEventListener('change', function () {
            const preview = document.querySelector('#image-preview');
            const files = Array.from(this.files).slice(0, 3);
            preview.innerHTML = '';

            if (this.files.length > 3) {
                alert('Bạn chỉ được tải lên tối đa 3 ảnh!');
            }

            files.forEach(file => {
                if (file.type.startsWith('image/')) {
                    const img = document.createElement('img');
                    img.src = URL.createObjectURL(file);
                    img.style.width = "80px";
                    img.style.height = "80px";
                    img.style.objectFit = "cover";
                    img.style.marginRight = "8px";
                    img.style.borderRadius = "4px";
                    img.style.border = "1px solid #ddd";
                    preview.appendChild(img);
                }
            });

            const dataTransfer = new DataTransfer();
            files.forEach(file => dataTransfer.items.add(file));
            this.files = dataTransfer.files;
        });

        submitReviewBtn.addEventListener('click', () => {
            const comment = document.querySelector('#comment').value.trim();
            const rating = document.querySelectorAll('#rating-stars .active').length;

            if (!comment || rating === 0) {
                alert("Vui lòng nhập đầy đủ thông tin!");
                return;
            }

            alert("Gửi đánh giá thành công!");
            closeReviewPopup();
        });
    });
</script>

</body>
</html>