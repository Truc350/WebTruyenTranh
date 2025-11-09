// cho truyện link qua trang detail.html
  document.addEventListener("DOMContentLoaded", function () {
    const product = document.querySelector("#clickon");
    product.addEventListener("click", function () {
      window.location.href = "detail.html";
    });
  });

// banner
const listImage = document.querySelector('.list-images'); 
const imgs = document.querySelectorAll('.list-images img'); 
const dots = document.querySelectorAll('.dot'); 
const btnPrev = document.querySelector('.btn.prev');
const btnNext = document.querySelector('.btn.next'); 

let index = 0;

function changeSlide(i) {
    let width = imgs[0].offsetWidth;
    listImage.style.transform = `translateX(${-width * i}px)`;
    document.querySelector('.dot.active').classList.remove('active');
    dots[i].classList.add('active');
}

setInterval(() => {
    index++;
    if (index >= imgs.length) index = 0;
    changeSlide(index);
}, 2000);

// Dots click
dots.forEach((dot, i) => {
    dot.addEventListener('click', () => {
        index = i;
        changeSlide(index);
    });
});

btnNext.addEventListener('click', () => {
    index++;
    if (index >= imgs.length) index = 0;
    changeSlide(index);
});

btnPrev.addEventListener('click', () => {
    index--;
    if (index < 0) index = imgs.length - 1;
    changeSlide(index);
});

// slider
document.querySelectorAll('.product-slider').forEach(slider => {
    const track = slider.querySelector('.slider-track');
    const prevBtn = slider.querySelector('.arrow.prev');
    const nextBtn = slider.querySelector('.arrow.next');
    const items = slider.querySelectorAll('.product-item');

    let currentPosition = 0;

    //Lấy đúng kích thước 1 item thực tế (bao gồm margin/gap)
    const itemWidth = items[0].offsetWidth + 10; // 10 = gap trong CSS
    const visibleItems = 5;

    // Tính toán vị trí tối đa KHÔNG bị trống
    const maxPosition = -((items.length * itemWidth) - (itemWidth * visibleItems));

    // 🔹 Khi nhấn nút next
    nextBtn.addEventListener('click', () => {
        if (currentPosition > maxPosition) {
            currentPosition -= itemWidth;
            // Dịch chuyển đúng khoảng cần thiết
            track.style.transform = `translateX(${currentPosition}px)`;
        }
    });

    //Khi nhấn nút prev
    prevBtn.addEventListener('click', () => {
        if (currentPosition < 0) {
            currentPosition += itemWidth;
            track.style.transform = `translateX(${currentPosition}px)`;
        }
    });
});


//cái này click qua trang hành động
  document.getElementById("actionLink").addEventListener("click", function(event) {
    event.preventDefault(); // chặn hành vi mặc định của thẻ a
    window.location.href = "CatagoryPage.html";
});