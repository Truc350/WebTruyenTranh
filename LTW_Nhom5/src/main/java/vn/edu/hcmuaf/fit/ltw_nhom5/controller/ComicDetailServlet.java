package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.ComicService;

import java.io.IOException;

@WebServlet("/comic-detail")
public class ComicDetailServlet extends HttpServlet {
    private ComicService comicService;

    @Override
    public void init() throws ServletException {
        comicService = new ComicService();
        System.out.println("🔥 ComicDetailServlet INIT 🔥");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("\n🔴🔴🔴 ComicDetailServlet doGet CALLED 🔴🔴🔴");
        System.out.println("🔴 Request URI: " + request.getRequestURI());
        System.out.println("🔴 Query String: " + request.getQueryString());

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy ID từ parameter
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int comicId = Integer.parseInt(idParam);

            // Lấy thông tin chi tiết truyện
            Comic comic = comicService.getComicById(comicId);

            if (comic == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            // Lấy danh sách ảnh của truyện
            var images = comicService.getComicImages(comicId);

            // Lấy danh sách truyện tương tự (cùng thể loại hoặc tác giả)
            var relatedComics = comicService.getRelatedComics(comicId, 8);

            // Lấy đánh giá của truyện
            var reviews = comicService.getComicReviews(comicId);

            // Tính điểm trung bình
            double avgRating = comicService.getAverageRating(comicId);

            // Set attributes
            request.setAttribute("comic", comic);
            request.setAttribute("images", images);
            request.setAttribute("relatedComics", relatedComics);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);

            // Forward đến trang detail
            request.getRequestDispatcher("/fontend/public/detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println(">>> ERROR - NumberFormatException: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            System.err.println(">>> ERROR - Exception: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}