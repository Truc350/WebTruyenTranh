<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/SeriComic.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
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

        <a href="AbouUS.jsp">Liên hệ</a>
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
                <a href="#" class="bell-icon">
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
                            <a href="#">Xem tất cả</a>
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

<div class="contain-main">
    <div class="seri">
        <a href="#" class="image">
            <img src="https://tse4.mm.bing.net/th/id/OIP.FznzlFc591l-OschGXnpHgHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3"
                 alt="Detective Conan Volume 107 cover" class="manga-cover">
        </a>

        <div class="contain1">
            <div class="contain-header">
                <h2 class="manga-title">Detective Conan</h2>
                <p class="manga-author"><strong>Tác giả:</strong> Goshi aoyama</p>
                <p class="manga-publisher"><strong>Nhà xuất bản:</strong> 小学館</p>
            </div>

            <div class="action-panel">
                <div class="notify-section">
                    <button  id="notifyBtn" class="notify-btn">🔔 Nhận thông báo</button>
                </div>
            </div>

        </div>

    </div>
</div>

<div class="item">
    <div class="slider-track">
        <div class="product-item">
            <img src="https://m.media-amazon.com/images/I/91IqatXbNGL.jpg" alt="">
            <p class="product-name">Onepiece Tâp 8</p>
            <p class="product-price">₫35,000</p>
            <p class="sold">Đã bán: <strong>103</strong></p>
        </div>
        <div class="product-item">
            <img src="https://tse2.mm.bing.net/th/id/OIP.sOYHVoZtuhT_wslUk377nAHaLH?w=1498&h=2250&rs=1&pid=ImgDetMain&o=7&rm=3"
                 alt="">
            <p class="product-name">Onepiece Tâp 7</p>
            <p class="product-price">₫40,000</p>
            <p class="sold">Đã bán: <strong>138</strong></p>
        </div>
        <div class="product-item">
            <img src="https://th.bing.com/th/id/OIP.Rv6Zq3gzBUg7PZIoSibkuAAAAA?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3"
                 alt="">
            <p class="product-name">Onepiece Tâp 75</p>
            <p class="product-price">₫39,000</p>
            <p class="sold">Đã bán: <strong>109</strong></p>
        </div>
        <div class="product-item">
            <img src="https://tse4.mm.bing.net/th/id/OIP.mk3uhKbGlMl1FGnF8lhUlAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3"
                 alt="">
            <p class="product-name">Onepiece Tâp 22</p>
            <p class="product-price">₫40,000</p>
            <p class="sold">Đã bán: <strong>72</strong></p>
        </div>
        <div class="product-item">
            <img src="https://m.media-amazon.com/images/I/91hZpBeRbaL._SY425_.jpg" alt="">
            <p class="product-name">Opiece Tâp 21</p>
            <p class="product-price">₫40,000</p>
            <p class="sold">Đã bán: <strong>58</strong></p>
        </div>
        <div class="product-item">
            <img src="https://m.media-amazon.com/images/I/91hZpBeRbaL._SY425_.jpg" alt="">
            <p class="product-name">Opiece Tâp 21</p>
            <p class="product-price">₫40,000</p>
            <p class="sold">Đã bán: <strong>58</strong></p>
        </div>
        <div class="product-item">
            <img src="https://m.media-amazon.com/images/I/91hZpBeRbaL._SY425_.jpg" alt="">
            <p class="product-name">Opiece Tâp 21</p>
            <p class="product-price">₫40,000</p>
            <p class="sold">Đã bán: <strong>58</strong></p>
        </div>

        <div class="product-item">
            <img src="https://dw9to29mmj727.cloudfront.net/products/1421534681.jpg" alt="">
            <p class="product-name">Onepiece Tâp 52</p>
            <p class="product-price">₫40,000</p>
            <p class="sold">Đã bán: <strong>17</strong></p>
        </div>
        <div class="product-item">
            <img src="https://dw9to29mmj727.cloudfront.net/products/1421534681.jpg" alt="">
            <p class="product-name">Onepiece Tâp 52</p>
            <p class="product-price">₫40,000</p>
            <p class="sold">Đã bán: <strong>17</strong></p>
        </div>
        <div class="product-item">
            <img src="https://dw9to29mmj727.cloudfront.net/products/1421534681.jpg" alt="">
            <p class="product-name">Onepiece Tâp 52</p>
            <p class="product-price">₫40,000</p>
            <p class="sold">Đã bán: <strong>17</strong></p>
        </div>
    </div>
</div>

<footer class="footer">
    <div class="footer-container">
        <!-- Cột 1: Giới thiệu -->
        <div class="footer-column">
            <div class="logo">
                <a href="#">
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

</body>
<script>
    const notifyBtn = document.getElementById("notifyBtn");

    notifyBtn.addEventListener("click", () => {
        if (notifyBtn.textContent.trim() === "🔔 Nhận thông báo") {
            notifyBtn.textContent = "🔔 Hủy thông báo";
        } else {
            notifyBtn.textContent = "🔔 Nhận thông báo";
        }
    });
</script>
</html>