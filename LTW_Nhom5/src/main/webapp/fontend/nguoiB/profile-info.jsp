<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="vn.edu.hcmuaf.fit.ltw_nhom5.model.User" %>

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

        // Lấy thông tin user từ session
        User currentUser = (User) session.getAttribute("currentUser");

        // Parse thông tin từ user
        String fullName = currentUser != null && currentUser.getFullName() != null ? currentUser.getFullName() : "";
        String[] nameParts = fullName.split(" ", 2);
        String ho = nameParts.length > 0 ? nameParts[0] : "";
        String ten = nameParts.length > 1 ? nameParts[1] : "";

        String phone = currentUser != null && currentUser.getPhone() != null ? currentUser.getPhone() : "";
        String email = currentUser != null && currentUser.getEmail() != null ? currentUser.getEmail() : "";
        String gender = currentUser != null && currentUser.getGender() != null ? currentUser.getGender() : "male";

        // Parse ngày sinh
        int day = 1, month = 1, year = 2000;
        if (currentUser != null && currentUser.getBirthdate() != null) {
            day = currentUser.getBirthdate().getDayOfMonth();
            month = currentUser.getBirthdate().getMonthValue();
            year = currentUser.getBirthdate().getYear();
        }

        // Parse địa chỉ - có thể chứa CODE hoặc TÊN
        String address = currentUser != null && currentUser.getAddress() != null ? currentUser.getAddress() : "";
        String[] addressParts = address.split(",\\s*");
        String houseNumber = addressParts.length > 0 ? addressParts[0].trim() : "";
        String district = addressParts.length > 1 ? addressParts[1].trim() : "";
        String province = addressParts.length > 2 ? addressParts[2].trim() : "";
        String country = addressParts.length > 3 ? addressParts[3].trim() : "Việt Nam";

        // Kiểm tra xem province và district có phải là CODE hay không
        boolean isProvinceCode = province.matches("\\d+");
        boolean isDistrictCode = district.matches("\\d+");
    %>

    <jsp:include page="/fontend/nguoiB/ASideUser.jsp"/>

    <div class="profile-form-container">
        <h2>Hồ sơ cá nhân</h2>
        <form action="${pageContext.request.contextPath}/updateUser" method="post">
            <div class="form-group">
                <label for="ho">Họ: *</label>
                <input type="text" id="ho" name="ho" value="<%= ho %>" placeholder="Nhập họ" required>
            </div>
            <div class="form-group">
                <label for="ten">Tên: *</label>
                <input type="text" id="ten" name="ten" value="<%= ten %>" placeholder="Nhập tên" required>
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại:</label>
                <input type="tel" id="phone" name="phone" value="<%= phone %>" placeholder="Nhập số điện thoại"
                       required pattern="[0-9]{10}" maxlength="10" title="nhập lại sdt"/>
            </div>
            <div class="form-group">
                <label for="email">Email: </label>
                <input type="email" id="email" name="email" value="<%= email %>" placeholder="Nhập email" required>
            </div>
            <div class="form-group">
                <div class="genders">
                    <label>Giới tính: *</label>
                    <div class="gender-options">
                        <label><input type="radio" name="gender" value="male" <%= "male".equals(gender) ? "checked" : "" %>> Nam</label>
                        <label><input type="radio" name="gender" value="female" <%= "female".equals(gender) ? "checked" : "" %>> Nữ</label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="birthday">
                    <label for="day">Ngày tháng năm sinh: *</label>
                    <input type="number" id="day" name="day" value="<%= day %>" min="1" max="31" required> /
                    <input type="number" id="month" name="month" value="<%= month %>" min="1" max="12" required> /
                    <input type="number" id="year" name="year" value="<%= year %>" min="1900" max="2025" required>
                </div>
            </div>
            <div class="form-group">
                <div class="address">
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
                    <input type="text" id="house-number" name="house-number" value="<%= houseNumber %>" placeholder="Nhập số nhà, xã" required>
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

        // Lấy giá trị đã lưu từ server
        const savedProvince = "<%= province %>";
        const savedDistrict = "<%= district %>";
        const isProvinceCode = <%= isProvinceCode %>;
        const isDistrictCode = <%= isDistrictCode %>;

        console.log("📍 Profile address API:", API_BASE);
        console.log("📍 Saved Province:", savedProvince, "- Is Code:", isProvinceCode);
        console.log("📍 Saved District:", savedDistrict, "- Is Code:", isDistrictCode);

        //  LOAD TỈNH / THÀNH PHỐ
        fetch(API_BASE + "/p/")
            .then(res => {
                if (!res.ok) throw new Error("Không load được tỉnh");
                return res.json();
            })
            .then(provinces => {
                provinceSelect.innerHTML = '<option value="">Chọn tỉnh/thành phố</option>';

                let selectedProvinceCode = null;

                provinces.forEach(p => {
                    const opt = document.createElement("option");
                    opt.value = p.name;  // Lưu TÊN vào value
                    opt.textContent = p.name;
                    opt.dataset.code = p.code;  // Lưu CODE vào dataset
                    opt.dataset.name = p.name;

                    // Chọn tỉnh đã lưu (so sánh cả CODE và TÊN)
                    if (p.name === savedProvince || p.code == savedProvince) {
                        opt.selected = true;
                        selectedProvinceCode = p.code;
                    }

                    provinceSelect.appendChild(opt);
                });

                provinceSelect.disabled = false;
                console.log("✅ Provinces loaded:", provinces.length);

                // Nếu có tỉnh đã lưu, load huyện tương ứng
                if (selectedProvinceCode) {
                    loadDistricts(selectedProvinceCode, savedDistrict);
                }
            })
            .catch(err => {
                console.error("❌ Lỗi load tỉnh:", err);
                alert("Không thể tải danh sách tỉnh/thành phố");
            });

        // Hàm load huyện
        function loadDistricts(provinceCode, districtToSelect = null) {
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
                        opt.value = d.name;  // Lưu TÊN vào value
                        opt.textContent = d.name;
                        opt.dataset.code = d.code;  // Lưu CODE vào dataset
                        opt.dataset.name = d.name;

                        // Chọn huyện đã lưu (so sánh cả CODE và TÊN)
                        if (districtToSelect && (d.name === districtToSelect || d.code == districtToSelect)) {
                            opt.selected = true;
                            console.log("✅ Selected district:", d.name);
                        }

                        districtSelect.appendChild(opt);
                    });

                    districtSelect.disabled = false;
                    console.log("✅ Districts loaded:", districts.length);
                })
                .catch(err => {
                    console.error("❌ Lỗi load huyện:", err);
                    alert("Không thể tải danh sách huyện");
                });
        }

        // KHI CHỌN TỈNH → LOAD HUYỆN
        provinceSelect.addEventListener("change", function () {
            const selectedOption = this.options[this.selectedIndex];
            const provinceCode = selectedOption.dataset.code;

            console.log("📍 Province changed:", selectedOption.value, "- Code:", provinceCode);

            if (!provinceCode) {
                districtSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                districtSelect.disabled = true;
                return;
            }

            loadDistricts(provinceCode);
        });

    });
</script>

</body>
</html>
