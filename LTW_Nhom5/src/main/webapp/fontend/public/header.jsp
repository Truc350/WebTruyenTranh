<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="vn.edu.hcmuaf.fit.ltw_nhom5.model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao" %>
<%@ page import="vn.edu.hcmuaf.fit.ltw_nhom5.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<header class="navbar">
    <a href="${pageContext.request.contextPath}/home">
        <div class="logo">
            <img id="logo" src="${pageContext.request.contextPath}/img/logo.png" alt="Comic Store">
            <span>Comic Store</span>
        </div>
    </a>
    <nav class="menu">
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a>

        <div class="dropdown">
            <a href="#">Thể loại &#9662;</a>
            <div class="dropdown-content">
                <%
                    List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");

                    // Nếu chưa có trong request thì tự load luôn chỗ này
                    if (listCategories == null || listCategories.isEmpty()) {
                        CategoriesDao categoriesDao = new CategoriesDao();
                        listCategories = categoriesDao.listCategories();
                    }

                    //List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                    if (listCategories != null && !listCategories.isEmpty()) {
                        for (Category c : listCategories) {
                %>
                <a href="${pageContext.request.contextPath}/category?id=<%= c.getId() %>"><%= c.getNameCategories() %>
                </a>
                <%
                    }
                } else {
                %>
                <a href="#">KHÔNG CÓ</a>
                <%
                    }
                %>
            </div>
        </div>


        <a href="${pageContext.request.contextPath}/fontend/public/AbouUS.jsp">Liên hệ</a>
    </nav>
    <div class="search-bar">
        <div class="search-box">
            <form action="${pageContext.request.contextPath}/search" method="get" accept-charset="UTF-8">
                <input type="text"
                       id="searchInput"
                       name="keyword"
                       placeholder="Tìm truyện..."
                       class="search-input"
                       autocomplete="off"
                       value="${param.keyword != null ? param.keyword : ''}">
                <button type="submit" class="search-button">
                    <i class="fas fa-magnifying-glass"></i>
                </button>
            </form>

            <div id="searchDropdown" class="search-history-dropdown">
                <div class="history-header">
                    <span>Lịch sử tìm kiếm</span>
                    <span class="clear-all" id="clearAll">Xóa tất cả</span>
                </div>

                <div class="history-tags-container" id="historyTagsContainer">
                </div>
            </div>
        </div>
    </div>

    <div class="contain-left">
        <div class="actions">
            <div class="notify-wrapper">
                <a href="#" class="bell-icon" id="bell-icon">
                    <i class="fa-solid fa-bell"></i>
                    <span class="notification-badge" id="notification-badge">0</span>
                </a>

                <!-- Dropdown thông báo -->
                <div class="notification-panel" id="notification-panel">
                    <div class="notification-header">
                        <div class="inform-num">
                            <i class="fa-solid fa-bell"></i>
                            <span>Thông báo</span>
                            <span class="notification-badge" id="header-badge-count">(0)</span>
                        </div>
                        <div class="inform-all">
                            <a href="${pageContext.request.contextPath}/fontend/nguoiB/profile.jsp#notifications">Xem
                                tất cả</a>
                        </div>
                    </div>

                    <div class="notification-list" id="header-notification-list">
                        <div class="empty-noti">Chưa có thông báo mới</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/fontend/nguoiB/chat.jsp">
                <i class="fa-solid fa-comment"></i>
            </a>
        </div>

        <div class="actions cart-icon-wrapper">
            <a href="${pageContext.request.contextPath}/cart" class="cart-icon">
                <i class="fa-solid fa-cart-shopping"></i>
                <c:if test="${not empty sessionScope.cart && fn:length(sessionScope.cart.items) > 0}">
                    <span class="cart-badge">${fn:length(sessionScope.cart.items)}</span>
                </c:if>
            </a>
        </div>

        <div class="actions user-nav">
            <i class="fa-solid fa-user" id="user"></i>
            <div class="dropdown-user">
                <a href="${pageContext.request.contextPath}/fontend/nguoiB/profile.jsp">Người dùng</a>

                <%
                    User curnentUser = (User) session.getAttribute("currentUser");
                    if (curnentUser != null) {
                %>
                <a href="<%= request.getContextPath() %>/logout">Đăng xuất</a>
                <%
                } else {

                %>
                <a href="<%= request.getContextPath() %>/login">Đăng nhập</a>
                <%
                    }
                %>


            </div>
        </div>
    </div>
</header>


<script>
    const searchInput = document.getElementById('searchInput');
    const dropdown = document.getElementById('searchDropdown');
    const tagsContainer = document.getElementById('historyTagsContainer');
    const clearAllBtn = document.getElementById('clearAll');

    const STORAGE_KEY = 'comicstore_search_history';
    let searchHistory = JSON.parse(localStorage.getItem(STORAGE_KEY)) || [];

    function saveHistory() {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(searchHistory));
    }

    // function positionDropdown() {
    //     const rect = searchInput.getBoundingClientRect();
    //     dropdown.style.top = (rect.bottom + 6) + 'px';
    //     dropdown.style.left = rect.left + 'px';
    //     dropdown.style.width = rect.width + 'px';
    // }

    function removeHistoryItem(term) {
        searchHistory = searchHistory.filter(t => t !== term);
        saveHistory();
        renderHistory();
    }

    function renderHistory() {
        tagsContainer.innerHTML = '';

        if (!searchHistory.length) {
            tagsContainer.innerHTML = '<div style="padding:12px 16px;color:#999;font-style:italic;text-align:center">Không có lịch sử</div>';
            return;
        }

        // Hiển thị tối đa 20 item
        searchHistory.slice(0, 20).forEach(term => {
            const tag = document.createElement('div');
            tag.className = 'history-tag';

            const text = document.createElement('span');
            text.textContent = term;
            text.onclick = () => {
                searchInput.value = term;
                hideDropdown();
                searchInput.form.submit();
            };

            const removeBtn = document.createElement('span');
            removeBtn.className = 'remove';
            removeBtn.innerHTML = '×';
            removeBtn.onclick = (e) => {
                e.stopPropagation();
                removeHistoryItem(term);
            };

            tag.appendChild(text);
            tag.appendChild(removeBtn);
            tagsContainer.appendChild(tag);
        });
    }

    function showDropdown() {
        // positionDropdown();
        renderHistory();
        dropdown.classList.add('show');
    }

    function hideDropdown() {
        dropdown.classList.remove('show');
    }

    searchInput.addEventListener('focus', showDropdown);
    searchInput.addEventListener('input', showDropdown);

    document.addEventListener('click', (e) => {
        if (!dropdown.contains(e.target) && e.target !== searchInput) {
            hideDropdown();
        }
    });

    // window.addEventListener('resize', hideDropdown);
    window.addEventListener('scroll', hideDropdown);

    searchInput.form.addEventListener('submit', (e) => {
        const term = searchInput.value.trim();
        if (!term) {
            e.preventDefault();
            return;
        }

        // ✅ Lấy button element trước khi dùng
        const searchButton = document.querySelector('.search-button');
        if (searchButton) {
            searchButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        }

        // Xóa term cũ nếu đã tồn tại
        searchHistory = searchHistory.filter(t => t !== term);
        // Thêm vào đầu mảng
        searchHistory.unshift(term);
        // Giới hạn 20 item
        if (searchHistory.length > 20) searchHistory.pop();

        saveHistory();
    });

    clearAllBtn.onclick = () => {
        if (confirm('Xóa toàn bộ lịch sử?')) {
            searchHistory = [];
            saveHistory();
            renderHistory();
        }
    };
</script>
<script>
    async function loadHeaderNotifications() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/NotificationServlet/recent?limit=8');
            if (!response.ok) throw new Error('Network error');

            const data = await response.json();

            // Cập nhật badge
            const count = data.unread_count || 0;
            document.getElementById('notification-badge').textContent = count;
            document.getElementById('notification-badge').style.display = count > 0 ? 'flex' : 'none';
            document.getElementById('header-badge-count').textContent = `(${count})`;

            const list = document.getElementById('header-notification-list');

            if (!data.notifications || data.notifications.length === 0) {
                list.innerHTML = '<div class="empty-noti">Chưa có thông báo mới</div>';
                return;
            }

            let html = '';
            data.notifications.forEach(n => {
                const unreadClass = n.is_read ? '' : 'unread';
                html += `
                <a href="${n.link || '#'}" class="header-noti-item ${unreadClass}" data-id="${n.id}">
                    <div class="title">${n.title}</div>
                    <div class="msg">${n.message}</div>
                    <div class="time">${n.formatted_date}</div>
                </a>
            `;
            });
            list.innerHTML = html;

            // Click thông báo → đánh dấu đã đọc
            document.querySelectorAll('.header-noti-item').forEach(item => {
                item.addEventListener('click', async function (e) {
                    if (this.classList.contains('unread')) {
                        const id = this.dataset.id;
                        await fetch('${pageContext.request.contextPath}/NotificationServlet/mark-read?id=' + id, {method: 'POST'});
                        loadHeaderNotifications(); // refresh lại
                    }
                });
            });

        } catch (err) {
            console.error('Lỗi load thông báo header:', err);
            document.getElementById('header-notification-list').innerHTML =
                '<div class="empty-noti">Lỗi kết nối. Thử lại sau.</div>';
        }
    }

    // Mở/đóng dropdown
    document.addEventListener('DOMContentLoaded', () => {
        const bell = document.getElementById('bell-icon');
        const panel = document.getElementById('notification-panel');

        bell.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();

            if (panel.style.display === 'block') {
                panel.style.display = 'none';
            } else {
                panel.style.display = 'block';
                loadHeaderNotifications(); // load mới mỗi lần mở
            }
        });

        // Đóng khi click ngoài
        document.addEventListener('click', function (e) {
            if (!bell.contains(e.target) && !panel.contains(e.target)) {
                panel.style.display = 'none';
            }
        });
    });

    // Load badge ngay khi trang mở
    fetch('${pageContext.request.contextPath}/NotificationServlet/count')
        .then(r => r.json())
        .then(d => {
            const count = d.unread_count || 0;
            document.getElementById('notification-badge').textContent = count;
            document.getElementById('notification-badge').style.display = count > 0 ? 'flex' : 'none';
        })
        .catch(() => {
        });
</script>
<c:if test="${not empty sessionScope.user}">
    <script>
        document.body.dataset.userId = '${sessionScope.user.id}';
        document.body.dataset.loggedIn = 'true';
        document.body.dataset.contextPath = '${pageContext.request.contextPath}';
    </script>

    <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js"></script>

    <script src="${pageContext.request.contextPath}/fontend/js/firebase-notification.js"></script>
</c:if>

