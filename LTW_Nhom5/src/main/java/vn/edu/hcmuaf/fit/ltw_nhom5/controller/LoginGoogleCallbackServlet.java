package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Cart;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

@WebServlet(urlPatterns = "/login-google-callback", name = "LoginGoogleCallbackServlet")
public class LoginGoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");
    private static final String REDIRECT_URI = "http://localhost:8080/LTW_Nhom5/login-google-callback";

    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDao(JdbiConnector.get());

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

            // 2️⃣ Lấy user info từ Google
            JSONObject userInfo = getUserInfo(accessToken);

            String email = userInfo.getString("email");
            String name = userInfo.getString("name");
            String picture = userInfo.optString("picture", "");
            String googleId = userInfo.getString("id");

            // 3️⃣ Kiểm tra/Tạo user trong database
            Optional<User> userOpt = userDao.findByEmail(email);
            User user;

            if (userOpt.isPresent()) {
                // User đã tồn tại - cập nhật thông tin Google nếu cần
                user = userOpt.get();
                // TODO: Có thể cập nhật googleId, picture vào DB nếu cần
            } else {
                // User chưa tồn tại - tạo mới
                user = new User();
                user.setEmail(email);
                user.setUsername(name);
                user.setFullName(name);
                user.setRole("USER"); // Mặc định là USER
                // TODO: Lưu user mới vào database
                // userDao.createGoogleUser(user, googleId, picture);

                // Tạm thời set ID (trong thực tế phải lấy từ DB sau khi insert)
                user.setId(0); // Placeholder - cần thay bằng ID thực từ DB
            }

            // 4️⃣ XÓA SESSION CŨ (giống LoginServlet)
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                Cart oldCart = (Cart) oldSession.getAttribute("cart");
                System.out.println("===== SESSION CŨ (GOOGLE LOGIN) =====");
                System.out.println("Session ID cũ: " + oldSession.getId());
                if (oldCart != null) {
                    System.out.println("Giỏ hàng cũ có: " + oldCart.getItems().size() + " sản phẩm");
                }
                System.out.println("=> ĐANG XÓA SESSION CŨ...");
                oldSession.invalidate();
                System.out.println("=> ĐÃ XÓA SESSION CŨ!");
            }

            // 5️⃣ TẠO SESSION MỚI
            HttpSession newSession = request.getSession(true);
            System.out.println("===== SESSION MỚI (GOOGLE LOGIN) =====");
            System.out.println("Session ID mới: " + newSession.getId());

            // 6️⃣ KIỂM TRA ADMIN
            boolean isAdmin = "ADMIN".equalsIgnoreCase(user.getRole());

            if (isAdmin) {
                newSession.setAttribute("currentUser", user);
                newSession.setAttribute("userId", user.getId());
                newSession.setAttribute("isAdmin", true);
                newSession.setAttribute("loginMethod", "google");

                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                response.sendRedirect(request.getContextPath() + "/fontend/admin/dashboard.jsp");
                return;
            }

            // 7️⃣ USER THƯỜNG - Tạo giỏ hàng mới
            Cart newCart = new Cart();
            System.out.println("Giỏ hàng mới có: " + newCart.getItems().size() + " sản phẩm");

            // Lưu vào session
            newSession.setAttribute("cart", newCart);
            newSession.setAttribute("currentUser", user);
            newSession.setAttribute("clearCartLocalStorage", true);
            newSession.setAttribute("loginMethod", "google");

            // Lưu thêm thông tin Google (tuỳ chọn)
            newSession.setAttribute("userPicture", picture);
            newSession.setAttribute("googleId", googleId);

            newSession.setMaxInactiveInterval(30 * 60); // 30 phút

            System.out.println("======================");

            // 8️⃣ Tắt cache
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            // 9️⃣ Kiểm tra redirect URL (từ checkout)
            String redirectUrl = (String) newSession.getAttribute("redirectAfterLogin");

            if (redirectUrl != null) {
                newSession.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }

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