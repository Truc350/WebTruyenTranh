package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
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
import java.util.Optional;

@WebServlet("/comic-detail")
public class ComicDetailServlet extends HttpServlet {
    private ComicService comicService;
    private RecommendationService recommendationService;
    private WishlistDAO wishlistDAO;
    private SeriesDAO seriesDAO;

    @Override
    public void init() throws ServletException {
        comicService = new ComicService();
        recommendationService = new RecommendationService();
        wishlistDAO = new WishlistDAO();
        seriesDAO = new SeriesDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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
            var relatedComics = comicService.getRelatedComics(comicId);

            // Lấy đánh giá của truyện
            var reviews = comicService.getComicReviews(comicId);

            // Tính điểm trung bình
            double avgRating = comicService.getAverageRating(comicId);

            // ========== LẤY TÊN SERIES ==========
            String seriesName = null;
            if (comic.getSeriesId() != null && comic.getSeriesId() > 0) {
                try {
                    // Cách 1: Sử dụng ComicService nếu có method
                    seriesName = comicService.getSeriesName(comic.getSeriesId());
                } catch (Exception e) {
                    System.out.println("⚠️ ComicService.getSeriesName() failed: " + e.getMessage());

                    // Cách 2: Fallback - Sử dụng SeriesDAO trực tiếp
                    try {
                        Optional<Series> seriesOpt = seriesDAO.getSeriesById(comic.getSeriesId());
                        if (seriesOpt.isPresent()) {
                            seriesName = seriesOpt.get().getSeriesName();
                            System.out.println("✅ Series name from SeriesDAO: " + seriesName);
                        } else {
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }

                if (seriesName == null && comic.getSeriesName() != null) {
                    seriesName = comic.getSeriesName();
                }
            } else {
                System.out.println("⚠️ Comic has no series_id or series_id <= 0");
            }



            // Lấy DS gợi ý truyện
            // Lấy user từ session
            User currentUser = (User) request.getSession().getAttribute("currentUser");
            Integer userId = (currentUser != null) ? currentUser.getId() : null;

            // Lấy danh sách gợi ý
            List<Comic> suggestedComics = new ArrayList<>();
            String suggestionType;

            if (userId == null) {
                // Chưa đăng nhập → Gợi ý phổ biến
                List<Comic> temp = recommendationService.getRecommendations(null, 24);
                if (temp != null) {
                    suggestedComics = temp;
                }

                suggestionType = "popular";


            } else {
                // Đã đăng nhập
                int wishlistCount = wishlistDAO.getWishlistCount(userId);

                if (wishlistCount > 0) {
                    // Có wishlist → Gợi ý cá nhân hóa
                    List<Comic> temp = recommendationService.getRecommendations(userId, 24);

                    if (temp != null) {
                        suggestedComics = temp;
                    }
                    suggestionType = "personalized";
                } else {
                    // Chưa có wishlist → Gợi ý cùng thể loại
                    List<Comic> temp = recommendationService.getSimilarComics(comic.getId(), 24);

                    if (temp != null) {
                        suggestedComics = temp;
                    }

                    suggestionType = "similar";
                }
            }
            if (suggestedComics.isEmpty()) {
                List<Comic> fallback = recommendationService.getRecommendations(null, 24);
                if (fallback != null) {
                    suggestedComics = fallback;
                    suggestionType = "popular";
                }
            }


            request.setAttribute("seriesName", seriesName);
            // Set attributes
            request.setAttribute("comic", comic);
            request.setAttribute("images", images);
            request.setAttribute("relatedComics", relatedComics);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("suggestedComics", suggestedComics);
            request.setAttribute("suggestionType", suggestionType);

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