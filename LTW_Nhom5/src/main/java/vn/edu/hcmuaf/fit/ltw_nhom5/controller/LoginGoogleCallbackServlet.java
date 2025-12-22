package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = "/login-google-callback", name = "LoginGoogleCallbackServlet")
public class LoginGoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");

    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");

    private static final String REDIRECT_URI =
            "http://localhost:8080/LTW_Nhom5/login-google-callback";

    static {
        if (CLIENT_ID == null || CLIENT_SECRET == null) {
            throw  new RuntimeException("Missing GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET");
        }
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");

        if (code == null) {
            response.sendRedirect(request.getContextPath() + "/fontend/public/login.jsp");
            return;
        }

        // 1️⃣ Đổi code → access_token
        String params =
                "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
                        + "&client_id=" + CLIENT_ID
                        + "&client_secret=" + CLIENT_SECRET
                        + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
                        + "&grant_type=authorization_code";

        URL tokenUrl = new URL("https://oauth2.googleapis.com/token");
        HttpURLConnection conn = (HttpURLConnection) tokenUrl.openConnection();

        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes(StandardCharsets.UTF_8));
        }

        BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));

        StringBuilder tokenResponse = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            tokenResponse.append(line);
        }

        String accessToken = new JSONObject(tokenResponse.toString())
                .getString("access_token");

        // 2️⃣ Lấy user info
        URL userUrl = new URL(
                "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken);

        HttpURLConnection userConn = (HttpURLConnection) userUrl.openConnection();
        userConn.setRequestMethod("GET");

        BufferedReader userReader = new BufferedReader(
                new InputStreamReader(userConn.getInputStream(), StandardCharsets.UTF_8));

        StringBuilder userInfo = new StringBuilder();
        while ((line = userReader.readLine()) != null) {
            userInfo.append(line);
        }

        JSONObject userJson = new JSONObject(userInfo.toString());

        String email = userJson.getString("email");
        String name = userJson.getString("name");

        // 3️⃣ Lưu session
        HttpSession session = request.getSession();
        session.setAttribute("googleEmail", email);
        session.setAttribute("googleName", name);

        // 4️⃣ Redirect về home
        response.sendRedirect(request.getContextPath() + "/fontend/public/homePage.jsp");
    }


}
