package vn.edu.hcmuaf.fit.ltw_nhom5.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleComicsDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Cart;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.CartItem;

import java.io.IOException;
import java.util.Map;

@WebFilter("/*")
public class CartFlashSaleUpdateFilter implements Filter {

    private FlashSaleComicsDAO flashSaleComicsDAO;
    private FlashSaleDAO flashSaleDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        flashSaleComicsDAO = new FlashSaleComicsDAO();
        flashSaleDAO = new FlashSaleDAO();
        System.out.println("✅ CartFlashSaleUpdateFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        if (session != null) {
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null && !cart.getItems().isEmpty()) {
                updateCartFlashSalePrices(cart);
                session.setAttribute("cart", cart);
            }
        }

        chain.doFilter(request, response);
    }

    private void updateCartFlashSalePrices(Cart cart) {
        flashSaleDAO.updateStatuses();

        for (CartItem item : cart.getItems()) {
            int comicId = item.getComic().getId();

            Map<String, Object> activeFlashSale =
                    flashSaleComicsDAO.getFlashSaleInfoByComicId(comicId);

            if (activeFlashSale != null) {
                // Comic đang trong Flash Sale active
                Integer newFlashSaleId = (Integer) activeFlashSale.get("flashsale_id");
                Object discountObj = activeFlashSale.get("discount_percent");
                Double discountPercent = (discountObj instanceof Number)
                        ? ((Number) discountObj).doubleValue()
                        : null;

                if (discountPercent != null) {
                    Double newFlashSalePrice = item.getComic().getPrice() * (1 - discountPercent / 100.0);

                    // Cập nhật nếu khác với giá hiện tại
                    if (!newFlashSaleId.equals(item.getFlashSaleId()) ||
                            Math.abs(newFlashSalePrice - item.getPriceAtPurchase()) > 0.01) {

                        item.setFlashSaleId(newFlashSaleId);
                        item.setPriceAtPurchase(newFlashSalePrice);

                        System.out.println("🔄 Updated Flash Sale for comic ID " + comicId +
                                ": " + newFlashSalePrice + "₫");
                    }
                }
            } else {
                // Comic KHÔNG còn trong Flash Sale active
                if (item.isInFlashSale()) {
                    item.removeFlashSale();

                    System.out.println("⏰ Flash Sale ended for comic ID " + comicId +
                            ". Price reverted to: " + item.getComic().getPrice() + "₫");
                }
            }
        }
    }

    @Override
    public void destroy() {
        System.out.println("❌ CartFlashSaleUpdateFilter destroyed");
    }
}