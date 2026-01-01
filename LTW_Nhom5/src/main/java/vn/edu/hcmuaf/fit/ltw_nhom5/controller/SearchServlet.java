package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private ComicDAO comicDAO;

    @Override
    public void init() {
        comicDAO = new ComicDAO();
        System.out.println("🔥🔥🔥 SearchServlet INITIALIZED 🔥🔥🔥");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("\n🔍🔍🔍 SearchServlet doGet CALLED 🔍🔍🔍");
        System.out.println("🔍 Request URI: " + request.getRequestURI());
        System.out.println("🔍 Query String: " + request.getQueryString());

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        String searchType = request.getParameter("type");

        System.out.println("🔍 Keyword from request: [" + keyword + "]");
        System.out.println("🔍 Search Type: [" + searchType + "]");

        // Keyword rỗng
        if (keyword == null || keyword.trim().isEmpty()) {
            System.out.println("⚠️ Keyword is empty!");
            request.setAttribute("comics", new ArrayList<>());
            request.setAttribute("resultCount", 0);
            request.getRequestDispatcher("/fontend/public/searchResult.jsp")
                    .forward(request, response);
            return;
        }

        // Kết quả tìm kiếm
        List<Comic> comics = new ArrayList<>();

        if ("author".equals(searchType)) {
            System.out.println("📚 Searching by AUTHOR...");
            List<Comic> result = comicDAO.findByAuthor(keyword);
            if (result != null) comics.addAll(result);
            System.out.println("✅ Found by author: " + result.size());

        } else if ("publisher".equals(searchType)) {
            System.out.println("📚 Searching by PUBLISHER...");
            List<Comic> result = comicDAO.findByPublisher(keyword);
            if (result != null) comics.addAll(result);
            System.out.println("✅ Found by publisher: " + result.size());

        } else {
            System.out.println("📚 Searching by SMART SEARCH...");
            List<Comic> result = comicDAO.smartSearch(keyword);
            if (result != null) comics.addAll(result);
            System.out.println("✅ smartSearch returned: " + (result != null ? result.size() : "NULL"));
        }

        // Thêm các tập cùng series
        if (!comics.isEmpty()) {
            Comic first = comics.get(0);

            if (first.getSeriesId() != null) {
                List<Comic> sameSeries =
                        comicDAO.findBySeriesId(first.getSeriesId(), first.getId());

                if (sameSeries != null) {
                    for (Comic c : sameSeries) {
                        boolean existed = false;

                        // kiểm tra trùng ID
                        for (Comic existedComic : comics) {
                            if (existedComic.getId() == c.getId()) {
                                existed = true;
                                break;
                            }
                        }

                        if (!existed) {
                            comics.add(c);
                        }
                    }
                }
            }
        }

        request.setAttribute("keyword", keyword);
        request.setAttribute("searchType", searchType != null ? searchType : "all");
        request.setAttribute("comics", comics);
        request.setAttribute("resultCount", comics.size());

        request.getRequestDispatcher("/fontend/public/searchResult.jsp")
                .forward(request, response);
    }
}

