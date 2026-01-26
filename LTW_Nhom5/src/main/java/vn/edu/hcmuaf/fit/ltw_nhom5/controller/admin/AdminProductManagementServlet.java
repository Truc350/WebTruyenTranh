package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.ComicService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/admin/products/search")
public class AdminProductManagementServlet extends HttpServlet {
    private ComicService comicService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        comicService = new ComicService();
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class,
                        (com.google.gson.JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                                new com.google.gson.JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)))
                .create();

    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        try {
            // Lấy parameters
            String keyword = request.getParameter("keyword");
            String pageStr = request.getParameter("page");

            int page = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int limit = 8;

            // Tìm kiếm
            List<Comic> comics;
            int totalComics;

            if (keyword != null && !keyword.trim().isEmpty()) {
                comics = comicService.searchComicsAdmin(keyword.trim(), null, null, page, limit);
                totalComics = comicService.countComicsAdmin(keyword.trim(), null, null);
            } else {
                comics = comicService.getAllComicsAdmin(page, limit);
                totalComics = comicService.countAllComics();
            }

            // Tính số trang
            int totalPages = (int) Math.ceil((double) totalComics / limit);

            // CONVERT TO SIMPLE DTO
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

            // Tạo response JSON
            Map<String, Object> result = new HashMap<>();
            result.put("comics", simplifiedComics);  // ← Dùng DTO thay vì Comic
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalComics", totalComics);

            // Trả JSON
            String jsonResponse = gson.toJson(result);

            response.getWriter().write(jsonResponse);
            response.getWriter().flush();


        } catch (Exception e) {
            System.err.println("❌ ERROR:");
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage());

            response.getWriter().write(gson.toJson(errorResponse));
            response.getWriter().flush();
        }
    }
}