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
     */
    public List<Map<String, Object>> getExclusiveComicsForFlashSale(int flashSaleId) {
        // Sử dụng query đã tối ưu ở DAO
        return flashSaleComicsDAO.getExclusiveComicsForFlashSale(flashSaleId);
    }


}