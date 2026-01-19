package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleComicsDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@MultipartConfig
@WebServlet("/admin/manage-flashsale")
public class ManageFlashSaleServlet extends HttpServlet {

    private final FlashSaleDAO flashSaleDAO = new FlashSaleDAO();
    private final FlashSaleComicsDAO flashSaleComicsDAO = new FlashSaleComicsDAO();
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Hiển thị danh sách Flash Sale
        List<FlashSale> flashSales = flashSaleDAO.getAllFlashSales();
        request.setAttribute("flashSales", flashSales);
        request.setAttribute("timeFormatter", TIME_FORMATTER);

        request.getRequestDispatcher("/fontend/admin/flashSaleMan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");


        if ("delete".equals(action)) {
            handleDelete(request, response);
        }
        else if ("detail".equals(action)) {
            handleDetail(request, response);
        }
        else if ("update".equals(action)) {
            handleUpdate(request, response);
        }
        else {
            sendJsonResponse(response, false, "Action không hợp lệ!");
        }
    }

    /**
     * Xử lý update Flash Sale
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");

            LocalDateTime startTime = LocalDateTime.parse(startTimeStr);
            LocalDateTime endTime = LocalDateTime.parse(endTimeStr);

            String[] comicIdsArr = request.getParameterValues("comicIds");
            List<Integer> newComicIds = new ArrayList<>();
            if (comicIdsArr != null) {
                for (String cid : comicIdsArr) {
                    newComicIds.add(Integer.parseInt(cid));
                }
            }

            boolean updated = flashSaleDAO.updateFlashSale(id, name, discountPercent, startTime, endTime);

            if (!updated) {
                sendJsonResponse(response, false, "Không tìm thấy Flash Sale để cập nhật!");
                return;
            }

            flashSaleComicsDAO.deleteLinksByFlashSaleId(id);
            if (!newComicIds.isEmpty()) {
                flashSaleComicsDAO.insertLinks(id, newComicIds);
            }

            sendJsonResponse(response, true, "Cập nhật Flash Sale thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi server: " + e.getMessage());
        }
    }

    /**
     * Xử lý xóa Flash Sale
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            sendJsonResponse(response, false, "ID không được để trống!");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            boolean deleted = flashSaleDAO.deleteById(id);

            if (deleted) {
                sendJsonResponse(response, true, "Xóa Flash Sale thành công!");
            } else {
                sendJsonResponse(response, false, "Không tìm thấy Flash Sale hoặc xóa thất bại!");
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ!");
        }
    }

    /**
     * Xử lý xem chi tiết Flash Sale
     */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            sendJsonResponse(response, false, "ID không được để trống!");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            // Lấy thông tin Flash Sale
            FlashSale fs = flashSaleDAO.getById(id);
            if (fs == null) {
                sendJsonResponse(response, false, "Không tìm thấy Flash Sale!");
                return;
            }

            // Lấy danh sách comics áp dụng
            List<Map<String, Object>> comics = flashSaleComicsDAO.getComicsByFlashSaleId(id);

            // Tạo JSON response
            StringBuilder json = new StringBuilder();
            json.append("{\"success\":true,\"data\":{");
            json.append("\"id\":").append(fs.getId()).append(",");
            json.append("\"name\":\"").append(escapeJson(fs.getName())).append("\",");
            json.append("\"discountPercent\":").append(fs.getDiscountPercent()).append(",");
            json.append("\"startTime\":\"").append(fs.getStartTime().format(TIME_FORMATTER)).append("\",");
            json.append("\"endTime\":\"").append(fs.getEndTime().format(TIME_FORMATTER)).append("\",");
            json.append("\"status\":\"").append(fs.getStatus()).append("\",");
            json.append("\"comics\":[");

            // Thêm danh sách comics
            for (int i = 0; i < comics.size(); i++) {
                Map<String, Object> comic = comics.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"id\":").append(comic.get("id")).append(",");
                json.append("\"name\":\"").append(escapeJson((String) comic.get("name"))).append("\",");
                json.append("\"discount\":").append(comic.get("discount_percent"));
                json.append("}");
            }

            json.append("]}}");

            // Trả về JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi server: " + e.getMessage());
        }
    }

    /**
     * Gửi JSON response đơn giản
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = "{\"success\": " + success + ", \"message\": \"" + escapeJson(message) + "\"}";
        response.getWriter().write(json);
    }

    /**
     * Escape ký tự đặc biệt trong JSON
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}