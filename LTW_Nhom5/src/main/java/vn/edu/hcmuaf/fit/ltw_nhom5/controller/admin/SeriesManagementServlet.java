
package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SeriesManagement", urlPatterns = {"/SeriesManagement", "/admin/series"})
public class SeriesManagementServlet extends HttpServlet {

    private SeriesDAO seriesDAO;
    private static final int PAGE_SIZE = 5;

    @Override
    public void init() throws ServletException {
        seriesDAO = new SeriesDAO();
        System.out.println("✅ SeriesManagementServlet initialized successfully!");
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
            // Lấy số trang hiện tại
            String pageParam = request.getParameter("page");
            int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;

            // Lấy từ khóa tìm kiếm
            String keyword = request.getParameter("keyword");

            // LẤY FILTER
            String filterParam = request.getParameter("filter");
            Boolean isHidden = null;

            if ("visible".equals(filterParam)) {
                isHidden = false;  // is_hidden = 0
                System.out.println("🔍 Filter: VISIBLE (is_hidden = 0)");
            } else if ("hidden".equals(filterParam)) {
                isHidden = true;   // is_hidden = 1
                System.out.println("🔍 Filter: HIDDEN (is_hidden = 1)");
            } else {
                System.out.println("🔍 Filter: ALL");
            }

            List<Series> seriesList;
            int totalSeries;

            if (keyword != null && !keyword.trim().isEmpty()) {
                System.out.println("🔍 Searching for: '" + keyword + "' with filter");
                // Tìm kiếm với filter
                seriesList = seriesDAO.searchSeriesByNameAndVisibility(keyword.trim(), isHidden);
                totalSeries = seriesList.size();
            } else {
                // Lấy với filter và phân trang
                System.out.println("📚 Loading series with filter and pagination");
                seriesList = seriesDAO.getSeriesByVisibility(currentPage, PAGE_SIZE, isHidden);
                totalSeries = seriesDAO.countSeriesByVisibility(isHidden);
            }

            System.out.println("📊 Found " + seriesList.size() + " series on this page");
            System.out.println("📊 Total series: " + totalSeries);

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalSeries / PAGE_SIZE);
            if (totalPages == 0) totalPages = 1;

            System.out.println("📄 Total pages: " + totalPages);

            // Lấy message từ session
            String successMessage = (String) request.getSession().getAttribute("successMessage");
            String errorMessage = (String) request.getSession().getAttribute("errorMessage");

            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                request.getSession().removeAttribute("successMessage");
            }

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                request.getSession().removeAttribute("errorMessage");
            }

            // Đưa dữ liệu vào request
            request.setAttribute("seriesList", seriesList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);

            System.out.println("➡️ Forwarding to JSP");
            request.getRequestDispatcher("/fontend/admin/seriesManagement.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/fontend/admin/seriesManagement.jsp").forward(request, response);
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

        try {
            // Lấy action từ form (show/hide)
            String action = request.getParameter("action");
            String idParam = request.getParameter("id");

            System.out.println("🔧 Action: " + action);
            System.out.println("🔧 Series ID: " + idParam);

            if (idParam == null || idParam.isEmpty()) {
                System.err.println("❌ Missing series ID");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
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
                response.getWriter().write("{\"success\": false}");
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid series ID: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"error\": \"Invalid ID\"}");
        } catch (Exception e) {
            System.err.println("❌ Error updating series visibility: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}