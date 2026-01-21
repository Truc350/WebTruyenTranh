package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Payment;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class PaymentDAO {
    private final Jdbi jdbi;

    public PaymentDAO() {
        this.jdbi = JdbiConnector.get();
    }

    public PaymentDAO(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    /**
     * Tạo payment mới
     * @param payment Thông tin payment
     * @return ID của payment mới tạo
     */
    public int createPayment(Payment payment) {
        return jdbi.withHandle(handle -> {
            String sql = "INSERT INTO payments " +
                    "(order_id, payment_method, payment_status, transaction_id, " +
                    "amount, payment_date, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            return handle.createUpdate(sql)
                    .bind(0, payment.getOrderId())
                    .bind(1, payment.getPaymentMethod())
                    .bind(2, payment.getPaymentStatus())
                    .bind(3, payment.getTransactionId())
                    .bind(4, payment.getAmount())
                    .bind(5, payment.getPaymentDate())
                    .bind(6, payment.getCreatedAt())
                    .bind(7, payment.getUpdatedAt())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    /**
     * Lấy payment theo order ID
     * @param orderId ID đơn hàng
     * @return Optional chứa Payment nếu tìm thấy
     */
    public Optional<Payment> getPaymentByOrderId(int orderId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM payments WHERE order_id = ?")
                        .bind(0, orderId)
                        .mapToBean(Payment.class)
                        .findFirst()
        );
    }

    /**
     * Cập nhật trạng thái payment
     * @param paymentId ID payment
     * @param status Trạng thái mới
     * @param transactionId Mã giao dịch (có thể null)
     * @return true nếu cập nhật thành công
     */
    public boolean updatePaymentStatus(int paymentId, String status, String transactionId) {
        return jdbi.withHandle(handle -> {
            String sql = "UPDATE payments SET payment_status = ?, transaction_id = ?, " +
                    "payment_date = ?, updated_at = ? WHERE id = ?";

            int updated = handle.createUpdate(sql)
                    .bind(0, status)
                    .bind(1, transactionId)
                    .bind(2, LocalDateTime.now())
                    .bind(3, LocalDateTime.now())
                    .bind(4, paymentId)
                    .execute();

            return updated > 0;
        });
    }

    /**
     * Lấy tất cả payments của user
     * @param userId ID user
     * @return Danh sách payments
     */
    public List<Payment> getPaymentsByUserId(int userId) {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT p.* FROM payments p " +
                                        "JOIN orders o ON p.order_id = o.id " +
                                        "WHERE o.user_id = ? " +
                                        "ORDER BY p.created_at DESC")
                        .bind(0, userId)
                        .mapToBean(Payment.class)
                        .list()
        );
    }
}
