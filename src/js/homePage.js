// slider-show 
const listImage = document.querySelector('.list-images'); 
const imgs = document.querySelectorAll('.list-images img'); 

let index = 0;

setInterval(() => {
    index++;
    if (index >= imgs.length) index = 0;

    let width = imgs[0].offsetWidth;
    listImage.style.transform = `translateX(${-width * index}px)`;
}, 2000);