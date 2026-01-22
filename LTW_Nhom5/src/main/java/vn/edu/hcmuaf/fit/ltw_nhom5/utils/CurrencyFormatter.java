package vn.edu.hcmuaf.fit.ltw_nhom5.utils;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

/**
 * Helper class để format tiền tệ Việt Nam
 */
public class CurrencyFormatter {

    /**
     * Format số tiền thành chuỗi dạng "25.000 đ"
     * @param amount Số tiền cần format
     * @return Chuỗi đã format, ví dụ: "25.000 đ"
     */
    public static String format(double amount) {
        // Tạo formatter với locale Việt Nam
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');

        // Pattern: nhóm 3 chữ số, không có phần thập phân
        DecimalFormat formatter = new DecimalFormat("#,###", symbols);

        // Format và thêm " đ"
        return formatter.format(amount) + " đ";
    }

    /**
     * Format số tiền integer
     */
    public static String format(int amount) {
        return format((double) amount);
    }

    /**
     * Format số tiền long
     */
    public static String format(long amount) {
        return format((double) amount);
    }
}
