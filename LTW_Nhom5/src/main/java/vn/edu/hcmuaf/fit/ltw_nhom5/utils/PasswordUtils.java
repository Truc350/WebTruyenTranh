package vn.edu.hcmuaf.fit.ltw_nhom5.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    // Hash mật khẩu
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    // Kiểm tra mật khẩu nhập vào có khớp với hash không
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
