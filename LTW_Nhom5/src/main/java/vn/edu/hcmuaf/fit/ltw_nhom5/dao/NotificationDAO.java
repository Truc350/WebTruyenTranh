package vn.edu.hcmuaf.fit.ltw_nhom5.dao;

import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Notification;

import java.util.List;
import java.util.stream.Collectors;

public class NotificationDAO {
    private static NotificationDAO instance;
    private final Jdbi jdbi;
    private static final int ADMIN_ID = 1;

    public NotificationDAO(Jdbi jdbi) {
        this.jdbi = JdbiConnector.get();
    }

    public NotificationDAO() {
        this.jdbi = JdbiConnector.get();
    }

    public static NotificationDAO getInstance() {
        if (instance == null) {
            instance = new NotificationDAO();
        }
        return instance;
    }

    public int countUnread(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        return JdbiConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, userId)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public List<Notification> getRecent(int userId, int limit) {
        String sql = """
                SELECT id, user_id, message, type, is_read, created_at
                FROM notifications
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
                SELECT id, user_id, message, type, is_read, created_at
                FROM notifications
                WHERE user_id = ?
                """);
        if (typeFilter != null) {
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

    public void markAsread(int notiId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE id = ?";
        JdbiConnector.get().useHandle(handle ->
                handle.createUpdate(sql).bind(0, notiId).execute());
    }

    public void markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        JdbiConnector.get().useHandle(handle ->
                handle.createUpdate(sql).bind(0, userId).execute());
    }

    public void insert(Notification noti) {
        String sql = """
                INSERT INTO notifications (user_id, message, type, is_read, created_at)
                VALUES (?, ?, ?, 0, NOW())
                """;
        JdbiConnector.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, noti.getUserId())
                        .bind(1, noti.getMessage())
                        .bind(2, noti.getType())
                        .execute()
        );
    }

    //THÔNG BÁO CỦA ADMIN VỀ VI PHẠM CỦA USER
    public int countUnreadForAdmin() {
        return countUnread(ADMIN_ID);
    }

    public List<Notification> getRecentForAdmin(int limit) {
        return getRecent(ADMIN_ID, limit);
    }

    public void insertForAdmin(Notification noti) {
        noti.setUserId(ADMIN_ID);
        insert(noti);
    }
}