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
                <c:if test="${not empty series.description}">
                    <p class="manga-description">${series.description}</p>
                </c:if>

                <div class="series-info">
                    <p class="series-detail">
                        <i class="fas fa-book"></i>
                        <strong>Tổng số tập:</strong> ${series.totalVolumes}
                    </p>

                    <p class="series-detail">
                        <i class="fas fa-info-circle"></i>
                        <strong>Trạng thái:</strong>
                        <span class="status-badge ${series.status == 'completed' ? 'completed' : 'ongoing'}">
                            ${series.status == 'completed' ? 'Hoàn thành' :
                                    series.status == 'ongoing' ? 'Đang phát hành' : 'Tạm dừng'}
                        </span>
                    </p>

<%--                    <p class="series-detail">--%>
<%--                        <strong>Tác giả:</strong> ${}--%>
<%--                    </p>--%>
<%--                    <p class="series-detail">--%>
<%--                        <strong>Nhà xuất bản:</strong> ${}--%>
<%--                    </p>--%>
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
    <h2 class="section-title">
        <i class="fas fa-list"></i> Danh sách tập truyện
    </h2>

    <c:choose>
        <c:when test="${not empty comicsInSeries}">
            <div class="item">
                <div class="slider-track">
                    <c:forEach var="comic" items="${comicsInSeries}">
                        <div class="product-item">
                            <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}">
                                <img src="${comic.thumbnailUrl}"
                                     alt="${comic.nameComics}"
                                     onerror="this.src='https://via.placeholder.com/200x300?text=No+Image'">
                                <p class="product-name">${comic.nameComics}</p>

                                <fmt:formatNumber value="${comic.discountPrice}"
                                                  type="number"
                                                  groupingUsed="true"
                                                  var="formattedPrice"/>
                                <p class="product-price">₫${formattedPrice}</p>

                                <c:if test="${comic.totalSold > 0}">
                                    <p class="sold">Đã bán: <strong>${comic.totalSold}</strong></p>
                                </c:if>

                                <c:choose>
                                    <c:when test="${comic.stockQuantity == 0}">
                                        <span class="stock-badge out-of-stock">Hết hàng</span>
                                    </c:when>
                                    <c:when test="${comic.stockQuantity > 0 && comic.stockQuantity < 10}">
                                        <span class="stock-badge low-stock">Còn ${comic.stockQuantity}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-badge in-stock">Còn hàng</span>
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

<!-- INCLUDE FOOTER -->
<jsp:include page="/fontend/public/Footer.jsp"/>

</body>
<script>
    // Toggle notification button
    const notifyBtn = document.getElementById("notifyBtn");

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

    // Toast notification
    function showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'info-circle'}"></i>
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