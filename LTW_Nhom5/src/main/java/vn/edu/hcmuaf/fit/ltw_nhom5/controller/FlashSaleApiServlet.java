package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleComicsDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.FlashSaleService;

import java.io.IOException;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/flash-sale/*")
public class FlashSaleApiServlet extends HttpServlet {

    private final FlashSaleDAO flashSaleDAO = new FlashSaleDAO();
    private final FlashSaleComicsDAO flashSaleComicsDAO = new FlashSaleComicsDAO();
    private final FlashSaleService flashSaleService = new FlashSaleService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            sendErrorResponse(resp, "Invalid request");
            return;
        }

        // Parse path: /api/flash-sale/{id}/comics
        String[] parts = pathInfo.split("/");

        if (parts.length < 2) {
            sendErrorResponse(resp, "Flash Sale ID is required");
            return;
        }

        try {
            int flashSaleId = Integer.parseInt(parts[1]);

            // Kiểm tra endpoint
            if (parts.length >= 3 && "comics".equals(parts[2])) {
                // Endpoint: /api/flash-sale/{id}/comics
                getFlashSaleComics(flashSaleId, resp);
            } else {
                // Endpoint: /api/flash-sale/{id}
                getFlashSaleDetail(flashSaleId, resp);
            }

        } catch (NumberFormatException e) {
            sendErrorResponse(resp, "Invalid Flash Sale ID");
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(resp, "Server error: " + e.getMessage());
        }
    }

    /**
     * Lấy thông tin Flash Sale và danh sách comics ĐỘC QUYỀN
     * CHỈ HIỂN THỊ comics nếu Flash Sale này có discount CAO NHẤT
     */
    private void getFlashSaleComics(int flashSaleId, HttpServletResponse resp) throws IOException {
        // Cập nhật status trước
        flashSaleDAO.updateStatuses();

        // Lấy thông tin Flash Sale
        FlashSale flashSale = flashSaleDAO.getById(flashSaleId);

        if (flashSale == null) {
            sendErrorResponse(resp, "Flash Sale not found");
            return;
        }

        // ✅ ĐỔI TỪ getComicsForFlashSale THÀNH getExclusiveComicsForFlashSale
        List<Map<String, Object>> comics = flashSaleService.getExclusiveComicsForFlashSale(flashSaleId);

        // Tạo response
        Map<String, Object> data = new HashMap<>();

        // Thông tin Flash Sale
        Map<String, Object> flashSaleInfo = new HashMap<>();
        flashSaleInfo.put("id", flashSale.getId());
        flashSaleInfo.put("name", flashSale.getName());
        flashSaleInfo.put("discountPercent", flashSale.getDiscountPercent());
        flashSaleInfo.put("status", flashSale.getStatus());
        flashSaleInfo.put("startTime", flashSale.getStartTime().toString());
        flashSaleInfo.put("endTime", flashSale.getEndTime().toString());

        // Thêm timestamps cho countdown
        long startTimeMillis = flashSale.getStartTime()
                .atZone(ZoneId.systemDefault())
                .toInstant()
                .toEpochMilli();
        long endTimeMillis = flashSale.getEndTime()
                .atZone(ZoneId.systemDefault())
                .toInstant()
                .toEpochMilli();

        flashSaleInfo.put("startTimeMillis", startTimeMillis);
        flashSaleInfo.put("endTimeMillis", endTimeMillis);

        data.put("flashSale", flashSaleInfo);
        data.put("comics", comics);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", data);

        resp.getWriter().write(gson.toJson(response));

        System.out.println("✅ API Response for Flash Sale ID " + flashSaleId +
                " '" + flashSale.getName() + "' (" + flashSale.getDiscountPercent() + "%)" +
                " (Status: " + flashSale.getStatus() + ") with " + comics.size() + " EXCLUSIVE comics");
    }

    /**
     * Lấy thông tin chi tiết Flash Sale
     * API: GET /api/flash-sale/{id}
     */
    private void getFlashSaleDetail(int flashSaleId, HttpServletResponse resp) throws IOException {
        FlashSale flashSale = flashSaleDAO.getById(flashSaleId);

        if (flashSale == null) {
            sendErrorResponse(resp, "Flash Sale not found");
            return;
        }

        Map<String, Object> flashSaleInfo = new HashMap<>();
        flashSaleInfo.put("id", flashSale.getId());
        flashSaleInfo.put("name", flashSale.getName());
        flashSaleInfo.put("discountPercent", flashSale.getDiscountPercent());
        flashSaleInfo.put("status", flashSale.getStatus());
        flashSaleInfo.put("startTime", flashSale.getStartTime().toString());
        flashSaleInfo.put("endTime", flashSale.getEndTime().toString());

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", flashSaleInfo);

        resp.getWriter().write(gson.toJson(response));
    }

    /**
     * Gửi error response
     */
    private void sendErrorResponse(HttpServletResponse resp, String message) throws IOException {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);

        resp.getWriter().write(gson.toJson(response));
    }
}