package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Notification;

import java.util.List;
import java.util.stream.Collectors;

public class NotificationDAO {
    private static NotificationDAO instance;

    public static NotificationDAO getInstance() {
        if (instance == null) {
            instance = new NotificationDAO();
        }
        return instance;
    }

    public int countUnread(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE user_id = ? AND is_read = 0";
        return JdbiConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, userId)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public List<Notification> getRecent(int userId, int limit) {
        String sql = """
                SELECT id, user_id, title, message, type, is_read, related_id, related_type, created_at, read_at
                FROM Notifications
                WHERE user_id = ?
                ORDER BY created_at DESC
                LIMIT ?
                """;
        return JdbiConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, userId)
                        .bind(1, limit)
                        .mapToBean(Notification.class)
                        .collect(Collectors.toList())
        );
    }

    public List<Notification> getList(int userId, String typeFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("""
                SELECT id, user_id, title, message, type, is_read, related_id, related_type, created_at, read_at
                FROM Notifications
                WHERE user_id = ?
                """);
        if (typeFilter != null) { // ĐÃ BỎ ĐIỀU KIỆN !typeFilter.equals("ALL") ĐỂ TRÁNH NULL
            sql.append(" AND type = ?");
        }
        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");

        return JdbiConnector.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString()).bind(0, userId);
            int paramIndex = 1;
            if (typeFilter != null) {
                query.bind(paramIndex++, typeFilter);
            }
            query.bind(paramIndex++, pageSize);
            query.bind(paramIndex, (page - 1) * pageSize);
            return query.mapToBean(Notification.class).list();
        });
    }

    public void markAsread(long notiId) {
        String sql = "UPDATE Notifications SET is_read = 1, read_at = NOW() WHERE id = ?";
        JdbiConnector.get().useHandle(handle ->
                handle.createUpdate(sql).bind(0, notiId).execute());
    }

    public void markAllAsRead(int userId) {
        String sql = "UPDATE Notifications SET is_read = 1, read_at = NOW() WHERE user_id = ? AND is_read = 0"; // ĐÃ SỬA TYPO
        JdbiConnector.get().useHandle(handle ->
                handle.createUpdate(sql).bind(0, userId).execute());
    }

    public void insert(Notification noti) {
        String sql = """
                INSERT INTO Notifications (user_id, title, message, type, is_read, related_id, related_type, created_at)
                VALUES (?, ?, ?, ?, 0, ?, ?, NOW())
                """;
        JdbiConnector.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, noti.getUserId())
                        .bind(1, noti.getTitle())
                        .bind(2, noti.getMessage())
                        .bind(3, noti.getType())
                        .bind(4, noti.getRelatedId())
                        .bind(5, noti.getRelatedType())
                        .execute()
        );
    }
}