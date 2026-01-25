package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderHistory;

import java.util.List;
import java.util.Optional;

public class OrderHistoryDAO {
    private final Jdbi jdbi;

    public OrderHistoryDAO() {
        this.jdbi = JdbiConnector.get();
    }

    /**
     * Thêm một bản ghi lịch sử mới
     */
    public boolean addHistory(OrderHistory history) {
        String sql = """
            INSERT INTO order_history (order_id, status_from, status_to, changed_by, reason)
            VALUES (:orderId, :statusFrom, :statusTo, :changedBy, :reason)
        """;

        try {

            int result = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("orderId", history.getOrderId())
                            .bind("statusFrom", history.getStatusFrom())
                            .bind("statusTo", history.getStatusTo())
                            .bind("changedBy", history.getChangedBy())
                            .bind("reason", history.getReason())
                            .execute()
            );

            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy lý do hủy đơn hàng
     */
    public Optional<OrderHistory> getCancellationReason(int orderId) {
        String sql = """
            SELECT * FROM order_history
            WHERE order_id = ?
              AND status_to = 'Cancelled'
            ORDER BY changed_at DESC
            LIMIT 1
        """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind(0, orderId)
                            .mapToBean(OrderHistory.class)
                            .findFirst()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    /**
     * Lấy toàn bộ lịch sử của một đơn hàng
     */
    public List<OrderHistory> getOrderHistory(int orderId) {
        String sql = """
            SELECT * FROM order_history
            WHERE order_id = ?
            ORDER BY changed_at DESC
        """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind(0, orderId)
                            .mapToBean(OrderHistory.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Lấy lịch sử theo trạng thái đích
     */
    public List<OrderHistory> getHistoryByStatus(String statusTo) {
        String sql = """
            SELECT * FROM order_history
            WHERE status_to = ?
            ORDER BY changed_at DESC
        """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind(0, statusTo)
                            .mapToBean(OrderHistory.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Lấy lịch sử thay đổi mới nhất của đơn hàng
     */
    public Optional<OrderHistory> getLatestHistory(int orderId) {
        String sql = """
            SELECT * FROM order_history
            WHERE order_id = ?
            ORDER BY changed_at DESC
            LIMIT 1
        """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind(0, orderId)
                            .mapToBean(OrderHistory.class)
                            .findFirst()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    /**
     * Xóa toàn bộ lịch sử của một đơn hàng
     */
    public boolean deleteOrderHistory(int orderId) {
        String sql = "DELETE FROM order_history WHERE order_id = ?";

        try {
            int result = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind(0, orderId)
                            .execute()
            );
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static int countUserCancelledOrdersLastHour(int userId) {
        return JdbiConnector.get().withHandle(handle ->
                handle.createQuery(
                                """
                                SELECT COUNT(*)
                                FROM order_history oh
                                JOIN orders o ON oh.order_id = o.id
                                WHERE o.user_id = :userId
                                  AND oh.status_to = 'Cancelled'
                                  AND oh.changed_by = :userId
                                  AND oh.changed_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
                                """
                        )
                        .bind("userId", userId)
                        .mapTo(Integer.class)
                        .one()
        );
    }



}
