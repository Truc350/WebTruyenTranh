package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/user-management")
public class UserManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            UserDao userDao = new UserDao(JdbiConnector.get());

            String search = request.getParameter("search");
            String levelFilter = request.getParameter("level");

            List<User> users;

            // Xử lý tìm kiếm và lọc
            if (search != null && !search.trim().isEmpty() && levelFilter != null && !levelFilter.trim().isEmpty()) {
                // Tìm kiếm và lọc kết hợp
                users = userDao.searchAndFilterCustomers(search, levelFilter);
            } else if (search != null && !search.trim().isEmpty()) {
                // Chỉ tìm kiếm
                users = userDao.searchCustomers(search);
            } else if (levelFilter != null && !levelFilter.trim().isEmpty()) {
                // Chỉ lọc theo level
                users = userDao.filterCustomersByMembershipLevel(levelFilter);
            } else {
                // Lấy tất cả
                users = userDao.getAllCustomers();
            }

            // DEBUG: Log để kiểm tra
            System.out.println("=== DEBUG USER MANAGEMENT ===");
            System.out.println("Total users found: " + (users != null ? users.size() : "null"));
            if (users != null && !users.isEmpty()) {
                System.out.println("First user: " + users.get(0));
            }
            System.out.println("============================");

            request.setAttribute("users", users);
            request.getRequestDispatcher("/fontend/admin/userManagement.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý dữ liệu");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        String action = request.getParameter("action");

        try {
            UserDao userDao = new UserDao(JdbiConnector.get());

            if ("upgrade".equals(action)) {
                // Nâng cấp membership
                int userId = Integer.parseInt(request.getParameter("userId"));
                String newLevel = request.getParameter("newLevel");

                boolean success = userDao.upgradeMembershipLevel(userId, newLevel);

                if (success) {
                    response.getWriter().write("{\"status\":\"success\",\"message\":\"Nâng cấp thành công\"}");
                } else {
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Nâng cấp thất bại\"}");
                }

            } else if ("lock".equals(action)) {
                // Khóa tài khoản
                int userId = Integer.parseInt(request.getParameter("userId"));

                boolean success = userDao.lockUserAccount(userId);

                if (success) {
                    response.getWriter().write("{\"status\":\"success\",\"message\":\"Đã khóa tài khoản\"}");
                } else {
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Khóa tài khoản thất bại\"}");
                }

            } else {
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Action không hợp lệ\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi xử lý: " + e.getMessage() + "\"}");
        }
    }
}