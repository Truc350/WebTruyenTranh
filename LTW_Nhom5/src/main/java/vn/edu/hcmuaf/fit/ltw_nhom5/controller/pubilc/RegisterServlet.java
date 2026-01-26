package vn.edu.hcmuaf.fit.ltw_nhom5.controller.pubilc;

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
        userDao = new UserDao(JdbiConnector.get());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu khớp
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu không khớp!");
            request.getRequestDispatcher("/fontend/public/Register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra format mật khẩu
        if (!PasswordUtils.isValidPasswordFormat(password)) {
            request.setAttribute("error", "Mật khẩu phải ít nhất 8 ký tự, chữ hoa, thường, số và ký tự đặc biệt!");
            request.getRequestDispatcher("/fontend/public/Register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra username/email đã tồn tại
        if (userDao.findByUsername(username).isPresent()) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.getRequestDispatcher("/fontend/public/Register.jsp").forward(request, response);
            return;
        }

        if (userDao.findByEmail(email).isPresent()) {
            request.setAttribute("error", "Email đã được sử dụng!");
            request.getRequestDispatcher("/fontend/public/Register.jsp").forward(request, response);
            return;
        }

        // Hash mật khẩu và lưu
        String passwordHash = PasswordUtils.hashPassword(password);

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(passwordHash);
        user.setFullName(username);

        // Sau khi insert user thành công
        userDao.insert(user);
        request.setAttribute("success", true);
        request.getRequestDispatcher("/fontend/public/Register.jsp").forward(request, response);

    }

        @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/fontend/public/Register.jsp").forward(request, response);
    }
}
