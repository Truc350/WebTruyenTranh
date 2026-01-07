package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.WishlistDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Service xử lý logic gợi ý sản phẩm
 */
public class RecommendationService {
    private final ComicDAO comicDAO;
    private final WishlistDAO wishlistDAO;

    public RecommendationService() {
        this.comicDAO = new ComicDAO();
        this.wishlistDAO = new WishlistDAO();
    }

    public RecommendationService(ComicDAO comicDAO, WishlistDAO wishlistDAO) {
        this.comicDAO = comicDAO;
        this.wishlistDAO = wishlistDAO;
    }

    /**
     * Lấy danh sách gợi ý cho user
     * Logic ưu tiên:
     * 1. Nếu user có wishlist -> gợi ý thông minh
     * 2. Nếu wishlist trống hoặc chưa login -> gợi ý popular
     */
    public List<Comic> getRecommendations(Integer userId, int limit) {
        if (userId == null) {
            return getPopularRecommendations(limit);
        }

        int wishlistCount = wishlistDAO.getWishlistCount(userId);

        if (wishlistCount == 0) {
            return getPopularRecommendations(limit);
        }

        return getPersonalizedRecommendations(userId, limit);
    }

    private List<Comic> getPersonalizedRecommendations(Integer userId, int limit) {
        List<Comic> recommendations = comicDAO.getRecommendedComics(userId, limit);
        // Nếu không đủ recommendations, bổ sung bằng popular comics
        if (recommendations.size() < limit) {
            Set<Integer> existingIds = recommendations.stream()
                    .map(Comic::getId)
                    .collect(Collectors.toSet());
            List<Comic> popularComics = comicDAO.getPopularComics(limit - recommendations.size());
            for (Comic comic : popularComics) {
                if (!existingIds.contains(comic.getId())) {
                    recommendations.add(comic);
                    if (recommendations.size() >= limit) {
                        break;
                    }
                }
            }
        }
        return recommendations;
    }

    /**
     * Gợi ý comics phổ biến (cho user chưa login hoặc wishlist trống)
     */
    private List<Comic> getPopularRecommendations(int limit) {
        return comicDAO.getPopularComics(limit);
    }

    /**
     * Gợi ý tập tiếp theo của series
     */
    public Comic getNextVolumeRecommendation(int comicId) {
        Comic currentComic = comicDAO.getComicById1(comicId);
        if (currentComic == null || currentComic.getSeriesId() == null) {
            return null;
        }
        return comicDAO.getNextVolume(currentComic.getSeriesId(), currentComic.getVolume() != null ? currentComic.getVolume() : 0);
    }

    /**
     * Gợi ý comics tương tự (cùng thể loại)
     */
    public List<Comic> getSimilarComics(int comicId, int limit) {
        Comic comic = comicDAO.getComicById1(comicId);
        if (comic == null || comic.getCategoryId() == null) {
            return comicDAO.getPopularComics(limit);
        }
        return comicDAO.getComicsByCategory(comic.getCategoryId(), comicId, limit);
    }

    /**
     * Lấy danh sách gợi ý chi tiết với thông tin bổ sung
     */
    public Map<String, Object> getDetailedRecommendations(Integer userId, int limit) {
        Map<String, Object> result = new HashMap<>();
        List<Comic> recommendations = getRecommendations(userId, limit);
        result.put("comics", recommendations);
        if (userId != null) {
            int wishlistCount = wishlistDAO.getWishlistCount(userId);
            result.put("isPersonalized", wishlistCount > 0);
            result.put("wishlistCount", wishlistCount);
        } else {
            result.put("isPersonalized", false);
            result.put("wishlistCount", 0);
        }
        return result;
    }

    /**
     * Phân loại gợi ý theo nguồn
     */
    public Map<String, List<Comic>> getCategorizedRecommendations(int userId) {
        Map<String, List<Comic>> categorized = new LinkedHashMap<>();
        List<Comic> wishlistComics = wishlistDAO.getWishlistComics(userId);
        // Tập tiếp theo
        List<Comic> nextVolumes = new ArrayList<>();
        Set<Integer> addedSeriesIds = new HashSet<>();
        for (Comic wishlistComic : wishlistComics) {
            if (wishlistComic.getSeriesId() != null &&
                    !addedSeriesIds.contains(wishlistComic.getSeriesId())) {

                Comic nextVolume = comicDAO.getNextVolume(
                        wishlistComic.getSeriesId(),
                        wishlistComic.getVolume() != null ? wishlistComic.getVolume() : 0
                );

                if (nextVolume != null) {
                    nextVolumes.add(nextVolume);
                    addedSeriesIds.add(wishlistComic.getSeriesId());
                }
            }
        }
        if (!nextVolumes.isEmpty()) {
            categorized.put("Tập tiếp theo", nextVolumes);
        }
        // Comics cùng thể loại
        Set<Integer> categoryIds = wishlistComics.stream()
                .map(Comic::getCategoryId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        if (!categoryIds.isEmpty()) {
            List<Comic> sameCategory = new ArrayList<>();
            Set<Integer> addedIds = nextVolumes.stream()
                    .map(Comic::getId)
                    .collect(Collectors.toSet());
            for (Integer categoryId : categoryIds) {
                List<Comic> categoryComics = comicDAO.getComicsByCategory(categoryId, -1, 5);
                for (Comic comic : categoryComics) {
                    if (!addedIds.contains(comic.getId())) {
                        sameCategory.add(comic);
                        addedIds.add(comic.getId());

                        if (sameCategory.size() >= 8) {
                            break;
                        }
                    }
                }
                if (sameCategory.size() >= 8) {
                    break;
                }
            }
            if (!sameCategory.isEmpty()) {
                categorized.put("Cùng thể loại", sameCategory);
            }
        }
        // Comics phổ biến
        List<Comic> popular = comicDAO.getPopularComics(8);
        if (!popular.isEmpty()) {
            categorized.put("Phổ biến", popular);
        }

        return categorized;

    }
}
