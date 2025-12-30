    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page import="java.util.List" %>
    <%@ page import="vn.edu.hcmuaf.fit.ltw_nhom5.model.Banner" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/homePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="${pageContext.request.contextPath}/js/homePage.js"></script>
    </head>

    <body>

    <jsp:include page="/fontend/public/header.jsp" />

    <div class="container-content">


    <%--banner    --%>

        <%
            List<Banner> banners = (List<Banner>) request.getAttribute("banners");
        %>


        <div class="bannder-des">
            <div class="banner">
                <div class="list-images">
                    <% if (banners != null && !banners.isEmpty()) {
                        for (Banner b : banners) { %>
                    <img class="img" src="<%= b.getImageUrl() %>" alt="banner">
                    <% }
                    } else { %>
                    <img class="img" src="${pageContext.request.contextPath}/img/banner1.jpg" alt="banner">
                    <% } %>
                </div>

                <div class="btn prev">&#10094;</div>
                <div class="btn next">&#10095;</div>

                <div class="dots">
                    <% if (banners != null) {
                        for (int i = 0; i < banners.size(); i++) { %>
                    <div class="dot <%= (i==0 ? "active" : "") %>"></div>
                    <% } } %>
                </div>
            </div>
        </div>


    <!-- chỗ này banner -->
<%--    <div class="bannder-des">--%>
<%--        <div class="banner">--%>
<%--            <div class="list-images">--%>
<%--                <img class="img" src="../../img/banner1.jpg" alt="">--%>
<%--                <img class="img" src="../../img/banner2.jpg" alt="">--%>
<%--                <img id="img-banner3" class="img" src="../../img/banner3.jpg" alt="">--%>
<%--                <img class="img" src="../../img/banner4.jpg" alt="">--%>
<%--            </div>--%>

<%--            <div class="btn prev">&#10094;</div>--%>
<%--            <div class="btn next">&#10095;</div>--%>

<%--            <div class="dots">--%>
<%--                <div class="dot active"></div>--%>
<%--                <div class="dot"></div>--%>
<%--                <div class="dot"></div>--%>
<%--                <div class="dot"></div>--%>
<%--            </div>--%>

<%--        </div>--%>
<%--    </div>--%>


    <!-- chỗ này là danh mục -->
    <div class="danh-muc-icon">
        <h2>Tiện ích</h2>
        <div class="icon-list">
            <a href="FlashSale.jsp">
                <div class="icon-item">
                    <i class="fa-solid fa-bolt-lightning"></i>
                    <p>Flash Sale</p>
                </div>
            </a>

            <a href="getVourcher.jsp">
                <div class="icon-item">
                    <i class="fa-solid fa-money-bill"></i>
                    <p>Săn voucher</p>
                </div>
            </a>

            <a href="../nguoiB/profile.jsp">
                <div class="icon-item">
                    <i class="fa-solid fa-wallet"></i>
                    <p>Ví Voucher</p>
                </div>
            </a>
            <a href="../nguoiB/profile.jsp">
                <div class="icon-item">
                    <i class="fa-solid fa-list"></i>
                    <p>WishList</p>
                </div>
            </a>
        </div>

        <div class="flash-sale">
            <div class="titile-flash-sale">
                <h2>FLASH SALE</h2>

                <c:if test="${not empty flashSale}">
                    <p id="flash-sale-countdown"
                       data-end-time="${flashSale.endTime}">
                        Đang tải thời gian...
                    </p>
                </c:if>

                <c:if test="${empty flashSale}">
                    <p>Hiện không có Flash Sale</p>
                </c:if>
            </div>

            <div class="list-product-sale">
                <div>
                    <a href="detail.jsp">
                        <h3>Thám Tử Lừng Danh Conan Tập 100</h3>
                        <p>Giá khuyến mãi: 18.000₫</p>
                        <p>Giá gốc: <s>30,000₫</s></p>
                        <p>Giảm giá: 40%</p>
                    </a>
                </div>

                <div>

                    <h3>Kiếm sĩ mạnh nhất (Tái Bản)</h3>
                    <p>Tác giả: Jared Diamond</p>
                    <p>Giá khuyến mãi: 47,650₫</p>
                    <p>Giá gốc: <s>75,000₫</s></p>
                    <p>Giảm giá: 37%</p>

                </div>

                <div>

                    <h3>Oggy và những chú gián - Sân Băng</h3>
                    <p>Giá khuyến mãi: 134,000₫</p>
                    <p>Giá gốc: <s>213,000₫</s></p>
                    <p>Giảm giá: 37%</p>

                </div>

                <div>

                    <h3>Tấm Cám (2025)</h3>
                    <p>Giá khuyến mãi: 119,000₫</p>
                    <p>Giá gốc: <s>189,000₫</s></p>
                    <p>Giảm giá: 37%</p>

                </div>

            </div>


            <div class="more-btn">
                <a href="FlashSale.jsp">
                    <button>Xem thêm</button>
                </a>
            </div>
        </div>


        <div id="slider">
            <div class="suggest">
                <h2>Gợi ý cho bạn</h2>
            </div>

            <!-- slider 1 -->
            <div class="product-slider">

                <!-- mũi tên trái -->
                <div class="arrow prev">&#10094;</div>

                <div class="slider-track">
                    <div class="product-item">
                        <img src="https://tse2.mm.bing.net/th/id/OIP.vD8jLn7dqAK9Wuz_D0iCeAHaLz?rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Doraemon Tập 23</p>
                        <p class="product-price">₫18,000</p>
                        <p class="sold">Đã bán: <strong>196</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://product.hstatic.net/200000343865/product/1_9544a3ba5bd64806ab59f7fd9fafcf13_ea18ba498dbf48458655f34dd7c049e8_master.jpg"
                             alt="">
                        <p class="product-name">Doraemon Tập 1</p>
                        <p class="product-price">₫27,000</p>
                        <p class="sold">Đã bán: <strong>185</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://online.pubhtml5.com/wdykl/gqwi/files/large/1.jpg" alt="">
                        <p class="product-name">Doraemon Tập 11</p>
                        <p class="product-price">₫16,000</p>
                        <p class="sold">Đã bán: <strong>128</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://tse1.mm.bing.net/th/id/OIP.WKmbCVIbTS0Oct_J65DYjAHaMT?rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Doraemon Tập 6</p>
                        <p class="product-price">₫19,000</p>
                        <p class="sold">Đã bán: <strong>96</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://tse2.mm.bing.net/th/id/OIP.EYeZC0QXNbZJ9uKUFqejCQHaMT?w=1083&h=1800&rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Doraemon Tập 3</p>
                        <p class="product-price">₫22,000</p>
                        <p class="sold">Đã bán: <strong>46</strong></p>
                    </div>

                    <div class="product-item">
                        <img src="https://tse3.mm.bing.net/th/id/OIP.7x-q72jnW1WndxyDjThCZgHaMT?rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Doraemon Tập 15</p>
                        <p class="product-price">₫19,000</p>
                        <p class="sold">Đã bán: <strong>135</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://online.pubhtml5.com/anvq/nwha/files/large/1.jpg" alt="">
                        <p class="product-name">Doraemon Tập 13</p>
                        <p class="product-price">₫21,000</p>
                        <p class="sold">Đã bán: <strong>296</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://online.pubhtml5.com/anvq/hidy/files/large/1.jpg" alt="">
                        <p class="product-name">Doraemon Tập 6</p>
                        <p class="product-price">₫17,000</p>
                        <p class="sold">Đã bán: <strong>186</strong></p>
                    </div>


                </div>

                <!-- mũi tên phải -->
                <div class="arrow next">&#10095;</div>
            </div>

            <!-- slider 2 -->
            <div class="product-slider">

                <!-- mũi tên trái -->
                <div class="arrow prev">&#10094;</div>

                <div class="slider-track">
                    <div class="product-item">
                        <a href="detail.jsp">
                            <img src="https://tse2.mm.bing.net/th/id/OIP.9XM2JUuE0llfp0orZz18qwHaLg?rs=1&pid=ImgDetMain&o=7&rm=3"
                                 alt="">
                            <p class="product-name">Thám tử lừng danh Conan tập 100</p>
                        </a>
                        <p class="product-price">18,000 đ</p>
                        <p class="sold">Đã bán: <strong>196</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://tse1.mm.bing.net/th/id/OIP.P5rFWcOxdjC4jsCK2hMfvwAAAA?w=275&h=431&rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 36</p>
                        <p class="product-price">₫27,000</p>
                        <p class="sold">Đã bán: <strong>108</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://media.vov.vn/sites/default/files/styles/large/public/2021-04/conan_98.jpg"
                             alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 98</p>
                        <p class="product-price">₫18,000</p>
                        <p class="sold">Đã bán: <strong>120</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://www.detectiveconanworld.com/wiki/images/a/aa/Volume28v.jpg" alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 28</p>
                        <p class="product-price">₫18,000</p>
                        <p class="sold">Đã bán: <strong>130</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 86</p>
                        <p class="product-price">₫22,000</p>
                        <p class="sold">Đã bán: <strong>99</strong></p>
                    </div>

                    <div class="product-item">
                        <img src="https://www.detectiveconanworld.com/wiki/images/thumb/7/7d/Volume75v.jpg/225px-Volume75v.jpg"
                             alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 75</p>
                        <p class="product-price">₫19,000</p>
                        <p class="sold">Đã bán: <strong>82</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://www.detectiveconanworld.com/wiki/images/d/d8/Volume72v.jpg" alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 72</p>
                        <p class="product-price">₫21,000</p>
                        <p class="sold">Đã bán: <strong>36</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://www.detectiveconanworld.com/wiki/images/3/30/Volume76v.jpg" alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 76</p>
                        <p class="product-price">₫17,000</p>
                        <p class="sold">Đã bán: <strong>83</strong></p>
                    </div>


                </div>

                <!-- mũi tên phải -->
                <div class="arrow next">&#10095;</div>
            </div>

            <!-- slider 3 -->
            <div class="product-slider">

                <!-- mũi tên trái -->
                <div class="arrow prev">&#10094;</div>

                <div class="slider-track">
                    <div class="product-item">
                        <img src="https://m.media-amazon.com/images/I/61E6Vvsc6pL.jpg" alt="">
                        <p class="product-name">Naruto Tâp 24</p>
                        <p class="product-price">₫35,000</p>
                        <p class="sold">Đã bán: <strong>93</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://m.media-amazon.com/images/I/81hguFrRGYL._SL1500_.jpg" alt="">
                        <p class="product-name">Naruto Tâp 45</p>
                        <p class="product-price">₫40,000</p>
                        <p class="sold">Đã bán: <strong>38</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://m.media-amazon.com/images/I/818RM6H2oHL._SL1500_.jpg" alt="">
                        <p class="product-name">Naruto Tâp 160</p>
                        <p class="product-price">₫39,000</p>
                        <p class="sold">Đã bán: <strong>79</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://m.media-amazon.com/images/I/81W0jEvdO9L.jpg" alt="">
                        <p class="product-name">Naruto Tâp 62</p>
                        <p class="product-price">₫40,000</p>
                        <p class="sold">Đã bán: <strong>72</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://i.pinimg.com/originals/3a/a9/47/3aa9473f3ce582ddfcc0cf8cf2a12edf.jpg"
                             alt="">
                        <p class="product-name">Naruto Tâp 208</p>
                        <p class="product-price">₫40,000</p>
                        <p class="sold">Đã bán: <strong>58</strong></p>
                    </div>

                    <div class="product-item">
                        <img src="https://tse4.mm.bing.net/th/id/OIP.9v3RcOMUqWTRHXD8RwdBqwHaK0?cb=ucfimg2ucfimg=1&w=876&h=1280&rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Naruto Tâp 187</p>
                        <p class="product-price">₫40,000</p>
                        <p class="sold">Đã bán: <strong>17</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://cdn0.fahasa.com/media/catalog/product/n/a/naruto1-2-page-001.jpg" alt="">
                        <p class="product-name">Naruto Tâp 1</p>
                        <p class="product-price">₫40,000</p>
                        <p class="sold">Đã bán: <strong>49</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://tse3.mm.bing.net/th/id/OIP.UYXVfw_z4MzfvIEod7Gh7QAAAA?cb=ucfimg2ucfimg=1&w=400&h=629&rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Naruto Tâp 123</p>
                        <p class="product-price">₫25,000</p>
                        <p class="sold">Đã bán: <strong>76</strong></p>
                    </div>


                </div>

                <!-- mũi tên phải -->
                <div class="arrow next">&#10095;</div>
            </div>

            <!-- slider-popup -->
            <div id="product-slider-popup" class="product-slider">

                <!-- mũi tên trái -->
                <div class="arrow prev">&#10094;</div>

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
                        <img src="https://dw9to29mmj727.cloudfront.net/products/1421534681.jpg" alt="">
                        <p class="product-name">Onepiece Tâp 52</p>
                        <p class="product-price">₫40,000</p>
                        <p class="sold">Đã bán: <strong>17</strong></p>
                    </div>


                </div>

                <!-- mũi tên phải -->
                <div class="arrow next">&#10095;</div>
            </div>

            <div id="more-btn-popup-slider" class="more-btn">
                <button>Xem thêm</button>
            </div>

        </div>


        <div class="top-truyen">
            <h2>Top sách bán chạy trong tuần</h2>
            <div class="content-top">
                <div class="list-book">
                    <ol>
                        <c:forEach var="comic" items="${topComics}" varStatus="status">
                            <li id="item-pop-${status.index + 1}">
                                <div class="sach-item">
                                    <img src="${comic.thumbnailUrl}" alt="${comic.nameComics}">
                                    <h3>${comic.nameComics}</h3>
                                    <p>Đã bán: <strong>${comic.totalSold}</strong></p>
                                </div>
                            </li>
                        </c:forEach>
                    </ol>
                </div>

                <!-- cái này popup 1-->
                <div class="sach-chi-tiet pop-detail-home1">
                    <div class="item-top-1">
                        <img src="https://tse2.mm.bing.net/th/id/OIP.o5BlN5mfxXoD8u_Xm6S9igHaLH?rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                    </div>
                    <div class="detail-top-1">
                        <h3>One piece: Vùng Wano quốc</h3>
                        <p>Tác giả: Eiichiro Oda</p>
                        <p>Nhà xuất bản: Shueisha</p>
                        <p id="sale-price">22.500 đ</p>
                        <div class="sale-item">
                            <p><s>30.000 đ</s></p>
                            <div id="sale-percent">-25%</div>
                        </div>
                        <p>
                            Mô tả: Câu chuyện xoay quanh Monkey D. Luffy, một chàng trai có khả năng co giãn như cao
                            su sau khi ăn Trái Ác Quỷ Gomu Gomu.
                        </p>
                        <p>Arc Wano Quốc trong One Piece là cuộc chiến lớn giữa liên minh Luffy và các
                            samurai
                            chống lại Kaido và băng Bách Thú để giải phóng đất nước Wano khỏi chế độ độc tài..</p>
                    </div>
                </div>

                <!-- cái này popup 2-->
                <div class="sach-chi-tiet pop-detail-home2" style="display: none;">
                    <div class="item-top-1">
                        <img src="https://tse2.mm.bing.net/th/id/OIP.9XM2JUuE0llfp0orZz18qwHaLg?rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                    </div>
                    <a href="detail.jsp">
                        <div class="detail-top-1">
                            <h3>Thám tử lừng danh Conan Tập 100</h3>
                            <p>Tác giả: Eiichiro Oda</p>
                            <p>Nhà xuất bản: Shueisha</p>
                            <p id="sale-price">18.000 đ</p>
                            <div class="sale-item">
                                <p><s>40.000 đ</s></p>
                                <div id="sale-percent">-40%</div>
                            </div>
                            <p>Mô tả: Một thiên tài trinh thám tuổi teen Shinichi Kudo bị đầu độc bởi một tổ chức bí
                                ẩn,
                                teo nhỏ
                                thành “cậu bé” Conan Edogawa.
                                Không thể công khai danh tính, cậu sống cùng Ran và “ông bố thám tử” Kogoro Mouri,
                                âm
                                thầm
                                phá án để lần ngược dấu vết Tổ chức Áo Đen và tìm cách trở lại cơ thể cũ.</p>
                            <p>
                                Cùng với tài năng suy luận hơn người của cậu, Conan đã giúp cảnh sát phá nhiều vụ án
                                phức
                                tạp, lật tẩy âm mưu và đưa thủ phạm ra ánh sáng, trở thành huyền thoại trong giới
                                trinh
                                thám.
                            </p>
                        </div>
                    </a>
                </div>
                <!-- cái này popup 3-->
                <div class="sach-chi-tiet pop-detail-home3" style="display: none;">
                    <div class="item-top-1">
                        <img src="https://tse3.mm.bing.net/th/id/OIP.sZz1xnJWZY9rIqEsyGuMfAHaKX?rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                    </div>
                    <div class="detail-top-1">
                        <h3>Dragon Ball Tập 12</h3>
                        <p>Tác giả: Akira Toriyama</p>
                        <p>Nhà xuất bản: Shueisha</p>
                        <p id="sale-price">18.000 đ</p>
                        <div class="sale-item">
                            <p><s>40.000 đ</s></p>
                            <div id="sale-percent">-40%</div>
                        </div>
                        <p>Mô tả:Câu chuyện xoay quanh Son Goku, một cậu bé có sức mạnh phi thường, cùng hành trình
                            tìm kiếm bảy viên ngọc rồng
                            khi tập hợp đủ sẽ triệu hồi rồng thần Shenron để ban điều ước.</p>
                        <p>
                            Truyện kết hợp hành động kịch tính, hài hước duyên dáng, và những trận chiến hoành
                            tráng, đồng thời khai thác tình bạn,
                            lòng dũng cảm và khát vọng vượt lên chính mình.
                        </p>
                    </div>
                </div>
                <!-- cái này popup 4-->
                <div class="sach-chi-tiet pop-detail-home4" style="display: none;">
                    <div class="item-top-1">
                        <img src="https://cdn0.fahasa.com/media/catalog/product/t/r/truyen_tranh_trang_quynh___tap_1_sao_sang_xu_thanh_in_mau_1_2021_05_08_08_11_15.jpg"
                             alt="">
                    </div>
                    <div class="detail-top-1">
                        <h3>Trạng Quỳnh : Ăn xứ xứ Thanh</h3>
                        <p>Tác giả: Kim Khánh:</p>
                        <p>Nhà xuất bản: Shueisha</p>
                        <p id="sale-price">18.000 đ</p>
                        <div class="sale-item">
                            <p><s>40.000 đ</s></p>
                            <div id="sale-percent">-40%</div>
                        </div>

                        <p> Mô tả:
                            Truyện Trạng Quỳnh là một tác phẩm văn học dân gian Việt Nam, xoay quanh nhân vật Nguyễn
                            Quỳnh (1677–1748),
                            một danh sĩ thời Lê Trung Hưng, nổi tiếng với trí thông minh, tính cách trào lộng và
                            những giai thoại hài hước
                            châm biếm vua quan, phản ánh trí tuệ dân gian Việt Nam

                        </p>
                        <p>
                            Câu chuyện trên kể về tình huống ăn sáng của anh chàng Quỳnh và những tình huống hài
                            hước để châm biếm, phản ánh sự bất công trong xã hội phong kiến.
                        </p>
                    </div>
                </div>
                <!-- cái này popup 5-->
                <div class="sach-chi-tiet pop-detail-home5" style="display: none;">
                    <div class="item-top-1">
                        <img src="https://tse1.mm.bing.net/th/id/OIP.9kpsaXsuR1X9igWmZ0jRfgHaL4?rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                    </div>
                    <div class="detail-top-1">
                        <h3>Onepiece : Đảo người cá</h3>
                        <p>Tác giả: Eiichiro Oda</p>
                        <p>Nhà xuất bản: Shueisha</p>
                        <p id="sale-price">18.000 đ</p>
                        <div class="sale-item">
                            <p><s>40.000 đ</s></p>
                            <div id="sale-percent">-40%</div>
                        </div>
                        <p>Mô tả: Câu chuyện xoay quanh Monkey D. Luffy, một chàng trai có khả năng co giãn như cao
                            su sau khi ăn Trái Ác Quỷ Gomu Gomu.</p>
                        <p>
                            Hành trình khám phá đảo người cá cùng những đồng đội của mình trong một hòn đảo nằm dưới
                            sâu trong đại dương cái mặt nước biển 10.000 Km
                        </p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>


<!-- INCLUDE FOOTER -->
<jsp:include page="/fontend/public/Footer.jsp" />

</body>

</html>