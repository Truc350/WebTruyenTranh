package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/comics/filterByCategory")
public class FilterComicByCategoryServlet extends HttpServlet {

    private static final int COMICS_PER_PAGE = 12;
    private ComicDAO comicsDao;
    private CategoriesDao categoriesDao;

    @Override
    public void init() throws ServletException {
        try {
            this.comicsDao = new ComicDAO();
            this.categoriesDao = new CategoriesDao();
            System.out.println("✅ FilterComicByCategoryServlet initialized successfully!");
        } catch (Exception e) {
            System.err.println("❌ Error initializing FilterComicByCategoryServlet:");
            e.printStackTrace();
            throw new ServletException("Failed to initialize servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("========================================");
        System.out.println("✅ FilterComicByCategoryServlet.doGet() called!");
        System.out.println("========================================");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        try {
            // Lấy parameters
            String categoryIdStr = request.getParameter("categoryId");
            String pageStr = request.getParameter("page");

            System.out.println("📥 Parameters received:");
            System.out.println("  - categoryId: " + categoryIdStr);
            System.out.println("  - page: " + pageStr);

            // Validate categoryId
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                sendErrorResponse(response, "Vui lòng chọn thể loại!", 400);
                return;
            }

            int categoryId;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                sendErrorResponse(response, "ID thể loại không hợp lệ!", 400);
                return;
            }

            // Validate page
            int page = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            System.out.println("📊 Processing request:");
            System.out.println("  - Category ID: " + categoryId);
            System.out.println("  - Page: " + page);
            System.out.println("  - Comics per page: " + COMICS_PER_PAGE);

            // Kiểm tra thể loại có tồn tại không
            Category category = categoriesDao.getCategoryById(categoryId);
            if (category == null) {
                sendErrorResponse(response, "Thể loại không tồn tại!", 404);
                return;
            }

            System.out.println("✅ Category found: " + category.getNameCategories());

            // Đếm tổng số truyện trong thể loại
            int totalComics = comicsDao.countComicsByCategory(categoryId);
            System.out.println("📚 Total comics in category: " + totalComics);

            if (totalComics == 0) {
                sendSuccessResponse(response, null, category, page, 0, 0);
                return;
            }

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalComics / COMICS_PER_PAGE);
            System.out.println("📄 Total pages: " + totalPages);

            // Validate page không vượt quá totalPages
            if (page > totalPages) {
                page = totalPages;
            }

            // Lấy danh sách truyện theo thể loại và trang
            List<Comic> comics = comicsDao.getComicsByCategoryPaginated(categoryId, page, COMICS_PER_PAGE);
            System.out.println("✅ Retrieved " + comics.size() + " comics for page " + page);

            // Trả về response thành công
            sendSuccessResponse(response, comics, category, page, totalPages, totalComics);

        } catch (Exception e) {
            System.err.println("❌ Error in FilterComicByCategoryServlet:");
            e.printStackTrace();
            sendErrorResponse(response, "Có lỗi xảy ra khi lọc truyện: " + e.getMessage(), 500);
        }
    }

    /**
     * Gửi response thành công
     */
    private void sendSuccessResponse(HttpServletResponse response,
                                     List<Comic> comics,
                                     Category category,
                                     int currentPage,
                                     int totalPages,
                                     int totalComics) throws IOException {

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", comics == null || comics.isEmpty()
                ? "Không có truyện nào trong thể loại này"
                : "Lấy danh sách truyện thành công!");

        result.put("comics", comics);
        result.put("category", Map.of(
                "id", category.getId(),
                "name", category.getNameCategories(),
                "description", category.getDescription() != null ? category.getDescription() : ""
        ));
        result.put("currentPage", currentPage);
        result.put("totalPages", totalPages);
        result.put("totalComics", totalComics);
        result.put("comicsPerPage", COMICS_PER_PAGE);

        response.setStatus(HttpServletResponse.SC_OK);
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(result));
        out.flush();

        System.out.println("✅ Response sent successfully");
    }

    /**
     * Gửi response lỗi
     */
    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode)
            throws IOException {

        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);

        response.setStatus(statusCode);
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(result));
        out.flush();

        System.err.println("❌ Error response sent: " + message);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}