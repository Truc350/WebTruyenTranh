package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleComicsDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;
import vn.edu.hcmuaf.fit.ltw_nhom5.service.FlashSaleService;

import java.io.IOException;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;

@WebServlet("/flash-sale")
public class FlashSaleServlet extends HttpServlet {

    private final FlashSaleDAO flashSaleDAO = new FlashSaleDAO();
    private final FlashSaleComicsDAO flashSaleComicsDAO = new FlashSaleComicsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            // Cập nhật trạng thái trước khi hiển thị
            flashSaleDAO.updateStatuses();

            FlashSaleService flashSaleService = new FlashSaleService();

            // DEBUG: Hiển thị phân bổ comics
            printFlashSaleDistribution(flashSaleService);

            // 1. Lấy Flash Sale đang active (nếu có)
            FlashSale activeFlashSale = flashSaleDAO.getActiveFlashSaleEndingSoon();

            if (activeFlashSale != null) {
                req.setAttribute("activeFlashSale", activeFlashSale);

                // Chuyển endTime sang milliseconds cho JavaScript countdown
                long endTimeMillis = activeFlashSale.getEndTime()
                        .atZone(ZoneId.systemDefault())
                        .toInstant()
                        .toEpochMilli();
                req.setAttribute("flashSaleEndTimeMillis", endTimeMillis);

                // Lấy danh sách comics ĐỘC QUYỀN
                List<Map<String, Object>> activeComics =
                        flashSaleService.getExclusiveComicsForFlashSale(activeFlashSale.getId());
                req.setAttribute("activeComics", activeComics);

                System.out.println("✅ Active Flash Sale: " + activeFlashSale.getName() +
                        " (" + activeFlashSale.getDiscountPercent() + "%)");
                System.out.println("✅ Exclusive Comics count: " + activeComics.size());
            } else {
                System.out.println("⚠️ No active Flash Sale found");
            }

            // 2. Lấy danh sách Flash Sale sắp tới (scheduled + active) để hiển thị slot
            List<FlashSale> upcomingFlashSales = flashSaleDAO.getUpcomingAndActiveFlashSales();
            req.setAttribute("upcomingFlashSales", upcomingFlashSales);

            System.out.println("✅ Upcoming Flash Sales count: " + upcomingFlashSales.size());

            // Forward tới trang JSP
            req.getRequestDispatcher("/fontend/public/FlashSale.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi khi tải Flash Sale: " + e.getMessage());
            req.getRequestDispatcher("/fontend/public/error.jsp").forward(req, resp);
        }
    }

    /**
     * In ra phân bổ comics giữa các Flash Sale (để debug)
     */
    private void printFlashSaleDistribution(FlashSaleService flashSaleService) {
        System.out.println("\n" + "=".repeat(100));
        System.out.println("📊 FLASH SALE COMIC DISTRIBUTION - CHỈ HIỂN THỊ Ở FLASH SALE CÓ DISCOUNT CAO NHẤT");
        System.out.println("=".repeat(100));

        Map<String, Object> distribution = flashSaleService.getFlashSaleDistribution();

        @SuppressWarnings("unchecked")
        Map<Integer, Map<String, Object>> flashSales =
                (Map<Integer, Map<String, Object>>) distribution.get("flashSales");

        for (Map.Entry<Integer, Map<String, Object>> entry : flashSales.entrySet()) {
            Map<String, Object> info = entry.getValue();

            System.out.println("\n🔥 Flash Sale: " + info.get("name"));
            System.out.println("   Discount: " + info.get("discount") + "%");
            System.out.println("   Comics trong DB: " + info.get("totalComicsInDB"));
            System.out.println("   Comics HIỂN THỊ (độc quyền): " + info.get("exclusiveComicsCount"));

            @SuppressWarnings("unchecked")
            List<String> exclusiveNames = (List<String>) info.get("exclusiveComicNames");
            if (!exclusiveNames.isEmpty()) {
                System.out.println("\n   ✅ Comics được HIỂN THỊ:");
                for (String name : exclusiveNames) {
                    System.out.println("      - " + name);
                }
            }

            @SuppressWarnings("unchecked")
            List<String> stolenComics = (List<String>) info.get("stolenComics");
            if (!stolenComics.isEmpty()) {
                System.out.println("\n   ⚠️ Comics KHÔNG HIỂN THỊ (thuộc Flash Sale khác có discount cao hơn):");
                for (String comic : stolenComics) {
                    System.out.println("      - " + comic);
                }
            }
        }

        System.out.println("\n📊 Tổng số comics unique: " + distribution.get("totalUniqueComics"));
        System.out.println("=".repeat(100) + "\n");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}