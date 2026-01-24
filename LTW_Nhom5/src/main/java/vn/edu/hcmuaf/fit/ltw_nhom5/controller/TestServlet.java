package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/test-servlet")
public class TestServlet extends HttpServlet {

    @Override
    public void init() {
        System.out.println("✅ TestServlet INITIALIZED");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("✅ TestServlet doGet called");

        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write("TestServlet works! Context: " + request.getContextPath());
    }
}
