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

<!-- ===================== MAIN CONTENT ===================== -->
<main class="wrapper">
    <!-- CỘT TRÁI: DANH SÁCH SẢN PHẨM (CÓ SCROLL) -->
    <div class="cart-items-container">
        <!-- Header -->
        <div class="cart-header">GIỎ HÀNG</div>

        <!-- Chọn tất cả -->
        <div class="select-all">
            <input type="checkbox" class="item-checkbox" id="select-all"/>
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
                        <c:forEach var="item" items="${cartItems}">
                            <%--TRÂM--%>
                            <!--Sản phẩm -->
                            <div class="cart-item" data-comic-id="${item.comic.id}">
                                <input type="checkbox" class="item-checkbox"/>
                                <img src="${item.comic.thumbnailUrl}"
                                     alt="${item.comic.nameComics}" class="item-image"/>
                                <div class="item-info">
                                    <div class="item-title">${item.comic.nameComics}</div>
                                    <div class="item-subtitle">${item.comic.nameComics}</div>
                                    <div class="item-price">
                                        <fmt:formatNumber value="${item.comic.discountPrice}" type="number"
                                                          groupingUsed="true"/> đ
                                        <c:if test="${item.comic.discountPrice < item.comic.price}">
                                            <del><fmt:formatNumber value="${item.comic.price}" type="number"
                                                                   groupingUsed="true"/> đ
                                            </del>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="quantity-control">
                                    <button class="quantity-btn minus">-</button>
                                    <input type="text" value="${item.quantity}" class="quantity-input" readonly/>
                                    <button class="quantity-btn plus">+</button>
                                </div>

                                <div class="item-footer">
                                    <div class="item-total">
                                        <fmt:formatNumber value="${item.comic.discountPrice * item.quantity}"
                                                          type="number" groupingUsed="true"/> đ
                                    </div>
                                    <button class="delete-btn">
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
        <div class="promo-section">
            <div class="promo-header">
                <i class="fa-solid fa-tag"></i>
                <span>KHUYẾN MÃI</span>
                <a href="#" class="view-more">Xem thêm ></a>
            </div>
            <div class="promo-item">
                <div class="promo-info">
                    <div class="promo-title">Mã Giảm 10K - Toàn Sàn</div>
                    <div class="promo-desc">Đơn hàng từ 130k - Không bao gồm giá trị của các sản phẩm sau Manga,
                        Ngoại...
                    </div>
                    <div class="promo-expiry">HSD: 31/10/2025</div>
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: 40%;"></div>
                    </div>
                    <div class="progress-label">Mua thêm 130.000 đ</div>
                </div>
                <button class="btn-buy-more">Mua thêm</button>
            </div>
            <div class="promo-note">
                <i class="fa-solid fa-circle-info"></i>
                Có thể áp dụng đồng thời nhiều...
            </div>
        </div>
        <!-- Tổng tiền -->
        <div class="total-section">
            <div class="total-row">
                <span>Thành tiền</span>
                <span class="total-price"><fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/> đ
                </span>
            </div>
            <div class="total-row final">
                <span>Tổng Tiền:</span>
                <span class="total-final"><fmt:formatNumber value="${totalAmount}" type="number"
                                                            groupingUsed="true"/> đ</span>
            </div>
        </div>

        <!-- Thanh toán -->
        <div class="checkout-section">
            <a href="checkout.jsp">
                <button class="btn-checkout ${not empty cartItems ? 'active' : ''}">THANH TOÁN</button>
            </a>
            <!--            <div class="checkout-note">(Giảm giá trên web chỉ áp dụng cho bán lẻ)</div>-->
        </div>
    </div>
</main>

<!-- Thêm Message Box -->
<div class="message-box" id="messageBox">
    <span class="close-msg">&times;</span>
    <p id="messageText"></p>
</div>

<!-- ===================== FOOTER ===================== -->
<jsp:include page="/fontend/public/Footer.jsp"/>

<!-- JavaScript -->
<script>

    const contextPath = '${pageContext.request.contextPath}';
    // Get elements
    var modal = document.getElementById("modal");
    var viewMoreLink = document.querySelector(".promo-section .view-more");
    // var span = document.getElementsByClassName("closeBtn")[0];
    var viewMoreBtn = document.getElementById("viewMoreBtn");
    var messageBox = document.getElementById("messageBox");
    var messageText = document.getElementById("messageText");
    var closeMsg = document.querySelector(".close-msg");
    var selectAllLabel = document.querySelector(".select-all label[for='select-all']");
    var totalFinalElement = document.querySelector(".total-final");
    var totalPriceElement = document.querySelector(".total-price");
    var checkoutButton = document.querySelector(".btn-checkout");

    // TRAM
    // Hàm tính tiền dựa trên sản phẩm được tick
    function calculateTotal() {
        var cartItems = document.querySelectorAll(".cart-item");
        let total = 0;
        let count = 0;

        cartItems.forEach(item => {
            var checkbox = item.querySelector(".item-checkbox");
            if (checkbox && checkbox.checked) {
                var priceText = item.querySelector(".item-price").textContent.match(/[\d,.]+/)[0].replace(/\./g, '').replace(/,/g, '');
                var quantity = parseInt(item.querySelector(".quantity-input").value);
                var price = parseInt(priceText);
                total += price * quantity;
                count++;
            }
        });

        // Định dạng tiền tệ
        if (totalPriceElement) {
            totalPriceElement.textContent = `\${total.toLocaleString('vi-VN')} đ`;
        }
        if (totalFinalElement) {
            totalFinalElement.textContent = `\${total.toLocaleString('vi-VN')} đ`;
        }

        // Kích hoạt/vô hiệu hóa nút thanh toán
        if (checkoutButton) {
            if (count > 0) {
                checkoutButton.classList.add("active");
            } else {
                checkoutButton.classList.remove("active");
            }
        }
    }

    // Gọi hàm cập nhật khi trang tải
    window.onload = function () {
        restoreCheckboxStates();
        updateCartItemCount();
        calculateTotal();
    };

    // Cập nhật tiêu đề "Chọn tất cả (X sản phẩm)"
    function updateCartItemCount() {
        const itemCount = document.querySelectorAll(".cart-item").length;
        selectAllLabel.textContent = `Chọn tất cả (${itemCount} sản phẩm)`;
    }

    // Sự kiện "Chọn tất cả"
    document.getElementById("select-all").addEventListener("change", function () {
        const allCheckedboxes = document.querySelectorAll(".cart-item .item-checkbox");
        allCheckedboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
    });

    // Sự kiện thay đổi checkbox riêng lẻ
    document.querySelectorAll(".cart-item .item-checkbox").forEach(checkbox => {
        checkbox.addEventListener("change", function () {
            console.log("Checkbox changed, recalculating...");
            if (!this.checked) {
                document.getElementById("select-all").checked = false;
            } else if (document.querySelectorAll(".cart-item .item-checkbox:checked").length === document.querySelectorAll(".cart-item .item-checkbox").length) {
                document.getElementById("select-all").checked = true;
            }
            saveCheckboxStates();
            calculateTotal();
        });
    });

    // Sự kiện tăng giảm số lượng sách
    document.querySelectorAll(".quantity-control .quantity-btn").forEach(button => {
        button.addEventListener("click", function () {
            const quantityInput = this.parentElement.querySelector(".quantity-input");
            const comicId = this.closest(".cart-item").dataset.comicId;
            let currentValue = parseInt(quantityInput.value);

            if (this.classList.contains("plus")) {
                currentValue++;
            } else if (this.classList.contains("minus") && currentValue > 1) {
                currentValue--;
            }
            // Gọi servlet để cập nhật
            window.location.href = contextPath + `/cart?action=update&comicId=\${comicId}&quantity=\${currentValue}`;
        });
    });

    // Sự kiện cho nút xóa sản phẩm
    document.querySelectorAll(".delete-btn").forEach(button => {
        button.addEventListener("click", function () {
            const comicId = this.closest(".cart-item").dataset.comicId;
            if (confirm("Bạn có chắc muốn xóa sản phẩm này?")) {
                window.location.href = contextPath + `/cart?action=remove&comicId=${comicId}`;
            }
        });
    });

    // Open modal and disable scroll
    viewMoreLink.onclick = function (event) {
        event.preventDefault();
        modal.style.display = "block";
        document.body.classList.add("no-scroll");
        document.documentElement.classList.add("no-scroll");
    }

    // Close modal and enable scroll
    // span.onclick = function () {
    //     modal.style.display = "none";
    //     document.body.classList.remove("no-scroll");
    //     document.documentElement.classList.remove("no-scroll");
    // }

    // Close modal when clicking outside
    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = "none";
            document.body.classList.remove("no-scroll");
            document.documentElement.classList.remove("no-scroll");
        }
    }

    // Apply promo code from list with message box and auto-close
    var applyBtns = document.querySelectorAll(".promoItem .btnApply");
    applyBtns.forEach(button => {
        button.onclick = function () {
            var promo = this.parentElement.querySelector("input[type='radio']:checked");
            if (promo) {
                messageText.innerHTML = '<span style="font-size:24px; color:#4caf50;">✔️</span><br>Áp dụng mã <b>' + promo.value + '</b> thành công!';
                messageBox.style.display = "block";
                document.body.classList.add("no-scroll");
                document.documentElement.classList.add("no-scroll");
                setTimeout(() => {
                    messageBox.style.display = "none";
                    document.body.classList.remove("no-scroll");
                    document.documentElement.classList.remove("no-scroll");
                }, 3000);
            } else {
                messageText.innerHTML = '<span style="font-size:24px; color:#d32f2f;">❌</span><br>Vui lòng chọn một mã khuyến mãi!';
                messageBox.style.display = "block";
                document.body.classList.add("no-scroll");
                document.documentElement.classList.add("no-scroll");
            }
        }
    });

    // Apply manually entered promo code with message box and auto-close
    // document.getElementById("applyManualCode").onclick = function () {
    //     var promoCode = document.getElementById("promoCodeInput").value.trim();
    //     if (promoCode) {
    //         messageText.innerHTML = '<span style="font-size:24px; color:#4caf50;">✔️</span><br>Áp dụng mã <b>' + promoCode + '</b> thành công!';
    //         messageBox.style.display = "block";
    //         document.body.classList.add("no-scroll");
    //         document.documentElement.classList.add("no-scroll");
    //         setTimeout(() => {
    //             messageBox.style.display = "none";
    //             document.body.classList.remove("no-scroll");
    //             document.documentElement.classList.remove("no-scroll");
    //         }, 3000);
    //     } else {
    //         messageText.innerHTML = '<span style="font-size:24px; color:#d32f2f;">❌</span><br>Vui lòng nhập mã khuyến mãi!';
    //         messageBox.style.display = "block";
    //         document.body.classList.add("no-scroll");
    //         document.documentElement.classList.add("no-scroll");
    //     }
    // };

    // Close message box and enable scroll
    // closeMsg.onclick = function () {
    //     messageBox.style.display = "none";
    //     document.body.classList.remove("no-scroll");
    //     document.documentElement.classList.remove("no-scroll");
    // }

    // View more functionality
    // viewMoreBtn.onclick = function () {
    //     var hiddenItems = document.querySelectorAll(".promoItem.hidden");
    //     hiddenItems.forEach(item => {
    //         item.classList.remove("hidden");
    //     });
    //     if (document.querySelectorAll(".promoItem.hidden").length === 0) {
    //         viewMoreBtn.style.display = "none";
    //     }
    // }

    function saveCheckboxStates() {
        const states = {};
        document.querySelectorAll(".cart-item").forEach(item => {
            const comicId = item.dataset.comicId;
            const checkbox = item.querySelector(".item-checkbox");
            states[comicId] = checkbox.checked; // Lưu trạng thái
        });
        localStorage.setItem('cartCheckboxStates', JSON.stringify(states));
    }

    function restoreCheckboxStates() {
        const states = JSON.parse(localStorage.getItem('cartCheckboxStates'));
        if (!states) return;

        document.querySelectorAll(".cart-item").forEach(item => {
            const comicId = item.dataset.comicId;
            const checkbox = item.querySelector(".item-checkbox");

            if (states[comicId]) {
                checkbox.checked = true;
            }
        });
    }
</script>
</body>
</html>