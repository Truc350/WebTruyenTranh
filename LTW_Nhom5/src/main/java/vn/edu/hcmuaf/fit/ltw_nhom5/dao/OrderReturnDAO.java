package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderReturn;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderReturnImage;

import java.util.List;

public class OrderReturnDAO {
    private final Jdbi jdbi;

    public OrderReturnDAO() {
        this.jdbi = JdbiConnector.get();
    }

    /**
     * Thêm yêu cầu trả hàng mới
     */
    public int addOrderReturn(OrderReturn orderReturn) {
        String sql = "INSERT INTO order_returns (order_id, comic_id, quantity, reason, " +
                "refund_amount, status, created_at) " +
                "VALUES (:orderId, :comicId, :quantity, :reason, :refundAmount, :status, NOW())";

        return jdbi.withHandle(handle -> {
            int returnId = handle.createUpdate(sql)
                    .bind("orderId", orderReturn.getOrderId())
                    .bind("comicId", orderReturn.getComicId())
                    .bind("quantity", orderReturn.getQuantity())
                    .bind("reason", orderReturn.getReason())
                    .bind("refundAmount", orderReturn.getRefundAmount())
                    .bind("status", orderReturn.getStatus())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            System.out.println("Order return created with ID: " + returnId);
            return returnId;
        });
    }

    /**
     * Thêm ảnh trả hàng
     */
    public boolean addReturnImage(int orderReturnId, String imageUrl) {
        String sql = "INSERT INTO order_return_images (order_return_id, url_img, created_at) " +
                "VALUES (?, ?, NOW())";

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, orderReturnId)
                        .bind(1, imageUrl)
                        .execute() > 0
        );
    }

    /**
     * Lấy danh sách yêu cầu trả hàng theo order_id
     */
    public List<OrderReturn> getReturnsByOrderId(int orderId) {
        String sql = "SELECT * FROM order_returns WHERE order_id = ? ORDER BY created_at DESC";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, orderId)
                        .mapToBean(OrderReturn.class)
                        .list()
        );
    }

    /**
     * Lấy ảnh trả hàng theo order_return_id
     */
    public List<OrderReturnImage> getReturnImages(int orderReturnId) {
        String sql = "SELECT * FROM order_return_images WHERE order_return_id = ?";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, orderReturnId)
                        .mapToBean(OrderReturnImage.class)
                        .list()
        );
    }

    /**
     * Cập nhật trạng thái yêu cầu trả hàng
     */
    public boolean updateReturnStatus(int returnId, String status) {
        String sql = "UPDATE order_returns SET status = ? WHERE id = ?";

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, status)
                        .bind(1, returnId)
                        .execute() > 0
        );
    }
}