<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
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
                <button class="btn-loc">Lọc</button>
            </div>
            <section>
                <h3>GIÁ:</h3>
                <ul>
                    <li><input type="checkbox" id="price1"><label for="price1">0đ - 15,000đ</label></li>
                    <li><input type="checkbox" id="price2"><label for="price2">15,000đ - 30,000đ</label></li>
                    <li><input type="checkbox" id="price3"><label for="price3">30,000đ - 50,000đ</label></li>
                    <li><input type="checkbox" id="price4"><label for="price4">50,000đ - 70,000đ</label></li>
                    <li><input type="checkbox" id="price5"><label for="price5">70,000đ - 100,000đ</label></li>
                    <li><input type="checkbox" id="price6"><label for="price6">Trên 100,000đ</label></li>
                </ul>
            </section>

            <section>
                <h3>TÁC GIẢ:</h3>
                <ul>
                    <li><input type="checkbox" id="brand1"><label for="brand1">Aoyama Gosho</label></li>
                    <li><input type="checkbox" id="brand2"><label for="brand2">Yusuke Muratac</label></li>
                    <li><input type="checkbox" id="brand3"><label for="brand3">Eiichiro Oda</label></li>
                    <li><input type="checkbox" id="brand4"><label for="brand4">Aoyama Gosho</label></li>
                    <li><input type="checkbox" id="brand5"><label for="brand5">Fujiko F. Fujio</label></li>
                    <li><input type="checkbox" id="brand7"><label for="brand7">Niigata</label></li>
                    <li><input type="checkbox" id="brand9"><label for="brand9">Akira Toriyama</label></li>
                    <li><input type="checkbox" id="brand9"><label for="brand9">Masashi Kishimoto</label></li>
                </ul>
            </section>

            <section>
                <h3>NHÀ XUẤT BẢN:</h3>
                <ul>
                    <li><input type="checkbox" id="supplier1"><label for="supplier1">Nhà sách Phương Nam</label></li>
                    <li><input type="checkbox" id="supplier2"><label for="supplier2">Tân Việt Books</label></li>
                    <li><input type="checkbox" id="supplier3"><label for="supplier3">Nhà sách Tiền Phong, Thái Hà, Tiến
                        Thọ</label>
                    </li>
                    <li><input type="checkbox" id="supplier4"><label for="supplier4">NXB Trẻ</label></li>
                    <li><input type="checkbox" id="supplier5"><label for="supplier5">Nền tảng truyện online</label></li>
                    <li><input type="checkbox" id="supplier6"><label for="supplier6">MangaDex Việt</label></li>
                    <li><input type="checkbox" id="supplier7"><label for="supplier7">Kim Đồng</label></li>
                    <li><input type="checkbox" id="supplier8"><label for="supplier8">Skybooks</label></li>
                </ul>
            </section>

            <section>
                <h3>THỜI GIAN PHÁT HÀNH:</h3>
                <ul>
                    <li><input type="checkbox" id="supplier1"><label for="supplier1">Gần đây</label></li>
                    <li><input type="checkbox" id="supplier1"><label for="supplier1">2024</label></li>
                    <li><input type="checkbox" id="supplier1"><label for="supplier1">2023</label></li>
                    <li><input type="checkbox" id="supplier1"><label for="supplier1">2022</label></li>
                    <li><input type="checkbox" id="supplier1"><label for="supplier1">2021</label></li>
                    <li><input type="checkbox" id="supplier1"><label for="supplier1">2020</label></li>
                    <li><input type="checkbox" id="supplier2"><label for="supplier2">Trước đó</label></li>
                </ul>
            </section>

            <!-- <section class="end-section">
              <h3>Độ tuổi</h3>
              <ul>
                <li><input type="checkbox" id="supplier1"><label for="supplier1">Dưới 6 tuổi</label></li>
                <li><input type="checkbox" id="supplier2"><label for="supplier2">6 - 12 tuổi</label></li>
                <li><input type="checkbox" id="supplier3"><label for="supplier3">12 - 16 tuổi</label></li>
                <li><input type="checkbox" id="supplier4"><label for="supplier4">16 - 18 tuổi</label></li>
                <li><input type="checkbox" id="supplier4"><label for="supplier4">Trên 18 tuổi</label></li>

              </ul>
            </section> -->

        </div>

        <!-- content bên phải-->
        <div id="items-listing">

            <h1>Hành động</h1>

            <div id="sum-items">
                <p><strong>Tổng sản phẩm hiển thị:</strong> 36</p>
            </div>

            <!-- Lưới sản phẩm -->
            <section aria-label="Danh sách sản phẩm gôm tẩy">

                <!-- trang 1 nó hiện -->
                <div class="page" data-page="1">
                    <!--sản phẩm 1 đến 12-->

                    <!-- Sản phẩm 1 -->
                    <article>
                        <a href="detail.jsp">
                            <div>
                                <img src="https://tse2.mm.bing.net/th/id/OIP.9XM2JUuE0llfp0orZz18qwHaLg?rs=1&pid=ImgDetMain&o=7&rm=3"
                                     alt="">
                                <div class="detail-book">
                                    <p>Thám tử lừng danh Conan Tập 100</p>
                                    <p class="product-price">18.000₫</p>
                                    <p class="sold">Đã bán: <strong>196</strong></p>
                                </div>
                            </div>
                        </a>
                    </article>

                    <!-- Sản phẩm 2 -->
                    <article>
                        <div>
                            <img
                                    src="https://1.bp.blogspot.com/-_4tMiTXLiUo/XcgpmUGMteI/AAAAAAAAFW4/kpGxwVNcl00xeJjrgUCONjV5-M8PNpQkwCLcBGAsYHQ/s1600/LA%2BHAN%2BQUYEN.png"
                                    alt="">
                            <div class="detail-book">
                                <p>Thiếu lâm tự quyền hổ</p>
                                <p class="product-price">25.500₫</p>
                                <p class="sold">Đã bán: <strong>173</strong></p>
                            </div>
                        </div>
                    </article>

                    <!-- Sản phẩm 3 -->
                    <article>
                        <div>
                            <img
                                    src="https://tse2.mm.bing.net/th/id/OIP.Xt1Ul32rUSqFN3j53FGlXQAAAA?cb=ucfimgc2&w=369&h=544&rs=1&pid=ImgDetMain&o=7&rm=3"
                                    alt="">
                            <div class="detail-book">
                                <p>Thủy Hử</p>
                                <p class="product-price">25.500₫</p>
                                <p class="sold">Đã bán: <strong>173</strong></p>
                            </div>
                        </div>
                    </article>

                    <!-- Sản phẩm 4 -->
                    <article>
                        <div>
                            <img src="https://thegioivanhoc.com/wp-content/uploads/2024/02/luc-tieu-phung-350x476.jpg" alt="">
                            <div class="detail-book">
                                <p>Lục Tiểu Phụng</p>
                                <p class="product-price">35.500₫</p>
                                <p class="sold">Đã bán: <strong>63</strong></p>
                            </div>
                        </div>
                    </article>

                    <!-- Sản phẩm 5 -->
                    <article>
                        <div>
                            <img src="https://online.fliphtml5.com/qyhf/vkiv/files/large/1.webp" alt="">
                            <div class="detail-book">
                                <p>Nữ Hoàng Ai Cập</p>
                                <p class="product-price">19.500₫</p>
                                <p class="sold">Đã bán: <strong>69</strong></p>
                            </div>
                        </div>
                    </article>

                    <!-- Sản phẩm 6 -->
                    <article>
                        <div>
                            <img
                                    src="https://tse3.mm.bing.net/th/id/OIP.o9JBkwLR0W1_gmZ9LZm4JQAAAA?cb=ucfimgc2&rs=1&pid=ImgDetMain&o=7&rm=3"
                                    alt="">
                            <div class="detail-book">
                                <p>Song long đại đường</p>
                                <p class="product-price">19.500₫</p>
                                <p class="sold">Đã bán: <strong>69</strong></p>
                            </div>
                        </div>
                    </article>

                    <!-- Sản phẩm 7 -->
                    <article>
                        <div>
                            <img src="https://xemsachhay.com/wp-content/uploads/2018/04/29327_35837.jpg" alt="">
                            <div class="detail-book">
                                <p>Sơn tinh thủy tinh</p>
                                <p class="product-price">19.500₫</p>
                                <p class="sold">Đã bán: <strong>69</strong></p>
                            </div>
                        </div>
                    </article>


                    <!-- Sản phẩm 8 -->
                    <article>
                        <div>
                            <img src="https://bookbuy.vn/Res/Images/Product/nhiem-vu-dac-biet-tap-8_23819_1.jpg" alt="">
                            <div class="detail-book">
                                <p>Nhiệm vụ đặc biệt</p>
                                <p class="product-price">19.500₫</p>
                                <p class="sold">Đã bán: <strong>69</strong></p>
                            </div>
                        </div>
                    </article>

                    <!-- Sản phẩm 9 -->
                    <article>
                        <div>
                            <img src="https://cdn0.fahasa.com/media/catalog/product/8/a/8a03452591c41300acc485c8bc41663d.jpg"
                                 alt="">
                            <div class="detail-book">
                                <p>Thám tử Kinorochi</p>
                                <p class="product-price">19.500₫</p>
                                <p class="sold">Đã bán: <strong>69</strong></p>
                            </div>
                        </div>
                    </article>


                    <!-- Sản phẩm 10 -->
                    <article>
                        <div>
                            <img src="https://i.pinimg.com/736x/21/7f/49/217f49e1ed9474a04ffbf23105a35d1f.jpg" alt="">

                            <div class="detail-book">
                                <p>Hồ sơ thật</p>
                                <p class="product-price">19.500₫</p>
                                <p class="sold">Đã bán: <strong>69</strong></p>
                            </div>
                        </div>
                    </article>

                    <!-- Sản phẩm 11 -->
                    <article>
                        <div>
                            <img
                                    src="https://bookbuy.vn/Res/Images/Product/hanh-trinh-u-linh-gioi-tap-14-qua-khu-dam-mau_53979_1.jpg"
                                    alt="">
                            <div class="detail-book">
                                <p>hành trình U Linh Giới</p>
                                <p class="product-price">19.500₫</p>
                                <p class="sold">Đã bán: <strong>69</strong></p>
                            </div>
                        </div>
                    </article>


                    <!-- Sản phẩm 12 -->
                    <article>
                        <div>
                            <img
                                    src="https://tse4.mm.bing.net/th/id/OIP.FZtbFiffZnS4J_ioM2qk3QHaLb?cb=ucfimgc2&w=918&h=1416&rs=1&pid=ImgDetMain&o=7&rm=3"
                                    alt="">
                            <div class="detail-book">
                                <p>Itto sóng gió học đường</p>
                                <p class="product-price">19.500₫</p>
                                <p class="sold">Đã bán: <strong>69</strong></p>
                            </div>
                        </div>
                    </article>


                </div>

                <!-- trang 2 -->
                <div class="page" data-page="2" style="display:none;">
                    <!-- Sản phẩm 13 đến 24 -->
                    <!-- Sản phẩm 1 -->
                    <article>
                        <div>
                            <img
                                    src="https://dwgkfo5b3odmw.cloudfront.net/manga/thumbs/thumb-157628-OnePunchMan_GN27_C1_Web-3-gLWSq6Fk8H7qqa0kwZlEiA.jpg"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>Saitama - tập 27</p>
                            <p class="product-price">47.500₫</p>
                            <p class="sold">Đã bán: <strong>76</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 2 -->
                    <article>
                        <div>
                            <img
                                    src="https://tse2.mm.bing.net/th/id/OIP.Xt1Ul32rUSqFN3j53FGlXQAAAA?cb=ucfimgc2&w=369&h=544&rs=1&pid=ImgDetMain&o=7&rm=3"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>Thủy Hử</p>
                            <p class="product-price">25.000₫</p>
                            <p class="sold">Đã bán: <strong>173</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 3 -->
                    <article>
                        <div>
                            <img
                                    src="https://1.bp.blogspot.com/-_4tMiTXLiUo/XcgpmUGMteI/AAAAAAAAFW4/kpGxwVNcl00xeJjrgUCONjV5-M8PNpQkwCLcBGAsYHQ/s1600/LA%2BHAN%2BQUYEN.png"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>La hán quyền</p>
                            <p class="product-price">28.500₫</p>
                            <p class="sold">Đã bán: <strong>148</strong></p>
                        </div>
                    </article>


                    <!-- Sản phẩm 8 -->
                    <article>
                        <div>
                            <img src="https://bookbuy.vn/Res/Images/Product/nhiem-vu-dac-biet-tap-8_23819_1.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Nhiệm vụ đặc biệt</p>
                            <p class="product-price">34.500₫</p>
                            <p class="sold">Đã bán: <strong>94</strong></p>
                        </div>
                    </article>
                    <!-- Sản phẩm 5 -->
                    <article>
                        <div>
                            <img src="https://online.fliphtml5.com/qyhf/vkiv/files/large/1.webp" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Nữ Hoàng Ai Cập</p>
                            <p class="product-price">29.500₫</p>
                            <p class="sold">Đã bán: <strong>82</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 6 -->
                    <article>
                        <div>
                            <img
                                    src="https://tse3.mm.bing.net/th/id/OIP.o9JBkwLR0W1_gmZ9LZm4JQAAAA?cb=ucfimgc2&rs=1&pid=ImgDetMain&o=7&rm=3"
                                    alt="">
                            <p>Song long đại đường</p>
                        </div>
                        <div class="detail-book">
                            <p>Song long đại đường</p>
                            <p class="product-price">27.500₫</p>
                            <p class="sold">Đã bán: <strong>63</strong></p>
                        </div>
                    </article>




                    <!-- Sản phẩm 4 -->
                    <article>
                        <div>
                            <img src="https://thegioivanhoc.com/wp-content/uploads/2024/02/luc-tieu-phung-350x476.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Saitama - tập 27</p>
                            <p class="product-price">37.500₫</p>
                            <p class="sold">Đã bán: <strong>37</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 7 -->
                    <article>
                        <div>
                            <img src="https://xemsachhay.com/wp-content/uploads/2018/04/29327_35837.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Sơn Tinh Thủy Tinh</p>
                            <p class="product-price">24.500₫</p>
                            <p class="sold">Đã bán: <strong>68</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 9 -->
                    <article>
                        <div>
                            <img src="https://cdn0.fahasa.com/media/catalog/product/8/a/8a03452591c41300acc485c8bc41663d.jpg"
                                 alt="">
                            <p>Thám tử Kindaichi</p>
                        </div>
                        <div class="detail-book">
                            <p>Thám tử Kindaichi</p>
                            <p class="product-price">19.500₫</p>
                            <p class="sold">Đã bán: <strong>62</strong></p>
                        </div>
                    </article>


                    <!-- Sản phẩm 10 -->
                    <article>
                        <div>
                            <img src="https://i.pinimg.com/736x/21/7f/49/217f49e1ed9474a04ffbf23105a35d1f.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Saitama - tập 27</p>
                            <p class="product-price">47.500₫</p>
                            <p class="sold">Đã bán: <strong>76</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 11 -->
                    <article>
                        <div>
                            <img
                                    src="https://bookbuy.vn/Res/Images/Product/hanh-trinh-u-linh-gioi-tap-14-qua-khu-dam-mau_53979_1.jpg"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>Quá khứ đẫm máu</p>
                            <p class="product-price">25.500₫</p>
                            <p class="sold">Đã bán: <strong>123</strong></p>
                        </div>
                    </article>


                    <!-- Sản phẩm 12 -->
                    <article>
                        <div>
                            <img
                                    src="https://tse4.mm.bing.net/th/id/OIP.FZtbFiffZnS4J_ioM2qk3QHaLb?cb=ucfimgc2&w=918&h=1416&rs=1&pid=ImgDetMain&o=7&rm=3"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>Itto Sóng gió cầu trường</p>
                            <p class="product-price">27.500₫</p>
                            <p class="sold">Đã bán: <strong>176</strong></p>
                        </div>
                    </article>

                </div>

                <!-- Trang 3 -->
                <div class="page" data-page="3" style="display:none;">
                    <!-- Sản phẩm 25 đến 36 -->
                    <!-- Sản phẩm 1 -->
                    <article>
                        <div>
                            <img src="https://genk.mediacdn.vn/2019/11/27/photo-1-15748243687411891563142.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Saitama Tập 21</p>
                            <p class="product-price">25.500₫</p>
                            <p class="sold">Đã bán: <strong>133</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 2 -->
                    <article>
                        <div>
                            <img
                                    src="https://1.bp.blogspot.com/-_4tMiTXLiUo/XcgpmUGMteI/AAAAAAAAFW4/kpGxwVNcl00xeJjrgUCONjV5-M8PNpQkwCLcBGAsYHQ/s1600/LA%2BHAN%2BQUYEN.png"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>La hán quyền</p>
                            <p class="product-price">34.000₫</p>
                            <p class="sold">Đã bán: <strong>83</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 9 -->
                    <article>
                        <div>
                            <img src="https://cdn0.fahasa.com/media/catalog/product/8/a/8a03452591c41300acc485c8bc41663d.jpg"
                                 alt="">
                        </div>
                        <div class="detail-book">
                            <p>Thám tử Kindaichi</p>
                            <p class="product-price">22.500₫</p>
                            <p class="sold">Đã bán: <strong>83</strong></p>
                        </div>
                    </article>



                    <!-- Sản phẩm 3 -->
                    <article>
                        <div>
                            <img src="https://i.pinimg.com/736x/ed/d3/a7/edd3a77ad331ec6aad28c9e70c1f5cf2.jpg" alt="">
                            <p>Saitama - tập đặc biệt</p>
                        </div>
                        <div class="detail-book">
                            <p>Quá khứ đẫm máu</p>
                            <p class="product-price">25.500₫</p>
                            <p class="sold">Đã bán: <strong>123</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 4 -->
                    <article>
                        <div>
                            <img src="https://thegioivanhoc.com/wp-content/uploads/2024/02/luc-tieu-phung-350x476.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Lục Tiểu Phụng</p>
                            <p class="product-price">29.500₫</p>
                            <p class="sold">Đã bán: <strong>76</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 5 -->
                    <article>
                        <div>
                            <img src="https://online.fliphtml5.com/qyhf/vkiv/files/large/1.webp" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Nữ Hoàng Ai Cập</p>
                            <p class="product-price">25.500₫</p>
                            <p class="sold">Đã bán: <strong>58</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 6 -->
                    <article>
                        <div>
                            <img
                                    src="https://tse3.mm.bing.net/th/id/OIP.o9JBkwLR0W1_gmZ9LZm4JQAAAA?cb=ucfimgc2&rs=1&pid=ImgDetMain&o=7&rm=3"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>Song long đại đường</p>
                            <p class="product-price">34.500₫</p>
                            <p class="sold">Đã bán: <strong>94</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 7 -->
                    <article>
                        <div>
                            <img src="https://xemsachhay.com/wp-content/uploads/2018/04/29327_35837.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Sơn Tinh Thủy Tinh</p>
                            <p class="product-price">29.500₫</p>
                            <p class="sold">Đã bán: <strong>135</strong></p>
                        </div>
                    </article>


                    <!-- Sản phẩm 8 -->
                    <article>
                        <div>
                            <img src="https://bookbuy.vn/Res/Images/Product/nhiem-vu-dac-biet-tap-8_23819_1.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Quá khứ đẫm máu</p>
                            <p class="product-price">29.000₫</p>
                            <p class="sold">Đã bán: <strong>79</strong></p>
                        </div>
                    </article>


                    <!-- Sản phẩm 10 -->
                    <article>
                        <div>
                            <img src="https://i.pinimg.com/736x/21/7f/49/217f49e1ed9474a04ffbf23105a35d1f.jpg" alt="">
                        </div>
                        <div class="detail-book">
                            <p>Hồ sơ thật</p>
                            <p class="product-price">25.500₫</p>
                            <p class="sold">Đã bán: <strong>161</strong></p>
                        </div>
                    </article>

                    <!-- Sản phẩm 11 -->
                    <article>
                        <div>
                            <img
                                    src="https://bookbuy.vn/Res/Images/Product/hanh-trinh-u-linh-gioi-tap-14-qua-khu-dam-mau_53979_1.jpg"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>Quá khứ đẫm máu</p>
                            <p class="product-price">25.500₫</p>
                            <p class="sold">Đã bán: <strong>123</strong></p>
                        </div>
                    </article>


                    <!-- Sản phẩm 12 -->
                    <article>
                        <div>
                            <img
                                    src="https://tse4.mm.bing.net/th/id/OIP.FZtbFiffZnS4J_ioM2qk3QHaLb?cb=ucfimgc2&w=918&h=1416&rs=1&pid=ImgDetMain&o=7&rm=3"
                                    alt="">
                        </div>
                        <div class="detail-book">
                            <p>Itto Sóng gió cầu trường</p>
                            <p class="product-price">25.500₫</p>
                            <p class="sold">Đã bán: <strong>49</strong></p>
                        </div>
                    </article>
                </div>

            </section>

            <!-- Phân trang -->
            <nav aria-label="Phân trang">
                <ul>
                    <li><a href="#" onclick="prevPage()">«</a></li>
                    <li><a href="#" onclick="changePage(1)" id="page-1">1</a></li>
                    <li><a href="#" onclick="changePage(2)" id="page-2">2</a></li>
                    <li><a href="#" onclick="changePage(3)" id="page-3">3</a></li>
                    <li><a href="#" onclick="nextPage()">»</a></li>
                </ul>
            </nav>

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
                    <img
                            src="https://product.hstatic.net/200000343865/product/1_9544a3ba5bd64806ab59f7fd9fafcf13_ea18ba498dbf48458655f34dd7c049e8_master.jpg"
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
                    <img
                            src="https://tse2.mm.bing.net/th/id/OIP.EYeZC0QXNbZJ9uKUFqejCQHaMT?w=1083&h=1800&rs=1&pid=ImgDetMain&o=7&rm=3"
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
                        <p class="product-price">₫18,000</p>
                        <p class="sold">Đã bán: <strong>196</strong></p>
                    </a>
                </div>
                <div class="product-item">
                    <img
                            src="https://tse1.mm.bing.net/th/id/OIP.P5rFWcOxdjC4jsCK2hMfvwAAAA?w=275&h=431&rs=1&pid=ImgDetMain&o=7&rm=3"
                            alt="">
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
                    <img
                            src="https://tse2.mm.bing.net/th/id/OIP.TkZ31P2gB7dWazJNWUyV0AAAAA?w=300&h=470&rs=1&pid=ImgDetMain&o=7&rm=3"
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
                    <img src="https://i.pinimg.com/originals/3a/a9/47/3aa9473f3ce582ddfcc0cf8cf2a12edf.jpg" alt="">
                    <p class="product-name">Naruto Tâp 208</p>
                    <p class="product-price">₫40,000</p>
                    <p class="sold">Đã bán: <strong>58</strong></p>
                </div>

                <div class="product-item">
                    <img
                            src="https://tse4.mm.bing.net/th/id/OIP.9v3RcOMUqWTRHXD8RwdBqwHaK0?cb=ucfimg2ucfimg=1&w=876&h=1280&rs=1&pid=ImgDetMain&o=7&rm=3"
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
                    <img
                            src="https://tse3.mm.bing.net/th/id/OIP.UYXVfw_z4MzfvIEod7Gh7QAAAA?cb=ucfimg2ucfimg=1&w=400&h=629&rs=1&pid=ImgDetMain&o=7&rm=3"
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
<jsp:include page="/fontend/public/Footer.jsp" />

<script>

    <%--document.addEventListener("DOMContentLoaded", function () {--%>
    <%--    let totalPages = document.querySelectorAll('.page').length;--%>
    <%--    let currentPage = 1; // khai báo biến toàn cục--%>

    <%--    function changePage(page) {--%>
    <%--        currentPage = page;--%>

    <%--        // Ẩn tất cả--%>
    <%--        document.querySelectorAll('.page').forEach(p => p.style.display = 'none');--%>

    <%--        // Hiển thị trang hiện tại nếu tồn tại--%>
    <%--        const current = document.querySelector(`.page[data-page="${page}"]`);--%>
    <%--        if (current) {--%>
    <%--            current.style.display = 'flex';--%>
    <%--        }--%>

    <%--        // Cập nhật trạng thái nút phân trang--%>
    <%--        document.querySelectorAll('nav[aria-label="Phân trang"] a').forEach(a => a.classList.remove('active'));--%>
    <%--        const activeBtn = document.getElementById(`page-${page}`);--%>
    <%--        if (activeBtn) {--%>
    <%--            activeBtn.classList.add('active');--%>
    <%--        }--%>
    <%--    }--%>

    <%--    function nextPage() {--%>
    <%--        if (currentPage < totalPages) {--%>
    <%--            changePage(currentPage + 1);--%>
    <%--        }--%>
    <%--    }--%>

    <%--    function prevPage() {--%>
    <%--        if (currentPage > 1) {--%>
    <%--            changePage(currentPage - 1);--%>
    <%--        }--%>
    <%--    }--%>

    <%--    // Mặc định hiển thị trang 1--%>
    <%--    changePage(1);--%>

    <%--    // Nếu muốn gắn sự kiện cho nút "Next" và "Prev"--%>
    <%--    document.getElementById("nextBtn")?.addEventListener("click", nextPage);--%>
    <%--    document.getElementById("prevBtn")?.addEventListener("click", prevPage);--%>
    <%--});--%>

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