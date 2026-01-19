package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/products/images")
public class GetComicImagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            String comicIdParam = request.getParameter("comicId");

            if (comicIdParam == null || comicIdParam.isEmpty()) {
                result.put("success", false);
                result.put("message", "Thiếu comic ID");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int comicId = Integer.parseInt(comicIdParam);
            System.out.println("Getting images for comic ID: " + comicId);

            Jdbi jdbi = JdbiConnector.get();

            // LẤY THUMBNAIL (ẢNH BÌA) TỪ BẢNG comics
            String thumbnailUrl = jdbi.withHandle(handle ->
                    handle.createQuery("SELECT thumbnail_url FROM comics WHERE id = :id")
                            .bind("id", comicId)
                            .mapTo(String.class)
                            .findOne()
                            .orElse(null)
            );

            System.out.println("Thumbnail URL: " + thumbnailUrl);

            // LẤY ẢNH CHI TIẾT TỪ BẢNG comic_images (BẤT KỂ imageType)
            List<Map<String, Object>> detailImages = jdbi.withHandle(handle -> {
                String sql = """
                    SELECT 
                        id,
                        comic_id as comicId,
                        image_url as imageUrl,
                        image_type as imageType,
                        sort_order as sortOrder
                    FROM comic_images 
                    WHERE comic_id = :comicId 
                    AND image_url IS NOT NULL 
                    AND image_url != ''
                    ORDER BY sort_order ASC
                """;

                return handle.createQuery(sql)
                        .bind("comicId", comicId)
                        .mapToMap()
                        .list();
            });

            System.out.println("📸 Detail images from DB: " + detailImages.size());

            // TẠO DANH SÁCH ẢNH HOÀN CHỈNH: [Thumbnail] + [Detail Images]
            List<Map<String, Object>> allImages = new ArrayList<>();

            // THÊM THUMBNAIL VÀO VỊ TRÍ ĐẦU TIÊN (ẢNH BÌA)
            if (thumbnailUrl != null && !thumbnailUrl.isEmpty()) {
                Map<String, Object> coverImage = new HashMap<>();
                coverImage.put("imageUrl", thumbnailUrl);
                coverImage.put("imageType", "cover");
                coverImage.put("sortOrder", 0);
                allImages.add(coverImage);
                System.out.println("Added thumbnail as cover image");
            } else {
                System.out.println("⚠️ No thumbnail found for comic " + comicId);
            }

            // THÊM ẢNH CHI TIẾT (CHỈ THÊM NẾU CÓ imageUrl HỢP LỆ)
            if (detailImages != null && !detailImages.isEmpty()) {
                int validCount = 0;
                for (Map<String, Object> img : detailImages) {
                    Object imageUrl = img.get("imageUrl");
                    if (imageUrl != null && !imageUrl.toString().trim().isEmpty()) {

                        String imageType = (String) img.get("imageType");
                        if ("gallery".equals(imageType)) {
                            img.put("imageType", "detail");
                            System.out.println("Normalized: gallery → detail");
                        }

                        allImages.add(img);
                        validCount++;
                    } else {
                        System.out.println(" Skipped image with null/empty URL");
                    }
                }
                System.out.println(" Added " + validCount + " valid detail images");
            }

            //IN RA TẤT CẢ ẢNH
            System.out.println("📦 Total images to return: " + allImages.size());
            for (int i = 0; i < allImages.size(); i++) {
                Map<String, Object> img = allImages.get(i);
                System.out.println("  Image " + (i + 1) + ": " + img.get("imageType") + " - " + img.get("imageUrl"));
            }

            result.put("success", true);
            result.put("images", allImages);

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Comic ID không hợp lệ");
            System.err.println("❌ Invalid comic ID format");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
            System.err.println("❌ Error: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}