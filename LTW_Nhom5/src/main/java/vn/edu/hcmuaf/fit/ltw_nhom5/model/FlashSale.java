package vn.edu.hcmuaf.fit.ltw_nhom5.model;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class FlashSale {
    private int id;
    private String name;
    @ColumnName("discount_percent")
    private Double discountPercent;

    @ColumnName("start_time")
    private LocalDateTime startTime;

    @ColumnName("end_time")
    private LocalDateTime endTime;
    private String status;
    @ColumnName("created_at")
    private LocalDateTime createdAt;

    public FlashSale() {
    }

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


    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");


    /**
     * Chuyển LocalDateTime sang java.util.Date cho JSTL fmt:formatDate
     */
    public Date getStartTimeAsDate() {
        if (startTime == null) return null;
        return Timestamp.valueOf(startTime);
    }

    /**
     * Chuyển LocalDateTime sang java.util.Date cho JSTL fmt:formatDate
     */
    public Date getEndTimeAsDate() {
        if (endTime == null) return null;
        return Timestamp.valueOf(endTime);
    }

    /**
     * Lấy thời gian bắt đầu dạng HH:mm
     */
    public String getStartTimeFormatted() {
        if (startTime == null) return "";
        return String.format("%02d:%02d", startTime.getHour(), startTime.getMinute());
    }

    /**
     * Lấy thời gian kết thúc dạng HH:mm
     */
    public String getEndTimeFormatted() {
        if (endTime == null) return "";
        return String.format("%02d:%02d", endTime.getHour(), endTime.getMinute());
    }

    /**
     * Kiểm tra Flash Sale có đang active không
     */
    public boolean isActive() {
        return "active".equals(status);
    }

    /**
     * Kiểm tra Flash Sale có đang scheduled không
     */
    public boolean isScheduled() {
        return "scheduled".equals(status);
    }

    /**
     * Kiểm tra Flash Sale đã kết thúc chưa
     */
    public boolean isEnded() {
        return "ended".equals(status);
    }

    /**
     * Lấy label hiển thị cho status
     */
    public String getStatusLabel() {
        return switch (status) {
            case "active" -> "Đang bán";
            case "scheduled" -> "Sắp diễn ra";
            case "ended" -> "Đã kết thúc";
            default -> status;
        };
    }

    @Override
    public String toString() {
        return "FlashSale{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", discountPercent=" + discountPercent +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", status='" + status + '\'' +
                '}';
    }
}
