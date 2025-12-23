package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "WishlistServlet", value = "/WishlistServlet")
public class WishlistServlet extends HttpServlet {
    private Jdbi jdbi;

    @Override
    public void init() throws ServletException {
        jdbi = JdbiConnector.get();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập!\"}");
            return;
        }
        String action = request.getParameter("action");// add hoặc remove
        int comicId = Integer.parseInt(request.getParameter("comic_id"));
        try {
            if ("add".equals(action)) {
                // kiểm tra trong wishlist chưa
                boolean exists = jdbi.withHandle(handle ->
                        handle.createQuery("SELECT COUNT(*) FROM wishlist WHERE user_id = :userId AND comic_id = :comicId").bind("userId", userId).bind("comicId", comicId).mapTo(Integer.class).one() > 0);
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống\"}");
        }
    }
}
