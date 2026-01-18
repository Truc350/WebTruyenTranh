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
    private static final DateTimeFormatter TIME_FORMATTER =
            DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("SERVLET MANAGE FLASHSALE DA DUOC GOI");  // không dấu
        System.out.println("Duong dan forward: /fontend/admin/flashSaleMan.jsp");

        List<FlashSale> flashSales = flashSaleDAO.getAllFlashSales();

        System.out.println("So luong Flash Sale tu DB: " + flashSales.size());

        request.setAttribute("flashSaleCount", flashSales.size());
        request.setAttribute("flashSales", flashSales);
        request.setAttribute("timeFormatter", TIME_FORMATTER);

        request.getRequestDispatcher("/fontend/admin/flashSaleMan.jsp")
                .forward(request, response);
    }
}