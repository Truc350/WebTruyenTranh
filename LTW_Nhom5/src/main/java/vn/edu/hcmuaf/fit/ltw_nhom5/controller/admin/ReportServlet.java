package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ReportDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;

@WebServlet(name = "ReportServlet", urlPatterns = {"/admin/ReportManagement", "/admin/report-data"})
public class ReportServlet extends HttpServlet {
    private ReportDAO reportDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        reportDAO = new ReportDAO();
        gson = new Gson();
        System.out.println("✅ ReportServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        System.out.println("🔍 Request path: " + path);

        // ✅ Nếu truy cập /admin/ReportManagement → Forward đến JSP
        if ("/admin/ReportManagement".equals(path)) {
            System.out.println("📄 Forwarding to report.jsp");
            request.getRequestDispatcher("/fontend/admin/report.jsp").forward(request, response);
            return;
        }

        // ✅ Nếu truy cập /admin/report-data → Trả JSON
        if ("/admin/report-data".equals(path)) {
            System.out.println("📊 Handling report-data JSON request");
            handleReportData(request, response);
            return;
        }
    }

    /**
     * Xử lý request lấy dữ liệu JSON
     */
    private void handleReportData(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String filter = request.getParameter("filter");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        LocalDate startDate;
        LocalDate endDate;

        // ✅ FIX: Xử lý filter đúng
        if ("custom".equals(filter) && startDateStr != null && endDateStr != null) {
            startDate = LocalDate.parse(startDateStr);
            endDate = LocalDate.parse(endDateStr);
        } else if ("week".equals(filter)) {
            startDate = LocalDate.now().minusDays(6);
            endDate = LocalDate.now();
        } else if ("month".equals(filter)) {
            startDate = LocalDate.now().minusDays(29);
            endDate = LocalDate.now();
        } else { // today

            startDate = LocalDate.now();
            endDate = LocalDate.now();
        }

        System.out.println("📅 Filter: " + filter);
        System.out.println("📅 Date range: " + startDate + " to " + endDate);

        try {
            // Lấy dữ liệu
            Map<String, Object> result = new HashMap<>();

            // 1. KPI data
            Map<String, Object> kpi = reportDAO.getOverviewStats(startDate, endDate);
            result.put("kpi", kpi);
            System.out.println("✅ KPI loaded: " + kpi);

            // 2. Top products
            List<Map<String, Object>> topProducts = reportDAO.getTopSellingProducts(startDate, endDate, 3);
            result.put("topProducts", topProducts);
            System.out.println("✅ Top products count: " + topProducts.size());

            // 3. Chart data
            List<Map<String, Object>> dailyData = reportDAO.getDailyRevenue(startDate, endDate);
            System.out.println("✅ Daily data count: " + dailyData.size());

            Map<String, Object> chartData = new HashMap<>();

            // Prepare chart data
            List<String> labels = new ArrayList<>();
            List<Double> revenueData = new ArrayList<>();
            List<Integer> ordersData = new ArrayList<>();
            List<Double> avgValueData = new ArrayList<>();

            for (Map<String, Object> day : dailyData) {
                String dateStr = day.get("date").toString();
                labels.add(dateStr);

                Double revenue = day.get("revenue") != null ?
                        ((Number) day.get("revenue")).doubleValue() : 0.0;
                Integer orderCount = day.get("order_count") != null ?
                        ((Number) day.get("order_count")).intValue() : 0;

                revenueData.add(revenue);
                ordersData.add(orderCount);
                avgValueData.add(orderCount > 0 ? revenue / orderCount : 0.0);

                System.out.println("📊 " + dateStr + " - Revenue: " + revenue + ", Orders: " + orderCount);
            }

            // Revenue chart
            Map<String, Object> revenueChart = new HashMap<>();
            revenueChart.put("labels", labels);
            revenueChart.put("data", revenueData);

            // Orders chart
            Map<String, Object> ordersChart = new HashMap<>();
            ordersChart.put("labels", labels);
            ordersChart.put("data", ordersData);

            // Avg value chart
            Map<String, Object> avgValueChart = new HashMap<>();
            avgValueChart.put("labels", labels);
            avgValueChart.put("data", avgValueData);

            chartData.put("revenue", revenueChart);
            chartData.put("orders", ordersChart);
            chartData.put("avgValue", avgValueChart);

            result.put("chartData", chartData);

            String jsonResponse = gson.toJson(result);
            System.out.println("📤 Response: " + jsonResponse);

            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            System.err.println("❌ Error in handleReportData:");
            e.printStackTrace();

            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("error", true);
            errorResult.put("message", e.getMessage());

            response.getWriter().write(gson.toJson(errorResult));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}