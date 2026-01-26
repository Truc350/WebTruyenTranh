<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${series.seriesName} - Comic Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/SeriComic.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<jsp:include page="/fontend/public/header.jsp"/>

<div class="contain-main">
    <div class="seri">
        <a href="#" class="image">
            <img src="${series.coverUrl}"
                 alt="${series.seriesName}"
                 class="manga-cover"
                 onerror="this.src='https://via.placeholder.com/300x400?text=No+Image'">
        </a>

        <div class="contain1">
            <div class="contain-header">
                <h2 class="manga-title">${series.seriesName}</h2>

                <%-- Hiển thị tác giả --%>
                <c:if test="${not empty seriesAuthors}">
                    <p class="series-detail">
                        <strong>Tác giả:</strong> ${seriesAuthors}
                    </p>
                </c:if>

                <%-- Hiển thị nhà xuất bản --%>
                <c:if test="${not empty seriesPublishers}">
                    <p class="series-detail">
                        <strong>Nhà xuất bản:</strong> ${seriesPublishers}
                    </p>
                </c:if>

                <div class="series-info">
                    <p class="series-detail">
                        <strong>Tổng số tập:</strong> ${series.totalVolumes}
                    </p>

                    <p class="series-detail">
                        <strong>Trạng thái:</strong>
                        <span class="status-badge ${series.status == 'completed' ? 'completed' : 'ongoing'}">
                            ${series.status == 'completed' ? 'Hoàn thành' :
                                    series.status == 'ongoing' ? 'Đang phát hành' : 'Tạm dừng'}
                        </span>
                    </p>

                </div>
            </div>

            <div class="action-panel">
                <div class="notify-section">
                    <button id="notifyBtn" class="notify-btn">
                        <i class="fas fa-bell"></i> Nhận thông báo
                    </button>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Danh sách các tập truyện trong series -->
<div class="series-volumes-container">

    <c:choose>
        <c:when test="${not empty comicsInSeries}">
            <div class="item">
                <div class="slider-track">
                    <c:forEach var="comic" items="${comicsInSeries}">
                        <div class="product-item">
                            <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}">
                                <div style="position: relative;">
                                    <!-- Badge Flash Sale -->
                                    <c:if test="${comic.hasFlashSale}">
                                        <div class="flash-sale-badge">
                                            <i class="fas fa-bolt"></i> FLASH SALE
                                        </div>
                                    </c:if>

                                    <img src="${comic.thumbnailUrl}"
                                         alt="${comic.nameComics}"
                                         onerror="this.src='https://via.placeholder.com/200x300?text=No+Image'">
                                </div>

                                <p class="product-name">${comic.nameComics}</p>

                                <!-- Giá với Flash Sale -->
                                <c:choose>
                                    <c:when test="${comic.hasFlashSale}">
                                        <!-- Có Flash Sale -->
                                        <p class="product-price flash">
                                            <fmt:formatNumber value="${comic.flashSalePrice}" pattern="#,###"/> đ
                                        </p>
                                        <p class="original-price">
                                            <s><fmt:formatNumber value="${comic.price}" pattern="#,###"/> đ</s>
                                            <span class="discount-badge flash">
                                                -<fmt:formatNumber value="${comic.flashSaleDiscount}" pattern="#"/>%
                                            </span>
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Giá thường -->
                                        <p class="product-price">
                                            <fmt:formatNumber value="${comic.price}" pattern="#,###"/> đ
                                        </p>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Sold count -->
                                <c:choose>
                                    <c:when test="${comic.totalSold != null && comic.totalSold > 0}">
                                        <p class="sold">Đã bán: <strong>${comic.totalSold}</strong></p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="sold">Đã bán: <strong>0</strong></p>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="no-comics-message">
                <i class="fas fa-inbox"></i>
                <p>Chưa có tập truyện nào trong series này</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>




<!-- DEBUG INFO (Remove in production) -->
<c:if test="${pageContext.request.serverName == 'localhost'}">
    <div style="position: fixed; bottom: 10px; right: 10px; background: rgba(0,0,0,0.8); color: white; padding: 10px; border-radius: 8px; font-size: 12px; max-width: 300px; z-index: 9999;">
        <strong>🔍 Debug Info:</strong><br>
        Series ID: ${series.id}<br>
        Total Comics: ${totalComics}<br>
        Comics with Flash Sale:
        <c:set var="flashSaleCount" value="0" />
        <c:forEach var="comic" items="${comicsInSeries}">
            <c:if test="${comic.hasFlashSale}">
                <c:set var="flashSaleCount" value="${flashSaleCount + 1}" />
            </c:if>
        </c:forEach>
            ${flashSaleCount}
    </div>
</c:if>


<!-- INCLUDE FOOTER -->
<jsp:include page="/fontend/public/Footer.jsp"/>

</body>
<script>
    // Toggle notification button
    const notifyBtn = document.getElementById("notifyBtn");

    if (notifyBtn) {
        notifyBtn.addEventListener("click", () => {
            const icon = notifyBtn.querySelector('i');
            const isSubscribed = notifyBtn.classList.contains('subscribed');

            if (isSubscribed) {
                notifyBtn.classList.remove('subscribed');
                icon.className = 'fas fa-bell';
                notifyBtn.innerHTML = '<i class="fas fa-bell"></i> Nhận thông báo';

                // TODO: Gọi API hủy đăng ký thông báo
                showToast('Đã hủy nhận thông báo', 'info');
            } else {
                notifyBtn.classList.add('subscribed');
                icon.className = 'fas fa-bell-slash';
                notifyBtn.innerHTML = '<i class="fas fa-bell-slash"></i> Hủy thông báo';

                // TODO: Gọi API đăng ký thông báo
                showToast('Đã đăng ký nhận thông báo khi có tập mới', 'success');
            }
        });
    }

    // Toast notification
    function showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <i class="fas fa-${type == 'success' ? 'check-circle' : 'info-circle'}"></i>
            <span>${message}</span>
        `;

        document.body.appendChild(toast);

        setTimeout(() => toast.classList.add('show'), 10);
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }
</script>
</html>