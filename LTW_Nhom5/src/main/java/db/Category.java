package db;

import java.time.LocalDateTime;

public class Category {
    private int id;
    private String series_name;
    private String description;
    private String cover_url;
    private int total_volumes;
    private String status;
    private boolean is_deleted;
    private LocalDateTime deleted_at;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;

    public Category(int id, String series_name, String description, String cover_url, int total_volumes, String status, boolean is_deleted, LocalDateTime deleted_at, LocalDateTime created_at, LocalDateTime updated_at) {
        this.id = id;
        this.series_name = series_name;
        this.description = description;
        this.cover_url = cover_url;
        this.total_volumes = total_volumes;
        this.status = status;
        this.is_deleted = is_deleted;
        this.deleted_at = deleted_at;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSeries_name() {
        return series_name;
    }

    public void setSeries_name(String series_name) {
        this.series_name = series_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCover_url() {
        return cover_url;
    }

    public void setCover_url(String cover_url) {
        this.cover_url = cover_url;
    }

    public int getTotal_volumes() {
        return total_volumes;
    }

    public void setTotal_volumes(int total_volumes) {
        this.total_volumes = total_volumes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isIs_deleted() {
        return is_deleted;
    }

    public void setIs_deleted(boolean is_deleted) {
        this.is_deleted = is_deleted;
    }

    public LocalDateTime getDeleted_at() {
        return deleted_at;
    }

    public void setDeleted_at(LocalDateTime deleted_at) {
        this.deleted_at = deleted_at;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public LocalDateTime getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(LocalDateTime updated_at) {
        this.updated_at = updated_at;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", series_name='" + series_name + '\'' +
                ", description='" + description + '\'' +
                ", cover_url='" + cover_url + '\'' +
                ", total_volumes=" + total_volumes +
                ", status='" + status + '\'' +
                ", is_deleted=" + is_deleted +
                ", deleted_at=" + deleted_at +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                '}';
    }
}