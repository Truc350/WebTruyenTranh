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


// phần này của slider
// 🔽 Lấy phần tử cần dùng
const track = document.querySelector('.slider-track');
const prevBtn = document.querySelector('.arrow.prev');
const nextBtn = document.querySelector('.arrow.next');

// 🔽 Biến để lưu vị trí hiện tại
let currentPosition = 0;
const itemWidth = 220; // mỗi item 200px + gap 20px
const visibleItems = 5; // số lượng item hiển thị trong khung

// 🔽 Khi nhấn nút next
nextBtn.addEventListener('click', () => {
    const totalItems = document.querySelectorAll('.product-item').length;
    const maxPosition = -(itemWidth * (totalItems - visibleItems));

    if (currentPosition > maxPosition) {
        currentPosition -= itemWidth;
        track.style.transform = `translateX(${currentPosition}px)`;
    }
});

// 🔽 Khi nhấn nút prev
prevBtn.addEventListener('click', () => {
    if (currentPosition < 0) {
        currentPosition += itemWidth;
        track.style.transform = `translateX(${currentPosition}px)`;
    }
});