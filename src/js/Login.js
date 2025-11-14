
//cái dưới là chuyển form đăng nhập đăng ký\
document.getElementById("show-register").addEventListener("click", function (event) {
  event.preventDefault();
  document.querySelector(".container-signup").style.display = "none";
  document.querySelector(".container-register").style.display = "block";
});


document.getElementById("show-login").addEventListener("click", function (event) {
  event.preventDefault();
  document.querySelector(".container-signup").style.display = "flex";
  document.querySelector(".container-register").style.display = "none";
});


//cái này làm cho xác thực quên mật khẩu
document.getElementById("show-forgot-pw").addEventListener("click", function (event) {
  event.preventDefault();
  document.querySelector(".container-signup").style.display = "none";
  document.querySelector(".forgot-pd-container").style.display = "block";
});