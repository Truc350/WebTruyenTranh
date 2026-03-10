package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CategoriesDao {
    private Jdbi jdbi;

    public CategoriesDao() {
        try {
            this.jdbi = JdbiConnector.get();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public List<Category> listCategories() {
        String sql = "SELECT id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
                "is_hidden AS is_hidden, " +

                "deleted_at as deletedAt, " +
                "created_at as createdAt " +
                "FROM categories WHERE is_deleted = 0 ORDER BY name_categories";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public List<Category> getAllCategories() {
        String sql = "SELECT id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
                "is_hidden AS is_hidden, " +
                "deleted_at as deletedAt, " +
                "created_at as createdAt " +
                "FROM categories WHERE is_deleted = 0 ORDER BY name_categories ASC";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public int getTotalCategories() {
        String sql = "SELECT COUNT(*) FROM categories WHERE is_deleted = 0";

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .mapTo(Integer.class)
                            .findOne()
                            .orElse(0)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int countSearchResults(String keyword) {
        String sql = "SELECT COUNT(*) FROM categories " +
                "WHERE name_categories LIKE :keyword AND is_deleted = 0";

        try {
            return jdbi.withHandle(handle -> handle.createQuery(sql)
                    .bind("keyword", "%" + keyword + "%")
                    .mapTo(Integer.class)
                    .findOne()
                    .orElse(0)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Category> searchCategoriesByName(String keyword, int page, int pageSize) {
        String sql = "SELECT id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
                "is_hidden AS is_hidden, " +
                "deleted_at as deletedAt, " +
                "created_at as createdAt " +
                "FROM categories " +
                "WHERE name_categories LIKE :keyword AND is_deleted = 0 " +
                "ORDER BY name_categories ASC " +
                "LIMIT :limit OFFSET :offset";

        int offset = (page - 1) * pageSize;

        try {
            return jdbi.withHandle(handle -> handle.createQuery(sql)
                    .bind("keyword", "%" + keyword + "%")
                    .bind("limit", pageSize)
                    .bind("offset", offset)
                    .mapToBean(Category.class)
                    .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }


    public List<Category> getCategoriesByPage(int page, int pageSize) {
        String sql = "SELECT id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
                "is_hidden AS is_hidden, " +
                "deleted_at as deletedAt, " +
                "created_at as createdAt " +
                "FROM categories " +
                "WHERE is_deleted = 0 " +
                "ORDER BY id ASC " +
                "LIMIT :limit OFFSET :offset";

        int offset = (page - 1) * pageSize;

        try {
            List<Category> result = jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("limit", pageSize)
                            .bind("offset", offset)
                            .mapToBean(Category.class)
                            .list()
            );
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT " +
                "id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
                "is_hidden AS is_hidden, " +
                "deleted_at as deletedAt, " +
                "created_at as createdAt " +
                "FROM categories " +
                "WHERE id = :id AND is_deleted = 0";

        try {

            Category result = jdbi.withHandle(handle -> {
                return handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Category.class)
                        .findOne()
                        .orElse(null);
            });

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error getting category by ID: " + id, e);
        }
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (name_categories, description, created_at) " +
                "VALUES (:name, :description, NOW())";

        try {
            jdbi.useHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("name", category.getNameCategories())
                            .bind("description", category.getDescription())
                            .execute()
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCategory(Category category) {
        String sql = """
                    UPDATE categories
                    SET name_categories = :name,
                        description = :description
                    WHERE id = :id AND is_deleted = 0
                """;

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", category.getId())
                        .bind("name", category.getNameCategories())
                        .bind("description", category.getDescription())
                        .execute()
        );

        return rows > 0;
    }


    public boolean deleteCategory(int id) {
        String sql = "UPDATE categories " +
                "SET is_deleted = 1, deleted_at = NOW() " +
                "WHERE id = :id";

        try {
            int rowsAffected = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", id)
                            .execute()
            );
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isNameExists(String name, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM categories " +
                "WHERE name_categories = :name AND is_deleted = 0";

        if (excludeId != null) {
            sql += " AND id != :excludeId";
        }

        String finalSql = sql;

        try {
            int count = jdbi.withHandle(handle -> {
                var query = handle.createQuery(finalSql).bind("name", name);
                if (excludeId != null) {
                    query.bind("excludeId", excludeId);
                }
                return query.mapTo(Integer.class).findOne().orElse(0);
            });

            return count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public int countComicsInCategory(int categoryId) {
        String sql = """
                    SELECT COUNT(*) 
                    FROM comics 
                    WHERE category_id = :categoryId 
                      AND is_deleted = 0 
                      AND is_hidden = 0 
                      AND status = 'available'
                """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("categoryId", categoryId)
                            .mapTo(Integer.class)
                            .findOne()
                            .orElse(0)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }


    public static void main(String[] args) {
        CategoriesDao dao = new CategoriesDao();

        Category cat = dao.getCategoryById(2);
    }



}