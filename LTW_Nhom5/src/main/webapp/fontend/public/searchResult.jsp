<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/search.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/homePage.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<jsp:include page="/fontend/public/header.jsp"/>

<div class="container">
    <h2>
        Kết quả tìm kiếm cho:
        <span class="keyword">"${keyword}"</span>
    </h2>

    <c:choose>
        <c:when test="${empty comics}">
            <p class="empty">Không tìm thấy truyện phù hợp.</p>
        </c:when>

        <c:otherwise>
            <div class="comic-list">
                <c:forEach var="comic" items="${comics}">
                    <div class="product-item">
                        <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}">
                            <img src="${comic.thumbnailUrl}" alt="${comic.nameComics}">
                            <p class="product-name">${comic.nameComics}</p>
                        </a>

                        <fmt:setLocale value="vi_VN"/>
                        <p class="product-price">
                                <%--                            <fmt:formatNumber value="${comic.price}" type="currency"/>--%>
                            <fmt:formatNumber value="${comic.price}" type="number" groupingUsed="true"/> đ
                        </p>

                        <p class="sold">
                            Đã bán: <strong>${comic.totalSold}</strong>
                        </p>

                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- INCLUDE FOOTER -->
<jsp:include page="/fontend/public/Footer.jsp"/>
</body>
</html>
