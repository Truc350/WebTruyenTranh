package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleComicsDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.annotation.MultipartConfig;

@MultipartConfig
@WebServlet("/admin/create-flashsale")
public class CreateFlashSaleServlet extends HttpServlet {

    private final FlashSaleDAO flashSaleDAO = new FlashSaleDAO();
    private final FlashSaleComicsDAO flashSaleComicsDAO = new FlashSaleComicsDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        System.out.println("=== CREATE FLASHSALE ĐÃ CHẠY PHIÊN BẢN MỚI ===");
        System.out.println("Tên nhận được: '" + req.getParameter("flashSaleName") + "'");


        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonObject responseJson = new JsonObject();

        try {
            // SỬA CHÍNH TẠI ĐÂY: Lấy đúng tên parameter từ HTML (flashSaleName)
            String name = req.getParameter("flashSaleName");
            String startTimeStr = req.getParameter("startTime");
            String endTimeStr = req.getParameter("endTime");

            // Xử lý comicIds null
            String[] comicIdArray = req.getParameterValues("comicIds");
            if (comicIdArray == null) {
                comicIdArray = new String[0];
            }

            // Validate
            if (name == null || name.trim().isEmpty()) {
                responseJson.addProperty("success", false);
                responseJson.addProperty("message", "Tên Flash Sale không được để trống");
                resp.getWriter().write(responseJson.toString());
                return;
            }

            if (startTimeStr == null || startTimeStr.isEmpty() ||
                    endTimeStr == null || endTimeStr.isEmpty()) {
                responseJson.addProperty("success", false);
                responseJson.addProperty("message", "Vui lòng chọn giờ bắt đầu và kết thúc");
                resp.getWriter().write(responseJson.toString());
                return;
            }

            if (comicIdArray.length == 0) {
                responseJson.addProperty("success", false);
                responseJson.addProperty("message", "Vui lòng chọn ít nhất một truyện");
                resp.getWriter().write(responseJson.toString());
                return;
            }

            LocalDateTime startTime = LocalDateTime.parse(startTimeStr);
            LocalDateTime endTime = LocalDateTime.parse(endTimeStr);

            if (endTime.isBefore(startTime) || endTime.equals(startTime)) {
                responseJson.addProperty("success", false);
                responseJson.addProperty("message", "Giờ kết thúc phải sau giờ bắt đầu");
                resp.getWriter().write(responseJson.toString());
                return;
            }

            FlashSale flashSale = new FlashSale();
            flashSale.setName(name.trim());
            flashSale.setDiscountPercent(null);
            flashSale.setStartTime(startTime);
            flashSale.setEndTime(endTime);

            int flashSaleId = flashSaleDAO.insert(flashSale);

            List<Integer> comicIdList = new ArrayList<>();
            for (String idStr : comicIdArray) {
                try {
                    comicIdList.add(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException ignored) {}
            }

            flashSaleComicsDAO.insertLinks(flashSaleId, comicIdList);

            responseJson.addProperty("success", true);
            responseJson.addProperty("message", "Tạo Flash Sale thành công!");
            responseJson.addProperty("flashSaleId", flashSaleId);

        } catch (Exception e) {
            e.printStackTrace();
            responseJson.addProperty("success", false);
            responseJson.addProperty("message", "Lỗi server: " + e.getMessage());
        }

        resp.getWriter().write(responseJson.toString());
    }
}