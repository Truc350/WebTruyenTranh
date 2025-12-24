package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.PasswordUtils;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private UserDao userDao;

    @Override
    public void init() {
        // Khởi tạo Jdbi (ví dụ bạn có class JdbiConnector)
        userDao = new UserDao(JdbiConnector.get());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu không khớp!");
            request.getRequestDispatcher("/fontend/public/register.jsp").forward(request, response);
            return;
        }

        // Hash mật khẩu
        String passwordHash = PasswordUtils.hashPassword(password);

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(passwordHash);
        user.setFullName(username); // hoặc lấy từ form

        userDao.insert(user);
        response.sendRedirect(request.getContextPath() + "/fontend/public/homePage.jsp");

        //response.sendRedirect("/fontend/public/homePage.jsp");
    }
}
