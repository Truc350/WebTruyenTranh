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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/pagination.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<jsp:include page="/fontend/public/header.jsp"/>

<div class="container">
    <h2>
        Kết quả tìm kiếm cho:
        <span class="keyword">"${keyword}"</span>
    </h2>

    <!-- Hiển thị tổng số kết quả -->
    <c:if test="${not empty totalComics && totalComics > 0}">
        <p class="search-info">
            Tìm thấy <strong>${totalComics}</strong> truyện
            <c:if test="${not empty searchType && searchType != 'all'}">
                (tìm theo
                <c:choose>
                    <c:when test="${searchType == 'name'}">tên truyện</c:when>
                    <c:when test="${searchType == 'author'}">tác giả</c:when>
                    <c:when test="${searchType == 'publisher'}">nhà xuất bản</c:when>
                    <c:when test="${searchType == 'category'}">thể loại</c:when>
                </c:choose>)
            </c:if>
        </p>
    </c:if>

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

            <!-- PAGINATION - Hiển thị thông minh -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <c:url var="prevUrl" value="/search">
                            <c:param name="keyword" value="${keyword}"/>
                            <c:if test="${not empty searchType}">
                                <c:param name="type" value="${searchType}"/>
                            </c:if>
                            <c:param name="page" value="${currentPage - 1}"/>
                        </c:url>
                        <a href="${prevUrl}" class="page-btn">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </c:if>

                    <!-- Logic hiển thị số trang thông minh -->
                    <c:choose>
                        <%-- Nếu tổng số trang <= 7, hiển thị tất cả --%>
                        <c:when test="${totalPages <= 7}">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="pageUrl" value="/search">
                                            <c:param name="keyword" value="${keyword}"/>
                                            <c:if test="${not empty searchType}">
                                                <c:param name="type" value="${searchType}"/>
                                            </c:if>
                                            <c:param name="page" value="${i}"/>
                                        </c:url>
                                        <a href="${pageUrl}" class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:when>

                        <%-- Nếu nhiều trang hơn, hiển thị thông minh với dấu ... --%>
                        <c:otherwise>
                            <%-- Trang đầu --%>
                            <c:choose>
                                <c:when test="${currentPage == 1}">
                                    <span class="page-btn active">1</span>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="page1Url" value="/search">
                                        <c:param name="keyword" value="${keyword}"/>
                                        <c:if test="${not empty searchType}">
                                            <c:param name="type" value="${searchType}"/>
                                        </c:if>
                                        <c:param name="page" value="1"/>
                                    </c:url>
                                    <a href="${page1Url}" class="page-btn">1</a>
                                </c:otherwise>
                            </c:choose>

                            <%-- Dấu ... nếu cần --%>
                            <c:if test="${currentPage > 3}">
                                <span class="page-btn dots">...</span>
                            </c:if>

                            <%-- Các trang xung quanh trang hiện tại --%>
                            <c:forEach var="i" begin="${currentPage - 1}" end="${currentPage + 1}">
                                <c:if test="${i > 1 && i < totalPages}">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="page-btn active">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url var="pageUrl" value="/search">
                                                <c:param name="keyword" value="${keyword}"/>
                                                <c:if test="${not empty searchType}">
                                                    <c:param name="type" value="${searchType}"/>
                                                </c:if>
                                                <c:param name="page" value="${i}"/>
                                            </c:url>
                                            <a href="${pageUrl}" class="page-btn">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forEach>

                            <%-- Dấu ... nếu cần --%>
                            <c:if test="${currentPage < totalPages - 2}">
                                <span class="page-btn dots">...</span>
                            </c:if>

                            <%-- Trang cuối --%>
                            <c:choose>
                                <c:when test="${currentPage == totalPages}">
                                    <span class="page-btn active">${totalPages}</span>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="lastPageUrl" value="/search">
                                        <c:param name="keyword" value="${keyword}"/>
                                        <c:if test="${not empty searchType}">
                                            <c:param name="type" value="${searchType}"/>
                                        </c:if>
                                        <c:param name="page" value="${totalPages}"/>
                                    </c:url>
                                    <a href="${lastPageUrl}" class="page-btn">${totalPages}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>

                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <c:url var="nextUrl" value="/search">
                            <c:param name="keyword" value="${keyword}"/>
                            <c:if test="${not empty searchType}">
                                <c:param name="type" value="${searchType}"/>
                            </c:if>
                            <c:param name="page" value="${currentPage + 1}"/>
                        </c:url>
                        <a href="${nextUrl}" class="page-btn">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </c:if>

        </c:otherwise>
    </c:choose>
</div>

<!-- INCLUDE FOOTER -->
<jsp:include page="/fontend/public/Footer.jsp"/>
</body>
</html>
