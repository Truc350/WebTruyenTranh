package vn.edu.hcmuaf.fit.ltw_nhom5.controller.UserB;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.OrderDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.*;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "BuyAgain", value = "/buy-again")
public class BuyAgainServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Kiểm tra đăng nhập
        if (currentUser == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Vui lòng đăng nhập!\"}");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            System.out.println("===== MUA LẠI ĐơN HÀNG #" + orderId + " =====");

            // Lấy giỏ hàng từ session
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }

            // Lấy danh sách sản phẩm trong đơn hàng
            OrderDAO orderDAO = new OrderDAO();
            ComicDAO comicDAO = new ComicDAO();

            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);

            int addedCount = 0;
            int outOfStockCount = 0;
            StringBuilder errorMsg = new StringBuilder();

            for (OrderItem item : orderItems) {
                Comic comic = comicDAO.getComicById(item.getComicId());

                if (comic == null) {
                    System.out.println("✗ Comic ID " + item.getComicId() + " không tồn tại");
                    continue;
                }

                // Kiểm tra tồn kho
                CartItem existingItem = cart.get(comic.getId());
                int currentQtyInCart = (existingItem != null) ? existingItem.getQuantity() : 0;
                int requestedQty = item.getQuantity();
                int totalQty = currentQtyInCart + requestedQty;

                if (comic.getStockQuantity() < totalQty) {
                    System.out.println("✗ " + comic.getNameComics() +
                            " - Không đủ hàng (còn " + comic.getStockQuantity() +
                            ", yêu cầu " + totalQty + ")");
                    outOfStockCount++;
                    errorMsg.append(comic.getNameComics())
                            .append(" (chỉ còn ")
                            .append(comic.getStockQuantity())
                            .append("), ");
                    continue;
                }

                // Thêm vào giỏ hàng
                cart.addItem(comic, requestedQty);
                addedCount++;
                System.out.println("✓ Đã thêm " + comic.getNameComics() +
                        " x" + requestedQty);
            }

            // Lưu lại giỏ hàng
            session.setAttribute("cart", cart);

            System.out.println("Kết quả: Thêm " + addedCount + "/" + orderItems.size() +
                    " sản phẩm");
            System.out.println("=======================================");

            // Tạo response
            Map<String, Object> result = new HashMap<>();

            if (addedCount > 0) {
                result.put("success", true);
                result.put("addedCount", addedCount);
                result.put("totalItems", orderItems.size());

                if (outOfStockCount > 0) {
                    result.put("message", "Đã thêm " + addedCount + " sản phẩm vào giỏ hàng. " +
                            outOfStockCount + " sản phẩm không đủ hàng: " +
                            errorMsg.toString().replaceAll(", $", ""));
                } else {
                    result.put("message", "Đã thêm tất cả " + addedCount +
                            " sản phẩm vào giỏ hàng!");
                }
            } else {
                result.put("success", false);
                result.put("message", "Không thể thêm sản phẩm nào. Vui lòng kiểm tra lại!");
            }

            // Trả về JSON
            Gson gson = new Gson();
            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"Dữ liệu không hợp lệ!\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi hệ thống: " +
                    e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}