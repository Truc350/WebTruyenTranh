package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/SeriesManagement")
public class SeriesManagementServlet extends HttpServlet {

    private SeriesDAO seriesDAO;
    private static final int PAGE_SIZE = 5;

    @Override
    public void init() throws ServletException {
        seriesDAO = new SeriesDAO();
        System.out.println("SeriesManagementServlet initialized successfully!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("========================================");
        System.out.println("✅ SeriesManagementServlet.doGet() được gọi!");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("========================================");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy số trang hiện tại (mặc định là 1)
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            System.out.println("📄 Current page: " + currentPage);

            // Lấy từ khóa tìm kiếm
            String keyword = request.getParameter("keyword");
            if (keyword != null) {
                keyword = keyword.trim();
                if (keyword.isEmpty()) {
                    keyword = null;
                }
            }
            System.out.println("🔍 Keyword: " + (keyword != null ? "'" + keyword + "'" : "null"));

            // LẤY FILTER (mặc định là "all")
            String filterParam = request.getParameter("filter");
            if (filterParam == null || filterParam.trim().isEmpty()) {
                filterParam = "all";
            }
            System.out.println("🎯 Filter param: " + filterParam);

            Boolean isHidden = null;

            if ("visible".equals(filterParam)) {
                isHidden = false;  // is_hidden = 0
                System.out.println("🔍 Filter: VISIBLE (is_hidden = 0)");
            } else if ("hidden".equals(filterParam)) {
                isHidden = true;   // is_hidden = 1
                System.out.println("🔍 Filter: HIDDEN (is_hidden = 1)");
            } else {
                System.out.println("🔍 Filter: ALL (no filter)");
            }

            List<Series> seriesList;
            int totalSeries;

            // Xử lý tìm kiếm hoặc load thông thường
            if (keyword != null && !keyword.isEmpty()) {
                System.out.println("🔍 Mode: SEARCH with filter");
                // Tìm kiếm với filter
                seriesList = seriesDAO.searchSeriesByNameAndVisibility(keyword, isHidden);
                totalSeries = seriesList.size();

                System.out.println("📊 Search results: " + totalSeries + " series found");

                // Phân trang cho kết quả tìm kiếm
                int startIndex = (currentPage - 1) * PAGE_SIZE;
                int endIndex = Math.min(startIndex + PAGE_SIZE, totalSeries);

                if (startIndex < totalSeries && startIndex >= 0) {
                    seriesList = new ArrayList<>(seriesList.subList(startIndex, endIndex));
                    System.out.println("📊 Showing results from " + startIndex + " to " + endIndex);
                } else {
                    seriesList = new ArrayList<>();
                    System.out.println("⚠️ Start index out of range, returning empty list");
                }
            } else {
                // LOAD THÔNG THƯỜNG VỚI PHÂN TRANG
                System.out.println("📚 Mode: LOAD ALL with pagination and filter");
                seriesList = seriesDAO.getSeriesByVisibility(currentPage, PAGE_SIZE, isHidden);
                totalSeries = seriesDAO.countSeriesByVisibility(isHidden);

                System.out.println("📊 Total series in DB: " + totalSeries);
                System.out.println("📊 Series on this page: " + seriesList.size());
            }

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalSeries / PAGE_SIZE);
            if (totalPages == 0) totalPages = 1;

            // Đảm bảo currentPage không vượt quá totalPages
            if (currentPage > totalPages) {
                currentPage = totalPages;
            }

            System.out.println("📄 Total pages: " + totalPages);
            System.out.println("📄 Adjusted current page: " + currentPage);

            // Lấy message từ session
            String successMessage = (String) request.getSession().getAttribute("successMessage");
            String errorMessage = (String) request.getSession().getAttribute("errorMessage");

            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                request.getSession().removeAttribute("successMessage");
                System.out.println("✅ Success message: " + successMessage);
            }

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                request.getSession().removeAttribute("errorMessage");
                System.out.println("❌ Error message: " + errorMessage);
            }

            // Đưa dữ liệu vào request
            request.setAttribute("seriesList", seriesList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);
            request.setAttribute("filter", filterParam);

            System.out.println("✅ Request attributes set successfully");
            System.out.println("➡️ Forwarding to JSP");
            System.out.println("========================================");

            request.getRequestDispatcher("/fontend/admin/seriesManagement.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("========================================");
            System.err.println("❌ ERROR in doGet:");
            System.err.println("❌ Message: " + e.getMessage());
            e.printStackTrace();
            System.err.println("========================================");

            // Đảm bảo luôn có dữ liệu để hiển thị (tránh lỗi null)
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            request.setAttribute("seriesList", new ArrayList<Series>());
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("filter", "all");

//            request.getRequestDispatcher("/fontend/admin/seriesManagement.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("========================================");
        System.out.println("✅ SeriesManagementServlet.doPost() được gọi!");
        System.out.println("========================================");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        try {
            // Lấy action từ form (show/hide)
            String action = request.getParameter("action");
            String idParam = request.getParameter("id");

            System.out.println("🔧 Action: " + action);
            System.out.println("🔧 Series ID: " + idParam);

            if (idParam == null || idParam.isEmpty()) {
                System.err.println("❌ Missing series ID");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"Missing ID\"}");
                return;
            }

            if (action == null || action.isEmpty()) {
                System.err.println("❌ Missing action");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"Missing action\"}");
                return;
            }

            int seriesId = Integer.parseInt(idParam);

            boolean hidden = "hide".equals(action);
            boolean success = seriesDAO.updateSeriesVisibility(seriesId, hidden);

            if (success) {
                System.out.println("✅ Updated visibility for series " + seriesId + ": " + (hidden ? "hidden" : "visible"));
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true}");
            } else {
                System.err.println("❌ Failed to update visibility for series " + seriesId);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"error\": \"Update failed\"}");
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid series ID: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"error\": \"Invalid ID format\"}");
        } catch (Exception e) {
            System.err.println("❌ Error updating series visibility: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}

