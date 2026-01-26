package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import com.google.gson.Gson;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.Map;

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

                // Kiểm tra xem user có đủ điều kiện không
                Map<String, Object> eligibility = userDao.checkUpgradeEligibility(userId, newLevel);

                if ((boolean) eligibility.get("eligible")) {
                    // Đủ điều kiện -> Nâng cấp
                    boolean success = userDao.upgradeMembershipLevel(userId, newLevel);

                    if (success) {
                        response.getWriter().write(
                                "{\"status\":\"success\",\"message\":\"Nâng cấp thành công lên " + newLevel + "\"}"
                        );
                    } else {
                        response.getWriter().write(
                                "{\"status\":\"error\",\"message\":\"Nâng cấp thất bại\"}"
                        );
                    }
                } else {
                    // CHƯA ĐỦ ĐIỀU KIỆN
                    response.getWriter().write(
                            "{\"status\":\"error\",\"message\":\"" + eligibility.get("message") + "\"}"
                    );
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

            } else if ("syncSpent".equals(action)) {
                // Đồng bộ total_spent từ orders
                String syncType = request.getParameter("syncType");

                if ("all".equals(syncType)) {
                    // Đồng bộ cho tất cả users
                    int updated = userDao.syncAllUsersTotalSpent();
                    response.getWriter().write(
                            "{\"status\":\"success\",\"message\":\"Đã cập nhật " + updated + " users\",\"count\":" + updated + "}"
                    );
                } else if ("one".equals(syncType)) {
                    // Đồng bộ cho 1 user
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    boolean success = userDao.syncTotalSpentFromOrders(userId);

                    if (success) {
                        response.getWriter().write(
                                "{\"status\":\"success\",\"message\":\"Đã cập nhật tổng chi tiêu\"}"
                        );
                    } else {
                        response.getWriter().write(
                                "{\"status\":\"error\",\"message\":\"Không thể cập nhật\"}"
                        );
                    }
                } else {
                    response.getWriter().write(
                            "{\"status\":\"error\",\"message\":\"syncType không hợp lệ\"}"
                    );
                }
            }  else if ("check-violation".equals(action)) {
                // ✅ THÊM: Endpoint kiểm tra vi phạm
                handleCheckViolation(request, response);
            }
            else {
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Action không hợp lệ\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi xử lý: " + e.getMessage() + "\"}");
        }
    }

    /**
     * ✅ THÊM: Kiểm tra vi phạm trước khi cho phép khóa
     */
    private void handleCheckViolation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));

            UserDao userDao = UserDao.getInstance();
            Map<String, Object> violationInfo = userDao.checkUserViolation(userId);

            // Trả về JSON
            Gson gson = new Gson();
            response.getWriter().write(gson.toJson(violationInfo));

        } catch (Exception e) {
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}