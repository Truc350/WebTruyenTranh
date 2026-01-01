package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.sqlobject.statement.SqlQuery;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.ComicImage;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Review;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.TextUtils;

import java.util.ArrayList;
import java.util.List;

public class ComicDAO extends ADao {

    public List<Comic> searchCandidate(String keyword) {

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
        String sql = "SELECT * FROM Comics WHERE id = :id AND is_deleted = 0";

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
    public List<Comic> getRelatedComics(int comicId, int limit) {
        String inforSql = """
            SELECT series_id, volume
            FROM Comics
            WHERE id = :comicId
            """;

        Comic current = jdbi.withHandle(h ->
                h.createQuery(inforSql)
                        .bind("comicId", comicId)
                        .mapToBean(Comic.class)
                        .one()
        );

        Integer seriesId = current.getSeriesId();
        Integer currentVolume = current.getVolume();

        // 2️⃣ Query truyện liên quan
        String sql = """
        SELECT DISTINCT c.*
        FROM Comics c
        WHERE c.id != :comicId
          AND c.is_deleted = 0
          AND c.status = 'available'
          AND (
              (
                  c.series_id = :seriesId
                  AND c.volume IS NOT NULL
              )
              OR c.category_id = (
                  SELECT category_id FROM Comics WHERE id = :comicId
              )
          )
        ORDER BY
            CASE
                WHEN c.series_id = :seriesId AND c.volume > :currentVolume THEN 0
                WHEN c.series_id = :seriesId AND c.volume < :currentVolume THEN 1
                ELSE 2
            END,
            CASE
                WHEN c.series_id = :seriesId THEN c.volume
                ELSE c.created_at
            END
        LIMIT :limit
        """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("comicId", comicId)
                        .bind("seriesId", seriesId)
                        .bind("currentVolume", currentVolume != null ? currentVolume : -1)
                        .bind("limit", limit)
                        .mapToBean(Comic.class)
                        .list()
        );
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
}
