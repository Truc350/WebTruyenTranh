// // Hàm nhúng footer từ file footer.html
// function loadFooter() {
//     // Sử dụng fetch để lấy nội dung từ footer.html
//     fetch('../footer.html')
//         .then(response => response.text())
//         .then(html => {
//             // Tạo một phần tử tạm để chứa nội dung footer
//             const tempDiv = document.createElement('div');
//             tempDiv.innerHTML = html;

//             // Lấy phần tử footer từ nội dung tải về
//             const footer = tempDiv.querySelector('footer');

//             // Thêm footer vào cuối body
//             document.body.appendChild(footer);
//         })
//         .catch(error => console.error('Lỗi khi tải footer:', error));
// }

// // Gọi hàm khi trang được tải
// document.addEventListener('DOMContentLoaded', loadFooter);