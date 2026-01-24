package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class UserDao {
    private final Jdbi jdbi;

    public UserDao(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    // Tìm user theo username hoặc email
    public Optional<User> findByUsernameOrEmail(String usernameOrEmail) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM Users WHERE (username = :ue OR email = :ue) AND is_deleted = 0 AND is_active = 1")
                        .bind("ue", usernameOrEmail)
                        .mapToBean(User.class)
                        .findOne()
        );
    }


    // Thêm user mới
    public void insert(User user) {
        jdbi.useHandle(handle ->
                handle.createUpdate("INSERT INTO Users (username, email, password_hash, full_name, created_at) " +
                                "VALUES (:username, :email, :passwordHash, :fullName, NOW())")
                        .bindBean(user)
                        .execute()
        );
    }

//   2 cái này cho đăng kí nó trùng username hay mail nó khỏi error 500
    public Optional<User> findByUsername(String username) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM Users WHERE username = :username")
                        .bind("username", username)
                        .mapToBean(User.class)
                        .findOne()
        );
    }

    public Optional<User> findByEmail(String email) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM Users WHERE email = :email")
                        .bind("email", email)
                        .mapToBean(User.class)
                        .findOne()
        );
    }


    // Update mật khẩu theo email của authen
    public void updatePassword(String email, String newPasswordHash) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE Users SET password_hash = :passwordHash WHERE email = :email")
                        .bind("passwordHash", newPasswordHash)
                        .bind("email", email)
                        .execute()
        );
    }



    //cái này để chỉnh sủa thoogn tin user ở profile

        // Cập nhật thông tin user
        public boolean updateUser(User user) {
            return jdbi.withHandle(handle ->
                    handle.createUpdate("UPDATE users SET full_name = :fullName, phone = :phone, email = :email, gender = :gender, birthdate = :birthdate, address = :address, updated_at = :updatedAt WHERE id = :id")
                            .bind("fullName", user.getFullName())
                            .bind("phone", user.getPhone())
                            .bind("email", user.getEmail())
                            .bind("gender", user.getGender())
                            .bind("birthdate", user.getBirthdate())
                            .bind("address", user.getAddress())
                            .bind("updatedAt", LocalDateTime.now())
                            .bind("id", user.getId())
                            .execute() > 0
            );
        }

        // Lấy user theo ID
        public User getUserById(int id) {
            return jdbi.withHandle(handle ->
                    handle.createQuery("SELECT * FROM users WHERE id = :id")
                            .bind("id", id)
                            .mapToBean(User.class)
                            .findOne()
                            .orElse(null)
            );
        }

    /**
     * Cap nhat diem thuong cua user
     * @param userId
     * @param newPoints
     */
    public boolean updateUserPoints(int userId, int newPoints) {
        return jdbi.withHandle(handle -> {
            int updated = handle.createUpdate(
                            "UPDATE users SET points = ? WHERE id = ?")
                    .bind(0, newPoints)
                    .bind(1, userId)
                    .execute();
            return updated > 0;
        });
    }

    /**
     * Thêm điểm cho user (tích lũy)
     * @param userId ID của user
     * @param pointsToAdd Số điểm cần thêm
     * @return true nếu thành công
     */
    public boolean addUserPoints(int userId, int pointsToAdd) {
        return jdbi.withHandle(handle -> {
            int updated = handle.createUpdate(
                            "UPDATE users SET points = points + ? WHERE id = ?")
                    .bind(0, pointsToAdd)
                    .bind(1, userId)
                    .execute();
            return updated > 0;
        });
    }

    /**
     * Trừ điểm của user
     * @param userId ID của user
     * @param pointsToSubtract Số điểm cần trừ
     * @return true nếu thành công
     */
    public boolean subtractUserPoints(int userId, int pointsToSubtract) {
        return jdbi.withHandle(handle -> {
            int updated = handle.createUpdate(
                            "UPDATE users SET points = GREATEST(points - ?, 0) WHERE id = ?")
                    .bind(0, pointsToSubtract)
                    .bind(1, userId)
                    .execute();
            return updated > 0;
        });
    }

    /**
     * Lấy số điểm hiện tại của user
     * @param userId ID của user
     * @return Số điểm của user
     */
    public int getUserPoints(int userId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT points FROM users WHERE id = ?")
                        .bind(0, userId)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0)
        );
    }
    // Trong UserDao.java
    public boolean updatePassword(int userId, String newPasswordHash) {
        return JdbiConnector.get().withHandle(handle ->
                handle.createUpdate("UPDATE users SET password_hash = :hash, updated_at = NOW() WHERE id = :id")
                        .bind("hash", newPasswordHash)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    public Optional<User> findById(int id) {
        return JdbiConnector.get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE id = :id AND is_deleted = 0")
                        .bind("id", id)
                        .mapToBean(User.class)
                        .findOne()
        );
    }

    /**
     * Lấy tất cả users (chỉ customer, không lấy admin)
     * @return Danh sách user
     */
    public List<User> getAllCustomers() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE role = 'user' " +
                                "AND is_deleted = 0 ORDER BY created_at DESC")
                        .mapToBean(User.class)
                        .list()
        );
    }

    /**
     * Đếm tổng số customer
     * @return Tổng số customer
     */
    public int countAllCustomers() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM users WHERE role = 'customer' AND is_deleted = false")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    /**
     * Tìm kiếm user theo tên hoặc email
     * @param keyword từ khóa tìm kiếm
     * @return Danh sách user tìm được
     */
    public List<User> searchCustomers(String keyword) {
        return jdbi.withHandle(handle -> {
            String membershipLevel = convertVietnameseToLevel(keyword);

            StringBuilder sql = new StringBuilder(
                    "SELECT * FROM users WHERE role = 'user' AND is_deleted = 0 AND ("
            );

            // Luôn tìm theo tên, email, username
            sql.append("full_name LIKE :keyword OR email LIKE :keyword OR username LIKE :keyword");

            // Nếu keyword khớp với tên cấp độ, THÊM điều kiện tìm theo membership_level
            if (membershipLevel != null) {
                sql.append(" OR membership_level = :level");
            }

            sql.append(") ORDER BY created_at DESC");

            var query = handle.createQuery(sql.toString())
                    .bind("keyword", "%" + keyword + "%");

            if (membershipLevel != null) {
                query.bind("level", membershipLevel);
            }

            List<User> result = query.mapToBean(User.class).list();

            return result;
        });
    }

    private String convertVietnameseToLevel(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return null;
        }

        String lowerKeyword = keyword.toLowerCase().trim();

        // Mapping tiếng Việt và tiếng Anh sang tên cấp độ
        if (lowerKeyword.contains("thường") || lowerKeyword.contains("thuong") ||
                lowerKeyword.equals("normal")) {
            return "Normal";
        } else if (lowerKeyword.contains("bạc") || lowerKeyword.contains("bac") ||
                lowerKeyword.equals("silver")) {
            return "Silver";
        } else if (lowerKeyword.contains("vàng") || lowerKeyword.contains("vang") ||
                lowerKeyword.equals("gold")) {
            return "Gold";
        } else if (lowerKeyword.contains("bạch kim") || lowerKeyword.contains("bach kim") ||
                lowerKeyword.equals("platinum") || lowerKeyword.contains("kim cương") ||
                lowerKeyword.contains("kim cuong")) {
            return "Platinum";
        }

        return null;
    }

    /**
     * Lọc user theo cấp độ thành viên
     * @param membershipLevel cấp độ (Normal, Silver, Gold, Platinum)
     * @return Danh sách user theo cấp độ
     */
    public List<User> filterCustomersByMembershipLevel(String membershipLevel) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE role = 'user' AND is_deleted = 0 " +
                                "AND membership_level = :level ORDER BY created_at DESC")
                        .bind("level", membershipLevel)
                        .mapToBean(User.class)
                        .list()
        );
    }

    /**
     * Tìm kiếm và lọc kết hợp
     * @param keyword từ khóa tìm kiếm
     * @param membershipLevel cấp độ thành viên
     * @return Danh sách user
     */
    public List<User> searchAndFilterCustomers(String keyword, String membershipLevel) {
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM users WHERE role = 'user' AND is_deleted = 0 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (full_name LIKE :keyword OR email LIKE :keyword OR username LIKE :keyword) ");
        }

        if (membershipLevel != null && !membershipLevel.trim().isEmpty()) {
            sql.append("AND membership_level = :level ");
        }

        sql.append("ORDER BY created_at DESC");

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword + "%");
            }

            if (membershipLevel != null && !membershipLevel.trim().isEmpty()) {
                query.bind("level", membershipLevel);
            }

            return query.mapToBean(User.class).list();
        });
    }

    /**
     * Nâng cấp membership level của user
     * @param userId ID của user
     * @param newLevel cấp độ mới (Normal, Silver, Gold, Platinum)
     * @return true nếu thành công
     */
    public boolean upgradeMembershipLevel(int userId, String newLevel) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE users SET membership_level = :level, updated_at = NOW() WHERE id = :id")
                        .bind("level", newLevel)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    /**
     * Khóa tài khoản user (soft delete)
     * @param userId ID của user cần khóa
     * @return true nếu thành công
     */
    public boolean lockUserAccount(int userId) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE users SET is_active = 0, " +
                                "deleted_at = NOW(), updated_at = NOW() WHERE id = :id")
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    /**
     * Mở khóa tài khoản user
     * @param userId ID của user
     * @return true nếu thành công
     */
    public boolean unlockUserAccount(int userId) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE users SET is_active = 1, " +
                                "deleted_at = NULL, updated_at = NOW() WHERE id = :id")
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    /**
     * Lấy thống kê số lượng user theo membership level
     * @return Map với key là level, value là số lượng
     */
    public List<MembershipStats> getMembershipStatistics() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT membership_level as level, COUNT(*) as count " +
                                "FROM users WHERE role = 'user' AND is_deleted = 0 " +
                                "GROUP BY membership_level")
                        .map((rs, ctx) -> new MembershipStats(
                                rs.getString("level"),
                                rs.getInt("count")
                        ))
                        .list()
        );
    }

    /**
     * Inner class cho thống kê membership
     */
    public static class MembershipStats {
        private String level;
        private int count;

        public MembershipStats(String level, int count) {
            this.level = level;
            this.count = count;
        }

        public String getLevel() {
            return level;
        }

        public int getCount() {
            return count;
        }
    }

    /**
     * Cập nhật tổng chi tiêu của user
     * @param userId ID của user
     * @param amount số tiền cần cộng thêm
     * @return true nếu thành công
     */
    public boolean updateTotalSpent(int userId, double amount) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE users SET total_spent = total_spent + :amount, updated_at = NOW() WHERE id = :id")
                        .bind("amount", amount)
                        .bind("id", userId)
                        .execute() > 0
        );
    }


    /**
     * Lấy danh sách user đã bị khóa
     * @return Danh sách user bị khóa
     */
    public List<User> getLockedUsers() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE role = 'user' AND is_active = 0 " +
                                "ORDER BY deleted_at DESC")
                        .mapToBean(User.class)
                        .list()
        );
    }


}
