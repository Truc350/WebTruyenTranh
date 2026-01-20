package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/categories/list")
public class ListCategoriesServlet extends HttpServlet {

    private CategoriesDao categoriesDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        System.out.println("🔧 Initializing ListCategoriesServlet...");
        categoriesDao = new CategoriesDao();
        gson = new Gson();
        System.out.println("✅ ListCategoriesServlet initialized!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        try {
            System.out.println("📋 Getting all categories...");

            List<Category> categories = categoriesDao.getAllCategories();

            if (categories == null || categories.isEmpty()) {
                System.out.println("⚠️ No categories found");
                result.put("success", true);
                result.put("categories", new ArrayList<>());
                result.put("message", "Chưa có thể loại nào");
            } else {
                // Chuyển đổi sang DTO
                List<Map<String, Object>> categoryList = new ArrayList<>();

                for (Category cat : categories) {
                    Map<String, Object> categoryData = new HashMap<>();
                    categoryData.put("id", cat.getId());
                    categoryData.put("nameCategories", cat.getNameCategories());
                    categoryData.put("description", cat.getDescription());
                    categoryList.add(categoryData);
                }

                result.put("success", true);
                result.put("categories", categoryList);
                System.out.println("✅ Found " + categories.size() + " categories");
            }

        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(gson.toJson(result));
        response.getWriter().flush();
    }
}