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
               <h3>${error}</h3>
               </c:if>

               <label>Nhập Email hoặc Tên đăng nhập:</label>
               <input  placeholder="Email hoặc tên đăng nhập" name="username">

               <label>Nhập mật khẩu:</label>
               <div class="password-box">
                   <input type="password" placeholder="Mật khẩu" name="password">
                   <span class="eye">
                    <img src="${pageContext.request.contextPath}/img/eyePassword.png" id="toggleEye" alt="eye">
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
                <img class="google"
                     src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ13Zhu7gCjSl_MTncNr7aEbl9HkMWaidA4wNFbPO0oxQm49i-RPgTEME3oN_nSroHl1KqwY2haK-IFEYfBc1BkwP9PBNEv9ApC9tvzcVM&s"
                     alt="Google">

                <img class="facebook"
                     src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/500px-Facebook_Logo_%282019%29.png"
                     alt="Facebook">
            </div>

        </div>
    </div>

    <!-- Right 1/3 -->
    <div class="image-section">
        <img src="${pageContext.request.contextPath}/img/anhLogin.png" alt="Books">
    </div>
</div>
<script>
    const eye = document.getElementById("toggleEye");
    const passwordInput = document.querySelector(".password-box input");

    eye.addEventListener("click", () => {
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            eye.src = "${pageContext.request.contextPath}/img/eyePasswordHide.png";
        } else {
            passwordInput.type = "password";
            eye.src = "${pageContext.request.contextPath}/img/eyePassword.png";
        }
    });
    <%--<img src="../../img/anhLogin.png" height="1200" width="676"/><img src="../../img/eyePasswordHide.png" height="512"--%>
    <%--                                                                  width="512"/><img--%>
    <%--    src="../../img/eyePasswordHide.png" height="512" width="512"/></script><script>--%>
    const eye = document.getElementById("toggleEye");
    const passwordInput = document.querySelector(".password-box input");

    eye.addEventListener("click", () => {
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            eye.src = "${pageContext.request.contextPath}/img/eyePasswordHide.png";
        } else {
            passwordInput.type = "password";
            eye.src = "${pageContext.request.contextPath}/img/eyePassword.png";
        }
    });
</script>

</body>
</html>