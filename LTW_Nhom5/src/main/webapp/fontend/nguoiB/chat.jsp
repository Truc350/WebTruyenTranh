<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Comic Store - Chat Người Mua - Người Bán</title>
    <link rel="stylesheet" href="../css/publicCss/FooterStyle.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="../css/publicCss/nav.css">
    <link rel="stylesheet" href="../css/UserBCss/chat.css">
</head>
<body>

<header class="navbar">
    <a href="../public/homePage.jsp">
        <div class="logo">
            <img id="logo" src="../../img/logo.png" alt="Comic Store">
            <span>Comic Store</span>
        </div>
    </a>
    <nav class="menu">
        <a href="../public/homePage.jsp">Trang chủ</a>

        <div class="dropdown">
            <a href="#">Thể loại &#9662;</a>
            <div class="dropdown-content">
                <a href="../public/CatagoryPage.jsp">Hành động</a>
                <a href="#">Phiêu lưu</a>
                <a href="#">Lãng mạn </a>
                <a href="#">Học đường</a>
                <a href="#">Kinh dị</a>
                <a href="#">Hài hước</a>
                <a href="#">Giả tưởng</a>
                <a href="#">Trinh thám</a>
                <!-- <a href="#">Cổ đại</a>
                <a href="#">Đời thường</a> -->
            </div>
        </div>

        <a href="../public/AbouUS.jsp">Liên hệ</a>
    </nav>
    <div class="search-bar">
        <input type="text" placeholder="Voucher Xịn đến 100 nghìn" class="search-input">
        <button class="search-button">
            <i class="fas fa-magnifying-glass"></i>
        </button>
    </div>
    <div class="contain-left">

        <div class="actions">
            <div class="notify-wrapper">
                <a href="profile.jsp" class="bell-icon">
                    <i class="fa-solid fa-bell"></i>
                    <span id="span-bell">2</span>
                </a>
                <!-- Khung thông báo -->
                <div class="notification-panel">
                    <div class="notification-header">
                        <div class="inform-num">
                            <i class="fa-solid fa-bell"></i>
                            <span>Thông báo</span>
                            <span class="notification-badge">(1)</span>
                        </div>
                        <div class="inform-all">
                            <a href="profile.jsp">Xem tất cả</a>
                        </div>
                    </div>
                    <div class="notification-content inform1">
                        <strong>Cập nhật email ngay để nhận voucher nhé!</strong><br>
                        Bạn vừa đăng kí tài khoản. Hãy cập nhật email ngay để nhận được các thông báo và phần quà
                        hấp
                        dẫn.
                    </div>
                    <div class="notification-content inform2">
                        <strong>Cập nhật email ngay để nhận vorcher nhé!</strong><br>
                        Bạn vừa đăng kí tài khoản.Hãy cập nhật email ngay để nhận được các thông báo và phần quà hấp
                        dẫn.
                    </div>
                </div>
            </div>
        </div>

        <div class="actions">
            <a href="chat.html">
                <i class="fa-solid fa-comment"></i>
            </a>
        </div>

        <div class="actions">
            <a href="cart.jsp">
                <i class="fa-solid fa-cart-shopping"></i>
            </a>
        </div>

        <div class="actions user-nav">
            <i class="fa-solid fa-user" id="user"></i>
            <div class="dropdown-user">
                <a href="../public/homePage.jsp">Trang chủ</a>
                <a href="../public/login.jsp">Đăng xuất</a>
            </div>
        </div>
    </div>
</header>

<!-- Chat Container -->
<div class="chat-container">
    <!-- Chat Area -->
    <div class="chat-area">
        <div class="chat-header" id="chatHeader">
            <img src="https://i.pravatar.cc/150?img=1" alt="" class="user-avatar">
            <div class="header-info">
                <h3>ComicStore</h3>
                <small><i class="fas fa-circle online-dot"></i> Đang hoạt động</small>
            </div>
            <button class="header-action"><i class="fas fa-ellipsis-v"></i></button>
        </div>

        <div class="chat-messages" id="chatMessages">
            <div class="message received">
                <div class="bubble">Chào bạn! Mình có thể giúp gì ạ?</div>
                <div class="timestamp">10:32</div>
            </div>
            <div class="message sent">
                <div class="bubble">Mình cần tư vấn về sản phẩm</div>
                <div class="timestamp">10:33</div>
            </div>
        </div>

        <!-- Typing indicator -->
        <div class="typing-indicator" id="typingIndicator" style="display: none;">
            <span></span><span></span><span></span>
        </div>

        <!-- Chat input -->
        <div class="chat-input">
            <label class="input-action" for="imageInput" title="Gửi ảnh">
                <i class="fas fa-image"></i>
            </label>
            <input type="file" id="imageInput" accept="image/*" style="display: none;"/>
            <textarea id="messageInput" placeholder="Nhập tin nhắn..." rows="1"></textarea>
            <button class="input-action emoji-btn"><i class="fas fa-smile"></i></button>
            <button class="send-btn" onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
        </div>

        <!-- Image preview -->
        <div id="imagePreview" class="image-preview" style="display: none;">
            <img id="previewImg" src="" alt="Preview"/>
            <button class="close-preview" onclick="closePreview()">×</button>
            <button class="send-image-btn" onclick="sendImage()">Gửi</button>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="footer-container">
        <!-- Cột 1: Giới thiệu -->
        <div class="footer-column">
            <div class="logo">
                <a href="#">
                    <img src="../../img/logo.png" alt="logo"><!--420-780-->
                </a>
            </div>
            <p><b>ComicStore</b> là cửa hàng truyện tranh<br> trực tuyến hàng đầu Việt Nam<br> — nơi bạn có thể mua
                truyện
                giấy,<br>
                đọc truyện online và<br> khám phá thế giới<br> manga – manhwa – comic đa dạng.</p>
            <p>Thành lâp năm <strong>2025</strong>, chúng tôi mang đến hơn
                <str>10.000+</str>
                <br>
                truyện hấp dẫn cho bạn
            </p>
        </div>

        <!-- Cột 2: Liên kết nhanh -->
        <div class="footer-column">
            <h4><i class="fa-solid fa-link"></i> Liên kết nhanh</h4>
            <ul>
                <li><a href="../public/homePage.jsp">Trang chủ</a></li>
                <li><a href="../public/FlashSale.jsp">Khuyến mãi</a></li>
                <li><a href="cart.jsp">Giỏ hàng</a></li>
                <li><a href="../public/AbouUS.jsp">Liên hệ</a></li>
            </ul>
        </div>

        <!-- Cột 3: Hỗ trợ khách hàng -->
        <div class="footer-column">
            <h4><i class="fa-solid fa-headset"></i> Hỗ trợ khách hàng</h4>
            <ul>
                <li><a href="RefundPolicy.jsp">Chính sách đổi trả</a></li>
                <li><a href="shippingPolicy.jsp">Chính sách vận chuyển</a></li>
            </ul>
        </div>

        <!-- Cột 4: Liên hệ & Mạng xã hội -->
        <div class="footer-column">
            <h4><i class="fa-solid fa-envelope"></i> Liên hệ</h4>
            <p><i class="fa-solid fa-envelope"></i> support@metruyen.vn</p>
            <p><i class="fa-solid fa-phone"></i> 0123 456 789</p>
            <p><i class="fa-solid fa-location-dot"></i> 123 Nguyễn Huệ, Q.1, TP.HCM</p>

            <div class="social-links">
                <a href="https://www.facebook.com/share/1MVc1miHnd/" title="Facebook"><i
                        class="fab fa-facebook-f"></i></a>
                <a href="https://www.instagram.com/comic.store/" title="Instagram"><i
                        class="fab fa-instagram"></i></a>
                <a href="https://www.tiktok.com/@comics_store.oficial" title="TikTok"><i
                        class="fab fa-tiktok"></i></a>
            </div>
        </div>

        <!-- Cột 5: Thanh toán -->
        <div class="footer-column">
            <h4><i class="fa-solid fa-shield-halved"></i> Thanh toán & Bảo mật</h4>
            <p>Hỗ trợ thanh toán qua:</p>
            <div class="payment-icons">
                <img src="../../img/momo.png" alt="Momo">
                <img src="../../img/zalopay.png" alt="ZaloPay">
            </div>
            <p>Website đã đăng ký với Bộ Công Thương.</p>
        </div>
    </div>

    <div class="footer-bottom">
        <p>© 2025 <strong>ComicStore.vn</strong> — All rights reserved.</p>
    </div>
</footer>

<script>
    // === KEY LƯU TRỮ TRONG LOCALSTORAGE ===
    const STORAGE_KEY = 'comicstore_chat_history';

    // === LOAD DỮ LIỆU TỪ LOCALSTORAGE ===
    let conversations = {};
    try {
        const saved = localStorage.getItem(STORAGE_KEY);
        if (saved) {
            conversations = JSON.parse(saved);
        }
    } catch (e) {
        console.warn("Không thể đọc lịch sử chat:", e);
    }

    // === DỮ LIỆU MẶC ĐỊNH ===
    const defaultConversations = {
        1: {
            user: { name: "ComicStore", avatar: "https://i.pravatar.cc/150?img=1", online: true },
            messages: [
                { text: "Chào bạn! Mình có thể giúp gì ạ?", type: "received", time: "10:32" },
                { text: "Mình cần tư vấn về sản phẩm", type: "sent", time: "10:33" }
            ]
        }
    };

    // Gộp dữ liệu mặc định nếu chưa tồn tại
    Object.keys(defaultConversations).forEach(id => {
        if (!conversations[id]) {
            conversations[id] = defaultConversations[id];
        }
    });

    const currentUserId = 1;

    // === LƯU VÀO LOCALSTORAGE ===
    function saveToStorage() {
        try {
            localStorage.setItem(STORAGE_KEY, JSON.stringify(conversations));
        } catch (e) {
            console.warn("Không thể lưu lịch sử chat:", e);
        }
    }

    // === HIỂN THỊ HỘI THOẠI ===
    function loadConversation() {
        const conv = conversations[currentUserId];
        const header = document.getElementById('chatHeader');
        const messagesDiv = document.getElementById('chatMessages');

        // Cập nhật header
        header.innerHTML = `
        <img src="${conv.user.avatar}" alt="" class="user-avatar">
        <div class="header-info">
            <h3>Comic Store</h3>
            <small><i class="fas fa-circle online-dot"></i> ${conv.user.online ? 'Đang hoạt động' : 'Offline'}</small>
        </div>
        <button class="header-action"><i class="fas fa-ellipsis-v"></i></button>
`;

        // Load tin nhắn
        messagesDiv.innerHTML = '';
        conv.messages.forEach(msg => {
            const messageEl = document.createElement('div');
            messageEl.className = `message ${msg.type}`;
            messageEl.innerHTML = `
            <div class="bubble">${msg.text}</div>
            <div class="timestamp">${msg.time}</div>
        `;
            messagesDiv.appendChild(messageEl);
        });

        messagesDiv.scrollTop = messagesDiv.scrollHeight;
    }

    // === GỬI TIN NHẮN ===
    function sendMessage() {
        const input = document.getElementById('messageInput');
        const text = input.value.trim();
        if (!text) return;

        const time = new Date().toLocaleTimeString('vi', { hour: '2-digit', minute: '2-digit' });

        // Thêm tin nhắn gửi
        const messagesDiv = document.getElementById('chatMessages');
        const msg = document.createElement('div');
        msg.className = 'message sent';
        msg.innerHTML = `<div class="bubble">${text}</div><div class="timestamp">${time}</div>`;
        messagesDiv.appendChild(msg);
        messagesDiv.scrollTop = messagesDiv.scrollHeight;

        // Lưu vào dữ liệu + localStorage
        conversations[currentUserId].messages.push({ text, type: 'sent', time });
        saveToStorage();

        input.value = '';
        input.style.height = 'auto';

        // Typing + phản hồi
        showTyping();
        setTimeout(() => {
            hideTyping();
            const reply = getAutoReply();
            const replyTime = new Date().toLocaleTimeString('vi', { hour: '2-digit', minute: '2-digit' });
            addReceivedMessage(reply, replyTime);

            // Lưu phản hồi
            conversations[currentUserId].messages.push({ text: reply, type: 'received', time: replyTime });
            saveToStorage();
        }, 1000 + Math.random() * 1000);
    }

    // === HIỆU ỨNG TYPING ===
    function showTyping() {
        const typing = document.getElementById('typingIndicator');
        typing.style.display = 'flex';
        document.getElementById('chatMessages').scrollTop = document.getElementById('chatMessages').scrollHeight;
    }

    // === THÊM TIN NHẬN ===
    function addReceivedMessage(text, time) {
        const messagesDiv = document.getElementById('chatMessages');
        const msg = document.createElement('div');
        msg.className = 'message received';
        msg.innerHTML = `<div class="bubble">${text}</div><div class="timestamp">${time}</div>`;
        messagesDiv.appendChild(msg);
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
    }

    // === PHẢN HỒI TỰ ĐỘNG ===
    function getAutoReply() {
        const replies = [
            "Cảm ơn bạn! Mình đang kiểm tra giúp bạn nhé!",
            "Sản phẩm đang có sẵn ạ, bạn cần size nào?",
            "Mình sẽ gửi hình ảnh chi tiết ngay!",
            "Bạn muốn đặt hàng luôn không ạ?",
            "Đã nhận được yêu cầu, mình xử lý ngay!"
        ];
        return replies[Math.floor(Math.random() * replies.length)];
    }

    // === ENTER GỬI TIN ===
    document.getElementById('messageInput').addEventListener('keypress', e => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });

    // === TỰ ĐỘNG RESIZE ===
    const textarea = document.getElementById('messageInput');
    textarea.addEventListener('input', function () {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
    });

    // === KHỞI TẠO ===
    document.addEventListener('DOMContentLoaded', () => {
        loadConversation();
    });
</script>
</body>
</html>