package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.ComicImage;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Review;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.TextUtils;

import java.util.ArrayList;
import java.util.List;

public class ComicDAO extends ADao {
    private final Jdbi jdbi;

    public ComicDAO() {
        this.jdbi = JdbiConnector.get();
    }

    public ComicDAO(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    public List<Comic> searchCandidate(String keyword) {

        System.out.println("=== DEBUG searchCandidate ===");
        System.out.println("Input keyword: " + keyword);
        String normalized = TextUtils.normalize(keyword.toLowerCase());
        String number = keyword.replaceAll("\\D+", "");

        String sql = """
                    SELECT DISTINCT c.*
                    FROM Comics c
                    WHERE c.is_deleted = 0
                      AND c.status = 'available'
                    ORDER BY c.name_comics
                    LIMIT 500
                """;

        List<Comic> allComics = new ArrayList<>(
                jdbi.withHandle(h ->
                        h.createQuery(sql)
                                .mapToBean(Comic.class)
                                .list()
                )
        );

        System.out.println("✅ Total comics from DB: " + allComics.size());

        // ===== TÁCH TỪ =====
        String[] words = normalized.split("\\s+");
        List<String> meaningfulWords = new ArrayList<>();
        for (String word : words) {
            if (!word.matches("tap|vol|volume|\\d+")) {
                meaningfulWords.add(word);
            }
        }

        int volumeNum = number.isEmpty() ? -1 : Integer.parseInt(number);

        // ===== FILTER THỦ CÔNG (KHÔNG STREAM) =====
        List<Comic> result = new ArrayList<>();

        for (Comic c : allComics) {
            String name = TextUtils.normalize(c.getNameComics().toLowerCase());

            int matchCount = 0;
            for (String w : meaningfulWords) {
                if (name.contains(w)) {
                    matchCount++;
                }
            }

            boolean nameMatch;
            if (meaningfulWords.isEmpty()) {
                nameMatch = true;
            } else if (meaningfulWords.size() == 1) {
                nameMatch = matchCount >= 1;
            } else {
                nameMatch = ((double) matchCount / meaningfulWords.size()) >= 0.5;
            }

            boolean volumeMatch = c.getVolume() != null && c.getVolume() == volumeNum;

            boolean ok;
            if (volumeNum != -1 && !meaningfulWords.isEmpty()) {
                ok = nameMatch && volumeMatch;
            } else if (volumeNum != -1) {
                ok = volumeMatch;
            } else {
                ok = nameMatch;
            }

            if (ok) {
                result.add(c);
            }

            if (result.size() >= 100) break;
        }

        System.out.println("✅ After filter: " + result.size());
        System.out.println("===========================\n");

        return result;
    }

    public List<Comic> smartSearch(String keyword) {

        List<Comic> candidates = new ArrayList<>(searchCandidate(keyword));

        String normKey = TextUtils.normalize(keyword.toLowerCase());
        String[] words = normKey.split("\\s+");
        String number = keyword.replaceAll("\\D+", "");

        candidates.sort((a, b) -> {
            int scoreA = score(a, words, number, normKey);
            int scoreB = score(b, words, number, normKey);
            return Integer.compare(scoreB, scoreA);
        });

        return candidates;
    }

    private int score(Comic c, String[] words, String number, String fullKeyword) {
        String name = TextUtils.normalize(c.getNameComics().toLowerCase());
        int score = 0;

        // 1. Khớp chính xác toàn bộ (cao nhất)
        if (name.equals(fullKeyword)) {
            score += 1000;
        }

        // 2. Chứa toàn bộ cụm từ liên tiếp
        if (name.contains(fullKeyword)) {
            score += 500;
        }

        // 3. Đếm số từ khớp
        int matchCount = 0;
        for (String word : words) {
            if (name.contains(word)) {
                matchCount++;
                score += 50;
            }
        }

        // 4. Bonus nếu khớp tất cả các từ
        if (matchCount == words.length) {
            score += 200;
        }

        // 5. Khớp đúng số tập/volume (QUAN TRỌNG!)
        if (!number.isEmpty()) {
            try {
                int targetNum = Integer.parseInt(number);

                // Kiểm tra cột volume
                if (c.getVolume() != null && c.getVolume() == targetNum) {
                    score += 400;
                }

                // Kiểm tra trong tên: "tập 4", "tap 4", "volume 4", "vol 4"
                String numPattern = ".*(tap|volume|vol)\\s*0*" + number + "([^0-9]|$).*";
                if (name.matches(numPattern)) {
                    score += 300;
                }

            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        // 6. Ưu tiên tên ngắn hơn (chính xác hơn)
        score -= name.length() / 10;

        return score;
    }


    // Tìm theo tác giả
    public List<Comic> findByAuthor(String authorName) {
        String sql = """
                SELECT DISTINCT c.* 
                FROM Comics c
                INNER JOIN Comic_Authors ca ON c.id = ca.comic_id
                INNER JOIN Authors a ON ca.author_id = a.id
                WHERE LOWER(a.name) LIKE :author
                  AND a.is_deleted = 0
                  AND c.is_deleted = 0
                  AND c.status = 'available'
                ORDER BY c.name_comics
                """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("author", "%" + authorName.toLowerCase() + "%")
                        .mapToBean(Comic.class)
                        .list()
        );
    }

    // Tìm theo nhà xuất bản
    public List<Comic> findByPublisher(String publisherName) {
        String sql = """
                SELECT DISTINCT c.* 
                FROM Comics c
                INNER JOIN Comic_Publishers cp ON c.id = cp.comic_id
                INNER JOIN Publishers p ON cp.publisher_id = p.id
                WHERE LOWER(p.name) LIKE :publisher
                  AND p.is_deleted = 0
                  AND c.is_deleted = 0
                  AND c.status = 'available'
                ORDER BY c.name_comics
                """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("publisher", "%" + publisherName.toLowerCase() + "%")
                        .mapToBean(Comic.class)
                        .list()
        );
    }

    // Lấy danh sách tác giả của một comic
    public List<String> getAuthorsByComicId(int comicId) {
        String sql = """
                SELECT a.name
                FROM Authors a
                INNER JOIN Comic_Authors ca ON a.id = ca.author_id
                WHERE ca.comic_id = :comicId
                  AND a.is_deleted = 0
                ORDER BY a.name
                """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("comicId", comicId)
                        .mapTo(String.class)
                        .list()
        );
    }

    // Lấy danh sách nhà xuất bản của một comic
    public List<String> getPublishersByComicId(int comicId) {
        String sql = """
                SELECT p.name
                FROM Publishers p
                INNER JOIN Comic_Publishers cp ON p.id = cp.publisher_id
                WHERE cp.comic_id = :comicId
                  AND p.is_deleted = 0
                ORDER BY p.name
                """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("comicId", comicId)
                        .mapTo(String.class)
                        .list()
        );
    }

    // Tìm các tập khác trong cùng series
    public List<Comic> findBySeriesId(int seriesId, int excludeId) {

        String sql = """
                    SELECT *
                    FROM Comics
                    WHERE series_id = :sid
                      AND id != :id
                      AND is_deleted = 0
                      AND status = 'available'
                    ORDER BY 
                        CASE WHEN volume IS NOT NULL THEN volume ELSE 999999 END,
                        name_comics
                """;

        return new ArrayList<>(
                jdbi.withHandle(h ->
                        h.createQuery(sql)
                                .bind("sid", seriesId)
                                .bind("id", excludeId)
                                .mapToBean(Comic.class)
                                .list()
                )
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
                    LIMIT 5
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

    /**
     * Lấy thông tin chi tiết truyện theo ID
     */
    public Comic getComicById(int id) {
        String sql = """
                    SELECT
                        id,
                        name_comics,
                        description,
                        author,
                        publisher,
                        price,
                        thumbnail_url
                    FROM Comics
                    WHERE id = :id
                """;


        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Comic.class)
                        .findOne()
                        .orElse(null)
        );
    }


    /**
     * Lấy danh sách ảnh của truyện
     */
    public List<ComicImage> getComicImages(int comicId) {
        String sql = """
                SELECT * FROM Comic_Images 
                WHERE comic_id = :comicId 
                ORDER BY sort_order ASC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("comicId", comicId)
                        .mapToBean(ComicImage.class)
                        .list()
        );
    }

    /**
     * Lấy danh sách truyện tương tự (cùng series hoặc cùng thể loại)
     */
    public List<Comic> getRelatedComics(int comicId) {

        final int LIMIT = 9;

        Comic current = jdbi.withHandle(h ->
                h.createQuery("""
                                    SELECT id, series_id, volume, category_id
                                    FROM Comics
                                    WHERE id = :comicId
                                """)
                        .bind("comicId", comicId)
                        .mapToBean(Comic.class)
                        .one()
        );

        List<Comic> result = new ArrayList<>();

        // 1️⃣ Cùng series
        if (current.getSeriesId() != null && current.getVolume() != null) {
            result.addAll(jdbi.withHandle(h ->
                    h.createQuery("""
                                        SELECT *
                                        FROM Comics
                                        WHERE series_id = :seriesId
                                          AND volume > :volume
                                          AND id != :comicId
                                          AND is_deleted = 0
                                          AND status = 'available'
                                        ORDER BY volume ASC
                                        LIMIT 9
                                    """)
                            .bind("seriesId", current.getSeriesId())
                            .bind("volume", current.getVolume())
                            .bind("comicId", comicId)
                            .mapToBean(Comic.class)
                            .list()
            ));
        }

        // 2️⃣ Build Excluded IDs (LUÔN CÓ ÍT NHẤT 1 PHẦN TỬ)
        List<Integer> excludedIds = new ArrayList<>();
        excludedIds.add(comicId); // ← Luôn có ít nhất comicId
        result.forEach(c -> excludedIds.add(c.getId()));

        // 3️⃣ Cùng thể loại (CHECK SIZE TRƯỚC KHI QUERY)
        if (result.size() < LIMIT) {
            int need = LIMIT - result.size();

            result.addAll(jdbi.withHandle(h ->
                    h.createQuery("""
                                        SELECT *
                                        FROM Comics
                                        WHERE category_id = :categoryId
                                          AND id NOT IN (<excludedIds>)
                                          AND is_deleted = 0
                                          AND status = 'available'
                                        ORDER BY created_at DESC
                                        LIMIT :limit
                                    """)
                            .bind("categoryId", current.getCategoryId())
                            .bind("limit", need)
                            .bindList("excludedIds", excludedIds)
                            .mapToBean(Comic.class)
                            .list()
            ));
        }

        // UPDATE excludedIds sau mỗi lần thêm
        List<Integer> finalExcludedIds = new ArrayList<>();
        finalExcludedIds.add(comicId);
        result.forEach(c -> finalExcludedIds.add(c.getId()));

        // 4️⃣ Random (NẾU VẪN CHƯA ĐỦ)
        if (result.size() < LIMIT) {
            int need = LIMIT - result.size();

            result.addAll(jdbi.withHandle(h ->
                    h.createQuery("""
                                        SELECT *
                                        FROM Comics
                                        WHERE id NOT IN (<excludedIds>)
                                          AND is_deleted = 0
                                          AND status = 'available'
                                        ORDER BY RAND()
                                        LIMIT :limit
                                    """)
                            .bind("limit", need)
                            .bindList("excludedIds", finalExcludedIds)
                            .mapToBean(Comic.class)
                            .list()
            ));
        }

        // 5️⃣ CẮT CỨNG 9
        return result.size() > LIMIT
                ? result.subList(0, LIMIT)
                : result;
    }

    /**
     * Lấy danh sách đánh giá của truyện
     */
    public List<Review> getComicReviews(int comicId) {
        String sql = """
                SELECT r.id, r.comic_id, r.user_id, r.rating, r.comment, r.created_at,
                       u.username 
                FROM Reviews r
                JOIN Users u ON r.user_id = u.id
                WHERE r.comic_id = :comicId
                ORDER BY r.created_at DESC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("comicId", comicId)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    /**
     * Tính điểm đánh giá trung bình
     */
    public double getAverageRating(int comicId) {
        String sql = """
                SELECT COALESCE(AVG(rating), 0) as avg_rating 
                FROM Reviews 
                WHERE comic_id = :comicId
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("comicId", comicId)
                        .mapTo(Double.class)
                        .findOne()
                        .orElse(0.0)
        );
    }

    /**
     * Gợi ý comics dựa trên wishlist của user
     * Ưu tiên:
     * 1. Tập tiếp theo của series đang có trong wishlist
     * 2. Comics cùng thể loại với wishlist
     * 3. Comics phổ biến (fallback nếu wishlist trống)
     */
    public List<Comic> getRecommendedComics(int userId, int limit) {
        String sql = """
                WITH wishlist_data AS(
                SELECT DISTINCT
                    c.series_id,
                    c.category_id,
                    c.volume
                FROM Wishlist w
                JOIN Comics c ON w.comic_id = c.id
                WHERE w.user_id = :userId
                AND c.is_deleted = 0
                ),
                next_volumes AS(
                -- Tập tiếp theo của series trong wishlist
                SELECT DISTINCT c.*,
                    1 as priority_score,
                    'next_volume' as reason
                FROM Comics c
                JOIN wishlist_data wd ON c.series_id = wd.series_id
                WHERE c.volume = wd.volume + 1
                AND c.is_deleted = 0
                AND c.stock_quantity > 0
                AND c.id NOT IN (SELECT comic_id FROM Wishlist WHERE user_id = :userId)
                ),
                same_category AS(
                SELECT DISTINCT c.*,
                2 as priority_score,
                'same_category' as reason
                FROM Comics c
                JOIN wishlist_data wd ON c.category_id = wd.category_id
                AND c.stock_quantity > 0
                AND c.id NOT IN (SELECT comic_id FROM Wishlist WHERE user_id = :userId)
                AND c.id NOT IN (SELECT id FROM next_volumes)
                ),
                popular_comics AS (
                SELECT DISTINCT c.*,
                3 as priority_score,
                'popular' as reason
                FROM Comics c
                LEFT JOIN Order_Items oi ON c.id = oi.comic_id
                LEFT JOIN Orders o ON oi.order_id = o.id
                AND o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
                WHERE c.is_deleted = 0
                AND c.stock_quantity > 0
                AND c.id NOT IN (SELECT comic_id FROM Wishlist WHERE user_id = :userId)
                AND c.id NOT IN (SELECT id FROM next_volumes)
                AND c.id NOT IN (SELECT id FROM same_category)
                GROUP BY c.id
                ORDER BY COUNT(oi.id) DESC
                )
                SELECT * FROM (
                  SELECT * FROM next_volumes
                  UNION ALL
                  SELECT * FROM same_category
                  UNION ALL
                  SELECT * FROM popular_comics
                  ) as recommended
                  ORDER BY priority_score, RAND()
                  LIMIT :limit
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql).bind("userId", userId).bind("limit", limit).mapToBean(Comic.class).list()
        );
    }

    /**
     * Gợi ý cho user chưa đăng nhập hoặc wishlist trống
     */
    public List<Comic> getPopularComics(int limit) {
        String sql = """
                SELECT c.*
                FROM Comics c
                LEFT JOIN Order_Items oi ON c.id = oi.comic_id
                LEFT JOIN Orders o ON oi.order_id = o.id\s
                     AND o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
                WHERE c.is_deleted = 0
                AND c.stock_quantity > 0
                GROUP BY c.id
                ORDER BY COUNT(oi.id) DESC, c.created_at DESC
                LIMIT :limit
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", limit)
                        .mapToBean(Comic.class).list()
        );
    }

    /**
     * Lấy tập tiếp theo của một series
     */
    public Comic getNextVolume(int seriesId, int currentVolume) {
        String sql = """
                SELECT * FROM Comics
                WHERE series_id = :seriesId
                AND volume = :nextVolume
                AND is_deleted = 0
                AND stock_quantity > 0
                LIMIT 1
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("seriesId", seriesId)
                        .bind("nextVolume", currentVolume + 1)
                        .mapToBean(Comic.class)
                        .findOne()
                        .orElse(null)
        );
    }

    /**
     * Lấy comics cùng thể loại
     */
    public List<Comic> getComicsByCategory(int categoryId, int excludeComicId, int limit) {
        String sql = """
                SELECT * FROM Comics
                WHERE category_id = :categoryId
                AND id != :excludeId
                AND is_deleted = 0
                AND stock_quantity > 0
                ORDER BY RAND()
                LIMIT :limit
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .bind("excludeId", excludeComicId)
                        .bind("limit", limit)
                        .mapToBean(Comic.class)
                        .list()
        );
    }

    /**
     * Lấy top comics bán chạy trong tuần
     */
    public List<Comic> getTopSellingComics(int limit) {
        String sql = """
                SELECT c.*, 
                    COALESCE(SUM(oi.quantity), 0) as totalSold
                FROM Comics c
                LEFT JOIN Order_Items oi ON c.id = oi.comic_id
                LEFT JOIN Orders o ON oi.order_id = o.id
                    AND o.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
                    AND o.status != 'cancelled'
                WHERE c.is_deleted = 0
                GROUP BY c.id
                ORDER BY totalSold DESC, c.created_at DESC
                LIMIT :limit
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", limit)
                        .mapToBean(Comic.class)
                        .list()
        );
    }

    /**
     * Lấy comic theo ID
     */
    public Comic getComicById1(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM Comics WHERE id = :id AND is_deleted = 0")
                        .bind("id", id)
                        .mapToBean(Comic.class)
                        .findOne()
                        .orElse(null)
        );
    }
}

