package vn.edu.hcmuaf.fit.ltw_nhom5.model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private Comic comic;
    private int quantity;
    private double priceAtPurchase;

    public CartItem(Comic comic, int quantity, double priceAtPurchase) {
        this.comic = comic;
        this.quantity = quantity;
        this.priceAtPurchase = priceAtPurchase;
    }

    public CartItem() {
    }

    public Comic getComic() {
        return comic;
    }

    public void setComic(Comic comic) {
        this.comic = comic;
    }

    public double getPriceAtPurchase() {
        return priceAtPurchase;
    }

    public void setPriceAtPurchase(double priceAtPurchase) {
        this.priceAtPurchase = priceAtPurchase;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void updateQuantity(int quantity) {
        this.quantity += quantity;
    }
}
