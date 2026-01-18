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
        <div class="bg order-1 order-md-2"
             style="background-image: url(${pageContext.request.contextPath}/img/anhLogin.png);"></div>


        <div class="container">
                <div class="row align-items-center justify-content-center">
                    <div class="col-md-7">
                        <h3><strong>Xác thực email</strong></h3>
                        <p class="mb-4">Nhập email để lấy mã xác thực và đặt lại mật khẩu mới.</p>

                        <form action="${pageContext.request.contextPath}/ForgotPasswordServlet" method="post">
                            <!-- Email -->
                            <div class="form-group first">
                                <label for="email">Email</label>
                                <input type="email" class="form-control" placeholder="Địa chỉ gmail" id="email" name="email"
                                       value="${enteredEmail}" required>
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

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.querySelector("form");
        const newPasswordInput = document.getElementById("newPassword");

        form.addEventListener("submit", function (event) {
            // chỉ kiểm tra khi action là resetPassword
            const action = event.submitter ? event.submitter.value : null;
            if (action === "resetPassword") {
                const password = newPasswordInput.value;

                // Regex kiểm tra: ít nhất 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt
                const regex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

                if (!regex.test(password)) {
                    event.preventDefault(); // chặn submit
                    alert("Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
                    newPasswordInput.value = ""; // reset ô nhập mật khẩu
                }
            }
        });
    });
</script>



<%--<script src="js/jquery-3.3.1.min.js"></script>--%>
<%--<script src="js/popper.min.js"></script>--%>
<%--<script src="js/bootstrap.min.js"></script>--%>
<%--<script src="js/main.js"></script>--%>
</body>
</html>