<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<header class="bg-[#121212]/90 border-b border-gray-800/80 px-4 md:px-6 py-3 flex justify-between items-center fixed w-full top-0 z-50 h-16 backdrop-blur">
    <div class="flex items-center space-x-4">
        <button id="sidebar-toggle" class="p-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-xl transition md:block">
            <i class="fas fa-bars text-lg"></i>
        </button>
        <div class="flex items-center space-x-2">
            <div class="bg-gradient-to-r from-blue-600 to-cyan-500 p-2 rounded-lg text-white shadow-md shadow-blue-600/20">
                <i class="fas fa-user-tie text-base"></i>
            </div>
            <span class="text-white font-black text-lg tracking-wider hidden sm:inline">STARLIGHT <span class="text-blue-400 text-sm">STAFF</span></span>
        </div>
    </div>
    <div id="realtime-clock" class="hidden lg:flex items-center bg-[#0d0d0d] px-4 py-1.5 rounded-xl border border-gray-800 text-sm font-medium tracking-wide text-gray-400">
        <i class="far fa-clock text-blue-500 mr-2"></i>--:--:--
    </div>
    <div class="flex items-center space-x-2 md:space-x-3">
        <a href="${pageContext.request.contextPath}/" target="_blank" title="Xem trang khách hàng"
           class="w-9 h-9 text-gray-400 hover:text-white hover:bg-gray-800 rounded-xl flex items-center justify-center transition">
            <i class="fas fa-globe text-base"></i>
        </a>
        <div id="profile-menu-btn" class="relative flex items-center space-x-3 border-l border-gray-800 pl-3 md:pl-4 py-1 cursor-pointer">
            <div class="text-right hidden sm:block">
                <p class="text-white text-xs font-semibold leading-tight">
                    Xin chào, <c:out value="${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.fullName : 'Nhân viên'}" />
                </p>
                <p class="text-blue-500 text-[10px] font-bold mt-0.5 uppercase tracking-wider">
                    (<c:out value="${not empty sessionScope.userRole ? sessionScope.userRole : 'STAFF'}" />)
                </p>
            </div>
            <div class="relative w-9 h-9 rounded-full p-[1.5px] bg-gradient-to-tr from-blue-600 to-cyan-500 shadow-md">
                <c:set var="avatarName" value="${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.fullName : 'Staff'}" />
                <c:set var="staffAvatar" value="${sessionScope.loggedInUser.avatar}" />
                <c:choose>
                    <c:when test="${not empty staffAvatar && staffAvatar != 'null' && fn:trim(staffAvatar) != ''}">
                        <c:choose>
                            <c:when test="${fn:startsWith(fn:trim(staffAvatar), 'http')}">
                                <c:set var="headerAvatarSrc" value="${fn:trim(staffAvatar)}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="headerAvatarSrc" value="${pageContext.request.contextPath}/assets/images/avatar/${fn:trim(staffAvatar)}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:set var="headerAvatarSrc" value="https://ui-avatars.com/api/?name=${fn:replace(avatarName, ' ', '+')}&background=121212&color=3b82f6&bold=true"/>
                    </c:otherwise>
                </c:choose>
                <img src="${headerAvatarSrc}"
                     alt="Avatar" class="w-full h-full object-cover rounded-full bg-[#121212]"
                     onerror="this.src='https://ui-avatars.com/api/?name=${fn:replace(avatarName, ' ', '+')}&background=121212&color=3b82f6&bold=true';">
            </div>
            <div id="profile-dropdown" class="absolute right-0 top-full mt-2 w-48 bg-[#121212] border border-gray-800 rounded-xl shadow-2xl p-1.5 opacity-0 invisible -translate-y-2 transition-all duration-300 z-50 transform origin-top-right">
                <a href="${pageContext.request.contextPath}/staff/profile" class="flex items-center space-x-2.5 px-3 py-2 rounded-lg text-xs text-gray-400 hover:text-white hover:bg-gray-800 transition">
                    <i class="fas fa-user-circle text-sm w-4 text-center"></i>
                    <span>Thông tin cá nhân</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout-staff"
                   onclick="return confirmStaffLogout(event)"
                   class="flex items-center space-x-2.5 px-3 py-2 rounded-lg text-xs text-red-400 hover:text-white hover:bg-red-600 transition font-medium">
                    <i class="fas fa-sign-out-alt text-sm w-4 text-center"></i>
                    <span>Đăng xuất</span>
                </a>
                <c:if test="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'MANAGER'}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center space-x-2.5 px-3 py-2 rounded-lg text-xs text-gray-400 hover:text-white hover:bg-gray-800 transition">
                    <i class="fas fa-chart-pie text-sm w-4 text-center"></i>
                    <span>Giao diện quản trị</span>
                </a>
                </c:if>
            </div>
        </div>
    </div>
</header>
