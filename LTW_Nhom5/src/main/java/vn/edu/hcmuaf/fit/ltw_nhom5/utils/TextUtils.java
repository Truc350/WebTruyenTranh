package vn.edu.hcmuaf.fit.ltw_nhom5.utils;

import java.text.Normalizer;

public class TextUtils {
    public static String normalize(String text) {
        if (text == null || text.isEmpty()) {
            return "";
        }

        text = text.toLowerCase().trim();

        // Bảng chuyển đổi dấu tiếng Việt
        text = text.replaceAll("[áàảãạăắằẳẵặâấầẩẫậ]", "a");
        text = text.replaceAll("[éèẻẽẹêếềểễệ]", "e");
        text = text.replaceAll("[íìỉĩị]", "i");
        text = text.replaceAll("[óòỏõọôốồổỗộơớờởỡợ]", "o");
        text = text.replaceAll("[úùủũụưứừửữự]", "u");
        text = text.replaceAll("[ýỳỷỹỵ]", "y");
        text = text.replaceAll("đ", "d");

        // Chuẩn hóa khoảng trắng
        text = text.replaceAll("\\s+", " ").trim();

        return text;
    }

    public static void main(String[] args) {
        System.out.println(normalize("Chú Thuật Hồi Chiến Tập 4"));
        // Expected: "chu thuat hoi chien tap 4"

        System.out.println(normalize("shin tập 50"));
        // Expected: "shin tap 50"
    }
}
