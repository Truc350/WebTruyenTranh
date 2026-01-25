package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;

import java.time.LocalDateTime;
import java.util.List;

public class FlashSaleDAO extends ADao {
    public FlashSale getActiveFlashSaleEndingSoon() {
        String sql = """
                    SELECT *
                    FROM FlashSale
                    WHERE status = 'active'
                      AND start_time <= NOW()
                      AND end_time >= NOW()
                    ORDER BY end_time ASC
                    LIMIT 1
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(FlashSale.class)
                        .findOne()
                        .orElse(null)
        );
    }


    public int insert(FlashSale flashSale) {
        String sql = """
                    INSERT INTO FlashSale (name, discount_percent, start_time, end_time, status)
                    VALUES (:name, :discountPercent, :startTime, :endTime, :status)
                """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(flashSale)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
    }

    public List<FlashSale> getAllFlashSales() {

        updateStatuses();

        String sql = """
                    SELECT id, name, discount_percent, start_time, end_time, status, created_at
                    FROM FlashSale
                    ORDER BY created_at ASC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(FlashSale.class)
                        .list()
        );
    }

    public boolean deleteById(int id) {
        String sql = "DELETE FROM FlashSale WHERE id = ?";

        // Xóa liên kết trong bảng trung gian FlashSale_Comics (nếu có ràng buộc foreign key)
        String deleteLinksSql = "DELETE FROM FlashSale_Comics WHERE flashsale_id = ?";

        return jdbi.withHandle(handle -> {
            // Xóa liên kết trước (nếu bảng trung gian có foreign key)
            handle.createUpdate(deleteLinksSql)
                    .bind(0, id)
                    .execute();

            // Xóa FlashSale chính
            int rows = handle.createUpdate(sql)
                    .bind(0, id)
                    .execute();
            return rows > 0;
        });
    }

    public FlashSale getById(int id) {

        updateStatuses();

        String sql = "SELECT * FROM FlashSale WHERE id = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, id)
                        .mapToBean(FlashSale.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public boolean updateFlashSale(int id, String name, double discountPercent, LocalDateTime startTime, LocalDateTime endTime) {
        String sql = """
                    UPDATE FlashSale 
                    SET name = :name,
                        discount_percent = :discountPercent,
                        start_time = :startTime,
                        end_time = :endTime
                    WHERE id = :id
                """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("name", name)
                        .bind("discountPercent", discountPercent)
                        .bind("startTime", startTime)
                        .bind("endTime", endTime)
                        .bind("id", id)
                        .execute() > 0
        );
    }

    public void updateStatuses() {
        String sql = """
                    UPDATE FlashSale
                    SET status = CASE
                        WHEN NOW() < start_time THEN 'scheduled'
                        WHEN NOW() >= start_time AND NOW() <= end_time THEN 'active'
                        WHEN NOW() > end_time THEN 'ended'
                    END
                    WHERE status != CASE
                        WHEN NOW() < start_time THEN 'scheduled'
                        WHEN NOW() >= start_time AND NOW() <= end_time THEN 'active'
                        WHEN NOW() > end_time THEN 'ended'
                    END
                """;

        jdbi.useHandle(handle -> handle.createUpdate(sql).execute());
    }


    public List<FlashSale> getUpcomingFlashSales(int limit) {
        String sql = """
                    SELECT *
                    FROM FlashSale
                    WHERE (status = 'scheduled' OR status = 'active')
                      AND end_time >= NOW()
                    ORDER BY start_time ASC
                    LIMIT ?
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, limit)
                        .mapToBean(FlashSale.class)
                        .list()
        );
    }

    /**
     * Update Flash Sale với transaction
     */
    public boolean updateFlashSaleWithComics(int id, String name, double discountPercent,
                                             LocalDateTime startTime, LocalDateTime endTime,
                                             List<Integer> comicIds) {
        return jdbi.inTransaction(handle -> {
            // Update flash sale
            int updated = handle.createUpdate("""
                                UPDATE FlashSale 
                                SET name = :name,
                                    discount_percent = :discountPercent,
                                    start_time = :startTime,
                                    end_time = :endTime
                                WHERE id = :id
                            """)
                    .bind("name", name)
                    .bind("discountPercent", discountPercent)
                    .bind("startTime", startTime)
                    .bind("endTime", endTime)
                    .bind("id", id)
                    .execute();

            if (updated == 0) return false;

            // Delete old links
            handle.createUpdate("DELETE FROM FlashSale_Comics WHERE flashsale_id = ?")
                    .bind(0, id)
                    .execute();

            // Insert new links
            if (comicIds != null && !comicIds.isEmpty()) {
                var batch = handle.prepareBatch(
                        "INSERT INTO FlashSale_Comics (flashsale_id, comic_id) VALUES (?, ?)"
                );
                for (int comicId : comicIds) {
                    batch.bind(0, id).bind(1, comicId).add();
                }
                batch.execute();
            }

            return true;
        });
    }


    /**
     * Lấy danh sách Flash Sale đang active và sắp diễn ra
     * Sắp xếp theo thời gian bắt đầu
     */
    public List<FlashSale> getUpcomingAndActiveFlashSales() {

        updateStatuses();

        String sql = """
                    SELECT *
                    FROM FlashSale
                    WHERE status IN ('active', 'scheduled')
                    ORDER BY start_time ASC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(FlashSale.class)
                        .list()
        );
    }

    /**
     * Lấy Flash Sale theo trạng thái
     */
    public List<FlashSale> getFlashSalesByStatus(String status) {
        updateStatuses();

        String sql = """
        SELECT *
        FROM FlashSale
        WHERE status = :status
        ORDER BY start_time ASC
    """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("status", status)
                        .mapToBean(FlashSale.class)
                        .list()
        );
    }

    /**
     * Kiểm tra xem có Flash Sale nào đang active không
     */
    public boolean hasActiveFlashSale() {
        updateStatuses();

        String sql = """
        SELECT COUNT(*) 
        FROM FlashSale
        WHERE status = 'active'
          AND start_time <= NOW()
          AND end_time >= NOW()
    """;

        return jdbi.withHandle(handle -> {
            Integer count = handle.createQuery(sql)
                    .mapTo(Integer.class)
                    .one();
            return count != null && count > 0;
        });
    }

/**
 * Lấy Flash Sale tiếp theo sẽ bắt đầu
 */
public FlashSale getNextScheduledFlashSale() {
    updateStatuses();

    String sql = """
        SELECT *
        FROM FlashSale
        WHERE status = 'scheduled'
          AND start_time > NOW()
        ORDER BY start_time ASC
        LIMIT 1
    """;

    return jdbi.withHandle(handle ->
            handle.createQuery(sql)
                    .mapToBean(FlashSale.class)
                    .findOne()
                    .orElse(null)
    );
}


    /**
     * Lấy tất cả Flash Sale (cho admin)
     */
    public List<FlashSale> getAllFlashSalesForUser() {
        updateStatuses();

        String sql = """
        SELECT *
        FROM FlashSale
        WHERE status IN ('active', 'scheduled')
        ORDER BY 
            CASE 
                WHEN status = 'active' THEN 1
                WHEN status = 'scheduled' THEN 2
                ELSE 3
            END,
            start_time ASC
    """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(FlashSale.class)
                        .list()
        );
    }
}
