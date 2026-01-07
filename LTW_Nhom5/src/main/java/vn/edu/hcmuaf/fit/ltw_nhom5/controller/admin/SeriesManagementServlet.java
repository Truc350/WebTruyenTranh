package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import java.io.IOException;
import java.util.List;

@WebServlet("/SeriesManagement")
public class SeriesManagementServlet extends HttpServlet {
    private SeriesDAO seriesDAO;

    @Override
    public void init() throws ServletException {
        seriesDAO = new SeriesDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 8; // số series mỗi trang

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        SeriesDAO dao = new SeriesDAO();
        List<Series> seriesList = dao.getSeriesByPage(page, pageSize);
        int totalSeries = dao.countSeries();
        int totalPages = (int) Math.ceil((double) totalSeries / pageSize);

        request.setAttribute("seriesList", seriesList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("fontend/admin/seriesManagement.jsp").forward(request, response);
    }

}
