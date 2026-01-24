<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/login1.css">
</head>
<body>

<div class="container">
    <!-- Left 2/3 -->
    <div class="login-section">
        <div class="login-box">
           <form action="${pageContext.request.contextPath}/login" method="post">
               <h2>Đăng nhập</h2>
               <c:if test="${not empty error}">
               <h3 style="color : red; font-size: 14px; display: flex; justify-content: center; ">${error}</h3>
               </c:if>

               <label>Nhập Email hoặc Tên đăng nhập:</label>
               <input  placeholder="Email hoặc tên đăng nhập" name="username">

               <label>Nhập mật khẩu:</label>
               <div class="password-box">
                   <input type="password" placeholder="Mật khẩu" name="password">
                   <span class="eye">
<%--                    <img src="${pageContext.request.contextPath}/img/eyePassword.png" id="toggleEye" alt="eye">--%>
                </span>
               </div>

               <div class="links">
                   <a href="${pageContext.request.contextPath}/fontend/public/Register.jsp">Đăng ký tài khoản</a>
                   <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a>
               </div>

                <button type="submit" value="Đăng nhập">Đăng nhập</button>

           </form>
            <p class="or">Hoặc đăng nhập bằng</p>

            <div class="social">
                <img class="google" id="googleLogin"
                     src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ13Zhu7gCjSl_MTncNr7aEbl9HkMWaidA4wNFbPO0oxQm49i-RPgTEME3oN_nSroHl1KqwY2haK-IFEYfBc1BkwP9PBNEv9ApC9tvzcVM&s"
                     alt="Google"
                     style="cursor: pointer;">

                <img class="facebook" id="facebookLogin"
                     src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/500px-Facebook_Logo_%282019%29.png"
                     alt="Facebook"
                     style="cursor: pointer;">
            </div>

        </div>
    </div>

    <!-- Right 1/3 -->
    <div class="image-section">
        <img src="${pageContext.request.contextPath}/img/anhLogin.png" alt="Books">
    </div>
</div>

<script>
    // Toggle password visibility
    const eye = document.getElementById("toggleEye");
    const passwordInput = document.querySelector(".password-box input");

    if (eye && passwordInput) {
        eye.addEventListener("click", () => {
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                eye.src = "${pageContext.request.contextPath}/img/eyePasswordHide.png";
            } else {
                passwordInput.type = "password";
                eye.src = "${pageContext.request.contextPath}/img/eyePassword.png";
            }
        });
    }

    // Google login
    const googleBtn = document.getElementById("googleLogin");
    if (googleBtn) {
        googleBtn.addEventListener("click", () => {
            window.location.href = "${pageContext.request.contextPath}/login-google";
        });
    }

    // Facebook login
    const facebookBtn = document.getElementById("facebookLogin");
    if (facebookBtn) {
        facebookBtn.addEventListener("click", () => {
            const clientId = "YOUR_FACEBOOK_APP_ID"; // Lấy từ env hoặc config
            const redirectUri = encodeURIComponent("http://localhost:8080/LTW_Nhom5/login-facebook-callback");
            const scope = encodeURIComponent("email,public_profile");

            const facebookAuthUrl = `https://www.facebook.com/v19.0/dialog/oauth?client_id=${clientId}&redirect_uri=${redirectUri}&scope=${scope}&response_type=code`;

            window.location.href = facebookAuthUrl;
        });
    }
</script>

</body>
</html>