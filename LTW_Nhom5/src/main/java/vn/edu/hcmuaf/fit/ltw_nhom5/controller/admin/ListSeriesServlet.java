package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/series/list")
public class ListSeriesServlet extends HttpServlet {

    private SeriesDAO seriesDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        System.out.println("🔧 Initializing ListSeriesServlet...");
        seriesDAO = new SeriesDAO();
        gson = new Gson();
        System.out.println("✅ ListSeriesServlet initialized!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        try {
            System.out.println("📚 Getting all series...");

            List<Series> seriesList = seriesDAO.getAllSeries();

            if (seriesList == null || seriesList.isEmpty()) {
                System.out.println("⚠️ No series found");
                result.put("success", true);
                result.put("series", new ArrayList<>());
                result.put("message", "Chưa có bộ truyện nào");
            } else {
                // Chuyển đổi sang DTO
                List<Map<String, Object>> seriesDataList = new ArrayList<>();

                for (Series series : seriesList) {
                    Map<String, Object> seriesData = new HashMap<>();
                    seriesData.put("id", series.getId());
                    seriesData.put("seriesName", series.getSeriesName());
                    seriesData.put("description", series.getDescription());
                    seriesData.put("totalVolumes", series.getTotalVolumes());
                    seriesData.put("status", series.getStatus());
                    seriesDataList.add(seriesData);
                }

                result.put("success", true);
                result.put("series", seriesDataList);
                System.out.println("✅ Found " + seriesList.size() + " series");
            }

        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(gson.toJson(result));
        response.getWriter().flush();
    }
}