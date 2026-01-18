<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/resetPassword.css">
</head>
<body>

<div class="container">
    <!-- LEFT -->
    <div class="left">
        <div class="box">
            <img src="${pageContext.request.contextPath}/img/logo.png" class="logo">

            <form action="${pageContext.request.contextPath}/ResetPassServlet" method="post">
                <h2>Tạo mật khẩu</h2>

                <c:if test="${not empty error}">
                    <div style="color: red; margin-bottom: 10px;">${error}</div>
                </c:if>

                <label>Nhập mật khẩu mới:</label>
                <div class="password-box">
                    <input type="password" name="oldPassword" id="oldPassword" required>
                    <img src="${pageContext.request.contextPath}/img/eyePassword.png" class="eye toggle1">
                </div>

                <label>Xác nhận lại mật khẩu:</label>
                <div class="password-box">
                    <input type="password" name="newPassword" id="newPassword" required>
                    <img src="${pageContext.request.contextPath}/img/eyePassword.png" class="eye toggle2">
                </div>

                <button id="confirmBtn" type="submit">Xác nhận</button>
            </form>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="right">
        <img src="${pageContext.request.contextPath}/img/anhLogin.png">
    </div>
</div>

<!-- POPUP SUCCESS -->
<div class="popup-success" id="successPopup" style="display: none;">
    <div class="success-box">
        <h2>Thay đổi mật khẩu thành công</h2>
        <div class="check-icon"></div>
    </div>
</div>

<script>
    function togglePassword(eyeClass){
        const eye = document.querySelector("." + eyeClass);
        const input = eye.previousElementSibling;

        eye.addEventListener("click", () => {
            if(input.type === "password"){
                input.type = "text";
                eye.src = "${pageContext.request.contextPath}/img/eyePasswordHide.png";
            }else{
                input.type = "password";
                eye.src = "${pageContext.request.contextPath}/img/eyePassword.png";
            }
        });
    }

    togglePassword("toggle1");
    togglePassword("toggle2");

    // CHỈ CHẠY KHI success = true
    <c:if test="${success eq true}">
    window.onload = () => {
        const successPopup = document.getElementById("successPopup");
        successPopup.style.display = "flex";

        setTimeout(() => {
            window.location.href = "${pageContext.request.contextPath}/login";
        }, 3000);
    }
    </c:if>
</script>

</body>
</html>