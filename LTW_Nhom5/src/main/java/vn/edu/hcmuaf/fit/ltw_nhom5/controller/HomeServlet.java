package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.BannerDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Banner;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.ComicService;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet({"/home", "/"})
public class HomeServlet extends HttpServlet {
    private ComicDAO comicDAO;
    private FlashSaleDAO flashSaleDAO;
    private ComicService comicService;
    private BannerDao bannerDao;

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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        //gợi ý truyện theo wishlist + số tập
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");// null nnếu chưa login
        // Goij server để lấy gợi ý.,
        List<Comic> suggestedComics = comicService.getSuggestedComics(userId);
        // Đưa dữ liệu vào request
        request.setAttribute("suggestedComics", suggestedComics);


        //chỗ này của banner
        Timestamp now = new Timestamp(System.currentTimeMillis());
        List<Banner> banners = bannerDao.findActiveBanners(now);
        System.out.println(now);

            //debug log
            if (banners == null) {
                System.out.println("No banners found");
            }else{
                System.out.println("Banners size = " + banners.size());
                for (Banner b : banners) {
                    System.out.println("Banner id = " + b.getId() + ", url = " + b.getImageUrl());
                }
        }
        request.setAttribute("banners", banners);


        request.getRequestDispatcher("/fontend/public/homePage.jsp")
                .forward(request, response);
    }

}