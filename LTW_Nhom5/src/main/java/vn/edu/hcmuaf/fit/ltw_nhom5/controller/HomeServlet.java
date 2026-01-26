package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Banner;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.ComicService;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.FlashSaleService;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.RecommendationService;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;

@WebServlet({"/home"})
public class HomeServlet extends HttpServlet {
    private ComicDAO comicDAO;
    private FlashSaleDAO flashSaleDAO;
    private FlashSaleComicsDAO flashSaleComicsDAO;
    private FlashSaleService flashSaleService;
    private ComicService comicService;
    private BannerDao bannerDao;
    private WishlistDAO wishlistDAO;
    private RecommendationService recommendationService;

    @Override
    public void init() throws ServletException {
        comicDAO = new ComicDAO();
        flashSaleDAO = new FlashSaleDAO();
        flashSaleComicsDAO = new FlashSaleComicsDAO();
        flashSaleService = new FlashSaleService();
        comicService = new ComicService(JdbiConnector.get());
        bannerDao = new BannerDao(JdbiConnector.get());
        wishlistDAO = new WishlistDAO();
        recommendationService = new RecommendationService(comicDAO, wishlistDAO);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ========================================
            // 1. CẬP NHẬT TRẠNG THÁI FLASH SALE
            // ========================================
            flashSaleDAO.updateStatuses();

            // ========================================
            // 2. LẤY THÔNG TIN USER (NẾU CÓ)
            // ========================================
            HttpSession session = request.getSession(false);
            User currentUser = null;
            Integer userId = null;

            if (session != null) {
                currentUser = (User) session.getAttribute("currentUser");

                if (currentUser != null) {
                    userId = currentUser.getId();
                    System.out.println("✓ Found user from session");
                    System.out.println("  - User ID: " + userId);
                    System.out.println("  - Username: " + currentUser.getUsername());
                } else {
                    System.out.println("⚠️ No user found in session (Guest user)");
                }
            } else {
                System.out.println("⚠️ No session found (Guest user)");
            }

            // ========================================
            // 3. FLASH SALE ĐANG ACTIVE (CHO BANNER)
            // ========================================
            FlashSale activeFlashSale = flashSaleDAO.getActiveFlashSaleEndingSoon();

            if (activeFlashSale != null) {
                request.setAttribute("flashSale", activeFlashSale);

                // Chuyển endTime sang milliseconds cho JavaScript countdown
                long endTimeMillis = activeFlashSale.getEndTime()
                        .atZone(ZoneId.systemDefault())
                        .toInstant()
                        .toEpochMilli();
                request.setAttribute("flashSaleEndTimeMillis", endTimeMillis);

                // DEBUG LOG
                System.out.println("==================== FLASH SALE DEBUG ====================");
                System.out.println("Flash Sale Name: " + activeFlashSale.getName());
                System.out.println("Flash Sale Status: " + activeFlashSale.getStatus());
                System.out.println("End Time: " + activeFlashSale.getEndTime());
                System.out.println("End Time Millis: " + endTimeMillis);
                System.out.println("Current Time Millis: " + System.currentTimeMillis());
                System.out.println("=========================================================");

                // Lấy 4 comics đầu tiên từ Flash Sale (độc quyền)
                List<Map<String, Object>> flashSaleComics =
                        flashSaleService.getExclusiveComicsForFlashSale(activeFlashSale.getId());

                // Chỉ lấy 4 sản phẩm đầu cho homepage
                if (flashSaleComics.size() > 4) {
                    flashSaleComics = flashSaleComics.subList(0, 4);
                }

                request.setAttribute("flashSaleComics", flashSaleComics);
                System.out.println("✅ Flash Sale Comics (first 4): " + flashSaleComics.size());
            } else {
                System.out.println("⚠️ No active Flash Sale found");
            }

            // ========================================
            // 4. BANNERS
            // ========================================
            Timestamp now = new Timestamp(System.currentTimeMillis());
            List<Banner> banners = bannerDao.findActiveBanners(now);
            request.setAttribute("banners", banners);
            System.out.println("✅ Banners: " + banners.size());

            // ========================================
            // 5. COMICS GỢI Ý (CÓ FLASH SALE)
            // ========================================
            List<Comic> recommendedComics;

            if (currentUser != null) {
                int wishlistCount = wishlistDAO.getWishlistCount(currentUser.getId());

                if (wishlistCount > 0) {
                    // User có wishlist → Gợi ý dựa trên wishlist
                    recommendedComics = comicDAO.getRecommendedComics(currentUser.getId(), 16);
                    System.out.println("✅ Recommended Comics (from wishlist): " + recommendedComics.size());
                } else {
                    // User không có wishlist → Hiển thị phổ biến
                    recommendedComics = comicDAO.getPopularComics(16);
                    System.out.println("✅ Recommended Comics (popular): " + recommendedComics.size());
                }
            } else {
                // Guest user → Hiển thị phổ biến
                recommendedComics = comicDAO.getPopularComics(16);
                System.out.println("✅ Recommended Comics (guest): " + recommendedComics.size());
            }

            request.setAttribute("recommendedComics", recommendedComics);
            request.setAttribute("isLoggedIn", currentUser != null);

            // ========================================
            // 6. TOP COMICS BÁN CHẠY TRONG TUẦN (CÓ FLASH SALE)
            // ========================================
            List<Comic> topComics = comicDAO.getTop5BestSellerThisWeek();
            request.setAttribute("topComics", topComics);
            System.out.println("✅ Top Comics: " + topComics.size());

            // ========================================
            // 7. LOG SUMMARY
            // ========================================
            System.out.println("\n=== HOME PAGE DATA SUMMARY ===");
            System.out.println("User: " + (currentUser != null ? currentUser.getUsername() : "Guest"));
            System.out.println("Flash Sale: " + (activeFlashSale != null ? activeFlashSale.getName() : "None"));
            System.out.println("Banners: " + banners.size());
            System.out.println("Recommended Comics: " + recommendedComics.size());
            System.out.println("Top Comics: " + topComics.size());
            System.out.println("==============================\n");

            // ========================================
            // 8. FORWARD TO JSP
            // ========================================
            request.getRequestDispatcher("/fontend/public/homePage.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Error in HomeServlet: " + e.getMessage());

            // Set error message
            request.setAttribute("errorMessage", "Lỗi khi tải trang chủ: " + e.getMessage());
            request.getRequestDispatcher("/fontend/public/error.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}