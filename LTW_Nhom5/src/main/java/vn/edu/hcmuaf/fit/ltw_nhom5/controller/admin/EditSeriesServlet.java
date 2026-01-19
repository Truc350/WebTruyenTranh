
package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.CloudinaryService;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "EditSeriesServlet", urlPatterns = {"/EditSeriesServlet", "/admin/edit-series"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class EditSeriesServlet extends HttpServlet {

    private SeriesDAO seriesDAO;

    @Override
    public void init() throws ServletException {
        seriesDAO = new SeriesDAO();
        System.out.println("✅ EditSeriesServlet initialized successfully!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("⚠️ GET request to EditSeriesServlet - redirecting...");
        response.sendRedirect(request.getContextPath() + "/SeriesManagement");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Debug log
        System.out.println("========================================");
        System.out.println("✅ EditSeriesServlet.doPost() được gọi!");
        System.out.println("Method: " + request.getMethod());
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Content Type: " + request.getContentType());
        System.out.println("========================================");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy ID series cần sửa
            String seriesIdParam = request.getParameter("seriesId");

            if (seriesIdParam == null || seriesIdParam.trim().isEmpty()) {
                System.err.println("❌ Missing series ID");
                request.getSession().setAttribute("errorMessage", "Thiếu ID series!");
                response.sendRedirect(request.getContextPath() + "/SeriesManagement");
                return;
            }

            int seriesId = Integer.parseInt(seriesIdParam);
            System.out.println("📝 Editing series ID: " + seriesId);

            // Lấy thông tin series hiện tại từ DB
            Optional<Series> optionalSeries = seriesDAO.getSeriesById(seriesId);

            if (!optionalSeries.isPresent()) {
                System.err.println("❌ Series not found: " + seriesId);
                request.getSession().setAttribute("errorMessage", "Không tìm thấy series!");
                response.sendRedirect(request.getContextPath() + "/SeriesManagement");
                return;
            }

            Series series = optionalSeries.get();
            System.out.println("📚 Found series: " + series.getSeriesName());

            // Cập nhật thông tin mới
            String seriesName = request.getParameter("seriesName");
            String description = request.getParameter("seriesDescription");
            String status = request.getParameter("seriesStatus");
            String volumesParam = request.getParameter("seriesVolumes");

            System.out.println("📝 New name: " + seriesName);
            System.out.println("📝 New volumes: " + volumesParam);
            System.out.println("📝 New status: " + status);

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

            // Kiểm tra tên series đã tồn tại chưa (trừ series đang sửa)
            if (seriesDAO.isSeriesNameExistsExcludingId(seriesName, seriesId)) {
                System.err.println("❌ Series name already exists: " + seriesName);
                request.getSession().setAttribute("errorMessage", "Tên series '" + seriesName + "' đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/SeriesManagement");
                return;
            }

            series.setSeriesName(seriesName);
            series.setDescription(description);
            series.setStatus(status);
            series.setTotalVolumes(totalVolumes);

            // Xử lý upload ảnh mới (nếu có)
            Part coverPart = request.getPart("seriesCover");

            if (coverPart != null && coverPart.getSize() > 0) {
                System.out.println("📤 Uploading new cover image...");
                try {
                    // Xóa ảnh cũ trên Cloudinary (nếu có)
                    String oldCoverUrl = series.getCoverUrl();
                    if (oldCoverUrl != null && !oldCoverUrl.isEmpty()) {
                        String publicId = CloudinaryService.getPublicIdFromUrl(oldCoverUrl);
                        if (publicId != null) {
                            boolean deleted = CloudinaryService.deleteImage(publicId);
                            if (deleted) {
                                System.out.println("🗑️ Deleted old cover: " + publicId);
                            } else {
                                System.out.println("⚠️ Failed to delete old cover: " + publicId);
                            }
                        }
                    }

                    // Upload ảnh mới
                    String newCoverUrl = CloudinaryService.uploadImage(coverPart, "comics/series");
                    series.setCoverUrl(newCoverUrl);
                    System.out.println("✅ Uploaded new cover: " + newCoverUrl);

                } catch (IOException e) {
                    System.err.println("❌ Error uploading new cover: " + e.getMessage());
                    e.printStackTrace();
                    request.getSession().setAttribute("errorMessage", "Lỗi khi upload ảnh mới: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/SeriesManagement");
                    return;
                }
            } else {
                System.out.println("ℹ️ No new cover image uploaded, keeping existing");
            }

            // Cập nhật vào database
            boolean success = seriesDAO.updateSeries(series);

            if (success) {
                System.out.println("✅ Series updated successfully: " + seriesId);
                request.getSession().setAttribute("successMessage", "Cập nhật series thành công!");
            } else {
                System.err.println("❌ Failed to update series: " + seriesId);
                request.getSession().setAttribute("errorMessage", "Cập nhật series thất bại!");
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid number format: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "Số tập phải là số nguyên hợp lệ!");
        } catch (IllegalArgumentException e) {
            System.err.println("❌ Validation error: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            System.err.println("❌ Error updating series: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }

        // Redirect về trang quản lý series
        response.sendRedirect(request.getContextPath() + "/SeriesManagement");
    }
}