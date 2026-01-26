<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


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
                    <button class="filter-tab ${currentFilter == 'pending' ? 'active' : ''}"
                            data-filter="pending">Chờ xác nhận
                    </button>
                    <button class="filter-tab ${currentFilter == 'shipping' ? 'active' : ''}"
                            data-filter="shipping">Vận chuyển
                    </button>
                    <button class="filter-tab ${currentFilter == 'delivery' ? 'active' : ''}"
                            data-filter="delivery">Chờ giao hàng
                    </button>
                    <button class="filter-tab ${currentFilter == 'completed' ? 'active' : ''}"
                            data-filter="completed">Hoàn thành
                    </button>
                    <button class="filter-tab ${currentFilter == 'canceled' ? 'active' : ''}"
                            data-filter="canceled">Đã hủy
                    </button>
                    <button class="filter-tab ${currentFilter == 'refund' ? 'active' : ''}"
                            data-filter="refund">Trả hàng/Hoàn tiền
                    </button>
                </div>
                <button class="scroll-btn scroll-right" title="Cuộn phải">&gt;</button>
            </div>

        </div>

        <div class="orders-list">
            <%-- Loop qua các đơn hàng đã được filter từ servlet --%>
            <c:forEach var="orderDetail" items="${orderDetails}">
                <c:set var="order" value="${orderDetail.order}"/>
                <c:set var="items" value="${orderDetail.items}"/>

                <%-- Map status sang CSS class và text tiếng Việt --%>
                <c:set var="statusClass" value=""/>
                <c:set var="statusText" value=""/>
                <c:choose>
                    <c:when test="${order.status == 'Pending'}">
                        <c:set var="statusClass" value="pending"/>
                        <c:set var="statusText" value="Chờ xác nhận"/>
                    </c:when>
                    <c:when test="${order.status == 'AwaitingPickup'}">
                        <c:set var="statusClass" value="shipping"/>
                        <c:set var="statusText" value="Vận chuyển"/>
                    </c:when>
                    <c:when test="${order.status == 'Shipping'}">
                        <c:set var="statusClass" value="delivery"/>
                        <c:set var="statusText" value="Chờ giao hàng"/>
                    </c:when>
                    <c:when test="${order.status == 'Completed'}">
                        <c:set var="statusClass" value="completed"/>
                        <c:set var="statusText" value="Hoàn thành"/>
                    </c:when>
                    <c:when test="${order.status == 'Cancelled'}">
                        <c:set var="statusClass" value="canceled"/>
                        <c:set var="statusText" value="Đã hủy"/>
                    </c:when>
                    <c:when test="${order.status == 'Returned'}">
                        <c:set var="statusClass" value="refund"/>
                        <c:set var="statusText" value="Trả hàng/Hoàn tiền"/>
                    </c:when>
                </c:choose>

                <div class="order-item" data-status="${statusClass}">
                    <div class="order-header">
                        <span class="order-id">ID đơn hàng: #${order.id}</span>
                        <span class="order-date">
                                ${order.orderDate}
                        </span>
                        <span class="order-status ${statusClass}">${statusText}</span>
                    </div>

                    <div class="order-content">
                            <%-- Loop qua các sản phẩm --%>
                        <c:forEach var="itemData" items="${items}">
                            <c:set var="item" value="${itemData.item}"/>
                            <c:set var="comic" value="${itemData.comic}"/>

                            <c:if test="${comic != null}">
                                <div class="product-item">
                                    <img src="${comic.thumbnailUrl}"
                                         alt="${comic.nameComics}"
                                         class="product-img"
                                         onerror="this.src='https://via.placeholder.com/100x140?text=No+Image'">
                                    <div class="product-info">
                                        <h3>${comic.nameComics}</h3>
                                        <p class="product-quantity">Số lượng: x${item.quantity}</p>
                                        <div class="price-details">
                                    <span class="discount-price">
                                        <fmt:formatNumber value="${item.priceAtPurchase}" pattern="#,###"/>đ
                                    </span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>

                    <div class="order-total">
                <span>Tổng tiền: <strong>
                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ
                </strong></span>
                    </div>

                        <%-- Action buttons dựa vào status --%>
                    <div class="order-actions">
                        <c:choose>
                            <c:when test="${order.status == 'Completed'}">
                                <a href="${pageContext.request.contextPath}/cart.jsp">
                                    <button class="action-btn buy-again">Mua lại</button>
                                </a>
                                <%--                                <button class="action-btn contact-seller" onclick="openReviewPopup(${order.id})">--%>
                                <%--                                    Đánh giá--%>
                                <%--                                </button>--%>
                                <button class="action-btn contact-seller ${orderDetail.hasReviewed ? 'disabled' : ''}"
                                        onclick="openReviewPopup(${order.id})"
                                    ${orderDetail.hasReviewed ? 'disabled' : ''}>
                                        ${orderDetail.hasReviewed ? 'Đã đánh giá' : 'Đánh giá'}
                                </button>
                            </c:when>

                            <c:when test="${order.status == 'Pending'}">
                                <a href="${pageContext.request.contextPath}/fontend/nguoiB/chat.jsp">
                                    <button class="action-btn contact-seller">Liên hệ</button>
                                </a>
                                <%--                                <button class="action-btn cancel-order" onclick="cancelOrder(${order.id})">--%>
                                <button class="action-btn cancel-order" onclick="openCancelPopup(${order.id})">
                                    Hủy đơn hàng
                                </button>
                            </c:when>

                            <c:when test="${order.status == 'AwaitingPickup'}">
                                <a href="${pageContext.request.contextPath}/fontend/nguoiB/chat.jsp">
                                    <button class="action-btn contact-seller">Liên hệ</button>
                                </a>
                            </c:when>

                            <c:when test="${order.status == 'Shipping'}">
                                <button class="action-btn contact-seller" onclick="returnOrder(${order.id})">
                                    Trả hàng
                                </button>
                                <button class="action-btn receive-order" onclick="receiveOrder(${order.id})">
                                    Đã nhận hàng
                                </button>
                            </c:when>

                            <c:when test="${order.status == 'Cancelled' || order.status == 'Returned'}">
                                <a href="${pageContext.request.contextPath}/cart.jsp">
                                    <button class="action-btn buy-again">Mua lại</button>
                                </a>
                                <a href="${pageContext.request.contextPath}/fontend/nguoiB/chat.jsp">
                                    <button class="action-btn contact-seller">Liên hệ</button>
                                </a>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>

            <%-- Hiển thị message khi không có đơn hàng --%>
            <c:if test="${empty orderDetails}">
                <div class="no-orders" style="text-align: center; padding: 60px 20px; color: #666; font-size: 16px;">
                    <div style="margin-bottom: 20px;">
                        <img src="https://png.pngtree.com/png-clipart/20230418/original/pngtree-order-confirm-line-icon-png-image_9065104.png"
                             alt="No orders" style="width: 120px; height: auto;">
                    </div>
                    <p style="margin: 0; font-weight: 500; color: #555;">Bạn chưa có đơn hàng nào cả</p>
                </div>
            </c:if>
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


    <!-- Popup trả hàng -->
    <div class="popup-backdrop-return" style="display: none;"></div>
    <div class="container-write-review" id="return-popup" style="display: none;">
        <div class="header-review">
            <p id="title">YÊU CẦU TRẢ HÀNG</p>
        </div>
        <div class="field">
            <label for="return-reason" class="nameDisplay">Lý do trả hàng</label>
            <textarea id="return-reason" placeholder="Nhập lý do trả hàng của bạn"></textarea>
        </div>
        <div class="field-img">
            <label for="return-image-upload" class="nameDisplay">Tải ảnh (nếu có)</label>
            <input type="file" id="return-image-upload" accept="image/*" multiple/>
            <div id="return-image-preview"></div>
        </div>
        <div class="actions-write-review">
            <button class="cancel-return btn-reivew">Hủy</button>
            <button class="submit-return btn-reivew primary">Gửi yêu cầu</button>
        </div>
    </div>


    <!--Popup hủy đơn hàng -->
    <div class="popup-backdrop-cancel" style="display: none;"></div>
    <div class="container-write-review" id="cancel-popup" style="display: none;">
        <div class="header-review">
            <p id="title">HỦY ĐƠN HÀNG</p>
        </div>
        <div class="field">
            <label for="cancel-reason" class="nameDisplay">Lý do hủy đơn hàng</label>
            <textarea id="cancel-reason"
                      placeholder="Vui lòng cho chúng tôi biết lý do bạn muốn hủy đơn hàng này"></textarea>
        </div>
        <div class="actions-write-review">
            <button class="cancel-cancel btn-reivew">Đóng</button>
            <button class="submit-cancel btn-reivew primary">Xác nhận hủy</button>
        </div>
    </div>
</main>

<jsp:include page="/fontend/public/Footer.jsp"/>

<script>

    // Biến global để lưu orderId hiện tại
    let currentOrderId = null;

    // Biến global cho return
    let currentReturnOrderId = null;

    //Biến global cho cancel
    let currentCancelOrderId = null;

    //Function mở popup hủy đơn hàng
    function openCancelPopup(orderId) {
        currentCancelOrderId = orderId;
        const cancelPopup = document.querySelector('#cancel-popup');
        const popupBackdropCancel = document.querySelector('.popup-backdrop-cancel');

        // Reset form
        document.querySelector('#cancel-reason').value = '';

        if (cancelPopup && popupBackdropCancel) {
            cancelPopup.style.display = 'block';
            popupBackdropCancel.style.display = 'block';
        }
    }


    // Function mở popup trả hàng
    function openReturnPopup(orderId) {
        currentReturnOrderId = orderId;
        const returnPopup = document.querySelector('#return-popup');
        const popupBackdropReturn = document.querySelector('.popup-backdrop-return');

        // Reset form
        document.querySelector('#return-reason').value = '';
        document.querySelector('#return-image-preview').innerHTML = '';
        document.querySelector('#return-image-upload').value = '';

        if (returnPopup && popupBackdropReturn) {
            returnPopup.style.display = 'block';
            popupBackdropReturn.style.display = 'block';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const tabsContainer = document.querySelector('.tabs-container');
        const scrollLeftBtn = document.querySelector('.scroll-left');
        const scrollRightBtn = document.querySelector('.scroll-right');
        const filterTabs = document.querySelectorAll('.filter-tab');

        // Nút scroll trái/phải cho tabs
        if (scrollLeftBtn) {
            scrollLeftBtn.addEventListener('click', () => {
                tabsContainer.scrollBy({left: -150, behavior: 'smooth'});
            });
        }

        if (scrollRightBtn) {
            scrollRightBtn.addEventListener('click', () => {
                tabsContainer.scrollBy({left: 150, behavior: 'smooth'});
            });
        }

        // Xử lý click tab filter
        filterTabs.forEach(tab => {
            tab.addEventListener('click', function () {
                // Bỏ active cũ, thêm active mới
                filterTabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');

                const filterValue = this.getAttribute('data-filter');

                // Reload trang với parameter filter
                const currentUrl = window.location.href.split('?')[0];
                window.location.href = currentUrl + '?filter=' + filterValue;
            });
        });

        // --- Popup đánh giá ---
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
            if (reviewContainer) reviewContainer.style.display = 'none';
            if (popupBackdropReview) popupBackdropReview.style.display = 'none';
            currentOrderId = null;
        }

        if (cancelReviewBtn) cancelReviewBtn.addEventListener('click', closeReviewPopup);
        if (popupBackdropReview) popupBackdropReview.addEventListener('click', closeReviewPopup);

        // Rating stars
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

        // Upload ảnh review
        const imageUpload = document.querySelector('#image-upload');
        if (imageUpload) {
            imageUpload.addEventListener('change', function () {
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
        }

        // Submit review với FormData
        if (submitReviewBtn) {
            submitReviewBtn.addEventListener('click', () => {
                const comment = document.querySelector('#comment').value.trim();
                const rating = document.querySelectorAll('#rating-stars .active').length;
                const imageUpload = document.querySelector('#image-upload');

                if (!comment || rating === 0) {
                    alert("Vui lòng nhập đầy đủ thông tin và chọn số sao!");
                    return;
                }

                if (!currentOrderId) {
                    alert("Không tìm thấy thông tin đơn hàng!");
                    return;
                }

                // Tạo FormData
                const formData = new FormData();
                formData.append('orderId', currentOrderId);
                formData.append('rating', rating);
                formData.append('comment', comment);

                // Thêm ảnh
                if (imageUpload.files.length > 0) {
                    for (let i = 0; i < imageUpload.files.length; i++) {
                        formData.append('images', imageUpload.files[i]);
                    }
                }

                // Disable nút submit để tránh spam
                submitReviewBtn.disabled = true;
                submitReviewBtn.textContent = 'Đang gửi...';

                fetch('${pageContext.request.contextPath}/submit-review', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Gửi đánh giá thành công!');
                            closeReviewPopup();
                            location.reload();
                        } else {
                            alert(data.message || 'Có lỗi xảy ra, vui lòng thử lại!');
                            submitReviewBtn.disabled = false;
                            submitReviewBtn.textContent = 'Gửi nhận xét';
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra!');
                        submitReviewBtn.disabled = false;
                        submitReviewBtn.textContent = 'Gửi nhận xét';
                    });
            });
        }


        // === Popup trả hàng ===
        const returnPopup = document.querySelector('#return-popup');
        const popupBackdropReturn = document.querySelector('.popup-backdrop-return');
        const cancelReturnBtn = document.querySelector('.cancel-return');
        const submitReturnBtn = document.querySelector('.submit-return');

        function closeReturnPopup() {
            if (returnPopup) returnPopup.style.display = 'none';
            if (popupBackdropReturn) popupBackdropReturn.style.display = 'none';
            currentReturnOrderId = null;
        }

        if (cancelReturnBtn) {
            cancelReturnBtn.addEventListener('click', closeReturnPopup);
        }

        if (popupBackdropReturn) {
            popupBackdropReturn.addEventListener('click', closeReturnPopup);
        }

        // Upload ảnh trả hàng
        const returnImageUpload = document.querySelector('#return-image-upload');
        if (returnImageUpload) {
            returnImageUpload.addEventListener('change', function () {
                const preview = document.querySelector('#return-image-preview');
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
        }

        // Submit trả hàng
        if (submitReturnBtn) {
            submitReturnBtn.addEventListener('click', () => {
                const reason = document.querySelector('#return-reason').value.trim();
                const returnImageUpload = document.querySelector('#return-image-upload');

                if (!reason) {
                    alert("Vui lòng nhập lý do trả hàng!");
                    return;
                }

                if (!currentReturnOrderId) {
                    alert("Không tìm thấy thông tin đơn hàng!");
                    return;
                }

                const formData = new FormData();
                formData.append('orderId', currentReturnOrderId);
                formData.append('reason', reason);

                if (returnImageUpload.files.length > 0) {
                    for (let i = 0; i < returnImageUpload.files.length; i++) {
                        formData.append('images', returnImageUpload.files[i]);
                    }
                }

                submitReturnBtn.disabled = true;
                submitReturnBtn.textContent = 'Đang gửi...';

                fetch('${pageContext.request.contextPath}/submit-return', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Gửi yêu cầu trả hàng thành công!');
                            closeReturnPopup();
                            location.reload();
                        } else {
                            alert(data.message || 'Có lỗi xảy ra, vui lòng thử lại!');
                            submitReturnBtn.disabled = false;
                            submitReturnBtn.textContent = 'Gửi yêu cầu';
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra!');
                        submitReturnBtn.disabled = false;
                        submitReturnBtn.textContent = 'Gửi yêu cầu';
                    });
            });
        }


        //Popup hủy đơn hàng
        const cancelPopup = document.querySelector('#cancel-popup');
        const popupBackdropCancel = document.querySelector('.popup-backdrop-cancel');
        const cancelCancelBtn = document.querySelector('.cancel-cancel');
        const submitCancelBtn = document.querySelector('.submit-cancel');

        function closeCancelPopup() {
            if (cancelPopup) cancelPopup.style.display = 'none';
            if (popupBackdropCancel) popupBackdropCancel.style.display = 'none';
            currentCancelOrderId = null;
        }

        if (cancelCancelBtn) {
            cancelCancelBtn.addEventListener('click', closeCancelPopup);
        }

        if (popupBackdropCancel) {
            popupBackdropCancel.addEventListener('click', closeCancelPopup);
        }

        // Submit hủy đơn hàng
        if (submitCancelBtn) {
            submitCancelBtn.addEventListener('click', () => {
                const reason = document.querySelector('#cancel-reason').value.trim();

                if (!reason) {
                    alert("Vui lòng nhập lý do hủy đơn hàng!");
                    return;
                }

                if (!currentCancelOrderId) {
                    alert("Không tìm thấy thông tin đơn hàng!");
                    return;
                }

                submitCancelBtn.disabled = true;
                submitCancelBtn.textContent = 'Đang xử lý...';

                fetch('${pageContext.request.contextPath}/order-history', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=cancel&orderId=' + currentCancelOrderId + '&reason=' + encodeURIComponent(reason)
                })
                    .then(response => {
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            alert('Hủy đơn hàng thành công!');
                            closeCancelPopup();
                            location.reload();
                        } else {
                            alert(data.message || 'Có lỗi xảy ra, vui lòng thử lại!');
                            submitCancelBtn.disabled = false;
                            submitCancelBtn.textContent = 'Xác nhận hủy';
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra!');
                        submitCancelBtn.disabled = false;
                        submitCancelBtn.textContent = 'Xác nhận hủy';
                    });
            });
        }


    });

    // FUNCTIONS FOR ORDER ACTIONS
    function openReviewPopup(orderId) {
        currentOrderId = orderId;
        const reviewContainer = document.querySelector('.container-write-review');
        const popupBackdropReview = document.querySelector('.popup-backdrop-review');

        // Reset form
        document.querySelector('#comment').value = '';
        document.querySelector('#image-preview').innerHTML = '';
        document.querySelector('#image-upload').value = '';

        // Reset rating stars
        document.querySelectorAll('#rating-stars span').forEach(s => s.classList.remove('active'));

        if (reviewContainer && popupBackdropReview) {
            reviewContainer.style.display = 'block';
            popupBackdropReview.style.display = 'block';
        }
    }

    <%--function cancelOrder(orderId) {--%>
    <%--    if (confirm('Bạn có chắc muốn hủy đơn hàng này?')) {--%>
    <%--        fetch('${pageContext.request.contextPath}/order-history', {--%>
    <%--            method: 'POST',--%>
    <%--            headers: {--%>
    <%--                'Content-Type': 'application/x-www-form-urlencoded',--%>
    <%--            },--%>
    <%--            body: 'action=cancel&orderId=' + orderId--%>
    <%--        })--%>
    <%--            .then(response => response.json())--%>
    <%--            .then(data => {--%>
    <%--                if (data.success) {--%>
    <%--                    alert('Hủy đơn hàng thành công!');--%>
    <%--                    location.reload();--%>
    <%--                } else {--%>
    <%--                    alert('Có lỗi xảy ra, vui lòng thử lại!');--%>
    <%--                }--%>
    <%--            })--%>
    <%--            .catch(error => {--%>
    <%--                console.error('Error:', error);--%>
    <%--                alert('Có lỗi xảy ra!');--%>
    <%--            });--%>
    <%--    }--%>
    <%--}--%>


    function cancelOrder(orderId) {
        openCancelPopup(orderId);
    }

    function receiveOrder(orderId) {
        if (confirm('Xác nhận đã nhận hàng?')) {
            fetch('${pageContext.request.contextPath}/order-history', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=receive&orderId=' + orderId
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Xác nhận thành công!');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra, vui lòng thử lại!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra!');
                });
        }
    }

    function returnOrder(orderId) {
        openReturnPopup(orderId);
    }

</script>

</body>
</html>