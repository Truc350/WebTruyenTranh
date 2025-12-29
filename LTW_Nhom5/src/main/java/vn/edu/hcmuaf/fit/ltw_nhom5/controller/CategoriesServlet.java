package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;

import java.io.IOException;
import java.util.List;

@WebServlet("/category")
public class CategoriesServlet extends HttpServlet {
    private CategoriesDao categoriesDao;
   //ai làm lấy truyện chỗ này thì thêm comic vô nè

    @Override
    public void init() throws ServletException {
        categoriesDao = new CategoriesDao();

    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy id thể loại từ URL: /category?id=3
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int categoryId = Integer.parseInt(idParam);

        // Lấy thông tin thể loại để hiển thị tiêu đề
        List<Category> allCategories = categoriesDao.listCategories();
        Category selectedCategory = null;
        for (Category c : allCategories) {
            if (c.getId() == categoryId) {
                selectedCategory = c;
                break;
            }
        }

        if (selectedCategory == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            System.out.println("select category is null");
            return;
        }



        request.setAttribute("selectedCategory", selectedCategory);


        request.getRequestDispatcher("/fontend/public/CatagoryPage.jsp")
                .forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}