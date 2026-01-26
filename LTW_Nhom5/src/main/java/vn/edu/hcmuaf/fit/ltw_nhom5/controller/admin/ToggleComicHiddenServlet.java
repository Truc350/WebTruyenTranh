package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý ẩn/hiện sản phẩm
 */
@WebServlet(name = "ToggleHiddenServlet", urlPatterns = {"/admin/products/toggle-hidden"})
public class ToggleComicHiddenServlet extends HttpServlet {

    private final ComicDAO comicDAO = new ComicDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        Map<String, Object> jsonResponse = new HashMap<>();
        PrintWriter out = response.getWriter();

        try {
            // Lấy parameters
            String idStr = request.getParameter("id");
            String hiddenStr = request.getParameter("hidden");

            System.out.println("========================================");
            System.out.println("📥 Toggle Hidden Request:");
            System.out.println("   Comic ID: " + idStr);
            System.out.println("   Hidden value: " + hiddenStr);
            System.out.println("========================================");

            // Validate parameters
            if (idStr == null || idStr.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "ID sản phẩm không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            if (hiddenStr == null || hiddenStr.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Giá trị hidden không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            // Parse parameters
            int comicId;
            int hidden;

            try {
                comicId = Integer.parseInt(idStr);
                hidden = Integer.parseInt(hiddenStr);
            } catch (NumberFormatException e) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Dữ liệu không đúng định dạng");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            // Validate hidden value (chỉ cho phép 0 hoặc 1)
            if (hidden != 0 && hidden != 1) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Giá trị hidden phải là 0 hoặc 1");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            // Thực hiện toggle hidden
            boolean success = comicDAO.toggleHidden(comicId, hidden);

            if (success) {
                String statusMessage = (hidden == 1) ? "ẩn" : "hiển thị";

                System.out.println("✅ Toggle hidden thành công!");
                System.out.println("   Comic ID: " + comicId);
                System.out.println("   Trạng thái mới: " + statusMessage);

                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã cập nhật trạng thái sản phẩm thành " + statusMessage);
                jsonResponse.put("comicId", comicId);
                jsonResponse.put("isHidden", hidden);

            } else {
                System.err.println("❌ Toggle hidden thất bại!");
                System.err.println("   Comic ID: " + comicId);

                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật trạng thái sản phẩm");
            }

        } catch (Exception e) {
            System.err.println("❌ Error in ToggleHiddenServlet: " + e.getMessage());
            e.printStackTrace();

            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi server: " + e.getMessage());

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        // Trả về JSON response
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Method GET không được hỗ trợ. Vui lòng sử dụng POST");

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}