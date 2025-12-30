package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/*
fontend → Facebook → Servlet → Graph API → Session
 */

@WebServlet("/login-facebook-callback")
public class LoginFacebookCallbackServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        try {
            String code = request.getParameter("code"); // Facebook gửi code về
            if (code == null) {
                response.getWriter().println("Code từ Facebook bị null hoặc user hủy login");
                return;
            }

            // Bước 1: Đổi code lấy access token
            String clientId = System.getenv("FACEBOOK_APP_ID");
            String clientSecret = System.getenv("FACEBOOK_APP_SECRET");
            String redirectUri = "http://localhost:8080/LTW_Nhom5/login-facebook-callback";


            String tokenUrl = "https://graph.facebook.com/v19.0/oauth/access_token"
                    + "?client_id=" + clientId
                    + "&redirect_uri=" + redirectUri
                    + "&client_secret=" + clientSecret
                    + "&code=" + code;

            URL url = new URL(tokenUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            br.close();

            JSONObject tokenJson = new JSONObject(sb.toString());
            String accessToken = tokenJson.getString("access_token");

            // Bước 2: Dùng access token lấy thông tin user
            String userUrl = "https://graph.facebook.com/me?fields=id,name,email&access_token=" + accessToken;
            URL userURL = new URL(userUrl);
            HttpURLConnection userConn = (HttpURLConnection) userURL.openConnection();
            userConn.setRequestMethod("GET");

            BufferedReader brUser = new BufferedReader(new InputStreamReader(userConn.getInputStream()));
            StringBuilder userSb = new StringBuilder();
            while ((line = brUser.readLine()) != null) userSb.append(line);
            brUser.close();

            JSONObject userJson = new JSONObject(userSb.toString());

            // Lưu thông tin user vào session
            request.getSession().setAttribute("fbId", userJson.getString("id"));
            request.getSession().setAttribute("name", userJson.getString("name"));
            request.getSession().setAttribute("email", userJson.optString("email", ""));

            // Redirect về trang chính
            response.sendRedirect(request.getContextPath() + "/fontend/public/homePage.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.getWriter().println("Lỗi: " + e.getMessage());
            } catch (Exception ex) {
            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
