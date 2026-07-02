<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String currentView = request.getParameter("currentView");
    if (currentView == null) currentView = "dashboard";
    String baseClass = "flex items-center space-x-3 px-4 py-3 rounded-xl transition-all duration-300 group font-medium text-sm sidebar-item-hover relative ";
    String activeClass = "bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/30 sidebar-glow active-indicator";
    String inactiveClass = "text-gray-400 hover:bg-[#1a1a1a] hover:text-white";
%>
<aside id="admin-sidebar" class="w-64 bg-[#121212] border-r border-gray-800/80 fixed left-0 top-16 bottom-0 z-40 p-4 overflow-y-auto sidebar-transition">
    <div class="mb-6 text-center border-b border-gray-800 pb-4 mt-2 sidebar-category">
        <h2 class="text-white font-black tracking-widest uppercase text-lg glow-text-red">NHÂN VIÊN</h2>
    </div>
    <div class="space-y-1.5">
        <p class="text-[10px] font-bold text-gray-500 px-4 uppercase tracking-widest mb-2 sidebar-category">Tổng quan</p>
        <a href="${pageContext.request.contextPath}/staff/dashboard" class="<%= baseClass%><%= "dashboard".equals(currentView) ? activeClass : inactiveClass%>">
            <i class="fas fa-chart-pie w-5 text-center transition-transform duration-300 group-hover:rotate-12 group-hover:text-blue-400"></i>
            <span class="sidebar-text">Tổng quan</span>
        </a>
        <a href="${pageContext.request.contextPath}/staff/profile" class="<%= baseClass%><%= "profile".equals(currentView) ? activeClass : inactiveClass%>">
            <i class="fas fa-user-circle w-5 text-center transition-transform duration-300 group-hover:scale-110 group-hover:text-blue-400"></i>
            <span class="sidebar-text">Thông tin cá nhân</span>
        </a>

        <p class="text-[10px] font-bold text-gray-500 px-4 uppercase tracking-widest pt-4 mb-2 sidebar-category">Vé &amp; Chiếu</p>
        <a href="${pageContext.request.contextPath}/staff/tickets" class="<%= baseClass%><%= "tickets".equals(currentView) ? activeClass : inactiveClass%>">
            <i class="fas fa-ticket-alt w-5 text-center transition-transform duration-300 group-hover:scale-110 group-hover:text-blue-400"></i>
            <span class="sidebar-text">Quản lý vé</span>
        </a>
        <a href="${pageContext.request.contextPath}/staff/check-ticket" class="<%= baseClass%><%= "check_ticket".equals(currentView) ? activeClass : inactiveClass%>">
            <i class="fas fa-qrcode w-5 text-center transition-transform duration-300 group-hover:scale-110 group-hover:text-blue-400"></i>
            <span class="sidebar-text">Soát vé</span>
        </a>
        <a href="${pageContext.request.contextPath}/staff/showtimes" class="<%= baseClass%><%= "showtimes".equals(currentView) ? activeClass : inactiveClass%>">
            <i class="fas fa-clock w-5 text-center transition-transform duration-300 group-hover:scale-110 group-hover:text-blue-400"></i>
            <span class="sidebar-text">Lịch chiếu</span>
        </a>
        <a href="${pageContext.request.contextPath}/staff/movies" class="<%= baseClass%><%= "movies".equals(currentView) ? activeClass : inactiveClass%>">
            <i class="fas fa-film w-5 text-center transition-transform duration-300 group-hover:scale-110 group-hover:text-blue-400"></i>
            <span class="sidebar-text">Danh sách phim</span>
        </a>

        <p class="text-[10px] font-bold text-gray-500 px-4 uppercase tracking-widest pt-6 mb-2 sidebar-category">Tài khoản</p>
        <a href="${pageContext.request.contextPath}/logout-staff"
           onclick="return confirmStaffLogout(event)"
           class="<%= baseClass%><%= "logout".equals(currentView) ? activeClass : inactiveClass%> text-red-400/80 hover:text-red-400 hover:bg-red-500/10">
            <i class="fas fa-sign-out-alt w-5 text-center transition-transform duration-300 group-hover:scale-110"></i>
            <span class="sidebar-text">Đăng xuất</span>
        </a>
    </div>
</aside>
