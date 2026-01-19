package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Cart;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.CartItem;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.ComicService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Cart", value = "/cart")
public class CartSevlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        if (action == null || action.equals("view")) {
            // Hiển thị giỏ hàng
            viewCart(request, response, cart);

        } else if (action.equals("add")) {
            // Thêm sản phẩm
            addToCart(request, response, cart, session);

        } else if (action.equals("update")) {
            // Cập nhật số lượng
            updateCart(request, response, cart, session);

        } else if (action.equals("remove")) {
            // Xóa sản phẩm
            removeFromCart(request, response, cart, session);

        } else if (action.equals("clear")) {
            // Xóa toàn bộ giỏ hàng
            clearCart(request, response, cart, session);

        } else {
            // Action không hợp lệ
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response, Cart cart, HttpSession session) throws ServletException, IOException {
        cart.removeAllItems();
        session.setAttribute("cart", cart);
        session.setAttribute("successMsg", "Đã xóa toàn bộ giỏ hàng");

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Cart cart, HttpSession session) throws ServletException, IOException {
        try {
            int comicId = Integer.parseInt(request.getParameter("comicId"));

            cart.removeItem(comicId);
            session.setAttribute("cart", cart);
            session.setAttribute("successMsg", "Đã xóa sản phẩm khỏi giỏ hàng");

            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response, Cart cart, HttpSession session) throws ServletException, IOException {
        try {
            int comicId = Integer.parseInt(request.getParameter("comicId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                session.setAttribute("errorMsg", "Số lượng phải lớn hơn 0");
                response.sendRedirect(request.getContextPath() + "/cart");
                quantity = 1;
            }

            // ktra ton kho
            ComicService comicService = new ComicService();
            Comic comic = comicService.getComicById(comicId);

            if(comic != null && comic.getStockQuantity() < quantity){
                session.setAttribute("errorMsg", "Sản phẩm không đủ hàng. Chỉ còn " + comic.getStockQuantity() + " sản phẩm.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            boolean success = cart.updateItem(comicId, quantity);

            if (success) {
                session.setAttribute("cart", cart);
                session.setAttribute("successMsg", "Đã cập nhật số lượng");
            } else {
                session.setAttribute("errorMsg", "Không tìm thấy sản phẩm trong giỏ hàng");
            }

            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/cart");
        }

    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response, Cart cart) throws ServletException, IOException {
        // Tắt cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        List<CartItem> cartItems = cart.getItems();
        double totalAmount = cart.total();
        int totalQuantity = cart.totalQuantity();

        // LƯU VÀO SESSION thay vì request
        HttpSession session = request.getSession();
        session.setAttribute("cart", cart);
        session.setAttribute("cartItems", cartItems);

        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("totalQuantity", totalQuantity);

        // Kiểm tra trạng thái đăng nhập để hiển thị giao diện
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        request.setAttribute("isLoggedIn", currentUser != null);

        request.getRequestDispatcher("/fontend/nguoiB/cart.jsp").forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, Cart cart, HttpSession session) throws ServletException, IOException {
        try {
            int comicId = Integer.parseInt(request.getParameter("comicId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // ===== DEBUG =====
            User currentUser = (User) session.getAttribute("currentUser");
            System.out.println("===== THÊM VÀO GIỎ HÀNG =====");
            System.out.println("Comic ID: " + comicId);
            System.out.println("Số lượng: " + quantity);
            System.out.println("Đã đăng nhập: " + (currentUser != null ? currentUser.getUsername() : "CHƯA"));
            System.out.println("Session ID: " + session.getId());
            System.out.println("Giỏ hàng trước khi thêm: " + cart.getItems().size() + " sản phẩm");
            System.out.println("============================");

            if (quantity <= 0) {
                quantity = 1;
            }

            ComicService comicService = new ComicService();
            Comic comic = comicService.getComicById(comicId);

            if (comic != null) {
                // ktra SL trong giỏ hiện tại
                CartItem existingItem = cart.get(comicId);
                int totalQuantity = (existingItem != null) ? existingItem.getQuantity() + quantity : quantity;
                // Kiểm tra tồn kho
                if (comic.getStockQuantity() < totalQuantity) {
                    session.setAttribute("errorMsg", "Sản phẩm không đủ hàng. Chỉ còn " +
                            comic.getStockQuantity() + " sản phẩm.");
                    response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + comicId);
                    return;
                }

                // Thêm vào giỏ
                cart.addItem(comic, quantity);
                session.setAttribute("cart", cart);

                session.setAttribute("successMsg", "Đã thêm \"" + comic.getNameComics() +
                        "\" vào giỏ hàng!");

                // Kiểm tra buyNow
                boolean buyNow = "true".equals(request.getParameter("buyNow"));

                if (buyNow) {
                    // Mua ngay -> chuyển đến giỏ hàng
                    response.sendRedirect(request.getContextPath() + "/cart");
                } else {
                    // Quay về trang chi tiết
                    response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + comicId);
                }
            } else {
                session.setAttribute("errorMsg", "Không tìm thấy sản phẩm");
                response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + comicId);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}