package vn.edu.hcmuaf.fit.ltw_nhom5.model;

public class CartItem {
    private Comic comic;
    private int quantity;
    private double priceAtPurchase; // Giá tại thời điểm thêm vào giỏ
    private Integer flashSaleId;    // ID của Flash Sale (nếu có)

    // Constructor cũ (không có Flash Sale)
    public CartItem(Comic comic, int quantity, double priceAtPurchase) {
        this.comic = comic;
        this.quantity = quantity;
        this.priceAtPurchase = priceAtPurchase;
        this.flashSaleId = null;
    }

    // Constructor mới (có Flash Sale)
    public CartItem(Comic comic, int quantity, Integer flashSaleId, Double flashSalePrice) {
        this.comic = comic;
        this.quantity = quantity;
        this.flashSaleId = flashSaleId;
        this.priceAtPurchase = (flashSalePrice != null) ? flashSalePrice : comic.getPrice();
    }

    /**
     * Kiểm tra xem item này có đang trong Flash Sale không
     */
    public boolean isInFlashSale() {
        return flashSaleId != null;
    }

    /**
     * Lấy giá hiện tại (đã bao gồm Flash Sale nếu có)
     */
    public double getCurrentPrice() {
        return priceAtPurchase;
    }

    /**
     * Tổng tiền của item này
     */
    public double getTotalPrice() {
        return priceAtPurchase * quantity;
    }

    /**
     * Cập nhật số lượng
     */
    public void updateQuantity(int additionalQuantity) {
        this.quantity += additionalQuantity;
    }

    /**
     * Xóa thông tin Flash Sale (khi Flash Sale kết thúc)
     * và đặt lại giá về giá gốc
     */
    public void removeFlashSale() {
        if (flashSaleId != null) {
            this.flashSaleId = null;
            this.priceAtPurchase = comic.getPrice(); // Về giá gốc
        }
    }

    // Getters và Setters
    public Comic getComic() {
        return comic;
    }

    public void setComic(Comic comic) {
        this.comic = comic;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPriceAtPurchase() {
        return priceAtPurchase;
    }

    public void setPriceAtPurchase(double priceAtPurchase) {
        this.priceAtPurchase = priceAtPurchase;
    }

    public Integer getFlashSaleId() {
        return flashSaleId;
    }

    public void setFlashSaleId(Integer flashSaleId) {
        this.flashSaleId = flashSaleId;
    }

    public void setFlashSalePrice(Double flashSalePrice) {
        this.priceAtPurchase = flashSalePrice;
    }
}