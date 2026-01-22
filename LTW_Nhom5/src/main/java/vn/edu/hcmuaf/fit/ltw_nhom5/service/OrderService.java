package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.OrderDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.PaymentDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.CurrencyFormatter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class OrderService {
    private final Jdbi jdbi;
    private OrderDAO orderDAO;
    private PaymentDAO paymentDAO;
    private ComicDAO comicDAO;
    private UserDao userDAO;

    public OrderService() {
        this.jdbi = JdbiConnector.get();
        this.orderDAO = new OrderDAO();
        this.paymentDAO = new PaymentDAO();
        this.comicDAO = new ComicDAO();
        this.userDAO = new UserDao(jdbi);
    }

    /**
     * Lấy tất cả đơn hàng kèm thông tin đầy đủ
     */
    public Map<String, Object> getAllOrdersWithDetails() {
        Map<String, Object> result = new HashMap<>();

        try {
            // Lấy tất cả đơn hàng
            List<Order> allOrders = orderDAO.getAllOrders();

            // Phân loại theo trạng thái
            Map<String, List<Map<String, Object>>> ordersByStatus = new HashMap<>();
            ordersByStatus.put("Pending", getOrdersWithDetailsByStatus("Pending"));
            ordersByStatus.put("AwaitingPickup", getOrdersWithDetailsByStatus("AwaitingPickup"));
            ordersByStatus.put("Shipping", getOrdersWithDetailsByStatus("Shipping"));
            ordersByStatus.put("Completed", getOrdersWithDetailsByStatus("Completed"));
            ordersByStatus.put("Returned", getOrdersWithDetailsByStatus("Returned"));
            ordersByStatus.put("Cancelled", getOrdersWithDetailsByStatus("Cancelled"));

            result.put("ordersByStatus", ordersByStatus);
            result.put("success", true);

        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        return result;
    }

    /**
     * Lấy danh sách đơn hàng theo trạng thái kèm chi tiết
     */
    public List<Map<String, Object>> getOrdersWithDetailsByStatus(String status) {
        List<Order> orders = orderDAO.getOrdersByStatus(status);
        List<Map<String, Object>> result = new ArrayList<>();

        for (Order order : orders) {
            Map<String, Object> orderData = buildOrderData(order);
            result.add(orderData);
        }

        return result;
    }

    /**
     * Lấy chi tiết một đơn hàng
     */
    public Map<String, Object> getOrderDetail(int orderId) {
        Map<String, Object> result = new HashMap<>();

        try {
            Order order = orderDAO.getOrderById(orderId).orElse(null);

            if (order == null) {
                result.put("success", false);
                result.put("error", "Không tìm thấy đơn hàng");
                return result;
            }

            Map<String, Object> orderData = buildOrderData(order);
            result.put("success", true);
            result.put("order", orderData);

        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        return result;
    }

    /**
     * Xây dựng dữ liệu đơn hàng đầy đủ
     */
    private Map<String, Object> buildOrderData(Order order) {
        Map<String, Object> data = new HashMap<>();

        // Thông tin cơ bản của đơn hàng
        data.put("id", order.getId());
        data.put("orderCode", order.getId());
        data.put("userId", order.getUserId());

        // ✅ XỬ LÝ NGÀY THÁNG - Xử lý cả trường hợp NULL
        try {
            Object orderDate = order.getOrderDate();
            String formattedDate = "";

            if (orderDate == null) {
                // ✅ Trường hợp NULL - set giá trị mặc định
                formattedDate = "N/A";
                data.put("orderDate", new java.util.Date());
                System.out.println("⚠️ Order " + order.getId() + " has NULL orderDate");
            } else if (orderDate instanceof java.time.LocalDate) {
                java.time.LocalDate localDate = (java.time.LocalDate) orderDate;
                formattedDate = localDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                data.put("orderDate", java.util.Date.from(
                        localDate.atStartOfDay(java.time.ZoneId.systemDefault()).toInstant()
                ));
            } else if (orderDate instanceof java.time.LocalDateTime) {
                java.time.LocalDateTime localDateTime = (java.time.LocalDateTime) orderDate;
                formattedDate = localDateTime.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                data.put("orderDate", java.util.Date.from(
                        localDateTime.atZone(java.time.ZoneId.systemDefault()).toInstant()
                ));
            } else if (orderDate instanceof java.sql.Timestamp) {
                // ✅ THÊM XỬ LÝ CHO TIMESTAMP
                java.sql.Timestamp timestamp = (java.sql.Timestamp) orderDate;
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                formattedDate = sdf.format(timestamp);
                data.put("orderDate", timestamp);
            } else if (orderDate instanceof java.util.Date) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                formattedDate = sdf.format(orderDate);
                data.put("orderDate", orderDate);
            } else {
                // ✅ Kiểu dữ liệu không xác định
                System.out.println("❌ Unknown date type for order " + order.getId() + ": " + orderDate.getClass().getName());
                formattedDate = "N/A";
                data.put("orderDate", new java.util.Date());
            }

            data.put("orderDateFormatted", formattedDate);

        } catch (Exception e) {
            System.out.println("❌ Exception formatting date for order " + order.getId() + ": " + e.getMessage());
            e.printStackTrace();
            data.put("orderDate", new java.util.Date());
            data.put("orderDateFormatted", "N/A");
        }

        data.put("status", order.getStatus());
        data.put("totalAmount", order.getTotalAmount());

        // ✅ SỬ DỤNG CurrencyFormatter ĐỂ FORMAT TIỀN
        data.put("formattedAmount", CurrencyFormatter.format(order.getTotalAmount()));

        data.put("recipientName", order.getRecipientName());
        data.put("shippingPhone", order.getShippingPhone());
        data.put("shippingAddress", order.getShippingAddress());
        data.put("fullAddress", order.getShippingAddress() + " (" + order.getShippingPhone() + ")");

        // Format hiển thị đơn vị vận chuyển
        String shippingProvider = order.getShippingProvider();
        String shippingProviderDisplay = "—";
        if (shippingProvider != null) {
            if ("standard".equalsIgnoreCase(shippingProvider)) {
                shippingProviderDisplay = "Tiêu chuẩn";
            } else if ("express".equalsIgnoreCase(shippingProvider)) {
                shippingProviderDisplay = "Hỏa tốc";
            } else {
                shippingProviderDisplay = shippingProvider;
            }
        }

        data.put("shippingProvider", shippingProviderDisplay);

        data.put("shippingFee", order.getShippingFee());

        // ✅ FORMAT PHÍ VẬN CHUYỂN
        data.put("formattedShippingFee", CurrencyFormatter.format(order.getShippingFee()));

        data.put("pointUsed", order.getPointUsed());

        // Lấy tên khách hàng từ recipient_name
        data.put("userName", order.getRecipientName());
        try {
            User user = userDAO.getUserById(order.getUserId());
            if (user != null) {
                data.put("userEmail", user.getEmail());
            } else {
                data.put("userEmail", "");
            }
        } catch (Exception e) {
            data.put("userEmail", "");
        }

        // Lấy thông tin payment
        Payment payment = paymentDAO.getPaymentByOrderId(order.getId()).orElse(null);
        if (payment != null) {
            data.put("paymentMethod", payment.getPaymentMethod());
            data.put("paymentStatus", payment.getPaymentStatus());
            data.put("transactionId", payment.getTransactionId());

            // Format hiển thị phương thức thanh toán
            if ("COD".equals(payment.getPaymentMethod())) {
                data.put("paymentMethodDisplay", "COD");
            } else if ("Completed".equals(payment.getPaymentStatus())) {
                data.put("paymentMethodDisplay", "Đã thanh toán");
            } else {
                data.put("paymentMethodDisplay", payment.getPaymentMethod());
            }

            // Format hiển thị trạng thái thanh toán
            switch (payment.getPaymentStatus()) {
                case "Completed":
                    data.put("paymentStatusDisplay", "Đã thanh toán");
                    break;
                case "Pending":
                    data.put("paymentStatusDisplay", "Chờ thanh toán");
                    break;
                case "Failed":
                    data.put("paymentStatusDisplay", "Thất bại");
                    break;
                default:
                    data.put("paymentStatusDisplay", payment.getPaymentStatus());
            }
        } else {
            data.put("paymentMethod", "");
            data.put("paymentMethodDisplay", "—");
            data.put("paymentStatusDisplay", "—");
        }

        // Lấy danh sách sản phẩm
        List<OrderItem> orderItems = orderDAO.getOrderItems(order.getId());
        List<Map<String, Object>> itemsData = new ArrayList<>();
        StringBuilder productSummary = new StringBuilder();

        for (int i = 0; i < orderItems.size(); i++) {
            OrderItem item = orderItems.get(i);
            Map<String, Object> itemData = new HashMap<>();

            itemData.put("id", item.getId());
            itemData.put("comicId", item.getComicId());
            itemData.put("quantity", item.getQuantity());
            itemData.put("priceAtPurchase", item.getPriceAtPurchase());

            // ✅ SỬ DỤNG CurrencyFormatter ĐỂ FORMAT GIÁ SẢN PHẨM
            itemData.put("formattedPrice", CurrencyFormatter.format(item.getPriceAtPurchase()));

            // Lấy thông tin comic
            try {
                Comic comic = comicDAO.getComicById(item.getComicId());
                if (comic != null) {
                    itemData.put("comicName", comic.getNameComics());
                    itemData.put("comicImage", comic.getThumbnailUrl());

                    // Thêm vào product summary
                    if (i > 0) productSummary.append(", ");
                    productSummary.append(comic.getNameComics())
                            .append(" (")
                            .append(item.getQuantity())
                            .append(")");
                } else {
                    itemData.put("comicName", "Sản phẩm #" + item.getComicId());
                    itemData.put("comicImage", "");
                }
            } catch (Exception e) {
                itemData.put("comicName", "Sản phẩm #" + item.getComicId());
                itemData.put("comicImage", "");
            }

            itemsData.add(itemData);
        }

        data.put("items", itemsData);
        data.put("productSummary", productSummary.toString());
        data.put("itemCount", orderItems.size());

        return data;
    }

    /**
     * Xác nhận đơn hàng
     */
    public Map<String, Object> confirmOrder(int orderId, String shippingProvider) {
        Map<String, Object> result = new HashMap<>();

        try {
            // Cập nhật đơn vị vận chuyển nếu có
            if (shippingProvider != null && !shippingProvider.trim().isEmpty()) {
                orderDAO.updateShippingProvider(orderId, shippingProvider);
            }

            // Chuyển sang trạng thái AwaitingPickup
            boolean success = orderDAO.updateOrderStatus(orderId, "AwaitingPickup");

            if (success) {
                result.put("success", true);
                result.put("message", "Đã xác nhận đơn hàng thành công");
            } else {
                result.put("success", false);
                result.put("message", "Không thể xác nhận đơn hàng");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        return result;
    }

    /**
     * Hủy đơn hàng
     */
    public Map<String, Object> cancelOrder(int orderId, String reason) {
        Map<String, Object> result = new HashMap<>();

        try {
            // Sử dụng updateOrderStatusWithPoints để tự động hoàn xu và tồn kho
            boolean success = orderDAO.updateOrderStatusWithPoints(orderId, "Cancelled");

            if (success) {
                result.put("success", true);
                result.put("message", "Đã hủy đơn hàng. Xu và tồn kho đã được hoàn lại.");
            } else {
                result.put("success", false);
                result.put("message", "Không thể hủy đơn hàng");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        return result;
    }

    /**
     * Xác nhận đã giao cho đơn vị vận chuyển
     */
    public Map<String, Object> confirmShipped(int orderId) {
        Map<String, Object> result = new HashMap<>();

        try {
            boolean success = orderDAO.updateOrderStatus(orderId, "Shipping");

            if (success) {
                result.put("success", true);
                result.put("message", "Đã xác nhận giao cho ĐVVC");
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật trạng thái");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        return result;
    }

    /**
     * Xác nhận đã giao hàng thành công
     */
    public Map<String, Object> confirmDelivered(int orderId) {
        Map<String, Object> result = new HashMap<>();

        try {
            // Sử dụng updateOrderStatusWithPoints để tự động cộng xu cho khách
            boolean success = orderDAO.updateOrderStatusWithPoints(orderId, "Completed");

            if (success) {
                result.put("success", true);
                result.put("message", "Đã xác nhận giao hàng thành công. Khách hàng đã được cộng xu.");
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật trạng thái");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        return result;
    }

    /**
     * Cập nhật trạng thái đơn hàng
     */
    public Map<String, Object> updateOrderStatus(int orderId, String newStatus) {
        Map<String, Object> result = new HashMap<>();

        try {
            // Sử dụng updateOrderStatusWithPoints để tự động xử lý xu
            boolean success = orderDAO.updateOrderStatusWithPoints(orderId, newStatus);

            if (success) {
                result.put("success", true);
                result.put("message", "Đã cập nhật trạng thái đơn hàng");
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật trạng thái");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        return result;
    }

    /**
     * Xử lý yêu cầu hoàn tiền
     */
    public Map<String, Object> processRefund(int orderId) {
        Map<String, Object> result = new HashMap<>();

        try {
            // Chuyển trạng thái sang Returned và hoàn xu, tồn kho
            boolean success = orderDAO.updateOrderStatusWithPoints(orderId, "Returned");

            if (success) {
                result.put("success", true);
                result.put("message", "Đã xác nhận hoàn tiền. Xu và tồn kho đã được hoàn lại.");
            } else {
                result.put("success", false);
                result.put("message", "Không thể xử lý hoàn tiền");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        return result;
    }

    /**
     * Lấy thống kê đơn hàng
     */
    public Map<String, Object> getOrderStatistics() {
        Map<String, Object> stats = new HashMap<>();

        try {
            stats.put("totalOrders", orderDAO.getAllOrders().size());
            stats.put("pendingCount", orderDAO.getOrdersByStatus("Pending").size());
            stats.put("awaitingPickupCount", orderDAO.getOrdersByStatus("AwaitingPickup").size());
            stats.put("shippingCount", orderDAO.getOrdersByStatus("Shipping").size());
            stats.put("completedCount", orderDAO.getOrdersByStatus("Completed").size());
            stats.put("returnedCount", orderDAO.getOrdersByStatus("Returned").size());
            stats.put("cancelledCount", orderDAO.getOrdersByStatus("Cancelled").size());
            stats.put("totalRevenue", orderDAO.getTotalRevenue());

        } catch (Exception e) {
            stats.put("error", e.getMessage());
        }

        return stats;
    }

    public List<Map<String, Object>> searchOrders(String keyword, String status) {
        if (keyword == null) keyword = "";
        if (status == null || status.isEmpty()) status = "Pending";

        List<Map<String, Object>> orders = orderDAO.searchOrders(keyword.trim(), status);

        // ✅ SỬ DỤNG buildOrderData ĐỂ FORMAT ĐỒNG NHẤT
        List<Map<String, Object>> result = new ArrayList<>();

        for (Map<String, Object> orderMap : orders) {
            int orderId = ((Number) orderMap.get("id")).intValue();

            // ✅ LẤY ORDER OBJECT ĐẦY ĐỦ
            Order order = orderDAO.getOrderById(orderId).orElse(null);

            if (order != null) {
                // ✅ DÙNG buildOrderData ĐỂ FORMAT GIỐNG HỆT NHƯ LÚC LOAD TRANG
                Map<String, Object> formattedOrder = buildOrderData(order);
                result.add(formattedOrder);
            }
        }

        return result;
    }
}