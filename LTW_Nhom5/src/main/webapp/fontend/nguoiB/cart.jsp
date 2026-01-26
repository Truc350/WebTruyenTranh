<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comic Store - Giỏ hàng</title>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/UserBCss/cartCss.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
</head>

<body>
<jsp:include page="/fontend/public/header.jsp"/>

<form id="checkoutForm"
      action="${pageContext.request.contextPath}/checkout"
      method="post">
</form>


<!-- ===================== MAIN CONTENT ===================== -->
<main class="wrapper">
    <!-- CỘT TRÁI: DANH SÁCH SẢN PHẨM (CÓ SCROLL) -->
    <div class="cart-items-container">
        <!-- Header -->
        <div class="cart-header">GIỎ HÀNG</div>

        <!-- Chọn tất cả -->
        <div class="select-all">
            <input type="checkbox" class="item-checkbox" id="select-all"
                   form="checkoutForm"/>
            <label for="select-all"> Chọn tất cả (${fn:length(cartItems)} sản phẩm)</label>
            <div class="quantity-header">Số lượng</div>
            <div class="price-header">Thành tiền</div>
        </div>

        <!-- Scrollable Area -->
        <div class="cart-items-scrollable">
            <div class="cart-items">
                <c:choose>
                    <c:when test="${empty cartItems}">
                        <div style="text-align: center; padding: 40px; color: #999;">
                            <i class="fas fa-shopping-cart" style="font-size: 64px; margin-bottom: 20px;"></i>
                            <p style="font-size: 18px;">Giỏ hàng của bạn đang trống</p>
                            <a href="${pageContext.request.contextPath}/"
                               style="display: inline-block; margin-top: 20px; padding: 10px 30px; background: #e74c3c; color: white; text-decoration: none; border-radius: 5px;">
                                Tiếp tục mua sắm
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- SẢN PHẨM TRONG GIỎ HÀNG -->
                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item" data-comic-id="${item.comic.id}">
                                <input type="checkbox" class="item-checkbox" name="selectedComics" value="${item.comic.id}"
                                       form="checkoutForm"/>
                                <img src="${item.comic.thumbnailUrl}"
                                     alt="${item.comic.nameComics}" class="item-image"/>
                                <div class="item-info">
                                    <div class="item-title">${item.comic.nameComics}</div>
                                    <div class="item-subtitle">${item.comic.nameComics}</div>

                                        <%-- ✅ THAY ĐỔI QUAN TRỌNG: Dùng item.finalPrice thay vì item.comic.discountPrice --%>
                                    <div class="item-price" data-price="${item.finalPrice}">
    <span class="discount-price">
        <fmt:formatNumber value="${item.finalPrice}" type="number" groupingUsed="true"/> đ
    </span>

                                            <%-- Hiển thị badge Flash Sale nếu có --%>
                                        <c:if test="${item.flashSaleId != null}">
                                            <span class="flash-sale-badge">⚡ Flash Sale</span>
                                        </c:if>

                                            <%-- Hiển thị giá gốc bị gạch nếu có giảm giá --%>
                                        <c:if test="${item.finalPrice < item.comic.price}">
                                            <del class="original-price">
                                                <fmt:formatNumber value="${item.comic.price}" type="number" groupingUsed="true"/> đ
                                            </del>
                                        </c:if>
                                    </div>
                                </div>

                                    <%-- Số lượng --%>
                                <div class="quantity-control">
                                    <button type="button" class="quantity-btn minus">-</button>
                                    <input type="text" value="${item.quantity}" class="quantity-input" readonly/>
                                    <button type="button" class="quantity-btn plus">+</button>
                                </div>

                                <div class="item-footer">
                                        <%-- ✅ THAY ĐỔI: Dùng item.subtotal hoặc item.totalPrice --%>
                                    <div class="item-total">
                                        <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/> đ
                                    </div>
                                    <button type="button" class="delete-btn">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- CỘT PHẢI: TỔNG KẾT & THANH TOÁN (STICKY) -->
    <div class="cart-summary">
        <!-- Khuyến mãi -->
        <%--            <div class="promo-section">--%>
        <%--                <div class="promo-header">--%>
        <%--                    <i class="fa-solid fa-tag"></i>--%>
        <%--                    <span>KHUYẾN MÃI</span>--%>
        <%--                    <a href="#" class="view-more">Xem thêm ></a>--%>
        <%--                </div>--%>
        <%--                <div class="promo-item">--%>
        <%--                    <div class="promo-info">--%>
        <%--                        <div class="promo-title">Mã Giảm 10K - Toàn Sàn</div>--%>
        <%--                        <div class="promo-desc">Đơn hàng từ 130k - Không bao gồm giá trị của các sản phẩm sau Manga,--%>
        <%--                            Ngoại...--%>
        <%--                        </div>--%>
        <%--                        <div class="promo-expiry">HSD: 31/10/2025</div>--%>
        <%--                        <div class="progress-bar">--%>
        <%--                            <div class="progress-fill" style="width: 40%;"></div>--%>
        <%--                        </div>--%>
        <%--                        <div class="progress-label">Mua thêm 130.000 đ</div>--%>
        <%--                    </div>--%>
        <%--                    <button class="btn-buy-more">Mua thêm</button>--%>
        <%--                </div>--%>
        <%--                <div class="promo-note">--%>
        <%--                    <i class="fa-solid fa-circle-info"></i>--%>
        <%--                    Có thể áp dụng đồng thời nhiều...--%>
        <%--                </div>--%>
        <%--            </div>--%>
        <!-- Tổng tiền -->
        <div class="total-section">
            <div class="total-row">
                <span>Thành tiền</span>
                <span class="total-price"><fmt:formatNumber value="${checkoutTotal != null ? checkoutTotal : 0}"
                                                            type="number" groupingUsed="true"/> đ
                </span>
            </div>
            <div class="total-row final">
                <span>Tổng Tiền:</span>
                <span class="total-final"><fmt:formatNumber value="${checkoutTotal != null ? checkoutTotal : 0}"
                                                            type="number"
                                                            groupingUsed="true"/> đ</span>
            </div>
        </div>

        <!-- Thanh toán -->
        <div class="checkout-section">
            <button type="submit" id="btnCheckout" form="checkoutForm" class="btn-checkout ${not empty cartItems ? 'active' : ''}">THANH
                TOÁN
            </button>
            <!--            <div class="checkout-note">(Giảm giá trên web chỉ áp dụng cho bán lẻ)</div>-->
        </div>
    </div>
</main>

<!-- Modal yêu cầu đăng nhập -->
<div id="loginModal" class="login-modal">
    <div class="login-modal-content">
        <h3>Bạn cần đăng nhập để mua hàng</h3>
        <div class="login-modal-buttons">
            <a href="${pageContext.request.contextPath}/login" class="login-modal-btn login-modal-btn-primary"  method="post">
                Đăng nhập</a>
            <button type="button" id="closeLoginModal" class="login-modal-btn login-modal-btn-secondary">
                Đóng
            </button>
        </div>
    </div>
</div>

<!-- Thêm Message Box -->
<div class="message-box" id="messageBox">
    <span class="close-msg">&times;</span>
    <p id="messageText"></p>
</div>

<!-- ===================== FOOTER ===================== -->
<jsp:include page="/fontend/public/Footer.jsp"/>

<!-- JavaScript -->
<script>
    // XÓA localStorage khi vừa đăng nhập HOẶC khi giỏ hàng trống
    <c:if test="${not empty sessionScope.clearCartLocalStorage}">
    localStorage.removeItem('cartCheckboxStates');
    <% session.removeAttribute("clearCartLocalStorage"); %>
    </c:if>

    <c:if test="${empty cartItems}">
    localStorage.removeItem('cartCheckboxStates');
    </c:if>

    const contextPath = '${pageContext.request.contextPath}';
    const isLoggedIn = "${not empty sessionScope.currentUser}" === "true";


    // ===== ELEMENTS =====
    const loginModal = document.getElementById("loginModal");
    const closeLoginModal = document.getElementById("closeLoginModal");
    const selectAllCheckbox = document.getElementById("select-all");
    const selectAllLabel = document.querySelector(".select-all label[for='select-all']");
    const totalFinalElement = document.querySelector(".total-final");
    const totalPriceElement = document.querySelector(".total-price");
    const checkoutButton = document.getElementById("btnCheckout");

    // ===== FUNCTIONS =====
    function calculateTotal() {
        const cartItems = document.querySelectorAll(".cart-item");
        let total = 0;
        let count = 0;

        cartItems.forEach(item => {
            const checkbox = item.querySelector(".item-checkbox");
            if (checkbox && checkbox.checked) {
                // ✅ Lấy giá từ data-price (đã là finalPrice)
                const priceText = item.querySelector(".item-price").dataset.price;
                const quantity = parseInt(item.querySelector(".quantity-input").value);
                const price = parseFloat(priceText);

                console.log('Item:', {
                    name: item.querySelector('.item-title').textContent,
                    price: price,
                    quantity: quantity,
                    subtotal: price * quantity
                });

                total += price * quantity;
                count++;
            }
        });

        console.log('Total:', total, 'Count:', count);

        if (totalPriceElement) {
            totalPriceElement.textContent = total.toLocaleString('vi-VN') + ' đ';
        }
        if (totalFinalElement) {
            totalFinalElement.textContent = total.toLocaleString('vi-VN') + ' đ';
        }

        if (checkoutButton) {
            if (count > 0) {
                checkoutButton.classList.add("active");
            } else {
                checkoutButton.classList.remove("active");
            }
        }
    }

    function updateCartItemCount() {
        const itemCount = document.querySelectorAll(".cart-item").length;
        if (selectAllLabel) {
            selectAllLabel.textContent = "Chọn tất cả (" + itemCount + " sản phẩm)";
        }
    }

    function saveCheckboxStates() {
        const states = {};
        document.querySelectorAll(".cart-item").forEach(item => {
            const comicId = item.getAttribute("data-comic-id");
            const checkbox = item.querySelector(".item-checkbox");
            states[comicId] = checkbox.checked;
        });
        localStorage.setItem('cartCheckboxStates', JSON.stringify(states));
    }

    function restoreCheckboxStates() {
        const states = JSON.parse(localStorage.getItem('cartCheckboxStates'));
        if (!states) return;

        const currentComicIds = [];
        document.querySelectorAll(".cart-item").forEach(item => {
            currentComicIds.push(item.getAttribute("data-comic-id"));
        });

        document.querySelectorAll(".cart-item").forEach(item => {
            const comicId = item.getAttribute("data-comic-id");
            const checkbox = item.querySelector(".item-checkbox");

            if (states[comicId]) {
                checkbox.checked = true;
            }
        });

        const cleanedStates = {};
        currentComicIds.forEach(id => {
            if (states[id] !== undefined) {
                cleanedStates[id] = states[id];
            }
        });
        localStorage.setItem('cartCheckboxStates', JSON.stringify(cleanedStates));
    }

    // ===== INIT =====
    window.addEventListener('DOMContentLoaded', function () {
        restoreCheckboxStates();
        updateCartItemCount();
        calculateTotal();
    });

    // ===== EVENT LISTENERS =====
    // Chọn tất cả
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener("change", function () {
            const allCheckboxes = document.querySelectorAll(".cart-item .item-checkbox");
            allCheckboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
            saveCheckboxStates();
            calculateTotal();
        });
    }

    // Checkbox riêng lẻ
    document.querySelectorAll(".cart-item .item-checkbox").forEach(checkbox => {
        checkbox.addEventListener("change", function () {
            if (!this.checked) {
                if (selectAllCheckbox) selectAllCheckbox.checked = false;
            } else {
                const totalCheckboxes = document.querySelectorAll(".cart-item .item-checkbox").length;
                const checkedCheckboxes = document.querySelectorAll(".cart-item .item-checkbox:checked").length;
                if (selectAllCheckbox && totalCheckboxes === checkedCheckboxes) {
                    selectAllCheckbox.checked = true;
                }
            }
            saveCheckboxStates();
            calculateTotal();
        });
    });

    // Tăng/giảm số lượng
    document.querySelectorAll(".quantity-control .quantity-btn").forEach(button => {
        button.addEventListener("click", function () {
            const quantityInput = this.parentElement.querySelector(".quantity-input");
            const comicId = this.closest(".cart-item").getAttribute("data-comic-id");
            let currentValue = parseInt(quantityInput.value);

            if (this.classList.contains("plus")) {
                currentValue++;
            } else if (this.classList.contains("minus") && currentValue > 1) {
                currentValue--;
            }
            window.location.href = contextPath + "/cart?action=update&comicId=" + comicId + "&quantity=" + currentValue;
        });
    });

    // Xóa sản phẩm
    document.querySelectorAll(".delete-btn").forEach(button => {
        button.addEventListener("click", function () {
            const comicId = this.closest(".cart-item").getAttribute("data-comic-id");
            if (confirm("Bạn có chắc muốn xóa sản phẩm này?")) {
                window.location.href = contextPath + "/cart?action=remove&comicId=" + comicId;
            }
        });
    });

    // ===== CHECKOUT HANDLER =====
    const form = document.getElementById("checkoutForm");

    form.addEventListener("submit", function (e) {

        // Chưa đăng nhập
        if (!isLoggedIn) {
            e.preventDefault();
            loginModal.style.display = "block";
            return;
        }

        // Chưa chọn sản phẩm
        const checked = document.querySelectorAll(
            ".cart-item .item-checkbox:checked"
        );

        if (checked.length === 0) {
            e.preventDefault();
            return;
        }
    });


    // ===== MODAL HANDLERS =====
    if (closeLoginModal) {
        closeLoginModal.addEventListener("click", function () {
            if (loginModal) loginModal.style.display = "none";
        });
    }

    window.addEventListener("click", function (event) {
        if (event.target === loginModal) {
            loginModal.style.display = "none";
        }
    });

    <c:if test="${not empty cartItems}">
    <c:set var="hasFlashSale" value="false" />
    <c:forEach var="item" items="${cartItems}">
    <c:if test="${item.flashSaleId != null}">
    <c:set var="hasFlashSale" value="true" />
    </c:if>
    </c:forEach>

    <c:if test="${hasFlashSale}">
    // Có sản phẩm Flash Sale trong giỏ, tự động refresh mỗi 1 phút
    console.log('⚡ Giỏ hàng có sản phẩm Flash Sale, sẽ tự động cập nhật giá');

    setInterval(function() {
        console.log(' Đang cập nhật giá Flash Sale...');
        location.reload();
    }, 60000); // Refresh mỗi 60 giây (1 phút)

    // Hiển thị thông báo cho người dùng
    console.log('💡 Giá sản phẩm Flash Sale sẽ được cập nhật tự động');
    </c:if>
    </c:if>
</script>
</body>
</html>