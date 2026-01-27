package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ReportDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;

@WebServlet(name = "ReportServlet", urlPatterns = {"/ReportManagement"})
public class ReportServlet extends HttpServlet {
    private ReportDAO reportDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        reportDAO = new ReportDAO();
        gson = new Gson();
        System.out.println("✅ ReportServlet initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🔍 ReportServlet doGet called");

        String action = request.getParameter("action");
        System.out.println("📝 Action: " + action);

        if (action == null) {
            // Load trang report với dữ liệu mặc định
            loadDefaultReport(request, response);
        } else {
            // Xử lý các action Ajax
            handleAjaxRequest(request, response, action);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("filterByDateRange".equals(action)) {
            filterByDateRange(request, response);
        } else if ("exportReport".equals(action)) {
            exportReport(request, response);
        }
    }

    /**
     * Load báo cáo mặc định (hôm nay)
     */
    private void loadDefaultReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("📊 Loading default report...");

            LocalDate today = LocalDate.now();
            System.out.println("📅 Date: " + today);

            // Lấy thống kê tổng quan
            Map<String, Object> overview = reportDAO.getOverviewStats(today, today);
            System.out.println("✅ Overview loaded: " + overview);

            // Lấy top sản phẩm
            List<Map<String, Object>> topProducts = reportDAO.getTopSellingProducts(today, today, 10);
            System.out.println("✅ Top products count: " + topProducts.size());

            // Lấy doanh thu 7 ngày gần nhất
            List<Map<String, Object>> weeklyRevenue = reportDAO.getWeeklyRevenue();
            System.out.println("✅ Weekly revenue loaded: " + weeklyRevenue.size() + " records");

            // Đưa dữ liệu vào request
            request.setAttribute("overview", overview);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("revenueData", weeklyRevenue);
            request.setAttribute("currentPeriod", "today");

            // Forward đến JSP
            String jspPath = "/fontend/admin/report.jsp";
            System.out.println("🔄 Forwarding to: " + jspPath);

            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            if (dispatcher != null) {
                dispatcher.forward(request, response);
            } else {
                System.err.println("❌ Dispatcher is null for path: " + jspPath);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "JSP not found: " + jspPath);
            }

        } catch (Exception e) {
            System.err.println("❌ Error in loadDefaultReport:");
            e.printStackTrace();

            // Gửi error response
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h1>Error Loading Report</h1>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
            response.getWriter().println("<pre>");
            e.printStackTrace(response.getWriter());
            response.getWriter().println("</pre>");
            response.getWriter().println("</body></html>");
        }
    }

    /**
     * Xử lý Ajax requests
     */
    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response, String action)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        Map<String, Object> result = new HashMap<>();

        try {
            System.out.println("🔄 Processing Ajax action: " + action);

            switch (action) {
                case "getOverview":
                    result = getOverviewData(request);
                    break;
                case "getRevenueChart":
                    result.put("data", getRevenueChartData(request));
                    break;
                case "getTopProducts":
                    result.put("data", getTopProductsData(request));
                    break;
                case "getCategoryStats":
                    result.put("data", getCategoryStatsData(request));
                    break;
                case "getPaymentStats":
                    result.put("data", getPaymentStatsData(request));
                    break;
                default:
                    result.put("success", false);
                    result.put("message", "Unknown action: " + action);
            }

            result.putIfAbsent("success", true);
            System.out.println("✅ Ajax response prepared");

        } catch (Exception e) {
            System.err.println("❌ Error in handleAjaxRequest:");
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

    /**
     * Lấy dữ liệu tổng quan
     */
    private Map<String, Object> getOverviewData(HttpServletRequest request) {
        DateRange dateRange = getDateRange(request);
        Map<String, Object> overview = reportDAO.getOverviewStats(
                dateRange.startDate, dateRange.endDate
        );

        // Thêm so sánh với kỳ trước
        Map<String, Object> comparison = reportDAO.compareRevenue(
                dateRange.startDate, dateRange.endDate
        );

        overview.put("comparison", comparison);

        return overview;
    }

    /**
     * Lấy dữ liệu biểu đồ doanh thu
     */
    private List<Map<String, Object>> getRevenueChartData(HttpServletRequest request) {
        DateRange dateRange = getDateRange(request);
        return reportDAO.getDailyRevenue(dateRange.startDate, dateRange.endDate);
    }

    /**
     * Lấy dữ liệu top sản phẩm
     */
    private List<Map<String, Object>> getTopProductsData(HttpServletRequest request) {
        DateRange dateRange = getDateRange(request);
        int limit = Integer.parseInt(request.getParameter("limit") != null ?
                request.getParameter("limit") : "10");

        return reportDAO.getTopSellingProducts(dateRange.startDate, dateRange.endDate, limit);
    }

    /**
     * Lấy thống kê theo thể loại
     */
    private List<Map<String, Object>> getCategoryStatsData(HttpServletRequest request) {
        DateRange dateRange = getDateRange(request);
        return reportDAO.getRevenueByCategory(dateRange.startDate, dateRange.endDate);
    }

    /**
     * Lấy thống kê phương thức thanh toán
     */
    private List<Map<String, Object>> getPaymentStatsData(HttpServletRequest request) {
        DateRange dateRange = getDateRange(request);
        return reportDAO.getPaymentMethodStats(dateRange.startDate, dateRange.endDate);
    }

    /**
     * Lọc theo khoảng thời gian
     */
    private void filterByDateRange(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DateRange dateRange = getDateRange(request);

        // Lấy dữ liệu theo khoảng thời gian
        Map<String, Object> overview = reportDAO.getOverviewStats(
                dateRange.startDate, dateRange.endDate
        );
        List<Map<String, Object>> topProducts = reportDAO.getTopSellingProducts(
                dateRange.startDate, dateRange.endDate, 10
        );
        List<Map<String, Object>> revenueData = reportDAO.getDailyRevenue(
                dateRange.startDate, dateRange.endDate
        );

        request.setAttribute("overview", overview);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("revenueData", revenueData);
        request.setAttribute("startDate", dateRange.startDate.toString());
        request.setAttribute("endDate", dateRange.endDate.toString());

        request.getRequestDispatcher("/fontend/admin/report.jsp").forward(request, response);
    }

    /**
     * Export báo cáo
     */
    private void exportReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", "Export feature coming soon");

        response.getWriter().write(gson.toJson(result));
    }

    /**
     * Lấy khoảng thời gian từ request
     */
    private DateRange getDateRange(HttpServletRequest request) {
        String period = request.getParameter("period");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        LocalDate startDate;
        LocalDate endDate = LocalDate.now();

        if (startDateStr != null && endDateStr != null) {
            // Custom date range
            startDate = LocalDate.parse(startDateStr);
            endDate = LocalDate.parse(endDateStr);
        } else if (period != null) {
            // Predefined periods
            switch (period) {
                case "today":
                    startDate = LocalDate.now();
                    endDate = LocalDate.now();
                    break;
                case "week":
                    startDate = LocalDate.now().minusDays(6);
                    break;
                case "month":
                    startDate = LocalDate.now().minusDays(29);
                    break;
                case "year":
                    startDate = LocalDate.now().minusYears(1);
                    break;
                default:
                    startDate = LocalDate.now();
            }
        } else {
            startDate = LocalDate.now();
        }

        return new DateRange(startDate, endDate);
    }

    /**
     * Helper class cho date range
     */
    private static class DateRange {
        LocalDate startDate;
        LocalDate endDate;

        DateRange(LocalDate startDate, LocalDate endDate) {
            this.startDate = startDate;
            this.endDate = endDate;
        }
    }
}