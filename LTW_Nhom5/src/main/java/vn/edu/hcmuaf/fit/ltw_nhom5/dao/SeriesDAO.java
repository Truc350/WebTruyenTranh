package vn.edu.hcmuaf.fit.ltw_nhom5.dao;


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
}
