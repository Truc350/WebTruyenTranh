package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/products/list")
public class ListComicsServlet extends HttpServlet {

    private ComicDAO comicDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        System.out.println("🔧 Initializing ListComicsServlet...");
        try {
            comicDAO = new ComicDAO();
            gson = new Gson();
            System.out.println("✅ ListComicsServlet initialized successfully!");
        } catch (Exception e) {
            System.err.println("❌ Error initializing servlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        try {
            // Lấy trang hiện tại
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }

            // ✅ GIỚI HẠN 8 TRUYỆN MỖI TRANG
            int limit = 8;

            // Lấy danh sách truyện
            List<Comic> comics = comicDAO.getAllComicsAdmin(page, limit);

            // Đếm tổng số truyện
            int totalComics = comicDAO.countAllComics();

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalComics / limit);

            System.out.println("✅ Page: " + page + "/" + totalPages + " - Loaded " + comics.size() + " comics");

            // Chuyển đổi sang DTO đơn giản
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
                simplifiedComics.add(dto);
            }

            result.put("success", true);
            result.put("comics", simplifiedComics);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalComics", totalComics);

        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();

            result.put("success", false);
            result.put("message", "Server error: " + e.getMessage());

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(gson.toJson(result));
        response.getWriter().flush();
    }
}