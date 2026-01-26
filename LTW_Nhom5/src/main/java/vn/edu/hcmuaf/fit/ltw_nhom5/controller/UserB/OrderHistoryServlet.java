package vn.edu.hcmuaf.fit.ltw_nhom5.controller.UserB;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.OrderDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ReviewDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleComicsDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Order;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderItem;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.OrderViolationService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private ComicDAO comicDAO;
    private ReviewDAO reviewDAO;
    private FlashSaleComicsDAO flashSaleComicsDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        comicDAO = new ComicDAO();
        reviewDAO = new ReviewDAO();
        flashSaleComicsDAO = new FlashSaleComicsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("========== ORDER HISTORY DEBUG ==========");
        System.out.println("User: " + user.getUsername() + " (ID: " + user.getId() + ")");

        // Lấy filter từ parameter
        String filter = request.getParameter("filter");
        if (filter == null || filter.isEmpty()) {
            filter = "completed"; // Mặc định
        }
        System.out.println("Filter: " + filter);

        // Map filter sang status
        String dbStatus = mapFilterToStatus(filter);
        System.out.println("DB Status: " + dbStatus);

        // Lấy tất cả đơn hàng của user
        List<Order> allOrders = orderDAO.getOrdersByUserId(user.getId());
        System.out.println("Total orders: " + allOrders.size());

        // Filter theo status
        List<Order> filteredOrders;
        if ("all".equals(filter)) {
            filteredOrders = allOrders;
        } else {
            filteredOrders = allOrders.stream()
                    .filter(o -> o.getStatus().equals(dbStatus))
                    .collect(java.util.stream.Collectors.toList());
        }
        System.out.println("Filtered orders: " + filteredOrders.size());

        // NumberFormat để format giá
        NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));

        // Lấy thông tin chi tiết
        List<Map<String, Object>> orderDetails = new ArrayList<>();

        for (Order order : filteredOrders) {
            System.out.println("\n--- Order #" + order.getId() + " ---");
            System.out.println("Date: " + order.getOrderDate());
            System.out.println("Status: " + order.getStatus());
            System.out.println("Total: " + order.getTotalAmount());

            Map<String, Object> orderData = new HashMap<>();
            orderData.put("order", order);

            // Kiểm tra đã review chưa
            boolean hasReviewed = reviewDAO.hasUserReviewedOrder(user.getId(), order.getId());
            orderData.put("hasReviewed", hasReviewed);
            System.out.println("Has reviewed: " + hasReviewed);

            // Lấy order items
            List<OrderItem> items = orderDAO.getOrderItems(order.getId());
            System.out.println("Items count: " + items.size());

            List<Map<String, Object>> itemsWithComics = new ArrayList<>();

            for (OrderItem item : items) {
                System.out.println("  Item - Comic ID: " + item.getComicId() +
                        ", Qty: " + item.getQuantity() +
                        ", Price: " + item.getPriceAtPurchase());

                Map<String, Object> itemData = new HashMap<>();
                itemData.put("item", item);

                Comic comic = comicDAO.getComicById(item.getComicId());
                System.out.println("item.getComicId() " + item.getComicId());

                if (comic != null) {
                    System.out.println("    ✓ Comic found: " + comic.getNameComics());
                    System.out.println("      Thumbnail: " + comic.getThumbnailUrl());
                    itemData.put("comic", comic);

                    // ===== THÊM LOGIC XỬ LÝ GIÁ =====
                    double priceAtPurchase = item.getPriceAtPurchase();
                    double currentPrice = comic.getDiscountPrice();

                    // Format giá đã mua
                    itemData.put("formattedPriceAtPurchase", currencyFormat.format(priceAtPurchase));

                    // Kiểm tra có Flash Sale không
                    Map<String, Object> flashSaleInfo = flashSaleComicsDAO.getFlashSaleInfoByComicId(comic.getId());

                    if (flashSaleInfo != null) {
                        // ⚡ Có Flash Sale
                        Object discountObj = flashSaleInfo.get("discount_percent");
                        Double discountPercent = (discountObj instanceof Number)
                                ? ((Number) discountObj).doubleValue()
                                : null;

                        if (discountPercent != null) {
                            double flashSalePrice = comic.getPrice() * (1 - discountPercent / 100.0);

                            itemData.put("hasActiveFlashSale", true);
                            itemData.put("flashSaleDiscount", discountPercent.intValue());
                            itemData.put("formattedDisplayPrice", currencyFormat.format(flashSalePrice));
                            itemData.put("priceChanged", Math.abs(priceAtPurchase - flashSalePrice) > 0.01);

                            System.out.println("      ⚡ Flash Sale: " + discountPercent + "%");
                            System.out.println("      Flash Sale price: " + currencyFormat.format(flashSalePrice) + "đ");
                        }
                    } else {
                        // ℹ️ Không có Flash Sale
                        itemData.put("hasActiveFlashSale", false);
                        itemData.put("formattedDisplayPrice", currencyFormat.format(currentPrice));
                        itemData.put("priceChanged", Math.abs(priceAtPurchase - currentPrice) > 0.01);

                        System.out.println("      Current price: " + currencyFormat.format(currentPrice) + "đ");
                        System.out.println("      Price changed: " + itemData.get("priceChanged"));
                    }
                } else {
                    System.out.println("    ✗ Comic NOT FOUND for ID: " + item.getComicId());
                }

                itemsWithComics.add(itemData);
            }

            orderData.put("items", itemsWithComics);
            orderDetails.add(orderData);
        }

        System.out.println("\nTotal orderDetails: " + orderDetails.size());
        System.out.println("=========================================\n");

        request.setAttribute("orderDetails", orderDetails);
        request.setAttribute("currentFilter", filter);
        request.getRequestDispatcher("/fontend/nguoiB/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean success = false;
        String message = "";
        try {
            String action = request.getParameter("action");
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            switch (action) {
                case "cancel":
                    String cancelReason = request.getParameter("reason");
                    success = orderDAO.cancelOrderWithHistory(orderId, user.getId(), cancelReason);
                    System.out.println("Cancel order #" + orderId + " with reason: " + cancelReason + " - " + success);

                    if (success) {
                        OrderViolationService.getInstance().checkCancelViolation(user.getId());
                        message = "Hủy đơn thành công";
                    } else {
                        message = "Không thể hủy đơn hàng";
                    }
                    break;

                case "receive":
                    success = orderDAO.updateOrderStatusWithPoints(orderId, "Completed");
                    message = success ? "Đã xác nhận nhận hàng" : "Không thể cập nhật";
                    System.out.println("Receive order #" + orderId + ": " + success);
                    break;

                case "return":
                    success = orderDAO.updateOrderStatus(orderId, "Returned");
                    message = success ? "Đã yêu cầu trả hàng" : "Không thể trả hàng";
                    System.out.println("Return order #" + orderId + ": " + success);
                    break;

                default:
                    message = "Hành động không hợp lệ";
                    System.out.println("Unknown action: " + action);
                    break;
            }
        } catch (NumberFormatException e) {
            success = false;
            message = "Mã đơn hàng không hợp lệ";
            e.printStackTrace();
        } catch (Exception e) {
            success = false;
            message = "Lỗi: " + e.getMessage();
            e.printStackTrace();
        }

        String jsonResponse = String.format(
                "{\"success\":%b,\"message\":\"%s\"}",
                success,
                message.replace("\"", "\\\"").replace("\n", " ")
        );

        System.out.println("📤 Response JSON: " + jsonResponse);
        response.getWriter().write(jsonResponse);
    }

    private String mapFilterToStatus(String filter) {
        switch (filter) {
            case "pending":
                return "Pending";
            case "shipping":
                return "AwaitingPickup";
            case "delivery":
                return "Shipping";
            case "completed":
                return "Completed";
            case "canceled":
                return "Cancelled";
            case "refund":
                return "Returned";
            default:
                return "Pending";
        }
    }
}