package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Banner;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.ComicService;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.RecommendationService;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet({"/home"})
public class HomeServlet extends HttpServlet {
    private ComicDAO comicDAO;
    private FlashSaleDAO flashSaleDAO;
    private ComicService comicService;
    private BannerDao bannerDao;
    private WishlistDAO wishlistDAO;
    private RecommendationService recommendationService;

    @Override
    public void init() throws ServletException {
        comicDAO = new ComicDAO();
        flashSaleDAO = new FlashSaleDAO();
        comicService = new ComicService(JdbiConnector.get());
        bannerDao = new BannerDao(JdbiConnector.get());
//        Jdbi jdbi = Jdbi.create(
//                "jdbc:mysql://localhost:3306/comic_shop?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
//                "root",
//                ""  // password rỗng
//        );
        wishlistDAO = new WishlistDAO();
        recommendationService = new RecommendationService(comicDAO, wishlistDAO);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {



        HttpSession session = request.getSession(false);
        User currentUser = null;
        Integer userId = null;
        if (session != null) {
            // Lấy từ "currentUser" (như LoginServlet đang lưu)
            currentUser = (User) session.getAttribute("currentUser");

            if (currentUser != null) {
                userId = currentUser.getId();
                System.out.println("✓ Found user from session");
                System.out.println("  - User ID: " + userId);
                System.out.println("  - Username: " + currentUser.getUsername());
            } else {
                System.out.println("⚠️ No user found in session (Guest user)");
            }
        } else {
            System.out.println("⚠️ No session found (Guest user)");
        }


        // Top 5 truyện bán chạy trong tuần
        request.setAttribute(
                "topComics",
                comicDAO.getTop5BestSellerThisWeek()
        );

        // Flash sale đang diễn ra & sắp kết thúc
        request.setAttribute(
                "flashSale",
                flashSaleDAO.getActiveFlashSaleEndingSoon()
        );

//        //gợi ý truyện theo wishlist + số tập
//        HttpSession session = request.getSession();
//        Integer userId = (Integer) session.getAttribute("userId");// null nnếu chưa login
//        // Goij server để lấy gợi ý.,
//        List<Comic> suggestedComics = comicService.getSuggestedComics(userId);
//        // Đưa dữ liệu vào request
//        request.setAttribute("suggestedComics", suggestedComics);


        //chỗ này của banner
        Timestamp now = new Timestamp(System.currentTimeMillis());
        List<Banner> banners = bannerDao.findActiveBanners(now);

//        System.out.println(now);
//            if (banners == null) {
//                System.out.println("No banners found");
//            }else{
//                System.out.println("Banners size = " + banners.size());
//                for (Banner b : banners) {
//                    System.out.println("Banner id = " + b.getId() + ", url = " + b.getImageUrl());
//                }
//        }

        request.setAttribute("banners", banners); //hết phần banner

        //cái này bỏ rồi nha
//        CategoriesDao categoriesDao = new CategoriesDao();
//        List<Category> listCategories = categoriesDao.listCategories();
//        request.setAttribute("listCategories", listCategories);


        // Lấy comics gợi ý
        List<Comic> recommendedComics;
        if (currentUser != null) {
            int wishlistCount = wishlistDAO.getWishlistCount(currentUser.getId());

            if (wishlistCount > 0) {
                recommendedComics = comicDAO.getRecommendedComics(currentUser.getId(), 16);

            } else {
                recommendedComics = comicDAO.getPopularComics(16);
            }
        } else {
            //chua dang nhap
            recommendedComics = comicDAO.getPopularComics(16);
        }
        // Lấy top comics bán chạy trong tuần
        List<Comic> topComics = comicDAO.getTopSellingComics(5);
        // Set attributes
        request.setAttribute("recommendedComics", recommendedComics);
        request.setAttribute("topComics", topComics);
        request.setAttribute("isLoggedIn", currentUser != null);


        request.getRequestDispatcher("/fontend/public/homePage.jsp")
                .forward(request, response);


    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}




