package vn.edu.hcmuaf.fit.ltw_nhom5.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.ComicDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.ComicImage;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/products/images")
public class GetComicImagesServlet extends HttpServlet {

    private ComicDAO comicDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        System.out.println("🔧 Initializing GetComicImagesServlet...");
        try {
            comicDAO = new ComicDAO();
            gson = new Gson();
            System.out.println("✅ GetComicImagesServlet initialized successfully!");
        } catch (Exception e) {
            System.err.println("❌ Error initializing servlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        try {
            String comicIdParam = request.getParameter("comicId");

            if (comicIdParam == null || comicIdParam.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Thiếu comic ID");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int comicId = Integer.parseInt(comicIdParam);
            System.out.println("🖼️ Getting images for comic ID: " + comicId);

            // Lấy danh sách ảnh
            List<ComicImage> images = comicDAO.getComicImages(comicId);

            if (images == null || images.isEmpty()) {
                System.out.println("⚠️ No images found for comic ID: " + comicId);
                result.put("success", true);
                result.put("images", new ArrayList<>());
                result.put("message", "Truyện chưa có ảnh");
            } else {
                // Chuyển đổi sang DTO đơn giản
                List<Map<String, Object>> imageList = new ArrayList<>();

                for (ComicImage img : images) {
                    Map<String, Object> imageData = new HashMap<>();
                    imageData.put("id", img.getId());
                    imageData.put("comicId", img.getComicId());
                    imageData.put("imageUrl", img.getImageUrl());
                    imageData.put("imageType", img.getImageType());
                    imageData.put("sortOrder", img.getSortOrder());
                    imageList.add(imageData);
                }

                result.put("success", true);
                result.put("images", imageList);
                System.out.println("✅ Found " + images.size() + " images");
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid comic ID format: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Comic ID không hợp lệ");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(gson.toJson(result));
        response.getWriter().flush();
    }
}