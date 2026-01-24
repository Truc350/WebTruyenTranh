package vn.edu.hcmuaf.fit.ltw_nhom5.controller.UserB;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


@WebServlet(name = "UserCategoryServlet", urlPatterns = {"/userCategory"})
public class UserCategoryServlet extends HttpServlet {
    private CategoriesDao categoriesDao;
    private ComicDAO comicDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            categoriesDao = new CategoriesDao();
            comicDAO = new ComicDAO();
            System.out.println("✓ UserCategoryServlet initialized successfully");
        } catch (Exception e) {
            System.err.println("✗ ERROR initializing UserCategoryServlet:");
            e.printStackTrace();
            throw new ServletException("Failed to initialize UserCategoryServlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            String categoryIdParam = request.getParameter("id");

            if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int categoryId = Integer.parseInt(categoryIdParam);
            System.out.println("=== UserCategoryServlet: categoryId = " + categoryId + " ===");

            // Lấy thông tin category
            Category selectedCategory = categoriesDao.getCategoryById(categoryId);

            if (selectedCategory == null || selectedCategory.getIs_hidden() == 1) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            // Lấy các tham số filter
            String[] priceFilters = request.getParameterValues("price");
            String[] authorFilters = request.getParameterValues("author");
            String[] publisherFilters = request.getParameterValues("publisher");
            String[] yearFilters = request.getParameterValues("year");

            // Convert sang List
            List<String> priceRanges = priceFilters != null ? Arrays.asList(priceFilters) : new ArrayList<>();
            List<String> authors = authorFilters != null ? Arrays.asList(authorFilters) : new ArrayList<>();
            List<String> publishers = publisherFilters != null ? Arrays.asList(publisherFilters) : new ArrayList<>();
            List<String> years = yearFilters != null ? Arrays.asList(yearFilters) : new ArrayList<>();

            // Lấy danh sách comics với filter
            List<Comic> comicList;
            if (priceRanges.isEmpty() && authors.isEmpty() && publishers.isEmpty() && years.isEmpty()) {
                // Không có filter, lấy tất cả
                comicList = comicDAO.getComicsByCategory1(categoryId);
            } else {
                // Có filter
                comicList = comicDAO.getComicsByCategoryWithFilters(categoryId, priceRanges, authors, publishers, years);
            }

            // Lấy danh sách tác giả và nhà xuất bản cho category này
            List<String> availableAuthors = comicDAO.getAuthorsByCategory(categoryId);
            List<String> availablePublishers = comicDAO.getPublishersByCategory(categoryId);

            // Lấy danh sách categories cho header
            List<Category> listCategories = categoriesDao.listCategories();

            // Set attributes
            request.setAttribute("selectedCategory", selectedCategory);
            request.setAttribute("comicList", comicList);
            request.setAttribute("listCategories", listCategories);
            request.setAttribute("availableAuthors", availableAuthors);
            request.setAttribute("availablePublishers", availablePublishers);
            request.setAttribute("selectedPrices", priceRanges);
            request.setAttribute("selectedAuthors", authors);
            request.setAttribute("selectedPublishers", publishers);
            request.setAttribute("selectedYears", years);

            request.getRequestDispatcher("/fontend/public/CatagoryPage.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("✗ ERROR in UserCategoryServlet:");
            e.printStackTrace();
            throw new ServletException("Error processing category request", e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
