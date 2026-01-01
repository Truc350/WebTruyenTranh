package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import java.util.List;

public class FlashSaleComicsDAO extends ADao {

    public void insertLinks(int flashSaleId, List<Integer> comicIds) {
        if (comicIds == null || comicIds.isEmpty()) return;

        String sql = "INSERT IGNORE INTO FlashSale_Comics (flashsale_id, comic_id) VALUES (?, ?)";

        jdbi.useHandle(handle -> {
            try (var batch = handle.prepareBatch(sql)) {
                for (int comicId : comicIds) {
                    batch
                            .bind(0, flashSaleId)
                            .bind(1, comicId)
                            .add();
                }
                batch.execute();
            }
        });
    }
}
