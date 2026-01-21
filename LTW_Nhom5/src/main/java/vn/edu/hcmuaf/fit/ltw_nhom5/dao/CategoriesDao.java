package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class CategoriesDao {
    private Jdbi jdbi;

    public CategoriesDao() {
        try {
            this.jdbi = JdbiConnector.get();
            System.out.println("✓ CategoriesDao initialized successfully");
        } catch (Exception e) {
            System.err.println("✗ ERROR initializing CategoriesDao:");
            e.printStackTrace();
            throw e;
        }
    }

    public List<Category> listCategories() {
        String sql = "SELECT id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
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
            System.err.println("Error in getTotalCategories:");
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
            System.err.println("Error in countSearchResults:");
            e.printStackTrace();
            return 0;
        }
    }

    public List<Category> searchCategoriesByName(String keyword, int page, int pageSize) {
        String sql = "SELECT id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
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
            System.err.println("Error in searchCategoriesByName:");
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Lấy danh sách thể loại theo trang
     */
    public List<Category> getCategoriesByPage(int page, int pageSize) {
        String sql = "SELECT id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
                "deleted_at as deletedAt, " +
                "created_at as createdAt " +
                "FROM categories " +
                "WHERE is_deleted = 0 " +
                "ORDER BY id ASC " +
                "LIMIT :limit OFFSET :offset";

        int offset = (page - 1) * pageSize;

        try {
            System.out.println("Getting categories - Page: " + page + ", PageSize: " + pageSize + ", Offset: " + offset);
            List<Category> result = jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("limit", pageSize)
                            .bind("offset", offset)
                            .mapToBean(Category.class)
                            .list()
            );
            System.out.println("Retrieved " + result.size() + " categories");
            return result;
        } catch (Exception e) {
            System.err.println("Error in getCategoriesByPage:");
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Lấy thể loại theo ID - SỬA LẠI SELECT *
     */
    public Category getCategoryById(int id) {
        String sql = "SELECT id, " +
                "name_categories as nameCategories, " +
                "description, " +
                "is_deleted as isDeleted, " +
                "deleted_at as deletedAt, " +
                "created_at as createdAt " +
                "FROM categories WHERE id = :id AND is_deleted = 0";

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("id", id)
                            .mapToBean(Category.class)
                            .findOne()
                            .orElse(null)
            );
        } catch (Exception e) {
            System.err.println("Error in getCategoryById:");
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Thêm thể loại mới
     */
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
            System.out.println("✓ Category added successfully: " + category.getNameCategories());
            return true;
        } catch (Exception e) {
            System.err.println("✗ Error adding category:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật thể loại
     */
    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories " +
                "SET name_categories = :name, description = :description " +
                "WHERE id = :id AND is_deleted = 0";

        try {
            int rowsAffected = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", category.getId())
                            .bind("name", category.getNameCategories())
                            .bind("description", category.getDescription())
                            .execute()
            );
            System.out.println("✓ Category updated - Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("✗ Error updating category:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa mềm thể loại (soft delete)
     */
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
            System.out.println("✓ Category deleted - Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("✗ Error deleting category:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Kiểm tra tên thể loại đã tồn tại chưa (để validate)
     */
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
            System.err.println("Error in isNameExists:");
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) {
        System.out.println(    new CategoriesDao().addCategory(new Category(36, "Truyện dân gian","Truyện cổ tích là loại truyện dân gian hư cấu, phản ánh ước mơ, niềm tin và bài học đạo đức qua những nhân vật, sự kiện kỳ ảo, giàu tính nhân văn.", 0, null,LocalDateTime.now())));
    }
}