package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/getCategoryById")
public class GetCategoryByIdServlet extends HttpServlet {

    private CategoriesDao categoriesDao;
    private Gson gson;

    @Override
    public void init() {
        categoriesDao = new CategoriesDao();

        // Cấu hình Gson để serialize LocalDateTime
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class,
                        (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                                context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)))
                .create();

        System.out.println("✓ GetCategoryByIdServlet initialized with Gson adapter");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("=== GetCategoryByIdServlet called ===");

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        PrintWriter out = resp.getWriter();
        Map<String, Object> result = new HashMap<>();

        try {
            String idParam = req.getParameter("id");
            System.out.println("ID parameter: " + idParam);

            if (idParam == null || idParam.isEmpty()) {
                System.out.println("✗ ID is null or empty");
                result.put("success", false);
                result.put("message", "Thiếu ID!");
                out.print(gson.toJson(result));
                return;
            }

            int id = Integer.parseInt(idParam);
            System.out.println("Parsed ID: " + id);
            System.out.println("Calling DAO...");

            Category category = categoriesDao.getCategoryById(id);
            System.out.println("DAO returned: " + (category != null ? "Category found" : "null"));

            if (category != null && !category.isDeleted()) {
                System.out.println("✓ Success - returning category");
                System.out.println("Category name: " + category.getNameCategories());

                result.put("success", true);
                result.put("category", category);
                result.put("message", "Lấy thông tin thành công!");

                String json = gson.toJson(result);
                System.out.println("JSON response: " + json);
                out.print(json);

            } else {
                System.out.println("✗ Category not found or deleted");
                result.put("success", false);
                result.put("message", "Không tìm thấy thể loại!");
                out.print(gson.toJson(result));
            }

        } catch (NumberFormatException e) {
            System.err.println("✗ NumberFormatException:");
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "ID không hợp lệ!");
            out.print(gson.toJson(result));

        } catch (Exception e) {
            System.err.println("✗✗✗ EXCEPTION in GetCategoryByIdServlet ✗✗✗");
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
            out.print(gson.toJson(result));
        }

        out.flush();
    }
}