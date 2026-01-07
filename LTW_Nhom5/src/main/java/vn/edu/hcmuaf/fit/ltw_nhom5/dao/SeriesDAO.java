package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import java.util.List;
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


    public List<Series> getAllSeries() {
        String sql = "SELECT id, series_name, description, cover_url, total_volumes, status, is_deleted, created_at, updated_at FROM series";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Series.class)
                        .list()
        );
    }


    public List<Series> getSeriesByPage(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT id, series_name AS seriesName, description, cover_url AS coverUrl, " +
                "total_volumes AS totalVolumes, status, is_deleted AS isDeleted, " +
                "created_at AS createdAt, updated_at AS updatedAt " +
                "FROM series LIMIT :limit OFFSET :offset";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", pageSize)
                        .bind("offset", offset)
                        .mapToBean(Series.class)
                        .list()
        );
    }

    public int countSeries() {
        String sql = "SELECT COUNT(*) FROM series";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .one()
        );
    }


}
