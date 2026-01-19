package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.CartItem;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Chuyển đến trang checkout
        request.getRequestDispatcher("/fontend/nguoiB/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách comic ID đã được chọn từ form
        String[] selectedComicIds = request.getParameterValues("selectedComics");

        if (selectedComicIds == null || selectedComicIds.length == 0) {
            session.setAttribute("checkoutError", "Vui lòng chọn ít nhất một sản phẩm để thanh toán");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Lấy giỏ hàng từ session
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");

        if (cartItems == null || cartItems.isEmpty()) {
            System.out.println("Cart is empty!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Lọc ra các sản phẩm đã được chọn
        List<CartItem> selectedItems = new ArrayList<>();
        double subtotal = 0;

        for (String comicId : selectedComicIds) {
            int id = Integer.parseInt(comicId);

            for (CartItem item : cartItems) {
                if (item.getComic().getId() == id) {
                    selectedItems.add(item);
                    subtotal += item.getComic().getDiscountPrice() * item.getQuantity();
                    break;
                }
            }
        }

        // Tính phí vận chuyển mặc định (Tiêu chuẩn)
        double shippingFee = 25000;

        // Tổng tiền (chưa trừ điểm)
        double totalAmount = subtotal + shippingFee;

        // Lưu thông tin vào session để hiển thị trên trang checkout
        session.setAttribute("selectedItems", selectedItems);
        session.setAttribute("checkoutSubtotal", subtotal);
        session.setAttribute("shippingFee", shippingFee);
        session.setAttribute("checkoutTotal", totalAmount);


        // Dùng forward thay vì sendRedirect để giữ lại dữ liệu
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}