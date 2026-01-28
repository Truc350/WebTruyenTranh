package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.NotificationDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Notification;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class NotificationService {

    private static NotificationService instance;
    private NotificationDAO notificationDao;

    private NotificationService() {
        this.notificationDao = NotificationDAO.getInstance();
    }

    public static NotificationService getInstance() {
        if (instance == null) {
            instance = new NotificationService();
        }
        return instance;
    }

    /**
     * Thông báo cho admin khi user vi phạm rule
     */
    public void notifyAdminUserViolation(int violatorUserId, String violatorName, String ruleType, String detail) {
        // GỘP title và message thành 1 message duy nhất
        String fullMessage = String.format(
                "⚠️ User vi phạm quy định\n\n" +
                        "User: %s (ID: %d)\n" +
                        "Loại vi phạm: %s\n" +
                        "Chi tiết: %s",
                violatorName, violatorUserId, ruleType, detail
        );

        Notification noti = new Notification();
        noti.setUserId(1); // admin
        noti.setMessage(fullMessage);
        noti.setType("USER_VIOLATION");

        notificationDao.insertForAdmin(noti);

        System.out.println(" [NotificationService] Đã gửi thông báo vi phạm cho admin về user " + violatorUserId);
    }

    /**
     * Gửi thông báo cho user
     * SỬA: Chỉ dùng message, không dùng title
     */
    public void notifyUser(int userId, String message, String type) {
        Notification noti = new Notification();
        noti.setUserId(userId);
        noti.setMessage(message);
        noti.setType(type);

        notificationDao.insert(noti);

        System.out.println(" [NotificationService] Đã gửi thông báo cho user " + userId);
    }

    /**
     * Admin xác nhận đơn hàng
     */
    public void notifyOrderConfirmed(int userId, String orderCode) {
        try {
            String message = String.format(
                    "✅ Đơn hàng %s đã được xác nhận\n\n" +
                            "Đơn hàng của bạn đang được chuẩn bị.\n" +
                            "Chúng tôi sẽ sớm giao hàng cho đơn vị vận chuyển.",
                    orderCode
            );

            // Lưu vào DB
            notifyUser(userId, message, "ORDER_CONFIRMED");

            sendFCMNotification(userId, "Đơn hàng đã xác nhận", message);

        } catch (Exception e) {
            System.err.println("Error sending order confirmation notification: " + e.getMessage());
        }
    }

    /**
     * Admin xác nhận đã giao cho ĐVVC
     */
    public void notifyOrderShipped(int userId, String orderCode, String shippingProvider) {
        try {
            String message = String.format(
                    "🚚 Đơn hàng %s đã được giao cho đơn vị vận chuyển\n\n" +
                            "Đơn vị vận chuyển: %s\n" +
                            "Đơn hàng đang trên đường đến với bạn!",
                    orderCode,
                    shippingProvider != null ? shippingProvider : "Đang cập nhật"
            );
            notifyUser(userId, message, "ORDER_SHIPPED");

        } catch (Exception e) {
            System.err.println("❌ Error sending shipping notification: " + e.getMessage());
        }
    }

    /**
     * Admin hủy đơn hàng
     */
    public void notifyOrderCancelled(int userId, String orderCode, String reason) {
        try {
            String message = String.format(
                    "❌ Đơn hàng %s đã bị hủy\n\n" +
                            "Lý do: %s\n\n" +
                            "Nếu bạn đã thanh toán, số tiền sẽ được hoàn lại trong 3-7 ngày làm việc.",
                    orderCode,
                    reason != null && !reason.trim().isEmpty() ? reason : "Không có lý do cụ thể"
            );
            notifyUser(userId, message, "ORDER_CANCELLED");

        } catch (Exception e) {
            System.err.println("❌ Error sending cancellation notification: " + e.getMessage());
        }
    }

    /**
     * Admin xác nhận hoàn tiền
     */
    public void notifyRefundApproved(int userId, String orderCode, String refundAmount) {
        try {
            String message = String.format(
                    "💰 Yêu cầu hoàn tiền đã được chấp nhận\n\n" +
                            "Đơn hàng: %s\n" +
                            "Số tiền hoàn: %s\n\n" +
                            "Tiền sẽ được hoàn vào tài khoản của bạn trong 3-7 ngày làm việc.",
                    orderCode,
                    refundAmount
            );
            notifyUser(userId, message, "REFUND_APPROVED");

        } catch (Exception e) {
            System.err.println("❌ Error sending refund approval notification: " + e.getMessage());
        }
    }

    /**
     * Admin từ chối hoàn tiền
     */
    public void notifyRefundRejected(int userId, String orderCode, String reason) {
        try {
            String message = String.format(
                    "⛔ Yêu cầu hoàn tiền bị từ chối\n\n" +
                            "Đơn hàng: %s\n" +
                            "Lý do từ chối: %s\n\n" +
                            "Vui lòng liên hệ bộ phận chăm sóc khách hàng để biết thêm chi tiết.",
                    orderCode,
                    reason != null && !reason.trim().isEmpty() ? reason : "Không đủ điều kiện hoàn tiền"
            );
            notifyUser(userId, message, "REFUND_REJECTED");

        } catch (Exception e) {
            System.err.println("❌ Error sending refund rejection notification: " + e.getMessage());
        }
    }

    /**
     * Thông báo tổng quát cho đơn hàng
     */
    public void notifyOrderUpdate(int userId, String orderCode, String status, String message) {
        try {
            String fullMessage = String.format(
                    "📦 Cập nhật đơn hàng %s\n\n" +
                            "Trạng thái: %s\n" +
                            "%s",
                    orderCode,
                    status,
                    message
            );
            notifyUser(userId, fullMessage, "ORDER_UPDATE");

        } catch (Exception e) {
            System.err.println("❌ Error sending order update notification: " + e.getMessage());
        }
    }

    /**
     * Gửi Firebase Cloud Messaging notification (real-time push)
     * CHỈ CẦN KHI MUỐN PUSH NOTIFICATION THẬT
     */
    private void sendFCMNotification(int userId, String title, String message) {
        try {
            String fcmToken = getUserFCMToken(userId);

            if (fcmToken == null || fcmToken.isEmpty()) {
                System.out.println("⚠️ User " + userId + " chưa có FCM token");
                return;
            }

            // TODO: Implement Firebase Admin SDK
            // Message fcmMessage = Message.builder()
            //     .setToken(fcmToken)
            //     .setNotification(Notification.builder()
            //         .setTitle(title)
            //         .setBody(message)
            //         .build())
            //     .build();
            //
            // FirebaseMessaging.getInstance().send(fcmMessage);

            System.out.println("✅ FCM notification sent to user " + userId);

        } catch (Exception e) {
            System.err.println("❌ Error sending FCM: " + e.getMessage());
        }
    }

    /**
     * Lấy FCM token của user từ database
     */
    private String getUserFCMToken(int userId) {
        try {
            return notificationDao.getFCMToken(userId);
        } catch (Exception e) {
            System.err.println("❌ Error getting FCM token: " + e.getMessage());
            return null;
        }
    }
}