package vn.edu.hcmuaf.fit.ltw_nhom5.service;

import vn.edu.hcmuaf.fit.ltw_nhom5.model.NotificationDTO;

import java.util.ArrayList;
import java.util.List;

public class NotificationService {
    private static final NotificationService instance = new NotificationService();

    public static NotificationService getInstance() {
        return instance;
    }

    private List<NotificationDTO> list = new ArrayList<>();
    String sql = "SELECT id, message, type, is_read, created_at FROM Notifications where user_id =  ?";
    List<Object> params = new ArrayList<>();


}
