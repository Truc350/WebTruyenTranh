package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import java.io.IOException;
import java.util.*;

@WebServlet("/series-detail")
public class SeriesDetailServlet extends HttpServlet {
    private SeriesDAO seriesDAO;
    private ComicDAO comicDAO;
    private FlashSaleDAO flashSaleDAO;

    @Override
    public void init() throws ServletException {
        System.out.println("✅ SeriesDetailServlet initialized");
        seriesDAO = new SeriesDAO();
        comicDAO = new ComicDAO();
        flashSaleDAO = new FlashSaleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("\n========================================");
        System.out.println("🔍 SeriesDetailServlet.doGet() called");
        System.out.println("📍 Request URI: " + request.getRequestURI());
        System.out.println("========================================\n");

        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Cập nhật Flash Sale statuses
        flashSaleDAO.updateStatuses();

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

            // Lấy danh sách comic thuộc series này VỚI FLASH SALE
            List<Comic> comicsInSeries = comicDAO.getComicsBySeriesIdWithFlashSale(seriesId);

            // Lấy totalSold
            Map<Integer, Integer> soldMap = comicDAO.getTotalSoldBySeriesId(seriesId);

            // Gán totalSold cho từng comic
            for (Comic comic : comicsInSeries) {
                int totalSold = soldMap.getOrDefault(comic.getId(), 0);
                comic.setTotalSold(totalSold);
            }

            // TỔNG HỢP TÁC GIẢ VÀ NHÀ XUẤT BẢN
            Set<String> authorSet = new HashSet<>();
            Set<String> publisherSet = new HashSet<>();

            for (Comic comic : comicsInSeries) {
                // Thêm tác giả
                if (comic.getAuthor() != null && !comic.getAuthor().trim().isEmpty()) {
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

            // DEBUG LOG
            System.out.println("Series Comics with Flash Sale Info:");
            for (Comic comic : comicsInSeries) {
                System.out.println("  - " + comic.getNameComics());
                System.out.println("    Has Flash Sale: " + comic.isHasFlashSale());
                if (comic.isHasFlashSale()) {
                    System.out.println("    Flash Sale: " + comic.getFlashSaleName());
                    System.out.println("    Discount: " + comic.getFlashSaleDiscount() + "%");
                    System.out.println("    Flash Price: " + comic.getFlashSalePrice());
                }
                System.out.println("    Normal Price: " + comic.getPrice());
            }

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation if needed
    }
}