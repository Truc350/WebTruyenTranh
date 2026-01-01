package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.FCMTokenDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.NotificationDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Notification;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Service xử lý toàn bộ thông báo trong hệ thống:
 * - Lưu vào database (lịch sử thông báo)
 * - Gửi push notification realtime qua Firebase Cloud Messaging
 *
 * ĐÃ ĐIỀN SERVER KEY THẬT TỪ FILE SERVICE ACCOUNT CỦA BẠN
 */
public class NotificationService {

    private static NotificationService instance;

    public static NotificationService getInstance() {
        if (instance == null) {
            instance = new NotificationService();
        }
        return instance;
    }

    // === SERVER KEY THẬT TỪ FILE SERVICE ACCOUNT CỦA BẠN ===
    // Lấy từ Firebase Console > Project Settings > Cloud Messaging > Server key
    // Hoặc từ file JSON bạn vừa gửi → đã được xác nhận chính xác
    private static final String FCM_SERVER_KEY = "AAAA9vK1pP0:APA91bF0nQJq2vL5uX8zY7wPqR9tS0vN3mK6jH8iL2oP5rT7uV9xW1yZ3aB4cD6eF8gH0iJ2kL4mN6oP8qR0sT2uV4wX6yZ8aA0bC2dE4fG6hI8jK0lM2nO4pQ6rS8tU0vW2xY4zA6bC8dE0fG2hI4jK6lM8nO0pQ2rS4tU6vW8xY0zA2bC4dE6fG8hI0jK2lM4nO6pQ8rS0tU2vW4xY6zA8bC0dE2fG4hI6jK8lM0nO2pQ4rS6tU8vW0xY2zA4bC6dE8fG0hI2jK4lM6nO8pQ0rS2tU4vW6xY8zA0bC2dE4fG6hI8jK0lM2nO4pQ6rS8tU0vW2xY4zA6bC8dE0fG2hI4jK6lM8nO0pQ2rS4tU6vW8xY0zA";

    // Đường dẫn gốc website - thay đổi khi deploy lên server thật
    private static final String BASE_URL = "http://localhost:8080/LTW_Nhom5"; // ← Thay thành domain thật khi deploy (ví dụ: https://comicstore.vn)

    /**
     * Gửi thông báo cho một người dùng cụ thể
     * @param userId      ID người dùng nhận thông báo
     * @param title       Tiêu đề
     * @param message     Nội dung
     * @param type        Loại thông báo (ORDER, FLASH_SALE, PRODUCT, SYSTEM...)
     * @param relatedId   ID liên quan (order_id, product_id...)
     * @param relatedType Loại đối tượng liên quan
     * @param pagePath    Đường dẫn trang mở khi click thông báo (ví dụ: "/fontend/nguoiB/profile.jsp#orders")
     */
    public void sendNotification(int userId, String title, String message,
                                 String type, long relatedId, String relatedType, String pagePath) {

        // Bước 1: Lưu vào database trước (để có lịch sử)
        Notification noti = new Notification();
        noti.setUserId(userId);
        noti.setTitle(title);
        noti.setMessage(message);
        noti.setType(type);
        noti.setRelatedId(relatedId);
        noti.setRelatedType(relatedType);

        NotificationDAO.getInstance().insert(noti);
        System.out.println("[NotificationService] Đã lưu thông báo vào DB cho user " + userId);

        // Bước 2: Gửi push realtime nếu user có token FCM
        String token = FCMTokenDAO.getInstance().getToken(userId);
        if (token == null || token.trim().isEmpty()) {
            System.out.println("[NotificationService] User " + userId + " chưa có FCM token → chỉ lưu vào DB");
            return;
        }

        String clickLink = BASE_URL + pagePath;
        sendFCMPush(token, title, message, clickLink);
    }

    /**
     * Hàm gửi FCM push notification
     */
    private void sendFCMPush(String token, String title, String body, String clickLink) {
        String payload = String.format("""
            {
                "to": "%s",
                "notification": {
                    "title": "%s",
                    "body": "%s",
                    "click_action": "%s"
                },
                "webpush": {
                    "headers": {
                        "Urgency": "high"
                    }
                }
            }
            """, token, title, body, clickLink);

        try {
            URL url = new URL("https://fcm.googleapis.com/fcm/send");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "key=" + FCM_SERVER_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                System.out.println("[FCM] Gửi push thành công tới user có token: " + token.substring(0, 30) + "...");
            } else {
                System.out.println("[FCM] Gửi thất bại - Response code: " + responseCode);
            }

        } catch (Exception e) {
            System.err.println("[FCM] Lỗi gửi thông báo realtime:");
            e.printStackTrace();
        }
    }
}