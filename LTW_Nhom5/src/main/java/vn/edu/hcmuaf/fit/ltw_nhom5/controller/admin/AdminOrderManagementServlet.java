package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.OrderService;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/orders")
public class AdminOrderManagementServlet extends HttpServlet {
    private OrderService orderService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        System.out.println("========================================");
        System.out.println("=== AdminOrderManagementServlet INIT ===");
        System.out.println("========================================");
        try {
            orderService = new OrderService();
            gson = new Gson();
            System.out.println("✅ OrderService and Gson initialized successfully");
        } catch (Exception e) {
            System.out.println("❌ ERROR during init:");
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        System.out.println("Action parameter: " + action);
        String orderId = req.getParameter("orderId");
        try {
            if (action == null) {
                // Hiển thị trang quản lý đơn hàng
                displayOrderManagement(req, resp);
            } else {
                switch (action) {
                    case "detail":
                        System.out.println("➡️ Calling getOrderDetail...");
                        getOrderDetail(req, resp);
                        break;
                    case "search":
                        System.out.println("➡️ Calling searchOrders...");
                        searchOrders(req, resp);
                        break;
                    case "stats":
                        System.out.println("➡️ Calling getStatistics...");
                        getStatistics(req, resp);
                        break;
                    default:
                        System.out.println("➡️ Default: Calling displayOrderManagement...");
                        displayOrderManagement(req, resp);
                }
            }
            System.out.println("✅ doGet completed successfully");
        } catch (Exception e) {
            System.out.println("❌ ERROR in doGet:");
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        if (action == null) {
            sendJsonError(resp, "Missing action parameter");
            return;
        }

        try {
            Map<String, Object> result;

            switch (action) {
                case "confirm":
                    result = confirmOrder(req);
                    break;
                case "confirmAll":
                    result = confirmAllOrders(req);
                    break;
                case "cancel":
                    result = cancelOrder(req);
                    break;
                case "confirmShipped":
                    result = confirmShipped(req);
                    break;
                case "confirmDelivered":
                    result = confirmDelivered(req);
                    break;
                case "updateStatus":
                    result = updateOrderStatus(req);
                    break;
                case "processRefund":
                    result = processRefund(req);
                    break;
                default:
                    result = Map.of("success", false, "error", "Invalid action");
            }

            resp.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(resp, e.getMessage());
        }
    }

    /**
     * Hiển thị trang quản lý đơn hàng
     */
    private void displayOrderManagement(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // Lấy tất cả đơn hàng với chi tiết đầy đủ từ SERVICE
            Map<String, Object> data = orderService.getAllOrdersWithDetails();

            System.out.println("=== DEBUG ORDER MANAGEMENT ===");
            System.out.println("Success: " + data.get("success"));
            System.out.println("Error: " + data.get("error"));

            if ((Boolean) data.get("success")) {
                @SuppressWarnings("unchecked")
                Map<String, List<Map<String, Object>>> ordersByStatus =
                        (Map<String, List<Map<String, Object>>>) data.get("ordersByStatus");

                System.out.println("Pending orders: " + ordersByStatus.get("Pending").size());
                System.out.println("AwaitingPickup orders: " + ordersByStatus.get("AwaitingPickup").size());
                System.out.println("Shipping orders: " + ordersByStatus.get("Shipping").size());

                req.setAttribute("ordersByStatus", ordersByStatus);

                // Lấy thống kê
                Map<String, Object> stats = orderService.getOrderStatistics();
                req.setAttribute("stats", stats);

            } else {
                System.out.println("Failed to load orders: " + data.get("error"));
                req.setAttribute("error", data.get("error"));
            }

            // Forward tới JSP
            req.getRequestDispatcher("/fontend/admin/order.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception in displayOrderManagement: " + e.getMessage());
            req.setAttribute("error", "Lỗi khi tải danh sách đơn hàng: " + e.getMessage());
            req.getRequestDispatcher("/fontend/admin/order.jsp")
                    .forward(req, resp);
        }
    }

    /**
     * Lấy chi tiết đơn hàng
     */
    private void getOrderDetail(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            Map<String, Object> result = orderService.getOrderDetail(orderId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            sendJsonError(resp, "Invalid order ID");
        } catch (Exception e) {
            sendJsonError(resp, e.getMessage());
        }
    }

    /**
     * Tìm kiếm đơn hàng
     */
    private void searchOrders(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            String keyword = req.getParameter("keyword");
            String status = req.getParameter("status");

            List<Map<String, Object>> orders = orderService.searchOrders(keyword, status);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(gson.toJson(Map.of(
                    "success", true,
                    "orders", orders
            )));

        } catch (Exception e) {
            sendJsonError(resp, e.getMessage());
        }
    }

    /**
     * Lấy thống kê
     */
    private void getStatistics(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            Map<String, Object> stats = orderService.getOrderStatistics();

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(gson.toJson(Map.of(
                    "success", true,
                    "stats", stats
            )));

        } catch (Exception e) {
            sendJsonError(resp, e.getMessage());
        }
    }

    /**
     * Xác nhận TẤT CẢ đơn hàng đang ở trạng thái Pending
     */
    private Map<String, Object> confirmAllOrders(HttpServletRequest req) {
        try {
            // Lấy tất cả đơn hàng Pending từ service
            List<Map<String, Object>> pendingOrders = orderService.getOrdersWithDetailsByStatus("Pending");

            if (pendingOrders.isEmpty()) {
                return Map.of(
                        "success", false,
                        "message", "Không có đơn hàng nào cần xác nhận"
                );
            }

            int successCount = 0;
            int failCount = 0;
            List<String> errors = new ArrayList<>();

            // Duyệt qua tất cả đơn Pending và xác nhận
            for (Map<String, Object> order : pendingOrders) {
                try {
                    int orderId = (Integer) order.get("id");
                    Map<String, Object> result = orderService.confirmOrder(orderId, null);

                    if ((Boolean) result.get("success")) {
                        successCount++;
                    } else {
                        failCount++;
                        errors.add("Đơn #" + orderId + ": " + result.get("message"));
                    }
                } catch (Exception e) {
                    failCount++;
                    errors.add("Lỗi xử lý đơn: " + e.getMessage());
                }
            }

            // Tạo response
            Map<String, Object> response = new HashMap<>();
            response.put("success", successCount > 0);
            response.put("successCount", successCount);
            response.put("failCount", failCount);
            response.put("totalOrders", pendingOrders.size());

            if (successCount > 0 && failCount == 0) {
                response.put("message", "Đã xác nhận thành công " + successCount + " đơn hàng!");
            } else if (successCount > 0 && failCount > 0) {
                response.put("message", "Xác nhận thành công " + successCount + "/" + pendingOrders.size() + " đơn hàng");
                response.put("errors", errors);
            } else {
                response.put("message", "Không thể xác nhận đơn hàng nào. Vui lòng thử lại!");
                response.put("errors", errors);
            }

            return response;

        } catch (Exception e) {
            return Map.of(
                    "success", false,
                    "error", "Lỗi xử lý: " + e.getMessage()
            );
        }
    }

    /**
     * Xác nhận một đơn hàng
     */
    private Map<String, Object> confirmOrder(HttpServletRequest req) {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String shippingProvider = req.getParameter("shippingProvider");

            return orderService.confirmOrder(orderId, shippingProvider);

        } catch (NumberFormatException e) {
            return Map.of("success", false, "error", "Invalid order ID");
        }
    }

    /**
     * Hủy đơn hàng
     */
    private Map<String, Object> cancelOrder(HttpServletRequest req) {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String reason = req.getParameter("reason");

            return orderService.cancelOrder(orderId, reason);

        } catch (NumberFormatException e) {
            return Map.of("success", false, "error", "Invalid order ID");
        }
    }

    /**
     * Xác nhận đã giao cho ĐVVC
     */
    private Map<String, Object> confirmShipped(HttpServletRequest req) {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            return orderService.confirmShipped(orderId);

        } catch (NumberFormatException e) {
            return Map.of("success", false, "error", "Invalid order ID");
        }
    }

    /**
     * Xác nhận đã giao hàng thành công
     */
    private Map<String, Object> confirmDelivered(HttpServletRequest req) {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            return orderService.confirmDelivered(orderId);

        } catch (NumberFormatException e) {
            return Map.of("success", false, "error", "Invalid order ID");
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng
     */
    private Map<String, Object> updateOrderStatus(HttpServletRequest req) {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String newStatus = req.getParameter("status");

            return orderService.updateOrderStatus(orderId, newStatus);

        } catch (NumberFormatException e) {
            return Map.of("success", false, "error", "Invalid order ID");
        }
    }

    /**
     * Xử lý hoàn tiền
     */
    private Map<String, Object> processRefund(HttpServletRequest req) {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            return orderService.processRefund(orderId);

        } catch (NumberFormatException e) {
            return Map.of("success", false, "error", "Invalid order ID");
        }
    }

    /**
     * Gửi JSON error response
     */
    private void sendJsonError(HttpServletResponse resp, String message) throws IOException {
        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "error", message
        )));
    }
}