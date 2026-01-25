package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleComicsDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FlashSaleDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.FlashSale;

import java.util.*;

public class FlashSaleService {
    private final FlashSaleDAO flashSaleDAO = new FlashSaleDAO();
    private final FlashSaleComicsDAO flashSaleComicsDAO = new FlashSaleComicsDAO();

    /**
     * Lấy danh sách comics ĐỘC QUYỀN cho một Flash Sale cụ thể
     * CHỈ hiển thị comic nếu Flash Sale này có discount CAO NHẤT
     * Nếu comic thuộc Flash Sale khác có discount cao hơn → KHÔNG hiển thị
     */
    public List<Map<String, Object>> getExclusiveComicsForFlashSale(int flashSaleId) {
        // Sử dụng query đã tối ưu ở DAO
        return flashSaleComicsDAO.getExclusiveComicsForFlashSale(flashSaleId);
    }

    /**
     * Lấy tất cả comics đang active, mỗi comic CHỈ XUẤT HIỆN 1 LẦN
     * Ưu tiên Flash Sale có discount cao nhất
     */
    public List<Map<String, Object>> getAllUniqueActiveComics() {
        return flashSaleComicsDAO.getUniqueComicsWithBestDiscount();
    }

    /**
     * Kiểm tra xem một Flash Sale có comics độc quyền nào không
     * (tức là có comics mà Flash Sale này có discount cao nhất)
     */
    public boolean hasExclusiveComics(int flashSaleId) {
        List<Map<String, Object>> exclusiveComics = getExclusiveComicsForFlashSale(flashSaleId);
        return exclusiveComics != null && !exclusiveComics.isEmpty();
    }

    /**
     * Lấy thông tin về việc phân bổ comics giữa các Flash Sale active
     * Dùng để debug và hiển thị thông tin
     */
    public Map<String, Object> getFlashSaleDistribution() {
        Map<String, Object> distribution = new HashMap<>();

        // Lấy tất cả Flash Sale active
        List<FlashSale> activeFlashSales = flashSaleDAO.getFlashSalesByStatus("active");

        Map<Integer, Map<String, Object>> flashSaleInfo = new LinkedHashMap<>();

        for (FlashSale fs : activeFlashSales) {
            Map<String, Object> info = new HashMap<>();
            info.put("id", fs.getId());
            info.put("name", fs.getName());
            info.put("discount", fs.getDiscountPercent());

            // Số lượng comics độc quyền (thực sự hiển thị)
            List<Map<String, Object>> exclusiveComics =
                    getExclusiveComicsForFlashSale(fs.getId());
            info.put("exclusiveComicsCount", exclusiveComics.size());

            // Số lượng comics tổng (trong database)
            List<Map<String, Object>> allComics =
                    flashSaleComicsDAO.getComicsByFlashSaleId(fs.getId());
            info.put("totalComicsInDB", allComics.size());

            // Danh sách comics độc quyền
            List<String> exclusiveNames = new ArrayList<>();
            for (Map<String, Object> comic : exclusiveComics) {
                exclusiveNames.add((String) comic.get("name"));
            }
            info.put("exclusiveComicNames", exclusiveNames);

            // Danh sách comics bị "chiếm" bởi Flash Sale khác
            Set<Integer> exclusiveIds = new HashSet<>();
            for (Map<String, Object> comic : exclusiveComics) {
                exclusiveIds.add(((Number) comic.get("id")).intValue());
            }

            List<String> stolenComics = new ArrayList<>();
            for (Map<String, Object> comic : allComics) {
                int comicId = ((Number) comic.get("id")).intValue();
                if (!exclusiveIds.contains(comicId)) {
                    Integer ownerFlashSaleId = flashSaleComicsDAO.getBestFlashSaleIdForComic(comicId);
                    if (ownerFlashSaleId != null && ownerFlashSaleId != fs.getId()) {
                        FlashSale ownerFs = flashSaleDAO.getById(ownerFlashSaleId);
                        stolenComics.add(comic.get("name") + " → " + ownerFs.getName() +
                                " (" + ownerFs.getDiscountPercent() + "%)");
                    }
                }
            }
            info.put("stolenComics", stolenComics);

            flashSaleInfo.put(fs.getId(), info);
        }

        distribution.put("flashSales", flashSaleInfo);
        distribution.put("totalUniqueComics", getAllUniqueActiveComics().size());

        return distribution;
    }

    /**
     * Lấy Flash Sale "chủ sở hữu" của một comic
     * (Flash Sale có discount cao nhất cho comic này)
     */
    public Integer getOwnerFlashSaleForComic(int comicId) {
        return flashSaleComicsDAO.getBestFlashSaleIdForComic(comicId);
    }

    /**
     * Kiểm tra xem một comic có nằm trong Flash Sale được chỉ định không
     * VÀ Flash Sale này có phải là chủ sở hữu không
     */
    public boolean isComicOwnedByFlashSale(int comicId, int flashSaleId) {
        Integer ownerFlashSaleId = getOwnerFlashSaleForComic(comicId);
        return ownerFlashSaleId != null && ownerFlashSaleId == flashSaleId;
    }
}