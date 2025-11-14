 document.getElementById("loginBtn").addEventListener("click", function() {
    window.location.href = "homePage.html"; 
  });



  //cái dưới là chuyển form đăng nhập đăng ký\
  document.getElementById("show-register").addEventListener("click", function(event) {
    event.preventDefault(); 
    document.querySelector(".container-signup").style.display = "none";
    document.querySelector(".container-register").style.display = "block";
  });
  
  
  document.getElementById("show-login").addEventListener("click", function(event) {
    event.preventDefault(); 
    document.querySelector(".container-signup").style.display = "flex";
    document.querySelector(".container-register").style.display = "none";
  });