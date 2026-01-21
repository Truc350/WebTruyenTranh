<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông báo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/FooterStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/publicCss/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fontend/css/UserBCss/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<jsp:include page="/fontend/public/header.jsp"/>

<main>
    <jsp:include page="/fontend/nguoiB/ASideUser.jsp"/>

    <div class="notification-container">
        <div class="tabs">
            <div class="tab active" data-type="ALL">Tất cả</div>
            <div class="tab" data-type="ORDER">Đơn Hàng</div>
            <div class="tab" data-type="EVENT">Sự kiện</div>
        </div>
        <div class="line"></div>
        <div id="notification-list-area" style="min-height:300px;">
            <div style="text-align:center;padding:60px;color:#999;">Đang tải thông báo...</div>
        </div>
        <div style="text-align:center;padding:20px;">
            <button id="mark-all-read-btn" style="padding:10px 20px;background:#007bff;color:white;border:none;border-radius:4px;cursor:pointer;display:none;">
                Đánh dấu tất cả đã đọc
            </button>
        </div>
    </div>
</main>

<jsp:include page="/fontend/public/Footer.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        loadNotifications();

        // Tab switching
        document.querySelectorAll('.notification-container .tab').forEach(tab => {
            tab.addEventListener('click', function () {
                document.querySelectorAll('.notification-container .tab').forEach(t =>
                    t.classList.remove('active')
                );
                this.classList.add('active');
                loadNotifications();
            });
        });

        // Mark all read button
        document.getElementById('mark-all-read-btn').addEventListener('click', markAllRead);
    });

    async function loadNotifications() {
        const container = document.querySelector('.notification-container');
        const listArea = document.getElementById('notification-list-area');

        const activeTab = container.querySelector('.tab.active');
        let type = 'ALL';
        if (activeTab) {
            type = activeTab.dataset.type || 'ALL';
        }

        listArea.innerHTML = '<div style="text-align:center;padding:60px;color:#999;">Đang tải thông báo...</div>';

        try {
            const response = await fetch('${pageContext.request.contextPath}/NotificationServlet/list?type=' + type, {
                credentials: 'include'
            });

            if (!response.ok) throw new Error('HTTP ' + response.status);

            const data = await response.json();

            if (!data.notifications || data.notifications.length === 0) {
                listArea.innerHTML = '<div style="text-align:center;padding:80px;color:#999;font-size:16px;">Không có thông báo nào.</div>';
                document.getElementById('mark-all-read-btn').style.display = 'none';
                return;
            }

            document.getElementById('mark-all-read-btn').style.display = 'block';

            let html = '';
            data.notifications.forEach(n => {
                const unreadStyle = n.is_read ? '' : 'background:#f0f8ff; font-weight:600; border-left:4px solid #007bff; padding-left:16px;';
                html += `
                <div style="padding:16px; margin-bottom:8px; border-bottom:1px solid #eee; border-radius:6px; cursor:pointer; ${unreadStyle}"
                     onclick="markReadAndGo(${n.id}, '${n.link}')">
                    <strong style="font-size:16px;display:block;margin-bottom:6px;">${n.title}</strong>
                    <div style="color:#555;font-size:14px;margin-bottom:10px;">${n.message}</div>
                    <small style="color:#999;font-size:13px;">${n.formatted_date}</small>
                </div>
            `;
            });

            listArea.innerHTML = html;

        } catch (err) {
            console.error('Lỗi load thông báo:', err);
            listArea.innerHTML = '<div style="text-align:center;padding:60px;color:red;">Lỗi tải thông báo<br><small>Vui lòng làm mới trang</small></div>';
        }
    }

    async function markReadAndGo(id, link) {
        try {
            await fetch('${pageContext.request.contextPath}/NotificationServlet/mark-read?id=' + id, {
                method: 'POST',
                credentials: 'include'
            });
            loadNotifications();
            if (link && link !== '#' && link !== '') {
                window.location.href = link;
            }
        } catch (err) {
            alert('Lỗi đánh dấu đã đọc');
        }
    }

    async function markAllRead() {
        if (!confirm('Đánh dấu tất cả thông báo là đã đọc?')) return;
        try {
            await fetch('${pageContext.request.contextPath}/NotificationServlet/mark-all-read', {
                method: 'POST',
                credentials: 'include'
            });
            loadNotifications();
        } catch (err) {
            alert('Lỗi thực hiện');
        }
    }
</script>

</body>
</html>