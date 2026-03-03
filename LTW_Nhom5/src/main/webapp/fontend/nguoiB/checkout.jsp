<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Thanh toán</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/UserBCss/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">

</head>

<body>

<jsp:include page="/fontend/public/header.jsp"/>

<!-- Main Content -->
<div class="titleCheckout">
    <h1>THANH TOÁN</h1>
</div>

<div class="mainContainer" style="display: flex">
    <div class="container">
        <main>
            <form id="orderForm" action="${pageContext.request.contextPath}/order" method="post">
                <section class="address">
                    <c:if test="${not empty defaultAddress}">
                        <div class="default-address-notice">
                            <i class="fas fa-check-circle"></i>
                            <span>Đang sử dụng địa chỉ mặc định của bạn. Bạn có thể thay đổi nếu cần.</span>
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label>Họ và tên người nhận: *</label>
                        <input type="text" name="receiverName"
                               value="${defaultRecipientName != null ? defaultRecipientName : ''}"
                               placeholder="Nhập họ tên" required>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại: *</label>
                        <input type="text" name="receiverPhone"
                               value="${defaultPhone != null ? defaultPhone : ''}"
                               placeholder="Nhập số điện thoại" required>
                    </div>

                    <div class="form-group">
                        <label>Tỉnh/Thành Phố: *</label>
                        <select name="province" id="province" required>
                            <option value="">-- Chọn Tỉnh/Thành phố --</option>
                        </select>
                        <div id="provinceLoading" class="loading-indicator" style="display: none;">
                            <i class="fas fa-spinner fa-spin"></i> Đang tải danh sách tỉnh/thành phố...
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Phường/Xã: *</label>
                        <select name="ward" id="ward" required disabled>
                            <option value="">-- Chọn Phường/Xã --</option>
                        </select>
                        <div id="wardLoading" class="loading-indicator" style="display: none;">
                            <i class="fas fa-spinner fa-spin"></i> Đang tải danh sách phường/xã...
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ nhận hàng: *</label>
                        <input type="text" name="address"
                               value="${defaultStreetAddress != null ? defaultStreetAddress : ''}"
                               placeholder="Nhập địa chỉ cụ thể (số nhà, tên đường)" required>
                    </div>

                    <div class="form-group" style="padding-left: 0;">
                        <label style="display: inline-flex; align-items: center; cursor: pointer; font-weight: normal;">
                            <input type="checkbox" name="setDefaultAddress" id="setDefaultAddress" value="true"
                            ${not empty defaultAddress ? 'checked' : ''}>
                            <span class="checkbox-label-text">Đặt địa chỉ này làm địa chỉ mặc định</span>
                        </label>
                    </div>

                    <!-- Hidden inputs để lưu địa chỉ mặc định -->
                    <input type="hidden" id="defaultProvince" value="${defaultProvince != null ? defaultProvince : ''}">
                    <input type="hidden" id="defaultDistrict" value="${defaultDistrict != null ? defaultDistrict : ''}">
                    <input type="hidden" id="defaultWard" value="${defaultWard != null ? defaultWard : ''}">
                </section>

                <section class="shipping">
                    <h2>Phương thức Vận chuyển: *</h2>
                    <label><input type="radio" name="shipping" value="standard" data-fee="25000" checked> Giao hàng Tiêu
                        Chuẩn - 25.000đ</label><br>
                    <label><input type="radio" name="shipping" value="express" data-fee="50000"> Giao hàng Hỏa Tốc -
                        50.000đ</label>
                </section>

                <section class="payment">
                    <h2>Phương thức Thanh toán: *</h2>
                    <label>
                        <input type="radio" name="payment" value="COD" checked> Thanh toán khi nhận hàng
                        (COD)</label><br>
                    <label><input type="radio" name="payment" value="ewallet"> Ví điện tử (MoMo,
                        ZaloPay,...)</label><br>
                </section>

                <section class="promotion">
                    <h2>Điểm thưởng:</h2>
                    <div class="usePoint">
                        <p>Sử dụng <strong>${user.points != null ? user.points : 0}</strong> xu (1 xu = 1.000đ)</p>
                        <input type="checkbox" name="usePoints" id="usePoints">
                    </div>
                </section>
            </form>
        </main>
    </div>

    <div class="totalCost">
        <section class="order-summary">
            <h2>Tổng đơn đặt hàng</h2>
            <div class="items">
                <c:forEach var="item" items="${selectedItems}">
                    <div class="itemSummary">
                        <div class="item">
                            <img src="${item.comic.thumbnailUrl}" alt="${item.comic.nameComics}">
                            <div class="item-details">
                                <p>${item.comic.nameComics}</p>
                                <span class="item-quantity">x${item.quantity}</span>
                            </div>
                        </div>
                        <span class="item-price">
                            <c:choose>
                                <c:when test="${item.flashSalePrice != null}">
                                    <fmt:formatNumber value="${item.flashSalePrice * item.quantity}"
                                                      type="number" groupingUsed="true"/>đ
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${item.comic.discountPrice * item.quantity}"
                                                      type="number" groupingUsed="true"/>đ
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </c:forEach>
            </div>

            <div class="summary-row">
                <p>Tạm tính:</p>
                <span id="subtotal">
                    <fmt:formatNumber value="${checkoutSubtotal}" type="number" groupingUsed="true"/>đ
                </span>
            </div>

            <div class="summary-row">
                <p>Phí vận chuyển:</p>
                <span id="shippingFee">
                    <fmt:formatNumber value="${shippingFee}" type="number" groupingUsed="true"/>đ
                </span>
            </div>

            <div class="summary-row" id="pointsDiscountRow" style="display: none;">
                <p>Giảm giá từ xu:</p>
                <span id="pointsDiscount">0đ</span>
            </div>

            <div class="summary-row total-row">
                <p><strong>TỔNG THANH TOÁN:</strong></p>
                <span id="totalAmount">
                    <fmt:formatNumber value="${checkoutTotal}" type="number" groupingUsed="true"/>đ
                </span>
            </div>
            <button type="button" id="checkout-qr">ĐẶT HÀNG</button>
        </section>
    </div>
</div>

<!----Popup mã QR-->
<div class="container-qr-popup" style="display: none;">
    <div class="qr-backdrop"></div>
    <div class="momo-modal" id="momoModal" aria-hidden="true">
        <div class="momo-dialog" role="dialog" aria-modal="true" aria-labelledby="momoTitle">
            <button class="momo-close" id="momoClose" aria-label="Đóng popup">✕</button>
            <h2 class="momo-title" id="momoTitle">Quét QR MoMo để thanh toán</h2>
            <div class="momo-content">
                <img src="${pageContext.request.contextPath}/img/qr.jpg" alt="Mã QR MoMo" class="momo-qr"/>
                <div class="momo-info">
                    <p><strong>Người nhận:</strong> Comic Store</p>
                    <p><strong>SĐT MoMo:</strong> 0901234567</p>
                    <p><strong>Số tiền:</strong> <span id="qrAmount"></span></p>
                    <p><strong>Nội dung chuyển khoản:</strong> Thanh toán đơn hàng</p>
                </div>
                <button type="button" id="confirmPayment" class="btn-confirm-payment">
                    Xác nhận đã thanh toán
                </button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fontend/public/Footer.jsp"/>

<script>
    // ==================== CẤU HÌNH ====================
    const API_BASE = "${pageContext.request.contextPath}/api/provinces";
    const provinceSelect = document.getElementById("province");
    const wardSelect = document.getElementById("ward");
    const provinceLoading = document.getElementById("provinceLoading");
    const wardLoading = document.getElementById("wardLoading");

    // Lấy địa chỉ mặc định
    const defaultProvince = document.getElementById('defaultProvince')?.value || '';
    const defaultWard = document.getElementById('defaultWard')?.value || '';

    console.log("🚀 Checkout initialized");
    console.log("📍 API Base:", API_BASE);
    console.log("📍 Default address:", {defaultProvince, defaultWard});

    // ==================== LOAD TỈNH/THÀNH PHỐ ====================
    function loadProvinces() {
        if (provinceLoading) provinceLoading.style.display = "block";

        const provincesUrl = API_BASE + "/p/";
        console.log("🔄 Loading provinces from:", provincesUrl);

        fetch(provincesUrl)
            .then(res => {
                console.log("📥 Response status:", res.status);
                if (!res.ok) throw new Error("HTTP " + res.status);
                return res.json();
            })
            .then(provinces => {
                console.log("✅ Loaded", provinces.length, "provinces");

                provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';

                let selectedProvinceCode = null;

                provinces.forEach(p => {
                    const opt = document.createElement("option");
                    opt.value = p.name;
                    opt.textContent = p.name;
                    opt.dataset.code = p.code;

                    // Tự động chọn tỉnh mặc định
                    if (defaultProvince && p.name === defaultProvince) {
                        opt.selected = true;
                        selectedProvinceCode = p.code;
                        console.log("✅ Auto-selected province:", p.name);
                    }

                    provinceSelect.appendChild(opt);
                });

                provinceSelect.disabled = false;
                if (provinceLoading) provinceLoading.style.display = "none";

                // Nếu có tỉnh mặc định, load phường/xã
                if (selectedProvinceCode) {
                    loadWards(selectedProvinceCode, defaultWard);
                }
            })
            .catch(err => {
                console.error("❌ Error loading provinces:", err);
                alert("Không thể tải danh sách tỉnh/thành phố: " + err.message);
                if (provinceLoading) {
                    provinceLoading.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi tải dữ liệu';
                    provinceLoading.style.color = "red";
                }
            });
    }

    // ==================== LOAD PHƯỜNG/XÃ ====================
    function loadWards(provinceCode, autoSelectWard = '') {
        wardSelect.innerHTML = '<option value="">-- Đang tải... --</option>';
        wardSelect.disabled = true;
        if (wardLoading) wardLoading.style.display = "block";

        const wardsUrl = API_BASE + "/p/" + provinceCode + "?depth=2";
        console.log("🔄 Loading wards from:", wardsUrl);

        fetch(wardsUrl)
            .then(res => {
                console.log("📥 Response status:", res.status);
                if (!res.ok) throw new Error("HTTP " + res.status);
                return res.json();
            })
            .then(data => {
                console.log("✅ Wards data received");

                let wards = [];
                if (data.districts && Array.isArray(data.districts)) {
                    wards = data.districts;
                } else if (data.wards && Array.isArray(data.wards)) {
                    wards = data.wards;
                } else if (Array.isArray(data)) {
                    wards = data;
                }

                console.log("📊 Found", wards.length, "wards");

                wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

                wards.forEach(w => {
                    const opt = document.createElement("option");
                    opt.value = w.name;
                    opt.textContent = w.name;
                    opt.dataset.code = w.code;

                    // Tự động chọn phường/xã mặc định
                    if (autoSelectWard && w.name === autoSelectWard) {
                        opt.selected = true;
                        console.log("✅ Auto-selected ward:", w.name);
                    }

                    wardSelect.appendChild(opt);
                });

                wardSelect.disabled = false;
                if (wardLoading) wardLoading.style.display = "none";
            })
            .catch(err => {
                console.error("❌ Error loading wards:", err);
                alert("Không thể tải danh sách phường/xã: " + err.message);
                wardSelect.innerHTML = '<option value="">-- Lỗi tải dữ liệu --</option>';
                if (wardLoading) {
                    wardLoading.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi tải dữ liệu';
                    wardLoading.style.color = "red";
                }
            });
    }

    // ==================== EVENT LISTENERS ====================
    provinceSelect.addEventListener("change", function() {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;

        console.log("🔍 Province changed:", selectedOption.value);

        if (code) {
            loadWards(code);
        } else {
            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
            wardSelect.disabled = true;
        }
    });

    // ==================== SHIPPING & POINTS ====================
    const shippingRadios = document.querySelectorAll('input[name="shipping"]');
    const usePointsCheckbox = document.getElementById('usePoints');
    const subtotal = ${checkoutSubtotal};
    const userPoints = ${user.points != null ? user.points : 0};
    const shippingFeeSpan = document.getElementById('shippingFee');
    const pointsDiscountRow = document.getElementById('pointsDiscountRow');
    const pointsDiscountSpan = document.getElementById('pointsDiscount');
    const totalAmountSpan = document.getElementById('totalAmount');

    function formatNumber(num) {
        return Math.round(num).toLocaleString('vi-VN');
    }

    function updateTotal() {
        const selectedShipping = document.querySelector('input[name="shipping"]:checked');
        const shippingFee = selectedShipping ? parseInt(selectedShipping.dataset.fee) || 0 : 0;

        let pointsDiscount = 0;
        if (usePointsCheckbox && usePointsCheckbox.checked) {
            // pointsDiscount = userPoints * 1000;
            pointsDiscount = userPoints;
        }

        const total = subtotal + shippingFee - pointsDiscount;

        if (shippingFeeSpan) shippingFeeSpan.textContent = formatNumber(shippingFee) + 'đ';

        if (usePointsCheckbox && usePointsCheckbox.checked) {
            if (pointsDiscountRow) pointsDiscountRow.style.display = 'flex';
            if (pointsDiscountSpan) pointsDiscountSpan.textContent = '-' + formatNumber(pointsDiscount) + 'đ';
        } else {
            if (pointsDiscountRow) pointsDiscountRow.style.display = 'none';
        }

        if (totalAmountSpan) totalAmountSpan.textContent = formatNumber(total) + 'đ';
    }

    shippingRadios.forEach(radio => radio.addEventListener('change', updateTotal));
    if (usePointsCheckbox) usePointsCheckbox.addEventListener('change', updateTotal);

    // ==================== CHECKOUT ====================
    const checkoutBtn = document.getElementById('checkout-qr');
    const orderForm = document.getElementById('orderForm');

    function validateCheckoutForm() {
        const recipientName = document.querySelector('input[name="receiverName"]');
        const receiverPhone = document.querySelector('input[name="receiverPhone"]');
        const address = document.querySelector('input[name="address"]');

        if (!recipientName?.value.trim()) {
            alert('Vui lòng nhập họ tên người nhận');
            recipientName.focus();
            return false;
        }

        if (!receiverPhone?.value.trim()) {
            alert('Vui lòng nhập số điện thoại');
            receiverPhone.focus();
            return false;
        }

        const phoneRegex = /^[0-9]{10,11}$/;
        if (!phoneRegex.test(receiverPhone.value.trim())) {
            alert('Số điện thoại không hợp lệ (10-11 chữ số)');
            receiverPhone.focus();
            return false;
        }

        if (!provinceSelect.value) {
            alert('Vui lòng chọn Tỉnh/Thành phố');
            provinceSelect.focus();
            return false;
        }

        if (!wardSelect.value) {
            alert('Vui lòng chọn Phường/Xã');
            wardSelect.focus();
            return false;
        }

        if (!address?.value.trim()) {
            alert('Vui lòng nhập địa chỉ cụ thể');
            address.focus();
            return false;
        }

        return true;
    }

    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', function() {
            if (!validateCheckoutForm()) return;

            const selectedPayment = document.querySelector('input[name="payment"]:checked');

            if (selectedPayment?.value === 'ewallet') {
                const containerQrPopup = document.querySelector('.container-qr-popup');
                const qrAmountSpan = document.getElementById('qrAmount');

                const totalText = totalAmountSpan.textContent.replace(/[^\d]/g, '');
                if (qrAmountSpan) qrAmountSpan.textContent = formatNumber(totalText) + 'đ';

                if (containerQrPopup) containerQrPopup.style.display = 'flex';
            } else {
                checkoutBtn.disabled = true;
                checkoutBtn.textContent = 'Đang xử lý...';
                orderForm.submit();
            }
        });
    }

    // ==================== POPUP ====================
    const momoClose = document.getElementById('momoClose');
    const containerQrPopup = document.querySelector('.container-qr-popup');
    const confirmPaymentBtn = document.getElementById('confirmPayment');

    if (momoClose) {
        momoClose.addEventListener('click', () => {
            if (containerQrPopup) containerQrPopup.style.display = 'none';
        });
    }

    if (containerQrPopup) {
        containerQrPopup.addEventListener('click', function(e) {
            if (e.target === this || e.target.classList.contains('qr-backdrop')) {
                this.style.display = 'none';
            }
        });
    }

    if (confirmPaymentBtn) {
        confirmPaymentBtn.addEventListener('click', function() {
            this.disabled = true;
            this.textContent = 'Đang xử lý...';
            orderForm.submit();
        });
    }

    // ==================== MESSAGES ====================
    window.addEventListener('DOMContentLoaded', function() {
        const errorMsg = '${orderError}';
        if (errorMsg && errorMsg.trim() !== '' && errorMsg !== 'null') {
            alert(errorMsg);
            <% session.removeAttribute("orderError"); %>
        }

        const successMsg = '${orderSuccess}';
        if (successMsg && successMsg.trim() !== '' && successMsg !== 'null') {
            showSuccessPopup(successMsg);
            <% session.removeAttribute("orderSuccess"); %>
        }
    });

    function showSuccessPopup(message) {
        const backdrop = document.createElement('div');
        backdrop.style.cssText = `
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.6); z-index: 10000;
            display: flex; align-items: center; justify-content: center;
        `;

        backdrop.innerHTML = `
            <div style="background: white; border-radius: 12px; padding: 30px; max-width: 400px; width: 90%; text-align: center; box-shadow: 0 10px 40px rgba(0,0,0,0.3);">
                <div style="color: #28a745; font-size: 48px; margin-bottom: 15px;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h2 style="color: #333; font-size: 22px; margin-bottom: 10px;">Đặt hàng thành công!</h2>
                <p style="color: #666; font-size: 15px; margin-bottom: 20px;">${message}</p>
                <button onclick="this.closest('div').parentElement.remove()"
                    style="background: #28a745; color: white; border: none; padding: 12px 30px; border-radius: 6px; font-size: 16px; cursor: pointer; font-weight: 600;">
                    OK
                </button>
            </div>
        `;

        document.body.appendChild(backdrop);
        setTimeout(() => backdrop.remove(), 5000);
    }

    loadProvinces();
    updateTotal();
</script>

</body>
</html>
