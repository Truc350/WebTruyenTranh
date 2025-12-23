package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.util.List;

public class ComicDAO extends ADao {
    public List<Comic> search(String keyword) {
        String sql = """
                    SELECT *
                    FROM Comics
                    WHERE is_deleted = 0
                      AND status = 'available'
                      AND (name_comics LIKE :kw OR author LIKE :kw OR publisher LIKE :kw)
                    ORDER BY created_at DESC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("kw", "%" + keyword + "%")
                        .mapToBean(Comic.class)
                        .list()
        );

    }
}
