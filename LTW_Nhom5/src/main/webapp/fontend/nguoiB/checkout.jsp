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
                    <div class="form-group">
                        <label>Họ và tên người nhận: *</label>
                        <input type="text" name="receiverName" value="" placeholder="Nhập họ tên" required>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại: *</label>
                        <input type="text" name="receiverPhone" value="" placeholder="Nhập số điện thoại" required>
                    </div>

                    <div class="form-group">
                        <label>Tỉnh/Thành Phố: *</label>
                        <select name="province" id="province" required>
                            <option value="">-- Chọn Tỉnh/Thành phố --</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Quận/Huyện: *</label>
                        <select name="district" id="district" required disabled>
                            <option value="">-- Chọn Quận/Huyện --</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Phường/Xã:</label>
                        <select name="ward" id="ward" required disabled>
                            <option value="">-- Chọn Phường/Xã --</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ nhận hàng: *</label>
                        <input type="text" name="address" value="" placeholder="Nhập địa chỉ cụ thể" required>
                    </div>
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


<script>
    const contextPath = '${pageContext.request.contextPath}';

    // Giá trị từ server
    let subtotal = <c:out value="${checkoutSubtotal}" default="0"/>;
    let shippingFee = <c:out value="${shippingFee}" default="25000"/>;
    let userPoints = <c:out value="${currentUser.points}" default="0"/>;
    let pointsDiscount = 0;

    // Elements
    const shippingRadios = document.querySelectorAll('input[name="shipping"]');
    const usePointsCheckbox = document.getElementById('usePoints');
    const shippingFeeElement = document.getElementById('shippingFee');
    const pointsDiscountElement = document.getElementById('pointsDiscount');
    const pointsDiscountRow = document.getElementById('pointsDiscountRow');
    const totalAmountElement = document.getElementById('totalAmount');
    const checkoutBtn = document.getElementById('checkout-btn');
    const orderForm = document.getElementById('orderForm');
    const provinceSelect = document.getElementById('province');
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');

    // Popup elements
    const momoPopup = document.querySelector('.container-qr-popup');
    const momoClose = document.getElementById('momoClose');
    const confirmPaymentBtn = document.getElementById('confirmPayment');
    const qrAmountElement = document.getElementById('qrAmount');

    // Tính tổng tiền
    function calculateTotal() {
        let total = subtotal + shippingFee - pointsDiscount;
        if (total < 0) total = 0;
        totalAmountElement.textContent = total.toLocaleString('vi-VN') + 'đ';

        // Cập nhật số tiền trên QR
        if (qrAmountElement) {
            qrAmountElement.textContent = total.toLocaleString('vi-VN') + 'đ';
        }

        return total;
    }

    // Xử lý thay đổi phương thức vận chuyển
    shippingRadios.forEach(radio => {
        radio.addEventListener('change', function () {
            shippingFee = parseInt(this.dataset.fee);
            shippingFeeElement.textContent = shippingFee.toLocaleString('vi-VN') + 'đ';
            calculateTotal();
        });
    });

    // Xử lý sử dụng xu
    if (usePointsCheckbox) {
        usePointsCheckbox.addEventListener('change', function () {
            if (this.checked) {
                pointsDiscount = userPoints * 1000; // 1 xu = 1.000đ
                pointsDiscountRow.style.display = 'flex';
                pointsDiscountElement.textContent = '-' + pointsDiscount.toLocaleString('vi-VN') + 'đ';
            } else {
                pointsDiscount = 0;
                pointsDiscountRow.style.display = 'none';
                pointsDiscountElement.textContent = '0đ';
            }
            calculateTotal();
        });
    }

    // Xử lý nút đặt hàng
    const checkoutQrBtn = document.getElementById('checkout-qr');
    if (checkoutQrBtn) {
        checkoutQrBtn.addEventListener('click', function () {
            const paymentMethod = document.querySelector('input[name="payment"]:checked').value;

            // Validate form
            if (!orderForm.checkValidity()) {
                orderForm.reportValidity();
                return;
            }

            addLocationNamesToForm();

            // Nếu chọn ví điện tử, hiện popup QR
            if (paymentMethod === 'ewallet') {
                momoPopup.style.display = 'block';
            } else {
                // COD - submit form trực tiếp
                orderForm.submit();
            }
        });
    }
    // Đóng popup QR
    if (momoClose) {
        momoClose.addEventListener('click', function () {
            momoPopup.style.display = 'none';
        });
    }

    // Click outside popup
    if (momoPopup) {
        momoPopup.addEventListener('click', function (e) {
            if (e.target === momoPopup || e.target.classList.contains('momo-modal')) {
                momoPopup.style.display = 'none';
            }
        });
    }

    // Xác nhận đã thanh toán
    if (confirmPaymentBtn) {
        confirmPaymentBtn.addEventListener('click', function () {
            addLocationNamesToForm();
            // Đóng popup
            momoPopup.style.display = 'none';

            // Submit form
            orderForm.submit();
        });
    }

    // Tính tổng ban đầu
    calculateTotal();

    function addLocationNamesToForm() {
        const selectedProvince = provinceSelect.options[provinceSelect.selectedIndex];
        if (selectedProvince?.dataset.name) {
            let input = document.querySelector('input[name="provinceName"]');
            if (!input) {
                input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'provinceName';
                orderForm.appendChild(input);
            }
            input.value = selectedProvince.dataset.name;
        }

        const selectedDistrict = districtSelect.options[districtSelect.selectedIndex];
        if (selectedDistrict?.dataset.name) {
            let input = document.querySelector('input[name="districtName"]');
            if (!input) {
                input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'districtName';
                orderForm.appendChild(input);
            }
            input.value = selectedDistrict.dataset.name;
        }

        const selectedWard = wardSelect.options[wardSelect.selectedIndex];
        if (selectedWard?.dataset.name) {
            let input = document.querySelector('input[name="wardName"]');
            if (!input) {
                input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'wardName';
                orderForm.appendChild(input);
            }
            input.value = selectedWard.dataset.name;
        }
    }

    // ==================== API ĐỊA CHỈ VIỆT NAM ====================
    // ==================== LOAD TỈNH ====================
    // ==================== LOAD TỈNH (ALTERNATIVE API) ====================
    async function loadProvinces() {
        try {
            console.log('🔄 Loading provinces...');
            const res = await fetch('https://vapi.vnappmob.com/api/province/');

            if (!res.ok) {
                throw new Error(`HTTP error! status: ${res.status}`);
            }

            const data = await res.json();
            const provinces = data.results || [];
            console.log('✅ Provinces loaded:', provinces.length);

            provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';

            provinces.forEach(p => {
                const opt = document.createElement('option');
                opt.value = p.province_id;
                opt.textContent = p.province_name;
                opt.dataset.name = p.province_name;
                provinceSelect.appendChild(opt);
            });

        } catch (e) {
            console.error('❌ Load provinces error:', e);
            alert('Không thể tải danh sách tỉnh/thành phố. Vui lòng thử lại!');
        }
    }

    // ==================== LOAD HUYỆN ====================
    async function loadDistricts(provinceCode) {
        try {
            console.log('🔄 Loading districts for province code:', provinceCode);

            districtSelect.disabled = true;
            wardSelect.disabled = true;
            districtSelect.innerHTML = '<option value="">Đang tải...</option>';

            // ✅ SỬA LẠI URL - dùng endpoint mới
            const url = `https://provinces.open-api.vn/api/p/${provinceCode}?depth=2`;
            console.log('📡 Fetching URL:', url);

            const res = await fetch(url);

            if (!res.ok) {
                throw new Error(`HTTP error! status: ${res.status}`);
            }

            const data = await res.json();
            console.log('📦 Full API Response:', data);

            // ✅ KIỂM TRA CẤU TRÚC DATA
            const districts = data.districts || [];
            console.log('🔍 Found districts:', districts.length);
            console.log('🔍 Districts array:', districts);

            districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';

            if (districts.length === 0) {
                console.warn('⚠️ No districts returned from API');
                districtSelect.innerHTML = '<option value="">Không có dữ liệu quận/huyện</option>';
                districtSelect.disabled = false;
                return;
            }

            districts.forEach(d => {
                const opt = document.createElement('option');
                opt.value = d.code;
                opt.textContent = d.name;
                opt.dataset.name = d.name;
                districtSelect.appendChild(opt);
                console.log('➕ Added district:', d.name, '| Code:', d.code);
            });

            districtSelect.disabled = false;
            console.log('✅ Districts loaded successfully:', districts.length, 'items');

        } catch (e) {
            console.error('❌ Load districts error:', e);
            districtSelect.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
            alert('Không thể tải danh sách quận/huyện. Vui lòng thử lại!');
        }
    }

    // ==================== LOAD PHƯỜNG ====================
    // ==================== LOAD PHƯỜNG (ALTERNATIVE API) ====================
    async function loadWards(districtCode) {
        try {
            console.log('🔄 Loading wards for district code:', districtCode);

            wardSelect.disabled = true;
            wardSelect.innerHTML = '<option value="">Đang tải...</option>';

            const url = `https://vapi.vnappmob.com/api/province/ward/${districtCode}`;
            console.log('📡 Fetching URL:', url);

            const res = await fetch(url);

            if (!res.ok) {
                throw new Error(`HTTP error! status: ${res.status}`);
            }

            const data = await res.json();
            const wards = data.results || [];
            console.log('✅ Found wards:', wards.length);

            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

            if (wards.length === 0) {
                wardSelect.innerHTML = '<option value="">Không có dữ liệu</option>';
                wardSelect.disabled = false;
                return;
            }

            wards.forEach(w => {
                const opt = document.createElement('option');
                opt.value = w.ward_id;
                opt.textContent = w.ward_name;
                opt.dataset.name = w.ward_name;
                wardSelect.appendChild(opt);
            });

            wardSelect.disabled = false;
            console.log('✅ Ward select enabled with', wards.length, 'options');

        } catch (e) {
            console.error('❌ Load wards error:', e);
            wardSelect.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
            alert('Không thể tải danh sách phường/xã!');
        }
    }

    // ==================== EVENT LISTENERS ====================
    provinceSelect.addEventListener('change', function () {
        const selectedValue = this.value;
        const selectedText = this.options[this.selectedIndex].text;
        console.log('🏙️ Province changed:', selectedText, '| Code:', selectedValue);

        // Reset district và ward
        districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        districtSelect.disabled = true;
        wardSelect.disabled = true;

        if (selectedValue) {
            loadDistricts(selectedValue);
        }
    });

    districtSelect.addEventListener('change', function () {
        const selectedValue = this.value;
        const selectedText = this.options[this.selectedIndex].text;
        console.log('🏘️ District changed:', selectedText, '| Code:', selectedValue);

        // Reset ward
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;

        if (selectedValue) {
            loadWards(selectedValue);
        }
    });

    wardSelect.addEventListener('change', function () {
        const selectedValue = this.value;
        const selectedText = this.options[this.selectedIndex].text;
        console.log('🏠 Ward changed:', selectedText, '| Code:', selectedValue);
    });

    // ==================== INIT ====================
    window.addEventListener('DOMContentLoaded', function () {
        console.log('🚀 Page loaded, initializing address selects...');
        loadProvinces();
    });
</script>

</body>

</html>