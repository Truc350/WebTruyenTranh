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
            // ✅ PARSE PAGE
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }

            // ✅ PARSE LIMIT
            int limit = 8;
            String limitParam = request.getParameter("limit");
            if (limitParam != null && !limitParam.isEmpty()) {
                limit = Integer.parseInt(limitParam);
                if (limit < 1) limit = 8;
                if (limit > 1000) limit = 1000;
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

            System.out.println("📋 List params: page=" + page + ", limit=" + limit + ", hiddenFilter=" + hiddenFilter);

            // ✅ GỌI DAO VỚI FILTER
            List<Comic> comics;
            int totalComics;

            if (hiddenFilter != null) {
                comics = comicDAO.getAllComicsAdminWithFilter(page, limit, hiddenFilter);
                totalComics = comicDAO.countAllComicsWithFilter(hiddenFilter);
            } else {
                comics = comicDAO.getAllComicsAdmin(page, limit);
                totalComics = comicDAO.countAllComics();
            }

            int totalPages = (int) Math.ceil((double) totalComics / limit);

            System.out.println("✅ Loaded " + comics.size() + " comics (filtered: " + hiddenFilter + ")");

            // ✅ BUILD RESPONSE (THÊM isHidden)
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

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Server error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(gson.toJson(result));
        response.getWriter().flush();
    }
}