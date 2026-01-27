package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderReturn;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.OrderReturnImage;

import java.util.List;
import java.util.Map;

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
        String sql = "SELECT * FROM order_return_images WHERE order_return_id = ? ORDER BY created_at";

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

    /**
     * Lấy tất cả yêu cầu trả hàng với thông tin đơn hàng và khách hàng
     */
    public List<Map<String, Object>> getAllReturnsWithDetails() {
        String sql = """
            SELECT 
                or_ret.id as return_id,
                or_ret.order_id,
                or_ret.comic_id,
                or_ret.quantity,
                or_ret.reason,
                or_ret.refund_amount,
                or_ret.status as return_status,
                or_ret.created_at as return_date,
                o.id as order_code,
                o.recipient_name as customer_name,
                c.name_comics as product_name
            FROM order_returns or_ret
            JOIN orders o ON or_ret.order_id = o.id
            LEFT JOIN comics c ON or_ret.comic_id = c.id
            ORDER BY or_ret.created_at DESC
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToMap()
                        .list()
        );
    }

    /**
     * Tìm kiếm yêu cầu trả hàng theo mã đơn hoặc tên khách hàng
     */
    public List<Map<String, Object>> searchReturns(String keyword) {
        if (keyword == null) keyword = "";
        String trimmedKeyword = keyword.trim();
        boolean isNumber = trimmedKeyword.matches("\\d+");

        String sqlById = """
            SELECT 
                or_ret.id as return_id,
                or_ret.order_id,
                or_ret.comic_id,
                or_ret.quantity,
                or_ret.reason,
                or_ret.refund_amount,
                or_ret.status as return_status,
                or_ret.created_at as return_date,
                o.id as order_code,
                o.recipient_name as customer_name,
                c.name_comics as product_name
            FROM order_returns or_ret
            JOIN orders o ON or_ret.order_id = o.id
            LEFT JOIN comics c ON or_ret.comic_id = c.id
            WHERE o.id = ?
            ORDER BY or_ret.created_at DESC
        """;

        String sqlByName = """
            SELECT 
                or_ret.id as return_id,
                or_ret.order_id,
                or_ret.comic_id,
                or_ret.quantity,
                or_ret.reason,
                or_ret.refund_amount,
                or_ret.status as return_status,
                or_ret.created_at as return_date,
                o.id as order_code,
                o.recipient_name as customer_name,
                c.name_comics as product_name
            FROM order_returns or_ret
            JOIN orders o ON or_ret.order_id = o.id
            LEFT JOIN comics c ON or_ret.comic_id = c.id
            WHERE LOWER(o.recipient_name) LIKE LOWER(?)
            ORDER BY or_ret.created_at DESC
        """;

        return jdbi.withHandle(handle -> {
            if (isNumber && !trimmedKeyword.isEmpty()) {
                return handle.createQuery(sqlById)
                        .bind(0, Integer.parseInt(trimmedKeyword))
                        .mapToMap()
                        .list();
            } else if (!trimmedKeyword.isEmpty()) {
                return handle.createQuery(sqlByName)
                        .bind(0, "%" + trimmedKeyword + "%")
                        .mapToMap()
                        .list();
            } else {
                return getAllReturnsWithDetails();
            }
        });
    }

    /**
     * Xác nhận hoàn tiền - cập nhật trạng thái thành "Refunded"
     */
    public boolean confirmRefund(int returnId) {
        return jdbi.inTransaction(handle -> {
            // Lấy thông tin yêu cầu trả hàng
            String getReturnSql = "SELECT * FROM order_returns WHERE id = ?";
            OrderReturn orderReturn = handle.createQuery(getReturnSql)
                    .bind(0, returnId)
                    .mapToBean(OrderReturn.class)
                    .findOne()
                    .orElse(null);

            if (orderReturn == null) {
                return false;
            }

            // Cập nhật trạng thái
            String updateSql = "UPDATE order_returns SET status = 'Refunded' WHERE id = ?";
            int updated = handle.createUpdate(updateSql)
                    .bind(0, returnId)
                    .execute();

            if (updated == 0) {
                return false;
            }

            // Hoàn tiền cho khách hàng (tùy logic nghiệp vụ)
            // TODO: Thêm logic hoàn tiền nếu cần

            return true;
        });
    }

    /**
     * Từ chối yêu cầu hoàn tiền với lý do
     */
    public boolean rejectRefund(int returnId, String rejectReason) {
        String sql = """
        UPDATE order_returns 
        SET status = 'Rejected',
            reject_reason = ?
        WHERE id = ?
    """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, rejectReason)
                        .bind(1, returnId)
                        .execute() > 0
        );
    }

    /**
     * Lấy chi tiết yêu cầu trả hàng theo ID
     */
    public Map<String, Object> getReturnDetailsById(int returnId) {
        String sql = """
            SELECT 
                or_ret.id as return_id,
                or_ret.order_id,
                or_ret.comic_id,
                or_ret.quantity,
                or_ret.reason,
                or_ret.refund_amount,
                or_ret.status as return_status,
                or_ret.created_at as return_date,
                o.id as order_code,
                o.recipient_name as customer_name,
                c.name_comics as product_name
            FROM order_returns or_ret
            JOIN orders o ON or_ret.order_id = o.id
            LEFT JOIN comics c ON or_ret.comic_id = c.id
            WHERE or_ret.id = ?
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, returnId)
                        .mapToMap()
                        .findOne()
                        .orElse(null)
        );
    }

}