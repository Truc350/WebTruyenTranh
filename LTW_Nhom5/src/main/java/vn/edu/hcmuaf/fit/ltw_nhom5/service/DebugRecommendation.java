package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.WishlistDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.util.List;

/**
 * Class để debug chức năng gợi ý
 * Chạy file này để kiểm tra từng bước
 */
public class DebugRecommendation {

    public static void main(String[] args) {
        // Thay userId này bằng user_id thực tế trong database của bạn
        int testUserId = 1;

        System.out.println("========================================");
        System.out.println("DEBUG RECOMMENDATION SYSTEM");
        System.out.println("========================================\n");

        ComicDAO comicDAO = new ComicDAO();
        WishlistDAO wishlistDAO = new WishlistDAO();

        // BƯỚC 1: Kiểm tra user có tồn tại không
        System.out.println("STEP 1: Checking user...");
        System.out.println("User ID: " + testUserId);
        System.out.println();

        // BƯỚC 2: Kiểm tra wishlist
        System.out.println("STEP 2: Checking wishlist...");
        int wishlistCount = wishlistDAO.getWishlistCount(testUserId);
        System.out.println("Wishlist count: " + wishlistCount);

        if (wishlistCount == 0) {
            System.out.println("⚠️ WARNING: Wishlist is EMPTY!");
            System.out.println("   Solution: Add some comics to wishlist first");
            System.out.println();
        } else {
            System.out.println("✓ Wishlist has " + wishlistCount + " items");
            System.out.println();

            // BƯỚC 3: Xem chi tiết wishlist
            System.out.println("STEP 3: Wishlist details...");
            List<Comic> wishlistComics = wishlistDAO.getWishlistComics(testUserId);
            for (int i = 0; i < wishlistComics.size(); i++) {
                Comic c = wishlistComics.get(i);
                System.out.println((i + 1) + ". " + c.getNameComics());
                System.out.println("   - Comic ID: " + c.getId());
                System.out.println("   - Series ID: " + c.getSeriesId());
                System.out.println("   - Volume: " + c.getVolume());
                System.out.println("   - Category ID: " + c.getCategoryId());
            }
            System.out.println();
        }

        // BƯỚC 4: Test query gợi ý
        System.out.println("STEP 4: Testing recommendation query...");
        try {
            List<Comic> recommendations = comicDAO.getRecommendedComics(testUserId, 10);
            System.out.println("✓ Query executed successfully!");
            System.out.println("Found " + recommendations.size() + " recommendations");
            System.out.println();

            if (recommendations.isEmpty()) {
                System.out.println("⚠️ WARNING: No recommendations found!");
                System.out.println("Possible reasons:");
                System.out.println("1. Comics in wishlist don't have series_id or category_id");
                System.out.println("2. No next volume available");
                System.out.println("3. All comics in same category are already in wishlist");
                System.out.println();
            } else {
                System.out.println("STEP 5: Recommendation details...");
                for (int i = 0; i < recommendations.size(); i++) {
                    Comic c = recommendations.get(i);
                    System.out.println((i + 1) + ". " + c.getNameComics());
                    System.out.println("   - Series ID: " + c.getSeriesId());
                    System.out.println("   - Volume: " + c.getVolume());
                    System.out.println("   - Category ID: " + c.getCategoryId());
                }
                System.out.println();
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR: Query failed!");
            System.out.println("Error message: " + e.getMessage());
            e.printStackTrace();
            System.out.println();
        }

        // BƯỚC 6: Test popular comics (fallback)
        System.out.println("STEP 6: Testing popular comics (fallback)...");
        try {
            List<Comic> popularComics = comicDAO.getPopularComics(10);
            System.out.println("✓ Found " + popularComics.size() + " popular comics");
            System.out.println();
        } catch (Exception e) {
            System.out.println("❌ ERROR: Failed to get popular comics!");
            System.out.println("Error message: " + e.getMessage());
            System.out.println();
        }

        // BƯỚC 7: Kiểm tra dữ liệu comics
        System.out.println("STEP 7: Checking comics data quality...");
        checkComicsDataQuality();

        System.out.println("========================================");
        System.out.println("DEBUG COMPLETED");
        System.out.println("========================================");
    }

    public static void checkComicsDataQuality() {
        ComicDAO comicDAO = new ComicDAO();


        try {
            // Đếm comics có đầy đủ thông tin
            comicDAO.jdbi.withHandle(handle -> {
                String sql = """
                    SELECT 
                        COUNT(*) as total,
                        COUNT(series_id) as has_series,
                        COUNT(volume) as has_volume,
                        COUNT(category_id) as has_category
                    FROM comics
                    WHERE is_deleted = 0
                    """;

                handle.createQuery(sql)
                        .mapToMap()
                        .forEach(row -> {
                            int total = ((Number) row.get("total")).intValue();
                            int hasSeries = ((Number) row.get("has_series")).intValue();
                            int hasVolume = ((Number) row.get("has_volume")).intValue();
                            int hasCategory = ((Number) row.get("has_category")).intValue();

                            System.out.println("Total comics: " + total);
                            System.out.println("Comics with series_id: " + hasSeries + " (" + (hasSeries * 100 / total) + "%)");
                            System.out.println("Comics with volume: " + hasVolume + " (" + (hasVolume * 100 / total) + "%)");
                            System.out.println("Comics with category_id: " + hasCategory + " (" + (hasCategory * 100 / total) + "%)");

                            if (hasSeries < total) {
                                System.out.println("⚠️ WARNING: Some comics missing series_id");
                            }
                            if (hasCategory < total) {
                                System.out.println("⚠️ WARNING: Some comics missing category_id");
                            }
                        });

                return null;
            });

        } catch (Exception e) {
            System.out.println("❌ ERROR: Cannot check comics data");
            e.printStackTrace();
        }
    }
}