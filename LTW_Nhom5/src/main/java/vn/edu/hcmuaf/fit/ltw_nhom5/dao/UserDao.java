package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
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



}
