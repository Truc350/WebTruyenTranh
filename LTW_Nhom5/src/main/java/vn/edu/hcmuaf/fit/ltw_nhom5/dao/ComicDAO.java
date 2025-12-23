package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.sqlobject.statement.SqlQuery;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.util.ArrayList;
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

    /**
     * Lấy danh sách gợi ý truyện cá nhân hóa cho người dùng dựa trên Wishlist
     * Ưu tiên:
     * 1. Tập tiếp theo của các series đang có trong Wishlist
     * 2. Truyện cùng thể loại với những truyện trong Wishlist
     * 3. Nếu chưa đăng nhập hoặc Wishlist rỗng → trả về 12 truyện mới nhất
     *
     * @param userId ID người dùng (có thể null nếu chưa login)
     * @return List<Comic> tối đa 12 cuốn
     */
    public List<Comic> getSuggestedComics(Integer userId) {
        List<Comic> suggested = new ArrayList<>();

        if (userId != null) {
            // -----------------------------
            // 1. Gợi ý tập tiếp theo của series trong wishlist
            // -----------------------------
            String sqlNextVolume = """
                    SELECT c.*
                    FROM comics c
                    WHERE c.series_id IN (
                        SELECT DISTINCT c2.series_id
                        FROM comics c2
                        JOIN wishlist w ON c2.id = w.comic_id
                        WHERE w.user_id = :userId
                          AND c2.is_deleted = 0
                    )
                    AND c.volume = (
                        SELECT MAX(c3.volume) + 1
                        FROM comics c3
                        JOIN wishlist w2 ON c3.id = w2.comic_id
                        WHERE c3.series_id = c.series_id
                          AND w2.user_id = :userId
                          AND c3.is_deleted = 0
                    )
                    AND c.is_deleted = 0
                    LIMIT 8
                    """;

            List<Comic> nextVolumes = jdbi.withHandle(handle ->
                    handle.createQuery(sqlNextVolume)
                            .bind("userId", userId)
                            .mapToBean(Comic.class)
                            .list()
            );

            suggested.addAll(nextVolumes);

            // -----------------------------
            // 2. Bổ sung truyện cùng thể loại (không trùng wishlist)
            // -----------------------------
            if (suggested.size() < 12) {
                int need = 12 - suggested.size();

                String sqlSameCategory = """
                        SELECT c.*
                        FROM comics c
                        WHERE c.category_id IN (
                            SELECT DISTINCT c2.category_id
                            FROM comics c2
                            JOIN wishlist w ON c2.id = w.comic_id
                            WHERE w.user_id = :userId
                              AND c2.is_deleted = 0
                        )
                        AND c.id NOT IN (
                            SELECT comic_id 
                            FROM wishlist 
                            WHERE user_id = :userId
                        )
                        AND c.is_deleted = 0
                        ORDER BY RAND()
                        LIMIT :limit
                        """;

                List<Comic> sameCategory = jdbi.withHandle(handle ->
                        handle.createQuery(sqlSameCategory)
                                .bind("userId", userId)
                                .bind("limit", need)
                                .mapToBean(Comic.class)
                                .list()
                );

                suggested.addAll(sameCategory);
            }
        }

        // -----------------------------
        // 3. Fallback: Chưa login hoặc Wishlist rỗng → lấy truyện mới nhất
        // -----------------------------
        if (suggested.isEmpty()) {
            String sqlLatest = """
                    SELECT *
                    FROM comics
                    WHERE is_deleted = 0
                    ORDER BY created_at DESC
                    LIMIT 12
                    """;

            suggested = jdbi.withHandle(handle ->
                    handle.createQuery(sqlLatest)
                            .mapToBean(Comic.class)
                            .list()
            );
        }

        return suggested;
    }

}
