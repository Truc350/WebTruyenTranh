
// Lưu trữ tin nhắn (mô phỏng)
let messages = {};
let currentUserId = null;

// Hàm chọn người dùng
function selectUser(userId) {
    currentUserId = userId;
    const userList = document.getElementById('userList');
    const selectedUser = userList.querySelector(`[data-user-id="${userId}"] span`).textContent;
    document.getElementById('chatHeader').innerHTML = `<h3>Chat với ${selectedUser}</h3>`;
    loadMessages(userId);
}

// Hàm tải tin nhắn
function loadMessages(userId) {
    if (!messages[userId]) {
        messages[userId] = [];
    }
    const chatMessages = document.getElementById('chatMessages');
    chatMessages.innerHTML = '';
    messages[userId].forEach(msg => {
        addMessageToChat(msg.text, msg.sender, msg.timestamp);
    });
}

// Hàm thêm tin nhắn vào giao diện
function addMessageToChat(text, sender, timestamp) {
    const chatMessages = document.getElementById('chatMessages');
    const messageDiv = document.createElement('div');
    messageDiv.classList.add('message');
    messageDiv.classList.add(sender === 'me' ? 'sent' : 'received');
    messageDiv.innerHTML = `
        <p>${text}</p>
        <span class="timestamp">${timestamp}</span>
    `;
    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight; // Cuộn xuống cuối
}

// Hàm gửi tin nhắn
function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const text = messageInput.value.trim();
    if (!text || !currentUserId) return;

    const timestamp = new Date().toLocaleString('vi-VN', {
        hour: '2-digit',
        minute: '2-digit',
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour12: true
    }).replace(',', ''); // Định dạng: 02:57 PM 26/10/2025

    // Mô phỏng gửi tin nhắn
    const message = { text, sender: 'me', timestamp };
    if (!messages[currentUserId]) {
        messages[currentUserId] = [];
    }
    messages[currentUserId].push(message);
    addMessageToChat(text, 'me', timestamp);

    // Xóa nội dung input
    messageInput.value = '';

    // Mô phỏng phản hồi từ người bán (AJAX mock)
    setTimeout(() => {
        const reply = { text: `Cảm ơn bạn! Tin nhắn của bạn đã được nhận vào ${timestamp}`, sender: 'other', timestamp };
        messages[currentUserId].push(reply);
        addMessageToChat(reply.text, 'received', reply.timestamp);
    }, 1000); // Trả lời sau 1 giây
}

// Gọi hàm khi nhấn Enter
document.getElementById('messageInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
    }
});