<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/css/style.css">
<%--    <link rel="stylesheet" href="fonts/icomoon/style.css">--%>
<%--    <link rel="stylesheet" href="css/owl.carousel.min.css">--%>

    <title>Forgot Password </title>
</head>
<body>

<div class="d-lg-flex half">
    <div class="bg order-1 order-md-2" style="background-image: url('../../img/anhLogin.png');"></div>

        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-md-7">
                    <h3><strong>Xác thực email</strong></h3>
                    <p class="mb-4">Nhập email để lấy mã xác thực và đặt lại mật khẩu mới.</p>

                    <form action="ForgotPasswordServlet" method="post">
                        <!-- Email -->
                        <div class="form-group first">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" placeholder="Địa chỉ gmail" id="email" name="email" required>
                        </div>

                        <!-- Mã xác thực -->
                        <div class="form-group">
                            <label for="code">Mã xác thực</label>
                            <input type="text" class="form-control" placeholder="Nhập mã xác thực đã gửi" id="code" name="code">
                        </div>

                        <!-- Mật khẩu mới -->
                        <div class="form-group last mb-3">
                            <label for="newPassword">Mật khẩu mới</label>
                            <input type="password" class="form-control" placeholder="Nhập mật khẩu mới" id="newPassword" name="newPassword">
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex mb-4 align-items-center">
                            <button type="submit" name="action" value="getCode" class="btn btn-secondary mr-2">Lấy mã xác thực</button>
                            <button type="submit" name="action" value="resetPassword" class="btn btn-primary">Xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>



<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/popper.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/main.js"></script>
</body>
</html>