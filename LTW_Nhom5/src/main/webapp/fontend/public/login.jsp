<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
<%--    <link rel="stylesheet" href="../css/publicCss/nav.css">--%>
<%--    <link rel="stylesheet" href="../css/publicCss/Authentic.css">--%>
<%--    <link rel="stylesheet" href="../css/publicCss/Register.css">--%>
<%--    <link rel="stylesheet" href="../css/publicCss/login.css">--%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/Authentic.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/Register.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- <script src="../../js/Login.js" defer></script> -->
</head>

<body>
    <header class="navbar">
        <div class="logo">
            <img id="logo" src="${pageContext.request.contextPath}/img/logo.png" alt="Comic Store">
            <span>Comic Store</span>
        </div>
        <nav class="menu">

            <a href="#">Trang chủ</a>

            <div class="dropdown">
                <a href="#">Thể loại &#9662;</a>
                <div class="dropdown-content">
                    <a href="#">Hành động</a>
                    <a href="#">Phiêu lưu</a>
                    <a href="#">Lãng mạn </a>
                    <a href="#">Học đường</a>
                    <a href="#">Kinh dị</a>
                    <a href="#">Hài hước</a>
                    <a href="#">Giả tưởng</a>
                    <a href="#">Trinh thám</a>
                </div>
            </div>

            <a href="#">Liên hệ</a>
            <a href="#">Thông báo</a>
        </nav>
        <div class="actions">
            <!-- <div class="search">
                <i class="fas fa-magnifying-glass"></i>
            </div> -->
            <!-- <a href="#" class="publish-btn">Publish</a> -->
            <a href="#" class="login-btn">Log in</a>

        </div>
    </header>


    <div class="img-Login">
        <%
            String error = (String) request.getAttribute("message");
            if (error == null)error="";
            String Username = request.getParameter("username");
            if (Username==null)Username="";
        %>
        <!-- phần này dang nhap -->
        <form class="container-signup" action="${pageContext.request.contextPath}/login" method="post">
            <div class="title">
                <h3>Đăng nhập Comic Store</h3>
                <span id="span-message" style="color:red; position:relative; top:15px;"><%=error%></span>

            </div>
            <div class="container">
                <div class="sdt_maOTP">
                    <input id="nhapstk" type="text" placeholder="Số điện thoại hoặc Email" name="username" value="<%=Username%>" >
                    <input id="nhapmk" type="password" placeholder="Nhập mật khẩu" name="password"  autocomplete="new-password">
                </div>

                <div class="login-options">
                    <label class="remember-me">
                        <input type="checkbox">
                        Ghi nhớ tài khoản
                    </label>
                    <a href="#" class="forgot-password" id="show-forgot-pw">Quên mật khẩu</a>
                </div>

                <button class="btn btn_guiOTP">Đăng nhập</button>
                <!-- <a href="homePage.jsp">
                </a> -->

                <div class="dktk">
                    <span><a href="#" id="show-register">Đăng ký tài khoản</a></span>
                </div>

                <div class="is-user">
                    <p>Hoặc sử dụng tài khoản</p>
                </div>

                <div class="social-buttons">
                    <a class="google" href="${pageContext.request.contextPath}/login-google">
                        <i class="fa-brands fa-google"></i>
                    </a>
                    <a class="facebook" href="https://facebook.com" target="_blank">
                        <i class="fa-brands fa-facebook"></i>
                    </a>
                </div>
            </div>
        </form>

        <!-- phần này dang ki -->
        <div class="container-register">
            <div class="glass-card">
                <!-- Header -->
                <div class="form-container active" id="registerForm">
                    <div class="form-header">
                        <h2>Tạo tài khoản</h2>
                        <p>Điền thông tin để đăng ký</p>
                    </div>
                </div>

                <div class="auth-form" id="registerFormElement">
                    <div class="input-group">
                        <!--name-->
                        <div class="input-child">
                            <div class="name-register">
                                <i class="fa-solid fa-user"></i>
                                <input id="firstName" name="firstName" type="text" placeholder="Tên đăng nhập" />
                            </div>
                        </div>


                        <!-- Email -->
                        <div class="input-child">
                            <div class="email-container">
                                <i class="fa-solid fa-envelope"></i>
                                <input id="email" name="email" type="text" placeholder="Địa chỉ Email" />
                            </div>
                        </div>

                        <!-- Password -->
                        <div class="input-child">
                            <div class="pw-container">
                                <i class="fa-solid fa-lock"></i>
                                <input id="pw" name="pw" type="text" placeholder="Mật khẩu" />
                            </div>
                        </div>

                        <!-- Confirm Password -->
                        <div class="input-child">
                            <div class="cf-pw-container">
                                <i class="fa-solid fa-lock"></i>
                                <input id="cf-pw" name="cf-pw" type="text" placeholder="Xác nhận mật khẩu" />
                            </div>
                        </div>
                    </div>
                    <!-- Terms checkbox -->
                    <div class="input-group">
                        <div class="input-container" data-doc="TheDoc">
                            <input id="agree" name="agree" type="checkbox" placeholder="Confirm Password" />
                            <label for="agree">Tôi đồng ý với các chính sách và điều khoản</label>
                        </div>
                    </div>
                </div>

                <div class="form-footer">

                    <div class="btn-sign-up">
                        <a href="homePage.jsp">
                            <button>Đăng ký</button>
                        </a>
                    </div>

                    <div class="form-footer">
                        <a href="#" id="show-login">Đăng nhập tài khoản</a>
                    </div>

                </div>
            </div>

        </div>


        <!-- phần này quên xác thuật quên mật khẩu -->
        <div class="forgot-pd-container">
            <h2>Xác thực mail người dùng</h2>
            <div id="forgot-password-form">
                <div class="email-class">
                    <label for="email" class="label-with-icon">Email</label>
                    <!-- <input class="in" type="email" id="email" placeholder="Nhập Email để lấy mã xác thực"> -->
                    <input class="in" type="email" placeholder="Nhập Email để lấy mã xác thực">
                </div>
                <div class="verify">
                    <div class="verify-title">
                        <label for="verify-code" class="label-with-icon">Mã xác thực</label>
                        <input class="in" type="text" id="verify-code" name="verify-code"
                            placeholder="Nhập mã xác thực đã gửi">
                    </div>
                </div>

                <div class="new-pass">
                    <label for="new-password">Mật khẩu mới</label>
                    <input class="in" type="password" id="new-password" name="new-password"
                        placeholder="Nhập mật khẩu mới" disabled>
                </div>
                <div id="remind" hidden="hidden">Chúng tôi đang gửi mã</div>
                <button class="get-verify-code">Lấy mã xác thực</button>

                <a href="homePage.jsp">
                    <button class="submit">Xác nhận</button>
                </a>
            </div>
        </div>

    </div>
</body>

 <footer class="footer">
        <div class="footer-container">
            <!-- Cột 1: Giới thiệu -->
            <div class="footer-column">
                <div class="logo">
                    <a href="#">
                        <img src="${pageContext.request.contextPath}/img/logo.png" alt="logo"><!--420-780-->
                    </a>
                </div>
                <p><b>ComicStore</b> là cửa hàng truyện tranh<br> trực tuyến hàng đầu Việt Nam<br> — nơi bạn có thể mua
                    truyện
                    giấy,<br>
                    đọc truyện online và<br> khám phá thế giới<br> manga – manhwa – comic đa dạng.</p>
                <p>Thành lâp năm <strong>2025</strong>, chúng tôi mang đến hơn
                    <str>10.000+</str>
                    <br>
                    truyện hấp dẫn cho bạn
                </p>
            </div>

            <!-- Cột 2: Liên kết nhanh -->
            <div class="footer-column">
                <h4><i class="fa-solid fa-link"></i> Liên kết nhanh</h4>
                <ul>
                    <li><a href="homePage.jsp">Trang chủ</a></li>
                    <li><a href="FlashSale.jsp">Khuyến mãi</a></li>
                    <li><a href="cart.html">Giỏ hàng</a></li>
                    <li><a href="chat.html">Liên hệ</a></li>
                </ul>
            </div>

            <!-- Cột 3: Hỗ trợ khách hàng -->
            <div class="footer-column">
                <h4><i class="fa-solid fa-headset"></i> Hỗ trợ khách hàng</h4>
                <ul>
                    <li><a href="../nguoiB/RefundPolicy.jsp">Chính sách đổi trả</a></li>
                    <li><a href="../nguoiB/shippingPolicy.jsp">Chính sách vận chuyển</a></li>
                </ul>
            </div>

            <!-- Cột 4: Liên hệ & Mạng xã hội -->
            <div class="footer-column">
                <h4><i class="fa-solid fa-envelope"></i> Liên hệ</h4>
                <p><i class="fa-solid fa-envelope"></i> support@metruyen.vn</p>
                <p><i class="fa-solid fa-phone"></i> 0123 456 789</p>
                <p><i class="fa-solid fa-location-dot"></i> 123 Nguyễn Huệ, Q.1, TP.HCM</p>

                <div class="social-links">
                    <a href="https://www.facebook.com/share/1MVc1miHnd/" title="Facebook"><i
                            class="fab fa-facebook-f"></i></a>
                    <a href="https://www.instagram.com/comic.store/" title="Instagram"><i
                            class="fab fa-instagram"></i></a>
                    <a href="https://www.tiktok.com/@comics_store.oficial" title="TikTok"><i
                            class="fab fa-tiktok"></i></a>
                </div>
            </div>

            <!-- Cột 5: Thanh toán -->
            <div class="footer-column">
                <h4><i class="fa-solid fa-shield-halved"></i> Thanh toán & Bảo mật</h4>
                <p>Hỗ trợ thanh toán qua:</p>
                <div class="payment-icons">
                    <img src="${pageContext.request.contextPath}/img/momo.png" alt="Momo">
                    <img src="${pageContext.request.contextPath}/img/zaloPay.png" alt="ZaloPay">
                </div>
                <p>Website đã đăng ký với Bộ Công Thương.</p>
            </div>
        </div>

        <div class="footer-bottom">
            <p>© 2025 <strong>ComicStore.vn</strong> — All rights reserved.</p>
        </div>
    </footer>

<script>


    //cái dưới là chuyển form đăng nhập đăng ký\
    document.getElementById("show-register").addEventListener("click", function (event) {
        event.preventDefault();
        document.querySelector(".container-signup").style.display = "none";
        document.querySelector(".container-register").style.display = "block";
    });


    document.getElementById("show-login").addEventListener("click", function (event) {
        event.preventDefault();
        document.querySelector(".container-signup").style.display = "flex";
        document.querySelector(".container-register").style.display = "none";
    });


    //cái này làm cho xác thực quên mật khẩu
    document.getElementById("show-forgot-pw").addEventListener("click", function (event) {
        event.preventDefault();
        document.querySelector(".container-signup").style.display = "none";
        document.querySelector(".forgot-pd-container").style.display = "block";
    });

    //cái này new-pass khi quên
    const verifyInput = document.getElementById('verify-code');
    const newPassInput = document.getElementById('new-password');

    verifyInput.addEventListener('input', () => {
        if (verifyInput.value.trim() !== '') {
            newPassInput.disabled = false;
        } else {
            newPassInput.disabled = true;
        }
    });
</script>

</html>