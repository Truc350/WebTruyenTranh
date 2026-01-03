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

    public void addItem(Comic comic, int quantity) {
        if(quantity <= 0) quantity = 1;
        if(get(comic.getId()) != null)
            data.get(comic.getId()).updateQuantity(quantity);
        else
            data.put(comic.getId(), new CartItem(comic, quantity, comic.getPrice()));

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
        getItems().forEach(item->{
            total.addAndGet(item.getQuantity());});
        return total.get();
    }

    public double total() {
        AtomicReference<Double> total = new AtomicReference<>((double) 0);
        getItems().forEach(item->{
            total.updateAndGet(v -> v.doubleValue() + (item.getQuantity() * item.getPriceAtPurchase()));
        });
        return total.get();
    }


    // tuy theo thong tin muon update
    public void updateCustomerInfo(User user) {
        this.user = user;
    }



}
