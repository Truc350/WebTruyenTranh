package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private UserDao userDAO;
    private UserShippingAddressDAO userShippingAddressDAO;
    private ComicDAO comicDAO;

    @Override
    public void init() throws ServletException {
        Jdbi jdbi = JdbiConnector.get();
        orderDAO = new OrderDAO(jdbi);
        userDAO = new UserDao(jdbi);
        userShippingAddressDAO = new UserShippingAddressDAO(jdbi);
        comicDAO = new ComicDAO(jdbi);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cart");
        request.getRequestDispatcher("fontend/admin/order.jsp").forward(request, response);
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

        try {
            // Lấy thông tin từ form
            String recipientName = request.getParameter("receiverName");
            String shippingPhone = request.getParameter("receiverPhone");
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String streetAddress = request.getParameter("address");
            String shippingMethod = request.getParameter("shipping"); // standard hoặc express
            String paymentMethod = request.getParameter("payment"); // COD hoặc ewallet
            String usePointsStr = request.getParameter("usePoints");

            // Validate thông tin bắt buộc
            if (recipientName == null || recipientName.trim().isEmpty() ||
                    shippingPhone == null || shippingPhone.trim().isEmpty() ||
                    province == null || province.trim().isEmpty() ||
                    ward == null || ward.trim().isEmpty() ||
                    streetAddress == null || streetAddress.trim().isEmpty() ||
                    shippingMethod == null || shippingMethod.trim().isEmpty() ||
                    paymentMethod == null || paymentMethod.trim().isEmpty()) {

                session.setAttribute("orderError", "Vui lòng điền đầy đủ thông tin bắt buộc");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            boolean usePoints = "on".equals(usePointsStr);

            // Lấy thông tin giỏ hàng đã chọn từ session
            @SuppressWarnings("unchecked")
            List<CartItem> selectedItems = (List<CartItem>) session.getAttribute("selectedItems");

            if (selectedItems == null || selectedItems.isEmpty()) {
                session.setAttribute("orderError", "Không có sản phẩm nào được chọn");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // ========== KIỂM TRA TỒN KHO ==========
            for (CartItem item : selectedItems) {
                int comicId = item.getComic().getId();
                int requestedQty = item.getQuantity();

                if (!comicDAO.hasEnoughStock(comicId, requestedQty)) {
                    int availableStock = comicDAO.getStockQuantity(comicId);
                    session.setAttribute("orderError",
                            "Sản phẩm '" + item.getComic().getNameComics() +
                                    "' không đủ hàng. Còn lại: " + availableStock + ", bạn yêu cầu: " + requestedQty);
                    response.sendRedirect(request.getContextPath() + "/checkout");
                    return;
                }
            }

            // Tính toán giá
            double subtotal = (Double) session.getAttribute("checkoutSubtotal");
            double shippingFee = "express".equals(shippingMethod) ? 50000 : 25000;

            // Tính điểm giảm giá (1 điểm = 1.000đ)
            int pointsToUse = 0;
            double pointsDiscount = 0;
            if (usePoints && user.getPoints() > 0) {
                pointsToUse = user.getPoints();
                pointsDiscount = pointsToUse * 1000.0;
            }

            // Tổng tiền sau khi trừ điểm
            double totalAmount = subtotal + shippingFee - pointsDiscount;

            // Đảm bảo tổng tiền không âm
            if (totalAmount < 0) {
                totalAmount = 0;
            }

            // ========== TẠO ĐỊA CHỈ GIAO HÀNG ==========
            UserShippingAddress shippingAddress = new UserShippingAddress();
            shippingAddress.setUserId(user.getId());
            shippingAddress.setRecipientName(recipientName.trim());
            shippingAddress.setPhone(shippingPhone.trim());
            shippingAddress.setProvince(province.trim());
            shippingAddress.setDistrict(district != null ? district.trim() : "");
            shippingAddress.setWard(ward.trim());
            shippingAddress.setStreetAddress(streetAddress.trim());
            shippingAddress.setCreatedAt(LocalDate.now());
            shippingAddress.setUpdatedAt(LocalDate.now());

            // Nếu đây là địa chỉ đầu tiên của user, đặt làm mặc định
            int addressCount = userShippingAddressDAO.countAddressesByUserId(user.getId());
            shippingAddress.setDefault(addressCount == 0);

            // Kiểm tra địa chỉ đã tồn tại chưa
            Optional<UserShippingAddress> existingAddress =
                    userShippingAddressDAO.findExistingAddress(shippingAddress);

            int shippingAddressId;
            if (existingAddress.isPresent()) {
                // Sử dụng địa chỉ đã có
                shippingAddressId = existingAddress.get().getId();
            } else {
                // Tạo địa chỉ mới
                shippingAddressId = userShippingAddressDAO.createShippingAddress(shippingAddress);

                if (shippingAddressId <= 0) {
                    session.setAttribute("orderError", "Không thể lưu địa chỉ giao hàng");
                    response.sendRedirect(request.getContextPath() + "/checkout");
                    return;
                }
            }

            // Tạo đối tượng Order
            Order order = new Order();
            order.setUserId(user.getId());
            order.setOrderDate(LocalDateTime.now());
            order.setStatus("Pending"); // Trạng thái: Đang chờ xử lý
            order.setTotalAmount(totalAmount);
            order.setShippingAddressId(shippingAddressId); // Nếu không dùng shipping_address_id thì set 0
            order.setRecipientName(recipientName.trim());
            order.setShippingPhone(shippingPhone.trim());

            // Địa chỉ đầy đủ để hiển thị
            // Địa chỉ đầy đủ
            String fullAddress = streetAddress.trim() + ", " + ward.trim();
            if (district != null && !district.trim().isEmpty()) {
                fullAddress += ", " + district.trim();
            }
            fullAddress += ", " + province.trim();
            order.setShippingAddress(fullAddress);

            order.setShippingProvider(shippingMethod); // standard hoặc express
            order.setShippingFee(shippingFee);
            order.setPointUsed(pointsToUse);
            order.setCreatedAt(LocalDateTime.now());

            // Tạo danh sách OrderItem
            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem item : selectedItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setComicId(item.getComic().getId());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setPriceAtPurchase(item.getFinalPrice());
                orderItems.add(orderItem);
            }

            // Lưu đơn hàng vào database
            int orderId = orderDAO.createOrderWithPayment(order, orderItems, paymentMethod);

            if (orderId > 0) {
                // ✅ NẾU LÀ E-WALLET, CẬP NHẬT TRANSACTION ID VÀ PAYMENT STATUS
                if ("ewallet".equals(paymentMethod)) {
                    PaymentDAO paymentDAO = new PaymentDAO(JdbiConnector.get());

                    // Tạo transaction ID ngẫu nhiên
                    String transactionId = generateTransactionId();

                    // Lấy payment vừa tạo
                    Optional<Payment> paymentOpt = paymentDAO.getPaymentByOrderId(orderId);
                    if (paymentOpt.isPresent()) {
                        Payment payment = paymentOpt.get();

                        // Cập nhật transaction ID và status thành Completed
                        paymentDAO.updatePaymentStatus(
                                payment.getId(),
                                "Completed",  // Trạng thái: Đã thanh toán
                                transactionId
                        );

                        System.out.println("✅ E-wallet payment completed. Transaction ID: " + transactionId);
                    }
                }
                // Xóa các sản phẩm đã đặt khỏi giỏ hàng
                Cart cart = (Cart) session.getAttribute("cart");
                @SuppressWarnings("unchecked")
                List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");

                if (cart != null && cartItems != null) {
                    // Lấy danh sách comic IDs đã mua để so sánh
                    List<Integer> purchasedComicIds = new ArrayList<>();
                    for (CartItem item : selectedItems) {
                        purchasedComicIds.add(item.getComic().getId());
                    }

                    // XÓA TỪ CART OBJECT (quan trọng!)
                    for (Integer comicId : purchasedComicIds) {
                        cart.removeItem(comicId);
                    }

                    cartItems.removeIf(item -> purchasedComicIds.contains(item.getComic().getId()));

                    session.setAttribute("cart", cart);
                    session.setAttribute("cartItems", cartItems);
                    session.setAttribute("clearCartLocalStorage", Boolean.TRUE);
                }
                // Nếu sử dụng điểm, trừ điểm của user
                if (usePoints && pointsToUse > 0) {
                    int newPoints = user.getPoints() - pointsToUse;
                    if (newPoints < 0) newPoints = 0;

                    // Cập nhật điểm trong database
                    userDAO.updateUserPoints(user.getId(), newPoints);

                    // Cập nhật điểm trong session
                    user.setPoints(newPoints);
                    session.setAttribute("currentUser", user);

                    // Tạo transaction bằng setter thay vì constructor
                    PointTransactionDAO pointTransactionDAO = new PointTransactionDAO(JdbiConnector.get());
                    PointTransaction transaction = new PointTransaction();
                    transaction.setUserId(user.getId());
                    transaction.setOrderId(orderId);
                    transaction.setPoints(pointsToUse);
                    transaction.setTransactionType("SPEND");
                    transaction.setDescription("Sử dụng " + pointsToUse + " xu cho đơn hàng #" + orderId);
                    transaction.setCreatedAt(java.time.LocalDateTime.now());

                    pointTransactionDAO.createTransaction(transaction);
                }

                // Xóa thông tin checkout khỏi session
                session.removeAttribute("selectedItems");
                session.removeAttribute("checkoutSubtotal");
                session.removeAttribute("shippingFee");
                session.removeAttribute("checkoutTotal");

                // Lưu thông tin đơn hàng để hiển thị trang success
                session.setAttribute("orderId", orderId);
                session.setAttribute("orderTotal", totalAmount);
                session.setAttribute("orderPaymentMethod", paymentMethod);
                session.setAttribute("orderSuccess", "Đặt hàng thành công!");

                // Chuyển đến trang thành công
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                session.setAttribute("orderError", "Đặt hàng thất bại. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/checkout");
            }

        } catch (RuntimeException e) {
            // Lỗi từ transaction (ví dụ: không đủ hàng)
            e.printStackTrace();
            session.setAttribute("orderError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("orderError", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }

    /**
     * Tạo transaction ID ngẫu nhiên cho thanh toán online
     * Format: TXN + timestamp + random
     * Ví dụ: TXN1737446789ABC123
     */
    private String generateTransactionId() {
        String prefix = "TXN";
        long timestamp = System.currentTimeMillis() / 1000; // Unix timestamp

        // Tạo 6 ký tự ngẫu nhiên (A-Z, 0-9)
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder randomPart = new StringBuilder();
        java.util.Random random = new java.util.Random();

        for (int i = 0; i < 6; i++) {
            randomPart.append(characters.charAt(random.nextInt(characters.length())));
        }
        return prefix + timestamp + randomPart.toString();
    }
}
