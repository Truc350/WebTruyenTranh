package vn.edu.hcmuaf.fit.ltw_nhom5.utils;

public class PaginationUtils {
    /**
     * Tính tổng số trang
     */
    public static int calculateTotalPages(int totalItems, int itemsPerPage) {
        return (int) Math.ceil((double) totalItems / itemsPerPage);
    }

    /**
     * Validate page number
     */
    public static int validatePage(String pageStr, int totalPages) {
        try {
            int page = Integer.parseInt(pageStr);
            if (page < 1) return 1;
            if (page > totalPages) return Math.max(totalPages, 1);
            return page;
        } catch (NumberFormatException e) {
            return 1;
        }
    }
}
