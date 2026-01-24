<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin tài khoản</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/UserBCss/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<jsp:include page="/fontend/public/header.jsp"/>

<main>
    <%
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
    <script>
        window.onload = function() {
            alert("<%= message %>");
        };
    </script>
    <%
        }
    %>

    <jsp:include page="/fontend/nguoiB/ASideUser.jsp"/>

    <div class="profile-form-container">
        <h2>Hồ sơ cá nhân</h2>
        <form action="${pageContext.request.contextPath}/updateUser" method="post">
            <div class="form-group">
                <label for="ho">Họ: *</label>
                <input type="text" id="ho" name="ho" value="" placeholder="Nhập họ" required>
            </div>
            <div class="form-group">
                <label for="ten">Tên: *</label>
                <input type="text" id="ten" name="ten" value="" placeholder="Nhập tên" required>
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại:</label>
                <input type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại"
                       required pattern="[0-9]{10}" maxlength="10" title="nhập lại sdt"/>
            </div>
            <div class="form-group">
                <label for="email">Email: </label>
                <input type="email" id="email" name="email" value="" placeholder="Nhập email" required>
            </div>
            <div class="form-group">
                <div class="genders">
                    <label>Giới tính: *</label>
                    <div class="gender-options">
                        <label><input type="radio" name="gender" value="male" checked> Nam</label>
                        <label><input type="radio" name="gender" value="female"> Nữ</label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="birthday">
                    <label for="day">Ngày tháng năm sinh: *</label>
                    <input type="number" id="day" name="day" value="27" min="1" max="31" required> /
                    <input type="number" id="month" name="month" value="10" min="1" max="12" required> /
                    <input type="number" id="year" name="year" value="2005" min="1900" max="2025" required>
                </div>
            </div>
            <div class="form-group">
                <div class="address">
<%--                    <label for="country">Quốc gia: *</label>--%>
<%--                    <select id="country" name="country" required>--%>
<%--&lt;%&ndash;                        <option value="" disabled selected>Chọn quốc gia</option>&ndash;%&gt;--%>
<%--                        <option value="Vietnam">Việt Nam</option>--%>
<%--                    </select>--%>
                    <div class="diaChi">
                        <div class="address-group">
                            <label for="province">Tỉnh/Thành phố: *</label>
                            <select id="province" name="province" required>
                                <option value="">Chọn tỉnh/thành phố</option>
                            </select>
                        </div>
                        <div class="address-group">
                            <label for="district">Phường/Xã: *</label>
                            <select id="district" name="district" required disabled>
                                <option value="">Chọn phường/Xã</option>
                            </select>
                        </div>
                    </div>

                    <label for="house-number">Số nhà: *</label>
                    <input type="text" id="house-number" name="house-number" placeholder="Nhập số nhà, xã" required>
                </div>
            </div>
            <button type="submit" class="save-btn">Lưu thay đổi</button>
        </form>
    </div>
</main>

<jsp:include page="/fontend/public/Footer.jsp"/>


<script>
    document.addEventListener("DOMContentLoaded", function () {

        const API_BASE = "${pageContext.request.contextPath}/api/provinces";

        const provinceSelect = document.getElementById("province");
        const districtSelect = document.getElementById("district");

        console.log("📍 Profile address API:", API_BASE);

        //  LOAD TỈNH / THÀNH PHỐ
        fetch(API_BASE + "/p/")
            .then(res => {
                if (!res.ok) throw new Error("Không load được tỉnh");
                return res.json();
            })
            .then(provinces => {
                provinceSelect.innerHTML = '<option value="">Chọn tỉnh/thành phố</option>';

                provinces.forEach(p => {
                    const opt = document.createElement("option");
                    opt.value = p.code;          // gửi code về server
                    opt.textContent = p.name;    // hiển thị tên
                    opt.dataset.name = p.name;
                    provinceSelect.appendChild(opt);
                });

                provinceSelect.disabled = false;
                console.log(" Provinces loaded:", provinces.length);
            })
            .catch(err => {
                console.error(" Lỗi load tỉnh:", err);
                alert("Không thể tải danh sách tỉnh/thành phố");
            });

        // KHI CHỌN TỈNH → LOAD HUYỆN
        provinceSelect.addEventListener("change", function () {
            const provinceCode = this.value;

            districtSelect.innerHTML = '<option>Đang tải...</option>';
            districtSelect.disabled = true;

            if (!provinceCode) {
                districtSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                return;
            }

            fetch(API_BASE + "/p/" + provinceCode + "?depth=2")
                .then(res => {
                    if (!res.ok) throw new Error("Không load được huyện");
                    return res.json();
                })
                .then(data => {
                    districtSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';

                    let districts = [];

                    if (data.districts && Array.isArray(data.districts)) {
                        districts = data.districts;
                    } else if (data.wards && Array.isArray(data.wards)) {
                        districts = data.wards;
                    } else if (Array.isArray(data)) {
                        districts = data;
                    }

                    districts.forEach(d => {
                        const opt = document.createElement("option");
                        opt.value = d.code;        // gửi code
                        opt.textContent = d.name;  // hiển thị tên
                        opt.dataset.name = d.name;
                        districtSelect.appendChild(opt);
                    });

                    districtSelect.disabled = false;
                    console.log(" Districts loaded:", districts.length);
                })
                .catch(err => {
                    console.error(" Lỗi load huyện:", err);
                    alert("Không thể tải danh sách huyện");
                });
        });

    });
</script>

</body>
</html>