package vn.edu.hcmuaf.fit.ltw_nhom5.controller.pubilc;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", value = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // XÓA tất cả attributes liên quan đến OTP
        request.getSession().removeAttribute("otpSent");
        request.getSession().removeAttribute("otpError"); // THÊM DÒNG NÀY
        request.getSession().removeAttribute("otp");
        request.getSession().removeAttribute("otpEmail");

        // Forward đến trang ForgotPass.jsp
        request.getRequestDispatcher("/fontend/public/ForgotPass.jsp").forward(request, response);
    }
}