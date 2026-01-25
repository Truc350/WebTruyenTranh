package vn.edu.hcmuaf.fit.ltw_nhom5.controller.UserB;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.RecommendationService;

import java.io.IOException;
import java.util.*;


@WebServlet(name = "UserCategoryServlet", urlPatterns = {"/userCategory"})
public class UserCategoryServlet extends HttpServlet {
    private CategoriesDao categoriesDao;
    private ComicDAO comicDAO;
    private RecommendationService recommendationService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            categoriesDao = new CategoriesDao();
            comicDAO = new ComicDAO();
            recommendationService = new RecommendationService();
            System.out.println("✓ UserCategoryServlet initialized successfully");
        } catch (Exception e) {
            System.err.println("✗ ERROR initializing UserCategoryServlet:");
            e.printStackTrace();
            throw new ServletException("Failed to initialize UserCategoryServlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Cập nhật Flash Sale statuses
        FlashSaleDAO flashSaleDAO = new FlashSaleDAO();
        flashSaleDAO.updateStatuses();

        // ========== LẤY USER ID TỪ SESSION ==========
        Integer userId = null;
        HttpSession session = request.getSession(false);
        if (session != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
                userId = currentUser.getId();
                System.out.println("✅ User đã login: " + currentUser.getUsername() + " (ID: " + userId + ")");
            } else {
                System.out.println("⚠️ User chưa login - Hiển thị gợi ý phổ biến");
            }
        }

        try {
            String categoryIdParam = request.getParameter("id");

            if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int categoryId = Integer.parseInt(categoryIdParam);
            System.out.println("=== UserCategoryServlet: categoryId = " + categoryId + " ===");

            // Lấy thông tin category
            Category selectedCategory = categoriesDao.getCategoryById(categoryId);

            if (selectedCategory == null || selectedCategory.getIs_hidden() == 1) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            // Lấy các tham số filter
            String[] priceFilters = request.getParameterValues("price");
            String[] authorFilters = request.getParameterValues("author");
            String[] publisherFilters = request.getParameterValues("publisher");
            String[] yearFilters = request.getParameterValues("year");

            // Convert sang List
            List<String> priceRanges = priceFilters != null ? Arrays.asList(priceFilters) : new ArrayList<>();
            List<String> authors = authorFilters != null ? Arrays.asList(authorFilters) : new ArrayList<>();
            List<String> publishers = publisherFilters != null ? Arrays.asList(publisherFilters) : new ArrayList<>();
            List<String> years = yearFilters != null ? Arrays.asList(yearFilters) : new ArrayList<>();

            // Lấy danh sách comics với filter VÀ FLASH SALE
            List<Comic> comicList;
            if (priceRanges.isEmpty() && authors.isEmpty() && publishers.isEmpty() && years.isEmpty()) {
                // Không có filter, lấy tất cả
                comicList = comicDAO.getComicsByCategory1WithFlashSale(categoryId);
            } else {
                // Có filter
                comicList = comicDAO.getComicsByCategoryWithFiltersAndFlashSale(
                        categoryId, priceRanges, authors, publishers, years);
            }

            // Lấy danh sách tác giả và nhà xuất bản cho category này
            List<String> availableAuthors = comicDAO.getAuthorsByCategory(categoryId);
            List<String> availablePublishers = comicDAO.getPublishersByCategory(categoryId);

            // Lấy danh sách categories cho header
            List<Category> listCategories = categoriesDao.listCategories();

            // ========== GỢI Ý THÔNG MINH VỚI FLASH SALE ==========
            Map<String, List<Comic>> recommendations = new LinkedHashMap<>();

            try {
                if (userId != null) {
                    // User đã login → Gợi ý cá nhân hóa
                    System.out.println("🎯 Tạo gợi ý cá nhân hóa cho user ID: " + userId);
                    recommendations = recommendationService.getCategorizedRecommendationsWithFlashSale(userId);
                    System.out.println("✅ Đã tạo " + recommendations.size() + " nhóm gợi ý");

                } else {
                    // User chưa login → Gợi ý phổ biến
                    System.out.println("🔥 Tạo gợi ý phổ biến (chưa login)");
                    List<Comic> popularComics = comicDAO.getPopularComicsWithFlashSale(24);

                    if (!popularComics.isEmpty()) {
                        // Chia thành 3 nhóm
                        int size = popularComics.size();
                        if (size >= 8) {
                            recommendations.put("Phổ biến nhất",
                                    new ArrayList<>(popularComics.subList(0, Math.min(8, size))));
                        }
                        if (size >= 16) {
                            recommendations.put("Bán chạy",
                                    new ArrayList<>(popularComics.subList(8, Math.min(16, size))));
                        }
                        if (size >= 24) {
                            recommendations.put("Mới cập nhật",
                                    new ArrayList<>(popularComics.subList(16, Math.min(24, size))));
                        }
                    }
                    System.out.println("✅ Đã tạo " + recommendations.size() + " nhóm gợi ý phổ biến");
                }
            } catch (Exception e) {
                System.err.println("❌ Lỗi khi tạo gợi ý: " + e.getMessage());
                e.printStackTrace();
            }

            // Set attributes cho view
            request.setAttribute("selectedCategory", selectedCategory);
            request.setAttribute("comicList", comicList);
            request.setAttribute("listCategories", listCategories);
            request.setAttribute("availableAuthors", availableAuthors);
            request.setAttribute("availablePublishers", availablePublishers);
            request.setAttribute("selectedPrices", priceRanges);
            request.setAttribute("selectedAuthors", authors);
            request.setAttribute("selectedPublishers", publishers);
            request.setAttribute("selectedYears", years);
            request.setAttribute("recommendations", recommendations);
            request.setAttribute("isPersonalized", userId != null);

            request.getRequestDispatcher("/fontend/public/CatagoryPage.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("✗ Invalid category ID format: " + request.getParameter("id"));
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            System.err.println("✗ ERROR in UserCategoryServlet:");
            e.printStackTrace();
            throw new ServletException("Error processing category request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}