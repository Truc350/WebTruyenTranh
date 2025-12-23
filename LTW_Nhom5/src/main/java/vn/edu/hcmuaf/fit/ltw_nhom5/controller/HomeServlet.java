package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;

import java.io.IOException;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private ComicDAO comicDAO;
    private FlashSaleDAO flashSaleDAO;

    @Override
    public void init() throws ServletException {
        comicDAO = new ComicDAO();
        flashSaleDAO = new FlashSaleDAO();
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

        request.getRequestDispatcher("/fontend/public/homePage.jsp")
                .forward(request, response);
    }

}