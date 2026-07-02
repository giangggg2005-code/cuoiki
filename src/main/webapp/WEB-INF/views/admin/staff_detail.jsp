<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Nhân Sự</title>
    <style>
        .glass-card { background: rgba(22, 22, 22, 0.85); backdrop-filter: blur(16px); }
        .input-premium {
            background-color: #0d0d0d; border: 1px solid #262626; color: #f3f4f6;
            border-radius: 0.75rem; padding: 0.625rem 1rem; width: 100%; transition: all 0.3s ease;
        }
        .input-premium:focus:not(:read-only) { border-color: #3b82f6; outline: none; box-shadow: 0 0 12px rgba(59, 130, 246, 0.3); }
        .input-premium:read-only, .input-readonly { background-color: #050505; color: #737373; cursor: not-allowed; border-color: #171717; }
        .btn-premium { background: linear-gradient(135deg, #2563eb, #4f46e5); color: white; transition: all 0.3s ease; }
        .btn-premium:hover { box-shadow: 0 0 20px rgba(59, 130, 246, 0.5); transform: translateY(-2px); }
        .premium-glow { box-shadow: 0 0 15px rgba(59, 130, 246, 0.2); transition: all 0.3s ease-in-out; }
        .field-live-error { display: block; margin-top: 0.35rem; color: #fca5a5; font-size: 0.72rem; font-weight: 600; }
        .field-live-error.hidden { display: none; }
        .field-has-error { border-color: rgba(248, 113, 113, 0.95) !important; box-shadow: 0 0 0 1px rgba(248, 113, 113, 0.55), 0 0 14px rgba(239, 68, 68, 0.16) !important; }

        @keyframes toastFlyIn { 0% { transform: translateX(130%) scale(0.9); opacity: 0; filter: blur(5px); } 60% { transform: translateX(-15px) scale(1.02); filter: blur(0); } 80% { transform: translateX(5px) scale(0.99); } 100% { transform: translateX(0) scale(1); opacity: 1; filter: blur(0); } }
        @keyframes toastFadeZoomOut { 0% { transform: translate(0) scale(1); opacity: 1; filter: blur(0); } 40% { transform: translateX(10px) scale(1.01); opacity: 0.8; } 100% { transform: translateX(60px) scale(0.85); opacity: 0; filter: blur(6px); } }
        @keyframes toastTimeline { 0% { width: 100%; } 100% { width: 0%; } }
        @keyframes glowPulseRed { 0%, 100% { border-color: rgba(239, 68, 68, 0.35); box-shadow: 0 10px 30px -5px rgba(239, 68, 68, 0.15), 0 0 15px rgba(239, 68, 68, 0.05); } 50% { border-color: rgba(239, 68, 68, 0.8); box-shadow: 0 15px 35px -2px rgba(239, 68, 68, 0.35), 0 0 25px rgba(239, 68, 68, 0.15); } }
        @keyframes glowPulseGreen { 0%, 100% { border-color: rgba(34, 197, 94, 0.35); box-shadow: 0 10px 30px -5px rgba(34, 197, 94, 0.15), 0 0 15px rgba(34, 197, 94, 0.05); } 50% { border-color: rgba(34, 197, 94, 0.8); box-shadow: 0 15px 35px -2px rgba(34, 197, 94, 0.35), 0 0 25px rgba(34, 197, 94, 0.15); } }
        @keyframes subtleBounce { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-3px); } }
        @keyframes fadeDown { from { opacity: 0; transform: translateY(-16px); } to { opacity: 1; transform: translateY(0); } }

        .toast-item { animation: toastFlyIn 0.55s cubic-bezier(0.25, 1, 0.5, 1) forwards; will-change: transform, opacity; z-index: 99999; }
        .toast-item.toast-leave-active { animation: toastFadeZoomOut 0.45s cubic-bezier(0.25, 1, 0.5, 1) forwards !important; }
        .toast-error-glow { animation: glowPulseRed 3s infinite ease-in-out; }
        .toast-success-glow { animation: glowPulseGreen 3s infinite ease-in-out; }
        .toast-progress-countdown { position: absolute !important; left: 0 !important; bottom: 0 !important; height: 3px !important; z-index: 3 !important; animation: toastTimeline 5s linear forwards; }
        .animate-subtle-bounce { animation: subtleBounce 2.5s ease-in-out infinite; }
        .animate-fade-down { animation: fadeDown 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .staff-detail-shell { max-width: 1500px; margin: 0 auto; padding-left: 0.75rem; padding-right: 0.75rem; }
        .staff-detail-grid { display: grid; grid-template-columns: minmax(280px, 360px) minmax(0, 1fr); gap: 1.25rem; align-items: start; transition: all 0.3s ease; }
        .staff-detail-grid.sidebar-collapsed { grid-template-columns: 0 minmax(0, 1fr); gap: 0; }
        .staff-sidebar { min-width: 0; overflow: hidden; transition: opacity 0.25s ease, transform 0.25s ease; }
        .staff-detail-grid.sidebar-collapsed .staff-sidebar { opacity: 0; transform: translateX(-12px); pointer-events: none; }
        .staff-main-panel { min-width: 0; transition: all 0.3s ease; }
        .staff-role-card { position: relative; overflow: hidden; }
        .staff-role-card::before { content: ""; position: absolute; inset: 0; background: linear-gradient(120deg, transparent, rgba(99, 102, 241, 0.08), transparent); transform: translateX(-100%); transition: transform 0.75s ease; }
        .staff-role-card:hover::before { transform: translateX(100%); }
        @keyframes avatarOrbit { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        @keyframes avatarBreath { 0%, 100% { transform: translateY(0) scale(1); } 50% { transform: translateY(-4px) scale(1.025); } }
        @keyframes cardShimmer { 0% { transform: translateX(-120%); } 100% { transform: translateX(120%); } }
        @keyframes warningPulse { 0%, 100% { box-shadow: 0 0 0 rgba(245,158,11,0); transform: scale(1); } 50% { box-shadow: 0 0 26px rgba(245,158,11,0.35); transform: scale(1.03); } }
        @keyframes unsavedBorderGlow { 0%, 100% { border-color: rgba(245,158,11,0.35); box-shadow: 0 0 0 rgba(245,158,11,0); } 50% { border-color: rgba(245,158,11,0.85); box-shadow: 0 0 24px rgba(245,158,11,0.16); } }
        .profile-hero-card::before {
            content: ""; position: absolute; inset: -40%; pointer-events: none;
            background: radial-gradient(circle at 20% 10%, rgba(59,130,246,0.2), transparent 28%), radial-gradient(circle at 80% 0%, rgba(168,85,247,0.16), transparent 28%);
            filter: blur(12px);
        }
        .profile-hero-card::after {
            content: ""; position: absolute; top: 0; bottom: 0; width: 40%; left: -45%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.06), transparent);
            animation: cardShimmer 5s ease-in-out infinite;
        }
        .staff-avatar-orb {
            width: 10.5rem; height: 10.5rem; border-radius: 9999px; padding: 4px; position: relative;
            animation: avatarBreath 4s ease-in-out infinite;
        }
        .staff-avatar-orb::before {
            content: ""; position: absolute; inset: -5px; border-radius: inherit; z-index: 0;
            background: conic-gradient(from 0deg, var(--role-a), var(--role-b), var(--role-c), var(--role-a));
            animation: avatarOrbit 4.5s linear infinite;
            filter: drop-shadow(0 0 18px var(--role-glow));
        }
        .staff-avatar-orb::after {
            content: ""; position: absolute; inset: 5px; border-radius: inherit; z-index: 1;
            background: #080808;
        }
        .staff-avatar-img { position: relative; z-index: 2; width: 100%; height: 100%; border-radius: inherit; object-fit: cover; border: 4px solid rgba(10,10,10,0.95); }
        .avatar-role-admin { --role-a: #facc15; --role-b: #ef4444; --role-c: #a855f7; --role-glow: rgba(250,204,21,0.55); }
        .avatar-role-manager { --role-a: #38bdf8; --role-b: #6366f1; --role-c: #22d3ee; --role-glow: rgba(56,189,248,0.45); }
        .avatar-role-seller { --role-a: #22c55e; --role-b: #14b8a6; --role-c: #84cc16; --role-glow: rgba(34,197,94,0.42); }
        .avatar-role-default { --role-a: #64748b; --role-b: #334155; --role-c: #94a3b8; --role-glow: rgba(148,163,184,0.25); }
        .form-input-wrap { position: relative; }
        .form-input-wrap .input-premium { padding-left: 2.85rem !important; }
        .form-input-wrap .input-right-action { padding-right: 2.85rem !important; }
        .form-input-icon { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #6b7280; pointer-events: none; z-index: 2; }
        .decor-card { position: relative; overflow: hidden; }
        .decor-card::before {
            content: ""; position: absolute; inset: 0; pointer-events: none;
            background: linear-gradient(135deg, rgba(59,130,246,0.08), transparent 32%, rgba(168,85,247,0.07));
        }
        .unsaved-warning-icon { animation: warningPulse 2s ease-in-out infinite; }
        .staff-form-unsaved {
            border-color: rgba(245,158,11,0.55) !important;
            animation: unsavedBorderGlow 2.6s ease-in-out infinite;
        }
        .unsaved-save-badge {
            display: none;
            animation: subtleBounce 2.2s ease-in-out infinite;
        }
        .staff-form-unsaved .unsaved-save-badge {
            display: inline-flex;
        }
        @media (max-width: 1024px) {
            .staff-detail-grid, .staff-detail-grid.sidebar-collapsed { grid-template-columns: 1fr; gap: 1rem; }
            .staff-detail-grid.sidebar-collapsed .staff-sidebar { display: none; }
        }
    </style>
</head>
<body class="bg-[#0b0c10] text-gray-300 font-sans min-h-screen">
    
    <div class="staff-detail-shell pb-10">
        <div class="flex items-center justify-between mb-6 pb-4 border-b border-gray-800">
            <div>
                <h2 class="text-2xl font-bold text-white flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl flex items-center justify-center text-blue-500 premium-glow" style="background: rgba(59, 130, 246, 0.2);">
                        <i class="fas fa-id-badge"></i>
                    </div>
                    Hồ Sơ Nhân Sự: <span class="text-blue-400">@${staff.username}</span>
                </h2>
                <p class="text-sm text-gray-500 mt-1">Cập nhật thông tin, thay đổi chức vụ hoặc phân quyền</p>
            </div>
            <div class="flex items-center gap-2">
                <button type="button" onclick="toggleStaffSidebar()" class="px-4 py-2 rounded-xl bg-blue-500/10 hover:bg-blue-500/20 border border-blue-500/20 text-blue-300 text-sm font-bold transition duration-200 flex items-center gap-2">
                    <i id="sidebarToggleIcon" class="fas fa-compress-alt"></i> <span id="sidebarToggleText">Thu thẻ hồ sơ</span>
                </button>
                <a href="${pageContext.request.contextPath}${readOnlyMode ? '/admin/monitoring' : '/admin/staffs'}" onclick="return ${readOnlyMode ? 'true' : 'guardUnsavedNavigation(event, this.href)'}" class="px-4 py-2 rounded-xl bg-gray-800 hover:bg-gray-700 text-white text-sm font-medium transition duration-200 flex items-center gap-2">
                    <i class="fas fa-arrow-left"></i> Trở về ${readOnlyMode ? 'giám sát' : 'danh sách'}
                </a>
            </div>
        </div>

        <c:if test="${readOnlyMode}">
            <div class="mb-4 p-4 rounded-xl border border-amber-500/30 bg-amber-950/20 text-amber-300 text-sm font-bold flex items-center gap-2">
                <i class="fas fa-eye"></i> Chế độ xem chỉ đọc — bạn không thể chỉnh sửa thông tin nhân sự.
            </div>
        </c:if>

        <input type="hidden" id="backend-error-bridge" value="${fn:escapeXml(errorMessage)}">
        <input type="hidden" id="backend-success-bridge" value="${fn:escapeXml(successMessage)}">
        <div id="premium-toast-container" class="fixed bottom-6 right-6 flex flex-col gap-3 z-[99999] max-w-sm w-full pointer-events-none"></div>

        <c:set var="staffAvatarPreview" value=""/>
        <c:choose>
            <c:when test="${not empty staff.avatar && staff.avatar != 'null' && fn:trim(staff.avatar) != ''}">
                <c:choose>
                    <c:when test="${fn:startsWith(fn:trim(staff.avatar), 'http')}">
                        <c:set var="staffAvatarPreview" value="${fn:trim(staff.avatar)}"/>
                    </c:when>
                    <c:when test="${fn:startsWith(fn:trim(staff.avatar), '/assets/')}">
                        <c:set var="staffAvatarPreview" value="${pageContext.request.contextPath}${fn:trim(staff.avatar)}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="staffAvatarPreview" value="${pageContext.request.contextPath}/assets/images/avatar/${fn:trim(staff.avatar)}"/>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <c:set var="staffAvatarPreview" value="https://ui-avatars.com/api/?name=${not empty staff.fullName ? staff.fullName : 'Staff'}&background=random"/>
            </c:otherwise>
        </c:choose>

        <c:set var="avatarRoleClass" value="avatar-role-default"/>
        <c:set var="avatarRoleLabel" value="STAFF"/>
        <c:choose>
            <c:when test="${not empty staffRole.quyen.roleName && fn:contains(staffRole.quyen.roleName, 'ADMIN')}">
                <c:set var="avatarRoleClass" value="avatar-role-admin"/>
                <c:set var="avatarRoleLabel" value="ADMIN"/>
            </c:when>
            <c:when test="${not empty staffRole.quyen.roleName && fn:contains(staffRole.quyen.roleName, 'MANAGER')}">
                <c:set var="avatarRoleClass" value="avatar-role-manager"/>
                <c:set var="avatarRoleLabel" value="MANAGER"/>
            </c:when>
            <c:when test="${not empty staffRole.quyen.roleName && fn:contains(staffRole.quyen.roleName, 'TICKETSELLER')}">
                <c:set var="avatarRoleClass" value="avatar-role-seller"/>
                <c:set var="avatarRoleLabel" value="TICKETSELLER"/>
            </c:when>
        </c:choose>

        <div id="staffDetailGrid" class="staff-detail-grid">
            <div id="staffSidebar" class="staff-sidebar flex flex-col gap-5">
                <div class="glass-card profile-hero-card p-6 rounded-2xl border border-gray-800 flex flex-col items-center text-center relative overflow-hidden">
                    <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-blue-600 to-indigo-600"></div>
                    
                    <div id="avatar-preview-container" class="staff-avatar-orb ${avatarRoleClass} mx-auto mb-5 flex items-center justify-center shadow-xl">
                        <img id="avatar-preview-img" src="${staffAvatarPreview}" class="staff-avatar-img bg-gray-900" alt="Avatar" onerror="this.src='${pageContext.request.contextPath}/assets/images/avatar/default-avatar.png';">
                        <i id="avatar-error-icon" class="fas fa-image text-gray-500 hidden"></i>
                    </div>

                    <h3 class="text-xl font-bold text-white mb-1">${staff.fullName}</h3>
                    <p class="text-sm text-blue-400 font-mono mb-2">@${staff.username}</p>
                    <span class="mb-4 inline-flex items-center gap-2 px-3 py-1 rounded-full border border-white/10 bg-white/5 text-[11px] font-black tracking-[0.18em] text-gray-200">
                        <i class="fas fa-crown text-yellow-400"></i> ${avatarRoleLabel}
                    </span>

                    <div class="w-full flex justify-center mb-5">
                        <c:choose>
                            <c:when test="${staff.status == 'Active'}">
                                <div class="inline-flex items-center gap-2 bg-green-500/10 text-green-400 px-4 py-1.5 rounded-full text-sm font-medium border border-green-500/20 shadow-[0_0_10px_rgba(34,197,94,0.1)]">
                                    <div class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></div> Trạng thái: Hoạt động
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="inline-flex items-center gap-2 bg-red-500/10 text-red-400 px-4 py-1.5 rounded-full text-sm font-medium border border-red-500/20">
                                    <i class="fas fa-lock text-xs"></i> Trạng thái: Đã khóa
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="w-full bg-[#0d0d0d] rounded-xl p-4 border border-gray-800 text-left text-xs text-gray-400 flex flex-col gap-2">
                        <div class="flex justify-between items-center pb-2 border-b border-gray-800">
                            <span>Mã nhân sự:</span>
                            <span class="font-mono text-white">#${staff.id_User}</span>
                        </div>
                        <div class="flex justify-between items-center pb-2 border-b border-gray-800">
                            <span>Ngày tạo tài khoản:</span>
                            <span class="text-white"><fmt:formatDate value="${staff.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span>Cập nhật thông tin:</span>
                            <span class="text-white"><fmt:formatDate value="${staff.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                    </div>
                </div>

                <div class="glass-card decor-card p-5 rounded-2xl border border-yellow-500/20">
                    <h4 class="text-sm font-bold text-yellow-400 uppercase tracking-wider mb-4 flex items-center gap-2 relative z-10">
                        <i class="fas fa-key"></i> Thông Tin Tài Khoản
                    </h4>
                    <div class="space-y-4 relative z-10">
                        <div>
                            <label class="text-[11px] text-gray-500 font-bold uppercase tracking-wider mb-2 block">Tên đăng nhập</label>
                            <div class="form-input-wrap">
                                <input type="text" value="${staff.username}" readonly class="input-premium input-readonly text-sm font-mono tracking-wide">
                                <i class="fas fa-user-circle form-input-icon"></i>
                            </div>
                        </div>
                        <div class="rounded-xl border border-yellow-500/20 bg-yellow-500/5 p-3">
                            <div class="flex items-start gap-3">
                                <div class="w-9 h-9 rounded-lg bg-yellow-500/10 border border-yellow-500/20 text-yellow-400 flex items-center justify-center flex-shrink-0">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                                <div class="text-left">
                                    <p class="text-xs font-black uppercase tracking-wider text-yellow-300 mb-1">Mật khẩu được bảo vệ</p>
                                    <p class="text-[11px] text-gray-400 leading-relaxed">Admin không xem mật khẩu thật. Nếu nhân sự quên mật khẩu, hãy dùng chức năng reset về mặc định bên dưới.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="glass-card p-6 rounded-2xl border border-red-900/30">
                    <h4 class="text-sm font-bold text-red-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                        <i class="fas fa-exclamation-circle"></i> Thao Tác Quản Trị
                    </h4>
                    
                    <div class="flex flex-col gap-3">
                        <button onclick="openResetModal()" class="w-full bg-[#0d0d0d] hover:bg-orange-500/10 text-gray-300 hover:text-orange-400 border border-gray-800 hover:border-orange-500/30 px-4 py-3 rounded-xl text-sm transition duration-300 flex items-center gap-3">
                            <i class="fas fa-key w-5 text-center"></i> Khôi phục mật khẩu mặc định
                        </button>

                        <c:choose>
                            <c:when test="${staff.status == 'Active'}">
                                <button onclick="openLockModal('Locked')" class="w-full bg-[#0d0d0d] hover:bg-red-500/10 text-gray-300 hover:text-red-400 border border-gray-800 hover:border-red-500/30 px-4 py-3 rounded-xl text-sm transition duration-300 flex items-center gap-3">
                                    <i class="fas fa-user-lock w-5 text-center"></i> Khóa tài khoản này
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button onclick="openLockModal('Active')" class="w-full bg-[#0d0d0d] hover:bg-green-500/10 text-gray-300 hover:text-green-400 border border-gray-800 hover:border-green-500/30 px-4 py-3 rounded-xl text-sm transition duration-300 flex items-center gap-3">
                                    <i class="fas fa-user-check w-5 text-center"></i> Mở khóa tài khoản
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div id="staffRoleManagementPanel" class="glass-card p-5 rounded-2xl border border-purple-500/20 hidden">
                    <h4 class="text-sm font-bold text-purple-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                        <i class="fas fa-user-shield"></i> Quản Lý Phân Quyền
                    </h4>

                    <form action="${pageContext.request.contextPath}/admin/staffs/add-role" method="POST" class="mb-4 bg-[#0a0a0a] border border-gray-800 rounded-xl p-3">
                        <input type="hidden" name="id_User" value="${staff.id_User}">
                        <label class="text-[11px] text-gray-500 font-bold uppercase tracking-wider mb-2 block">Cấp thêm quyền mới</label>
                        <div class="flex gap-2">
                            <select name="roleId" class="input-premium text-xs py-2 cursor-pointer">
                                <option value="0">-- Chọn quyền --</option>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role.id_Role}" title="${role.description}">${role.roleName}</option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="px-3 py-2 rounded-xl bg-purple-600/20 hover:bg-purple-600 border border-purple-500/30 text-purple-300 hover:text-white text-xs font-black transition whitespace-nowrap">
                                <i class="fas fa-plus"></i> Thêm
                            </button>
                        </div>
                        <p class="text-[11px] text-gray-500 mt-2 leading-relaxed">
                            Không xóa quyền cũ. Nếu tài khoản đang Locked, quyền mới sẽ được lưu ở trạng thái Locked để giữ đúng ràng buộc.
                        </p>
                    </form>

                    <c:if test="${empty roleHistory}">
                        <div class="bg-[#121212] border border-gray-800/50 border-dashed rounded-xl p-5 text-center">
                            <i class="fas fa-user-lock text-gray-600 text-2xl mb-2"></i>
                            <p class="text-sm text-gray-500 font-medium">Nhân sự này chưa có lịch sử quyền nội bộ.</p>
                        </div>
                    </c:if>

                    <div class="space-y-3">
                        <c:forEach var="rh" items="${roleHistory}">
                            <div class="staff-role-card bg-[#101010] border border-gray-800 rounded-xl p-4 hover:border-purple-500/40 transition-colors">
                                <div class="flex items-start justify-between gap-3 mb-3">
                                    <div>
                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg bg-purple-500/10 border border-purple-500/25 text-purple-300 text-xs font-black uppercase tracking-wider">
                                            <i class="fas fa-id-badge text-[10px]"></i> ${rh.quyen.roleName}
                                        </span>
                                        <div class="text-[10px] text-gray-500 font-mono mt-1.5">UserRole #${rh.id_UserRole} · Role #${rh.quyen.id_Role}</div>
                                    </div>
                                    <span class="text-[10px] font-black uppercase tracking-wider border px-2.5 py-1 rounded-lg ${rh.status == 'Active' ? 'text-green-400 bg-green-500/10 border-green-500/20' : 'text-red-400 bg-red-500/10 border-red-500/20'}">
                                        ${rh.status}
                                    </span>
                                </div>
                                <p class="text-xs text-gray-400 leading-relaxed bg-[#080808] rounded-lg p-2 border border-gray-800/60 mb-2">
                                    ${rh.quyen.description}
                                </p>
                                <div class="grid grid-cols-1 gap-2 text-xs">
                                    <div class="flex justify-between gap-3 bg-[#080808] rounded-lg p-2 border border-gray-800/60">
                                        <span class="text-gray-500 font-bold"><i class="fas fa-calendar-plus text-blue-400 mr-1"></i>Ngày cấp quyền:</span>
                                        <span class="text-gray-200 font-mono"><fmt:formatDate value="${rh.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    </div>
                                    <div class="flex justify-between gap-3 bg-[#080808] rounded-lg p-2 border border-gray-800/60">
                                        <span class="text-gray-500 font-bold"><i class="fas fa-history text-yellow-400 mr-1"></i>Cập nhật trạng thái quyền:</span>
                                        <span class="text-yellow-300/90 font-mono"><fmt:formatDate value="${rh.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    </div>
                                </div>
                                <form action="${pageContext.request.contextPath}/admin/staffs/update-role-status" method="POST" class="grid grid-cols-2 gap-2 mt-3 relative z-10">
                                    <input type="hidden" name="id_User" value="${staff.id_User}">
                                    <input type="hidden" name="id_UserRole" value="${rh.id_UserRole}">
                                    <button type="submit" name="status" value="Active" ${staff.status == 'Locked' ? 'disabled' : ''} title="${staff.status == 'Locked' ? 'Không thể bật quyền Active khi tài khoản đang Locked' : 'Bật quyền Active'}" class="py-2 rounded-lg border text-xs font-black transition ${staff.status == 'Locked' ? 'bg-gray-800/50 border-gray-700 text-gray-600 cursor-not-allowed opacity-60' : (rh.status == 'Active' ? 'bg-green-500/20 border-green-500/40 text-green-300' : 'bg-[#080808] border-gray-800 text-gray-400 hover:border-green-500/40 hover:text-green-300')}">
                                        <i class="fas fa-toggle-on mr-1"></i> Active
                                    </button>
                                    <button type="submit" name="status" value="Locked" class="py-2 rounded-lg border text-xs font-black transition ${rh.status == 'Locked' ? 'bg-red-500/20 border-red-500/40 text-red-300' : 'bg-[#080808] border-gray-800 text-gray-400 hover:border-red-500/40 hover:text-red-300'}">
                                        <i class="fas fa-toggle-off mr-1"></i> Locked
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </div>
                </div>

            </div>

            <div class="staff-main-panel">
                <form id="staffUpdateForm" action="${pageContext.request.contextPath}/admin/staffs/update" method="POST" enctype="multipart/form-data" class="glass-card decor-card p-5 md:p-6 rounded-2xl border border-gray-800 relative overflow-hidden" onsubmit="return validateForm()">
                    
                    <input type="hidden" name="id_User" value="${staff.id_User}">
                    <input type="hidden" name="status" value="${staff.status}">

                    <h3 class="text-lg font-bold text-white border-b border-gray-800 pb-2 mb-5"><i class="fas fa-pen-alt text-blue-500 mr-2"></i> Chỉnh Sửa Hồ Sơ</h3>

                    <div class="mb-5">
                        <label class="block text-sm font-medium text-gray-400 mb-1">Tên đăng nhập (Username)</label>
                        <div class="form-input-wrap">
                            <input type="text" value="${staff.username}" readonly class="input-premium pl-10 text-sm font-mono tracking-wide" title="Không thể thay đổi tên đăng nhập">
                            <input type="hidden" name="username" value="${staff.username}">
                            <i class="fas fa-lock form-input-icon"></i>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                        <div>
                            <label class="block text-sm font-medium text-gray-400 mb-1">Họ và Tên <span class="text-red-500">*</span></label>
                            <div class="form-input-wrap">
                                <input type="text" name="fullName" id="fullName" value="${staff.fullName}" class="input-premium pl-10 text-sm">
                                <i class="fas fa-signature form-input-icon"></i>
                            </div>
                            <p id="fullName-error" class="text-xs text-red-500 mt-1 hidden"></p>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-400 mb-1">Số điện thoại <span class="text-red-500">*</span></label>
                            <div class="form-input-wrap">
                                <input type="text" name="phone" id="phone" value="${staff.phone}" class="input-premium pl-10 text-sm font-mono">
                                <i class="fas fa-phone-alt form-input-icon"></i>
                            </div>
                            <p id="phone-error" class="text-xs text-red-500 mt-1 hidden"></p>
                        </div>
                    </div>

                    <div class="mb-5">
                        <label class="block text-sm font-medium text-gray-400 mb-1">Email <span class="text-red-500">*</span></label>
                        <div class="form-input-wrap">
                            <input type="text" name="email" id="email" value="${staff.email}" class="input-premium pl-10 text-sm">
                            <i class="fas fa-envelope form-input-icon"></i>
                        </div>
                        <p id="email-error" class="text-xs text-red-500 mt-1 hidden"></p>
                    </div>

                    <div class="mb-5 bg-[#121212] p-4 rounded-xl border border-gray-800">
                        <label class="block text-sm font-medium text-gray-300 mb-2">
                            <i class="fas fa-user-shield text-purple-500 mr-1"></i> Ghi chú phân quyền
                        </label>
                        <p class="text-xs text-gray-400 leading-relaxed">
                            Form này chỉ cập nhật hồ sơ cá nhân. Việc cấp thêm quyền hoặc đổi trạng thái từng quyền nằm ở khối
                            <span class="text-purple-300 font-bold">Quản Lý Phân Quyền</span> bên trái để không xóa lịch sử `UserRole`.
                        </p>
                    </div>

                    <div class="mb-6 bg-[#121212] p-4 rounded-xl border border-gray-800">
                        <label class="block text-sm font-medium text-gray-300 mb-2">Ảnh đại diện</label>
                        <div class="grid grid-cols-1 sm:grid-cols-4 gap-3">
                            <div class="sm:col-span-3 form-input-wrap">
                                <input type="text" name="avatar" id="avatar" value="${staff.avatar}" placeholder="https://... hoặc tên file avatar" class="input-premium pl-10 text-sm" oninput="previewAvatar()">
                                <i class="fas fa-image form-input-icon"></i>
                            </div>
                            <div class="sm:col-span-1">
                                <input type="file" id="avatarFile" name="imageFile" accept="image/*" class="hidden" onchange="handleFileSelect(this)">
                                <button type="button" onclick="document.getElementById('avatarFile').click()" class="w-full py-2.5 px-4 bg-zinc-900 hover:bg-zinc-800 text-gray-300 rounded-xl border border-gray-800 hover:border-gray-700 transition flex items-center justify-center gap-2 text-sm font-medium h-full min-h-[44px]">
                                    <i class="fas fa-upload text-blue-500"></i> Chọn ảnh
                                </button>
                            </div>
                        </div>
                        <div class="mt-3 flex items-center gap-3 transition-all duration-300">
                            <div class="w-12 h-12 rounded-full border border-gray-600 shadow-lg overflow-hidden flex-shrink-0 bg-gray-800 flex items-center justify-center">
                                <img id="avatar-form-preview-img" src="${staffAvatarPreview}" alt="Preview" class="w-full h-full object-cover" onerror="this.src='${pageContext.request.contextPath}/assets/images/avatar/default-avatar.png';">
                            </div>
                            <span class="text-xs text-gray-400 italic" id="avatar-preview-text">Đang hiển thị ảnh xem trước hiện tại...</span>
                        </div>
                    </div>

                    <div class="pt-5 border-t border-gray-800 flex justify-end gap-3">
                        <button type="submit" class="px-8 py-2.5 rounded-xl btn-premium font-bold flex items-center gap-2">
                            <i class="fas fa-save"></i> Cập Nhật Hồ Sơ
                            <span id="unsavedSaveBadge" class="unsaved-save-badge items-center gap-1 rounded-full bg-yellow-400/15 border border-yellow-400/30 text-yellow-200 px-2 py-0.5 text-[10px] uppercase tracking-wider">
                                <i class="fas fa-circle-exclamation text-[9px]"></i> Chưa lưu
                            </span>
                        </button>
                    </div>
                </form>
                <div id="rolePanelMount" class="mt-5"></div>
            </div>
        </div>
    </div>

    <div id="lockModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 opacity-0 pointer-events-none transition-opacity duration-200">
        <div class="bg-[#1a1c23] border border-gray-800 rounded-xl w-full max-w-sm p-6 shadow-2xl transform scale-95 transition-transform duration-200 text-center">
            <div id="lockModalIcon" class="w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center text-2xl"></div>
            <h4 class="text-white font-bold text-lg mb-2" id="lockModalTitle">Xác nhận</h4>
            <p class="text-sm text-gray-400 mb-6" id="lockModalDesc"></p>
            
            <form action="${pageContext.request.contextPath}/admin/staffs/update-status" method="POST" class="flex justify-center gap-3">
                <input type="hidden" name="id_User" value="${staff.id_User}">
                <input type="hidden" name="status" id="lockModalStatusInput">
                <button type="button" onclick="closeLockModal()" class="px-5 py-2 rounded-xl bg-[#0b0c10] border border-gray-700 text-gray-300 hover:text-white transition">Hủy</button>
                <button type="submit" id="lockModalBtn" class="px-5 py-2 rounded-xl font-bold text-white transition shadow-lg"></button>
            </form>
        </div>
    </div>

    <div id="resetModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 opacity-0 pointer-events-none transition-opacity duration-200">
        <div class="bg-[#1a1c23] border border-orange-900/50 rounded-xl w-full max-w-sm p-6 shadow-2xl transform scale-95 transition-transform duration-200 text-center">
            <div class="w-16 h-16 rounded-full bg-orange-500/20 text-orange-500 mx-auto mb-4 flex items-center justify-center text-2xl">
                <i class="fas fa-key"></i>
            </div>
            <h4 class="text-white font-bold text-lg mb-2">Khôi phục mật khẩu?</h4>
            <p class="text-sm text-gray-400 mb-6">Mật khẩu của tài khoản <b>@${staff.username}</b> sẽ được đặt lại thành mặc định: <br><span class="text-white font-mono bg-gray-800 px-2 py-1 rounded mt-2 inline-block tracking-wider">Pass@123</span></p>
            
            <form action="${pageContext.request.contextPath}/admin/staffs/reset-password" method="POST" class="flex justify-center gap-3">
                <input type="hidden" name="id_User" value="${staff.id_User}">
                <button type="button" onclick="closeResetModal()" class="px-5 py-2 rounded-xl bg-[#0b0c10] border border-gray-700 text-gray-300 hover:text-white transition">Hủy</button>
                <button type="submit" class="px-5 py-2 rounded-xl font-bold text-white bg-orange-600 hover:bg-orange-500 transition shadow-[0_0_15px_rgba(249,115,22,0.4)]">Xác nhận</button>
            </form>
        </div>
    </div>

    <div id="unsavedChangesModal" class="fixed inset-0 z-[60] flex items-center justify-center bg-black/70 opacity-0 pointer-events-none transition-opacity duration-300 backdrop-blur-sm">
        <div class="bg-[#121212] border border-yellow-500/30 rounded-2xl w-full max-w-md p-6 shadow-2xl transform scale-95 transition-transform duration-300 text-center relative overflow-hidden">
            <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-yellow-500 via-orange-500 to-red-500"></div>
            <div class="unsaved-warning-icon w-20 h-20 rounded-full bg-yellow-500/10 text-yellow-400 border border-yellow-500/30 mx-auto mb-4 flex items-center justify-center text-4xl">
                <i class="fas fa-triangle-exclamation"></i>
            </div>
            <h4 class="text-white font-black text-xl mb-2 uppercase tracking-wider">Có thay đổi chưa lưu</h4>
            <p class="text-sm text-gray-400 mb-6 leading-relaxed">
                Bạn đã chỉnh sửa hồ sơ nhân viên nhưng chưa bấm <strong class="text-blue-300">Cập Nhật Hồ Sơ</strong>.
                Bạn có chắc chắn muốn rời khỏi trang này không?
            </p>
            <div class="flex gap-3">
                <button type="button" onclick="closeUnsavedChangesModal()" class="flex-1 px-5 py-2.5 rounded-xl bg-gray-800 hover:bg-gray-700 border border-gray-700 text-gray-300 hover:text-white transition font-bold">
                    <i class="fas fa-rotate-left mr-1"></i> Ở lại
                </button>
                <button type="button" onclick="confirmUnsavedNavigation()" class="flex-1 px-5 py-2.5 rounded-xl bg-gradient-to-r from-yellow-600 to-orange-600 hover:from-yellow-500 hover:to-orange-500 text-white transition font-bold shadow-[0_0_16px_rgba(245,158,11,0.35)]">
                    <i class="fas fa-door-open mr-1"></i> Rời đi
                </button>
            </div>
        </div>
    </div>

    <script>
        let hasUnsavedStaffChanges = false;
        let pendingNavigationUrl = '';
        let pendingNavigationAction = '';

        function escapeToastText(text) {
            const div = document.createElement('div');
            div.innerText = text || '';
            return div.innerHTML;
        }

        function triggerPremiumToast(type, title, message) {
            const container = document.getElementById('premium-toast-container');
            if (!container || !message) return;

            const isSuccess = type === 'success';
            const toast = document.createElement('div');
            toast.className = 'toast-item pointer-events-auto relative overflow-hidden backdrop-blur-xl rounded-2xl border p-4 flex items-start gap-3.5 transition-all duration-300 transform shadow-2xl ' +
                (isSuccess ? 'bg-zinc-950/90 text-white toast-success-glow border-green-500/30' : 'bg-zinc-950/90 text-white toast-error-glow border-red-500/30');

            const iconHtml = isSuccess ? '<i class="fas fa-check-circle text-base animate-pulse"></i>' : '<i class="fas fa-exclamation-triangle text-base animate-subtle-bounce"></i>';
            const titleColorClass = isSuccess ? 'text-green-400' : 'text-red-400';
            const iconBgClass = isSuccess ? 'bg-green-500/10 border-green-500/20 text-green-400' : 'bg-red-500/10 border-red-500/20 text-red-400';
            const barGradientClass = isSuccess ? 'from-green-500 via-emerald-400 to-teal-500' : 'from-red-500 via-rose-500 to-amber-500';
            const subIconHtml = isSuccess ? '<i class="fas fa-star text-[10px]"></i>' : '<i class="fas fa-shield-alt text-[10px]"></i>';

            toast.innerHTML =
                '<div class="flex-shrink-0 w-9 h-9 rounded-xl border flex items-center justify-center ' + iconBgClass + '">' + iconHtml + '</div>' +
                '<div class="flex-1 min-w-0 pt-0.5">' +
                    '<h4 class="text-xs font-black uppercase tracking-wider ' + titleColorClass + ' mb-0.5 flex items-center gap-1.5">' + subIconHtml + ' ' + escapeToastText(title) + '</h4>' +
                    '<p class="text-xs text-zinc-300 font-medium leading-relaxed">' + escapeToastText(message) + '</p>' +
                '</div>' +
                '<div class="flex-shrink-0 pl-1">' +
                    "<button onclick=\"dismissTargetToast(this.closest('.toast-item'))\" class=\"w-6 h-6 rounded-lg bg-white/5 hover:bg-white/10 text-zinc-400 hover:text-white flex items-center justify-center transition-all duration-200 group\" type=\"button\">" +
                        '<i class="fas fa-times text-[10px] transform group-hover:rotate-90 transition-transform duration-300"></i>' +
                    '</button>' +
                '</div>' +
                '<div class="toast-progress-countdown bg-gradient-to-r ' + barGradientClass + '"></div>';

            container.appendChild(toast);
            const autoDismissTimer = setTimeout(function () {
                dismissTargetToast(toast);
            }, 5000);
            toast.dataset.timerId = autoDismissTimer;
        }

        function dismissTargetToast(toast) {
            if (!toast || toast.classList.contains('toast-leave-active')) return;
            if (toast.dataset.timerId) clearTimeout(parseInt(toast.dataset.timerId, 10));
            toast.classList.add('toast-leave-active');
            setTimeout(function () {
                toast.remove();
            }, 450);
        }

        function setFieldState(input, errorEl, message) {
            if (!input) return;
            if (message) {
                input.classList.add('field-has-error');
                if (errorEl) {
                    errorEl.innerText = message;
                    errorEl.classList.remove('hidden');
                }
            } else {
                input.classList.remove('field-has-error');
                if (errorEl) {
                    errorEl.innerText = '';
                    errorEl.classList.add('hidden');
                }
            }
        }

        function getStaffFieldRules() {
            const nameRegex = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;
            const phoneRegex = /^(0[3|5|7|8|9])+([0-9]{8})$/;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            return {
                fullName: {
                    input: document.getElementById('fullName'),
                    errorEl: document.getElementById('fullName-error'),
                    validate: function (value) {
                        if (!value) return 'Vui lòng không để trống họ và tên nhân sự.';
                        if (value.length < 2) return 'Họ và tên quá ngắn, vui lòng nhập ít nhất 2 ký tự.';
                        if (!nameRegex.test(value)) return 'Họ và tên không được chứa số hoặc ký tự đặc biệt.';
                        return '';
                    }
                },
                phone: {
                    input: document.getElementById('phone'),
                    errorEl: document.getElementById('phone-error'),
                    validate: function (value) {
                        if (!value) return 'Vui lòng không để trống số điện thoại.';
                        if (!phoneRegex.test(value)) return 'Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 số, ví dụ 098xxxxxxx.';
                        return '';
                    }
                },
                email: {
                    input: document.getElementById('email'),
                    errorEl: document.getElementById('email-error'),
                    validate: function (value) {
                        if (!value) return 'Vui lòng không để trống email.';
                        if (!emailRegex.test(value)) return 'Email không đúng định dạng, ví dụ contact@gmail.com.';
                        return '';
                    }
                }
            };
        }

        function validateSingleField(field) {
            if (!field || !field.input) return '';
            const message = field.validate(field.input.value.trim());
            setFieldState(field.input, field.errorEl, message);
            return message;
        }

        function validateForm() {
            const fields = getStaffFieldRules();
            let firstError = '';
            Object.keys(fields).forEach(function (key) {
                const message = validateSingleField(fields[key]);
                if (message && !firstError) firstError = message;
            });

            if (firstError) {
                triggerPremiumToast('error', 'Lỗi Nhập Liệu', firstError);
                return false;
            }
            return true;
        }

        function syncAvatarImages(src) {
            const sideImg = document.getElementById('avatar-preview-img');
            const formImg = document.getElementById('avatar-form-preview-img');
            if (sideImg) sideImg.src = src;
            if (formImg) formImg.src = src;
        }

        function previewAvatar() {
            const avatarInput = document.getElementById('avatar');
            if (!avatarInput) return;
            const avatarUrl = avatarInput.value.trim();
            const fullName = document.getElementById('fullName') ? document.getElementById('fullName').value.trim() : 'Staff';
            const errorIcon = document.getElementById('avatar-error-icon');
            if (errorIcon) errorIcon.classList.add('hidden');

            if (avatarUrl !== '') {
                if (avatarUrl.startsWith('http')) {
                    syncAvatarImages(avatarUrl);
                } else if (!avatarUrl.startsWith('/assets/')) {
                    syncAvatarImages('${pageContext.request.contextPath}/assets/images/avatar/' + avatarUrl);
                }
            } else {
                syncAvatarImages('https://ui-avatars.com/api/?name=' + encodeURIComponent(fullName || 'Staff') + '&background=random');
            }
        }

        function handleFileSelect(input) {
            if (input.files && input.files[0]) {
                const avatarInput = document.getElementById('avatar');
                const previewText = document.getElementById('avatar-preview-text');
                avatarInput.value = '/assets/images/avatar/' + input.files[0].name;
                syncAvatarImages(URL.createObjectURL(input.files[0]));
                markStaffFormDirty();
                if (previewText) previewText.innerText = 'Đang xem trước ảnh vừa chọn. Hệ thống sẽ lưu đường dẫn /assets/images/avatar/' + input.files[0].name + '.';
            }
        }

        window.addEventListener('DOMContentLoaded', function () {
            const errorBridge = document.getElementById('backend-error-bridge');
            const successBridge = document.getElementById('backend-success-bridge');
            if (errorBridge && errorBridge.value.trim() !== '') {
                triggerPremiumToast('error', 'Lỗi Cập Nhật', errorBridge.value.trim());
            }
            if (successBridge && successBridge.value.trim() !== '') {
                triggerPremiumToast('success', 'Thành Công', successBridge.value.trim());
            }

            const fields = getStaffFieldRules();
            Object.keys(fields).forEach(function (key) {
                const field = fields[key];
                if (field.input) {
                    field.input.addEventListener('input', function () { validateSingleField(field); });
                    field.input.addEventListener('blur', function () { validateSingleField(field); });
                    field.input.addEventListener('change', function () { validateSingleField(field); });
                }
            });

            const rolePanel = document.getElementById('staffRoleManagementPanel');
            const roleMount = document.getElementById('rolePanelMount');
            if (rolePanel && roleMount) {
                roleMount.appendChild(rolePanel);
                rolePanel.classList.remove('hidden');
                rolePanel.classList.add('animate-fade-down');
            }

            const staffUpdateForm = document.getElementById('staffUpdateForm');
            if (staffUpdateForm) {
                staffUpdateForm.querySelectorAll('input, select, textarea').forEach(function (field) {
                    field.addEventListener('input', markStaffFormDirty);
                    field.addEventListener('change', markStaffFormDirty);
                });
                staffUpdateForm.addEventListener('submit', function () {
                    hasUnsavedStaffChanges = false;
                    staffUpdateForm.classList.remove('staff-form-unsaved');
                });
            }

            document.addEventListener('keydown', function (event) {
                const isReloadShortcut = event.key === 'F5' || ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'r');
                if (!isReloadShortcut || !hasUnsavedStaffChanges) return;
                event.preventDefault();
                pendingNavigationUrl = '';
                pendingNavigationAction = 'reload';
                openUnsavedChangesModal();
            });
        });

        window.addEventListener('beforeunload', function (event) {
            if (!hasUnsavedStaffChanges) return;
            event.preventDefault();
            event.returnValue = '';
        });

        function markStaffFormDirty() {
            hasUnsavedStaffChanges = true;
            const form = document.getElementById('staffUpdateForm');
            if (form) {
                form.classList.add('staff-form-unsaved');
            }
        }

        function guardUnsavedNavigation(event, targetUrl) {
            if (!hasUnsavedStaffChanges) return true;
            if (event) event.preventDefault();
            pendingNavigationUrl = targetUrl;
            pendingNavigationAction = 'navigate';
            openUnsavedChangesModal();
            return false;
        }

        function openUnsavedChangesModal() {
            const modal = document.getElementById('unsavedChangesModal');
            if (!modal) return;
            modal.classList.remove('opacity-0', 'pointer-events-none');
            modal.children[0].classList.remove('scale-95');
        }

        function closeUnsavedChangesModal() {
            const modal = document.getElementById('unsavedChangesModal');
            if (!modal) return;
            modal.classList.add('opacity-0', 'pointer-events-none');
            modal.children[0].classList.add('scale-95');
            pendingNavigationUrl = '';
            pendingNavigationAction = '';
        }

        function confirmUnsavedNavigation() {
            hasUnsavedStaffChanges = false;
            const form = document.getElementById('staffUpdateForm');
            if (form) {
                form.classList.remove('staff-form-unsaved');
            }
            if (pendingNavigationAction === 'reload') {
                window.location.reload();
                return;
            }
            if (pendingNavigationUrl) {
                window.location.href = pendingNavigationUrl;
            }
        }

        function toggleStaffSidebar() {
            const grid = document.getElementById('staffDetailGrid');
            const icon = document.getElementById('sidebarToggleIcon');
            const text = document.getElementById('sidebarToggleText');
            if (!grid) return;

            grid.classList.toggle('sidebar-collapsed');
            const isCollapsed = grid.classList.contains('sidebar-collapsed');
            if (icon) {
                icon.className = isCollapsed ? 'fas fa-expand-alt' : 'fas fa-compress-alt';
            }
            if (text) {
                text.innerText = isCollapsed ? 'Mở thẻ hồ sơ' : 'Thu thẻ hồ sơ';
            }
        }

        // JS MODAL TRẠNG THÁI
        function openLockModal(targetStatus) {
            const modal = document.getElementById('lockModal');
            const icon = document.getElementById('lockModalIcon');
            const title = document.getElementById('lockModalTitle');
            const desc = document.getElementById('lockModalDesc');
            const btn = document.getElementById('lockModalBtn');
            const input = document.getElementById('lockModalStatusInput');

            input.value = targetStatus;

            if (targetStatus === 'Locked') {
                icon.className = 'w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center text-2xl bg-red-500/20 text-red-500';
                icon.innerHTML = '<i class="fas fa-user-lock"></i>';
                title.innerText = 'Khóa Tài Khoản?';
                desc.innerHTML = 'Nhân sự này sẽ bị tước quyền đăng nhập và thao tác trên hệ thống ngay lập tức.<br><strong class="text-red-300">Tất cả quyền của nhân viên này sẽ bị Locked.</strong>';
                btn.className = 'px-5 py-2 rounded-xl font-bold text-white transition shadow-[0_0_15px_rgba(239,68,68,0.4)] bg-red-600 hover:bg-red-500';
                btn.innerText = 'Khóa Ngay';
            } else {
                icon.className = 'w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center text-2xl bg-green-500/20 text-green-500';
                icon.innerHTML = '<i class="fas fa-user-check"></i>';
                title.innerText = 'Mở Khóa Tài Khoản?';
                desc.innerText = 'Nhân sự này sẽ được cấp lại quyền đăng nhập vào hệ thống.';
                btn.className = 'px-5 py-2 rounded-xl font-bold text-white transition shadow-[0_0_15px_rgba(34,197,94,0.4)] bg-green-600 hover:bg-green-500';
                btn.innerText = 'Mở Khóa';
            }

            modal.classList.remove('opacity-0', 'pointer-events-none');
            modal.children[0].classList.remove('scale-95');
        }

        function closeLockModal() {
            const modal = document.getElementById('lockModal');
            modal.classList.add('opacity-0', 'pointer-events-none');
            modal.children[0].classList.add('scale-95');
        }

        // JS MODAL RESET PASSWORD
        function openResetModal() {
            const modal = document.getElementById('resetModal');
            modal.classList.remove('opacity-0', 'pointer-events-none');
            modal.children[0].classList.remove('scale-95');
        }

        function closeResetModal() {
            const modal = document.getElementById('resetModal');
            modal.classList.add('opacity-0', 'pointer-events-none');
            modal.children[0].classList.add('scale-95');
        }
    </script>
    <c:if test="${readOnlyMode}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const denyMsg = 'Bạn không có quyền chỉnh sửa';
            document.querySelectorAll('#staffUpdateForm input:not([type=hidden]), #staffUpdateForm textarea, #staffUpdateForm select').forEach(function (el) {
                el.readOnly = true;
                if (el.tagName === 'SELECT' || el.type === 'file') el.disabled = true;
            });
            document.querySelectorAll('#staffUpdateForm button[type=submit]').forEach(function (btn) { btn.style.display = 'none'; });
            document.querySelectorAll('form[action*="add-role"], form[action*="update-role-status"], form[action*="update-status"], form[action*="reset-password"]').forEach(function (form) {
                form.querySelectorAll('button, input[type=submit]').forEach(function (btn) { btn.style.display = 'none'; });
                form.addEventListener('submit', function (e) {
                    e.preventDefault();
                    if (typeof showPremiumToast === 'function') showPremiumToast('error', 'Không có quyền', denyMsg);
                    else alert(denyMsg);
                });
            });
            const staffForm = document.getElementById('staffUpdateForm');
            if (staffForm) {
                staffForm.addEventListener('submit', function (e) {
                    e.preventDefault();
                    if (typeof showPremiumToast === 'function') showPremiumToast('error', 'Không có quyền', denyMsg);
                    else alert(denyMsg);
                });
            }
        });
    </script>
    </c:if>
</body>
</html>