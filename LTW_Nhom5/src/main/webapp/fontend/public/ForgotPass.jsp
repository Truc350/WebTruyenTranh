<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/ForgotPassword.css">
</head>
<body>

<div class="container">
    <!-- LEFT -->
    <div class="left">
        <div class="box">
            <img src="${pageContext.request.contextPath}/img/logo.png" class="logo">

            <form action="${pageContext.request.contextPath}/AuthenEmailServlet" method="post">
                <h2>Quên mật khẩu</h2>
                <p>Hãy nhập email của bạn để nhận mã xác thực</p>

                <c:if test="${not empty error}">
                    <div style="color: red; margin-bottom: 10px;">${error}</div>
                </c:if>

                <label>Email:</label>
                <input type="email" placeholder="Nhập email" name="email" required>

                <div class="buttons">
                    <button class="back"
                            type="button"
                            onclick="window.location.href='${pageContext.request.contextPath}/login'"
                            style="color: black;">
                        ← Quay lại đăng nhập
                    </button>

                    <button class="send" type="submit" id="openPopup">Lấy mã xác thực</button>
                </div>
            </form>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="image-section">
        <img src="${pageContext.request.contextPath}/img/anhLogin.png" alt="Books">
    </div>
</div>

<!-- POPUP OTP -->
<div class="popup" id="otpPopup" style="display:none;">
    <div class="popup-content">
        <span class="close" id="closePopup">&times;</span>
        <h2>Nhập mã xác thực</h2>

        <c:if test="${not empty sessionScope.otpError}">
            <div style="color: red; margin-top: 8px;">${sessionScope.otpError}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/VerifyOtpServlet" method="post">
            <label>Nhập mã xác thực:</label>
            <input type="text" placeholder="Nhập mã" name="code" required>
            <button type="submit">Xác nhận</button>
        </form>
    </div>
</div>

<script>
    const popup = document.getElementById("otpPopup");
    const closeBtn = document.getElementById("closePopup");

    // Đóng popup khi click X
    closeBtn.onclick = () => {
        popup.style.display = "none";
    }

    // Đóng popup khi click ra ngoài
    window.onclick = (e) => {
        if (e.target === popup) {
            popup.style.display = "none";
        }
    }

    // MỞ POPUP KHI có otpSent trong session
    <c:if test="${sessionScope.otpSent eq true}">
    window.onload = () => {
        popup.style.display = "flex";
    }
    </c:if>
</script>

</body>
</html>