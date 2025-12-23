package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.util.List;

public class ComicDAO extends ADao {
    public List<Comic> search(String keyword) {
        String sql = """
                    SELECT *
                    FROM Comics
                    WHERE is_deleted = 0
                      AND status = 'available'
                      AND (name_comics LIKE :kw OR author LIKE :kw OR publisher LIKE :kw)
                    ORDER BY created_at DESC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("kw", "%" + keyword + "%")
                        .mapToBean(Comic.class)
                        .list()
        );

    }

    public List<Comic> getTop5BestSellerThisWeek() {
        String sql = """
        SELECT c.*,
               SUM(oi.quantity) AS totalSold
        FROM Order_Items oi
        JOIN Orders o ON oi.order_id = o.id
        JOIN Comics c ON oi.comic_id = c.id
        WHERE c.is_deleted = 0
          AND c.status = 'available'
          AND YEARWEEK(o.order_date, 1) = YEARWEEK(CURDATE(), 1)
        GROUP BY c.id
        ORDER BY totalSold DESC
        LIMIT 5z
    """;

        return jdbi.withHandle(handle ->
                 handle.createQuery(sql)
                        .mapToBean(Comic.class)
                        .list()
        );
    }

}
