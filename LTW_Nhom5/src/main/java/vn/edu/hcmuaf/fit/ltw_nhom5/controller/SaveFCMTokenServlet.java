package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.eclipse.tags.shaded.org.apache.bcel.generic.FCMPG;
import org.json.JSONObject;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FCMTokenDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.NotificationDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet(name = "SaveFCMTokenServlet", value = "/SaveFCMTokenServlet")
public class SaveFCMTokenServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Kiểm tra user đã login chưa
            User user = (User) request.getSession().getAttribute("currentUser");
            if (user == null) {
                response.setStatus(401);
                response.getWriter().write("{\"success\": false, \"error\": \"Not authenticated\"}");
                return;
            }

            // Đọc request body
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            // Parse JSON
            JsonObject json = JsonParser.parseString(sb.toString()).getAsJsonObject();
            String token = json.get("token").getAsString();

            if (token == null || token.isEmpty()) {
                response.setStatus(400);
                response.getWriter().write("{\"success\": false, \"error\": \"Token is required\"}");
                return;
            }

            // Lưu vào database
            NotificationDAO.getInstance().saveFCMToken(user.getId(), token);

            response.getWriter().write("{\"success\": true, \"message\": \"FCM token saved\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }

    }
}
