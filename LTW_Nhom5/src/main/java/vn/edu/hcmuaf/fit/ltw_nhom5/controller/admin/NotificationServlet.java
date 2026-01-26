package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.NotificationDAO;

import java.io.IOException;

@WebServlet({
        "/admin/mark-notification-read",
        "/admin/mark-all-notifications-read"
})
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private static final int ADMIN_ID = 1;

    @Override
    public void init() throws ServletException {
        notificationDAO = NotificationDAO.getInstance();
        System.out.println("✅ [NotificationServlet] Initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        try {
            if (path.endsWith("mark-notification-read")) {
                // Đánh dấu 1 thông báo đã đọc
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    int id = Integer.parseInt(idParam);
                    notificationDAO.markAsread(id);
                    response.getWriter().write("{\"success\": true}");
                    System.out.println("✅ [NotificationAction] Marked notification #" + id + " as read");
                } else {
                    response.getWriter().write("{\"success\": false, \"error\": \"Missing id parameter\"}");
                }
            } else if (path.endsWith("mark-all-notifications-read")) {
                // Đánh dấu tất cả thông báo admin đã đọc
                notificationDAO.markAllAsRead(ADMIN_ID);
                response.getWriter().write("{\"success\": true}");
                System.out.println("✅ [NotificationAction] Marked all admin notifications as read");
            } else {
                response.getWriter().write("{\"success\": false, \"error\": \"Unknown action\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"error\": \"Invalid ID format\"}");
            System.err.println("❌ [NotificationAction] Invalid ID format: " + e.getMessage());
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            System.err.println("❌ [NotificationAction] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}