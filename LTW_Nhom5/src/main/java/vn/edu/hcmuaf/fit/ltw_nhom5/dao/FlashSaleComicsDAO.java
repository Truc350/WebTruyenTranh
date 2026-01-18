package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import java.util.List;
import java.util.Map;

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

    public List<Map<String, Object>> getComicsByFlashSaleId(int flashSaleId) {
        String sql = """
        SELECT 
            c.id, 
            c.name_comics AS name,
            fs.discount_percent
        FROM FlashSale_Comics fsc
        JOIN Comics c ON fsc.comic_id = c.id
        JOIN FlashSale fs ON fsc.flashsale_id = fs.id
        WHERE fsc.flashsale_id = ?
        ORDER BY c.name_comics
    """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, flashSaleId)
                        .mapToMap()
                        .list()
        );
    }
}
