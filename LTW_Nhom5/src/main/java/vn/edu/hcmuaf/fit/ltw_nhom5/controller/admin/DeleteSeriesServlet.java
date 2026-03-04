package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;

import java.io.IOException;

@WebServlet(name = "DeleteSeriesServlet", urlPatterns = {"/DeleteSeriesServlet"})
public class DeleteSeriesServlet extends HttpServlet {

    private SeriesDAO seriesDAO;

    @Override
    public void init() throws ServletException {
        seriesDAO = new SeriesDAO();
        System.out.println("✅ DeleteSeriesServlet initialized successfully!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("========================================");
        System.out.println("✅ DeleteSeriesServlet.doGet() được gọi!");
        System.out.println("========================================");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy ID series cần xóa
            String seriesIdParam = request.getParameter("id");

            if (seriesIdParam == null || seriesIdParam.trim().isEmpty()) {
                System.err.println("Missing series ID");
                request.getSession().setAttribute("errorMessage", "Thiếu ID series!");
                response.sendRedirect(request.getContextPath() + "/admin/SeriesManagement");
                return;
            }

            int seriesId = Integer.parseInt(seriesIdParam);
            System.out.println("🗑️ Deleting series ID: " + seriesId);

            // Lấy tên series trước khi xóa (để hiển thị thông báo)
            String seriesName = seriesDAO.getSeriesNameById1(seriesId);

            // Thực hiện xóa mềm
            boolean success = seriesDAO.deleteSeries(seriesId);

            if (success) {
                System.out.println("✅ Series deleted successfully: " + seriesId);
                String message = "Xóa series";
                if (seriesName != null) {
                    message += " '" + seriesName + "'";
                }
                message += " thành công!";
                request.getSession().setAttribute("successMessage", message);
            } else {
                System.err.println("❌ Failed to delete series: " + seriesId);
                request.getSession().setAttribute("errorMessage", "Xóa series thất bại!");
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid series ID: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "ID series không hợp lệ!");
        } catch (Exception e) {
            System.err.println("❌ Error deleting series: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xóa series: " + e.getMessage());
        }

        // Redirect về trang quản lý series
        response.sendRedirect(request.getContextPath() + "/admin/SeriesManagement");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}