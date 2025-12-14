<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
<%--    <link rel="stylesheet" href="../css/publicCss/nav.css">--%>
<%--    <link rel="stylesheet" href="../css/publicCss/ReivewOfCus.css">--%>
<%--    <link rel="stylesheet" href="../css/publicCss/SuggesstItem.css">--%>
<%--    <link rel="stylesheet" href="../css/publicCss/FooterStyle.css">--%>
<%--    <link rel="stylesheet" href="../css/publicCss/detail.css">--%>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/ReivewOfCus.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/SuggesstItem.css">
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

    <!-- phần này là body chính cửa trang -->
    <div class="container-body">

        <div class="content-left">
            <div class="cont-left-body">

                <div id="img-container" class="img-container">
                    <img id="img" src="../../img/conan100.jpg" alt="">
                </div>

                <!-- popup cái ảnh dưới -->
                <div id="img-container-popup1" class="img-container" style="display: none;">
                    <img class="img-small-popup"
                        src="https://cdn1.fahasa.com/media/flashmagazine/images/page_images/___detective_conan_106/2024_12_02_16_16_34_2-390x510.jpg?_gl=1*192eztq*_ga*MzU5OTg1MjE5LjE3NjE3MjA4MDg.*_ga_D3YYPWQ9LN*czE3NjI5MzY0NDAkbzE1JGcxJHQxNzYyOTM2NTY2JGo2MCRsMCRoMA..*_gcl_au*MTM1MzE1NjYzNi4xNzYxNzIwODA4*_ga_460L9JMC2G*czE3NjI5MzY0MzMkbzE2JGcxJHQxNzYyOTM2NTY2JGo0OSRsMCRoOTUyODE0MzQy"
                        alt="">
                </div>
                <div id="img-container-popup2" class="img-container" style="display: none;">
                    <img class="img-small-popup"
                        src="https://cdn1.fahasa.com/media/flashmagazine/images/page_images/___detective_conan_106/2024_12_02_16_16_34_3-390x510.jpg"
                        alt="">
                </div>
                <div id="img-container-popup3" class="img-container" style="display: none;">
                    <img class="img-small-popup"
                        src="https://cdn1.fahasa.com/media/flashmagazine/images/page_images/_104__detective_conan_104/2023_12_13_16_37_44_3-390x510.jpg?_gl=1*ey826x*_ga*MzU5OTg1MjE5LjE3NjE3MjA4MDg.*_ga_D3YYPWQ9LN*czE3NjI5NTQxNDYkbzE4JGcxJHQxNzYyOTU0MTYyJGo0NCRsMCRoMA..*_gcl_au*MTM1MzE1NjYzNi4xNzYxNzIwODA4*_ga_460L9JMC2G*czE3NjI5NTQxNDYkbzE5JGcxJHQxNzYyOTU0MTYzJGo0MyRsMCRoOTM4MTE4NDA."
                        alt="">
                </div>



                <div class="warehouse-img">
                    <img id="img-small1" class="img-small"
                        src="https://tse2.mm.bing.net/th/id/OIP.9XM2JUuE0llfp0orZz18qwHaLg?rs=1&pid=ImgDetMain&o=7&rm=3"
                        alt="">
                    <img id="img-small2" class="img-small"
                        src="https://cdn1.fahasa.com/media/flashmagazine/images/page_images/___detective_conan_106/2024_12_02_16_16_34_2-390x510.jpg?_gl=1*192eztq*_ga*MzU5OTg1MjE5LjE3NjE3MjA4MDg.*_ga_D3YYPWQ9LN*czE3NjI5MzY0NDAkbzE1JGcxJHQxNzYyOTM2NTY2JGo2MCRsMCRoMA..*_gcl_au*MTM1MzE1NjYzNi4xNzYxNzIwODA4*_ga_460L9JMC2G*czE3NjI5MzY0MzMkbzE2JGcxJHQxNzYyOTM2NTY2JGo0OSRsMCRoOTUyODE0MzQy"
                        alt="">
                    <img id="img-small3" class="img-small"
                        src="https://cdn1.fahasa.com/media/flashmagazine/images/page_images/___detective_conan_106/2024_12_02_16_16_34_3-390x510.jpg"
                        alt="">
                    <img id="img-small4" class="img-small"
                        src="https://cdn1.fahasa.com/media/flashmagazine/images/page_images/_104__detective_conan_104/2023_12_13_16_37_44_3-390x510.jpg?_gl=1*ey826x*_ga*MzU5OTg1MjE5LjE3NjE3MjA4MDg.*_ga_D3YYPWQ9LN*czE3NjI5NTQxNDYkbzE4JGcxJHQxNzYyOTU0MTYyJGo0NCRsMCRoMA..*_gcl_au*MTM1MzE1NjYzNi4xNzYxNzIwODA4*_ga_460L9JMC2G*czE3NjI5NTQxNDYkbzE5JGcxJHQxNzYyOTU0MTYzJGo0MyRsMCRoOTM4MTE4NDA."
                        alt="">
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
                <h2>Thám tử lừng danh <span>Tập 100</span></h2>
                <div class="information">
                    <div class="line1">
                        <!-- <p>Người dịch:<strong> Hương Giang</strong></p> -->
                        <p>Nhà xuất bản:<strong> NXB Kim Đồng</strong></p>
                    </div>
                    <div class="line2">
                        <p>Tác giả:<strong> Gosho Aoyama</strong></p>
                        <!-- <p>Hình thức bìa:<strong> Bìa Cứng</strong></p> -->
                    </div>
                </div>
                <div class="line3">
                    <div class="star">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <p class="daban">Đã bán 196</p>
                </div>
                <div class="line4">
                    <p id="giamdagiam">18.000 đ</p>
                    <p id="giagoc">30.000 đ</p>
                    <p id="khuyenmai">-40%</p>
                </div>

                <div class="line5">
                    <p>Chính sách khuyến mãi trên chỉ áp dụng tại Comic Store</p>
                </div>
                <div class="line6">
                    <p><em>Sản phẩm gần hết hàng</em></p>
                </div>
            </div>
            <div class="container2">
                <div class="voucherbutton">
                    <p>Số lượng: </p>
                    <div class="quantity-control">
                        <button><i class="fas fa-minus" id="btn-vol"></i></button>
                        <span>1</span>
                        <button><i class="fas fa-plus" id="btn-vol"></i></button>
                    </div>
                </div>

                <div style="display: flex; align-items: center; gap: 8px; font-family: sans-serif;">
                    <div style="background-color: #007bff; color: white; padding: 2px 6px; border-radius: 4px; font-size: 12px;">
                        Bộ
                    </div>
                    <div style="font-size: 18px; font-weight: bold;">
                        Thám tử lừng danh Connan
                    </div>
                </div>

            </div>


            <div class="container3">
                <section class="related-products">
                    <h2>Sản phẩm tương tự</h2>
                    <div class="product-grid">

                        <div class="product-card">
                            <img src="https://tse2.mm.bing.net/th/id/OIP.Q_HBIf5co74JHpujqEEbowHaL3?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3"
                                alt="">
                            <h3>Connan tập 101</h3>
                            <p class="price">₫36.760</p>
                            <p class="sold">Đã bán: <strong>142</strong></p>
                            <!-- <div class="stars">★★★★★</div> -->
                        </div>
                        <div class="product-card">
                            <img src="https://tse3.mm.bing.net/th/id/OIP.eoE_6ogm0Md54J7nZyB0VQAAAA?rs=1&pid=ImgDetMain&o=7&rm=3"
                                alt="Sách Tay Không Bóc Hành">
                            <h3>Conan tập 59</h3>
                            <p class="price">₫37.950</p>
                            <p class="sold">Đã bán: <strong>72</strong></p>
                            <!-- <div class="stars">★★★★☆</div> -->
                        </div>
                        <div class="product-card">
                            <img src="https://www.detectiveconanworld.com/wiki/images/thumb/a/ab/Volume_30.jpg/275px-Volume_30.jpg"
                                alt="Những Quy Luật Bản Chất Con Người">
                            <h3>Conan tập 30</h3>
                            <p class="price">₫37.359</p>
                            <p class="sold">Đã bán: <strong>63</strong></p>
                            <!-- <div class="stars">★★★★★</div> -->
                        </div>
                        <div class="product-card">
                            <img src="https://m.media-amazon.com/images/I/51XmJpvigQL.jpg"
                                alt="Những Quy Luật Bản Chất Con Người">
                            <h3>Conan tập 35</h3>
                            <p class="price">₫33.359</p>
                            <p class="sold">Đã bán: <strong>52</strong></p>
                            <!-- <div class="stars">★★★★★</div> -->
                        </div>
                        <div class="product-card">
                            <img src="https://www.detectiveconanworld.com/wiki/images/thumb/0/04/Volume22v.jpg/225px-Volume22v.jpg"
                                alt="">
                            <h3>Conan tập 22</h3>
                            <p class="price">₫35.359</p>
                            <p class="sold">Đã bán: <strong>120</strong></p>
                            <!-- <div class="stars">★★★★★</div> -->
                        </div>
                        <div class="product-card">
                            <img src="https://www.detectiveconanworld.com/wiki/images/0/08/Volume78v.jpg" alt="">
                            <h3>Conan tập 78</h3>
                            <p class="price">35.359</p>
                            <!-- <div class="stars">★★★★★</div> -->
                            <p class="sold">Đã bán: <strong>172</strong></p>
                        </div>
                        <div class="product-card">
                            <img src="https://www.detectiveconanworld.com/wiki/images/a/aa/Volume28v.jpg" alt="">
                            <h3>Conan tập 285</h3>
                            <p class="price">₫35.359</p>
                            <p class="sold">Đã bán: <strong>82</strong></p>
                            <!-- <div class="stars">★★★★★</div> -->
                        </div>
                        <div class="product-card">
                            <img src="https://www.detectiveconanworld.com/wiki/images/e/e1/Volume21v.jpg" alt="">
                            <h3>Conan tập 21</h3>
                            <p class="price">₫35.359</p>
                            <p class="sold">Đã bán: <strong>96</strong></p>
                        </div>
                        <div class="product-card">
                            <img src="https://newshop.vn/public/uploads/products/29224/sach-tham-tu-lung-danh-conan-tap-97.jpg"
                                alt="">
                            <h3>Conan tập 97</h3>
                            <p class="price">₫35.359</p>
                            <p class="sold">Đã bán: <strong>99</strong></p>
                            <!-- <div class="stars">★★★★★</div> -->
                        </div>

                    </div>
                </section>
            </div>

            <div class="container4">
<%--                <section class="product-details">--%>
<%--                    <h2>Thông tin chi tiết</h2>--%>
<%--                    <div class="detail-table">--%>
<%--                        <div class="detail-left">--%>
<%--                            <span class="label">Công ty phát hành:</span>--%>
<%--                            <span class="label">Ngày xuất bản:</span>--%>
<%--                            <span class="label">Kích thước:</span>--%>
<%--                            <span class="label">Loại bìa:</span>--%>
<%--                            <span class="label">Số trang:</span>--%>
<%--                            <span class="label">Nhà xuất bản:</span>--%>
<%--                        </div>--%>

<%--                        <div class="detail-right">--%>
<%--                            <span class="value">NXB Trẻ</span>--%>
<%--                            <span class="value">2020-05-22 11:17:19</span>--%>
<%--                            <span class="value">15.5×23cm</span>--%>
<%--                            <span class="value">Bìa cứng</span>--%>
<%--                            <span class="value">184</span>--%>
<%--                            <span class="value">NXB Trẻ</span>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </section>--%>

                <section class="des-tiem">
                    <h2>Mô tả sản phẩm</h2>
                    <div class="des-review">
                        <p>
                            Một thiên tài trinh thám tuổi teen Shinichi Kudo bị đầu độc bởi một tổ chức bí ẩn, teo nhỏ
                            thành “cậu bé” Conan Edogawa.
                            Không thể công khai danh tính, cậu sống cùng Ran và “ông bố thám tử” Kogoro Mouri, âm thầm
                            phá án để lần ngược dấu vết Tổ chức Áo Đen và tìm cách trở lại cơ thể cũ.
                        </p>
                        <p>
                            Cùng với tài năng suy luận hơn người của cậu, Conan đã giúp cảnh sát phá nhiều vụ án phức
                            tạp, lật tẩy âm mưu và đưa thủ phạm ra ánh sáng, trở thành huyền thoại trong giới trinh
                            thám.
                        </p>
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
                <div class="score-number">5<span>/5</span></div>
                <div class="score-stars">★★★★★</div>
                <div class="score-count">(3 đánh giá)</div>
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
            <label id="tab2" class="tab">Mới nhất</label>
        </div>

        <div id="reviewed-person" class="reviewed-person">
            <div class="review-item">
                <div class="review-left">
                    <div class="avatar">HĐz</div>
                    <div class="review-date">Hưng Đoàn</div>
                    <div class="review-date">19/01/2020</div>
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

            <div class="review-item">
                <div class="review-left">
                    <div class="avatar">HĐz</div>
                    <div class="review-date">Bé Gà</div>
                    <div class="review-date">19/08/2020</div>
                </div>

                <div class="review-right">
                    <div class="review-stars">★★★★★</div>

                    <p class="review-text">
                        Sách này quá tuyệt vời! Nội dung hấp dẫn, nhân vật được phát triển tốt. Chất lượng in ấn rất
                        đẹp,
                        bìa cứng chắc chắn. Giao hàng nhanh chóng và đóng gói cẩn thận.
                        Tôi rất hài lòng với mua hàng lần này. Khuyến cáo mọi người nên mua!
                    </p>

                    <div class="review-actions">
                        <i id="heart" class="fa-regular fa-heart"></i>
                        <span class="action">Thích (4)</span>
                        <i class="fa-solid fa-reply"></i>
                        <span class="action"> Trả lời</span>
                    </div>
                </div>
            </div>

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
                        <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
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
                        <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
                        <p class="product-name">Thám tử lừng danh Conan tập 72</p>
                        <p class="product-price">₫21,000</p>
                        <p class="sold">Đã bán: <strong>36</strong></p>
                    </div>
                    <div class="product-item">
                        <img src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3" alt="">
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
                    <img src="../../img/zaloPay.png" alt="ZaloPay">
                </div>
                <p>Website đã đăng ký với Bộ Công Thương.</p>
            </div>
        </div>

        <div class="footer-bottom">
            <p>© 2025 <strong>ComicStore.vn</strong> — All rights reserved.</p>
        </div>
    </footer>


    <script>

        //cái popup hiện lên của ảnh bên trái
        // ảnh chính
        const mainImgContainer = document.getElementById("img-container");
        // popup
        const popup1 = document.getElementById("img-container-popup1");
        const popup2 = document.getElementById("img-container-popup2");
        const popup3 = document.getElementById("img-container-popup3");

        // ảnh nhỏ trong warehouse
        document.getElementById("img-small1").addEventListener("click", () => {
            mainImgContainer.style.display = "block";
            popup1.style.display = "none";
            popup2.style.display = "none";
            popup3.style.display = "none";
        });

        document.getElementById("img-small2").addEventListener("click", () => {
            mainImgContainer.style.display = "none";
            popup1.style.display = "block";
            popup2.style.display = "none";
            popup3.style.display = "none";
        });

        document.getElementById("img-small3").addEventListener("click", () => {
            mainImgContainer.style.display = "none";
            popup1.style.display = "none";
            popup2.style.display = "block";
            popup3.style.display = "none";
        });

        document.getElementById("img-small4").addEventListener("click", () => {
            mainImgContainer.style.display = "none";
            popup1.style.display = "none";
            popup2.style.display = "none";
            popup3.style.display = "block";
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

        // cái này cho trái tim đổi màu
        const heart = document.getElementById("heart");
        heart.addEventListener('click', () => {
            heart.classList.toggle("fa-regular");
            heart.classList.toggle("fa-solid");
        });


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
        document.getElementById("tab2").addEventListener("click", function (event) {
            event.preventDefault();
            document.querySelector(".reviewed-person").style.display = "none";
            document.querySelector(".reviewed-person-popup").style.display = "block";
        });
        document.getElementById("tab1").addEventListener("click", function (event) {
            event.preventDefault();
            document.querySelector(".reviewed-person").style.display = "block";
            document.querySelector(".reviewed-person-popup").style.display = "none";
        });

        document.getElementById("more-btn-popup-slider").addEventListener("click", function () {
            document.querySelector("#product-slider-popup").style.display = "block";

        });

    </script>

</body>

</html>