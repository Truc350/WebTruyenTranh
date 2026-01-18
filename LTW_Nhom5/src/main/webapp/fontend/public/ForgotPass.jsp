<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quên mật khẩu</title>
<!--  <link rel="stylesheet" href="forgot.css">-->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/ForgotPassword.css">
</head>
<body>

<div class="container">

  <!-- LEFT -->
  <div class="left">
    <div class="box">

      <img src="${pageContext.request.contextPath}/img/logo.png" class="logo">


      <form action="${pageContext.request.contextPath}/AuthenEmailServerlet" method="post">
          <h2>Quên mật khẩu</h2>
          <p>Hãy nhập email của bạn để nhận mã xác thực</p>

          <label>Email:</label>
          <input type="email" placeholder="Nhập email" name="email">
      </form>

      <div class="buttons">
          <div class="buttons">
              <button class="back"
                      onclick="window.location.href='${pageContext.request.contextPath}/login'"
                      style="color: black;">
                  ← Quay lại đăng nhập
              </button>
          </div>


        <button class="send" id="openPopup">Lấy mã xác thực</button>

      </div>

    </div>
  </div>

  <!-- RIGHT -->
  <div class="image-section">
    <img src="${pageContext.request.contextPath}/img/anhLogin.png" alt="Books">
  </div>

</div>
<!-- POPUP OTP -->
<div class="popup" id="otpPopup">
  <div class="popup-content">
    <span class="close" id="closePopup">&times;</span>
    <h2>Nhập mã xác thực</h2>

    <label>Nhập mã xác thực:</label>
    <input type="text" placeholder="Nhập mã">

    <button>Xác nhận</button>
  </div>
</div>


<script>
  const popup = document.getElementById("otpPopup");
  const openBtn = document.getElementById("openPopup");
  const closeBtn = document.getElementById("closePopup");

  openBtn.onclick = () => popup.style.display = "flex";
  closeBtn.onclick = () => popup.style.display = "none";

  window.onclick = (e) => {
    if (e.target === popup) popup.style.display = "none";
  }
</script>


</body>
</html>
