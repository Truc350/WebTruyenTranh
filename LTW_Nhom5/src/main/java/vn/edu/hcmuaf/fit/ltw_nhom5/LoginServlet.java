package vn.edu.hcmuaf.fit.ltw_nhom5;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "login", value = "/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("username");
        String password = request.getParameter("password");

        if ("abc@gmail.com".equals(name) && "123".equals(password)) {
            response.sendRedirect(request.getContextPath() + "/fontend/public/homePage.jsp");


        } else {
            request.setAttribute("message", "Invalid User Name or Password");
            request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
        }

    }
}