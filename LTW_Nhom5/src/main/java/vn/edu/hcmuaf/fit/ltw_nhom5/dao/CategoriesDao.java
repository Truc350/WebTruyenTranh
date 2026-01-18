package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;

import java.util.List;

public class CategoriesDao {
    private Jdbi jdbi;

    public CategoriesDao() {
        this.jdbi = JdbiConnector.get();  // Lấy jdbi từ connector
    }

    public List<Category> listCategories() {
        String sql = "SELECT id, name_categories, description, is_deleted, deleted_at, created_at " +
                "FROM Categories WHERE is_deleted = 0 ORDER BY name_categories";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Category.class)
                        .list()
        );
    }
    public List<Category> getAllCategories() {
        return listCategories();
    }
}