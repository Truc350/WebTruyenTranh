package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.UserShippingAddress;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class UserShippingAddressDAO {
    private final Jdbi jdbi;

    public UserShippingAddressDAO() {
        this.jdbi = JdbiConnector.get();
    }

    public UserShippingAddressDAO(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    /**
     * Tạo địa chỉ giao hàng mới
     * @param address Thông tin địa chỉ
     * @return ID của địa chỉ mới tạo, trả về 0 nếu thất bại
     */
    public int createShippingAddress(UserShippingAddress address) {
        return jdbi.withHandle(handle -> {
            String sql = "INSERT INTO user_shipping_addresses " +
                    "(user_id, recipient_name, phone, province, district, ward, " +
                    "street_address, is_default, is_deleted, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            return handle.createUpdate(sql)
                    .bind(0, address.getUserId())
                    .bind(1, address.getRecipientName())
                    .bind(2, address.getPhone())
                    .bind(3, address.getProvince())
                    .bind(4, address.getDistrict())
                    .bind(5, address.getWard())
                    .bind(6, address.getStreetAddress())
                    .bind(7, address.isDefault())
                    .bind(8, false) // is_deleted = false
                    .bind(9, LocalDate.now()) // created_at
                    .bind(10, LocalDate.now()) // updated_at
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    /**
     * Lấy địa chỉ theo ID
     * @param id ID của địa chỉ
     * @return Optional chứa UserShippingAddress nếu tìm thấy
     */
    public Optional<UserShippingAddress> getAddressById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM user_shipping_addresses WHERE id = ? AND is_deleted = false")
                        .bind(0, id)
                        .mapToBean(UserShippingAddress.class)
                        .findFirst()
        );
    }

    /**
     * Lấy tất cả địa chỉ của user
     * @param userId ID của user
     * @return Danh sách địa chỉ
     */
    public List<UserShippingAddress> getAddressesByUserId(int userId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM user_shipping_addresses " +
                                "WHERE user_id = ? AND is_deleted = false " +
                                "ORDER BY is_default DESC, created_at DESC")
                        .bind(0, userId)
                        .mapToBean(UserShippingAddress.class)
                        .list()
        );
    }

    /**
     * Lấy địa chỉ mặc định của user
     * @param userId ID của user
     * @return Optional chứa địa chỉ mặc định nếu có
     */
    public Optional<UserShippingAddress> getDefaultAddress(int userId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM user_shipping_addresses " +
                                "WHERE user_id = ? AND is_default = true AND is_deleted = false")
                        .bind(0, userId)
                        .mapToBean(UserShippingAddress.class)
                        .findFirst()
        );
    }

    /**
     * Cập nhật địa chỉ
     * @param address Thông tin địa chỉ mới
     * @return true nếu cập nhật thành công
     */
    public boolean updateAddress(UserShippingAddress address) {
        return jdbi.withHandle(handle -> {
            String sql = "UPDATE user_shipping_addresses SET " +
                    "recipient_name = ?, phone = ?, province = ?, district = ?, " +
                    "ward = ?, street_address = ?, is_default = ?, updated_at = ? " +
                    "WHERE id = ? AND is_deleted = false";

            int updated = handle.createUpdate(sql)
                    .bind(0, address.getRecipientName())
                    .bind(1, address.getPhone())
                    .bind(2, address.getProvince())
                    .bind(3, address.getDistrict())
                    .bind(4, address.getWard())
                    .bind(5, address.getStreetAddress())
                    .bind(6, address.isDefault())
                    .bind(7, LocalDate.now())
                    .bind(8, address.getId())
                    .execute();

            return updated > 0;
        });
    }

    /**
     * Đặt địa chỉ làm mặc định (và bỏ mặc định các địa chỉ khác)
     * @param addressId ID địa chỉ
     * @param userId ID user
     * @return true nếu thành công
     */
    public boolean setDefaultAddress(int addressId, int userId) {
        return jdbi.inTransaction(handle -> {
            // Bỏ mặc định tất cả địa chỉ của user
            handle.createUpdate("UPDATE user_shipping_addresses SET is_default = false " +
                            "WHERE user_id = ? AND is_deleted = false")
                    .bind(0, userId)
                    .execute();

            // Đặt địa chỉ được chọn làm mặc định
            int updated = handle.createUpdate("UPDATE user_shipping_addresses " +
                            "SET is_default = true, updated_at = ? " +
                            "WHERE id = ? AND user_id = ? AND is_deleted = false")
                    .bind(0, LocalDate.now())
                    .bind(1, addressId)
                    .bind(2, userId)
                    .execute();

            return updated > 0;
        });
    }

    public void unsetAllDefaultAddresses(int userId) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("UPDATE user_shipping_addresses SET is_default = false " +
                            "WHERE user_id = ? AND is_deleted = false")
                    .bind(0, userId)
                    .execute();
        });
    }
    /**
     * Xóa địa chỉ (soft delete)
     * @param addressId ID địa chỉ
     * @param userId ID user (để đảm bảo user chỉ xóa địa chỉ của mình)
     * @return true nếu xóa thành công
     */
    public boolean deleteAddress(int addressId, int userId) {
        return jdbi.withHandle(handle -> {
            String sql = "UPDATE user_shipping_addresses " +
                    "SET is_deleted = true, deleted_at = ?, updated_at = ? " +
                    "WHERE id = ? AND user_id = ?";

            int updated = handle.createUpdate(sql)
                    .bind(0, LocalDate.now())
                    .bind(1, LocalDate.now())
                    .bind(2, addressId)
                    .bind(3, userId)
                    .execute();

            return updated > 0;
        });
    }

    /**
     * Kiểm tra địa chỉ đã tồn tại chưa (dựa trên thông tin giống nhau)
     * @param address Thông tin địa chỉ cần kiểm tra
     * @return Optional chứa địa chỉ nếu đã tồn tại
     */
    public Optional<UserShippingAddress> findExistingAddress(UserShippingAddress address) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM user_shipping_addresses " +
                                "WHERE user_id = ? AND recipient_name = ? AND phone = ? " +
                                "AND province = ? AND district = ? AND ward = ? " +
                                "AND street_address = ? AND is_deleted = false")
                        .bind(0, address.getUserId())
                        .bind(1, address.getRecipientName())
                        .bind(2, address.getPhone())
                        .bind(3, address.getProvince())
                        .bind(4, address.getDistrict())
                        .bind(5, address.getWard())
                        .bind(6, address.getStreetAddress())
                        .mapToBean(UserShippingAddress.class)
                        .findFirst()
        );
    }

    /**
     * Đếm số địa chỉ của user
     * @param userId ID user
     * @return Số lượng địa chỉ
     */
    public int countAddressesByUserId(int userId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM user_shipping_addresses " +
                                "WHERE user_id = ? AND is_deleted = false")
                        .bind(0, userId)
                        .mapTo(Integer.class)
                        .one()
        );
    }
}
