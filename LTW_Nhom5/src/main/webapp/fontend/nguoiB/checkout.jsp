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
    <title>Document</title>

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
                        <input type="text" name="receiverName" value="${defaultRecipientName != null ? defaultRecipientName : ''}"
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
                        <div id="provinceLoading" class="loading-indicator">
                            <i class="fas fa-spinner fa-spin"></i> Đang tải danh sách tỉnh/thành phố...
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Phường/Xã: *</label>
                        <select name="ward" id="ward" required disabled>
                            <option value="">-- Chọn Phường/Xã --</option>
                        </select>
                        <div id="wardLoading" class="loading-indicator">
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

                    <!-- Hidden inputs để lưu code -->


                    <input type="hidden" name="provinceCode" id="provinceCodeInput">
                    <input type="hidden" name="wardCode" id="wardCodeInput">
                    <input type="hidden" name="provinceName" id="provinceName">
                    <input type="hidden" name="wardName" id="wardName">

                    <input type="hidden" id="defaultProvince" value="${defaultProvince != null ? defaultProvince : ''}">
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
                    <!-- <label><input type="radio" name="payment"> Chuyển khoản ngân hàng (QR Code)</label><br> -->
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
                            <fmt:formatNumber value="${item.comic.discountPrice * item.quantity}" type="number"
                                              groupingUsed="true"/>đ
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

<!--Popup mã QR-->
<div class="container-qr-popup" style="display: none;">
    <div class="momo-modal" id="momoModal" aria-hidden="true">
        <div class="momo-dialog" role="dialog" aria-modal="true" aria-labelledby="momoTitle">
            <button class="momo-close" id="momoClose" aria-label="Đóng popup">✕</button>

            <h2 class="momo-title" id="momoTitle">Quét QR MoMo để thanh toán</h2>

            <div class="momo-content">
                <!-- Ảnh QR: thay bằng QR của bạn -->
                <img src="https://tse3.mm.bing.net/th/id/OIP.IHv3sMp_4T18cEr7RTAdgQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3"
                     alt="Mã QR MoMo" class="momo-qr"/>

                <!-- Thông tin người nhận: thay bằng của bạn -->
                <div class="momo-info">
                    <p><strong>Người nhận:</strong> Comic Store</p>
                    <p><strong>SĐT MoMo:</strong> 0901234567</p>
                    <p><strong>Số tiền:</strong> <span id="qrAmount"></span></p>
                    <p><strong>Nội dung chuyển khoản:</strong>Thanh toán đơn hàng</p>
                </div>
                <button type="button" id="confirmPayment" class="btn-confirm-payment">Xác nhận đã thanh toán</button>
            </div>
        </div>
    </div>
</div>


<!-- BACKDROP LÀM MỜ -->
<div class="qr-backdrop"></div>

<!-- POPUP MÃ QR -->
<div class="qr-popup" id="qrPopup">
    <div class="qr-content">
        <button class="qr-close-btn">×</button>
        <h3>Quét mã QR để thanh toán</h3>
        <img src="https://vaynhanhonline.com.vn/wp-content/uploads/2024/01/cach-tao-ma-qr-ngan-hang-bidv-5-e1704968301891.jpg"
             alt="QR Code Thanh toán">
        <div class="qr-info">
            <p><strong>Ngân hàng:</strong> BIDV</p>
            <p><strong>Số tài khoản:</strong> 1234567890</p>
            <p><strong>Chủ tài khoản:</strong> NGUYEN VAN A</p>
            <p><strong>Nội dung chuyển khoản:</strong> <span id="orderCode">DH20251227001</span></p>
        </div>
        <button class="qr-copy-btn">Copy nội dung chuyển khoản</button>
    </div>
</div>

<!-- BACKDROP -->
<div class="voucher-backdrop" id="voucherBackdrop" style="display:none;"></div>

<!-- ===================== FOOTER ===================== -->
<jsp:include page="/fontend/public/Footer.jsp"/>

<!-- ===================== SCRIPT API TỈNH THÀNH ===================== -->
<script>
    // ================ SỬ DỤNG API - LOAD TỈNH/PHƯỜNG XÃ ================
    const API_BASE = "${pageContext.request.contextPath}/api/provinces";

    const provinceSelect = document.getElementById("province");
    const wardSelect = document.getElementById("ward");
    const provinceCodeInput = document.getElementById("provinceCodeInput");
    const wardCodeInput = document.getElementById("wardCodeInput");
    const provinceNameInput = document.getElementById("provinceName");
    const wardNameInput = document.getElementById("wardName");
    const provinceLoading = document.getElementById("provinceLoading");
    const wardLoading = document.getElementById("wardLoading");

    let provincesLoaded = false;

    console.log("🚀 Initializing checkout page...");
    console.log("📍 Context Path:", "${pageContext.request.contextPath}");
    console.log("📍 API Base URL:", API_BASE);

    // 1️⃣ Load danh sách Tỉnh/Thành phố khi trang load
    // ⚠️ QUAN TRỌNG: Phải gọi /p/ vì servlet pattern là /api/provinces/*
    const provincesUrl = API_BASE + "/p/";
    console.log("🔄 Loading provinces from:", provincesUrl);

    // Hiện loading indicator
    if (provinceLoading) provinceLoading.style.display = "block";

    fetch(provincesUrl)
        .then(res => {
            console.log("📥 Province response status:", res.status);
            console.log("📥 Province response URL:", res.url);

            if (!res.ok) {
                return res.text().then(text => {
                    console.error("❌ Error response:", text);
                    throw new Error("HTTP " + res.status + ": " + text);
                });
            }
            return res.json();
        })
        .then(provinces => {
            console.log("✅ Loaded provinces count:", provinces.length);
            console.log("📋 First 3 provinces:", provinces.slice(0, 3));

            // Xóa option cũ (trừ option mặc định)
            provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';

            provinces.forEach(p => {
                const opt = document.createElement("option");
                opt.value = p.name;
                opt.textContent = p.name;
                opt.dataset.code = p.code;
                provinceSelect.appendChild(opt);
            });

            provincesLoaded = true;
            provinceSelect.disabled = false;
            console.log("✅ Provinces loaded successfully");

            // Ẩn loading indicator
            if (provinceLoading) provinceLoading.style.display = "none";
        })
        .catch(err => {
            console.error("❌ Lỗi load tỉnh:", err);
            alert("Không thể tải danh sách tỉnh/thành phố. Vui lòng thử lại sau.\n\nLỗi: " + err.message);
            if (provinceLoading) {
                provinceLoading.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi tải dữ liệu';
                provinceLoading.style.color = "red";
            }
        });

    // 2️⃣ Khi chọn Tỉnh → load Phường/Xã
    provinceSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        const provinceName = selectedOption.value;

        console.log("🔍 Selected province:", provinceName, "Code:", code);

        // Lưu province code và name vào hidden input
        provinceCodeInput.value = code || '';
        provinceNameInput.value = provinceName || '';

        // Reset ward select
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;
        wardCodeInput.value = '';
        wardNameInput.value = '';

        if (!code) {
            console.log("⚠️ No province selected");
            return;
        }

        // Hiện loading indicator
        if (wardLoading) wardLoading.style.display = "block";

        const wardsUrl = API_BASE + "/p/" + code + "?depth=2";
        console.log("🔄 Loading wards from:", wardsUrl);

        fetch(wardsUrl)
            .then(res => {
                console.log("📥 Wards response status:", res.status);
                console.log("📥 Wards response URL:", res.url);

                if (!res.ok) {
                    return res.text().then(text => {
                        console.error("❌ Error response:", text);
                        throw new Error("HTTP " + res.status + ": " + text);
                    });
                }
                return res.json();
            })
            .then(data => {
                console.log("✅ Full wards response:", data);

                // Kiểm tra cấu trúc dữ liệu
                let wards = [];

                if (data.districts && Array.isArray(data.districts)) {
                    wards = data.districts;
                    console.log("📊 Found districts array with", wards.length, "items");
                } else if (data.wards && Array.isArray(data.wards)) {
                    wards = data.wards;
                    console.log("📊 Found wards array with", wards.length, "items");
                } else if (Array.isArray(data)) {
                    wards = data;
                    console.log("📊 Found array with", wards.length, "items");
                } else {
                    console.error("❌ Unexpected data structure:", data);
                }

                if (wards.length > 0) {
                    console.log("📋 First 3 wards:", wards.slice(0, 3));

                    // Xóa option cũ
                    wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

                    wards.forEach(w => {
                        const opt = document.createElement("option");
                        opt.value = w.name;
                        opt.textContent = w.name;
                        opt.dataset.code = w.code;
                        wardSelect.appendChild(opt);
                    });

                    wardSelect.disabled = false;
                    console.log("✅ Successfully loaded " + wards.length + " wards");

                    // Ẩn loading indicator
                    if (wardLoading) wardLoading.style.display = "none";
                } else {
                    console.warn("⚠️ No wards found in response");
                    wardSelect.innerHTML = '<option value="">-- Không có dữ liệu --</option>';
                    if (wardLoading) {
                        wardLoading.innerHTML = '<i class="fas fa-info-circle"></i> Không có dữ liệu phường/xã';
                        wardLoading.style.color = "orange";
                    }
                }
            })
            .catch(err => {
                console.error("❌ Lỗi load phường/xã:", err);
                alert("Không thể tải danh sách phường/xã. Vui lòng thử lại.\n\nLỗi: " + err.message);
                if (wardLoading) {
                    wardLoading.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi tải dữ liệu';
                    wardLoading.style.color = "red";
                }
            });
    });

    // 3️⃣ Cập nhật ward code và name khi chọn phường/xã
    wardSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        const wardName = selectedOption.value;

        console.log("🔍 Selected ward:", wardName, "Code:", code);

        wardCodeInput.value = code || '';
        wardNameInput.value = wardName || '';
    });

    // ========================================
    // XỬ LÝ SHIPPING FEE VÀ POINTS
    // ========================================
    const shippingRadios = document.querySelectorAll('input[name="shipping"]');
    const usePointsCheckbox = document.getElementById('usePoints');
    const checkoutBtn = document.getElementById('checkout-qr');
    const orderForm = document.getElementById('orderForm');

    // Lấy giá trị từ server
    const subtotal = ${checkoutSubtotal};
    const userPoints = ${user.points != null ? user.points : 0};

    // Elements hiển thị
    const shippingFeeSpan = document.getElementById('shippingFee');
    const pointsDiscountRow = document.getElementById('pointsDiscountRow');
    const pointsDiscountSpan = document.getElementById('pointsDiscount');
    const totalAmountSpan = document.getElementById('totalAmount');

    // Hàm format số
    function formatNumber(num) {
        return Math.round(num).toLocaleString('vi-VN');
    }

    // Hàm tính toán và cập nhật tổng tiền
    function updateTotal() {
        // Lấy phí ship hiện tại
        const selectedShipping = document.querySelector('input[name="shipping"]:checked');
        const shippingFee = selectedShipping ? parseInt(selectedShipping.dataset.fee) || 0 : 0;

        // Tính giảm giá từ xu
        let pointsDiscount = 0;
        if (usePointsCheckbox && usePointsCheckbox.checked) {
            pointsDiscount = userPoints * 1000; // 1 xu = 1000đ
        }

        // Tính tổng
        const total = subtotal + shippingFee - pointsDiscount;

        // Cập nhật UI
        if (shippingFeeSpan) {
            shippingFeeSpan.textContent = formatNumber(shippingFee) + 'đ';
        }

        if (usePointsCheckbox && usePointsCheckbox.checked) {
            if (pointsDiscountRow) pointsDiscountRow.style.display = 'flex';
            if (pointsDiscountSpan) pointsDiscountSpan.textContent = '-' + formatNumber(pointsDiscount) + 'đ';
        } else {
            if (pointsDiscountRow) pointsDiscountRow.style.display = 'none';
        }

        if (totalAmountSpan) {
            totalAmountSpan.textContent = formatNumber(total) + 'đ';
        }

        console.log("💰 Updated total:", {
            subtotal: subtotal,
            shippingFee: shippingFee,
            pointsDiscount: pointsDiscount,
            total: total
        });
    }

    // Lắng nghe thay đổi shipping
    shippingRadios.forEach(radio => {
        radio.addEventListener('change', updateTotal);
    });

    // Lắng nghe thay đổi points
    if (usePointsCheckbox) {
        usePointsCheckbox.addEventListener('change', updateTotal);
    }

    function validateCheckoutForm() {
        const recipientName = document.querySelector('input[name="receiverName"]');
        const receiverPhone = document.querySelector('input[name="receiverPhone"]');
        const province = document.getElementById('province');
        const ward = document.getElementById('ward');
        const address = document.querySelector('input[name="address"]');
        const shippingMethod = document.querySelector('input[name="shipping"]:checked');
        const paymentMethod = document.querySelector('input[name="payment"]:checked');

        // Kiểm tra họ tên
        if (!recipientName || !recipientName.value.trim()) {
            alert('Vui lòng nhập họ tên người nhận');
            recipientName.focus();
            return false;
        }

        // Kiểm tra số điện thoại
        if (!receiverPhone || !receiverPhone.value.trim()) {
            alert('Vui lòng nhập số điện thoại');
            receiverPhone.focus();
            return false;
        }

        // Validate số điện thoại (10-11 số)
        const phoneRegex = /^[0-9]{10,11}$/;
        if (!phoneRegex.test(receiverPhone.value.trim())) {
            alert('Số điện thoại không hợp lệ (phải có 10-11 chữ số)');
            receiverPhone.focus();
            return false;
        }

        // Kiểm tra tỉnh/thành phố
        if (!province || !province.value) {
            alert('Vui lòng chọn Tỉnh/Thành phố');
            province.focus();
            return false;
        }

        // Kiểm tra phường/xã
        if (!ward || !ward.value) {
            alert('Vui lòng chọn Phường/Xã');
            ward.focus();
            return false;
        }

        // Kiểm tra địa chỉ cụ thể
        if (!address || !address.value.trim()) {
            alert('Vui lòng nhập địa chỉ cụ thể (số nhà, tên đường)');
            address.focus();
            return false;
        }

        // Kiểm tra phương thức vận chuyển
        if (!shippingMethod) {
            alert('Vui lòng chọn phương thức vận chuyển');
            return false;
        }

        // Kiểm tra phương thức thanh toán
        if (!paymentMethod) {
            alert('Vui lòng chọn phương thức thanh toán');
            return false;
        }

        return true;
    }

    // Xử lý nút Đặt hàng
    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', function () {
            console.log("🛒 Checkout button clicked");

            // Validate form trước
            if (!validateCheckoutForm()) {
                console.log("❌ Form validation failed");
                return;
            }

            // Kiểm tra phương thức thanh toán
            const selectedPayment = document.querySelector('input[name="payment"]:checked');

            if (selectedPayment && selectedPayment.value === 'ewallet') {
                console.log("💳 E-wallet payment selected - showing QR modal");

                // Hiển thị popup QR
                const momoModal = document.getElementById('momoModal');
                const backdrop = document.querySelector('.qr-backdrop');
                const qrAmountSpan = document.getElementById('qrAmount');

                // Lấy tổng tiền
                const totalText = totalAmountSpan.textContent.replace(/[^\d]/g, '');
                if (qrAmountSpan) {
                    qrAmountSpan.textContent = formatNumber(totalText) + 'đ';
                }

                // Hiện popup
                if (momoModal) momoModal.style.display = 'block';
                if (backdrop) backdrop.style.display = 'block';

            } else {
                console.log("💵 COD payment selected - submitting form");
                // Hiển thị loading (tùy chọn)
                checkoutBtn.disabled = true;
                checkoutBtn.textContent = 'Đang xử lý...';

                // COD - submit form ngay
                orderForm.submit();
            }
        });
    }

    // Xử lý đóng popup MoMo
    const momoClose = document.getElementById('momoClose');
    const confirmPayment = document.getElementById('confirmPayment');

    if (momoClose) {
        momoClose.addEventListener('click', function () {
            console.log("❌ Closing MoMo modal");
            const momoModal = document.getElementById('momoModal');
            const backdrop = document.querySelector('.qr-backdrop');
            if (momoModal) momoModal.style.display = 'none';
            if (backdrop) backdrop.style.display = 'none';
        });
    }

    if (confirmPayment) {
        confirmPayment.addEventListener('click', function () {
            console.log("✅ Payment confirmed - submitting form");
            // Disable button để tránh double click
            confirmPayment.disabled = true;
            confirmPayment.textContent = 'Đang xử lý...';
            // Submit form sau khi xác nhận thanh toán
            orderForm.submit();
        });
    }

    // Khởi tạo tính toán ban đầu
    updateTotal();
    // Đóng popup khi click backdrop
    const backdrop = document.querySelector('.qr-backdrop');
    if (backdrop) {
        backdrop.addEventListener('click', function () {
            const momoModal = document.getElementById('momoModal');
            if (momoModal) momoModal.style.display = 'none';
            if (backdrop) backdrop.style.display = 'none';
        });
    }

    /**
     * Hiển thị thông báo lỗi nếu có
     */
    window.addEventListener('DOMContentLoaded', function () {
        const errorMsg = '${orderError}';
        if (errorMsg && errorMsg.trim() !== '' && errorMsg !== 'null') {
            alert(errorMsg);
            // Xóa error khỏi session
            <% session.removeAttribute("orderError"); %>
        }
    });

    console.log("✅ Checkout validation initialized");
    console.log("🚀 Checkout page initialized successfully");

</script>


<script>
    // ========================================
    // TỰ ĐỘNG LOAD ĐỊA CHỈ MẶC ĐỊNH
    // ========================================

    // Lấy địa chỉ mặc định từ hidden inputs
    const defaultProvince = document.getElementById('defaultProvince')?.value || '';
    const defaultWard = document.getElementById('defaultWard')?.value || '';

    console.log("📍 Default address:", { defaultProvince, defaultWard });

    // 1️⃣ Load danh sách Tỉnh/Thành phố khi trang load
    const provincesUrl = API_BASE + "/p/";
    console.log("🔄 Loading provinces from:", provincesUrl);

    // Hiện loading indicator
    if (provinceLoading) provinceLoading.style.display = "block";

    fetch(provincesUrl)
        .then(res => {
            console.log("📥 Province response status:", res.status);
            if (!res.ok) {
                return res.text().then(text => {
                    console.error("❌ Error response:", text);
                    throw new Error("HTTP " + res.status + ": " + text);
                });
            }
            return res.json();
        })
        .then(provinces => {
            console.log("✅ Loaded provinces count:", provinces.length);

            // Xóa option cũ (trừ option mặc định)
            provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';

            provinces.forEach(p => {
                const opt = document.createElement("option");
                opt.value = p.name;
                opt.textContent = p.name;
                opt.dataset.code = p.code;

                // Tự động chọn tỉnh mặc định
                if (defaultProvince && p.name === defaultProvince) {
                    opt.selected = true;
                    console.log("✅ Auto-selected default province:", p.name);
                }

                provinceSelect.appendChild(opt);
            });

            provincesLoaded = true;
            provinceSelect.disabled = false;
            console.log("✅ Provinces loaded successfully");

            // Ẩn loading indicator
            if (provinceLoading) provinceLoading.style.display = "none";

            // Nếu có địa chỉ mặc định, tự động load phường/xã
            if (defaultProvince && provinceSelect.value === defaultProvince) {
                const selectedOption = provinceSelect.options[provinceSelect.selectedIndex];
                const code = selectedOption.dataset.code;

                if (code) {
                    console.log("🔄 Auto-loading wards for default province...");
                    loadWardsForProvince(code, defaultWard);
                }
            }
        })
        .catch(err => {
            console.error("❌ Lỗi load tỉnh:", err);
            alert("Không thể tải danh sách tỉnh/thành phố. Vui lòng thử lại sau.\n\nLỗi: " + err.message);
            if (provinceLoading) {
                provinceLoading.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi tải dữ liệu';
                provinceLoading.style.color = "red";
            }
        });

    /**
     * Hàm load phường/xã cho một tỉnh
     * @param {string} provinceCode - Mã tỉnh
     * @param {string} autoSelectWard - Tên phường/xã cần tự động chọn (optional)
     */
    function loadWardsForProvince(provinceCode, autoSelectWard = '') {
        // Lưu province code vào hidden input
        provinceCodeInput.value = provinceCode;
        provinceNameInput.value = provinceSelect.value;

        // Reset ward select
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;
        wardCodeInput.value = '';
        wardNameInput.value = '';

        if (!provinceCode) {
            console.log("⚠️ No province code provided");
            return;
        }

        // Hiện loading indicator
        if (wardLoading) wardLoading.style.display = "block";

        const wardsUrl = API_BASE + "/p/" + provinceCode + "?depth=2";
        console.log("🔄 Loading wards from:", wardsUrl);

        fetch(wardsUrl)
            .then(res => {
                console.log("📥 Wards response status:", res.status);
                if (!res.ok) {
                    return res.text().then(text => {
                        console.error("❌ Error response:", text);
                        throw new Error("HTTP " + res.status + ": " + text);
                    });
                }
                return res.json();
            })
            .then(data => {
                console.log("✅ Full wards response:", data);

                // Kiểm tra cấu trúc dữ liệu
                let wards = [];
                if (data.districts && Array.isArray(data.districts)) {
                    wards = data.districts;
                } else if (data.wards && Array.isArray(data.wards)) {
                    wards = data.wards;
                } else if (Array.isArray(data)) {
                    wards = data;
                }

                if (wards.length > 0) {
                    console.log("📋 Loaded wards:", wards.length);

                    // Xóa option cũ
                    wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

                    wards.forEach(w => {
                        const opt = document.createElement("option");
                        opt.value = w.name;
                        opt.textContent = w.name;
                        opt.dataset.code = w.code;

                        // Tự động chọn phường/xã mặc định
                        if (autoSelectWard && w.name === autoSelectWard) {
                            opt.selected = true;
                            console.log("✅ Auto-selected default ward:", w.name);

                            // Cập nhật hidden inputs
                            wardCodeInput.value = w.code;
                            wardNameInput.value = w.name;
                        }

                        wardSelect.appendChild(opt);
                    });

                    wardSelect.disabled = false;
                    console.log("✅ Successfully loaded " + wards.length + " wards");

                    // Ẩn loading indicator
                    if (wardLoading) wardLoading.style.display = "none";
                } else {
                    console.warn("⚠️ No wards found in response");
                    wardSelect.innerHTML = '<option value="">-- Không có dữ liệu --</option>';
                    if (wardLoading) {
                        wardLoading.innerHTML = '<i class="fas fa-info-circle"></i> Không có dữ liệu phường/xã';
                        wardLoading.style.color = "orange";
                    }
                }
            })
            .catch(err => {
                console.error("❌ Lỗi load phường/xã:", err);
                alert("Không thể tải danh sách phường/xã. Vui lòng thử lại.\n\nLỗi: " + err.message);
                if (wardLoading) {
                    wardLoading.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi tải dữ liệu';
                    wardLoading.style.color = "red";
                }
            });
    }

    // 2️⃣ Khi chọn Tỉnh thủ công → load Phường/Xã
    provinceSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        const provinceName = selectedOption.value;

        console.log("🔍 Selected province:", provinceName, "Code:", code);

        if (code) {
            loadWardsForProvince(code);
        } else {
            // Reset nếu không chọn tỉnh
            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
            wardSelect.disabled = true;
            wardCodeInput.value = '';
            wardNameInput.value = '';
            provinceCodeInput.value = '';
            provinceNameInput.value = '';
        }
    });

    // 3️⃣ Cập nhật ward code và name khi chọn phường/xã
    wardSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        const wardName = selectedOption.value;

        console.log("🔍 Selected ward:", wardName, "Code:", code);

        wardCodeInput.value = code || '';
        wardNameInput.value = wardName || '';
    });

    console.log("✅ Default address script initialized");
</script>

</body>

</html>
