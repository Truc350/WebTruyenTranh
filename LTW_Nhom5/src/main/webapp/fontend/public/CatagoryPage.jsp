<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${selectedCategory.nameCategories} - Comic Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/CatagoryPage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>
<jsp:include page="/fontend/public/header.jsp" />

<div class="container-content">

    <div class="container">

        <!-- Bộ lọc giá bên trái -->
        <div id="filter-menu">
            <div class="title-filter">
                <h2>Bộ lọc sản phẩm</h2>
                <button class="btn-loc" onclick="applyFilters()">Lọc</button>
                <button class="btn-reset" onclick="resetFilters()">Đặt lại</button>
            </div>

            <form id="filterForm" method="get" action="${pageContext.request.contextPath}/userCategory">
                <input type="hidden" name="id" value="${selectedCategory.id}">

                <!-- GIÁ -->
                <section>
                    <h3>GIÁ:</h3>
                    <ul>
                        <li>
                            <input type="checkbox" name="price" value="0-15000" id="price1"
                            ${selectedPrices.contains('0-15000') ? 'checked' : ''}>
                            <label for="price1">0đ - 15,000đ</label>
                        </li>
                        <li>
                            <input type="checkbox" name="price" value="15000-30000" id="price2"
                            ${selectedPrices.contains('15000-30000') ? 'checked' : ''}>
                            <label for="price2">15,000đ - 30,000đ</label>
                        </li>
                        <li>
                            <input type="checkbox" name="price" value="30000-50000" id="price3"
                            ${selectedPrices.contains('30000-50000') ? 'checked' : ''}>
                            <label for="price3">30,000đ - 50,000đ</label>
                        </li>
                        <li>
                            <input type="checkbox" name="price" value="50000-70000" id="price4"
                            ${selectedPrices.contains('50000-70000') ? 'checked' : ''}>
                            <label for="price4">50,000đ - 70,000đ</label>
                        </li>
                        <li>
                            <input type="checkbox" name="price" value="70000-100000" id="price5"
                            ${selectedPrices.contains('70000-100000') ? 'checked' : ''}>
                            <label for="price5">70,000đ - 100,000đ</label>
                        </li>
                        <li>
                            <input type="checkbox" name="price" value="100000+" id="price6"
                            ${selectedPrices.contains('100000+') ? 'checked' : ''}>
                            <label for="price6">Trên 100,000đ</label>
                        </li>
                    </ul>
                </section>

                <!-- TÁC GIẢ -->
                <section>
                    <h3>TÁC GIẢ:</h3>
                    <ul>
                        <c:forEach var="author" items="${availableAuthors}" varStatus="status">
                            <li>
                                <input type="checkbox" name="author" value="${author}"
                                       id="author${status.index}"
                                    ${selectedAuthors.contains(author) ? 'checked' : ''}>
                                <label for="author${status.index}">${author}</label>
                            </li>
                        </c:forEach>
                        <c:if test="${empty availableAuthors}">
                            <li style="color: #999; font-style: italic;">Không có tác giả</li>
                        </c:if>
                    </ul>
                </section>

                <!-- NHÀ XUẤT BẢN -->
                <section>
                    <h3>NHÀ XUẤT BẢN:</h3>
                    <ul>
                        <c:forEach var="publisher" items="${availablePublishers}" varStatus="status">
                            <li>
                                <input type="checkbox" name="publisher" value="${publisher}"
                                       id="publisher${status.index}"
                                    ${selectedPublishers.contains(publisher) ? 'checked' : ''}>
                                <label for="publisher${status.index}">${publisher}</label>
                            </li>
                        </c:forEach>
                        <c:if test="${empty availablePublishers}">
                            <li style="color: #999; font-style: italic;">Không có nhà xuất bản</li>
                        </c:if>
                    </ul>
                </section>

                <!-- THỜI GIAN PHÁT HÀNH -->
                <section>
                    <h3>THỜI GIAN PHÁT HÀNH:</h3>
                    <ul>
                        <li>
                            <input type="checkbox" name="year" value="recent" id="time1"
                            ${selectedYears.contains('recent') ? 'checked' : ''}>
                            <label for="time1">Gần đây (năm nay)</label>
                        </li>
                        <li>
                            <input type="checkbox" name="year" value="2024" id="time2"
                            ${selectedYears.contains('2024') ? 'checked' : ''}>
                            <label for="time2">2024</label>
                        </li>
                        <li>
                            <input type="checkbox" name="year" value="2023" id="time3"
                            ${selectedYears.contains('2023') ? 'checked' : ''}>
                            <label for="time3">2023</label>
                        </li>
                        <li>
                            <input type="checkbox" name="year" value="2022" id="time4"
                            ${selectedYears.contains('2022') ? 'checked' : ''}>
                            <label for="time4">2022</label>
                        </li>
                        <li>
                            <input type="checkbox" name="year" value="2021" id="time5"
                            ${selectedYears.contains('2021') ? 'checked' : ''}>
                            <label for="time5">2021</label>
                        </li>
                        <li>
                            <input type="checkbox" name="year" value="2020" id="time6"
                            ${selectedYears.contains('2020') ? 'checked' : ''}>
                            <label for="time6">2020</label>
                        </li>
                        <li>
                            <input type="checkbox" name="year" value="before2020" id="time7"
                            ${selectedYears.contains('before2020') ? 'checked' : ''}>
                            <label for="time7">Trước 2020</label>
                        </li>
                    </ul>
                </section>
            </form>
        </div>

        <script>
            function applyFilters() {
                document.getElementById('filterForm').submit();
            }

            function resetFilters() {
                const checkboxes = document.querySelectorAll('#filterForm input[type="checkbox"]');
                checkboxes.forEach(cb => cb.checked = false);
                document.getElementById('filterForm').submit();
            }
        </script>

        <!-- content bên phải-->
        <div id="items-listing">

            <h1>${selectedCategory.nameCategories}</h1>

            <div id="sum-items">
                <p><strong>Tổng sản phẩm hiển thị:</strong> ${comicList.size()}</p>
            </div>

            <!-- Lưới sản phẩm -->
            <section aria-label="Danh sách sản phẩm ${selectedCategory.nameCategories}">

                <c:choose>
                    <c:when test="${empty comicList}">
                        <div class="no-products">
                            <p>Hiện tại chưa có sản phẩm nào trong thể loại này.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="comic" items="${comicList}">
                            <article>
                                <a href="${pageContext.request.contextPath}/detail?id=${comic.id}">
                                    <div>
                                        <img src="${comic.thumbnailUrl}"
                                             alt="${comic.nameComics}"
                                             onerror="this.src='${pageContext.request.contextPath}/img/no-image.png'">
                                        <div class="detail-book">
                                            <p>${comic.nameComics}
                                                <c:if test="${comic.volume != null}">
                                                    Tập ${comic.volume}
                                                </c:if>
                                            </p>
                                            <p class="product-price">
                                                <fmt:formatNumber value="${comic.price}" pattern="#,###"/>₫
                                            </p>
                                            <c:if test="${comic.stockQuantity > 0}">
                                                <p class="sold">Còn hàng: <strong>${comic.stockQuantity}</strong></p>
                                            </c:if>
                                            <c:if test="${comic.stockQuantity == 0}">
                                                <p class="sold out-of-stock">Hết hàng</p>
                                            </c:if>
                                        </div>
                                    </div>
                                </a>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

            </section>

            <!-- Phân trang (có thể thêm sau) -->
            <!--
            <nav aria-label="Phân trang">
                <ul>
                    <li><a href="#">«</a></li>
                    <li><a href="#" class="active">1</a></li>
                    <li><a href="#">2</a></li>
                    <li><a href="#">3</a></li>
                    <li><a href="#">»</a></li>
                </ul>
            </nav>
            -->

        </div>

    </div>

    <!-- PHẦN GỢI Ý - GIỮ NGUYÊN KHÔNG THAY ĐỔI -->
    <div id="slider">
        <div class="suggest">
            <h2>Gợi ý cho bạn</h2>
        </div>

        <!-- slider 1 -->
        <div class="product-slider">
            <div class="arrow prev">&#10094;</div>
            <div class="slider-track">
                <div class="product-item">
                    <img src="https://tse2.mm.bing.net/th/id/OIP.vD8jLn7dqAK9Wuz_D0iCeAHaLz?rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                    <p class="product-name">Doraemon Tập 23</p>
                    <p class="product-price">₫18,000</p>
                    <p class="sold">Đã bán: <strong>196</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://product.hstatic.net/200000343865/product/1_9544a3ba5bd64806ab59f7fd9fafcf13_ea18ba498dbf48458655f34dd7c049e8_master.jpg" alt="">
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
                    <img src="https://tse1.mm.bing.net/th/id/OIP.WKmbCVIbTS0Oct_J65DYjAHaMT?rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                    <p class="product-name">Doraemon Tập 6</p>
                    <p class="product-price">₫19,000</p>
                    <p class="sold">Đã bán: <strong>96</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://tse2.mm.bing.net/th/id/OIP.EYeZC0QXNbZJ9uKUFqejCQHaMT?w=1083&h=1800&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                    <p class="product-name">Doraemon Tập 3</p>
                    <p class="product-price">₫22,000</p>
                    <p class="sold">Đã bán: <strong>46</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://tse3.mm.bing.net/th/id/OIP.7x-q72jnW1WndxyDjThCZgHaMT?rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
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
            <div class="arrow next">&#10095;</div>
        </div>

        <!-- slider 2 -->
        <div class="product-slider">
            <div class="arrow prev">&#10094;</div>
            <div class="slider-track">
                <div class="product-item">
                    <a href="detail.jsp">
                        <img src="https://tse2.mm.bing.net/th/id/OIP.9XM2JUuE0llfp0orZz18qwHaLg?rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 100</p>
                        <p class="product-price">₫18,000</p>
                        <p class="sold">Đã bán: <strong>196</strong></p>
                    </a>
                </div>
                <div class="product-item">
                    <img src="https://tse1.mm.bing.net/th/id/OIP.P5rFWcOxdjC4jsCK2hMfvwAAAA?w=275&h=431&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                    <p class="product-name">Thám tử lừng danh Conan tập 36</p>
                    <p class="product-price">₫27,000</p>
                    <p class="sold">Đã bán: <strong>108</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://media.vov.vn/sites/default/files/styles/large/public/2021-04/conan_98.jpg" alt="">
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
                    <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                    <p class="product-name">Thám tử lừng danh Conan tập 86</p>
                    <p class="product-price">₫22,000</p>
                    <p class="sold">Đã bán: <strong>99</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://www.detectiveconanworld.com/wiki/images/thumb/7/7d/Volume75v.jpg/225px-Volume75v.jpg" alt="">
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
            <div class="arrow next">&#10095;</div>
        </div>

        <!-- slider 3 -->
        <div class="product-slider">
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
                    <img src="https://i.pinimg.com/originals/3a/a9/47/3aa9473f3ce582ddfcc0cf8cf2a12edf.jpg" alt="">
                    <p class="product-name">Naruto Tâp 208</p>
                    <p class="product-price">₫40,000</p>
                    <p class="sold">Đã bán: <strong>58</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://tse4.mm.bing.net/th/id/OIP.9v3RcOMUqWTRHXD8RwdBqwHaK0?cb=ucfimg2ucfimg=1&w=876&h=1280&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
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
                    <img src="https://tse3.mm.bing.net/th/id/OIP.UYXVfw_z4MzfvIEod7Gh7QAAAA?cb=ucfimg2ucfimg=1&w=400&h=629&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                    <p class="product-name">Naruto Tâp 123</p>
                    <p class="product-price">₫25,000</p>
                    <p class="sold">Đã bán: <strong>76</strong></p>
                </div>
            </div>
            <div class="arrow next">&#10095;</div>
        </div>

        <!-- slider-popup -->
        <div id="product-slider-popup" class="product-slider" style="display: none;">
            <div class="arrow prev">&#10094;</div>
            <div class="slider-track">
                <div class="product-item">
                    <img src="https://m.media-amazon.com/images/I/91IqatXbNGL.jpg" alt="">
                    <p class="product-name">Onepiece Tâp 8</p>
                    <p class="product-price">₫35,000</p>
                    <p class="sold">Đã bán: <strong>103</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://tse2.mm.bing.net/th/id/OIP.sOYHVoZtuhT_wslUk377nAHaLH?w=1498&h=2250&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                    <p class="product-name">Onepiece Tâp 7</p>
                    <p class="product-price">₫40,000</p>
                    <p class="sold">Đã bán: <strong>138</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://th.bing.com/th/id/OIP.Rv6Zq3gzBUg7PZIoSibkuAAAAA?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                    <p class="product-name">Onepiece Tâp 75</p>
                    <p class="product-price">₫39,000</p>
                    <p class="sold">Đã bán: <strong>109</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://tse4.mm.bing.net/th/id/OIP.mk3uhKbGlMl1FGnF8lhUlAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
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
            <div class="arrow next">&#10095;</div>
        </div>

        <div id="more-btn-popup-slider" class="more-btn">
            <button>Xem thêm</button>
        </div>
    </div>

</div>

<!-- INCLUDE FOOTER -->
<jsp:include page="/fontend/public/Footer.jsp" />

<style>
    /* Style bổ sung cho trạng thái hết hàng */
    .out-of-stock {
        color: #d32f2f !important;
        font-weight: bold;
    }

    /* Style cho hình ảnh khi load lỗi */
    section[aria-label] article img {
        background-color: #f5f5f5;
    }
</style>

<script>
    //slider
    function initSlider(slider) {
        const track = slider.querySelector('.slider-track');
        const prevBtn = slider.querySelector('.arrow.prev');
        const nextBtn = slider.querySelector('.arrow.next');
        const items = slider.querySelectorAll('.product-item');

        let currentPosition = 0;

        function recalc() {
            const itemWidth = items[0].offsetWidth + 10; // gap
            const totalItems = items.length;
            const trackWidth = totalItems * itemWidth;
            const containerWidth = slider.offsetWidth;
            const maxPosition = containerWidth - trackWidth;
            return { itemWidth, maxPosition };
        }

        prevBtn.addEventListener('click', () => {
            const { itemWidth } = recalc();
            if (currentPosition < 0) {
                currentPosition += itemWidth;
                if (currentPosition > 0) currentPosition = 0;
                track.style.transform = `translateX(${currentPosition}px)`;
            }
        });

        nextBtn.addEventListener('click', () => {
            const { itemWidth, maxPosition } = recalc();
            if (currentPosition > maxPosition) {
                currentPosition -= itemWidth;
                if (currentPosition < maxPosition) currentPosition = maxPosition;
                track.style.transform = `translateX(${currentPosition}px)`;
            }
        });
    }

    // Khi popup mở thì gọi lại initSlider
    document.querySelectorAll('.product-slider').forEach(initSlider);

    document.getElementById("more-btn-popup-slider").addEventListener("click", function () {
        document.querySelector("#product-slider-popup").style.display = "block";
    });
</script>

</body>
</html>