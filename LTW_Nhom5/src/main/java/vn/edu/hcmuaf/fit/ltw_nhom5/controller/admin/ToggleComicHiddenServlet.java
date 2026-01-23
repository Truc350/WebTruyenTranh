package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/products/toggle-hidden")
public class ToggleComicHiddenServlet extends HttpServlet {
    private ComicDAO comicDAO;

    @Override
    public void init() throws ServletException {
        comicDAO = new ComicDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            String idParam = request.getParameter("id");
            String hiddenParam = request.getParameter("hidden");

            if (idParam == null || hiddenParam == null) {
                result.put("success", false);
                result.put("message", "Thiếu tham số id hoặc hidden");
                response.getWriter().print(gson.toJson(result));
                return;
            }

            int comicId = Integer.parseInt(idParam);
            int hidden = Integer.parseInt(hiddenParam);

            // Validate hidden value (chỉ cho phép 0 hoặc 1)
            if (hidden != 0 && hidden != 1) {
                result.put("success", false);
                result.put("message", "Giá trị hidden không hợp lệ");
                response.getWriter().print(gson.toJson(result));
                return;
            }

            boolean success = comicDAO.toggleHidden(comicId, hidden);

            result.put("success", success);
            if (success) {
                result.put("message", hidden == 1 ? "Đã ẩn truyện" : "Đã hiện truyện");
            } else {
                result.put("message", "Không thể cập nhật trạng thái");
            }

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID hoặc giá trị hidden không hợp lệ");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        response.getWriter().print(gson.toJson(result));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Redirect sang POST
        doPost(req, resp);
    }
}