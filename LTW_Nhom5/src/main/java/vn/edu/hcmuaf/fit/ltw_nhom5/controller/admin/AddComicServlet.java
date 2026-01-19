package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Comic;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.ComicImage;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Category;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.CloudinaryService;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/products/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddComicServlet extends HttpServlet {

    private ComicDAO comicDAO;
    private CategoriesDao categoriesDao;
    private SeriesDAO seriesDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        comicDAO = new ComicDAO();
        categoriesDao = new CategoriesDao();
        seriesDAO = new SeriesDAO();
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
            System.out.println("========== ADD COMIC REQUEST ==========");

            // 1. Lấy dữ liệu từ form
            Comic comic = extractComicFromRequest(request);
            String authorName = request.getParameter("author");
            String publisherName = request.getParameter("publisher");

            System.out.println("Comic Name: " + comic.getNameComics());
            System.out.println("Author: " + authorName);
            System.out.println("Category ID: " + comic.getCategoryId());
            System.out.println("Series ID: " + comic.getSeriesId());

            // 2. Validate
            List<String> errors = validateComic(comic);
            if (!errors.isEmpty()) {
                result.put("success", false);
                result.put("message", "Dữ liệu không hợp lệ");
                result.put("errors", errors);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 3. Kiểm tra trùng
            if (comicDAO.isComicNameExist(comic.getNameComics(), comic.getSeriesId(), comic.getVolume())) {
                result.put("success", false);
                result.put("message", "Truyện này đã tồn tại");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 4. UPLOAD ẢNH BÌA LÊN CLOUDINARY
            Part coverPart = request.getPart("coverImage");
            if (coverPart != null && coverPart.getSize() > 0) {
                try {
                    String coverUrl = CloudinaryService.uploadImage(coverPart, "comics/covers");
                    if (coverUrl != null) {
                        comic.setThumbnailUrl(coverUrl);
                        System.out.println("✅ Cover uploaded: " + coverUrl);
                    }
                } catch (IOException e) {
                    System.err.println("❌ Error uploading cover: " + e.getMessage());
                    result.put("success", false);
                    result.put("message", "Lỗi upload ảnh bìa: " + e.getMessage());
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
            }

            // 5. Xử lý Author & Publisher
            int authorId = -1;
            int publisherId = -1;

            if (authorName != null && !authorName.trim().isEmpty()) {
                authorId = comicDAO.findOrCreateAuthor(authorName.trim());
            }

            if (publisherName != null && !publisherName.trim().isEmpty()) {
                publisherId = comicDAO.findOrCreatePublisher(publisherName.trim());
            }

            // 6. Gán tên vào Comic
            comic.setAuthor(authorName != null ? authorName.trim() : null);
            comic.setPublisher(publisherName != null ? publisherName.trim() : null);

            // 7. Insert Comic vào DB
            int comicId = comicDAO.insertComic(comic);

            if (comicId <= 0) {
                result.put("success", false);
                result.put("message", "Không thể thêm truyện");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            System.out.println("✅ Comic created with ID: " + comicId);

            // 8. Link với Author
            if (authorId > 0) {
                comicDAO.linkComicAuthor(comicId, authorId);
            }

            // 9. Link với Publisher
            if (publisherId > 0) {
                comicDAO.linkComicPublisher(comicId, publisherId);
            }

            // 10. UPLOAD ẢNH CHI TIẾT LÊN CLOUDINARY
            List<ComicImage> detailImages = new ArrayList<>();

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
                            detailImages.add(img);

                            System.out.println("✅ Detail image " + i + " uploaded: " + imageUrl);
                        }
                    } catch (IOException e) {
                        System.err.println("⚠️ Warning: Could not upload detail image " + i + ": " + e.getMessage());
                    }
                }
            }

            if (!detailImages.isEmpty()) {
                comicDAO.insertComicImages(detailImages);
            }

            // ✅ 11. TẠO RESPONSE VỚI THÔNG TIN ĐẦY ĐỦ
            Map<String, Object> comicData = new HashMap<>();
            comicData.put("id", comicId);
            comicData.put("nameComics", comic.getNameComics());
            comicData.put("author", comic.getAuthor());
            comicData.put("publisher", comic.getPublisher());
            comicData.put("price", comic.getPrice());
            comicData.put("stockQuantity", comic.getStockQuantity());
            comicData.put("thumbnailUrl", comic.getThumbnailUrl());

            // ✅ Lấy tên category
            String categoryName = "Chưa phân loại";
            if (comic.getCategoryId() != null) {
                try {
                    List<Category> categories = categoriesDao.getAllCategories();
                    for (Category cat : categories) {
                        if (cat.getId() == comic.getCategoryId()) {
                            categoryName = cat.getNameCategories();
                            break;
                        }
                    }
                } catch (Exception e) {
                    System.err.println("⚠️ Could not load category name: " + e.getMessage());
                }
            }
            comicData.put("categoryName", categoryName);

            // ✅ Lấy tên series bằng hàm getSeriesNameById()
            String seriesName = "-";
            if (comic.getSeriesId() != null) {
                try {
                    String name = seriesDAO.getSeriesNameById1(comic.getSeriesId());
                    if (name != null && !name.isEmpty()) {
                        seriesName = name;
                    }
                } catch (Exception e) {
                    System.err.println("⚠️ Could not load series name: " + e.getMessage());
                }
            }
            comicData.put("seriesName", seriesName);

            // 12. Thành công
            result.put("success", true);
            result.put("message", "Thêm truyện thành công");
            result.put("comicId", comicId);
            result.put("comic", comicData);

            System.out.println("✅ Response: " + gson.toJson(result));
            System.out.println("======================================");

        } catch (Exception e) {
            System.err.println("❌ Error in AddComicServlet: " + e.getMessage());
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
                priceStr = priceStr.replace(",", "");
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