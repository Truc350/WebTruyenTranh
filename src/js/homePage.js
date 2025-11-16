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

    // Kích thước 1 item + khoảng cách giữa các item
    const itemWidth = items[0].offsetWidth + 10; // 10 = gap
    const totalItems = items.length;

    // Tổng chiều rộng của toàn bộ track
    const trackWidth = totalItems * itemWidth;

    // Chiều rộng của vùng hiển thị slider
    const containerWidth = slider.offsetWidth;

    // Vị trí trượt tối đa (âm)
    const maxPosition = containerWidth - trackWidth;

    // Xử lý nút next
    nextBtn.addEventListener('click', () => {
        if (currentPosition > maxPosition) {
            currentPosition -= itemWidth;

            // Giới hạn không vượt quá maxPosition
            if (currentPosition < maxPosition) {
                currentPosition = maxPosition;
            }

            track.style.transform = `translateX(${currentPosition}px)`;
        }
    });

    // Xử lý nút prev
    prevBtn.addEventListener('click', () => {
        if (currentPosition < 0) {
            currentPosition += itemWidth;

            // Giới hạn không vượt quá 0
            if (currentPosition > 0) {
                currentPosition = 0;
            }

            track.style.transform = `translateX(${currentPosition}px)`;
        }
    })
});


//cái này click qua trang hành động
// document.getElementById("actionLink").addEventListener("click", function (event) {
//     event.preventDefault(); 
//     window.location.href = "CatagoryPage.html";
// });

//cái này cho top truyện 
document.getElementById("item-pop-1").addEventListener("mouseover", function () {
    document.querySelector(".pop-detail-home1").style.display = "flex";
    document.querySelector(".pop-detail-home2").style.display = "none";
    document.querySelector(".pop-detail-home3").style.display = "none";
    document.querySelector(".pop-detail-home4").style.display = "none";
    document.querySelector(".pop-detail-home5").style.display = "none";
});

document.getElementById("item-pop-2").addEventListener("mouseover", function () {
    document.querySelector(".pop-detail-home2").style.display = "flex";
    document.querySelector(".pop-detail-home1").style.display = "none";
    document.querySelector(".pop-detail-home3").style.display = "none";
    document.querySelector(".pop-detail-home4").style.display = "none";
    document.querySelector(".pop-detail-home5").style.display = "none";
});

document.getElementById("item-pop-3").addEventListener("mouseover", function () {
    document.querySelector(".pop-detail-home3").style.display = "flex";
    document.querySelector(".pop-detail-home1").style.display = "none";
    document.querySelector(".pop-detail-home2").style.display = "none";
    document.querySelector(".pop-detail-home4").style.display = "none";
    document.querySelector(".pop-detail-home5").style.display = "none";
});

document.getElementById("item-pop-4").addEventListener("mouseover", function () {
    document.querySelector(".pop-detail-home4").style.display = "flex";
    document.querySelector(".pop-detail-home1").style.display = "none";
    document.querySelector(".pop-detail-home2").style.display = "none";
    document.querySelector(".pop-detail-home3").style.display = "none";
    document.querySelector(".pop-detail-home5").style.display = "none";
});
document.getElementById("item-pop-5").addEventListener("mouseover", function () {
    document.querySelector(".pop-detail-home5").style.display = "flex";
    document.querySelector(".pop-detail-home1").style.display = "none";
    document.querySelector(".pop-detail-home2").style.display = "none";
    document.querySelector(".pop-detail-home3").style.display = "none";
    document.querySelector(".pop-detail-home4").style.display = "none";
});
