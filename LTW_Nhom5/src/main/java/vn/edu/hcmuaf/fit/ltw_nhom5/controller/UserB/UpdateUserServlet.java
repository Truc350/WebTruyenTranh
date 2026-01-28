package vn.edu.hcmuaf.fit.ltw_nhom5.controller.UserB;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet("/updateUser")
public class UpdateUserServlet extends HttpServlet {
    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDao(JdbiConnector.get());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy user hiện tại từ session
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String ho = request.getParameter("ho");
            String ten = request.getParameter("ten");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String gender = request.getParameter("gender");

            int day = Integer.parseInt(request.getParameter("day"));
            int month = Integer.parseInt(request.getParameter("month"));
            int year = Integer.parseInt(request.getParameter("year"));
            LocalDate birthdate = LocalDate.of(year, month, day);

            // Lấy thông tin địa chỉ - GIỜ ĐÃ LÀ TÊN CHỨ KHÔNG PHẢI CODE
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String houseNumber = request.getParameter("house-number");

            // Tạo tên đầy đủ
            String fullName = ho + " " + ten;

            // Tạo địa chỉ đầy đủ
            String address = houseNumber;
            if (district != null && !district.trim().isEmpty()) {
                address += ", " + district.trim();
            }
            if (province != null && !province.trim().isEmpty()) {
                address += ", " + province.trim();
            }
            address += ", Việt Nam";

            // Cập nhật thông tin user
            currentUser.setFullName(fullName);
            currentUser.setPhone(phone);
            currentUser.setEmail(email);
            currentUser.setGender(gender);
            currentUser.setBirthdate(birthdate);
            currentUser.setAddress(address);
            currentUser.setUpdatedAt(LocalDateTime.now());

            System.out.println("🔄 Updating user: " + currentUser.getFullName());
            System.out.println("📍 New address: " + address);

            // Gọi DAO để update
            boolean success = userDao.updateUser(currentUser);

            if (success) {
                // Cập nhật lại session với thông tin mới
                request.getSession().setAttribute("currentUser", currentUser);
                request.setAttribute("message", "Cập nhật thông tin thành công!");
                System.out.println("✅ User updated successfully");
            } else {
                request.setAttribute("message", "Cập nhật thất bại, vui lòng thử lại.");
                System.out.println("❌ User update failed");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("message", "Dữ liệu ngày sinh không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
        }

        // Forward về trang profile
        request.getRequestDispatcher("/fontend/nguoiB/profile-info.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Forward sang trang profile
        request.getRequestDispatcher("/fontend/nguoiB/profile-info.jsp").forward(request, response);
    }
}