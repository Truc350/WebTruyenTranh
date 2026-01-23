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
            System.out.println("User is null, redirecting to login");
            return;
        }
        System.out.println("User found: " + user.getUsername() + " (ID: " + user.getId() + ")");

        // Lấy filter từ parameter (mặc định là "all" để hiển thị tất cả)
        String filter = request.getParameter("filter");
        if (filter == null || filter.isEmpty()) {
            filter = "all";
        }

        // Lấy tất cả đơn hàng của user
        List<Order> allOrders = orderDAO.getOrdersByUserId(user.getId());
        System.out.println("Total orders for user: " + allOrders.size());

        // Lấy thông tin chi tiết cho từng đơn hàng
        List<Map<String, Object>> orderDetails = new ArrayList<>();

        for (Order order : allOrders) {
            Map<String, Object> orderData = new HashMap<>();
            orderData.put("order", order);

            // Lấy danh sách sản phẩm trong đơn
            List<OrderItem> items = orderDAO.getOrderItems(order.getId());
            System.out.println("Order #" + order.getId() + " has " + items.size() + " items");

            // Lấy thông tin comic cho từng item
            List<Map<String, Object>> itemsWithComics = new ArrayList<>();
            for (OrderItem item : items) {
                Map<String, Object> itemData = new HashMap<>();
                itemData.put("item", item);

                Comic comic = comicDAO.getComicById(item.getComicId());
                if (comic != null) {
                    itemData.put("comic", comic);
                    System.out.println("  - Comic: " + comic.getNameComics() +
                            ", Qty: " + item.getQuantity() +
                            ", Price: " + item.getPriceAtPurchase());
                } else {
                    System.out.println("  - Comic ID " + item.getComicId() + " not found!");
                }

                itemsWithComics.add(itemData);
            }

            orderData.put("items", itemsWithComics);
            orderDetails.add(orderData);

            System.out.println("Order #" + order.getId() +
                    " - Status: " + order.getStatus() +
                    " - Total: " + order.getTotalAmount());
        }

        System.out.println("Sending " + orderDetails.size() + " orders to JSP");

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
            case "awaitingpickup":
                return "AwaitingPickup";
            case "shipping":
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