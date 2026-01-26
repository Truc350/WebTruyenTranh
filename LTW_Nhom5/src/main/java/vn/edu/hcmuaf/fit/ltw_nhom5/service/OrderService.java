package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.CurrencyFormatter;

import java.time.LocalDateTime;
import java.util.*;

public class OrderService {
    private final Jdbi jdbi;
    private OrderDAO orderDAO;
    private PaymentDAO paymentDAO;
    private ComicDAO comicDAO;
    private UserDao userDAO;
    private OrderHistoryDAO orderHistoryDAO;

    public OrderService() {
        this.jdbi = JdbiConnector.get();
        this.orderDAO = new OrderDAO(jdbi);
        this.paymentDAO = new PaymentDAO();
        this.comicDAO = new ComicDAO();
        this.userDAO = new UserDao(jdbi);
        this.orderHistoryDAO = new OrderHistoryDAO();
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
    /**
     * Xây dựng dữ liệu đơn hàng đầy đủ
     */
    private Map<String, Object> buildOrderData(Order order) {
        Map<String, Object> data = new HashMap<>();

        // Thông tin cơ bản của đơn hàng
        data.put("id", order.getId());
        data.put("orderCode", order.getId());
        data.put("userId", order.getUserId());

        // XỬ LÝ NGÀY THÁNG - Xử lý cả trường hợp NULL
        try {
            Object orderDate = order.getOrderDate();
            String formattedDate = "";

            if (orderDate == null) {
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
                java.sql.Timestamp timestamp = (java.sql.Timestamp) orderDate;
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                formattedDate = sdf.format(timestamp);
                data.put("orderDate", timestamp);
            } else if (orderDate instanceof java.util.Date) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                formattedDate = sdf.format(orderDate);
                data.put("orderDate", orderDate);
            } else {
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
        data.put("formattedShippingFee", CurrencyFormatter.format(order.getShippingFee()));
        data.put("pointUsed", order.getPointUsed());

        // LẤY LÝ DO HỦY TỪ ORDER_HISTORY (NẾU ĐƠN BỊ HỦY)
        if ("Cancelled".equals(order.getStatus())) {
            try {
                Optional<OrderHistory> history = orderHistoryDAO.getCancellationReason(order.getId());
                if (history.isPresent()) {
                    data.put("cancellationReason", history.get().getReason() != null ? history.get().getReason() : "Không có lý do");
                    data.put("cancelledBy", history.get().getChangedBy());
                    LocalDateTime cancelledAt = history.get().getChangedAt();
                    if (cancelledAt != null) {
                        java.util.Date cancelledDate = java.util.Date.from(
                                cancelledAt.atZone(java.time.ZoneId.systemDefault()).toInstant()
                        );
                        data.put("cancelledAt", cancelledDate);
                    }
                } else {
                    data.put("cancellationReason", "Không có lý do");
                    data.put("cancelledBy", "N/A");
                    data.put("cancelledAt", null);
                }
            } catch (Exception e) {
                data.put("cancellationReason", "Không có lý do");
                data.put("cancelledBy", "N/A");
                data.put("cancelledAt", null);
            }
        }

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

            if ("COD".equals(payment.getPaymentMethod())) {
                data.put("paymentMethodDisplay", "COD");
            } else if ("Completed".equals(payment.getPaymentStatus())) {
                data.put("paymentMethodDisplay", "Đã thanh toán");
            } else {
                data.put("paymentMethodDisplay", payment.getPaymentMethod());
            }

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

        // ============================================================
        // ✅ PHẦN QUAN TRỌNG: XỬ LÝ DANH SÁCH SẢN PHẨM VỚI FLASH SALE
        // ============================================================
        List<OrderItem> orderItems = orderDAO.getOrderItems(order.getId());
        List<Map<String, Object>> itemsData = new ArrayList<>();
        StringBuilder productSummary = new StringBuilder();

        // ✅ KHỞI TẠO FlashSaleComicsDAO
        FlashSaleComicsDAO flashSaleComicsDAO = new FlashSaleComicsDAO();

        for (int i = 0; i < orderItems.size(); i++) {
            OrderItem item = orderItems.get(i);
            Map<String, Object> itemData = new HashMap<>();

            itemData.put("id", item.getId());
            itemData.put("comicId", item.getComicId());
            itemData.put("quantity", item.getQuantity());

            // ✅ GIÁ ĐÃ MUA (KHÔNG THAY ĐỔI) - Dùng cho tính tổng tiền
            itemData.put("priceAtPurchase", item.getPriceAtPurchase());
            itemData.put("formattedPriceAtPurchase", CurrencyFormatter.format(item.getPriceAtPurchase()));

            // Lấy thông tin comic
            try {
                Comic comic = comicDAO.getComicById(item.getComicId());
                if (comic != null) {
                    itemData.put("comicName", comic.getNameComics());
                    itemData.put("comicImage", comic.getThumbnailUrl());

                    // ✅ KIỂM TRA FLASH SALE HIỆN TẠI
                    Map<String, Object> flashSaleInfo = flashSaleComicsDAO.getFlashSaleInfoByComicId(item.getComicId());

                    double displayPrice = item.getPriceAtPurchase(); // Mặc định là giá đã mua
                    boolean hasActiveFlashSale = false;

                    if (flashSaleInfo != null) {
                        // ✅ CÓ FLASH SALE ĐANG HOẠT ĐỘNG
                        hasActiveFlashSale = true;

                        Object discountObj = flashSaleInfo.get("discount_percent");
                        if (discountObj instanceof Number) {
                            double discountPercent = ((Number) discountObj).doubleValue();
                            // Tính giá Flash Sale hiện tại từ GIÁ GỐC
                            displayPrice = comic.getPrice() * (1 - discountPercent / 100.0);

                            itemData.put("flashSaleName", flashSaleInfo.get("flashsale_name"));
                            itemData.put("flashSaleDiscount", discountPercent);
                        }
                    } else {
                        // ✅ KHÔNG CÓ FLASH SALE → Dùng giá discount hiện tại
                        if (comic.hasDiscount()) {
                            displayPrice = comic.getDiscountPrice();
                        } else {
                            displayPrice = comic.getPrice(); // Giá gốc
                        }
                    }

                    // ✅ GIÁ HIỂN THỊ (TỰ ĐỘNG CẬP NHẬT)
                    itemData.put("currentDisplayPrice", displayPrice);
                    itemData.put("formattedDisplayPrice", CurrencyFormatter.format(displayPrice));
                    itemData.put("hasActiveFlashSale", hasActiveFlashSale);

                    // ✅ KIỂM TRA XEM GIÁ CÓ THAY ĐỔI SO VỚI LÚC MUA KHÔNG
                    boolean priceChanged = Math.abs(displayPrice - item.getPriceAtPurchase()) > 0.01;
                    itemData.put("priceChanged", priceChanged);

                    // Thêm vào product summary
                    if (i > 0) productSummary.append(", ");
                    productSummary.append(comic.getNameComics())
                            .append(" (")
                            .append(item.getQuantity())
                            .append(")");
                } else {
                    itemData.put("comicName", "Sản phẩm #" + item.getComicId());
                    itemData.put("comicImage", "");
                    itemData.put("hasActiveFlashSale", false);
                    itemData.put("priceChanged", false);
                    itemData.put("currentDisplayPrice", item.getPriceAtPurchase());
                    itemData.put("formattedDisplayPrice", CurrencyFormatter.format(item.getPriceAtPurchase()));
                }
            } catch (Exception e) {
                itemData.put("comicName", "Sản phẩm #" + item.getComicId());
                itemData.put("comicImage", "");
                itemData.put("hasActiveFlashSale", false);
                itemData.put("priceChanged", false);
                itemData.put("currentDisplayPrice", item.getPriceAtPurchase());
                itemData.put("formattedDisplayPrice", CurrencyFormatter.format(item.getPriceAtPurchase()));
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
            Order order = orderDAO.getOrderById(orderId).orElse(null);
            if (order == null) {
                return Map.of("success", false, "message", "Không tìm thấy đơn hàng");
            }
            String oldStatus = order.getStatus();

            // Cập nhật đơn vị vận chuyển nếu có
            if (shippingProvider != null && !shippingProvider.trim().isEmpty()) {
                orderDAO.updateShippingProvider(orderId, shippingProvider);
            }

            // Chuyển sang trạng thái AwaitingPickup
            boolean success = orderDAO.updateOrderStatus(orderId, "AwaitingPickup");

            if (success) {
                OrderHistory history = new OrderHistory(
                        orderId,
                        oldStatus,
                        "AwaitingPickup",
                        "Admin",
                        null  // Không có lý do khi xác nhận
                );
                orderHistoryDAO.addHistory(history);
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
            // Lấy thông tin đơn hàng trước khi hủy
            Order order = orderDAO.getOrderById(orderId).orElse(null);
            if (order == null) {
                return Map.of("success", false, "message", "Không tìm thấy đơn hàng");
            }

            String oldStatus = order.getStatus();

            // Sử dụng updateOrderStatusWithPoints để tự động hoàn xu và tồn kho
            boolean success = orderDAO.updateOrderStatusWithPoints(orderId, "Cancelled");

            if (success) {
                OrderHistory history = new OrderHistory(
                        orderId,
                        oldStatus,
                        "Cancelled",
                        "Admin",  // Hoặc lấy từ session
                        reason != null ? reason : "Không có lý do"
                );

                orderHistoryDAO.addHistory(history);
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


    /**
     * Tìm kiếm đơn hàng theo tab cụ thể
     *
     * @param keyword Từ khóa tìm kiếm (mã đơn hoặc tên khách)
     * @param status  Trạng thái đơn hàng (tab hiện tại)
     * @return Danh sách đơn hàng đã format
     */
    public List<Map<String, Object>> searchOrdersByTab(String keyword, String status) {
        List<Map<String, Object>> result = new ArrayList<>();

        try {
            List<Map<String, Object>> orders;

            // Xử lý riêng cho tab Cancelled vì cần lấy thêm thông tin từ order_history
            if ("Cancelled".equalsIgnoreCase(status)) {
                orders = orderDAO.searchCancelledOrders(keyword);
            } else {
                orders = orderDAO.searchOrdersByStatus(keyword, status);
            }

            // Format dữ liệu giống như buildOrderData
            for (Map<String, Object> orderMap : orders) {
                int orderId = ((Number) orderMap.get("id")).intValue();

                // Lấy Order object đầy đủ
                Order order = orderDAO.getOrderById(orderId).orElse(null);

                if (order != null) {
                    // Sử dụng buildOrderData để format đồng nhất
                    Map<String, Object> formattedOrder = buildOrderData(order);
                    result.add(formattedOrder);
                }
            }

        } catch (Exception e) {
            System.err.println("Error in searchOrdersByTab: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Tìm kiếm đơn hàng cho tab CHỜ XÁC NHẬN
     */
    public List<Map<String, Object>> searchPendingOrders(String keyword) {
        return searchOrdersByTab(keyword, "Pending");
    }

    /**
     * Tìm kiếm đơn hàng cho tab CHỜ LẤY HÀNG
     */
    public List<Map<String, Object>> searchAwaitingPickupOrders(String keyword) {
        return searchOrdersByTab(keyword, "AwaitingPickup");
    }

    /**
     * Tìm kiếm đơn hàng cho tab ĐANG GIAO
     */
    public List<Map<String, Object>> searchShippingOrders(String keyword) {
        return searchOrdersByTab(keyword, "Shipping");
    }

    /**
     * Tìm kiếm đơn hàng cho tab ĐÃ GIAO
     */
    public List<Map<String, Object>> searchCompletedOrders(String keyword) {
        return searchOrdersByTab(keyword, "Completed");
    }

    /**
     * Tìm kiếm đơn hàng cho tab TRẢ HÀNG/HOÀN TIỀN
     */
    public List<Map<String, Object>> searchReturnedOrders(String keyword) {
        return searchOrdersByTab(keyword, "Returned");
    }

    /**
     * Tìm kiếm đơn hàng cho tab ĐƠN BỊ HỦY
     */
    public List<Map<String, Object>> searchCancelledOrders(String keyword) {
        return searchOrdersByTab(keyword, "Cancelled");
    }

    /**
     * Cập nhật trạng thái đơn hàng và tự động cập nhật total_spent
     *
     * @param orderId   ID đơn hàng
     * @param newStatus Trạng thái mới
     * @return true nếu thành công
     */
    public boolean updateOrderStatusAndSync(int orderId, String newStatus) {
        // Cập nhật trạng thái đơn hàng
        boolean orderUpdated = orderDAO.updateOrderStatus(orderId, newStatus);

        if (!orderUpdated) {
            return false;
        }

        // Nếu trạng thái mới là "completed", tự động cập nhật total_spent
        if ("Completed".equalsIgnoreCase(newStatus)) {
            Optional<Order> order = orderDAO.getOrderById(orderId);
            if (order.isPresent() && order.get().getUserId() > 0) {
                // Đồng bộ total_spent cho user
                userDAO.syncTotalSpentFromOrders(order.get().getUserId());
                System.out.println("Đã tự động cập nhật total_spent cho user ID: " + order.get().getUserId());
            }
        }
        return true;
    }
}