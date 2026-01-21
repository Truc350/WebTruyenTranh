<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ưu đãi C-Point</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/UserBCss/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<jsp:include page="/fontend/public/header.jsp"/>

<main>
    <jsp:include page="/fontend/nguoiB/ASideUser.jsp"/>

    <div class="xu-container">
        <div class="xu-header">
            <div class="xu-text">
                <p class="label">Số C-Point hiện có</p>
                <h1>2,500</h1>
            </div>
            <img src="${pageContext.request.contextPath}/img/dollar.png" class="xu-icon" alt="Point Icon">
        </div>

        <div class="history">
            <h3>Lịch sử giao dịch</h3>

            <div class="item">
                <div class="left">
                    <div class="light-icon">⚡</div>
                    <p>Hoàn thành đơn hàng</p>
                </div>
                <span class="value plus">+200 C-Point</span>
            </div>

            <div class="item">
                <div class="left">
                    <div class="light-icon">⚡</div>
                    <p>Hoàn thành đơn hàng</p>
                </div>
                <span class="value plus">+500 C-Point</span>
            </div>

            <div class="item">
                <div class="left">
                    <div class="light-icon">⚡</div>
                    <p>Đánh giá sản phẩm</p>
                </div>
                <span class="value plus">+50 C-Point</span>
            </div>

            <div class="item">
                <div class="left">
                    <div class="light-icon">🎁</div>
                    <p>Đổi voucher 10K</p>
                </div>
                <span class="value minus">-1000 C-Point</span>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/fontend/public/Footer.jsp"/>

</body>
</html>