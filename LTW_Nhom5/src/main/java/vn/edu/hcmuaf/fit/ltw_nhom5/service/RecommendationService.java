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
     * Lấy danh sách gợi ý cho user (CÓ TÍCH HỢP FLASH SALE)
     */
    public List<Comic> getRecommendations(Integer userId, int limit) {
        if (userId != null) {
            return comicDAO.getRecommendedComicsWithFlashSale(userId, limit);
        } else {
            return comicDAO.getPopularComicsWithFlashSale(limit);
        }
    }

    /**
     * Gợi ý comics tương tự (cùng thể loại), TÍCH HỢP FLASH SALE
     */
    public List<Comic> getSimilarComics(int comicId, int limit) {
        Comic current = comicDAO.getComicById(comicId);
        if (current == null || current.getCategoryId() == null) {
            return comicDAO.getPopularComicsWithFlashSale(limit);
        }

        return comicDAO.getComicsByCategoryWithFlashSale(
                current.getCategoryId(),
                comicId,
                limit
        );
    }

    /**
     * Gợi ý tập tiếp theo của series (CÓ FLASH SALE)
     */
    public Comic getNextVolumeRecommendation(int comicId) {
        Comic currentComic = comicDAO.getComicById(comicId);
        if (currentComic == null || currentComic.getSeriesId() == null) {
            return null;
        }
        return comicDAO.getNextVolumeWithFlashSale(
                currentComic.getSeriesId(),
                currentComic.getVolume() != null ? currentComic.getVolume() : 0
        );
    }

    /**
     * Lấy gợi ý cho trang detail (ĐÃ TÍCH HỢP FLASH SALE)
     */
    public List<Comic> getDetailPageSuggestions(Integer userId, Integer comicId, int limit) {
        List<Comic> suggestions = new ArrayList<>();

        if (userId != null && wishlistDAO.getWishlistCount(userId) > 0) {
            suggestions = getRecommendations(userId, limit);
        } else if (comicId != null) {
            suggestions = getSimilarComics(comicId, limit);
        }

        if (suggestions.isEmpty()) {
            suggestions = comicDAO.getPopularComicsWithFlashSale(limit);
        }

        return suggestions;
    }

    /**
     * Phân loại gợi ý theo nguồn (KHÔNG CÓ FLASH SALE - Deprecated)
     */
    @Deprecated
    public Map<String, List<Comic>> getCategorizedRecommendations(int userId) {
        // Method cũ, nên dùng getCategorizedRecommendationsWithFlashSale()
        return getCategorizedRecommendationsWithFlashSale(userId);
    }

    /**
     * Phân loại gợi ý theo nguồn VỚI FLASH SALE
     * Tích hợp thông tin Flash Sale vào tất cả recommendations
     */
    public Map<String, List<Comic>> getCategorizedRecommendationsWithFlashSale(int userId) {
        Map<String, List<Comic>> categorized = new LinkedHashMap<>();

        List<Comic> wishlistComics = wishlistDAO.getWishlistComics(userId);

        if (wishlistComics.isEmpty()) {
            System.out.println("⚠️ User " + userId + " has empty wishlist, returning popular comics");
            List<Comic> popular = comicDAO.getPopularComicsWithFlashSale(8);
            if (!popular.isEmpty()) {
                categorized.put("Phổ biến", popular);
            }
            return categorized;
        }

        // ========== 1. TẬP TIẾP THEO ==========
        List<Comic> nextVolumes = new ArrayList<>();
        Set<Integer> addedSeriesIds = new HashSet<>();

        for (Comic wishlistComic : wishlistComics) {
            if (wishlistComic.getSeriesId() != null &&
                    !addedSeriesIds.contains(wishlistComic.getSeriesId())) {

                Comic nextVolume = comicDAO.getNextVolumeWithFlashSale(
                        wishlistComic.getSeriesId(),
                        wishlistComic.getVolume() != null ? wishlistComic.getVolume() : 0
                );

                if (nextVolume != null) {
                    nextVolumes.add(nextVolume);
                    addedSeriesIds.add(wishlistComic.getSeriesId());

                    if (nextVolumes.size() >= 8) {
                        break;
                    }
                }
            }
        }

        if (!nextVolumes.isEmpty()) {
            categorized.put("Tập tiếp theo", nextVolumes);
            System.out.println("✅ Added " + nextVolumes.size() + " next volumes");
        }

        // ========== 2. CÙNG THỂ LOẠI ==========
        Set<Integer> categoryIds = wishlistComics.stream()
                .map(Comic::getCategoryId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        if (!categoryIds.isEmpty()) {
            List<Comic> sameCategory = new ArrayList<>();
            Set<Integer> addedIds = new HashSet<>();

            nextVolumes.forEach(comic -> addedIds.add(comic.getId()));
            wishlistComics.forEach(comic -> addedIds.add(comic.getId()));

            for (Integer categoryId : categoryIds) {
                List<Comic> categoryComics = comicDAO.getComicsByCategoryWithFlashSale(
                        categoryId, -1, 8
                );

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
                System.out.println("✅ Added " + sameCategory.size() + " same category comics");
            }
        }

        // ========== 3. PHỔ BIẾN ==========
        Set<Integer> allAddedIds = new HashSet<>();
        categorized.values().forEach(list ->
                list.forEach(comic -> allAddedIds.add(comic.getId()))
        );
        wishlistComics.forEach(comic -> allAddedIds.add(comic.getId()));

        List<Comic> popular = comicDAO.getPopularComicsWithFlashSale(16);
        List<Comic> filteredPopular = new ArrayList<>();

        for (Comic comic : popular) {
            if (!allAddedIds.contains(comic.getId())) {
                filteredPopular.add(comic);

                if (filteredPopular.size() >= 8) {
                    break;
                }
            }
        }

        if (!filteredPopular.isEmpty()) {
            categorized.put("Phổ biến", filteredPopular);
            System.out.println("✅ Added " + filteredPopular.size() + " popular comics");
        }

        System.out.println("📊 Total recommendation groups: " + categorized.size());
        return categorized;
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
     * Kiểm tra xem nên hiển thị gợi ý nào
     */
    public String getSuggestionType(Integer userId, Integer comicId) {
        if (userId == null) {
            return "popular";
        }

        int wishlistCount = wishlistDAO.getWishlistCount(userId);

        if (wishlistCount > 0) {
            return "personalized";
        } else if (comicId != null) {
            return "similar";
        } else {
            return "popular";
        }
    }
}