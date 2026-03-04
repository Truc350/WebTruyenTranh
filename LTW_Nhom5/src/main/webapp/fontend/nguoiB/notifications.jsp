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
        <div id="notification-list-area" style="min-height:300px; max-height:480px; overflow-y:auto;">
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

        document.getElementById('mark-all-read-btn').addEventListener('click', markAllRead);
    });

    async function loadNotifications() {
        const container = document.querySelector('.notification-container');
        const listArea = document.getElementById('notification-list-area');
        const activeTab = container.querySelector('.tab.active');
        let type = activeTab ? (activeTab.dataset.type || 'ALL') : 'ALL';

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
            data.notifications.forEach(function(n) {
                const unreadStyle = n.is_read ? '' : 'background:#f0f8ff;font-weight:600;border-left:4px solid #007bff;padding-left:16px;';
                const title = n.title || 'Thông báo';
                const message = (n.message || '').replace(/\n/g, '<br>');
                const formattedDate = n.formatted_date || '';
                const notiId = n.id || 0;

                let icon = '<i class="fa-solid fa-bell" style="color:#666;"></i>';
                if (n.type === 'ORDER_CONFIRMED')  icon = '<i class="fa-solid fa-circle-check" style="color:#28a745;"></i>';
                else if (n.type === 'ORDER_SHIPPED')   icon = '<i class="fa-solid fa-truck" style="color:#007bff;"></i>';
                else if (n.type === 'ORDER_CANCELLED') icon = '<i class="fa-solid fa-circle-xmark" style="color:#dc3545;"></i>';
                else if (n.type === 'ORDER_DELIVERED') icon = '<i class="fa-solid fa-box" style="color:#6f42c1;"></i>';
                else if (n.type === 'REFUND_APPROVED') icon = '<i class="fa-solid fa-money-bill-wave" style="color:#fd7e14;"></i>';
                else if (n.type === 'REFUND_REJECTED') icon = '<i class="fa-solid fa-ban" style="color:#dc3545;"></i>';
                else if (n.type === 'ORDER_UPDATE')    icon = '<i class="fa-solid fa-box-open" style="color:#17a2b8;"></i>';
                else if (n.type === 'PROMOTION')       icon = '<i class="fa-solid fa-tag" style="color:#e83e8c;"></i>';

                html += '<div id="noti-' + notiId + '"style="display:flex;gap:12px;align-items:flex-start;padding:16px;margin-bottom:4px;border-bottom:1px solid #eee;border-radius:6px;cursor:pointer;' + unreadStyle + '" '
                    + 'onclick="markReadAndGo(' + notiId + ')">'
                    +   '<div style="font-size:22px;padding-top:2px;flex-shrink:0;">' + icon + '</div>'
                    +   '<div style="flex:1;">'
                    +     '<strong style="font-size:15px;display:block;margin-bottom:4px;' + (n.is_read ? '' : 'font-weight:700;') + '">' + title + '</strong>'
                    +     '<div style="color:#555;font-size:13px;margin-bottom:6px;line-height:1.5;">' + message + '</div>'
                    +     '<small style="color:#aaa;font-size:12px;"><i class="fa-regular fa-clock"></i> ' + formattedDate + '</small>'
                    +   '</div>'
                    + '</div>';
            });

            listArea.innerHTML = html;

            const hash = window.location.hash;
            if (hash && hash.startsWith('#noti-')) {
                const targetEl = document.querySelector(hash);
                if (targetEl) {
                    setTimeout(function() {
                        targetEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        targetEl.style.transition = 'background 0.5s';
                        targetEl.style.background = '#fff3cd';
                        setTimeout(function() {
                            targetEl.style.background = '';
                        }, 2000);
                    }, 300);
                }
            }

        } catch (err) {
            console.error('Lỗi load thông báo:', err);
            listArea.innerHTML = '<div style="text-align:center;padding:60px;color:red;">Lỗi tải thông báo</div>';
        }
    }

    async function markReadAndGo(id) {
        try {
            await fetch('${pageContext.request.contextPath}/NotificationServlet/mark-read?id=' + id, {
                method: 'POST',
                credentials: 'include'
            });
            loadNotifications();
        } catch (err) {
            console.error('Lỗi đánh dấu đã đọc:', err);
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