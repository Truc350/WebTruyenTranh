package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/series-detail")
public class SeriesDetailServlet extends HttpServlet {
    private SeriesDAO seriesDAO;
    private ComicDAO comicDAO;

    @Override
    public void init() throws ServletException {
        seriesDAO = new SeriesDAO();
        comicDAO = new ComicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy series ID từ parameter
            String seriesIdParam = request.getParameter("id");

            if (seriesIdParam == null || seriesIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            int seriesId = Integer.parseInt(seriesIdParam);

            // Lấy thông tin series
            Optional<Series> seriesOptional = seriesDAO.getSeriesById(seriesId);

            if (!seriesOptional.isPresent()) {
                request.getSession().setAttribute("errorMsg", "Không tìm thấy series");
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            Series series = seriesOptional.get();

            // Kiểm tra series có bị ẩn không
            if (series.isHidden()) {
                request.getSession().setAttribute("errorMsg", "Series này hiện không khả dụng");
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            // Lấy danh sách comic thuộc series này
            List<Comic> comicsInSeries = comicDAO.getComicsBySeriesId(seriesId);

            // Set attributes để hiển thị
            request.setAttribute("series", series);
            request.setAttribute("comicsInSeries", comicsInSeries);
            request.setAttribute("totalComics", comicsInSeries.size());

            // Forward đến trang SeriComic.jsp
            request.getRequestDispatcher("/fontend/public/SeriComic.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "ID series không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Có lỗi xảy ra khi tải thông tin series");
            response.sendRedirect(request.getContextPath() + "/");
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}