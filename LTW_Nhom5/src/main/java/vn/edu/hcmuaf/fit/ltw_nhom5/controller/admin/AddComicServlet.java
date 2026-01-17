package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.ComicImage;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/admin/products/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddComicServlet extends HttpServlet {

    private ComicDAO comicDAO;
    private Gson gson;

    // Đường dẫn lưu ảnh (relative to webapp root)
    private static final String UPLOAD_DIR = "uploads" + File.separator + "comics";
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");

    @Override
    public void init() throws ServletException {
        comicDAO = new ComicDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        Map<String, Object> result = new HashMap<>();

        try {
            // 1. Lấy dữ liệu từ form
            Comic comic = extractComicFromRequest(request);

            // 2. Validate dữ liệu
            List<String> errors = validateComic(comic);
            if (!errors.isEmpty()) {
                result.put("success", false);
                result.put("message", "Dữ liệu không hợp lệ");
                result.put("errors", errors);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 3. Kiểm tra trùng tên
            if (comicDAO.isComicNameExist(comic.getNameComics(), comic.getSeriesId(), comic.getVolume())) {
                result.put("success", false);
                result.put("message", "Truyện này đã tồn tại trong hệ thống");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 4. Upload ảnh bìa
            Part coverImagePart = request.getPart("coverImage");
            if (coverImagePart != null && coverImagePart.getSize() > 0) {
                String coverImageUrl = uploadFile(coverImagePart, request);
                if (coverImageUrl != null) {
                    comic.setThumbnailUrl(coverImageUrl);
                }
            }

            // 5. Thêm truyện vào DB
            int comicId = comicDAO.insertComic(comic);

            if (comicId <= 0) {
                result.put("success", false);
                result.put("message", "Không thể thêm truyện vào cơ sở dữ liệu");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 6. Upload các ảnh chi tiết
            List<ComicImage> detailImages = new ArrayList<>();
            for (int i = 1; i <= 3; i++) {
                Part imagePart = request.getPart("detailImage" + i);
                if (imagePart != null && imagePart.getSize() > 0) {
                    String imageUrl = uploadFile(imagePart, request);
                    if (imageUrl != null) {
                        ComicImage comicImage = new ComicImage();
                        comicImage.setComicId(comicId);
                        comicImage.setImageUrl(imageUrl);
                        comicImage.setImageType("detail");
                        comicImage.setSortOrder(i);
                        detailImages.add(comicImage);
                    }
                }
            }

            // 7. Lưu ảnh chi tiết vào DB
            if (!detailImages.isEmpty()) {
                comicDAO.insertComicImages(detailImages);
            }

            // 8. Trả kết quả thành công
            result.put("success", true);
            result.put("message", "Thêm truyện thành công");
            result.put("comicId", comicId);

        } catch (Exception e) {
            System.err.println("Error in AddComicServlet: " + e.getMessage());
            e.printStackTrace();

            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

    /**
     * Trích xuất thông tin Comic từ request
     */
    private Comic extractComicFromRequest(HttpServletRequest request) throws ServletException, IOException {
        Comic comic = new Comic();

        comic.setNameComics(request.getParameter("nameComics"));
        comic.setAuthor(request.getParameter("author"));
        comic.setPublisher(request.getParameter("publisher"));
        comic.setDescription(request.getParameter("description"));

        // Parse số
        try {
            comic.setPrice(Double.parseDouble(request.getParameter("price")));
        } catch (NumberFormatException e) {
            comic.setPrice(0);
        }

        try {
            comic.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        } catch (NumberFormatException e) {
            comic.setStockQuantity(0);
        }

        // Category và Series
        String categoryIdStr = request.getParameter("categoryId");
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            comic.setCategoryId(Integer.parseInt(categoryIdStr));
        }

        String seriesIdStr = request.getParameter("seriesId");
        if (seriesIdStr != null && !seriesIdStr.isEmpty()) {
            comic.setSeriesId(Integer.parseInt(seriesIdStr));
        }

        String volumeStr = request.getParameter("volume");
        if (volumeStr != null && !volumeStr.isEmpty()) {
            comic.setVolume(Integer.parseInt(volumeStr));
        }

        comic.setStatus("available");

        return comic;
    }

    /**
     * Validate dữ liệu Comic
     */
    private List<String> validateComic(Comic comic) {
        List<String> errors = new ArrayList<>();

        if (comic.getNameComics() == null || comic.getNameComics().trim().isEmpty()) {
            errors.add("Tên truyện không được để trống");
        }

        if (comic.getAuthor() == null || comic.getAuthor().trim().isEmpty()) {
            errors.add("Tên tác giả không được để trống");
        }

        if (comic.getPrice() <= 0) {
            errors.add("Giá phải lớn hơn 0");
        }

        if (comic.getStockQuantity() < 0) {
            errors.add("Số lượng không được âm");
        }

        if (comic.getCategoryId() == null) {
            errors.add("Vui lòng chọn thể loại");
        }

        return errors;
    }

    /**
     * Upload file và trả về đường dẫn tương đối
     */
    private String uploadFile(Part filePart, HttpServletRequest request) throws IOException {
        String fileName = getFileName(filePart);
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        // Kiểm tra extension
        String extension = getFileExtension(fileName);
        if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
            System.err.println("Invalid file extension: " + extension);
            return null;
        }

        // Tạo tên file unique
        String uniqueFileName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8) + "." + extension;

        // Đường dẫn tuyệt đối trên server
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Lưu file
        Path filePath = Paths.get(uploadPath, uniqueFileName);
        Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        // Trả về đường dẫn tương đối (để lưu vào DB)
        return UPLOAD_DIR.replace(File.separator, "/") + "/" + uniqueFileName;
    }

    /**
     * Lấy tên file từ Part
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }

    /**
     * Lấy extension của file
     */
    private String getFileExtension(String fileName) {
        int lastIndexOf = fileName.lastIndexOf(".");
        if (lastIndexOf == -1) {
            return "";
        }
        return fileName.substring(lastIndexOf + 1);
    }
}