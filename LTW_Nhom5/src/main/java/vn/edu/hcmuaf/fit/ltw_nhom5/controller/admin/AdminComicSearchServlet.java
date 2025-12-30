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

@WebServlet("/admin/search-comics")
public class AdminComicSearchServlet extends HttpServlet {

    private ComicDAO comicDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        comicDAO = new ComicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        String keyword = request.getParameter("keyword");
        String searchType = request.getParameter("type"); // author, publisher, all

        List<Comic> comics = new ArrayList<>();

        if (keyword == null || keyword.trim().isEmpty()) {
            // Không có keyword → trả về mảng rỗng
            sendJsonResponse(response, comics);
            return;
        }

        keyword = keyword.trim();

        if ("author".equals(searchType)) {
            List<Comic> result = comicDAO.findByAuthor(keyword);
            if (result != null) comics.addAll(result);

        } else if ("publisher".equals(searchType)) {
            List<Comic> result = comicDAO.findByPublisher(keyword);
            if (result != null) comics.addAll(result);

        } else {
            // Mặc định: tìm tất cả (smartSearch)
            List<Comic> result = comicDAO.smartSearch(keyword);
            if (result != null) comics.addAll(result);
        }

        // Thêm các tập cùng series (giống SearchServlet cũ)
        if (!comics.isEmpty()) {
            Comic first = comics.get(0);
            if (first.getSeriesId() != null) {
                List<Comic> sameSeries = comicDAO.findBySeriesId(first.getSeriesId(), first.getId());
                if (sameSeries != null) {
                    for (Comic c : sameSeries) {
                        if (comics.stream().noneMatch(existing -> existing.getId() == c.getId())) {
                            comics.add(c);
                        }
                    }
                }
            }
        }

        // Chỉ trả về những field cần thiết cho admin chọn
        List<Map<String, Object>> simplifiedComics = new ArrayList<>();
        for (Comic comic : comics) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", comic.getId());
            map.put("name", comic.getNameComics());
            // Nếu có thêm thông tin muốn hiển thị như tác giả, nhà xuất bản...
            // map.put("author", comic.getAuthor());
            simplifiedComics.add(map);
        }

        sendJsonResponse(response, simplifiedComics);
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        String json = gson.toJson(data);
        response.getWriter().write(json);
    }
}