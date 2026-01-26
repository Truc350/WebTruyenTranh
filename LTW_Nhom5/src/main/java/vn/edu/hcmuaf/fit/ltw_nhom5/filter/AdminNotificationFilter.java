package vn.edu.hcmuaf.fit.ltw_nhom5.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.NotificationDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Notification;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.io.IOException;
import java.util.List;
@WebFilter("/fontend/admin/*")
public class AdminNotificationFilter implements Filter {
    private NotificationDAO notificationDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        notificationDAO = NotificationDAO.getInstance();
        System.out.println("✅ [AdminNotificationFilter] Filter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        // Kiểm tra admin đã login
        if (session != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

            if (currentUser != null && isAdmin != null && isAdmin) {
                try {
                    // Load notifications cho admin
                    List<Notification> notifications = notificationDAO.getRecentForAdmin(10);
                    int unreadCount = notificationDAO.countUnreadForAdmin();

                    // Set vào request để JSP dùng
                    request.setAttribute("notifications", notifications);
                    request.setAttribute("unreadNotificationCount", unreadCount);

                    System.out.println("📬 [AdminNotificationFilter] Loaded " + notifications.size() +
                            " notifications, unread: " + unreadCount);

                } catch (Exception e) {
                    System.err.println("❌ [AdminNotificationFilter] Error: " + e.getMessage());
                    e.printStackTrace();

                    // Set mặc định nếu lỗi
                    request.setAttribute("notifications", List.of());
                    request.setAttribute("unreadNotificationCount", 0);
                }
            } else {
                // Không phải admin
                request.setAttribute("notifications", List.of());
                request.setAttribute("unreadNotificationCount", 0);
            }
        } else {
            // Không có session
            request.setAttribute("notifications", List.of());
            request.setAttribute("unreadNotificationCount", 0);
        }

        // Tiếp tục chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup nếu cần
    }
}
