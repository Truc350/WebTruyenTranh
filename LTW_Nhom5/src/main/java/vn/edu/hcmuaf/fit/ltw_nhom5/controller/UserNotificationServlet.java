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

        try {
            if ("/count".equals(pathInfo)) {
                handleCount(request, response, user);
            } else if ("/recent".equals(pathInfo)) {
                handleRecent(request, response, user);
            } else if ("/list".equals(pathInfo)) {
                handleList(request, response, user);
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

        // Format date cho từng notification
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        for (Notification noti : notifications) {
            if (noti.getCreatedAt() != null) {
                noti.setFormattedCreatedAt(formatRelativeTime(noti.getCreatedAt()));
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("notifications", notifications);
        result.put("unread_count", unreadCount);

        response.getWriter().write(gson.toJson(result));
    }

    /**
     * GET /NotificationServlet/list?page=1&pageSize=20&type=ORDER_CONFIRMED
     * Trả về danh sách phân trang
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        String typeFilter = request.getParameter("type");

        int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null) ? Integer.parseInt(pageSizeParam) : 20;

        List<Notification> notifications = notificationDAO.getList(user.getId(), typeFilter, page, pageSize);

        // Format date
        for (Notification noti : notifications) {
            if (noti.getCreatedAt() != null) {
                noti.setFormattedCreatedAt(formatRelativeTime(noti.getCreatedAt()));
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("notifications", notifications);
        result.put("page", page);
        result.put("pageSize", pageSize);

        response.getWriter().write(gson.toJson(result));
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
        notificationDAO.markAsread(notiId);

        response.getWriter().write("{\"success\": true}");
    }

    /**
     * POST /NotificationServlet/mark-all-read
     * Đánh dấu tất cả thông báo đã đọc
     */
    private void handleMarkAllRead(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        notificationDAO.markAllAsRead(user.getId());

        response.getWriter().write("{\"success\": true}");
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