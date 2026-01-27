// src/main/java/vn/edu/hcmuaf/fit/ltw_nhom5/service/ComicService.java
package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ReviewDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.ComicImage;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Review;

import java.util.List;

public class ComicService {

    private final Jdbi jdbi;
    private final ComicDAO comicDAO;
    private SeriesDAO seriesDAO = new SeriesDAO();
    private CategoriesDao categoriesDao = new CategoriesDao();
    private ReviewDAO reviewDAO;

    public ComicService() {
        this.jdbi = JdbiConnector.get();
        this.comicDAO = new ComicDAO();
        reviewDAO = new ReviewDAO();
    }

    // Constructor nhận Jdbi (sẽ được inject từ servlet hoặc class config)
    public ComicService(Jdbi jdbi) {
        this.jdbi = jdbi;
        this.comicDAO = new ComicDAO();
    }

    public ComicService(Jdbi jdbi, ComicDAO comicDAO) {
        this.jdbi = jdbi;
        this.comicDAO = comicDAO;
    }

    /**
     * Lấy danh sách gợi ý truyện cho trang chủ
     * @param userId ID người dùng (null nếu chưa login)
     * @return List<Comic> tối đa 12 cuốn
     */
//    public List<Comic> getSuggestedComics(Integer userId) {
//        List<Comic> suggested = new ArrayList<>();
//
//        if (userId != null) {
//            // 1. Tập tiếp theo của series trong wishlist
//            String sqlNextVolume = """
//                SELECT c.*
//                FROM comics c
//                WHERE c.series_id IN (
//                    SELECT DISTINCT c2.series_id
//                    FROM comics c2
//                    JOIN wishlist w ON c2.id = w.comic_id
//                    WHERE w.user_id = :userId AND c2.is_deleted = 0
//                )
//                AND c.volume = (
//                    SELECT MAX(c3.volume) + 1
//                    FROM comics c3
//                    JOIN wishlist w2 ON c3.id = w2.comic_id
//                    WHERE c3.series_id = c.series_id
//                      AND w2.user_id = :userId
//                      AND c3.is_deleted = 0
//                )
//                AND c.is_deleted = 0
//                LIMIT 8
//                """;
//
//            List<Comic> nextVolumes = jdbi.withHandle(handle ->
//                    handle.createQuery(sqlNextVolume)
//                            .bind("userId", userId)
//                            .mapToBean(Comic.class)
//                            .list()
//            );
//            suggested.addAll(nextVolumes);
//
//            // 2. Bổ sung cùng thể loại nếu chưa đủ
//            if (suggested.size() < 12) {
//                int need = 12 - suggested.size();
//
//                String sqlSameCategory = """
//                    SELECT c.*
//                    FROM comics c
//                    WHERE c.category_id IN (
//                        SELECT DISTINCT c2.category_id
//                        FROM comics c2
//                        JOIN wishlist w ON c2.id = w.comic_id
//                        WHERE w.user_id = :userId AND c2.is_deleted = 0
//                    )
//                    AND c.id NOT IN (SELECT comic_id FROM wishlist WHERE user_id = :userId)
//                    AND c.is_deleted = 0
//                    ORDER BY RAND()
//                    LIMIT :limit
//                    """;
//
//                List<Comic> sameCategory = jdbi.withHandle(handle ->
//                        handle.createQuery(sqlSameCategory)
//                                .bind("userId", userId)
//                                .bind("limit", need)
//                                .mapToBean(Comic.class)
//                                .list()
//                );
//                suggested.addAll(sameCategory);
//            }
//        }
//
//        // 3. Fallback: Chưa login hoặc wishlist rỗng → truyện mới nhất
//        if (suggested.isEmpty()) {
//            String sqlLatest = """
//                SELECT *
//                FROM comics
//                WHERE is_deleted = 0
//                ORDER BY created_at DESC
//                LIMIT 12
//                """;
//
//            suggested = jdbi.withHandle(handle ->
//                    handle.createQuery(sqlLatest)
//                            .mapToBean(Comic.class)
//                            .list()
//            );
//        }
//
//        return suggested;
//    }

    /**
     * Lấy danh sách gợi ý truyện
     */
    public List<Comic> getSuggestedComics(Integer userId) {
        return comicDAO.getSuggestedComics(userId);
    }

    /**
     * Lấy danh sách ảnh của truyện
     */
    public List<ComicImage> getComicImages(int comicId) {
        return comicDAO.getComicImages(comicId);
    }

    /**
     * Lấy danh sách truyện tương tự
     */
    public List<Comic> getRelatedComics(int comicId) {
        return comicDAO.getRelatedComics(comicId);
    }

    /**
     * Tính điểm đánh giá trung bình
     */
    public double getAverageRating(int comicId) {
        return comicDAO.getAverageRating(comicId);
    }

    /**
     * Tìm kiếm thông minh
     */
    public List<Comic> smartSearch(String keyword) {
        return comicDAO.smartSearch(keyword);
    }

    /**
     * Tìm theo tác giả
     */
    public List<Comic> findByAuthor(String authorName) {
        return comicDAO.findByAuthor(authorName);
    }

    /**
     * Tìm theo nhà xuất bản
     */
    public List<Comic> findByPublisher(String publisherName) {
        return comicDAO.findByPublisher(publisherName);
    }


    public Comic getComicById(int comicId) {
        return comicDAO.getComicById(comicId);
    }

    public String getSeriesName(Integer seriesId) {
        if (seriesId == null) return null;
        return seriesDAO.getSeriesNameById1(seriesId);
    }

    /**
     * Tìm kiếm truyện
     */
    public List<Comic> searchComicsAdmin(String keyword, String author, Integer categoryId,
                                         int page, int limit) {
        return comicDAO.searchComicsAdmin(keyword, author, categoryId, page, limit);
    }

    /**
     * Đếm số truyện theo filter
     */
    public int countComicsAdmin(String keyword, String author, Integer categoryId) {
        return comicDAO.countComicsAdmin(keyword, author, categoryId);
    }

    /**
     * Lấy tất cả truyện
     */
    public List<Comic> getAllComicsAdmin(int page, int limit) {
        return comicDAO.getAllComicsAdmin(page, limit);
    }

    /**
     * Đếm tổng số truyện
     */
    public int countAllComics() {
        return comicDAO.countAllComics();
    }

    /**
     * Lấy danh sách thể loại (cho dropdown)
     */
    public List<Category> getAllCategories() {
        return categoriesDao.listCategories();
    }

    /**
     * Lấy danh sách review của comic (BAO GỒM ẢNH)
     */
    public List<Review> getComicReviews(int comicId) {
        System.out.println("🔍 ComicService.getComicReviews() called for comic: " + comicId);

        // ⭐ QUAN TRỌNG: Gọi ReviewDAO.getReviewsByComicId()
        // Method này đã load ảnh cho mỗi review
        List<Review> reviews = reviewDAO.getReviewsByComicId(comicId);

        System.out.println("📦 ComicService returning " + reviews.size() + " reviews");
        for (Review review : reviews) {
            System.out.println("   Review #" + review.getId() + " has " +
                    review.getImages().size() + " images");
        }

        return reviews;
    }
}