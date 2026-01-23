package vn.edu.hcmuaf.fit.ltw_nhom5.controller.UserB;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.OrderDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Order;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderItem;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private ComicDAO comicDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        comicDAO = new ComicDAO();
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

        // Lấy thông tin chi tiết
        List<Map<String, Object>> orderDetails = new ArrayList<>();

        for (Order order : filteredOrders) {
            System.out.println("\n--- Order #" + order.getId() + " ---");
            System.out.println("Date: " + order.getOrderDate());
            System.out.println("Status: " + order.getStatus());
            System.out.println("Total: " + order.getTotalAmount());

            Map<String, Object> orderData = new HashMap<>();
            orderData.put("order", order);

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
                System.out.println("item.getComicId() "+ item.getComicId());
                if (comic != null) {
                    System.out.println("    ✓ Comic found: " + comic.getNameComics());
                    System.out.println("      Thumbnail: " + comic.getThumbnailUrl());
                    itemData.put("comic", comic);
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
        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean success = false;

        switch (action) {
            case "cancel":
                // Hủy đơn hàng - sử dụng updateOrderStatusWithPoints để hoàn xu và tồn kho
                success = orderDAO.updateOrderStatusWithPoints(orderId, "Cancelled");
                System.out.println("Cancel order #" + orderId + ": " + success);
                break;

            case "receive":
                // Xác nhận đã nhận hàng
                success = orderDAO.updateOrderStatusWithPoints(orderId, "Completed");
                System.out.println("Receive order #" + orderId + ": " + success);
                break;

            default:
                System.out.println("Unknown action: " + action);
                break;
        }

        // Trả về JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + "}");
    }

    private String mapFilterToStatus(String filter) {
        switch (filter) {
            case "pending":
                return "Pending";
            case "shipping":  // ✅ Shipping = Vận chuyển
                return "AwaitingPickup";
            case "delivery":  // ✅ Delivery = Chờ giao hàng
                return "Shipping";
            case "completed":
                return "Completed";
            case "cancelled":
                return "Cancelled";
            case "returned":
                return "Returned";
            default:
                return "Pending";
        }
    }
}