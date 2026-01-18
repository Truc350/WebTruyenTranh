package vn.edu.hcmuaf.fit.ltw_nhom5.controller.pubilc;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.PasswordUtils;

import java.io.IOException;

@WebServlet(name = "ResetPassServlet", value = "/ResetPassServlet")
public class ResetPassServlet extends HttpServlet {
    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDao(JdbiConnector.get());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        String sessionCode = (String) request.getSession().getAttribute("otp");
        String sessionEmail = (String) request.getSession().getAttribute("otpEmail");

        if (sessionCode == null || sessionEmail == null) {
            request.setAttribute("error", "Bạn chưa có mã xác thực!");
            request.getRequestDispatcher("/fontend/public/reset-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu khớp
        if (!oldPassword.equals(newPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/fontend/public/reset-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra format mật khẩu
        if (!PasswordUtils.isValidPasswordFormat(newPassword)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            request.getRequestDispatcher("/fontend/public/reset-password.jsp").forward(request, response);
            return;
        }

        // Hash mật khẩu mới
        String hashed = PasswordUtils.hashPassword(newPassword);

        // Update DB
        userDao.updatePassword(sessionEmail, hashed);

        // Xóa OTP khỏi session
        request.getSession().removeAttribute("otp");
        request.getSession().removeAttribute("otpEmail");

        // Sau khi đổi mật khẩu thành công → về login
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
