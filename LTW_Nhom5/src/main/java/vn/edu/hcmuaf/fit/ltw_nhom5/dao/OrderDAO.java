package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Order;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderItem;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class OrderDAO extends ADao{
    public final Jdbi jdbi;
    private ComicDAO comicDAO;
    private PaymentDAO paymentDAO;

    public OrderDAO() {
        this.jdbi = JdbiConnector.get();
        comicDAO = new ComicDAO(jdbi);
        paymentDAO = new PaymentDAO(jdbi);
    }

    public OrderDAO(Jdbi jdbi) {
        this.jdbi = jdbi;
        this.comicDAO = new ComicDAO(jdbi);
        this.paymentDAO = new PaymentDAO(jdbi);
    }

    /**
     * Tạo đơn hàng mới với transaction (bao gồm payment và kiểm tra tồn kho)
     * @param order Thông tin đơn hàng
     * @param orderItems Danh sách sản phẩm trong đơn
     * @param paymentMethod Phương thức thanh toán
     * @return ID của đơn hàng mới tạo, trả về 0 nếu thất bại
     */
    public int createOrderWithPayment(Order order, List<OrderItem> orderItems, String paymentMethod) {
        return jdbi.inTransaction(handle -> {
            // 1. KIỂM TRA TỒN KHO
            for (OrderItem item : orderItems) {
                int stockQuantity = handle.createQuery(
                                "SELECT stock_quantity FROM comics WHERE id = ?")
                        .bind(0, item.getComicId())
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0);

                if (stockQuantity < item.getQuantity()) {
                    throw new RuntimeException(
                            "Sản phẩm ID " + item.getComicId() +
                                    " không đủ hàng. Còn lại: " + stockQuantity +
                                    ", yêu cầu: " + item.getQuantity()
                    );
                }
            }

            // 2. TẠO ĐƠN HÀNG
            String insertOrderSql = "INSERT INTO orders " +
                    "(user_id, order_date, status, total_amount, shipping_address_id, " +
                    "recipient_name, shipping_phone, shipping_address, shipping_provider, " +
                    "shipping_fee, points_used, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            int orderId = handle.createUpdate(insertOrderSql)
                    .bind(0, order.getUserId())
                    .bind(1, order.getOrderDate())
                    .bind(2, order.getStatus())
                    .bind(3, order.getTotalAmount())
                    .bind(4, order.getShippingAddressId())
                    .bind(5, order.getRecipientName())
                    .bind(6, order.getShippingPhone())
                    .bind(7, order.getShippingAddress())
                    .bind(8, order.getShippingProvider())
                    .bind(9, order.getShippingFee())
                    .bind(10, order.getPointUsed())
                    .bind(11, order.getCreatedAt())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            // 3. TẠO ORDER ITEMS VÀ TRỪ TỒN KHO
            if (orderItems != null && !orderItems.isEmpty()) {
                String insertItemSql = "INSERT INTO order_items " +
                        "(order_id, comic_id, quantity, price_at_purchase) " +
                        "VALUES (?, ?, ?, ?)";

                var batch = handle.prepareBatch(insertItemSql);

                for (OrderItem item : orderItems) {
                    // Thêm order item
                    batch.bind(0, orderId)
                            .bind(1, item.getComicId())
                            .bind(2, item.getQuantity())
                            .bind(3, item.getPriceAtPurchase())
                            .add();

                    // Trừ tồn kho
                    String updateStockSql = "UPDATE comics SET stock_quantity = stock_quantity - ? " +
                            "WHERE id = ? AND stock_quantity >= ?";

                    int updated = handle.createUpdate(updateStockSql)
                            .bind(0, item.getQuantity())
                            .bind(1, item.getComicId())
                            .bind(2, item.getQuantity())
                            .execute();

                    if (updated == 0) {
                        throw new RuntimeException(
                                "Không thể trừ tồn kho cho sản phẩm ID: " + item.getComicId()
                        );
                    }
                }

                batch.execute();
            }

            // 4. TẠO PAYMENT
            String insertPaymentSql = "INSERT INTO payments " +
                    "(order_id, payment_method, payment_status, transaction_id, " +
                    "amount, payment_date, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            // Xác định payment_status dựa trên payment_method
            String paymentStatus = "COD".equals(paymentMethod) ? "Pending" : "Pending";
            String transactionId = null; // Sẽ được cập nhật sau khi thanh toán
            LocalDateTime paymentDate = null;
            LocalDateTime now = LocalDateTime.now();

            handle.createUpdate(insertPaymentSql)
                    .bind(0, orderId)
                    .bind(1, paymentMethod)
                    .bind(2, paymentStatus)
                    .bind(3, transactionId)
                    .bind(4, order.getTotalAmount())
                    .bind(5, paymentDate) // payment_date sẽ được set khi thanh toán thành công
                    .bind(6, now)
                    .bind(7, now)
                    .execute();

            return orderId;
        });
    }

    /**
     * Tạo đơn hàng mới với transaction
     * @param order Thông tin đơn hàng
     * @param orderItems Danh sách sản phẩm trong đơn
     * @return ID của đơn hàng mới tạo, trả về 0 nếu thất bại
     */
    public int createOrder(Order order, List<OrderItem> orderItems) {
        return jdbi.inTransaction(handle -> {
            // Insert order
            String insertOrderSql = "INSERT INTO orders " +
                    "(user_id, order_date, status, total_amount, shipping_address_id, " +
                    "recipient_name, shipping_phone, shipping_address, shipping_provider, " +
                    "shipping_fee, points_used, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            int orderId = handle.createUpdate(insertOrderSql)
                    .bind(0, order.getUserId())
                    .bind(1, order.getOrderDate())
                    .bind(2, order.getStatus())
                    .bind(3, order.getTotalAmount())
                    .bind(4, order.getShippingAddressId())
                    .bind(5, order.getRecipientName())
                    .bind(6, order.getShippingPhone())
                    .bind(7, order.getShippingAddress())
                    .bind(8, order.getShippingProvider())
                    .bind(9, order.getShippingFee())
                    .bind(10, order.getPointUsed())
                    .bind(11, order.getCreatedAt())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            // Insert order items
            if (orderItems != null && !orderItems.isEmpty()) {
                String insertItemSql = "INSERT INTO order_items " +
                        "(order_id, comic_id, quantity, price_at_purchase) " +
                        "VALUES (?, ?, ?, ?)";

                var batch = handle.prepareBatch(insertItemSql);

                for (OrderItem item : orderItems) {
                    batch.bind(0, orderId)
                            .bind(1, item.getComicId())
                            .bind(2, item.getQuantity())
                            .bind(3, item.getPriceAtPurchase())
                            .add();
                }

                batch.execute();
            }

            return orderId;
        });
    }

    /**
     * Lấy thông tin đơn hàng theo ID
     * @param orderId ID đơn hàng
     * @return Optional chứa Order nếu tìm thấy
     */
    public Optional<Order> getOrderById(int orderId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders WHERE id = ?")
                        .bind(0, orderId)
                        .mapToBean(Order.class)
                        .findFirst()
        );
    }

    /**
     * Lấy danh sách đơn hàng của user
     * @param userId ID của user
     * @return Danh sách đơn hàng
     */
    public List<Order> getOrdersByUserId(int userId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC")
                        .bind(0, userId)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    /**
     * Lấy danh sách sản phẩm trong đơn hàng
     * @param orderId ID đơn hàng
     * @return Danh sách OrderItem
     */
    public List<OrderItem> getOrderItems(int orderId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM order_items WHERE order_id = ?")
                        .bind(0, orderId)
                        .mapToBean(OrderItem.class)
                        .list()
        );
    }

    /**
     * Cập nhật trạng thái đơn hàng
     * @param orderId ID đơn hàng
     * @param status Trạng thái mới
     * @return true nếu cập nhật thành công
     */
    public boolean updateOrderStatus(int orderId, String status) {
        return jdbi.withHandle(handle -> {
            int updated = handle.createUpdate(
                            "UPDATE orders SET status = ? WHERE id = ?")
                    .bind(0, status)
                    .bind(1, orderId)
                    .execute();
            return updated > 0;
        });
    }

    /**
     * Lấy danh sách tất cả đơn hàng (cho admin)
     * @return Danh sách tất cả đơn hàng
     */
    public List<Order> getAllOrders() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders ORDER BY order_date DESC")
                        .mapToBean(Order.class)
                        .list()
        );
    }

    /**
     * Lấy danh sách đơn hàng theo trạng thái
     * @param status Trạng thái đơn hàng
     * @return Danh sách đơn hàng
     */
    public List<Order> getOrdersByStatus(String status) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders WHERE status = ? ORDER BY order_date DESC")
                        .bind(0, status)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    /**
     * Đếm số đơn hàng của user
     * @param userId ID user
     * @return Số lượng đơn hàng
     */
    public int countOrdersByUserId(int userId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE user_id = ?")
                        .bind(0, userId)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    /**
     * Xóa đơn hàng (soft delete - chuyển status thành Cancelled)
     * @param orderId ID đơn hàng
     * @return true nếu xóa thành công
     */
    public boolean cancelOrder(int orderId) {
        return updateOrderStatus(orderId, "Cancelled");
    }

    /**
     * Lấy tổng doanh thu từ các đơn hàng đã hoàn thành
     * @return Tổng doanh thu
     */
    public double getTotalRevenue() {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'Completed'")
                        .mapTo(Double.class)
                        .one()
        );
    }

    /**
     * Lấy doanh thu theo khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Tổng doanh thu
     */
    public double getRevenueByDateRange(LocalDate startDate, LocalDate endDate) {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                                        "WHERE status = 'Completed' AND order_date BETWEEN ? AND ?")
                        .bind(0, startDate)
                        .bind(1, endDate)
                        .mapTo(Double.class)
                        .one()
        );
    }

    /**
     * Cập nhật trạng thái đơn hàng VÀ cộng xu khi hoàn thành
     * @param orderId ID đơn hàng
     * @param newStatus Trạng thái mới
     * @return true nếu cập nhật thành công
     */
    public boolean updateOrderStatusWithPoints(int orderId, String newStatus) {
        return jdbi.inTransaction(handle -> {
            // 1. Lấy thông tin đơn hàng
            Order order = handle.createQuery("SELECT * FROM orders WHERE id = ?")
                    .bind(0, orderId)
                    .mapToBean(Order.class)
                    .findOne()
                    .orElse(null);

            if (order == null) {
                return false;
            }

            String oldStatus = order.getStatus();

            // 2. Cập nhật trạng thái đơn hàng
            int updated = handle.createUpdate("UPDATE orders SET status = ? WHERE id = ?")
                    .bind(0, newStatus)
                    .bind(1, orderId)
                    .execute();

            if (updated == 0) {
                return false;
            }

            // 3. Nếu chuyển sang trạng thái "Completed", cộng xu cho user
            if ("Completed".equalsIgnoreCase(newStatus) &&
                    !"Completed".equalsIgnoreCase(oldStatus)) {

                // Tính xu được cộng (1% tổng đơn hàng, làm tròn xuống)
                // Ví dụ: đơn 150,000đ = 1 xu, 250,000đ = 2 xu
                int earnedPoints = (int) (order.getTotalAmount() / 100000);

                if (earnedPoints > 0) {
                    // Cập nhật xu cho user
                    handle.createUpdate("UPDATE users SET points = points + ? WHERE id = ?")
                            .bind(0, earnedPoints)
                            .bind(1, order.getUserId())
                            .execute();

                    // Ghi log giao dịch xu
                    String insertTransactionSql = "INSERT INTO PointTransactions " +
                            "(user_id, order_id, points, transaction_type, description, created_at) " +
                            "VALUES (?, ?, ?, ?, ?, ?)";

                    handle.createUpdate(insertTransactionSql)
                            .bind(0, order.getUserId())
                            .bind(1, orderId)
                            .bind(2, earnedPoints)
                            .bind(3, "EARN")
                            .bind(4, "Nhận " + earnedPoints + " xu từ đơn hàng #" + orderId +
                                    " (Giá trị đơn: " + String.format("%,.0f", order.getTotalAmount()) + "đ)")
                            .bind(5, LocalDateTime.now())
                            .execute();
                }
            }

            // 4. Nếu hủy đơn hàng, hoàn xu (nếu đã sử dụng xu)
            if ("Cancelled".equalsIgnoreCase(newStatus) &&
                    !"Cancelled".equalsIgnoreCase(oldStatus)) {

                if (order.getPointUsed() > 0) {
                    // Hoàn xu cho user
                    handle.createUpdate("UPDATE users SET points = points + ? WHERE id = ?")
                            .bind(0, order.getPointUsed())
                            .bind(1, order.getUserId())
                            .execute();

                    // Ghi log giao dịch hoàn xu
                    String insertTransactionSql = "INSERT INTO PointTransactions " +
                            "(user_id, order_id, points, transaction_type, description, created_at) " +
                            "VALUES (?, ?, ?, ?, ?, ?)";

                    handle.createUpdate(insertTransactionSql)
                            .bind(0, order.getUserId())
                            .bind(1, orderId)
                            .bind(2, order.getPointUsed())
                            .bind(3, "REFUND")
                            .bind(4, "Hoàn " + order.getPointUsed() +
                                    " xu do hủy đơn hàng #" + orderId)
                            .bind(5, LocalDateTime.now())
                            .execute();
                }

                // Hoàn lại tồn kho
                List<OrderItem> orderItems = handle.createQuery(
                                "SELECT * FROM order_items WHERE order_id = ?")
                        .bind(0, orderId)
                        .mapToBean(OrderItem.class)
                        .list();

                for (OrderItem item : orderItems) {
                    handle.createUpdate(
                                    "UPDATE comics SET stock_quantity = stock_quantity + ? WHERE id = ?")
                            .bind(0, item.getQuantity())
                            .bind(1, item.getComicId())
                            .execute();
                }
            }

            return true;
        });
    }
}
