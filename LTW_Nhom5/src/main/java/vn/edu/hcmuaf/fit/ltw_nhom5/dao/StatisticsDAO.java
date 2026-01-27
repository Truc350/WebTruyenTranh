package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StatisticsDAO {
    private final Jdbi jdbi;

    public StatisticsDAO() {
        this.jdbi = JdbiConnector.get();
    }

    /**
     * Đếm số truyện đang bán (status = 'available', is_deleted = 0, is_hidden = 0)
     */
    public int countComicsOnSale() {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                        "SELECT COUNT(*) FROM comics " +
                                "WHERE status = 'available' AND is_deleted = 0 AND is_hidden = 0"
                ).mapTo(Integer.class).one()
        );
    }

    /**
     * Đếm số đơn hàng theo khoảng thời gian và trạng thái
     */
    public int countOrders(LocalDate startDate, LocalDate endDate, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM orders WHERE 1=1"
        );

        if (startDate != null && endDate != null) {
            sql.append(" AND DATE(order_date) BETWEEN :startDate AND :endDate");
        }

        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND status = :status");
        }

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (startDate != null && endDate != null) {
                query.bind("startDate", startDate);
                query.bind("endDate", endDate);
            }

            if (status != null && !status.isEmpty() && !"all".equals(status)) {
                query.bind("status", status);
            }

            return query.mapTo(Integer.class).one();
        });
    }

    /**
     * Tính tổng doanh thu (chỉ tính đơn Completed)
     */
    public double getTotalRevenue(LocalDate startDate, LocalDate endDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                        "WHERE status = 'Completed'"
        );

        if (startDate != null && endDate != null) {
            sql.append(" AND DATE(order_date) BETWEEN :startDate AND :endDate");
        }

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (startDate != null && endDate != null) {
                query.bind("startDate", startDate);
                query.bind("endDate", endDate);
            }

            return query.mapTo(Double.class).one();
        });
    }

    /**
     * Đếm khách hàng mới theo khoảng thời gian
     */
    public int countNewCustomers(LocalDate startDate, LocalDate endDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM users WHERE role = 'user' AND is_deleted = 0"
        );

        if (startDate != null && endDate != null) {
            sql.append(" AND DATE(created_at) BETWEEN :startDate AND :endDate");
        }

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (startDate != null && endDate != null) {
                query.bind("startDate", startDate);
                query.bind("endDate", endDate);
            }

            return query.mapTo(Integer.class).one();
        });
    }

    /**
     * Lấy doanh thu theo 12 tháng trong năm
     */
    public List<Map<String, Object>> getRevenueByMonth(int year) {
        String sql = """
            SELECT 
                MONTH(order_date) as month,
                COALESCE(SUM(total_amount), 0) as revenue
            FROM orders
            WHERE YEAR(order_date) = :year 
              AND status = 'Completed'
            GROUP BY MONTH(order_date)
            ORDER BY month
        """;

        List<Map<String, Object>> result = jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("year", year)
                        .mapToMap()
                        .list()
        );

        // Đảm bảo có đủ 12 tháng (tháng nào không có data thì revenue = 0)
        List<Map<String, Object>> fullYearData = new ArrayList<>();
        for (int i = 1; i <= 12; i++) {
            boolean found = false;
            for (Map<String, Object> row : result) {
                if (((Number) row.get("month")).intValue() == i) {
                    fullYearData.add(row);
                    found = true;
                    break;
                }
            }
            if (!found) {
                Map<String, Object> emptyMonth = new HashMap<>();
                emptyMonth.put("month", i);
                emptyMonth.put("revenue", 0.0);
                fullYearData.add(emptyMonth);
            }
        }

        return fullYearData;
    }

    /**
     * Lấy top 10 sản phẩm bán chạy nhất theo khoảng thời gian
     */
    public List<Map<String, Object>> getTopSellingComics(LocalDate startDate, LocalDate endDate, int limit) {
        StringBuilder sql = new StringBuilder("""
            SELECT 
                c.id,
                c.name_comics,
                COALESCE(SUM(oi.quantity), 0) as total_sold
            FROM comics c
            JOIN order_items oi ON c.id = oi.comic_id
            JOIN orders o ON oi.order_id = o.id
            WHERE o.status IN ('Completed', 'Shipping', 'Confirmed')
        """);

        if (startDate != null && endDate != null) {
            sql.append(" AND DATE(o.order_date) BETWEEN :startDate AND :endDate");
        }

        sql.append("""
            GROUP BY c.id, c.name_comics
            ORDER BY total_sold DESC
            LIMIT :limit
        """);

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString())
                    .bind("limit", limit);

            if (startDate != null && endDate != null) {
                query.bind("startDate", startDate);
                query.bind("endDate", endDate);
            }

            return query.mapToMap().list();
        });
    }

    /**
     * Lấy thống kê tổng hợp trong tuần hiện tại
     */
    public Map<String, Object> getWeeklyStats() {
        LocalDate today = LocalDate.now();
        LocalDate weekStart = today.minusDays(today.getDayOfWeek().getValue() - 1);
        LocalDate weekEnd = weekStart.plusDays(6);

        Map<String, Object> stats = new HashMap<>();
        stats.put("comicsOnSale", countComicsOnSale());
        stats.put("totalOrders", countOrders(weekStart, weekEnd, null));
        stats.put("revenue", getTotalRevenue(weekStart, weekEnd));
        stats.put("newCustomers", countNewCustomers(weekStart, weekEnd));

        return stats;
    }

    /**
     * Lấy thống kê tổng hợp trong tháng hiện tại
     */
    public Map<String, Object> getMonthlyStats() {
        LocalDate today = LocalDate.now();
        LocalDate monthStart = today.withDayOfMonth(1);
        LocalDate monthEnd = today.withDayOfMonth(today.lengthOfMonth());

        Map<String, Object> stats = new HashMap<>();
        stats.put("comicsOnSale", countComicsOnSale());
        stats.put("totalOrders", countOrders(monthStart, monthEnd, null));
        stats.put("revenue", getTotalRevenue(monthStart, monthEnd));
        stats.put("newCustomers", countNewCustomers(monthStart, monthEnd));

        return stats;
    }

    /**
     * Lấy thống kê tổng hợp trong năm hiện tại
     */
    public Map<String, Object> getYearlyStats() {
        LocalDate today = LocalDate.now();
        LocalDate yearStart = today.withDayOfYear(1);
        LocalDate yearEnd = today.withDayOfYear(today.lengthOfYear());

        Map<String, Object> stats = new HashMap<>();
        stats.put("comicsOnSale", countComicsOnSale());
        stats.put("totalOrders", countOrders(yearStart, yearEnd, null));
        stats.put("revenue", getTotalRevenue(yearStart, yearEnd));
        stats.put("newCustomers", countNewCustomers(yearStart, yearEnd));

        return stats;
    }

    /**
     * Lấy thống kê theo khoảng thời gian tùy chỉnh
     */
    public Map<String, Object> getCustomStats(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("comicsOnSale", countComicsOnSale());
        stats.put("totalOrders", countOrders(startDate, endDate, null));
        stats.put("revenue", getTotalRevenue(startDate, endDate));
        stats.put("newCustomers", countNewCustomers(startDate, endDate));

        return stats;
    }

    /**
     * Lấy doanh thu theo từng ngày trong khoảng thời gian
     */
    public List<Map<String, Object>> getDailyRevenue(LocalDate startDate, LocalDate endDate) {
        String sql = """
            SELECT 
                DATE(order_date) as date,
                COALESCE(SUM(total_amount), 0) as revenue
            FROM orders
            WHERE DATE(order_date) BETWEEN :startDate AND :endDate
              AND status = 'Completed'
            GROUP BY DATE(order_date)
            ORDER BY date
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("startDate", startDate)
                        .bind("endDate", endDate)
                        .mapToMap()
                        .list()
        );
    }
    /**
     * lay top 10 san pham co danh gia cao nhat
     */
    /**
     * Lấy top 10 sản phẩm có đánh giá cao nhất
     * @param limit Số lượng sản phẩm cần lấy
     * @return Danh sách sản phẩm có rating cao nhất
     */
    public List<Map<String, Object>> getTopRatedComics(int limit) {
        String sql = """
            SELECT 
                c.id,
                c.name_comics,
                COALESCE(AVG(r.rating), 0) as average_rating,
                COUNT(r.id) as total_reviews
            FROM comics c
            INNER JOIN reviews r ON c.id = r.comic_id
            WHERE c.is_deleted = 0 AND c.is_hidden = 0
            GROUP BY c.id, c.name_comics
            HAVING COUNT(r.id) >= 1
            ORDER BY average_rating DESC, total_reviews DESC
            LIMIT :limit
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", limit)
                        .mapToMap()
                        .list()
        );
    }
}