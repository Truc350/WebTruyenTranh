package vn.edu.hcmuaf.fit.ltw_nhom5.controller.UserB;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.OrderDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ReviewDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Review;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderItem;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.CloudinaryService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/submit-review")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class SubmitReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            System.out.println("=== SUBMIT REVIEW ===");
            System.out.println("Order ID: " + orderId);
            System.out.println("User ID: " + user.getId());
            System.out.println("Rating: " + rating);
            System.out.println("Comment: " + comment);

            // Kiểm tra đã review chưa
            if (reviewDAO.hasUserReviewedOrder(user.getId(), orderId)) {
                response.getWriter().write("{\"success\":false,\"message\":\"Bạn đã đánh giá đơn hàng này rồi\"}");
                return;
            }

            // Lấy tất cả comic trong order
            List<OrderItem> items = orderDAO.getOrderItems(orderId);

            if (items.isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy sản phẩm trong đơn hàng\"}");
                return;
            }

            // Lấy danh sách ảnh từ request
            List<String> uploadedImageUrls = new ArrayList<>();

            // ✅ Sửa cách lấy Part - dùng getParts() thay vì vòng lặp request.getParts()
            for (Part part : request.getParts()) {
                String partName = part.getName();
                System.out.println("Part name: " + partName + ", size: " + part.getSize());

                if ("images".equals(partName) && part.getSize() > 0) {
                    try {
                        String imageUrl = CloudinaryService.uploadImage(part, "reviews");
                        if (imageUrl != null) {
                            uploadedImageUrls.add(imageUrl);
                            System.out.println("✓ Uploaded image: " + imageUrl);
                        }
                    } catch (Exception e) {
                        System.err.println("✗ Error uploading image: " + e.getMessage());
                    }
                }
            }

            System.out.println("Total uploaded images: " + uploadedImageUrls.size());

            // ✅ Tạo review cho từng comic và gán CÙNG ảnh cho tất cả review
            for (OrderItem item : items) {
                Review review = new Review();
                review.setComicId(item.getComicId());
                review.setUserId(user.getId());
                review.setRating(rating);
                review.setComment(comment);
                review.setOrderId(orderId);

                int reviewId = reviewDAO.addReview(review);
                System.out.println("Created review ID: " + reviewId + " for comic: " + item.getComicId() + " in order: " + orderId);

                // ✅ Thêm TẤT CẢ ảnh đã upload vào review này
                for (String imageUrl : uploadedImageUrls) {
                    boolean added = reviewDAO.addReviewImage(reviewId, imageUrl);
                    System.out.println("  " + (added ? "✓" : "✗") + " Added image to review: " + imageUrl);
                }
            }

            response.getWriter().write("{\"success\":true,\"message\":\"Đánh giá thành công\"}");

        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
            response.getWriter().write("{\"success\":false,\"message\":\"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            System.err.println("Error submitting review: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
}