package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.NotificationDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Notification;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.gson.GsonConfig;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "UserNotificationServlet", value = "/NotificationServlet/*")
public class UserNotificationServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = NotificationDAO.getInstance();
    private Gson gson;

    @Override
    public void init() throws ServletException {
        gson = GsonConfig.getGson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra user đã đăng nhập
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\": \"Not authenticated\"}");
            return;
        }

        String pathInfo = request.getPathInfo();
        System.out.println("📡 Request pathInfo: " + pathInfo + " - User ID: " + user.getId());

        try {
            if ("/count".equals(pathInfo)) {
                handleCount(request, response, user);
            } else if ("/recent".equals(pathInfo)) {
                handleRecent(request, response, user);
            } else if ("/list".equals(pathInfo)) {
                handleList(request, response, user);
            } else {
                System.out.println("❌ Endpoint not found: " + pathInfo);
                response.setStatus(404);
                response.getWriter().write("{\"error\": \"Endpoint not found\"}");
            }
        } catch (Exception e) {
            System.err.println("❌ Error handling request: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\": \"Not authenticated\"}");
            return;
        }

        String pathInfo = request.getPathInfo();
        System.out.println("📡 POST pathInfo: " + pathInfo + " - User ID: " + user.getId());

        try {
            if ("/mark-read".equals(pathInfo)) {
                handleMarkRead(request, response, user);
            } else if ("/mark-all-read".equals(pathInfo)) {
                handleMarkAllRead(request, response, user);
            } else {
                response.setStatus(404);
                response.getWriter().write("{\"error\": \"Endpoint not found\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    /**
     * GET /NotificationServlet/count
     * Trả về số lượng thông báo chưa đọc
     */
    private void handleCount(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int unreadCount = notificationDAO.countUnread(user.getId());
        System.out.println("📊 Unread count for user " + user.getId() + ": " + unreadCount);

        JsonObject json = new JsonObject();
        json.addProperty("unread_count", unreadCount);

        response.getWriter().write(gson.toJson(json));
    }

    /**
     * GET /NotificationServlet/recent?limit=8
     * Trả về danh sách thông báo gần đây
     */
    private void handleRecent(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String limitParam = request.getParameter("limit");
        int limit = (limitParam != null) ? Integer.parseInt(limitParam) : 10;

        List<Notification> notifications = notificationDAO.getRecent(user.getId(), limit);
        int unreadCount = notificationDAO.countUnread(user.getId());

        System.out.println("✅ Found " + notifications.size() + " notifications");

        // Format date cho từng notification
        for (Notification noti : notifications) {
            if (noti.getCreatedAt() != null) {
                noti.setFormattedCreatedAt(formatRelativeTime(noti.getCreatedAt()));
            }
            noti.setTitle(generateTitle(noti.getType()));
        }

        Map<String, Object> result = new HashMap<>();
        result.put("notifications", notifications);
        result.put("unread_count", unreadCount);

        response.getWriter().write(gson.toJson(result));
    }

    /**
     * GET /NotificationServlet/list?page=1&pageSize=20&type=ORDER
     * Trả về danh sách phân trang với filter theo type
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        String typeFilter = request.getParameter("type");

        int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null) ? Integer.parseInt(pageSizeParam) : 20;

        if ("ALL".equals(typeFilter)) {
            typeFilter = null;
        }

        System.out.println("📋 Loading notification list:");
        System.out.println("  - Page: " + page);
        System.out.println("  - PageSize: " + pageSize);
        System.out.println("  - Type filter: " + (typeFilter != null ? typeFilter : "ALL"));

        List<Notification> notifications = notificationDAO.getList(user.getId(), typeFilter, page, pageSize);

        System.out.println("✅ Found " + notifications.size() + " notifications");

        // Format date và thêm title
        for (Notification noti : notifications) {
            if (noti.getCreatedAt() != null) {
                String formattedDate = formatRelativeTime(noti.getCreatedAt());
                noti.setFormattedCreatedAt(formattedDate);

                Map<String, Object> extraData = new HashMap<>();
                extraData.put("formatted_date", formattedDate);
            }

            String title = generateTitle(noti.getType());
            noti.setTitle(title);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("notifications", notifications);
        result.put("page", page);
        result.put("pageSize", pageSize);
        result.put("total", notifications.size());

        String jsonResponse = gson.toJson(result);
        System.out.println("📤 Sending response: " + jsonResponse.substring(0, Math.min(200, jsonResponse.length())) + "...");

        response.getWriter().write(jsonResponse);
    }

    /**
     * POST /NotificationServlet/mark-read?id=123
     * Đánh dấu 1 thông báo đã đọc
     */
    private void handleMarkRead(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.setStatus(400);
            response.getWriter().write("{\"error\": \"Missing id parameter\"}");
            return;
        }

        int notiId = Integer.parseInt(idParam);
        System.out.println("✅ Marking notification #" + notiId + " as read");

        notificationDAO.markAsread(notiId);

        response.getWriter().write("{\"success\": true}");
    }

    /**
     * POST /NotificationServlet/mark-all-read
     * Đánh dấu tất cả thông báo đã đọc
     */
    private void handleMarkAllRead(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        System.out.println("✅ Marking all notifications as read for user " + user.getId());

        notificationDAO.markAllAsRead(user.getId());

        response.getWriter().write("{\"success\": true}");
    }

    /**
     * Tạo title cho notification dựa trên type
     */
    private String generateTitle(String type) {
        if (type == null) return "Thông báo";

        switch (type) {
            case "ORDER_CONFIRMED":
                return "✅ Đơn hàng đã được xác nhận";
            case "ORDER_SHIPPED":
                return "🚚 Đơn hàng đang được giao";
            case "ORDER_DELIVERED":
                return "📦 Đơn hàng đã giao thành công";
            case "ORDER_CANCELLED":
                return "❌ Đơn hàng đã bị hủy";
            case "REFUND_APPROVED":
                return "💰 Yêu cầu hoàn tiền đã được chấp nhận";
            case "REFUND_REJECTED":
                return "⛔ Yêu cầu hoàn tiền bị từ chối";
            case "ORDER_UPDATE":
                return "📋 Cập nhật đơn hàng";
            case "PROMOTION":
                return "🎉 Khuyến mãi mới";
            case "SYSTEM":
                return "🔔 Thông báo hệ thống";
            default:
                return "📬 Thông báo";
        }
    }

    /**
     * Format thời gian tương đối (vừa xong, 5 phút trước, 2 giờ trước, ...)
     * Hỗ trợ LocalDateTime
     */
    private String formatRelativeTime(LocalDateTime createdAt) {
        if (createdAt == null) {
            return "";
        }

        // Chuyển LocalDateTime sang epoch milliseconds
        long createdAtMillis = createdAt.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
        long diff = System.currentTimeMillis() - createdAtMillis;

        long seconds = diff / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;

        if (seconds < 60) {
            return "Vừa xong";
        } else if (minutes < 60) {
            return minutes + " phút trước";
        } else if (hours < 24) {
            return hours + " giờ trước";
        } else if (days < 7) {
            return days + " ngày trước";
        } else {
            // Format LocalDateTime thành string
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            return createdAt.format(formatter);
        }
    }
}