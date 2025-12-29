//banner
document.addEventListener("DOMContentLoaded", function () {
    const banner = document.querySelector('.banner');
    const listImage = document.querySelector('.list-images');
    const imgs = document.querySelectorAll('.list-images img');
    const dots = document.querySelectorAll('.dot');
    const btnPrev = document.querySelector('.banner .btn.prev');
    const btnNext = document.querySelector('.banner .btn.next');

    if (!banner || imgs.length === 0) return;

    let index = 0;
    let interval;

    function updateSlider() {
        const width = banner.clientWidth;  // luôn lấy mới, chính xác
        listImage.style.transform = `translateX(${-width * index}px)`;

        dots.forEach((dot, i) => {
            dot.classList.toggle('active', i === index);
        });
    }

    function nextSlide() {
        index = (index + 1) % imgs.length;
        updateSlider();
    }

    function prevSlide() {
        index = (index - 1 + imgs.length) % imgs.length;
        updateSlider();
    }

    // Auto play
    interval = setInterval(nextSlide, 3000);

    // Nút
    if (btnNext) btnNext.addEventListener('click', () => {
        nextSlide();
        clearInterval(interval);
        interval = setInterval(nextSlide, 3000);
    });

    if (btnPrev) btnPrev.addEventListener('click', () => {
        prevSlide();
        clearInterval(interval);
        interval = setInterval(nextSlide, 3000);
    });

    // Dot click
    dots.forEach((dot, i) => {
        dot.addEventListener('click', () => {
            index = i;
            updateSlider();
            clearInterval(interval);
            interval = setInterval(nextSlide, 3000);
        });
    });

    // Quan trọng: resize cửa sổ + chờ ảnh load
    window.addEventListener('resize', updateSlider);

    // Chờ tất cả ảnh load xong mới start (tránh width sai ban đầu)
    let loaded = 0;
    imgs.forEach(img => {
        if (img.complete) loaded++;
        else img.addEventListener('load', () => { loaded++; if (loaded === imgs.length) updateSlider(); });
    });

    if (loaded === imgs.length) updateSlider();
    else imgs.forEach(img => img.addEventListener('load', () => { if (++loaded === imgs.length) { updateSlider(); interval = setInterval(nextSlide, 3000); } }));
});





//slider
document.addEventListener("DOMContentLoaded", function () {
    const sliders = document.querySelectorAll('.product-slider');

    sliders.forEach(slider => {
        const track = slider.querySelector('.slider-track');
        const prevBtn = slider.querySelector('.arrow.prev');
        const nextBtn = slider.querySelector('.arrow.next');
        const items = slider.querySelectorAll('.product-item');

        let currentPosition = 0;

        function recalc() {
            const itemWidth = items[0].offsetWidth + 10; // khoảng cách giữa các item
            const totalItems = items.length;
            const trackWidth = totalItems * itemWidth;
            const containerWidth = slider.offsetWidth;
            const maxPosition = containerWidth - trackWidth;
            return { itemWidth, maxPosition };
        }

        function moveSlider(position) {
            track.style.transform = `translateX(${position}px)`;
        }

        // Nút prev
        prevBtn.addEventListener('click', () => {
            const { itemWidth } = recalc();
            currentPosition += itemWidth;
            if (currentPosition > 0) currentPosition = 0; // không vượt quá đầu
            moveSlider(currentPosition);
        });

        // Nút next
        nextBtn.addEventListener('click', () => {
            const { itemWidth, maxPosition } = recalc();
            currentPosition -= itemWidth;
            if (currentPosition < maxPosition) currentPosition = maxPosition; // không vượt quá cuối
            moveSlider(currentPosition);
        });

        // Khởi tạo
        moveSlider(currentPosition);
    });

    document.getElementById("more-btn-popup-slider").addEventListener("click", function () {
         document.querySelector("#product-slider-popup").style.display = "block";

});

});


// // top truyện
// document.getElementById("item-pop-1").addEventListener("mouseover", function () {
//     document.querySelector(".pop-detail-home1").style.display = "flex";
//     document.querySelector(".pop-detail-home2").style.display = "none";
//     document.querySelector(".pop-detail-home3").style.display = "none";
//     document.querySelector(".pop-detail-home4").style.display = "none";
//     document.querySelector(".pop-detail-home5").style.display = "none";
// });
//
// document.getElementById("item-pop-2").addEventListener("mouseover", function () {
//     document.querySelector(".pop-detail-home2").style.display = "flex";
//     document.querySelector(".pop-detail-home1").style.display = "none";
//     document.querySelector(".pop-detail-home3").style.display = "none";
//     document.querySelector(".pop-detail-home4").style.display = "none";
//     document.querySelector(".pop-detail-home5").style.display = "none";
// });
//
// document.getElementById("item-pop-3").addEventListener("mouseover", function () {
//     document.querySelector(".pop-detail-home3").style.display = "flex";
//     document.querySelector(".pop-detail-home1").style.display = "none";
//     document.querySelector(".pop-detail-home2").style.display = "none";
//     document.querySelector(".pop-detail-home4").style.display = "none";
//     document.querySelector(".pop-detail-home5").style.display = "none";
// });
//
// document.getElementById("item-pop-4").addEventListener("mouseover", function () {
//     document.querySelector(".pop-detail-home4").style.display = "flex";
//     document.querySelector(".pop-detail-home1").style.display = "none";
//     document.querySelector(".pop-detail-home2").style.display = "none";
//     document.querySelector(".pop-detail-home3").style.display = "none";
//     document.querySelector(".pop-detail-home5").style.display = "none";
// });
// document.getElementById("item-pop-5").addEventListener("mouseover", function () {
//     document.querySelector(".pop-detail-home5").style.display = "flex";
//     document.querySelector(".pop-detail-home1").style.display = "none";
//     document.querySelector(".pop-detail-home2").style.display = "none";
//     document.querySelector(".pop-detail-home3").style.display = "none";
//     document.querySelector(".pop-detail-home4").style.display = "none";
// });
//
//
// document.getElementById("more-btn-popup-slider").addEventListener("click", function () {
//     document.querySelector("#product-slider-popup").style.display = "block";
//
// });

