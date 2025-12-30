package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;

import java.io.IOException;
import java.util.List;

@WebServlet("/header")
public class HeaderServlet extends HttpServlet {
    private CategoriesDao categoriesDao;

    @Override
    public void init() throws ServletException {
        categoriesDao = new CategoriesDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
             //cái trên là load cái  số thể loại thôi đó nghe
            List<Category> listCategories = categoriesDao.listCategories();
            request.setAttribute("listCategories", listCategories);
            request.getRequestDispatcher("/home").forward(request, response);


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}