package vn.edu.hcmuaf.fit.ltw_nhom5.dao;


import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

public class SeriesDAO extends ADao{
    public String getSeriesNameById(int seriesId) {
        String sql = "SELECT series_name FROM series WHERE id = :id";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", seriesId)
                        .mapTo(String.class)
                        .findFirst()
                        .orElse(null)
        );
    }


    public void insert(Series series) {
        String sql = "INSERT INTO series (series_name, description, cover_url, total_volumes, status, is_deleted," +
                " created_at, updated_at) " +
                " VALUES (:seriesName, :description, :coverUrl, :totalVolumes, " +
                " :status, :isDeleted, :createdAt, :updatedAt)";

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("seriesName", series.getSeriesName())
                        .bind("description", series.getDescription())
                        .bind("coverUrl", series.getCoverUrl())
                        .bind("totalVolumes", series.getTotalVolumes())
                        .bind("status", series.getStatus())
                        .bind("isDeleted", series.isDeleted())
                        .bind("createdAt", series.getCreatedAt())
                        .bind("updatedAt", series.getUpdatedAt())
                        .execute()
        );
    }

}
