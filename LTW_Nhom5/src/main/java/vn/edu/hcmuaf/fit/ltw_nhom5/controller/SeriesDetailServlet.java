package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@WebServlet("/series-detail")
public class SeriesDetailServlet extends HttpServlet {
    private SeriesDAO seriesDAO;
    private ComicDAO comicDAO;

    @Override
    public void init() throws ServletException {
        System.out.println("✅ SeriesDetailServlet initialized");
        seriesDAO = new SeriesDAO();
        comicDAO = new ComicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("\n========================================");
        System.out.println("🔍 SeriesDetailServlet.doGet() called");
        System.out.println("📍 Request URI: " + request.getRequestURI());
        System.out.println("📍 Context Path: " + request.getContextPath());
        System.out.println("📍 Query String: " + request.getQueryString());
        System.out.println("========================================\n");

        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy series ID từ parameter
            String seriesIdParam = request.getParameter("id");

            if (seriesIdParam == null || seriesIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            int seriesId = Integer.parseInt(seriesIdParam);

            // Lấy thông tin series
            Optional<Series> seriesOptional = seriesDAO.getSeriesById(seriesId);

            if (!seriesOptional.isPresent()) {
                request.getSession().setAttribute("errorMsg", "Không tìm thấy series");
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            Series series = seriesOptional.get();

            // Kiểm tra series có bị ẩn không
            if (series.isHidden()) {
                request.getSession().setAttribute("errorMsg", "Series này hiện không khả dụng");
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            // Lấy danh sách comic thuộc series này
            List<Comic> comicsInSeries = comicDAO.getComicsBySeriesId(seriesId);

            // TỔNG HỢP TÁC GIẢ VÀ NHÀ XUẤT BẢN TỪ TẤT CẢ COMICS
            Set<String> authorSet = new HashSet<>();
            Set<String> publisherSet = new HashSet<>();

            for (Comic comic : comicsInSeries) {
                // Thêm tác giả
                if (comic.getAuthor() != null && !comic.getAuthor().trim().isEmpty()) {
                    // Tách các tác giả nếu có dấu phân cách (ví dụ: "Author A, Author B")
                    String[] authors = comic.getAuthor().split("[,;]");
                    for (String author : authors) {
                        String trimmed = author.trim();
                        if (!trimmed.isEmpty()) {
                            authorSet.add(trimmed);
                        }
                    }
                }

                // Thêm nhà xuất bản
                if (comic.getPublisher() != null && !comic.getPublisher().trim().isEmpty()) {
                    // Tách các NXB nếu có dấu phân cách
                    String[] publishers = comic.getPublisher().split("[,;]");
                    for (String publisher : publishers) {
                        String trimmed = publisher.trim();
                        if (!trimmed.isEmpty()) {
                            publisherSet.add(trimmed);
                        }
                    }
                }
            }

            // Chuyển Set thành String để hiển thị
            String authors = authorSet.isEmpty() ? null : String.join(", ", authorSet);
            String publishers = publisherSet.isEmpty() ? null : String.join(", ", publisherSet);

            // Set attributes để hiển thị
            request.setAttribute("series", series);
            request.setAttribute("comicsInSeries", comicsInSeries);
            request.setAttribute("totalComics", comicsInSeries.size());
            request.setAttribute("seriesAuthors", authors);
            request.setAttribute("seriesPublishers", publishers);


            // Forward đến trang SeriComic.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/fontend/public/SeriComic.jsp");

            dispatcher.forward(request, response);
            System.out.println("✅ Forward completed successfully!");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "ID series không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Có lỗi xảy ra khi tải thông tin series");
            response.sendRedirect(request.getContextPath() + "/");
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}