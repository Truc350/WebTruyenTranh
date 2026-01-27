package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleComicsDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Cart;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.CartItem;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.ComicService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

    private void viewCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        // Tắt cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // ===== KIỂM TRA VÀ CẬP NHẬT GIÁ FLASH SALE =====
        FlashSaleComicsDAO flashSaleComicsDAO = new FlashSaleComicsDAO();
        HttpSession session = request.getSession();
        boolean hasUpdates = false;

        for (CartItem item : cart.getItems()) {
            int comicId = item.getComic().getId();

            System.out.println("🔍 Checking comic " + comicId);
            System.out.println("   Current price in cart: " + item.getPriceAtPurchase() + "₫");
            System.out.println("   Comic original price: " + item.getComic().getPrice() + "₫");
            System.out.println("   Comic discount price: " + item.getComic().getDiscountPrice() + "₫");

            // Kiểm tra xem comic còn trong Flash Sale không
            Map<String, Object> flashSaleInfo = flashSaleComicsDAO.getFlashSaleInfoByComicId(comicId);

            if (flashSaleInfo != null) {
                // ✅ Còn trong Flash Sale
                Integer currentFlashSaleId = (Integer) flashSaleInfo.get("flashsale_id");
                Object discountObj = flashSaleInfo.get("discount_percent");
                Double discountPercent = (discountObj instanceof Number)
                        ? ((Number) discountObj).doubleValue()
                        : null;

                if (discountPercent != null) {
                    // Tính giá Flash Sale từ GIÁ GỐC
                    double originalPrice = item.getComic().getPrice();
                    double newFlashSalePrice = originalPrice * (1 - discountPercent / 100.0);

                    System.out.println("   ⚡ Flash Sale active: " + discountPercent + "% off");
                    System.out.println("   Flash Sale price should be: " + newFlashSalePrice + "₫");

                    // Cập nhật nếu giá Flash Sale thay đổi hoặc chưa có
                    if (item.getFlashSalePrice() == null ||
                            !currentFlashSaleId.equals(item.getFlashSaleId()) ||
                            Math.abs(item.getFlashSalePrice() - newFlashSalePrice) > 0.01) {

                        item.updateFlashSale(currentFlashSaleId, newFlashSalePrice);
                        hasUpdates = true;

                        System.out.println("   ✅ Updated to Flash Sale price: " + newFlashSalePrice + "₫");
                    }
                }
            } else {
                // ⏰ Hết Flash Sale hoặc không có Flash Sale
                if (item.getFlashSaleId() != null) {
                    // Đang có Flash Sale nhưng đã hết
                    double discountPrice = item.getComic().getDiscountPrice();

                    System.out.println("   ⏰ Flash Sale ended");
                    System.out.println("   Reverting to discount price: " + discountPrice + "₫");

                    item.removeFlashSale(); // Sẽ set về comic.getDiscountPrice()
                    hasUpdates = true;
                } else {
                    // Không có Flash Sale từ đầu, kiểm tra giá discount có thay đổi không
                    double currentDiscountPrice = item.getComic().getDiscountPrice();

                    if (Math.abs(item.getPriceAtPurchase() - currentDiscountPrice) > 0.01) {
                        System.out.println("   🔄 Discount price changed");
                        System.out.println("   Old: " + item.getPriceAtPurchase() + "₫");
                        System.out.println("   New: " + currentDiscountPrice + "₫");

                        item.setPriceAtPurchase(currentDiscountPrice);
                        hasUpdates = true;
                    }
                }
            }
        }

        // Lưu lại giỏ hàng nếu có thay đổi
        if (hasUpdates) {
            session.setAttribute("cart", cart);
            System.out.println("✅ Cart updated with latest prices");
        }

        List<CartItem> cartItems = cart.getItems();
        double totalAmount = cart.total();
        int totalQuantity = cart.totalQuantity();

        session.setAttribute("cart", cart);
        session.setAttribute("cartItems", cartItems);

        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("totalQuantity", totalQuantity);

        // Kiểm tra trạng thái đăng nhập
        User currentUser = (User) session.getAttribute("currentUser");
        request.setAttribute("isLoggedIn", currentUser != null);

        request.getRequestDispatcher("/fontend/nguoiB/cart.jsp").forward(request, response);
    }
    private void addToCart(HttpServletRequest request, HttpServletResponse response, Cart cart, HttpSession session) throws ServletException, IOException {
        try {
            int comicId = Integer.parseInt(request.getParameter("comicId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            boolean isAjax = "true".equals(request.getParameter("ajax"));
            String returnUrl = request.getParameter("returnUrl");

            System.out.println("===== THÊM VÀO GIỎ HÀNG =====");
            System.out.println("Comic ID: " + comicId);
            System.out.println("Số lượng: " + quantity);

            if (quantity <= 0) {
                quantity = 1;
            }

            ComicService comicService = new ComicService();
            Comic comic = comicService.getComicById(comicId);

            if (comic != null) {
                // Kiểm tra SL trong giỏ hiện tại
                CartItem existingItem = cart.get(comicId);
                int totalQuantity = (existingItem != null) ? existingItem.getQuantity() + quantity : quantity;

                // Kiểm tra tồn kho
                if (comic.getStockQuantity() < totalQuantity) {
                    session.setAttribute("errorMsg", "Sản phẩm không đủ hàng. Chỉ còn " +
                            comic.getStockQuantity() + " sản phẩm.");

                    if (isAjax) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"success\": false, \"message\": \"Sản phẩm không đủ hàng\"}");
                        return;
                    }

                    response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + comicId);
                    return;
                }

                // ===== KIỂM TRA FLASH SALE =====
                FlashSaleComicsDAO flashSaleComicsDAO = new FlashSaleComicsDAO();
                Map<String, Object> flashSaleInfo = flashSaleComicsDAO.getFlashSaleInfoByComicId(comicId);

                Integer flashSaleId = null;
                Double flashSalePrice = null;

                if (flashSaleInfo != null) {
                    flashSaleId = (Integer) flashSaleInfo.get("flashsale_id");
                    Object discountObj = flashSaleInfo.get("discount_percent");
                    Double discountPercent = (discountObj instanceof Number)
                            ? ((Number) discountObj).doubleValue()
                            : null;

                    // Tính giá Flash Sale từ GIÁ GỐC
                    if (discountPercent != null) {
                        flashSalePrice = comic.getPrice() * (1 - discountPercent / 100.0);
                    }

                    System.out.println("✅ Comic trong Flash Sale!");
                    System.out.println("Flash Sale ID: " + flashSaleId);
                    System.out.println("Giá gốc: " + comic.getPrice() + "₫");
                    System.out.println("Giảm giá Flash Sale: " + discountPercent + "%");
                    System.out.println("Giá Flash Sale: " + flashSalePrice + "₫");
                } else {
                    // ✅ KHÔNG CÓ FLASH SALE → Dùng giá đã discount (nếu có)
                    System.out.println("ℹ️ Comic không trong Flash Sale");
                    System.out.println("Giá gốc: " + comic.getPrice() + "₫");
                    System.out.println("Giá sau discount: " + comic.getDiscountPrice() + "₫");
                }

                // ✅ Thêm vào giỏ với thông tin Flash Sale (nếu có)
                // Nếu không có Flash Sale, CartItem constructor sẽ dùng comic.getDiscountPrice()
                cart.addItem(comic, quantity, flashSaleId, flashSalePrice);
                session.setAttribute("cart", cart);

                String successMsg = "Đã thêm \"" + comic.getNameComics() + "\" vào giỏ hàng!";
                if (flashSalePrice != null) {
                    successMsg += " (Giá Flash Sale: " + String.format("%,.0f", flashSalePrice) + "₫)";
                } else if (comic.getDiscountPrice() < comic.getPrice()) {
                    successMsg += " (Giá ưu đãi: " + String.format("%,.0f", comic.getDiscountPrice()) + "₫)";
                }

                session.setAttribute("successMsg", successMsg);

                // Nếu là AJAX request
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"message\": \"" + successMsg + "\"}");
                    return;
                }

                boolean buyNow = "true".equals(request.getParameter("buyNow"));

                if (buyNow) {
                    User currentUser = (User) session.getAttribute("currentUser");

                    if (currentUser == null) {
                        session.setAttribute("errorMsg", "Vui lòng đăng nhập để mua hàng");
                        response.sendRedirect(request.getContextPath() + "/login");
                        return;
                    }

                    // ✅ TẠO selectedItems CHỈ CHỨA SẢN PHẨM VỪA THÊM
                    CartItem addedItem = cart.get(comicId);
                    if (addedItem != null) {
                        List<CartItem> selectedItems = new ArrayList<>();
                        selectedItems.add(addedItem);

                        // Tính toán cho checkout
                        double subtotal = addedItem.getFinalPrice() * addedItem.getQuantity();
                        double shippingFee = 25000;
                        double totalAmount = subtotal + shippingFee;

                        // Set vào session
                        session.setAttribute("selectedItems", selectedItems);
                        session.setAttribute("checkoutSubtotal", subtotal);
                        session.setAttribute("shippingFee", shippingFee);
                        session.setAttribute("checkoutTotal", totalAmount);

                        // Redirect đến checkout
                        response.sendRedirect(request.getContextPath() + "/checkout");
                    }
                }



                else {
                    if ("wishlist".equals(returnUrl)) {
                        response.sendRedirect(request.getContextPath() + "/wishlist");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + comicId);
                    }
                }
            } else {
                session.setAttribute("errorMsg", "Không tìm thấy sản phẩm");

                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy sản phẩm\"}");
                    return;
                }

                if ("wishlist".equals(returnUrl)) {
                    response.sendRedirect(request.getContextPath() + "/wishlist");
                } else {
                    response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + comicId);
                }
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