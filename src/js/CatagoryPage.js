let currentPage = 1;
let totalPages = document.querySelectorAll('.page').length;

function changePage(page) {
  currentPage = page;

  document.querySelectorAll('.page').forEach(p => p.style.display = 'none');
  document.querySelector(`.page[data-page="${page}"]`).style.display = 'flex';

  document.querySelectorAll('nav[aria-label="Phân trang"] a').forEach(a => a.classList.remove('active'));
  document.getElementById(`page-${page}`).classList.add('active');
}

function nextPage() {
  if (currentPage < totalPages) {
    changePage(currentPage + 1);
  }
}

function prevPage() {
  if (currentPage > 1) {
    changePage(currentPage - 1);
  }
}

// Mặc định hiển thị trang 1
changePage(1);


//slider
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