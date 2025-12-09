<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us</title>
    <link rel="stylesheet" href="../css/publicCss/AboutUs.css">
    <link rel="stylesheet" href="../css/publicCss/nav.css ">
    <link rel="stylesheet" href="../css/publicCss/FooterStyle.css ">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>


 <header class="navbar">
        <a href="homePage.jsp">
            <div class="logo">
            <img id="logo" src="../../img/logo.png" alt="Comic Store">
            <span>Comic Store</span>
        </div>
        </a>
        <nav class="menu">
            <a href="homePage.jsp">Trang chủ</a>

            <div class="dropdown">
                <a href="#">Thể loại &#9662;</a>
                <div class="dropdown-content">
                    <a href="CatagoryPage.jsp">Hành động</a>
                    <a href="#">Phiêu lưu</a>
                    <a href="#">Lãng mạn </a>
                    <a href="#">Học đường</a>
                    <a href="#">Kinh dị</a>
                    <a href="#">Hài hước</a>
                    <a href="#">Giả tưởng</a>
                    <a href="#">Trinh thám</a>
                    <!-- <a href="#">Cổ đại</a>
                    <a href="#">Đời thường</a> -->
                </div>
            </div>

            <a href="AbouUS.html">Liên hệ</a>
        </nav>
        <div class="search-bar">
            <input type="text" placeholder="Voucher Xịn đến 100 nghìn" class="search-input">
            <button class="search-button">
                <i class="fas fa-magnifying-glass"></i>
            </button>
        </div>
        <div class="contain-left">
            
            <div class="actions">
                <div class="notify-wrapper">
                    <a href="../nguoiB/profile.jsp" class="bell-icon">
                        <i class="fa-solid fa-bell"></i>
                        <span id="span-bell">2</span>
                    </a>
                    <!-- Khung thông báo -->
                    <div class="notification-panel">
                        <div class="notification-header">
                            <div class="inform-num">
                                <i class="fa-solid fa-bell"></i>
                                <span>Thông báo</span>
                                <span class="notification-badge">(1)</span>
                            </div>
                            <div class="inform-all">
                                <a href="../nguoiB/profile.jsp">Xem tất cả</a>
                            </div>
                        </div>
                        <div class="notification-content inform1">
                            <strong>Cập nhật email ngay để nhận voucher nhé!</strong><br>
                            Bạn vừa đăng kí tài khoản. Hãy cập nhật email ngay để nhận được các thông báo và phần quà
                            hấp
                            dẫn.
                        </div>
                        <div class="notification-content inform2">
                            <strong>Cập nhật email ngay để nhận vorcher nhé!</strong><br>
                            Bạn vừa đăng kí tài khoản.Hãy cập nhật email ngay để nhận được các thông báo và phần quà hấp
                            dẫn.
                        </div>
                    </div>
                </div>
            </div>

            <div class="actions">
                <a href="../nguoiB/chat.jsp">
                    <i class="fa-solid fa-comment"></i>
                </a>
            </div>

            <div class="actions">
                <a href="../nguoiB/cart.jsp">
                    <i class="fa-solid fa-cart-shopping"></i>
                </a>
            </div>

            <div class="actions user-nav">
                <i class="fa-solid fa-user" id="user"></i>
                <div class="dropdown-user">
                    <a href="../nguoiB/profile.jsp">Trang chủ</a>
                    <a href="login.jsp">Đăng xuất</a>
                </div>
            </div>

            <!-- <div class="login-btn">
                 <a href="login.jsp" class="login-btn">Log out</a>
            </div> -->
        </div>

    </header>




    <div class="container">
        <!-- Hero -->
        <div>
            <section class="hero">
                <div class="hero-text">
                    <h1>About Us</h1>
                    <p>Chúng tôi mang đến trải nghiệm đọc truyện tranh hiện đại, tiện lợi và đầy cảm hứng cho độc giả
                        Việt Nam.</p>
                </div>
                <div>
                    <img id="logo" src="../../img/AboutUs.png" alt="Comic Store">
                </div>
            </section>
        </div>

        <!-- About -->
        <section class="about-us" id="about">

            <h2>Về chúng tôi</h2>
            <p>
                Comic Store là nơi hội tụ của những câu chuyện kỳ ảo, hài hước, cảm động và đầy cảm hứng từ khắp nơi
                trên thế giới. Chúng tôi mang đến cho độc giả Việt Nam trải nghiệm đọc truyện tranh hiện đại, tiện lợi
                và phong phú – từ manga Nhật Bản, manhwa Hàn Quốc đến comic phương Tây và truyện tranh Việt.
            </p>
            <p>
                Mỗi đầu truyện đều được tuyển chọn kỹ lưỡng, đảm bảo chất lượng nội dung, hình ảnh và bản dịch, giúp bạn
                đắm chìm trong thế giới truyện tranh một cách trọn vẹn nhất.
            </p>
        </section>

        <!-- Mission -->
        <section class="mission" id="mission">
            <h3>Sứ mệnh của chúng tôi</h3>
            <p>
                Chúng tôi mong muốn xây dựng một cộng đồng yêu truyện tranh sôi động, nơi mọi người có thể khám phá,
                chia sẻ và kết nối qua những câu chuyện đầy màu sắc. ComicVerse không chỉ là nơi bán truyện – mà là nơi
                khơi nguồn cảm hứng và nuôi dưỡng đam mê.
            </p>
        </section>

        <!-- Features -->
        <section class="features" id="features">
            <article class="feature-card">
                <h4>Kho truyện phong phú</h4>
                <p>Hơn 10.000 đầu truyện đủ thể loại: hành động, lãng mạn, hài hước, kinh dị, giả tưởng, slice of
                    life...</p>
                <p>Cập nhật liên tục các bộ truyện hot, trending và mới phát hành.</p>
            </article>

            <article class="feature-card">
                <h4>Tư vấn chọn truyện</h4>
                <p>Gợi ý truyện theo sở thích, độ tuổi và tâm trạng của bạn.</p>
                <p>Đội ngũ biên tập viên am hiểu truyện tranh luôn sẵn sàng hỗ trợ.</p>
            </article>

            <article class="feature-card">
                <h4>Trải nghiệm đọc truyện đỉnh cao</h4>
                <p>Chất lượng hình ảnh sắc nét, bản dịch chuẩn chỉnh.</p>
                <p>Dịch vụ chăm sóc khách hàng tận tâm, thân thiện.</p>
            </article>
        </section>
    </div>

</body>


<footer class="footer">
    <div class="footer-container">
        <!-- Cột 1: Giới thiệu -->
        <div class="footer-column">
            <div class="logo">
                <a href="homePage.jsp">
                    <img src="../../img/logo.png" alt="logo"><!--420-780-->
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
                <li><a href="../nguoiB/cart.jsp">Giỏ hàng</a></li>
                <li><a href="AbouUS.html">Liên hệ</a></li>
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
                <a href="https://www.facebook.com/share/1MVc1miHnd/" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                <a href="https://www.instagram.com/comic.store/" title="Instagram"><i class="fab fa-instagram"></i></a>
                <a href="https://www.tiktok.com/@comics_store.oficial" title="TikTok"><i class="fab fa-tiktok"></i></a>
            </div>
        </div>

        <!-- Cột 5: Thanh toán -->
        <div class="footer-column">
            <h4><i class="fa-solid fa-shield-halved"></i> Thanh toán & Bảo mật</h4>
            <p>Hỗ trợ thanh toán qua:</p>
            <div class="payment-icons">
                <img src="../../img/momo.png" alt="Momo">
                <img src="../../img/zalopay.png" alt="ZaloPay">
            </div>
            <p>Website đã đăng ký với Bộ Công Thương.</p>
        </div>
    </div>

    <div class="footer-bottom">
        <p>© 2025 <strong>ComicStore.vn</strong> — All rights reserved.</p>
    </div>
</footer>


</html>