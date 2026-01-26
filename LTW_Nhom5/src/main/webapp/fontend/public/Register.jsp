<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng ký</title>
<!--  <link rel="stylesheet" href="../css/publicCss/register.css">-->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/signIn.css">
</head>
<body>

<div class="container">

  <!-- LEFT -->
  <div class="left">
    <div class="box">

      <h2>Đăng ký</h2>

        <p id="clientError"
           style="color:red; font-size:14px; font-weight:bold;
          text-align:center; display:none; margin-bottom:5px;">
        </p>


        <c:if test="${not empty error}">
            <p class="" style="color : red; font-size: 14px; display: flex;font-weight: bold; justify-content: center;margin-bottom: 5px">${error}</p>
        </c:if>

      <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" onsubmit="return validateRegister()">
        <label>Nhập tên đăng nhập:</label>
        <input id="username" type="text" placeholder="" name="username">

        <label>Nhập email:</label>
        <input id="email" type="email" placeholder="" name="email">

        <label>Nhập mật khẩu:</label>
        <div class="password-box">
          <input id="password" type="password" placeholder="" name="password">
          <img src="${pageContext.request.contextPath}/img/eyePassword.png" class="eye toggle1">
        </div>

        <label>Xác nhận lại mật khẩu:</label>
        <div class="password-box">
          <input id="confirmPassword" type="password" placeholder="" name="confirmPassword">
          <img src="${pageContext.request.contextPath}/img/eyePassword.png" class="eye toggle2">
        </div>

        <button type="submit" value="Đăng ký" id="registerBtn">Đăng ký</button>
      </form>

    </div>
  </div>

  <!-- RIGHT -->
  <div class="right">
    <img src="${pageContext.request.contextPath}/img/anhLogin.png" alt="Books">
  </div>

</div>

<!-- POPUP SUCCESS -->
<div class="popup-success" id="successPopup">
  <div class="success-box">
    <h2>Đăng ký thành công</h2>
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
</script>

<c:if test="${not empty success}">
    <script>
        const successPopup = document.getElementById("successPopup");
        successPopup.style.display = "flex";
        setTimeout(() => {
            window.location.href = "${pageContext.request.contextPath}/login";
        }, 2000);
    </script>
</c:if>


</body>

<script>
    function validateRegister() {
        const username = document.getElementById("username").value.trim();
        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();
        const confirmPassword = document.getElementById("confirmPassword").value.trim();

        const clientError = document.getElementById("clientError");
        const serverError = document.getElementById("serverError");

        // Regex
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,}$/;

        // reset lỗi
        clientError.style.display = "none";
        clientError.innerText = "";
        if (serverError) serverError.style.display = "none";

        // 1. Rỗng
        if (!username || !email || !password || !confirmPassword) {
            showRegisterError("Vui lòng nhập đầy đủ thông tin");
            return false;
        }

        // 2. Email
        if (!emailRegex.test(email)) {
            showRegisterError("Email không đúng định dạng");
            return false;
        }

        // 3. Password
        if (!passwordRegex.test(password)) {
            showRegisterError(
                "Mật khẩu phải hơn 8 ký tự, gồm chữ hoa, chữ thường và ký tự đặc biệt"
            );
            return false;
        }

        // 4. Confirm password
        if (password !== confirmPassword) {
            showRegisterError("Mật khẩu xác nhận không khớp");
            return false;
        }

        return true; //cho submit
    }

    function showRegisterError(msg) {
        const clientError = document.getElementById("clientError");
        const serverError = document.getElementById("serverError");

        if (serverError) serverError.style.display = "none";

        clientError.innerText = msg;
        clientError.style.display = "block";
    }
</script>
<script>
    ["username", "email", "password", "confirmPassword"].forEach(id => {
        document.getElementById(id).addEventListener("input", clearRegisterErrors);
    });

    function clearRegisterErrors() {
        const clientError = document.getElementById("clientError");
        const serverError = document.getElementById("serverError");

        if (clientError) clientError.style.display = "none";
        if (serverError) serverError.style.display = "none";
    }
</script>


</html>