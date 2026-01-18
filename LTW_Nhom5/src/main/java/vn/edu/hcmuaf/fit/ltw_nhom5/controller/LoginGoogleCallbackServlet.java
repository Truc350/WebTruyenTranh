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
    private static final String REDIRECT_URI = "http://localhost:8080/LTW_Nhom5/login-google-callback";

    static {
        if (CLIENT_ID == null || CLIENT_SECRET == null) {
            throw new RuntimeException("Missing GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET environment variables");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        String error = request.getParameter("error");

        // Xử lý khi user từ chối cấp quyền
        if (error != null) {
            request.setAttribute("error", "Bạn đã từ chối đăng nhập bằng Google.");
            request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
            return;
        }

        // Kiểm tra code
        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("error", "Đăng nhập Google thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
            return;
        }

        try {
            // 1️⃣ Đổi code → access_token
            String accessToken = exchangeCodeForToken(code);

            // 2️⃣ Lấy user info
            JSONObject userInfo = getUserInfo(accessToken);

            String email = userInfo.getString("email");
            String name = userInfo.getString("name");
            String picture = userInfo.optString("picture", "");
            String googleId = userInfo.getString("id");

            // TODO: Kiểm tra user có tồn tại trong database chưa
            // Nếu chưa có thì tạo mới, nếu có rồi thì lấy thông tin
            // User user = userDAO.findOrCreateGoogleUser(googleId, email, name, picture);

            // 3️⃣ Lưu session
            HttpSession session = request.getSession();
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", name);
            session.setAttribute("userPicture", picture);
            session.setAttribute("googleId", googleId);
            session.setAttribute("loginMethod", "google");
            session.setMaxInactiveInterval(30 * 60); // 30 phút

            // 4️⃣ Redirect về trang chủ
            response.sendRedirect(request.getContextPath() + "/fontend/public/homePage.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi đăng nhập bằng Google. Vui lòng thử lại.");
            request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
        }
    }

    /**
     * Đổi authorization code thành access token
     */
    private String exchangeCodeForToken(String code) throws IOException {
        String params = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
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
        br.close();

        JSONObject tokenJson = new JSONObject(tokenResponse.toString());
        return tokenJson.getString("access_token");
    }

    /**
     * Lấy thông tin user từ Google
     */
    private JSONObject getUserInfo(String accessToken) throws IOException {
        URL userUrl = new URL(
                "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken);

        HttpURLConnection userConn = (HttpURLConnection) userUrl.openConnection();
        userConn.setRequestMethod("GET");

        BufferedReader userReader = new BufferedReader(
                new InputStreamReader(userConn.getInputStream(), StandardCharsets.UTF_8));

        StringBuilder userInfo = new StringBuilder();
        String line;
        while ((line = userReader.readLine()) != null) {
            userInfo.append(line);
        }
        userReader.close();

        return new JSONObject(userInfo.toString());
    }
}