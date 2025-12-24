<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/css/style.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400&display=swap" rel="stylesheet">
    <title>Register</title>

</head>
<body>
<div class="d-lg-flex half">
            <div class="bg order-1 order-md-2" style="background-image: url('../../img/anhLogin.png');"></div>
        <div class="contents order-2 order-md-1">

        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-md-7">
                    <h3> <strong>Tạo tài khoản</strong></h3>
                    <p class="mb-4">Điền thông tin để đăng ký.</p>

<%--                <form action="RegisterServlet" method="post">--%>
                    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                        <!-- Username -->
                        <div class="form-group first">
                            <label for="username">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Tên đăng nhập" required>
                        </div>

                        <!-- Email -->
                        <div class="form-group">
                            <label for="email">Địa chỉ Email</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Địa chỉ gmail" required>
                        </div>

                        <!-- Password -->
                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
                        </div>

                        <!-- Confirm Password -->
                        <div class="form-group last mb-3">
                            <label for="confirmPassword">Xác nhận mật khẩu</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                        </div>

                        <!-- Checkbox -->
                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="agree" name="agree" required>
                            <label class="form-check-label" for="agree">
                                Tôi đồng ý với các chính sách và điều khoản
                            </label>
                        </div>


                        <!-- Submit -->
                        <input type="submit" value="Đăng ký" class="btn btn-block btn-primary">

                        <!-- Link to login -->
                        <p class="mt-3 text-center">
                            <a href="login_bo.jsp">Đăng nhập tài khoản</a>
                        </p>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="js/bootstrap.min.js"></script>
</body>
</html>
