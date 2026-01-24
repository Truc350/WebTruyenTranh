package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Review;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.ReviewImage;


import java.util.List;

public class ReviewDAO {
    private final Jdbi jdbi;

    public ReviewDAO() {
        this.jdbi = JdbiConnector.get();
    }

    /**
     * Thêm review mới
     */
    public int addReview(Review review) {
        String sql = "INSERT INTO reviews (comic_id, user_id, rating, comment, created_at) " +
                "VALUES (:comicId, :userId, :rating, :comment, NOW())";

        return jdbi.withHandle(handle -> {
            int reviewId = handle.createUpdate(sql)
                    .bind("comicId", review.getComicId())
                    .bind("userId", review.getUserId())
                    .bind("rating", review.getRating())
                    .bind("comment", review.getComment())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            System.out.println("Review created with ID: " + reviewId);
            return reviewId;
        });
    }

    /**
     * Thêm ảnh review
     */
    public boolean addReviewImage(int reviewId, String imageUrl) {
        String sql = "INSERT INTO reviewimages (review_id, image_url) VALUES (?, ?)";

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, reviewId)
                        .bind(1, imageUrl)
                        .execute() > 0
        );
    }

    /**
     * Kiểm tra user đã review order này chưa
     */
    public boolean hasUserReviewedOrder(int userId, int orderId) {
        String sql = "SELECT COUNT(*) FROM reviews r " +
                "INNER JOIN order_items oi ON r.comic_id = oi.comic_id " +
                "WHERE oi.order_id = ? AND r.user_id = ?";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, orderId)
                        .bind(1, userId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    /**
     * Lấy danh sách review theo comic_id
     */
    public List<Review> getReviewsByComicId(int comicId) {
        String sql = "SELECT r.*, u.username FROM reviews r " +
                "INNER JOIN users u ON r.user_id = u.id " +
                "WHERE r.comic_id = ? ORDER BY r.created_at DESC";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, comicId)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    /**
     * Lấy danh sách ảnh của review
     */
    public List<ReviewImage> getReviewImages(int reviewId) {
        String sql = "SELECT * FROM reviewimages WHERE review_id = ?";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, reviewId)
                        .mapToBean(ReviewImage.class)
                        .list()
        );
    }

    /**
     * Lấy điểm trung bình của comic
     */
    public double getAverageRating(int comicId) {
        String sql = "SELECT COALESCE(AVG(rating), 0) FROM reviews WHERE comic_id = ?";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, comicId)
                        .mapTo(Double.class)
                        .one()
        );
    }
}