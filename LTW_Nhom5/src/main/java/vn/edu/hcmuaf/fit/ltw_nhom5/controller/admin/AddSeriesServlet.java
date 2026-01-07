package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Map;

@MultipartConfig
@WebServlet("/AddSeriesServlet")
public class AddSeriesServlet extends HttpServlet {

    private Cloudinary cloudinary;
    private SeriesDAO seriesDAO;

    @Override
    public void init() throws ServletException {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dj4bwkuul",          // thay bằng cloud_name của bạn
                "api_key", "437582248686893",      // thay bằng api_key của bạn
                "api_secret", "RZEOAFHqLWdHMFJtJTCQnGio5Go" // thay bằng api_secret của bạn
        ));
        seriesDAO = new SeriesDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy các parameter từ form
        String seriesName = request.getParameter("seriesName");
        String description = request.getParameter("seriesDescription");
        String volumesParam = request.getParameter("seriesVolumes");
        String status = request.getParameter("seriesStatus");
        Part filePart = request.getPart("seriesCover");

        // === VALIDATION ===
        if (seriesName == null || seriesName.trim().isEmpty()) {
            throw new ServletException("Tên series không được để trống");
        }

        if (status == null || status.trim().isEmpty()) {
            throw new ServletException("Vui lòng chọn tình trạng series");
        }

        int totalVolumes;
        if (volumesParam == null || volumesParam.trim().isEmpty()) {
            throw new ServletException("Số tập không được để trống");
        }
        try {
            totalVolumes = Integer.parseInt(volumesParam.trim());
            if (totalVolumes < 1) {
                throw new ServletException("Số tập phải lớn hơn hoặc bằng 1");
            }
        } catch (NumberFormatException e) {
            throw new ServletException("Số tập phải là một số nguyên hợp lệ");
        }

        if (filePart == null || filePart.getSize() == 0) {
            throw new ServletException("Vui lòng chọn ảnh bìa cho series");
        }

        // === UPLOAD ẢNH LÊN CLOUDINARY (đảm bảo không bị ghi đè) ===
        String coverUrl;
        try {
            byte[] fileBytes = filePart.getInputStream().readAllBytes();
            String submittedFileName = filePart.getSubmittedFileName();

            // Tạo tên file duy nhất bằng timestamp
            String uniqueName = "series_" + System.currentTimeMillis() + "_" + submittedFileName;

            Map<String, Object> params = ObjectUtils.asMap(
                    "public_id", uniqueName,   // tên file duy nhất
                    "folder", "series_covers", // lưu trong folder riêng (tùy chọn)
                    "overwrite", false         // không ghi đè
            );

            @SuppressWarnings("unchecked")
            Map<String, Object> uploadResult = cloudinary.uploader().upload(fileBytes, params);

            coverUrl = (String) uploadResult.get("secure_url");

            if (coverUrl == null || coverUrl.isEmpty()) {
                throw new ServletException("Upload ảnh thất bại: không nhận được URL");
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi khi upload ảnh lên Cloudinary: " + e.getMessage(), e);
        }

        // === TẠO ĐỐI TƯỢNG SERIES VÀ LƯU VÀO DB ===
        Series series = new Series();
        series.setSeriesName(seriesName.trim());
        series.setDescription(description != null ? description.trim() : "");
        series.setTotalVolumes(totalVolumes);
        series.setStatus(status);
        series.setCoverUrl(coverUrl);
        series.setCreatedAt(LocalDateTime.now());
        series.setUpdatedAt(LocalDateTime.now());
        series.setDeleted(false);

        seriesDAO.insert(series);

        // Chuyển hướng về trang quản lý sau khi thêm thành công
        response.sendRedirect("fontend/admin/seriesManagement.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("fontend/admin/seriesManagement.jsp");
    }
}
