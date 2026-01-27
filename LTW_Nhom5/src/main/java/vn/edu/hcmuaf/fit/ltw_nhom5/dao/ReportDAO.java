package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;

import java.time.LocalDate;
import java.util.*;

public class ReportDAO {
    private final Jdbi jdbi;

    public ReportDAO() {
        this.jdbi = JdbiConnector.get();
    }

    public ReportDAO(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    /**
     * ✅ FIX: Lấy thống kê tổng quan theo khoảng thời gian
     */
    public Map<String, Object> getOverviewStats(LocalDate startDate, LocalDate endDate) {
        return jdbi.withHandle(handle -> {
            Map<String, Object> stats = new HashMap<>();

            System.out.println("🔍 Querying from: " + startDate + " to: " + endDate);

            // 1. Tổng doanh thu THEO DATE RANGE
            Double totalRevenue = handle.createQuery(
                            "SELECT COALESCE(SUM(total_amount), 0) " +
                                    "FROM orders " +
                                    "WHERE order_date IS NOT NULL " +
                                    "AND DATE(order_date) BETWEEN :start AND :end"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .mapTo(Double.class)
                    .one();

            System.out.println("💰 Total Revenue in range: " + totalRevenue);

            // 2. Số đơn hàng THEO DATE RANGE
            Integer orderCount = handle.createQuery(
                            "SELECT COUNT(*) " +
                                    "FROM orders " +
                                    "WHERE order_date IS NOT NULL " +
                                    "AND DATE(order_date) BETWEEN :start AND :end"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .mapTo(Integer.class)
                    .one();

            System.out.println("📦 Total Orders in range: " + orderCount);

            // 3. Giá trị đơn trung bình
            Double avgOrderValue = orderCount > 0 ? totalRevenue / orderCount : 0.0;
            System.out.println("📊 Average Order Value: " + avgOrderValue);

            // 4. Sản phẩm bán chạy nhất THEO DATE RANGE
            Map<String, Object> topProduct = handle.createQuery(
                            "SELECT c.name_comics, SUM(oi.quantity) as total_sold " +
                                    "FROM order_items oi " +
                                    "JOIN comics c ON oi.comic_id = c.id " +
                                    "JOIN orders o ON oi.order_id = o.id " +
                                    "WHERE o.order_date IS NOT NULL " +
                                    "AND DATE(o.order_date) BETWEEN :start AND :end " +
                                    "GROUP BY c.id, c.name_comics " +
                                    "ORDER BY total_sold DESC " +
                                    "LIMIT 1"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .mapToMap()
                    .findFirst()
                    .orElse(null);

            if (topProduct != null) {
                System.out.println("🏆 Best Product: " + topProduct.get("name_comics"));
            }

            stats.put("revenue", totalRevenue);
            stats.put("totalOrders", orderCount);
            stats.put("avgOrderValue", avgOrderValue);
            stats.put("bestProduct", topProduct != null ? topProduct.get("name_comics") : "Chưa có dữ liệu");

            return stats;
        });
    }

    /**
     * Lấy doanh thu theo ngày trong khoảng thời gian
     */
    public List<Map<String, Object>> getDailyRevenue(LocalDate startDate, LocalDate endDate) {
        return jdbi.withHandle(handle -> {
            List<Map<String, Object>> result = handle.createQuery(
                            "SELECT DATE(order_date) as date, " +
                                    "COALESCE(SUM(total_amount), 0) as revenue, " +
                                    "COUNT(*) as order_count " +
                                    "FROM orders " +
                                    "WHERE order_date IS NOT NULL " +
                                    "AND DATE(order_date) BETWEEN :start AND :end " +
                                    "GROUP BY DATE(order_date) " +
                                    "ORDER BY date ASC"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .mapToMap()
                    .list();

            System.out.println("📊 getDailyRevenue returned " + result.size() + " rows");

            // Debug: In ra từng dòng data
            for (Map<String, Object> row : result) {
                System.out.println("  - Date: " + row.get("date") +
                        ", Revenue: " + row.get("revenue") +
                        ", Orders: " + row.get("order_count"));
            }

            return result;
        });
    }

    /**
     * Lấy top sản phẩm bán chạy
     */
    public List<Map<String, Object>> getTopSellingProducts(LocalDate startDate, LocalDate endDate, int limit) {
        return jdbi.withHandle(handle -> {
            List<Map<String, Object>> result = handle.createQuery(
                            "SELECT c.id, c.name_comics, " +
                                    "SUM(oi.quantity) as total_sold, " +
                                    "SUM(oi.quantity * oi.price_at_purchase) as total_revenue " +
                                    "FROM order_items oi " +
                                    "JOIN comics c ON oi.comic_id = c.id " +
                                    "JOIN orders o ON oi.order_id = o.id " +
                                    "WHERE o.order_date IS NOT NULL " +
                                    "AND DATE(o.order_date) BETWEEN :start AND :end " +
                                    "GROUP BY c.id, c.name_comics " +
                                    "ORDER BY total_sold DESC " +
                                    "LIMIT :limit"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .bind("limit", limit)
                    .mapToMap()
                    .list();

            System.out.println("🏆 getTopSellingProducts returned " + result.size() + " products");

            // Debug: In ra top products
            for (Map<String, Object> product : result) {
                System.out.println("  - Product: " + product.get("name_comics") +
                        ", Sold: " + product.get("total_sold"));
            }

            return result;
        });
    }

    /**
     * Lấy thống kê theo trạng thái đơn hàng
     */
    public Map<String, Integer> getOrderStatusStats(LocalDate startDate, LocalDate endDate) {
        return jdbi.withHandle(handle -> {
            List<Map<String, Object>> results = handle.createQuery(
                            "SELECT status, COUNT(*) as count " +
                                    "FROM orders " +
                                    "WHERE DATE(order_date) BETWEEN :start AND :end " +
                                    "GROUP BY status"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .mapToMap()
                    .list();

            Map<String, Integer> statusMap = new HashMap<>();
            for (Map<String, Object> row : results) {
                statusMap.put((String) row.get("status"), ((Number) row.get("count")).intValue());
            }
            return statusMap;
        });
    }

    /**
     * Lấy thống kê doanh thu theo thể loại
     */
    public List<Map<String, Object>> getRevenueByCategory(LocalDate startDate, LocalDate endDate) {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT cat.name_categories as category_name, " +
                                        "COALESCE(SUM(oi.quantity * oi.price_at_purchase), 0) as revenue, " +
                                        "SUM(oi.quantity) as total_sold " +
                                        "FROM order_items oi " +
                                        "JOIN comics c ON oi.comic_id = c.id " +
                                        "JOIN categories cat ON c.category_id = cat.id " +
                                        "JOIN orders o ON oi.order_id = o.id " +
                                        "WHERE o.order_date IS NOT NULL " +
                                        "AND DATE(o.order_date) BETWEEN :start AND :end " +
                                        "GROUP BY cat.id, cat.name_categories " +
                                        "ORDER BY revenue DESC"
                        )
                        .bind("start", startDate)
                        .bind("end", endDate)
                        .mapToMap()
                        .list()
        );
    }

    /**
     * Lấy thống kê khách hàng mới
     */
    public Map<String, Object> getCustomerStats(LocalDate startDate, LocalDate endDate) {
        return jdbi.withHandle(handle -> {
            Map<String, Object> stats = new HashMap<>();

            // Số khách hàng mới
            Integer newCustomers = handle.createQuery(
                            "SELECT COUNT(*) FROM users " +
                                    "WHERE role = 'user' " +
                                    "AND DATE(created_at) BETWEEN :start AND :end"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .mapTo(Integer.class)
                    .one();

            // Khách hàng có đơn hàng
            Integer activeCustomers = handle.createQuery(
                            "SELECT COUNT(DISTINCT user_id) FROM orders " +
                                    "WHERE DATE(order_date) BETWEEN :start AND :end"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .mapTo(Integer.class)
                    .one();

            stats.put("newCustomers", newCustomers);
            stats.put("activeCustomers", activeCustomers);

            return stats;
        });
    }

    /**
     * Lấy thống kê theo phương thức thanh toán
     */
    public List<Map<String, Object>> getPaymentMethodStats(LocalDate startDate, LocalDate endDate) {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT p.payment_method, " +
                                        "COUNT(*) as order_count, " +
                                        "COALESCE(SUM(p.amount), 0) as total_amount " +
                                        "FROM payments p " +
                                        "JOIN orders o ON p.order_id = o.id " +
                                        "WHERE o.order_date IS NOT NULL " +
                                        "AND DATE(o.order_date) BETWEEN :start AND :end " +
                                        "GROUP BY p.payment_method " +
                                        "ORDER BY total_amount DESC"
                        )
                        .bind("start", startDate)
                        .bind("end", endDate)
                        .mapToMap()
                        .list()
        );
    }

    /**
     * Lấy doanh thu theo tuần (7 ngày gần nhất)
     */
    public List<Map<String, Object>> getWeeklyRevenue() {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT DATE(order_date) as date, " +
                                        "DAYNAME(order_date) as day_name, " +
                                        "COALESCE(SUM(total_amount), 0) as revenue " +
                                        "FROM orders " +
                                        "WHERE order_date IS NOT NULL " +
                                        "AND order_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                                        "GROUP BY DATE(order_date), DAYNAME(order_date) " +
                                        "ORDER BY date ASC"
                        )
                        .mapToMap()
                        .list()
        );
    }

    /**
     * Lấy doanh thu theo tháng (12 tháng gần nhất)
     */
    public List<Map<String, Object>> getMonthlyRevenue() {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT YEAR(order_date) as year, " +
                                        "MONTH(order_date) as month, " +
                                        "DATE_FORMAT(order_date, '%Y-%m') as period, " +
                                        "COALESCE(SUM(total_amount), 0) as revenue, " +
                                        "COUNT(*) as order_count " +
                                        "FROM orders " +
                                        "WHERE order_date IS NOT NULL " +
                                        "AND order_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) " +
                                        "GROUP BY YEAR(order_date), MONTH(order_date) " +
                                        "ORDER BY year ASC, month ASC"
                        )
                        .mapToMap()
                        .list()
        );
    }

    /**
     * So sánh doanh thu với kỳ trước
     */
    public Map<String, Object> compareRevenue(LocalDate startDate, LocalDate endDate) {
        return jdbi.withHandle(handle -> {
            Map<String, Object> comparison = new HashMap<>();

            // Tính số ngày trong khoảng
            long daysBetween = java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;

            // Doanh thu kỳ hiện tại
            Double currentRevenue = handle.createQuery(
                            "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                                    "WHERE order_date IS NOT NULL " +
                                    "AND DATE(order_date) BETWEEN :start AND :end"
                    )
                    .bind("start", startDate)
                    .bind("end", endDate)
                    .mapTo(Double.class)
                    .one();

            // Doanh thu kỳ trước (cùng số ngày)
            LocalDate prevStart = startDate.minusDays(daysBetween);
            LocalDate prevEnd = startDate.minusDays(1);

            Double previousRevenue = handle.createQuery(
                            "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                                    "WHERE order_date IS NOT NULL " +
                                    "AND DATE(order_date) BETWEEN :start AND :end"
                    )
                    .bind("start", prevStart)
                    .bind("end", prevEnd)
                    .mapTo(Double.class)
                    .one();

            double changePercent = 0;
            if (previousRevenue > 0) {
                changePercent = ((currentRevenue - previousRevenue) / previousRevenue) * 100;
            }

            comparison.put("currentRevenue", currentRevenue);
            comparison.put("previousRevenue", previousRevenue);
            comparison.put("changePercent", changePercent);
            comparison.put("isIncrease", changePercent > 0);

            return comparison;
        });
    }

    /**
     * Lấy top khách hàng chi tiêu nhiều nhất
     */
    public List<Map<String, Object>> getTopCustomers(LocalDate startDate, LocalDate endDate, int limit) {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT u.id, u.username, u.full_name, u.email, " +
                                        "COUNT(o.id) as order_count, " +
                                        "COALESCE(SUM(o.total_amount), 0) as total_spent " +
                                        "FROM users u " +
                                        "JOIN orders o ON u.id = o.user_id " +
                                        "WHERE o.order_date IS NOT NULL " +
                                        "AND DATE(o.order_date) BETWEEN :start AND :end " +
                                        "GROUP BY u.id, u.username, u.full_name, u.email " +
                                        "ORDER BY total_spent DESC " +
                                        "LIMIT :limit"
                        )
                        .bind("start", startDate)
                        .bind("end", endDate)
                        .bind("limit", limit)
                        .mapToMap()
                        .list()
        );
    }
}