package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.VoucherDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Voucher;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin/vouchersManagement")
public class VoucherDisplay extends HttpServlet {
    private VoucherDao voucherDao;

    @Override
    public void init() throws ServletException {
        voucherDao = new VoucherDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Voucher> allVouchers = voucherDao.getAllVouchers();
        request.setAttribute("allVouchers", allVouchers);
        request.getRequestDispatcher("/fontend/admin/promotion.jsp")
                .forward(request, response);
    }


}