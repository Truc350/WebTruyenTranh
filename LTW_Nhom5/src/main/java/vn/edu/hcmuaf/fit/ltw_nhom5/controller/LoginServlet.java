package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.PasswordUtils;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "Login", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDao(JdbiConnector.get());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");

        // Kiểm tra format mật khẩu trước
        if (!PasswordUtils.isValidPasswordFormat(password)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
            return;
        }

        Optional<User> userOpt = userDao.findByUsernameOrEmail(usernameOrEmail);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (PasswordUtils.verifyPassword(password, user.getPasswordHash())) {
                request.getSession().setAttribute("currentUser", user);
                response.sendRedirect(request.getContextPath() + "/fontend/public/homePage.jsp");
            } else {
                request.setAttribute("error", "Hãy nhập đúng tài khoản và mật khẩu!");
                request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Hãy nhập đúng tài khoản và mật khẩu!");
            request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
        }
    }

}
