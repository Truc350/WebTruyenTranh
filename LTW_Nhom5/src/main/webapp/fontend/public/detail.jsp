<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/ReivewOfCus.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/SuggesstItem.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<jsp:include page="/fontend/public/header.jsp"/>

<!-- phần này là body chính cửa trang -->
<div class="container-body">

    <div class="content-left">
        <div class="cont-left-body">

            <div id="img-container" class="img-container">
                <img id="img" src="${comic.thumbnailUrl}" alt="${comic.nameComics}">
            </div>

            <!-- popup cái ảnh dưới -->
            <c:forEach var="image" items="${images}" varStatus="status">
                <div id="img-popup-${status.index}" class="img-container" style="display: none;">
                    <img class="img-small-popup" src="${image.imageUrl}" alt="${comic.nameComics}">
                </div>
            </c:forEach>

            <div class="warehouse-img">
                <!-- Thêm ảnh thumbnail đầu tiên -->
                <img class="img-small" data-img-index="-1" src="${comic.thumbnailUrl}" alt="${comic.nameComics}">
                <!-- Các ảnh còn lại từ images -->
                <c:forEach var="image" items="${images}" varStatus="status">
                    <img class="img-small" data-img-index="${status.index}"
                         src="${image.imageUrl}" alt="">
                </c:forEach>
            </div>


            <div class="actions-btn">
                <button class="btn add-to-cart">Thêm vào giỏ hàng</button>
                <button class="btn buy-now">Mua ngay</button>

                <label class="heart-toggle">
                    <input type="checkbox" hidden>
                    <i class="fa-regular fa-heart"></i>
                    <i class="fa-solid fa-heart"></i>
                    <p>Like</p>
                </label>

            </div>
        </div>
    </div>

    <div class="all-content">
        <div class="content">
            <h2>${comic.nameComics}
            </h2>
            <div class="information">
                <div class="line1">
                    <c:if test="${not empty comic.publisher}">
                        <p>Nhà xuất bản:<strong> ${comic.publisher}</strong></p>
                    </c:if>
                </div>
                <div class="line2">
                    <c:if test="${not empty comic.author}">
                        <p>Tác giả:<strong> ${comic.author}</strong></p>
                    </c:if>
                </div>
            </div>

            <p class="daban">Đã bán ${comic.totalSold}</p>

            <div class="line3">
                <div class="star">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                </div>
                <%--                <p class="daban">Đã bán 196</p>--%>
            </div>
            <div class="line4">
                <fmt:formatNumber value="${comic.discountPrice}" type="number" groupingUsed="true"
                                  var="discountPriceFormatted"/>
                <fmt:formatNumber value="${comic.price}" type="number" groupingUsed="true" var="priceFormatted"/>

                <p id="giamdagiam">${discountPriceFormatted} đ</p>

                <c:if test="${comic.discountPrice lt comic.price}">
                    <p id="giagoc">${priceFormatted} đ</p>
                </c:if>

            </div>

            <div class="line5">
                <p>Chính sách khuyến mãi trên chỉ áp dụng tại Comic Store</p>
            </div>
            <div class="line6">
                <c:choose>
                    <c:when test="${comic.stockQuantity == 0}">
                        <p><em style="color: red;">Hết hàng</em></p>
                    </c:when>
                    <c:when test="${comic.stockQuantity > 0 and comic.stockQuantity < 10}">
                        <p><em>Sản phẩm gần hết hàng (còn ${comic.stockQuantity})</em></p>
                    </c:when>
                    <c:otherwise>
                        <p><em>Còn hàng</em></p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="container2">
            <div class="voucherbutton">
                <p>Số lượng: </p>
                <div class="quantity-control">
                    <button id="btn-minus"><i class="fas fa-minus" id="btn-vol"></i></button>
                    <input type="number" id="quantity" value="1" min="1" />
                    <button id="btn-plus"><i class="fas fa-plus" id="btn-vol"></i></button>
                </div>
            </div>

            <c:if test="${not empty seriesName}">
                <div style="display: flex; align-items: center; gap: 8px; font-family: sans-serif;">
                    <div style="background-color: #007bff; color: white; padding: 2px 6px; border-radius: 4px; font-size: 12px;">
                        Bộ
                    </div>
                    <div style="font-size: 18px; font-weight: bold;">
                            ${seriesName}
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty comic.description}">
                <div class="comic-description">
                    <h3>Mô tả</h3>
                    <p>${comic.description}</p>
                </div>
            </c:if>
        </div>


        <div class="container3">
            <section class="related-products">
                <h2>Sản phẩm tương tự</h2>
                <div class="product-grid">
                    <c:forEach var="relatedComic" items="${relatedComics}">
                        <div class="product-card">
                            <a href="${pageContext.request.contextPath}/comic-detail?id=${relatedComic.id}">
                                <img src="${relatedComic.thumbnailUrl}" alt="${relatedComic.nameComics}">
                                <h3>${relatedComic.nameComics}</h3>
                                <fmt:formatNumber value="${relatedComic.discountPrice}" type="number"
                                                  groupingUsed="true" var="price"/>
                                <p class="price">${price} đ</p>
                                <p class="sold">Đã bán: <strong>${relatedComic.totalSold}</strong></p>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </div>

        <div class="container4">
            <section class="product-details" style="display: none;">
                <h2>Thông tin chi tiết</h2>
                <div class="detail-table">
                    <div class="detail-left">
                        <span class="label">Công ty phát hành:</span>
                        <span class="label">Ngày xuất bản:</span>
                        <span class="label">Kích thước:</span>
                        <span class="label">Loại bìa:</span>
                        <span class="label">Số trang:</span>
                        <span class="label">Nhà xuất bản:</span>
                    </div>
                    <section class="product-details">
                        <h2>Thông tin chi tiết</h2>
                        <div class="detail-table">
                            <div class="detail-left">
                                <span class="label">Công ty phát hành:</span>
                                <span class="label">Ngày xuất bản:</span>
                                <span class="label">Kích thước:</span>
                                <span class="label">Loại bìa:</span>
                                <span class="label">Số trang:</span>
                                <span class="label">Nhà xuất bản:</span>
                            </div>

                            <div class="detail-right">
                                <span class="value">NXB Trẻ</span>
                                <span class="value">2020-05-22 11:17:19</span>
                                <span class="value">15.5×23cm</span>
                                <span class="value">Bìa cứng</span>
                                <span class="value">184</span>
                                <span class="value">NXB Trẻ</span>
                            </div>
                        </div>
                    </section>

                    <section class="des-tiem">
                        <h2>Mô tả sản phẩm</h2>
                        <div class="des-review">
                            <p>
                                Một thiên tài trinh thám tuổi teen Shinichi Kudo bị đầu độc bởi một tổ chức bí ẩn, teo
                                nhỏ
                                thành “cậu bé” Conan Edogawa.
                                Không thể công khai danh tính, cậu sống cùng Ran và “ông bố thám tử” Kogoro Mouri, âm
                                thầm
                                phá án để lần ngược dấu vết Tổ chức Áo Đen và tìm cách trở lại cơ thể cũ.
                            </p>
                            <p>
                                Cùng với tài năng suy luận hơn người của cậu, Conan đã giúp cảnh sát phá nhiều vụ án
                                phức
                                tạp, lật tẩy âm mưu và đưa thủ phạm ra ánh sáng, trở thành huyền thoại trong giới trinh
                                thám.
                            </p>
                        </div>
                    </section>

                </div>
            </section>

        </div>
    </div>
</div>


<!-- phàn này đánh giá -->
<div class="rating-container">
    <!-- Cột trái -->
    <div class="rating-left">
        <h3>Đánh giá sản phẩm</h3>

        <div class="rating-score">
            <div class="score-number">
                <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/><span>/5</span>
            </div>
            <div class="score-stars">
                <c:set var="fullStars"
                       value="${avgRating >= 1 ? (avgRating >= 2 ? (avgRating >= 3 ? (avgRating >= 4 ? (avgRating >= 5 ? 5 : 4) : 3) : 2) : 1) : 0}"/>

                <c:forEach begin="1" end="${fullStars}">★</c:forEach>

                <c:set var="hasHalfStar" value="${avgRating - fullStars >= 0.5}"/>
                <c:if test="${hasHalfStar}">★</c:if>

                <c:set var="emptyStars" value="${5 - fullStars - (hasHalfStar ? 1 : 0)}"/>
                <c:forEach begin="1" end="${emptyStars}">☆</c:forEach>
            </div>
            <div class="score-count">(${not empty reviews ? reviews.size() : 0} đánh giá)</div>
        </div>

        <div class="rating-bars">
            <div class="bar-row">
                <span>5 sao</span>
                <div class="bar">
                    <div class="fill" style="width:100%"></div>
                </div>
                <span>100%</span>
            </div>

            <div class="bar-row">
                <span>4 sao</span>
                <div class="bar">
                    <div class="fill" style="width:0%"></div>
                </div>
                <span>0%</span>
            </div>

            <div class="bar-row">
                <span>3 sao</span>
                <div class="bar">
                    <div class="fill" style="width:0%"></div>
                </div>
                <span>0%</span>
            </div>

            <div class="bar-row">
                <span>2 sao</span>
                <div class="bar">
                    <div class="fill" style="width:0%"></div>
                </div>
                <span>0%</span>
            </div>

            <div class="bar-row">
                <span>1 sao</span>
                <div class="bar">
                    <div class="fill" style="width:0%"></div>
                </div>
                <span>0%</span>
            </div>
        </div>
    </div>

    <!-- Cột phải -->
    <!-- <div class="rating-right">
        <button class="write-btn">✎ Viết đánh giá</button>
    </div> -->

</div>

<!-- lời comment -->
<div class="comment">

    <!-- <div class="review-tabs">
        <label class="tab1 active">Tất cả đánh giá</label>
        <label class="tab2 active">Mới nhất</label>
    </div> -->

    <div class="review-tabs">
        <label id="tab1" class="tab active">Tất cả đánh giá</label>
        <!-- <label id="tab2" class="tab">Mới nhất</label> -->
    </div>

    <div id="reviewed-person" class="reviewed-person">
        <c:choose>
            <c:when test="${empty reviews}">
                <p>Chưa có đánh giá nào.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${reviews}">
                    <div class="review-item">
                        <div class="review-left">
                            <div class="avatar">
                                    ${fn:substring(review.username, 0, 2).toUpperCase()}
                            </div>
                            <div class="review-date">${review.username}</div>
                            <div class="review-date">
                                <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>

                        <div class="review-right">
                            <div class="review-stars">
                                <c:forEach begin="1" end="${review.rating}">★</c:forEach>
                                <c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                            </div>

                            <p class="review-text">${review.comment}</p>

                            <div class="review-actions">
                                <i class="fa-regular fa-heart"></i>
                                <span class="action">Thích (0)</span>
                                <i class="fa-solid fa-reply"></i>
                                <span class="action"> Trả lời</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </div>

    <div id="reviewed-person-popup" class="reviewed-person-popup" style="display: none;">
        <div class="review-item">
            <div class="review-left">
                <div class="avatar">HĐz</div>
                <div class="review-date">Hưng Đoàn</div>
                <div class="review-date">19/08/2020</div>
            </div>

            <div class="review-right">
                <div class="review-stars">★★★★★</div>

                <p class="review-text">
                    Quả như mong đợi của mình, cuốn này không những hay mà còn hấp dẫn , khuyên mọi người nên mua để
                    đọc
                    thử, cuốn như bánh cuốn luôn ý.
                    Tác giả còn bonus thêm quả boom cuối truyện như phim boom tấn ý mà tiết là nó tịt ngòi kkk.
                </p>

                <div class="review-actions">
                    <i class="fa-regular fa-heart"></i>
                    <span class="action">Thích (19)</span>
                    <i class="fa-solid fa-reply"></i>
                    <span class="action"> Trả lời</span>
                </div>
            </div>
        </div>

        <div class="review-item">
            <div class="review-left">
                <div class="avatar">HĐz</div>
                <div class="review-date">Bé heo</div>
                <div class="review-date">19/08/2020</div>
            </div>

            <div class="review-right">
                <div class="review-stars">★★★★★</div>

                <p class="review-text">
                    Sách rất hay, nội dung hấp dẫn và in ấn chất lượng cao. Đóng gói cẩn thận, giao hàng nhanh. Rất
                    hài
                    lòng với lần mua này!
                </p>

                <div class="review-actions">
                    <i id="heart" class="fa-regular fa-heart"></i>
                    <span class="action">Thích (9)</span>
                    <i class="fa-solid fa-reply"></i>
                    <span class="action"> Trả lời</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- phần này gợi ý cho bạn -->
<div class="container-slider">
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
                    <a href="detail.html">
                        <img src="https://tse2.mm.bing.net/th/id/OIP.9XM2JUuE0llfp0orZz18qwHaLg?rs=1&pid=ImgDetMain&o=7&rm=3"
                             alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 100</p>
                        <p class="product-price">₫18,000</p>
                        <p class="sold">Đã bán: <strong>196</strong></p>
                    </a>
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
                    <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3"
                         alt="">
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
                    <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3"
                         alt="">
                    <p class="product-name">Thám tử lừng danh Conan tập 75</p>
                    <p class="product-price">₫19,000</p>
                    <p class="sold">Đã bán: <strong>82</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3"
                         alt="">
                    <p class="product-name">Thám tử lừng danh Conan tập 72</p>
                    <p class="product-price">₫21,000</p>
                    <p class="sold">Đã bán: <strong>36</strong></p>
                </div>
                <div class="product-item">
                    <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3"
                         alt="">
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
                    <img src="https://i.pinimg.com/originals/3a/a9/47/3aa9473f3ce582ddfcc0cf8cf2a12edf.jpg" alt="">
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
        <div id="product-slider-popup" class="product-slider" style="display: none;">

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

</div>


<!-- INCLUDE FOOTER -->
<jsp:include page="/fontend/public/Footer.jsp"/>


<script>

    // lấy ảnh để hien thi
    const mainImg = document.getElementById("img");
    const imgSmalls = document.querySelectorAll(".img-small");

    imgSmalls.forEach((imgSmall) => {
        imgSmall.addEventListener("click", () => {
            const imgIndex = imgSmall.getAttribute("data-img-index");
            console.log("Clicked img-index:", imgIndex);
            const newSrc = imgSmall.getAttribute("src");
            mainImg.src = newSrc;

            console.log("Changed to:", newSrc);

            // Ẩn tất cả container
            document.querySelectorAll(".img-container").forEach(container => {
                container.style.display = "none";
            });

            if (imgIndex === "-1") {
                const mainContainer = document.getElementById("img-container");
                if (mainContainer) {
                    mainContainer.style.display = "block";
                    mainContainer.style.visibility = "visible"; // Thêm dòng này
                }
            } else {
                const mainContainer = document.getElementById("img-container");
                if (mainContainer) {
                    mainContainer.style.display = "block";
                    mainContainer.style.visibility = "visible"; // Thêm dòng này
                }
            }
        });
    });


    // slider
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
            return {itemWidth, maxPosition};
        }

        prevBtn.addEventListener('click', () => {
            const {itemWidth} = recalc();
            if (currentPosition < 0) {
                currentPosition += itemWidth;
                if (currentPosition > 0) currentPosition = 0;
                track.style.transform = `translateX(${currentPosition}px)`;
            }
        });

        nextBtn.addEventListener('click', () => {
            const {itemWidth, maxPosition} = recalc();
            if (currentPosition > maxPosition) {
                currentPosition -= itemWidth;
                if (currentPosition < maxPosition) currentPosition = maxPosition;
                track.style.transform = `translateX(${currentPosition}px)`;
            }
        });
    }

    // Khi popup mở thì gọi lại initSlider
    document.querySelectorAll('.product-slider').forEach(initSlider);

    // cái này cho trái tim đổi màu
    const heart = document.getElementById("heart");
    if (heart) {  // ← Kiểm tra null
        heart.addEventListener('click', () => {
            heart.classList.toggle("fa-regular");
            heart.classList.toggle("fa-solid");
        });
    }


    //cái này review chuyển đổi
    document.querySelectorAll(".review-tabs .tab").forEach(tab => {
        tab.addEventListener("click", function () {
            // bỏ active ở tất cả tab
            document.querySelectorAll(".review-tabs .tab").forEach(t => t.classList.remove("active"));
            // thêm active cho tab được click
            this.classList.add("active");
        });
    });


    //cái này reviewed
    const tab2 = document.getElementById("tab2");
    if (tab2) {
        tab2.addEventListener("click", function (event) {
            event.preventDefault();
            document.querySelector(".reviewed-person").style.display = "none";
            document.querySelector(".reviewed-person-popup").style.display = "block";
        });
    }
    const tab1 = document.getElementById("tab1");
    if (tab1) {
        tab1.addEventListener("click", function (event) {
            event.preventDefault();
            document.querySelector(".reviewed-person").style.display = "block";
            document.querySelector(".reviewed-person-popup").style.display = "none";
        });
    }

    const moreBtn = document.getElementById("more-btn-popup-slider");
    if (moreBtn) {
        moreBtn.addEventListener("click", function () {
            document.querySelector("#product-slider-popup").style.display = "block";
        });
    }


    // cái này tăng giảm số lượng
        const minusBtn = document.getElementById("btn-minus");
        const plusBtn = document.getElementById("btn-plus");
        const quantityInput = document.getElementById("quantity");

        plusBtn.addEventListener("click", () => {
        quantityInput.value = parseInt(quantityInput.value) + 1;
    });

        minusBtn.addEventListener("click", () => {
        if (parseInt(quantityInput.value) > 1) {
        quantityInput.value = parseInt(quantityInput.value) - 1;
    }
    });

        // Nếu muốn kiểm soát khi người dùng nhập tay
        quantityInput.addEventListener("input", () => {
        if (quantityInput.value < 1) {
        quantityInput.value = 1;
    }
    });

</script>


</body>

</html>