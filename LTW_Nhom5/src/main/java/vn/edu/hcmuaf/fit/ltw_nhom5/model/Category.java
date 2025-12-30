package vn.edu.hcmuaf.fit.ltw_nhom5.model;

import java.time.LocalDateTime;

public class Category {
    private int id;
    private String nameCategories;
    private String description;
    private boolean isDeleted;
    private LocalDateTime deletedAt;
    private LocalDateTime createdAt;

    // Constructor đầy đủ
    public Category(int id, String nameCategories, String description,
                    boolean isDeleted, LocalDateTime deletedAt, LocalDateTime createdAt) {
        this.id = id;
        this.nameCategories = nameCategories;
        this.description = description;
        this.isDeleted = isDeleted;
        this.deletedAt = deletedAt;
        this.createdAt = createdAt;
    }

    public Category() {
    }



    // Getter và Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNameCategories() {
        return nameCategories;
    }

    public void setNameCategories(String nameCategories) {
        this.nameCategories = nameCategories;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public LocalDateTime getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(LocalDateTime deletedAt) {
        this.deletedAt = deletedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", nameCategories='" + nameCategories + '\'' +
                ", description='" + description + '\'' +
                ", isDeleted=" + isDeleted +
                ", deletedAt=" + deletedAt +
                ", createdAt=" + createdAt +
                '}';
    }
}