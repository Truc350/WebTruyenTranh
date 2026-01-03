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

        String country = request.getParameter("country");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String houseNumber = request.getParameter("house-number");

        String fullName = ho + " " + ten;
        String address = houseNumber + ", " + district + ", " + province + ", " + country;

        // Lấy user hiện tại từ session (ví dụ đã đăng nhập)
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }

        // Cập nhật thông tin
        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);
        currentUser.setEmail(email);
        currentUser.setGender(gender);
        currentUser.setBirthdate(birthdate);
        currentUser.setAddress(address);
        currentUser.setUpdatedAt(LocalDateTime.now());
        System.out.println("current user current is: "+currentUser.toString());
        // Gọi DAO để update
        boolean success = userDao.updateUser(currentUser);

//        if (success) {
//            request.getSession().setAttribute("user", currentUser); // cập nhật lại session
//            response.sendRedirect(request.getContextPath() +"/fontend/nguoiB/profile.jsp");
//        } else {
//            response.sendRedirect(request.getContextPath() +"/fontend/nguoiB/profile.jsp");
//        }
        if (success) {
            request.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("message", "Cập nhật thất bại, vui lòng thử lại.");
        }
        request.getRequestDispatcher("/fontend/nguoiB/profile.jsp").forward(request, response);

    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
