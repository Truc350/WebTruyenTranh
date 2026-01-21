package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private ComicDAO comicDAO;
    private static final int ITEMS_PER_PAGE = 20;

    @Override
    public void init() {
        comicDAO = new ComicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        String searchType = request.getParameter("type");

        // Lấy trang hiện tại (mặc định là trang 1)
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        // Keyword rỗng
        if (keyword == null || keyword.trim().isEmpty()) {
            request.setAttribute("comics", new ArrayList<>());
            request.setAttribute("resultCount", 0);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalComics", 0);
            request.getRequestDispatcher("/fontend/public/searchResult.jsp")
                    .forward(request, response);
            return;
        }

        // Kết quả tìm kiếm
        List<Comic> comics = new ArrayList<>();

        // Tìm kiếm theo loại
        switch (searchType != null ? searchType : "all") {
            case "author":
                List<Comic> authorResult = comicDAO.findByAuthor(keyword);
                if (authorResult != null) comics.addAll(authorResult);
                break;

            case "publisher":
                List<Comic> publisherResult = comicDAO.findByPublisher(keyword);
                if (publisherResult != null) comics.addAll(publisherResult);
                break;

            case "category":
                List<Comic> categoryResult = comicDAO.findByCategory(keyword);
                if (categoryResult != null) comics.addAll(categoryResult);
                break;

            case "name":
                List<Comic> nameResult = comicDAO.smartSearch(keyword);
                if (nameResult != null) comics.addAll(nameResult);
                break;

            default: // "all" - tìm tất cả
                List<Comic> allResults = comicDAO.smartSearchAll(keyword);
                if (allResults != null) comics.addAll(allResults);
                break;
        }


        // Thêm các tập cùng series (nếu có kết quả)
        if (!comics.isEmpty()) {
            Set<Integer> addedIds = new HashSet<>();
            comics.forEach(c -> addedIds.add(c.getId()));

            Comic first = comics.get(0);

            if (first.getSeriesId() != null) {
                List<Comic> sameSeries = comicDAO.findBySeriesId(
                        first.getSeriesId(),
                        first.getId()
                );

                if (sameSeries != null) {
                    for (Comic c : sameSeries) {
                        // Chỉ thêm nếu chưa tồn tại
                        if (addedIds.add(c.getId())) {
                            comics.add(c);
                        }
                    }
                }
            }
        }

        // ========== PHÂN TRANG ==========
        int totalComics = comics.size();
        int totalPages = (int) Math.ceil((double) totalComics / ITEMS_PER_PAGE);

        // Đảm bảo trang hiện tại không vượt quá tổng số trang
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        // Lấy danh sách truyện cho trang hiện tại
        List<Comic> comicsForPage;
        if (totalComics > 0) {
            int startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
            int endIndex = Math.min(startIndex + ITEMS_PER_PAGE, totalComics);
            comicsForPage = comics.subList(startIndex, endIndex);
        } else {
            comicsForPage = new ArrayList<>();
        }

        request.setAttribute("keyword", keyword);
        request.setAttribute("searchType", searchType != null ? searchType : "all");
        request.setAttribute("comics", comicsForPage); // Chỉ truyền truyện của trang hiện tại
        request.setAttribute("resultCount", comicsForPage.size()); // Số truyện hiện tại
        request.setAttribute("totalComics", totalComics); // Tổng số truyện tìm thấy
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/fontend/public/searchResult.jsp")
                .forward(request, response);
    }
}

