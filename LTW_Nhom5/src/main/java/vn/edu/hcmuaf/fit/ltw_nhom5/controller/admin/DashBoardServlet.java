package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.StatisticsDAO;
import com.google.gson.Gson;

import java.io.IOException;
import java.time.LocalDate;
import java.time.Year;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class DashBoardServlet extends HttpServlet {
    private StatisticsDAO statisticsDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        statisticsDAO = new StatisticsDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("filter".equals(action)) {
            handleFilter(request, response);
        } else if ("chartData".equals(action)) {
            handleChartData(request, response);
        } else {
            // Mặc định hiển thị thống kê tháng hiện tại
            LocalDate today = LocalDate.now();
            LocalDate monthStart = today.withDayOfMonth(1);
            LocalDate monthEnd = today.withDayOfMonth(today.lengthOfMonth());
            displayDashboard(request, response, "month", monthStart, monthEnd);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Hiển thị dashboard với thống kê theo khoảng thời gian
     */
    private void displayDashboard(HttpServletRequest request, HttpServletResponse response,
                                  String period, LocalDate startDate, LocalDate endDate)
            throws ServletException, IOException {

        Map<String, Object> stats = statisticsDAO.getCustomStats(startDate, endDate);

        // Lấy top 10 sản phẩm bán chạy theo khoảng thời gian đã chọn
        List<Map<String, Object>> topProducts =
                statisticsDAO.getTopSellingComics(startDate, endDate, 10);

        // Lấy dữ liệu biểu đồ phù hợp với khoảng thời gian
        List<Map<String, Object>> chartData = getChartData(period, startDate, endDate);

        request.setAttribute("stats", stats);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("chartData", gson.toJson(chartData));
        request.setAttribute("chartType", getChartType(period));
        request.setAttribute("currentPeriod", period);

        request.getRequestDispatcher("/fontend/admin/dashboard.jsp")
                .forward(request, response);
    }

    /**
     * Xử lý lọc theo khoảng thời gian
     */
    private void handleFilter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String period = request.getParameter("period");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        LocalDate startDate;
        LocalDate endDate;

        if ("custom".equals(period) && startDateStr != null && endDateStr != null) {
            // Lọc theo khoảng thời gian tùy chỉnh
            startDate = LocalDate.parse(startDateStr);
            endDate = LocalDate.parse(endDateStr);

            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);
        } else {
            // Lọc theo hôm nay/tuần/tháng/năm
            LocalDate today = LocalDate.now();
            switch (period) {
                case "today":
                    startDate = today;
                    endDate = today;
                    break;
                case "week":
                    startDate = today.minusDays(today.getDayOfWeek().getValue() - 1);
                    endDate = startDate.plusDays(6);
                    break;
                case "year":
                    startDate = today.withDayOfYear(1);
                    endDate = today.withDayOfYear(today.lengthOfYear());
                    break;
                default: // month
                    startDate = today.withDayOfMonth(1);
                    endDate = today.withDayOfMonth(today.lengthOfMonth());
                    break;
            }
        }

        // Hiển thị dashboard với khoảng thời gian đã tính
        displayDashboard(request, response, period, startDate, endDate);
    }

    /**
     * Lấy dữ liệu biểu đồ phù hợp với loại thời gian
     */
    private List<Map<String, Object>> getChartData(String period, LocalDate startDate, LocalDate endDate) {
        switch (period) {
            case "today":
                // Hiển thị doanh thu theo giờ trong ngày (nếu có data)
                return statisticsDAO.getDailyRevenue(startDate, endDate);
            case "week":
            case "custom":
                // Hiển thị doanh thu theo ngày
                return statisticsDAO.getDailyRevenue(startDate, endDate);
            case "month":
                // Hiển thị doanh thu theo ngày trong tháng
                return statisticsDAO.getDailyRevenue(startDate, endDate);
            case "year":
                // Hiển thị doanh thu theo 12 tháng
                return statisticsDAO.getRevenueByMonth(startDate.getYear());
            default:
                return statisticsDAO.getRevenueByMonth(Year.now().getValue());
        }
    }

    /**
     * Xác định loại biểu đồ cần hiển thị
     */
    private String getChartType(String period) {
        switch (period) {
            case "today":
            case "week":
            case "custom":
            case "month":
                return "daily";
            case "year":
                return "monthly";
            default:
                return "monthly";
        }
    }

    /**
     * API trả về dữ liệu biểu đồ dạng JSON
     */
    private void handleChartData(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String chartType = request.getParameter("type");
        int year = request.getParameter("year") != null ?
                Integer.parseInt(request.getParameter("year")) :
                Year.now().getValue();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if ("monthly".equals(chartType)) {
            List<Map<String, Object>> data = statisticsDAO.getRevenueByMonth(year);
            response.getWriter().write(gson.toJson(data));
        }
    }
}