<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 21/12/2025
  Time: 11:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/search.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
</head>
<body>
<jsp:include page="/fontend/public/header.jsp" />
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
                    <div class="comic-card">
                        <img src="${comic.thumbnailUrl}" alt="${comic.nameComics}">
                        <div class="info">
                            <h3>${comic.nameComics}</h3>
                            <p><strong>Tác giả:</strong> ${comic.author}</p>
                            <p><strong>NXB:</strong> ${comic.publisher}</p>
                            <p class="price">${comic.price} đ</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
