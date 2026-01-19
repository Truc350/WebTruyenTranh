//package vn.edu.hcmuaf.fit.ltw_nhom5.controller;
//
//import jakarta.servlet.*;
//import jakarta.servlet.http.*;
//import jakarta.servlet.annotation.*;
//import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
//import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
//import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
//import vn.edu.hcmuaf.fit.ltw_nhom5.utils.PasswordUtils;
//import vn.edu.hcmuaf.fit.ltw_nhom5.utils.EmailUtils;
//
//import java.io.IOException;
//import java.util.Optional;
//
//@WebServlet(name = "ForgotPasswordServlet", value = "/ForgotPasswordServlet")
//public class ForgotPasswordServlet extends HttpServlet {
//    private UserDao userDao;
//
//    @Override
//    public void init() {
//        userDao = new UserDao(JdbiConnector.get());
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//        String email = request.getParameter("email");
//
//        if ("getCode".equals(action)) {
//            // Kiểm tra email có tồn tại
//            Optional<User> userOpt = userDao.findByEmail(email);
//            if (userOpt.isEmpty()) {
//                request.setAttribute("error", "Email không tồn tại trong hệ thống!");
//                request.getRequestDispatcher("/fontend/public/ForgotPass.jsp").forward(request, response);
//                return;
//            }
//
//            // Sinh mã OTP
//            String code = String.valueOf((int)(Math.random() * 900000) + 100000);
//
//            // Lưu OTP vào session (có thể lưu DB nếu muốn)
//            request.getSession().setAttribute("otp", code);
//            request.getSession().setAttribute("otpEmail", email);
//
//            // Gửi email
//            EmailUtils.sendEmail(email, "Mã xác thực quên mật khẩu", "Mã OTP của bạn là: " + code);
//
//            request.setAttribute("message", "Mã xác thực đã được gửi đến email!");
//            request.setAttribute("enteredEmail", email);
//            request.getRequestDispatcher("/fontend/public/ForgotPass.jsp").forward(request, response);
//
//        } else if ("resetPassword".equals(action)) {
//            String code = request.getParameter("code");
//            String newPassword = request.getParameter("newPassword");
//
//            String sessionCode = (String) request.getSession().getAttribute("otp");
//            String sessionEmail = (String) request.getSession().getAttribute("otpEmail");
//
//            if (sessionCode != null && sessionCode.equals(code)) {
//                // Kiểm tra format mật khẩu
//                if (!PasswordUtils.isValidPasswordFormat(newPassword)) {
//                    request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
//                    request.getRequestDispatcher("/fontend/public/ForgotPass.jsp").forward(request, response);
//                    return;
//                }
//
//                // Hash mật khẩu mới
//                String hashed = PasswordUtils.hashPassword(newPassword);
//
//                // Update DB
//                userDao.updatePassword(sessionEmail, hashed);
//
//                // Xóa OTP khỏi session
//                request.getSession().removeAttribute("otp");
//                request.getSession().removeAttribute("otpEmail");
//
//                request.setAttribute("message", "Đổi mật khẩu thành công!");
//                response.sendRedirect(request.getContextPath() + "/fontend/public/login.jsp");
//            } else {
//                request.setAttribute("error", "Mã xác thực không đúng!");
//                request.getRequestDispatcher("/fontend/public/ForgotPass.jsp").forward(request, response);
//            }
//        }
//    }
//}
