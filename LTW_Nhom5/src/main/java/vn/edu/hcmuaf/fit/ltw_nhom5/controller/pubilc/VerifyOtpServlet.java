package vn.edu.hcmuaf.fit.ltw_nhom5.controller.pubilc;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "VerifyOtpServlet", value = "/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        String sessionCode = (String) request.getSession().getAttribute("otp");

        if (sessionCode != null && sessionCode.equals(code)) {
            // OTP đúng → XÓA TẤT CẢ attributes liên quan
            request.getSession().removeAttribute("otpSent");
            request.getSession().removeAttribute("otpError");

            // Chuyển sang trang tạo mật khẩu
            response.sendRedirect(request.getContextPath() + "/fontend/public/reset-password.jsp");
        } else {
            // OTP sai → giữ otpSent và báo lỗi
            request.getSession().setAttribute("otpSent", true);
            request.getSession().setAttribute("otpError", "Mã xác thực không đúng!");

            // QUAN TRỌNG: Phải dùng forward để giữ otpSent
            request.getRequestDispatcher("/fontend/public/ForgotPass.jsp").forward(request, response);
        }
    }
}