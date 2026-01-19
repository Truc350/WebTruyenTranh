package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.CloudinaryService;

import java.io.IOException;

// Thay đổi URL pattern thành /admin/add-series
@WebServlet(name = "AddSeriesServlet", urlPatterns = {"/admin/add-series", "/AddSeriesServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddSeriesServlet extends HttpServlet {

    private SeriesDAO seriesDAO;

    @Override
    public void init() throws ServletException {
        seriesDAO = new SeriesDAO();
        System.out.println("AddSeriesServlet initialized successfully!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("GET request to AddSeriesServlet - redirecting...");
        response.sendRedirect(request.getContextPath() + "/SeriesManagement");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Debug log
        System.out.println("========================================");
        System.out.println("AddSeriesServlet.doPost() được gọi!");
        System.out.println("Method: " + request.getMethod());
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Content Type: " + request.getContentType());
        System.out.println("========================================");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            String seriesName = request.getParameter("seriesName");
            String description = request.getParameter("seriesDescription");
            String status = request.getParameter("seriesStatus");
            String volumesParam = request.getParameter("seriesVolumes");

            System.out.println("Series Name: " + seriesName);
            System.out.println("Volumes: " + volumesParam);
            System.out.println("Status: " + status);

            if (seriesName == null || seriesName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên series không được để trống!");
            }

            if (volumesParam == null || volumesParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Số tập không được để trống!");
            }

            int totalVolumes = Integer.parseInt(volumesParam);

            if (totalVolumes <= 0) {
                throw new IllegalArgumentException("Số tập phải lớn hơn 0!");
            }

            // Kiểm tra tên series đã tồn tại chưa
            if (seriesDAO.isSeriesNameExistsExcludingId(seriesName, totalVolumes)) {
                System.err.println("Series name already exists: " + seriesName);
                request.getSession().setAttribute("errorMessage", "Tên series '" + seriesName + "' đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/SeriesManagement");
                return;
            }

            // Xử lý upload ảnh
            Part coverPart = request.getPart("seriesCover");
            String coverUrl = null;

            if (coverPart != null && coverPart.getSize() > 0) {
                System.out.println(" Uploading cover image...");
                try {
                    coverUrl = CloudinaryService.uploadImage(coverPart, "comics/series");
                    System.out.println(" Uploaded cover: " + coverUrl);
                } catch (IOException e) {
                    System.err.println(" Error uploading cover: " + e.getMessage());
                    e.printStackTrace();
                    request.getSession().setAttribute("errorMessage", "Lỗi khi upload ảnh: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/SeriesManagement");
                    return;
                }
            } else {
                System.out.println(" No cover image uploaded");
            }

            // Tạo đối tượng Series
            Series series = new Series();
            series.setSeriesName(seriesName);
            series.setDescription(description);
            series.setCoverUrl(coverUrl);
            series.setTotalVolumes(totalVolumes);
            series.setStatus(status);

            // Thêm vào database
            int newId = seriesDAO.addSeries(series);

            if (newId > 0) {
                System.out.println("Series added successfully with ID: " + newId);
                request.getSession().setAttribute("successMessage", "Thêm series thành công!");
            } else {
                System.err.println(" Failed to add series");
                request.getSession().setAttribute("errorMessage", "Thêm series thất bại!");
            }

        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "Số tập phải là số nguyên hợp lệ!");
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            System.err.println("Error adding series: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }

        // Redirect về trang quản lý series
        response.sendRedirect(request.getContextPath() + "/SeriesManagement");
    }
}