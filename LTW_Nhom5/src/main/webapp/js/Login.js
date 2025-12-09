
// //cái dưới là chuyển form đăng nhập đăng ký\
// document.getElementById("show-register").addEventListener("click", function (event) {
//   event.preventDefault();
//   document.querySelector(".container-signup").style.display = "none";
//   document.querySelector(".container-register").style.display = "block";
// });


// document.getElementById("show-login").addEventListener("click", function (event) {
//   event.preventDefault();
//   document.querySelector(".container-signup").style.display = "flex";
//   document.querySelector(".container-register").style.display = "none";
// });


// //cái này làm cho xác thực quên mật khẩu
// document.getElementById("show-forgot-pw").addEventListener("click", function (event) {
//   event.preventDefault();
//   document.querySelector(".container-signup").style.display = "none";
//   document.querySelector(".forgot-pd-container").style.display = "block";
// });



// //check xem phải là admin thì qua admin, còn không thì là user
// function login() {
//     const username = document.getElementById("nhapstk").value.trim();
//     const password = document.getElementById("nhapmk").value.trim();

//     // Giả định: tài khoản đúng là "ad" và mật khẩu cũng là "ad"
//     if (username === "adminlinhnguyen123@gmail.com" && password === "1234") {
//       console.log(username, password)
//       window.location.href ="../admin/dashboard.jsp";
//     } else {
//       window.location.href = "homePage.jsp";
//     }
//   }