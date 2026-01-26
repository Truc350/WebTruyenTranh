package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet chuyên dụng để load trang Product Management
 * Đảm bảo JSP luôn được load qua Servlet thay vì truy cập trực tiếp
 */
//@WebServlet(name = "ProductManagement", urlPatterns = {"/ProductManagement", "/admin/products/manage"})
@WebServlet("/ProductManagement")
public class ProductManagementServlet extends HttpServlet {

    private ComicDAO comicDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        System.out.println("✅ ProductManagementServlet initialized successfully!");
        try {
            comicDAO = new ComicDAO();
            gson = new Gson();
        } catch (Exception e) {
            System.err.println("❌ Error initializing ProductManagementServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("========================================");
        System.out.println("✅ ProductManagementServlet.doGet() được gọi!");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("========================================");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra xem có phải request AJAX không
        String ajaxRequest = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(ajaxRequest);

        try {
            // ✅ PARSE PARAMETERS
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int limit = 8;
            String limitParam = request.getParameter("limit");
            if (limitParam != null && !limitParam.isEmpty()) {
                try {
                    limit = Integer.parseInt(limitParam);
                    if (limit < 1) limit = 8;
                    if (limit > 1000) limit = 1000;
                } catch (NumberFormatException e) {
                    limit = 8;
                }
            }

            // ✅ PARSE HIDDEN FILTER (QUAN TRỌNG!)
            Integer hiddenFilter = null;
            String hiddenParam = request.getParameter("hiddenFilter");
            if (hiddenParam != null && !hiddenParam.isEmpty()) {
                try {
                    int hiddenValue = Integer.parseInt(hiddenParam);
                    if (hiddenValue == 0 || hiddenValue == 1) {
                        hiddenFilter = hiddenValue;
                    }
                } catch (NumberFormatException e) {
                    // Ignore invalid value
                }
            }

            System.out.println("📋 Parameters: page=" + page + ", limit=" + limit + ", hiddenFilter=" + hiddenFilter);

            // ✅ GỌI DAO VỚI FILTER
            List<Comic> comics;
            int totalComics;

            if (hiddenFilter != null) {
                comics = comicDAO.getAllComicsAdminWithFilter(page, limit, hiddenFilter);
                totalComics = comicDAO.countAllComicsWithFilter(hiddenFilter);
                System.out.println("🔍 Filtering by isHidden=" + hiddenFilter);
            } else {
                comics = comicDAO.getAllComicsAdmin(page, limit);
                totalComics = comicDAO.countAllComics();
                System.out.println("📚 Loading all comics (no filter)");
            }

            int totalPages = (int) Math.ceil((double) totalComics / limit);

            System.out.println("✅ Loaded " + comics.size() + " comics (Total: " + totalComics + ", Pages: " + totalPages + ")");

            // ✅ NẾU LÀ AJAX REQUEST → TRẢ VỀ JSON
            if (isAjax || request.getParameter("ajax") != null) {
                response.setContentType("application/json; charset=UTF-8");

                Map<String, Object> result = new HashMap<>();

                // BUILD RESPONSE (THÊM isHidden)
                List<Map<String, Object>> simplifiedComics = new ArrayList<>();
                for (Comic comic : comics) {
                    Map<String, Object> dto = new HashMap<>();
                    dto.put("id", comic.getId());
                    dto.put("nameComics", comic.getNameComics());
                    dto.put("seriesName", comic.getSeriesName());
                    dto.put("categoryName", comic.getCategoryName());
                    dto.put("author", comic.getAuthor());
                    dto.put("price", comic.getPrice());
                    dto.put("stockQuantity", comic.getStockQuantity());
                    dto.put("volume", comic.getVolume());
                    dto.put("isHidden", comic.getIsHidden());
                    simplifiedComics.add(dto);
                }

                result.put("success", true);
                result.put("comics", simplifiedComics);
                result.put("currentPage", page);
                result.put("totalPages", totalPages);
                result.put("totalComics", totalComics);

                response.getWriter().write(gson.toJson(result));
                response.getWriter().flush();

                System.out.println("📤 JSON response sent");
                return;
            }

            // ✅ NẾU LÀ REQUEST THƯỜNG → FORWARD ĐẾN JSP
            // Lấy messages từ session (nếu có từ add/edit/delete operations)
            String successMessage = (String) request.getSession().getAttribute("successMessage");
            String errorMessage = (String) request.getSession().getAttribute("errorMessage");

            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                request.getSession().removeAttribute("successMessage");
                System.out.println("✅ Success message: " + successMessage);
            }

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                request.getSession().removeAttribute("errorMessage");
                System.out.println("⚠️ Error message: " + errorMessage);
            }

            // Đánh dấu rằng trang đã được load qua Servlet
            request.setAttribute("loadedFromServlet", true);

            // Set filter state để JSP có thể hiển thị
            request.setAttribute("currentHiddenFilter", hiddenFilter);
            request.setAttribute("currentPage", page);

            System.out.println("➡️ Forwarding to productManagement.jsp");

            // Forward sang JSP
            request.getRequestDispatcher("/fontend/admin/productManagement.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ Error in ProductManagementServlet: " + e.getMessage());
            e.printStackTrace();

            if (isAjax || request.getParameter("ajax") != null) {
                // Trả về JSON error
                response.setContentType("application/json; charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", "Server error: " + e.getMessage());

                response.getWriter().write(gson.toJson(error));
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải trang: " + e.getMessage());
                request.getRequestDispatcher("/fontend/admin/productManagement.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu có POST request, chuyển sang GET
        doGet(request, response);
    }
}