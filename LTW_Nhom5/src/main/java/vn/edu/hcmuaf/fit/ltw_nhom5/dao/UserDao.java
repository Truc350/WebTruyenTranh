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




}
