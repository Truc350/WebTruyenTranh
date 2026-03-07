package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONObject;
import vn.edu.hcmuaf.fit.ltw_nhom5.config.FacebookConfig;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Optional;

/*
fontend → Facebook → Servlet → Graph API → Session
 */

@WebServlet("/login-facebook-callback")
public class LoginFacebookCallbackServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String code = request.getParameter("code");
        if (code == null){
            response.sendRedirect(request.getContextPath()+ "/login?error=Bạn đã hủy đăng nhập Facebook");
            return;
        }
        try {
            String accessToken = getAccessToken(code);

            JSONObject fbUser = getFacebookUserInfo(accessToken);
            String fbId = fbUser.getString("id");
            String fbName = fbUser.getString("name");
            String fbEmail = fbUser.optString("email", "");
            UserDao userDao = UserDao.getInstance();
            User user = findOrCreateUser(userDao, fbId,fbName, fbEmail);
            if (user.getIsActive() == false || !user.getIsActive()){
                response.sendRedirect(request.getContextPath()
                        + "/login?error=Tài khoản của bạn đã bị khóa");
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("user",   user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("role",   user.getRole());
            if ("admin".equalsIgnoreCase(user.getRole())){
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }else {
                response.sendRedirect(request.getContextPath() + "/fontend/public/homePage.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/login?error=Đăng nhập Facebook thất bại, vui lòng thử lại");
        }

    }

    private JSONObject getFacebookUserInfo(String accessToken) throws Exception {
        String url = "https://graph.facebook.com/me"
                + "?fields=id,name,email"
                + "&access_token=" + accessToken;
        return new JSONObject(httpGet(url));
    }

    private User findOrCreateUser(UserDao userDao, String fbId, String fbName, String fbEmail) {
        if (!fbEmail.isEmpty()) {
            Optional<User> existing = userDao.findByEmail(fbEmail);
            if (existing.isPresent()) {
                return existing.get(); // Tài khoản đã tồn tại thif đăng nhập luôn
            }
        }

        Optional<User> byUserName = userDao.findByUsername("fb_" + fbId);
        if (byUserName.isPresent()) {
            return byUserName.get();
        }
//        chua co tai khoan thi tao
        User newUser = new User();
        newUser.setUsername("fb_" + fbId);
        newUser.setEmail(fbEmail.isEmpty() ? fbId + "@facebook.com" : fbEmail);
        newUser.setFullName(fbName);
        newUser.setPasswordHash("");
        userDao.insert(newUser);
        return userDao.findByUsername("fb_" + fbId)
                .orElseThrow(() -> new RuntimeException("Lỗi tạo tài khoản Facebook"));
    }

    private String  getAccessToken(String accessToken) throws Exception  {
        String url = "https://graph.facebook.com/v19.0/oauth/access_token"
                + "?client_id="     + FacebookConfig.getAppId()
                + "&redirect_uri="  + URLEncoder.encode(FacebookConfig.getRedirectUri(), "UTF-8")
                + "&client_secret=" + FacebookConfig.getAppSecret()
                + "&code="          + accessToken;

        JSONObject json = new JSONObject(httpGet(url));
        return json.getString("access_token");
    }

    private String httpGet(String urlStr) throws Exception  {
        HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            return sb.toString();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
