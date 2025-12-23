<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>--%>

<header class="navbar">
    <a href="homePage.jsp"></a>
    <div class="logo">
        <img id="logo" src="../../img/logo.png" alt="Comic Store">
        <span>Comic Store</span>
    </div>
    <nav class="menu">
        <a href="homePage.jsp">Trang chủ</a>

        <div class="dropdown">
            <a href="#">Thể loại &#9662;</a>
            <div class="dropdown-content">
                <a href="CatagoryPage.jsp">Hành động</a>
                <a href="#">Phiêu lưu</a>
                <a href="#">Lãng mạn </a>
                <a href="#">Học đường</a>
                <a href="#">Kinh dị</a>
                <a href="#">Hài hước</a>
                <a href="#">Giả tưởng</a>
                <a href="#">Trinh thám</a>
            </div>
        </div>

        <a href="AbouUS.jsp">Liên hệ</a>
    </nav>
    <div class="search-bar">
        <div class="search-box">
            <form action="${pageContext.request.contextPath}/search" method="get">
                <input type="text"
                       id="searchInput"
                       name="keyword"
                       placeholder="Tìm truyện..."
                       class="search-input"
                       autocomplete="off">
                <button type="submit" class="search-button">
                    <i class="fas fa-magnifying-glass"></i>
                </button>
            </form>

            <div id="searchDropdown" class="search-history-dropdown">
                <div class="history-header">
                    <span>Lịch sử tìm kiếm</span>
                    <span class="clear-all" id="clearAll">Xóa tất cả</span>
                </div>

                <div class="history-list">
                    <span>Conan tập 88</span>
                    <span class="remove">×</span>
                </div>
            </div>
        </div>
    </div>

    <div class="contain-left">
        <div class="actions">
            <div class="notify-wrapper">
                <a href="#" class="bell-icon">
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
                            <a href="#">Xem tất cả</a>
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
            <a href="../nguoiB/chat.jsp">
                <i class="fa-solid fa-comment"></i>
            </a>
        </div>

        <div class="actions">
            <a href="../nguoiB/cart.jsp">
                <i class="fa-solid fa-cart-shopping"></i>
            </a>
        </div>

        <div class="actions user-nav">
            <i class="fa-solid fa-user" id="user"></i>
            <div class="dropdown-user">
                <a href="../nguoiB/profile.jsp">Trang chủ</a>
                <a href="login.jsp">Đăng xuất</a>
            </div>
        </div>
    </div>
</header>



<script>
    const searchInput = document.getElementById('searchInput');
    const dropdown = document.getElementById('searchDropdown');
    const list = dropdown.querySelector('.history-list');
    const clearAllBtn = document.getElementById('clearAll');

    const STORAGE_KEY = 'comicstore_search_history';
    let searchHistory = JSON.parse(localStorage.getItem(STORAGE_KEY)) || [];

    function saveHistory() {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(searchHistory));
    }

    function positionDropdown() {
        const rect = searchInput.getBoundingClientRect();
        dropdown.style.top = rect.bottom + 6 + 'px';
        dropdown.style.left = rect.left + 'px';
        dropdown.style.width = rect.width + 'px';
    }

    function renderHistory() {
        list.innerHTML = '';

        if (!searchHistory.length) {
            list.innerHTML = '<div class="history-item" style="color:#999;font-style:italic">Không có lịch sử</div>';
            return;
        }
        searchHistory.slice(0, 6).forEach(term => {
            const item = document.createElement('div');
            item.className = 'history-item';
            item.textContent = term;
            item.onclick = () => {
                searchInput.value = term;
                hideDropdown();
                searchInput.form.submit();
            };
            list.appendChild(item);
        });
    }

    function showDropdown() {
        positionDropdown();
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

    window.addEventListener('resize', hideDropdown);
    window.addEventListener('scroll', hideDropdown);

    searchInput.form.addEventListener('submit', () => {
        const term = searchInput.value.trim();
        if (!term) return;
        searchHistory = searchHistory.filter(t => t !== term);
        searchHistory.unshift(term);
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