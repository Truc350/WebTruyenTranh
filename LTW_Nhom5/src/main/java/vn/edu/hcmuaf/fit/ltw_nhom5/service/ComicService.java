// src/main/java/vn/edu/hcmuaf/fit/ltw_nhom5/service/ComicService.java
package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.util.ArrayList;
import java.util.List;

public class ComicService {

    private final Jdbi jdbi;

    // Constructor nhận Jdbi (sẽ được inject từ servlet hoặc class config)
    public ComicService(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    /**
     * Lấy danh sách gợi ý truyện cho trang chủ
     * @param userId ID người dùng (null nếu chưa login)
     * @return List<Comic> tối đa 12 cuốn
     */
    public List<Comic> getSuggestedComics(Integer userId) {
        List<Comic> suggested = new ArrayList<>();

        if (userId != null) {
            // 1. Tập tiếp theo của series trong wishlist
            String sqlNextVolume = """
                SELECT c.*
                FROM comics c
                WHERE c.series_id IN (
                    SELECT DISTINCT c2.series_id
                    FROM comics c2
                    JOIN wishlist w ON c2.id = w.comic_id
                    WHERE w.user_id = :userId AND c2.is_deleted = 0
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

            // 2. Bổ sung cùng thể loại nếu chưa đủ
            if (suggested.size() < 12) {
                int need = 12 - suggested.size();

                String sqlSameCategory = """
                    SELECT c.*
                    FROM comics c
                    WHERE c.category_id IN (
                        SELECT DISTINCT c2.category_id
                        FROM comics c2
                        JOIN wishlist w ON c2.id = w.comic_id
                        WHERE w.user_id = :userId AND c2.is_deleted = 0
                    )
                    AND c.id NOT IN (SELECT comic_id FROM wishlist WHERE user_id = :userId)
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

        // 3. Fallback: Chưa login hoặc wishlist rỗng → truyện mới nhất
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