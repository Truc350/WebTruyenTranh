<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="vn.edu.hcmuaf.fit.ltw_nhom5.model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.edu.hcmuaf.fit.ltw_nhom5.dao.CategoriesDao" %>
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
                <a href="${pageContext.request.contextPath}/category?id=<%= c.getId() %>"><%= c.getNameCategories() %></a>
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
            <form action="${pageContext.request.contextPath}/search" method="get">
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
                <a href="login_bo.jsp">Đăng xuất</a>
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

    searchInput.form.addEventListener('submit', () => {
        const term = searchInput.value.trim();
        if (!term) return;

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