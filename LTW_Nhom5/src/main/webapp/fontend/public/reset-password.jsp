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

      <form action="${pageContext.request.contextPath}/ResetPassServerlet" method="post">
          <h2>Tạo mật khẩu</h2>

          <label>Nhập mật khẩu mới:</label>
          <div class="password-box">
              <input type="password" name="oldPassword" id="oldPassword">
              <img src="${pageContext.request.contextPath}/img/eyePassword.png" class="eye toggle1">
          </div>

          <label>Xác nhận lại mật khẩu:</label>
          <div class="password-box">
              <input type="password" name="newPassword" id="newPassword">
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
<div class="popup-success" id="successPopup">
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
</script>

<script>
  const confirmBtn = document.getElementById("confirmBtn");
  const successPopup = document.getElementById("successPopup");

  confirmBtn.onclick = () => {
    successPopup.style.display = "flex";

    setTimeout(() => {
      window.location.href = "login1.html";
    }, 2000);
  }
</script>

</body>
</html>