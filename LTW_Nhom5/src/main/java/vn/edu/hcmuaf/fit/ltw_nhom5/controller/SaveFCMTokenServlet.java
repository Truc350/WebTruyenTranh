package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.eclipse.tags.shaded.org.apache.bcel.generic.FCMPG;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FCMTokenDAO;

import java.io.IOException;

@WebServlet(name = "SaveFCMTokenServlet", value = "/SaveFCMTokenServlet")
public class SaveFCMTokenServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // dọc json từ body
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }
        String json = sb.toString();
        int userId = 0;
        String token = "";
        try {
            userId = Integer.parseInt(json.split("\"userId\":")[1].split(",")[0].trim());
            token = json.split("\"token\":\"")[1].split("\"")[0];

        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("{\"error\":\"Invalid JSON\"}");
            return;
        }
        //lưu token vào db
        boolean success = FCMTokenDAO.getInstance().saveOrUpdate(userId, token);
        response.setContentType("application/json");
        if (success) {
            response.getWriter().write("{\"success\":true}");
        }else {
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"Save failed\"}");
        }
    }
}
