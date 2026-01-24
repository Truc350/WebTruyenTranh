package vn.edu.hcmuaf.fit.ltw_nhom5.controller.UserB;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.OrderDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.OrderReturnDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderReturn;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderItem;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.CloudinaryService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/submit-return")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class SubmitReturnServlet extends HttpServlet {
    private OrderReturnDAO orderReturnDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderReturnDAO = new OrderReturnDAO();
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
            String reason = request.getParameter("reason");

            System.out.println("=== SUBMIT RETURN ===");
            System.out.println("Order ID: " + orderId);
            System.out.println("User ID: " + user.getId());
            System.out.println("Reason: " + reason);

            // Lấy tất cả sản phẩm trong đơn hàng
            List<OrderItem> items = orderDAO.getOrderItems(orderId);

            if (items.isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy sản phẩm trong đơn hàng\"}");
                return;
            }

            // Lấy danh sách ảnh từ request
            List<String> uploadedImageUrls = new ArrayList<>();

            for (Part part : request.getParts()) {
                String partName = part.getName();
                System.out.println("Part name: " + partName + ", size: " + part.getSize());

                if ("images".equals(partName) && part.getSize() > 0) {
                    try {
                        String imageUrl = CloudinaryService.uploadImage(part, "returns");
                        if (imageUrl != null) {
                            uploadedImageUrls.add(imageUrl);
                            System.out.println("✓ Uploaded return image: " + imageUrl);
                        }
                    } catch (Exception e) {
                        System.err.println("✗ Error uploading return image: " + e.getMessage());
                    }
                }
            }

            System.out.println("Total uploaded images: " + uploadedImageUrls.size());

            // Tạo yêu cầu trả hàng cho từng sản phẩm
            for (OrderItem item : items) {
                OrderReturn orderReturn = new OrderReturn();
                orderReturn.setOrderId(orderId);
                orderReturn.setComicId(item.getComicId());
                orderReturn.setQuantity(item.getQuantity());
                orderReturn.setReason(reason);
                orderReturn.setRefundAmount(item.getPriceAtPurchase() * item.getQuantity());
                orderReturn.setStatus("Pending"); // Chờ xử lý

                int returnId = orderReturnDAO.addOrderReturn(orderReturn);
                System.out.println("Created return ID: " + returnId + " for comic: " + item.getComicId());

                // Thêm ảnh vào order_return
                for (String imageUrl : uploadedImageUrls) {
                    boolean added = orderReturnDAO.addReturnImage(returnId, imageUrl);
                    System.out.println("  " + (added ? "✓" : "✗") + " Added image to return: " + imageUrl);
                }
            }

            // Cập nhật trạng thái đơn hàng thành "Returned"
            boolean updated = orderDAO.updateOrderStatus(orderId, "Returned");

            if (updated) {
                response.getWriter().write("{\"success\":true,\"message\":\"Yêu cầu trả hàng thành công\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Không thể cập nhật trạng thái đơn hàng\"}");
            }

        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
            response.getWriter().write("{\"success\":false,\"message\":\"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            System.err.println("Error submitting return: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
}