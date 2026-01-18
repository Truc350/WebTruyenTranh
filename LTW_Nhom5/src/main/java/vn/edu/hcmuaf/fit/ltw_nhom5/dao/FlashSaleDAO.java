package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;

import java.util.List;

public class FlashSaleDAO extends ADao{
    public FlashSale getActiveFlashSaleEndingSoon() {
        String sql = """
            SELECT *
            FROM FlashSale
            WHERE status = 'active'
              AND start_time <= NOW()
              AND end_time >= NOW()
            ORDER BY end_time DESC
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
            VALUES (:name, :discountPercent, :startTime, :endTime, 'scheduled')
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
}
