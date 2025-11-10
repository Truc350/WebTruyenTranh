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