package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import vn.edu.hcmuaf.fit.ltw_nhom5.dao.NotificationDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Notification;

public class NotificationService {

    private static NotificationService instance;

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

        NotificationDAO.getInstance().insertForAdmin(noti);

        System.out.println(" [NotificationService] Đã gửi thông báo vi phạm cho admin về user " + violatorUserId);
    }

    /**
     * Gửi thông báo cho user
     *  SỬA: Chỉ dùng message, không dùng title
     */
    public void notifyUser(int userId, String message, String type) {
        Notification noti = new Notification();
        noti.setUserId(userId);
        noti.setMessage(message);
        noti.setType(type);

        NotificationDAO.getInstance().insert(noti);

        System.out.println(" [NotificationService] Đã gửi thông báo cho user " + userId);
    }
}