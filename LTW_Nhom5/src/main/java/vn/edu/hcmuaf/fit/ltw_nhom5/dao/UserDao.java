package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.User;

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
}
