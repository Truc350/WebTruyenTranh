import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class TestGHN {

    private static final String GHN_TOKEN = "bb67bb35-1796-11f1-b2c0-1ab1fd37f3b7";
    private static final String GHN_SHOP_ID = "6302109"; // ComicStore
    private static final int FROM_DISTRICT = 3695;       // Thủ Đức

    public static void main(String[] args) throws Exception {

        // ===== Lấy danh sách dịch vụ vận chuyển =====
        System.out.println("===== Danh sách dịch vụ =====");
        String serviceBody = """
                {
                    "shop_id": 6302109,
                    "from_district": 3695,
                    "to_district": 1442
                }
                """;
        String serviceResult = post(
                "https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/available-services",
                serviceBody
        );
        System.out.println(serviceResult);

        // ===== Tính phí với service_type_id = 2 (thường) =====
        System.out.println("\n===== Phí giao thường =====");
        String feeStandard = post(
                "https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee",
                """
                {
                    "service_type_id": 2,
                    "from_district_id": 3695,
                    "to_district_id": 1442,
                    "to_ward_code": "21211",
                    "weight": 500
                }
                """
        );
        System.out.println(feeStandard);

        // ===== Tính phí với service_type_id = 1 (hỏa tốc) =====
        System.out.println("\n===== Phí hỏa tốc =====");
        String feeExpress = post(
                "https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee",
                """
                {
                    "service_type_id": 1,
                    "from_district_id": 3695,
                    "to_district_id": 1442,
                    "to_ward_code": "21211",
                    "weight": 500
                }
                """
        );
        System.out.println(feeExpress);
    }

    static String get(String apiUrl) throws Exception {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Token", GHN_TOKEN);
        conn.setRequestProperty("ShopId", GHN_SHOP_ID);

        int status = conn.getResponseCode();
        System.out.println("HTTP Status: " + status);

        InputStream is = status >= 200 && status < 300
                ? conn.getInputStream()
                : conn.getErrorStream();

        return new String(is.readAllBytes(), StandardCharsets.UTF_8);
    }

    static String post(String apiUrl, String body) throws Exception {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Token", GHN_TOKEN);
        conn.setRequestProperty("ShopId", GHN_SHOP_ID);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        System.out.println("HTTP Status: " + status);

        InputStream is = status >= 200 && status < 300
                ? conn.getInputStream()
                : conn.getErrorStream();

        return new String(is.readAllBytes(), StandardCharsets.UTF_8);
    }
}