package vn.edu.hcmuaf.fit.ltw_nhom5.model;

public class CartItem {
    private Comic comic;
    private int quantity;
    private Double priceAtPurchase; // Giá tại thời điểm thêm vào giỏ
    private Integer flashSaleId;    // ID của Flash Sale (nếu có)
    private Double flashSalePrice;  // Giá Flash Sale (nếu có)

    // Constructor cũ (không có Flash Sale)
    public CartItem(Comic comic, int quantity, Double priceAtPurchase) {
        this.comic = comic;
        this.quantity = quantity;
        this.priceAtPurchase = priceAtPurchase;
        this.flashSaleId = null;
        this.flashSalePrice = null;
    }

    // Constructor mới (có Flash Sale)
    public CartItem(Comic comic, int quantity, Integer flashSaleId, Double flashSalePrice) {
        this.comic = comic;
        this.quantity = quantity;
        this.flashSaleId = flashSaleId;
        this.flashSalePrice = flashSalePrice;

        // ✅ ƯU TIÊN: Flash Sale > Discount thường > Giá gốc
        if (flashSalePrice != null) {
            this.priceAtPurchase = flashSalePrice;
        } else {
            // Lấy giá đã giảm (nếu có) thay vì giá gốc
            this.priceAtPurchase = comic.getDiscountPrice();
        }
    }

    /**
     * Kiểm tra xem item này có đang trong Flash Sale không
     */
    public boolean isInFlashSale() {
        return flashSaleId != null && flashSalePrice != null;
    }

    /**
     * Lấy giá hiện tại (ưu tiên Flash Sale > Discount > Giá gốc)
     */
    public double getCurrentPrice() {
        if (flashSalePrice != null) {
            return flashSalePrice;
        }
        return priceAtPurchase;
    }

    /**
     * Lấy giá cuối cùng (tương tự getCurrentPrice nhưng rõ ràng hơn)
     */
    public double getFinalPrice() {
        if (flashSalePrice != null) {
            return flashSalePrice;
        }
        if (priceAtPurchase != null) {
            return priceAtPurchase;
        }
        // Fallback về giá có discount của comic
        return comic.getDiscountPrice();
    }

    /**
     * Tổng tiền của item này
     */
    public double getTotalPrice() {
        return getFinalPrice() * quantity;
    }

    /**
     * Tổng tiền (alias cho getTotalPrice)
     */
    public double getSubtotal() {
        return getTotalPrice();
    }

    /**
     * Cập nhật số lượng
     */
    public void updateQuantity(int additionalQuantity) {
        this.quantity += additionalQuantity;
    }

    /**
     * Xóa thông tin Flash Sale (khi Flash Sale kết thúc)
     * và đặt lại giá về giá có discount (nếu có) hoặc giá gốc
     */
    public void removeFlashSale() {
        if (flashSaleId != null) {
            this.flashSaleId = null;
            this.flashSalePrice = null;
            // ✅ Về giá discount (nếu có) thay vì giá gốc
            this.priceAtPurchase = comic.getDiscountPrice();
        }
    }

    /**
     * Cập nhật Flash Sale mới
     */
    public void updateFlashSale(Integer flashSaleId, Double flashSalePrice) {
        this.flashSaleId = flashSaleId;
        this.flashSalePrice = flashSalePrice;
        if (flashSalePrice != null) {
            this.priceAtPurchase = flashSalePrice;
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

    public Double getPriceAtPurchase() {
        return priceAtPurchase;
    }

    public void setPriceAtPurchase(Double priceAtPurchase) {
        this.priceAtPurchase = priceAtPurchase;
    }

    public Integer getFlashSaleId() {
        return flashSaleId;
    }

    public void setFlashSaleId(Integer flashSaleId) {
        this.flashSaleId = flashSaleId;
    }

    public Double getFlashSalePrice() {
        return flashSalePrice;
    }

    public void setFlashSalePrice(Double flashSalePrice) {
        this.flashSalePrice = flashSalePrice;
        // Cập nhật luôn priceAtPurchase
        if (flashSalePrice != null) {
            this.priceAtPurchase = flashSalePrice;
        }
    }
}