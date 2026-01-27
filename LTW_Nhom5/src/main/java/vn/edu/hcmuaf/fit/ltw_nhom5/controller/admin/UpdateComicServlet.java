package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.ComicImage;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.CloudinaryService;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/products/update")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UpdateComicServlet extends HttpServlet {

    private ComicDAO comicDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        System.out.println("🔧 Initializing UpdateComicServlet...");
        comicDAO = new ComicDAO();
        gson = new Gson();
        System.out.println("✅ UpdateComicServlet initialized!");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        Map<String, Object> result = new HashMap<>();

        try {
            System.out.println("========== UPDATE COMIC REQUEST ==========");

            // 1. Lấy comic ID
            String comicIdStr = request.getParameter("comicId");
            if (comicIdStr == null || comicIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Thiếu ID truyện");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int comicId = Integer.parseInt(comicIdStr);
            System.out.println("📖 Updating comic ID: " + comicId);

            // 2. Kiểm tra truyện có tồn tại không
            Comic existingComic = comicDAO.getComicById3(comicId);
            if (existingComic == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy truyện");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 3. Lấy dữ liệu từ form
            Comic comic = extractComicFromRequest(request);
            comic.setId(comicId);

            String authorName = request.getParameter("author");
            String publisherName = request.getParameter("publisher");

            System.out.println("Comic Name: " + comic.getNameComics());
            System.out.println("Author: " + authorName);
            System.out.println("Publisher: " + publisherName);

            // 4. Validate
            List<String> errors = validateComic(comic);
            if (!errors.isEmpty()) {
                result.put("success", false);
                result.put("message", "Dữ liệu không hợp lệ");
                result.put("errors", errors);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 5. Upload ảnh bìa mới (nếu có)
            Part coverPart = request.getPart("coverImage");
            if (coverPart != null && coverPart.getSize() > 0) {
                try {
                    String coverUrl = CloudinaryService.uploadImage(coverPart, "comics/covers");
                    if (coverUrl != null) {
                        comic.setThumbnailUrl(coverUrl);
                        System.out.println("✅ New cover uploaded: " + coverUrl);
                    }
                } catch (IOException e) {
                    System.err.println("⚠️ Warning: Could not upload cover: " + e.getMessage());
                }
            } else {
                // Giữ nguyên ảnh cũ
                comic.setThumbnailUrl(existingComic.getThumbnailUrl());
            }

            // 6. Xử lý Author & Publisher
            int authorId = -1;
            int publisherId = -1;

            if (authorName != null && !authorName.trim().isEmpty()) {
                authorId = comicDAO.findOrCreateAuthor(authorName.trim());
            }

            if (publisherName != null && !publisherName.trim().isEmpty()) {
                publisherId = comicDAO.findOrCreatePublisher(publisherName.trim());
            }

            comic.setAuthor(authorName != null ? authorName.trim() : null);
            comic.setPublisher(publisherName != null ? publisherName.trim() : null);

            // 7. Cập nhật Comic trong DB
            boolean updated = comicDAO.updateComic(comic);

            if (!updated) {
                result.put("success", false);
                result.put("message", "Không thể cập nhật truyện");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            System.out.println("✅ Comic updated successfully");

            // 8. Cập nhật Author & Publisher links
            if (authorId > 0) {
                comicDAO.updateComicAuthor(comicId, authorId);
            }

            if (publisherId > 0) {
                comicDAO.updateComicPublisher(comicId, publisherId);
            }

            // 9. Upload ảnh chi tiết mới (nếu có)
            List<ComicImage> newImages = new ArrayList<>();

            for (int i = 1; i <= 3; i++) {
                Part imagePart = request.getPart("detailImage" + i);
                if (imagePart != null && imagePart.getSize() > 0) {
                    try {
                        String imageUrl = CloudinaryService.uploadImage(imagePart, "comics/details");
                        if (imageUrl != null) {
                            ComicImage img = new ComicImage();
                            img.setComicId(comicId);
                            img.setImageUrl(imageUrl);
                            img.setImageType("detail");
                            img.setSortOrder(i);
                            newImages.add(img);

                            System.out.println("✅ Detail image " + i + " uploaded: " + imageUrl);
                        }
                    } catch (IOException e) {
                        System.err.println("⚠️ Warning: Could not upload detail image " + i + ": " + e.getMessage());
                    }
                }
            }

            // Nếu có ảnh mới, xóa ảnh cũ và thêm ảnh mới
            if (!newImages.isEmpty()) {
                comicDAO.deleteComicImages(comicId);
                comicDAO.insertComicImages(newImages);
                System.out.println("✅ Updated " + newImages.size() + " detail images");
            }

            // 10. Tạo response
            Map<String, Object> comicData = new HashMap<>();
            comicData.put("id", comicId);
            comicData.put("nameComics", comic.getNameComics());
            comicData.put("author", comic.getAuthor());
            comicData.put("publisher", comic.getPublisher());
            comicData.put("price", comic.getPrice());
            comicData.put("stockQuantity", comic.getStockQuantity());

            result.put("success", true);
            result.put("message", "Cập nhật truyện thành công");
            result.put("comic", comicData);

            System.out.println("✅ Response: " + gson.toJson(result));
            System.out.println("======================================");

        } catch (Exception e) {
            System.err.println("❌ Error in UpdateComicServlet: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

    private Comic extractComicFromRequest(HttpServletRequest request) {
        Comic comic = new Comic();

        comic.setNameComics(request.getParameter("nameComics"));
        comic.setDescription(request.getParameter("description"));

        try {
            String priceStr = request.getParameter("price");
            if (priceStr != null) {
                priceStr = priceStr.replace(",", "").replace("đ", "").trim();
                comic.setPrice(Double.parseDouble(priceStr));
            }
        } catch (NumberFormatException e) {
            comic.setPrice(0);
        }

        try {
            comic.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        } catch (NumberFormatException e) {
            comic.setStockQuantity(0);
        }

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

    private List<String> validateComic(Comic comic) {
        List<String> errors = new ArrayList<>();

        if (comic.getNameComics() == null || comic.getNameComics().trim().isEmpty()) {
            errors.add("Tên truyện không được để trống");
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
}