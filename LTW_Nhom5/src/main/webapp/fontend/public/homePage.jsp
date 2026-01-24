<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="vn.edu.hcmuaf.fit.ltw_nhom5.model.Banner" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<jsp:include page="/fontend/public/header.jsp"/>

<c:if test="${not empty sessionScope.successMessage}">
    <script type="text/javascript">
        window.onload = function() {
            alert("${sessionScope.successMessage}");
        };
    </script>

    <%-- Xóa ngay để không hiện lại khi refresh --%>
    <c:remove var="successMessage" scope="session" />
</c:if>


<%--thông báo khi vô trang admin--%>
<%
    String msg = (String) session.getAttribute("errorMessage");
    if (msg != null) {
%>
<script type="text/javascript">
    window.onload = function() {
        alert("<%= msg %>");
    };
</script>
<%
        session.removeAttribute("errorMessage");
    }
%>



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
                <% }
                } %>
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
            <a href="${pageContext.request.contextPath}/flash-sale">
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
                <h2>
                    <c:choose>
                        <c:when test="${isLoggedIn}">
                            <i class="fa-solid fa-star"></i> Dành riêng cho bạn
                        </c:when>
                        <c:otherwise>
                            Gợi ý cho bạn
                        </c:otherwise>
                    </c:choose>
                </h2>
            </div>

            <%-- Hiển thị comics gợi ý --%>
            <c:if test="${not empty recommendedComics}">
                <%-- Chia thành các slider 8 items/slider --%>
                <c:forEach var="i" begin="0" end="${(recommendedComics.size() - 1) / 8}" step="1">
                    <div class="product-slider">
                        <div class="arrow prev">&#10094;</div>
                        <div class="slider-track">
                            <c:forEach var="comic" items="${recommendedComics}"
                                       begin="${i * 8}"
                                       end="${i * 8 + 7}">
                                <div class="product-item">
                                    <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}">
                                        <img src="${comic.thumbnailUrl}"
                                             alt="${comic.nameComics}"
                                             onerror="this.src='${pageContext.request.contextPath}/img/no-image.jpg'">
                                        <p class="product-name">${comic.nameComics}</p>
                                    </a>

                                    <c:choose>
                                        <c:when test="${comic.hasDiscount()}">
                                            <p class="product-price">
                                                <fmt:formatNumber value="${comic.discountPrice}"
                                                                  pattern="#,###"/>₫
                                            </p>
                                            <p class="original-price">
                                                <s><fmt:formatNumber value="${comic.price}"
                                                                     pattern="#,###"/>₫</s>
                                                <span class="discount-badge">
                                                    -<fmt:formatNumber value="${comic.discountPercent}"
                                                                       pattern="#"/>%
                                                </span>
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="product-price">
                                                <fmt:formatNumber value="${comic.price}"
                                                                  pattern="#,###"/> đ
                                            </p>
                                        </c:otherwise>
                                    </c:choose>

                                        <%--                                    <c:if test="${comic.totalSold > 0}">--%>
                                        <%--                                        <p class="sold">Đã bán: <strong>${comic.totalSold}</strong></p>--%>
                                        <%--                                    </c:if>--%>
                                    <p class="sold">Đã bán: <strong>${comic.totalSold}</strong></p>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="arrow next">&#10095;</div>
                    </div>
                </c:forEach>
            </c:if>

            <c:if test="${empty recommendedComics}">
                <div class="no-products">
                    <p>Chưa có sản phẩm gợi ý</p>
                </div>
            </c:if>
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
<jsp:include page="/fontend/public/Footer.jsp"/>

</body>

</html>