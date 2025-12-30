// firebase-notification.js
// Phiên bản hoàn chỉnh, chạy trực tiếp trên JSP mà không cần bundler

// 1. Firebase Config của bạn (đúng)
const firebaseConfig = {
    apiKey: "AIzaSyAv9tMau9HTCHCyGWYUGh7ZVf4_0IVX9Jc",
    authDomain: "comic-5e20d.firebaseapp.com",
    projectId: "comic-5e20d",
    messagingSenderId: "766720100662",
    appId: "1:766720100662:web:4ddbd85b0d633e70f14b97"
};

// 2. Khởi tạo Firebase (dùng compat để tương thích CDN)
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// 3. Hàm khởi động FCM
function initFirebaseMessaging() {
    // Kiểm tra hỗ trợ trình duyệt
    if (!("Notification" in window)) {
        console.log("Trình duyệt không hỗ trợ Notification API");
        return;
    }

    if (!("serviceWorker" in navigator)) {
        console.log("Trình duyệt không hỗ trợ Service Worker");
        return;
    }

    Notification.requestPermission()
        .then(permission => {
            if (permission !== "granted") {
                console.log("Quyền thông báo bị từ chối");
                return;
            }

            console.log("Quyền thông báo đã được cấp");

            // Lấy token với VAPID key thật (bạn đã có rồi)
            return messaging.getToken({
                vapidKey: "BN76ewq9CfqebyTK_0Q2skO9cUhmyzWSIhR2L2eN6J_Vs_V7wMStLE-YVbRuaQgh_yWKrg91G5g8ejRSNU-qySM"
            });
        })
        .then(token => {
            if (token) {
                console.log("FCM Token:", token);
                sendTokenToServer(token);
            } else {
                console.warn("Không lấy được token");
            }
        })
        .catch(err => {
            console.error("Lỗi lấy FCM token:", err);
        });
}

// 4. Gửi token lên server
function sendTokenToServer(token) {
    const userId = document.body.dataset.userId;

    if (!userId) {
        console.log("User chưa đăng nhập → không gửi token");
        return;
    }

    const contextPath = document.body.dataset.contextPath || '';

    fetch(`${contextPath}/SaveFCMTokenServlet`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            userId: parseInt(userId),
            token: token
        })
    })
        .then(response => {
            if (!response.ok) throw new Error("HTTP " + response.status);
            return response.json();
        })
        .then(data => console.log("Token lưu thành công:", data))
        .catch(err => console.error("Lỗi gửi token:", err));
}

// 5. Nhận thông báo realtime (foreground)
messaging.onMessage((payload) => {
    console.log("Nhận thông báo realtime:", payload);

    // FCM có thể gửi notification hoặc data
    const notification = payload.notification || payload.data;

    if (!notification || !notification.title) {
        console.log("Payload không có title → bỏ qua");
        return;
    }

    const n = new Notification(notification.title, {
        body: notification.body || "",
        icon: "${pageContext.request.contextPath}/img/logo.png",  // ĐÚNG - dùng EL để render đường dẫn
        badge: "${pageContext.request.contextPath}/img/logo.png",
        tag: "comicstore-noti-" + Date.now(),
        data: notification.click_action || "${pageContext.request.contextPath}/"
    });

    n.onclick = () => {
        window.focus();
        if (n.data && n.data !== "${pageContext.request.contextPath}/") {
            window.location.href = n.data;
        }
        n.close();
    };

    // Cập nhật badge header nếu có hàm
    if (typeof updateNotificationBadge === "function") {
        updateNotificationBadge();
    }
});

// 6. Khởi động khi load trang
document.addEventListener("DOMContentLoaded", () => {
    if (document.body.dataset.loggedIn === "true") {
        initFirebaseMessaging();
    }
});