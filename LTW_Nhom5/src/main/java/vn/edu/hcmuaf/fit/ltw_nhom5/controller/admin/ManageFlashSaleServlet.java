package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/manage-flashsale")
public class ManageFlashSaleServlet extends HttpServlet {

    private final FlashSaleDAO flashSaleDAO = new FlashSaleDAO();
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
            String idStr = request.getParameter("id");

            // Debug: In ra giá trị id nhận được từ request
            System.out.println("=== DEBUG DELETE === Action: " + action);
            System.out.println("ID nhận từ request: '" + idStr + "'");

            if (idStr == null || idStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "ID không được để trống!");
                return;
            }

            idStr = idStr.trim(); // loại bỏ space thừa

            try {
                int id = Integer.parseInt(idStr);
                System.out.println("ID sau parse: " + id);

                boolean deleted = flashSaleDAO.deleteById(id);

                sendJsonResponse(response, deleted, deleted
                        ? "Xóa Flash Sale thành công!"
                        : "Không tìm thấy Flash Sale hoặc xóa thất bại!");
            } catch (NumberFormatException e) {
                System.out.println("Lỗi parse ID: " + e.getMessage());
                sendJsonResponse(response, false, "ID không hợp lệ! Giá trị nhận: '" + idStr + "'");
            }
        } else {
            sendJsonResponse(response, false, "Action không hợp lệ!");
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = "{\"success\": " + success + ", \"message\": \"" + message + "\"}";
        response.getWriter().write(json);
    }
}