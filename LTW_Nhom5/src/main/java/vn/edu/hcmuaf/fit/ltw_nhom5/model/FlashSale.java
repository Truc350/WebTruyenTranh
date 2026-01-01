package vn.edu.hcmuaf.fit.ltw_nhom5.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class FlashSale {
    private int id;
    private String name;
    private Double discountPercent;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String status;
    private LocalDateTime createdAt;

    public FlashSale() {}

    public FlashSale(String name, Double discountPercent, LocalDateTime startTime, LocalDateTime endTime) {
        this.name = name;
        this.discountPercent = discountPercent;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = "scheduled";
    }



    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(Double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
