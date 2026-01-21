package vn.edu.hcmuaf.fit.ltw_nhom5.controller.pubilc;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.UserDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Cart;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.utils.PasswordUtils;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDao(JdbiConnector.get());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");

        // Kiểm tra format mật khẩu trước
        if (!PasswordUtils.isValidPasswordFormat(password)) {
            request.setAttribute("error", "Mật khẩu ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
            return;
        }

        Optional<User> userOpt = userDao.findByUsernameOrEmail(usernameOrEmail);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (PasswordUtils.verifyPassword(password, user.getPasswordHash())) {

                // ===== BƯỚC 1: LẤY SESSION CŨ VÀ IN DEBUG =====
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    Cart oldCart = (Cart) oldSession.getAttribute("cart");
                    System.out.println("===== SESSION CŨ =====");
                    System.out.println("Session ID cũ: " + oldSession.getId());
                    if (oldCart != null) {
                        System.out.println("Giỏ hàng cũ có: " + oldCart.getItems().size() + " sản phẩm");
                        oldCart.getItems().forEach(item -> {
                            System.out.println("  - " + item.getComic().getNameComics());
                        });
                    }
                    // XÓA HẲN SESSION CŨ
                    System.out.println("=> ĐANG XÓA SESSION CŨ...");
                    oldSession.invalidate();
                    System.out.println("=> ĐÃ XÓA SESSION CŨ!");
                }

                // ===== BƯỚC 2: TẠO SESSION MỚI HOÀN TOÀN =====
                HttpSession newSession = request.getSession(true); // true = tạo mới nếu chưa có
                System.out.println("===== SESSION MỚI =====");
                System.out.println("Session ID mới: " + newSession.getId());


//                check admin
                // ===== KIỂM TRA ADMIN (CÁCH TỐT HƠN) =====
                boolean isAdmin = "ADMIN".equalsIgnoreCase(user.getRole());

                if (isAdmin) {
                    newSession.setAttribute("currentUser", user);
                    newSession.setAttribute("isAdmin", true);

                    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                    response.setHeader("Pragma", "no-cache");
                    response.setDateHeader("Expires", 0);

                    response.sendRedirect(request.getContextPath() + "/fontend/admin/dashboard.jsp");
                    return;
                }

                // ===== USER THƯỜNG =====
                // Tạo giỏ hàng MỚI (TRỐNG)
                Cart newCart = new Cart();
                System.out.println("Giỏ hàng mới có: " + newCart.getItems().size() + " sản phẩm");

//                Lưu vào session mới
                newSession.setAttribute("cart", newCart);
                newSession.setAttribute("currentUser", user);
                newSession.setAttribute("clearCartLocalStorage", true);
                System.out.println("======================");


//                request.getSession().setAttribute("currentUser", user);
//                response.sendRedirect(request.getContextPath() + "/home");

                // Tắt cache để buộc browser load lại trang mới
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                // Kiểm tra có redirect URL không (từ checkout)
                String redirectUrl = (String) request.getSession().getAttribute("redirectAfterLogin");

                if (redirectUrl != null) {
                    request.getSession().removeAttribute("redirectAfterLogin");
                    response.sendRedirect(redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                request.setAttribute("error", "Hãy nhập đúng tài khoản và mật khẩu!");
                request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Hãy nhập đúng tài khoản và mật khẩu!");
            request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã login rồi thì redirect về home
        if (request.getSession().getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Chưa login thì hiển thị form
        request.getRequestDispatcher("/fontend/public/login.jsp").forward(request, response);
    }


}
