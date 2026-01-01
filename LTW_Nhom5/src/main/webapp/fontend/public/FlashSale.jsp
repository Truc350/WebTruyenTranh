<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FlashSale.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>
<jsp:include page="/fontend/public/header.jsp" />

    <div class="container">
        <div class="banner-header">
            <img src="../../img/BannerFlashSale.png" alt="">
        </div>
    </div>

    <div class="flash-banner">
        <div class="flash-title">
            <span class="badge">FLASH SALE</span>
        </div>

        <div class="contain-flash">
            <div class="countdown-wrap">
                <span class="countdown-label">Kết thúc trong</span>
                <div class="countdown" id="countdown">
                    <div class="time-box" id="hh">02</div>
                    <span class="sep">:</span>
                    <div class="time-box" id="mm">00</div>
                    <span class="sep">:</span>
                    <div class="time-box" id="ss">00</div>
                </div>
            </div>

            <div class="slot-row" id="slotRow">
                <!-- Các khung giờ bán -->
                <div class="slot" id="slot1" data-time="22:00">
                    <div class="slot-time">22:00</div>
                    <div class="slot-status">Đang bán</div>
                </div>
                <div class="slot" id="slot2" data-time="00:00" data-nextday="true">
                    <div class="slot-time">00:00</div>
                    <div class="slot-status">Ngày mai</div>
                </div>
                <div class="slot" data-time="06:00" data-nextday="true">
                    <div class="slot-time">06:00</div>
                    <div class="slot-status">Ngày mai</div>
                </div>
                <div class="slot" data-time="08:00" data-nextday="true">
                    <div class="slot-time">08:00</div>
                    <div class="slot-status">Ngày mai</div>
                </div>
                <div class="slot" data-time="10:00" data-nextday="true">
                    <div class="slot-time">10:00</div>
                    <div class="slot-status">Ngày mai</div>
                </div>
            </div>
        </div>
    </div>


    <div class="container-item">
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://tse2.mm.bing.net/th/id/OIP.9XM2JUuE0llfp0orZz18qwHaLg?rs=1&pid=ImgDetMain&o=7&rm=3"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Thám tử Conan Tập 100
                </h3>

                <div class="price-section">
                    <span class="price">18.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">30.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 196</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://m.media-amazon.com/images/I/81hguFrRGYL._SL1500_.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Naruto Tập 74
                </h3>

                <div class="price-section">
                    <span class="price">24.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://newshop.vn/public/uploads/products/18649/conan-tap-17.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    One-Punch Tâp 25
                </h3>

                <div class="price-section">
                    <span class="price">16.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://1.bp.blogspot.com/-jvKRlAvLy2g/YVMRkp8KVnI/AAAAAAABWnc/8-3hUdKcezYo0Gx7bbHE5lFj32rcUXD2gCNcBGAsYHQ/s0/Dragon-Ball-Full-Color---Volume-02---Chapter-015---Page-01.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Dragon Ball Tập 15
                </h3>

                <div class="price-section">
                    <span class="price">20.000₫</span>
                    <span class="discount">-33%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">30.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://tse3.mm.bing.net/th/id/OIP.UYXVfw_z4MzfvIEod7Gh7QAAAA?cb=ucfimg2ucfimg=1&w=400&h=629&rs=1&pid=ImgDetMain&o=7&rm=3"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Naruto Tập 123
                </h3>

                <div class="price-section">
                    <span class="price">24.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://th.bing.com/th/id/OIP.T0Xbq4rZnls95XvoWldF-gHaLH?o=7&cb=ucfimg2rm=3&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    One-Punch Man Tập 24
                </h3>

                <div class="price-section">
                    <span class="price">16.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://i.pinimg.com/originals/3a/a9/47/3aa9473f3ce582ddfcc0cf8cf2a12edf.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Naruto Tập 128
                </h3>

                <div class="price-section">
                    <span class="price">26.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://cdn0.fahasa.com/media/catalog/product/v/u/vua_sang_che___tap3.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Vua sáng chế Tập 3
                </h3>

                <div class="price-section">
                    <span class="price">26.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://yzgeneration.com/wp-content/uploads/2023/07/One-Punch-Man-Tome-27.webp"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    One-Punch Man Tập 27
                </h3>

                <div class="price-section">
                    <span class="price">16.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://online.pubhtml5.com/anvq/hidy/files/large/1.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Doraemon Tập 6
                </h3>

                <div class="price-section">
                    <span class="price">16.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>

    </div>

    <div class="container-item2">
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://th.bing.com/th/id/OIP.T0Xbq4rZnls95XvoWldF-gHaLH?o=7&cb=ucfimg2rm=3&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    One-Punch Man Tập 24
                </h3>

                <div class="price-section">
                    <span class="price">16.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://tse4.mm.bing.net/th/id/OIP.ITHf6RrUo34b34N0miyxlQAAAA?cb=ucfimg2ucfimg=1&w=385&h=600&rs=1&pid=ImgDetMain&o=7&rm=3"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Vua sáng chế Tập 17
                </h3>

                <div class="price-section">
                    <span class="price">26.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://i.pinimg.com/originals/3a/a9/47/3aa9473f3ce582ddfcc0cf8cf2a12edf.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Naruto Tập 128
                </h3>

                <div class="price-section">
                    <span class="price">26.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://online.pubhtml5.com/anvq/hidy/files/large/1.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Doraemon Tập 6
                </h3>

                <div class="price-section">
                    <span class="price">16.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>
        <a href="detail.jsp">
            <div class="product-card">
                <img src="https://media.vov.vn/sites/default/files/styles/large/public/2021-04/conan_98.jpg"
                    alt="" class="product-image" />

                <h3 class="product-title">
                    Thám tử Conan Tập 98
                </h3>

                <div class="price-section">
                    <span class="price">16.000₫</span>
                    <span class="discount">-40%</span>
                </div>
                <div class="price-section">
                    <span class="old-price">40.000₫</span>
                </div>

                <div class="progress-bar">
                    <div class="progress-fill" style="width: 40%;"></div>
                </div>
                <div class="sold-text">Đã bán 11</div>

                <button class="add-to-cart">Thêm giỏ hàng</button>
            </div>

        </a>

    </div>

<!-- INCLUDE FOOTER -->
<jsp:include page="/fontend/public/Footer.jsp" />

    <script>
        document.querySelectorAll('.slot').forEach(slot => {
            slot.addEventListener('click', () => {
                // Xóa border vàng khỏi tất cả slot
                document.querySelectorAll('.slot').forEach(s => {
                    s.style.border = '1px solid rgba(255,255,255,0.3)';
                });

                // Gán border vàng cho slot được nhấn
                slot.style.border = '2px solid #ffd60a';
            });
        });

        //nhấn slot 2 thì qua 2
        document.getElementById("slot2").addEventListener("click", function (event) {
            event.preventDefault();
            document.querySelector(".container-item2").style.display = "flex";
            document.querySelector(".container-item").style.display = "none";
        });
        //nhấn slot 1 thì qua 1
        document.getElementById("slot1").addEventListener("click", function (event) {
            event.preventDefault();
           document.querySelector(".container-item").style.display = "flex";
            document.querySelector(".container-item2").style.display = "none";
        });

    </script>


</body>

</html>