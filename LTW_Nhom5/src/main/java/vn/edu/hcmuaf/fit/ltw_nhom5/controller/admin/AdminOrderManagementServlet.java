package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.OrderService;
import com.google.gson.Gson;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.gson.GsonConfig;

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

        try {
            orderService = new OrderService();
            gson = GsonConfig.getGson();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if (action == null) {
                displayOrderManagement(req, resp);
            } else {
                switch (action) {
                    case "detail":
                        getOrderDetail(req, resp);
                        break;
                    case "search":
                        // Tìm kiếm cũ (có thể giữ lại hoặc xóa)
                        searchOrders(req, resp);
                        break;
                    case "searchByTab":
                        // Tìm kiếm mới theo tab
                        searchOrdersByTab(req, resp);
                        break;
                    case "stats":
                        getStatistics(req, resp);
                        break;
                    default:
                        displayOrderManagement(req, resp);
                }
            }
        } catch (Exception e) {
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
                    result = updateOrderStatusWithSync(req);
                    break;
                case "processRefund":
                    result = processRefund(req);
                    break;
                case "confirmRefund":
                    result = handleConfirmRefund(req);
                    break;
                case "rejectRefund":
                    result = handleRejectRefund(req);
                    break;
                case "searchReturns":
                    result = handleSearchReturns(req);
                    break;
                case "getReturnDetail":
                    result = handleGetReturnDetail(req);
                    break;
                default:
                    result = Map.of("success", false, "error", "Invalid action");
            }

            // ✅ GHI RESPONSE VỚI GSON ĐÃ CONFIG
            resp.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(resp, e.getMessage());
        }
    }

    private Map<String, Object> handleGetReturnDetail(HttpServletRequest req) {
        try {
            int returnId = Integer.parseInt(req.getParameter("returnId"));

            System.out.println("📋 Getting return detail for ID: " + returnId);

            return orderService.getReturnDetail(returnId);

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid return ID format");
            return Map.of("success", false, "error", "Invalid return ID");
        } catch (Exception e) {
            System.err.println("❌ Error getting return detail: " + e.getMessage());
            e.printStackTrace();
            return Map.of("success", false, "error", e.getMessage());
        }
    }

    private Map<String, Object> handleSearchReturns(HttpServletRequest req) {
        try {
            String keyword = req.getParameter("keyword");
            if (keyword == null) keyword = "";

            System.out.println("🔍 Searching returns with keyword: '" + keyword + "'");

            List<Map<String, Object>> returns = orderService.searchReturns(keyword);

            System.out.println("✅ Found " + returns.size() + " return orders");

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("returns", returns);
            result.put("count", returns.size());

            return result;

        } catch (Exception e) {
            System.err.println("❌ Error searching returns: " + e.getMessage());
            e.printStackTrace();
            return Map.of("success", false, "error", e.getMessage());
        }
    }

    private Map<String, Object> handleRejectRefund(HttpServletRequest req) {
        try {
            int returnId = Integer.parseInt(req.getParameter("returnId"));
            String rejectReason = req.getParameter("reason");

            System.out.println("🔄 Rejecting refund for return ID: " + returnId);
            System.out.println("   Reason: " + rejectReason);

            Map<String, Object> result = orderService.rejectRefund(returnId, rejectReason);

            System.out.println("✅ Reject refund result: " + result.get("success"));

            return result;

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid return ID format");
            return Map.of("success", false, "error", "Invalid return ID");
        } catch (Exception e) {
            System.err.println("❌ Error rejecting refund: " + e.getMessage());
            e.printStackTrace();
            return Map.of("success", false, "error", e.getMessage());
        }
    }

    private Map<String, Object> handleConfirmRefund(HttpServletRequest req) {
        try {
            int returnId = Integer.parseInt(req.getParameter("returnId"));

            System.out.println("🔄 Confirming refund for return ID: " + returnId);

            Map<String, Object> result = orderService.confirmRefund(returnId);

            System.out.println("✅ Confirm refund result: " + result.get("success"));

            return result;

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid return ID format");
            return Map.of("success", false, "error", "Invalid return ID");
        } catch (Exception e) {
            System.err.println("❌ Error confirming refund: " + e.getMessage());
            e.printStackTrace();
            return Map.of("success", false, "error", e.getMessage());
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


            if ((Boolean) data.get("success")) {
                @SuppressWarnings("unchecked")
                Map<String, List<Map<String, Object>>> ordersByStatus =
                        (Map<String, List<Map<String, Object>>>) data.get("ordersByStatus");

                req.setAttribute("ordersByStatus", ordersByStatus);

                // ===== THÊM DỮ LIỆU TRẢ HÀNG/HOÀN TIỀN =====
                List<Map<String, Object>> returnOrders = orderService.getAllReturnsWithDetails();
                ordersByStatus.put("Returns", returnOrders);

                System.out.println("✅ Loaded " + returnOrders.size() + " return orders");

                // Lấy thống kê
                Map<String, Object> stats = orderService.getOrderStatistics();
                req.setAttribute("stats", stats);

            } else {
                req.setAttribute("error", data.get("error"));
            }

            // Forward tới JSP
            req.getRequestDispatcher("/fontend/admin/order.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
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

    /**
     * Tìm kiếm đơn hàng theo tab cụ thể
     * Thêm vào method doGet của AdminOrderManagementServlet
     */
    private void searchOrdersByTab(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        //SET CONTENT TYPE NGAY TỪ ĐẦU - TRƯỚC KHI XỬ LÝ BẤT KỲ LOGIC NÀO
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // THÊM HEADER ĐỂ TRÁNH CACHE
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Expires", "0");

        try {
            String keyword = req.getParameter("keyword");
            String status = req.getParameter("status");

            // VALIDATE INPUT
            if (status == null || status.isEmpty()) {
                resp.getWriter().write(gson.toJson(Map.of(
                        "success", false,
                        "error", "Missing status parameter"
                )));
                return;
            }

            // XỬ LÝ KEYWORD NULL
            if (keyword == null) {
                keyword = "";
            }

            List<Map<String, Object>> orders;

            // SWITCH CASE VỚI LOG
            switch (status) {
                case "Pending":
                    System.out.println("→ Searching Pending orders...");
                    orders = orderService.searchPendingOrders(keyword);
                    break;
                case "AwaitingPickup":
                    System.out.println("→ Searching AwaitingPickup orders...");
                    orders = orderService.searchAwaitingPickupOrders(keyword);
                    break;
                case "Shipping":
                    System.out.println("→ Searching Shipping orders...");
                    orders = orderService.searchShippingOrders(keyword);
                    break;
                case "Completed":
                    System.out.println("→ Searching Completed orders...");
                    orders = orderService.searchCompletedOrders("");
                    break;
                case "Returned":
                    System.out.println("→ Searching Returned orders...");
                    orders = orderService.searchReturnedOrders(keyword);
                    break;
                case "Cancelled":
                    System.out.println("→ Searching Cancelled orders...");
                    orders = orderService.searchCancelledOrders(keyword);
                    break;
                default:
                    System.err.println("❌ Invalid status: " + status);
                    orders = new ArrayList<>();
            }

            // TẠO RESPONSE
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("orders", orders);
            response.put("count", orders.size());

            // CONVERT TO JSON VÀ GHI RESPONSE
            String jsonResponse = gson.toJson(response);

            resp.getWriter().write(jsonResponse);
            resp.getWriter().flush();

        } catch (Exception e) {
            //  XỬ LÝ LỖI AN TOÀN
            System.err.println("❌ ERROR in searchOrdersByTab:");
            e.printStackTrace();

            // ĐẢM BẢO RESPONSE VẪN LÀ JSON
            try {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("error", e.getMessage() != null ? e.getMessage() : "Unknown error");
                errorResponse.put("errorType", e.getClass().getSimpleName());

                resp.getWriter().write(gson.toJson(errorResponse));
                resp.getWriter().flush();
            } catch (IOException ioException) {
                System.err.println("Failed to send error response:");
                ioException.printStackTrace();
            }
        }
    }

    private Map<String, Object> updateOrderStatusWithSync(HttpServletRequest req) {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String newStatus = req.getParameter("status");

            // Sử dụng OrderService.updateOrderStatusAndSync
            boolean success = orderService.updateOrderStatusAndSync(orderId, newStatus);

            if (success) {
                return Map.of(
                        "success", true,
                        "message", "Đã cập nhật trạng thái đơn hàng"
                );
            } else {
                return Map.of(
                        "success", false,
                        "message", "Cập nhật thất bại"
                );
            }

        } catch (NumberFormatException e) {
            return Map.of("success", false, "error", "Invalid order ID");
        } catch (Exception e) {
            return Map.of("success", false, "error", e.getMessage());
        }
    }
}