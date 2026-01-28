package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ReviewDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.WishlistDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.ComicService;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.RecommendationService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet("/comic-detail")
public class ComicDetailServlet extends HttpServlet {
    private ComicService comicService;
    private RecommendationService recommendationService;
    private WishlistDAO wishlistDAO;
    private SeriesDAO seriesDAO;
    private ComicDAO comicDAO;

    @Override
    public void init() throws ServletException {
        comicService = new ComicService();
        recommendationService = new RecommendationService();
        wishlistDAO = new WishlistDAO();
        seriesDAO = new SeriesDAO();
        comicDAO = new ComicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

            // ========== LẤY THÔNG TIN CHI TIẾT TRUYỆN (ĐÃ CÓ FLASH SALE) ==========
            Comic comic = comicService.getComicById(comicId);

            if (comic == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            int totalSell = comicDAO.getTotalSoldByComicId(comic.getId());
            // Lấy danh sách ảnh của truyện
            var images = comicService.getComicImages(comicId);

            // Lấy danh sách truyện tương tự (ĐÃ CÓ FLASH SALE)
            var relatedComics = comicService.getRelatedComics(comicId);

            // Lấy đánh giá của truyện
            var reviews = comicService.getComicReviews(comicId);
            double avgRating = comicService.getAverageRating(comicId);

            // Lấy phân bố rating
            ReviewDAO reviewDAO = new ReviewDAO();
            Map<Integer, Integer> ratingDistribution = reviewDAO.getRatingDistribution(comicId);
            int totalReviews = reviews.size();

            // ========== LẤY TÊN SERIES ==========
            String seriesName = null;
            if (comic.getSeriesId() != null && comic.getSeriesId() > 0) {
                try {
                    seriesName = comicService.getSeriesName(comic.getSeriesId());
                } catch (Exception e) {
                    System.out.println("⚠️ ComicService.getSeriesName() failed: " + e.getMessage());

                    try {
                        Optional<Series> seriesOpt = seriesDAO.getSeriesById(comic.getSeriesId());
                        if (seriesOpt.isPresent()) {
                            seriesName = seriesOpt.get().getSeriesName();
                            System.out.println("✅ Series name from SeriesDAO: " + seriesName);
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }

                if (seriesName == null && comic.getSeriesName() != null) {
                    seriesName = comic.getSeriesName();
                }
            }

            // ========== GỢI Ý TRUYỆN (ĐÃ TÍCH HỢP FLASH SALE) ==========
            User currentUser = (User) request.getSession().getAttribute("currentUser");
            Integer userId = (currentUser != null) ? currentUser.getId() : null;

            // Lấy danh sách gợi ý với Flash Sale
            List<Comic> suggestedComics = recommendationService.getDetailPageSuggestions(
                    userId,
                    comicId,
                    24
            );

            // Xác định loại gợi ý
            String suggestionType = recommendationService.getSuggestionType(userId, comicId);

            // Fallback nếu không có gợi ý
            if (suggestedComics.isEmpty()) {
                suggestedComics = recommendationService.getRecommendations(null, 24);
                suggestionType = "popular";
            }

            // ========== SET ATTRIBUTES ==========
            request.setAttribute("seriesName", seriesName);
            request.setAttribute("comic", comic);
            request.setAttribute("images", images);
            request.setAttribute("relatedComics", relatedComics);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("ratingDistribution", ratingDistribution);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("suggestedComics", suggestedComics);
            request.setAttribute("suggestionType", suggestionType);
            request.setAttribute("totalSell", totalSell);

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