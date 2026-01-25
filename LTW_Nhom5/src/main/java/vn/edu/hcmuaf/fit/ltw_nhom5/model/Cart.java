package vn.edu.hcmuaf.fit.ltw_nhom5.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public class Cart {
    Map<Integer, CartItem> data;
    private User user;

    public Cart() {
        data = new HashMap<>();
    }

    /**
     * Add item không có flash sale
     */
    public void addItem(Comic comic, int quantity) {
        addItem(comic, quantity, null, null);
    }

    /**
     * Add item CÓ flash sale (method chính)
     */
    public void addItem(Comic comic, int quantity, Integer flashSaleId, Double flashSalePrice) {
        if(quantity <= 0) quantity = 1;

        CartItem existingItem = get(comic.getId());

        if(existingItem != null) {
            // Đã có trong giỏ, cập nhật số lượng
            existingItem.updateQuantity(quantity);

            // Cập nhật Flash Sale info nếu có
            if (flashSaleId != null && flashSalePrice != null) {
                existingItem.setFlashSaleId(flashSaleId);
                existingItem.setPriceAtPurchase(flashSalePrice);
            }
        } else {
            // Chưa có, thêm mới
            CartItem newItem = new CartItem(comic, quantity, flashSaleId, flashSalePrice);
            data.put(comic.getId(), newItem);
        }
    }

    public boolean updateItem(int comicId, int quantity) {
        if(get(comicId) == null) return false;
        if(quantity <= 0) quantity = 1;
        data.get(comicId).setQuantity(quantity);
        return true;
    }

    public CartItem removeItem(int comicId) {
        if(get(comicId) == null) return null;
        return data.remove(comicId);
    }

    public List<CartItem> removeAllItems() {
        ArrayList<CartItem> cartItems = new ArrayList<>(data.values());
        data.clear();
        return cartItems;
    }

    public List<CartItem> getItems() {
        return new ArrayList<>(data.values());
    }

    public CartItem get(int id) {
        return data.get(id);
    }

    public int totalQuantity() {
        AtomicInteger total = new AtomicInteger();
        getItems().forEach(item -> {
            total.addAndGet(item.getQuantity());
        });
        return total.get();
    }

    public double total() {
        AtomicReference<Double> total = new AtomicReference<>(0.0);
        getItems().forEach(item -> {
            total.updateAndGet(v -> v + item.getTotalPrice());
        });
        return total.get();
    }

    /**
     * Xóa Flash Sale info khỏi một item cụ thể
     */
    public void removeFlashSaleFromItem(int comicId) {
        CartItem item = get(comicId);
        if (item != null) {
            item.removeFlashSale();
        }
    }

    /**
     * Xóa tất cả Flash Sale info khỏi giỏ hàng
     */
    public void clearAllFlashSales() {
        for (CartItem item : getItems()) {
            item.removeFlashSale();
        }
    }

    public void updateCustomerInfo(User user) {
        this.user = user;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}