<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Nhân Sự Mới</title>
    <style>
        .glass-card { background: rgba(22, 22, 22, 0.86); backdrop-filter: blur(16px); }
        .input-premium {
            background-color: #0d0d0d;
            border: 1px solid #262626;
            color: #f3f4f6;
            border-radius: 0.75rem;
            padding: 0.625rem 1rem;
            width: 100%;
            transition: all 0.3s ease;
        }
        .input-premium:focus { border-color: #3b82f6; outline: none; box-shadow: 0 0 12px rgba(59, 130, 246, 0.3); }
        .input-readonly { background-color: #050505; color: #737373; cursor: not-allowed; border-color: #171717; }
        .btn-premium { background: linear-gradient(135deg, #2563eb, #4f46e5); color: white; transition: all 0.3s ease; }
        .btn-premium:hover { box-shadow: 0 0 20px rgba(59, 130, 246, 0.5); transform: translateY(-2px); }
        .field-live-error { display: block; margin-top: 0.35rem; color: #fca5a5; font-size: 0.72rem; font-weight: 700; }
        .field-live-error.hidden { display: none; }
        .field-has-error { border-color: rgba(248, 113, 113, 0.95) !important; box-shadow: 0 0 0 1px rgba(248, 113, 113, 0.55), 0 0 14px rgba(239, 68, 68, 0.16) !important; }
        .field-is-valid { border-color: rgba(34, 197, 94, 0.45) !important; box-shadow: 0 0 12px rgba(34, 197, 94, 0.08) !important; }
        .form-input-wrap { position: relative; }
        .form-input-wrap .input-premium { padding-left: 2.85rem !important; }
        .form-input-icon { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #6b7280; pointer-events: none; z-index: 2; }

        @keyframes fadeDown { from { opacity: 0; transform: translateY(-16px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes subtleBounce { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-3px); } }
        @keyframes toastFlyIn { 0% { transform: translateX(130%) scale(0.9); opacity: 0; filter: blur(5px); } 60% { transform: translateX(-15px) scale(1.02); filter: blur(0); } 80% { transform: translateX(5px) scale(0.99); } 100% { transform: translateX(0) scale(1); opacity: 1; filter: blur(0); } }
        @keyframes toastFadeZoomOut { 0% { transform: translate(0) scale(1); opacity: 1; filter: blur(0); } 40% { transform: translateX(10px) scale(1.01); opacity: 0.8; } 100% { transform: translateX(60px) scale(0.85); opacity: 0; filter: blur(6px); } }
        @keyframes toastTimeline { 0% { width: 100%; } 100% { width: 0%; } }
        @keyframes glowPulseRed { 0%, 100% { border-color: rgba(239, 68, 68, 0.35); box-shadow: 0 10px 30px -5px rgba(239, 68, 68, 0.15), 0 0 15px rgba(239, 68, 68, 0.05); } 50% { border-color: rgba(239, 68, 68, 0.8); box-shadow: 0 15px 35px -2px rgba(239, 68, 68, 0.35), 0 0 25px rgba(239, 68, 68, 0.15); } }
        @keyframes glowPulseGreen { 0%, 100% { border-color: rgba(34, 197, 94, 0.35); box-shadow: 0 10px 30px -5px rgba(34, 197, 94, 0.15), 0 0 15px rgba(34, 197, 94, 0.05); } 50% { border-color: rgba(34, 197, 94, 0.8); box-shadow: 0 15px 35px -2px rgba(34, 197, 94, 0.35), 0 0 25px rgba(34, 197, 94, 0.15); } }
        @keyframes avatarOrbit { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        @keyframes avatarBreath { 0%, 100% { transform: translateY(0) scale(1); } 50% { transform: translateY(-4px) scale(1.025); } }
        @keyframes cardShimmer { 0% { transform: translateX(-120%); } 100% { transform: translateX(120%); } }
        @keyframes unsavedBorderGlow { 0%, 100% { border-color: rgba(245,158,11,0.35); box-shadow: 0 0 0 rgba(245,158,11,0); } 50% { border-color: rgba(245,158,11,0.85); box-shadow: 0 0 24px rgba(245,158,11,0.16); } }
        @keyframes warningPulse { 0%, 100% { box-shadow: 0 0 0 rgba(245,158,11,0); transform: scale(1); } 50% { box-shadow: 0 0 26px rgba(245,158,11,0.35); transform: scale(1.03); } }

        .animate-fade-down { animation: fadeDown 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-item { animation: toastFlyIn 0.55s cubic-bezier(0.25, 1, 0.5, 1) forwards; will-change: transform, opacity; z-index: 99999; }
        .toast-item.toast-leave-active { animation: toastFadeZoomOut 0.45s cubic-bezier(0.25, 1, 0.5, 1) forwards !important; }
        .toast-error-glow { animation: glowPulseRed 3s infinite ease-in-out; }
        .toast-success-glow { animation: glowPulseGreen 3s infinite ease-in-out; }
        .toast-progress-countdown { position: absolute !important; left: 0 !important; bottom: 0 !important; height: 3px !important; z-index: 3 !important; animation: toastTimeline 5s linear forwards; }
        .animate-subtle-bounce { animation: subtleBounce 2.5s ease-in-out infinite; }

        .staff-add-shell { max-width: 1500px; margin: 0 auto; padding-left: 0.75rem; padding-right: 0.75rem; }
        .decor-card { position: relative; overflow: hidden; }
        .decor-card::before {
            content: ""; position: absolute; inset: 0; pointer-events: none;
            background: linear-gradient(135deg, rgba(59,130,246,0.08), transparent 32%, rgba(168,85,247,0.07));
        }
        .decor-card::after {
            content: ""; position: absolute; top: 0; bottom: 0; width: 38%; left: -45%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.06), transparent);
            animation: cardShimmer 5s ease-in-out infinite;
            pointer-events: none;
        }
        .staff-avatar-orb {
            width: 10rem; height: 10rem; border-radius: 9999px; padding: 4px; position: relative;
            animation: avatarBreath 4s ease-in-out infinite;
            --role-a: #38bdf8; --role-b: #6366f1; --role-c: #22d3ee; --role-glow: rgba(56,189,248,0.42);
        }
        .staff-avatar-orb::before {
            content: ""; position: absolute; inset: -5px; border-radius: inherit; z-index: 0;
            background: conic-gradient(from 0deg, var(--role-a), var(--role-b), var(--role-c), var(--role-a));
            animation: avatarOrbit 4.5s linear infinite;
            filter: drop-shadow(0 0 18px var(--role-glow));
        }
        .staff-avatar-orb::after { content: ""; position: absolute; inset: 5px; border-radius: inherit; z-index: 1; background: #080808; }
        .staff-avatar-img { position: relative; z-index: 2; width: 100%; height: 100%; border-radius: inherit; object-fit: cover; border: 4px solid rgba(10,10,10,0.95); }
        .staff-add-unsaved { border-color: rgba(245,158,11,0.55) !important; animation: unsavedBorderGlow 2.6s ease-in-out infinite; }
        .unsaved-save-badge { display: none; animation: subtleBounce 2.2s ease-in-out infinite; }
        .staff-add-unsaved .unsaved-save-badge { display: inline-flex; }
        .unsaved-warning-icon { animation: warningPulse 2s ease-in-out infinite; }

        @keyframes hierarchyPanelIn { from { opacity: 0; transform: translateY(10px) scale(0.97); } to { opacity: 1; transform: translateY(0) scale(1); } }
        @keyframes hierarchyTierIn { from { opacity: 0; transform: translateX(-12px); } to { opacity: 1; transform: translateX(0); } }
        @keyframes hierarchyGlow { 0%, 100% { box-shadow: 0 0 0 rgba(168,85,247,0); } 50% { box-shadow: 0 0 22px rgba(168,85,247,0.12); } }
        @keyframes sidebarCardHover { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-2px); } }

        .sidebar-panel-card { transition: border-color 0.3s ease, box-shadow 0.3s ease, transform 0.3s ease; }
        .sidebar-panel-card:hover { transform: translateY(-2px); box-shadow: 0 12px 28px -8px rgba(0,0,0,0.45); }

        .role-hierarchy-panel {
            border-radius: 1rem;
            border: 1px solid rgba(168,85,247,0.25);
            background: linear-gradient(145deg, rgba(88,28,135,0.12), rgba(15,15,15,0.95));
            overflow: hidden;
            transition: max-height 0.45s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.35s ease, padding 0.35s ease, margin 0.35s ease;
            max-height: 0;
            opacity: 0;
            padding: 0 1rem;
            margin-top: 0;
            pointer-events: none;
        }
        .role-hierarchy-panel.is-visible {
            max-height: 180px;
            opacity: 1;
            padding: 1rem;
            margin-top: 0.85rem;
            pointer-events: auto;
            animation: hierarchyPanelIn 0.45s cubic-bezier(0.16, 1, 0.3, 1) forwards, hierarchyGlow 3s ease-in-out infinite;
        }
        .role-hierarchy-panel.count-1 { max-height: 130px; }
        .role-hierarchy-panel.count-2 { max-height: 150px; }
        .role-hierarchy-panel.count-3 { max-height: 170px; }

        .role-hierarchy-header {
            display: flex; align-items: center; justify-content: space-between; gap: 0.5rem;
            margin-bottom: 0.65rem; padding-bottom: 0.5rem; border-bottom: 1px solid rgba(168,85,247,0.2);
        }
        .role-hierarchy-stack {
            display: flex; flex-direction: row; flex-wrap: wrap; gap: 0.65rem; align-items: stretch;
        }
        .role-hierarchy-tier {
            flex: 1 1 0; min-width: 140px;
            display: flex; flex-direction: column; align-items: flex-start; gap: 0.45rem;
            border-radius: 0.85rem; padding: 0.7rem 0.75rem;
            border: 1px solid rgba(255,255,255,0.06);
            background: rgba(8,8,8,0.85);
            animation: hierarchyTierIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) backwards;
        }
        .role-hierarchy-panel.count-1 .role-hierarchy-tier { flex: 0 0 auto; min-width: 220px; max-width: 280px; }
        .role-hierarchy-panel.count-2 .role-hierarchy-tier { flex: 1 1 calc(50% - 0.35rem); min-width: 180px; }
        .role-hierarchy-panel.count-3 .role-hierarchy-tier { flex: 1 1 calc(33.333% - 0.45rem); min-width: 150px; }

        @media (max-width: 768px) {
            .role-hierarchy-stack { flex-direction: column; }
            .role-hierarchy-panel.count-1 .role-hierarchy-tier,
            .role-hierarchy-panel.count-2 .role-hierarchy-tier,
            .role-hierarchy-panel.count-3 .role-hierarchy-tier { flex: 1 1 100%; max-width: none; }
            .role-hierarchy-panel.is-visible,
            .role-hierarchy-panel.count-1,
            .role-hierarchy-panel.count-2,
            .role-hierarchy-panel.count-3 { max-height: 520px; }
        }

        .role-hierarchy-tier-row { display: flex; align-items: center; gap: 0.55rem; width: 100%; }
        .role-hierarchy-tier:nth-child(1) { animation-delay: 0.05s; }
        .role-hierarchy-tier:nth-child(2) { animation-delay: 0.12s; }
        .role-hierarchy-tier:nth-child(3) { animation-delay: 0.19s; }

        .role-hierarchy-tier.tier-admin { border-color: rgba(250,204,21,0.35); background: linear-gradient(90deg, rgba(250,204,21,0.08), rgba(8,8,8,0.9)); }
        .role-hierarchy-tier.tier-manager { border-color: rgba(56,189,248,0.35); background: linear-gradient(90deg, rgba(56,189,248,0.08), rgba(8,8,8,0.9)); }
        .role-hierarchy-tier.tier-seller { border-color: rgba(34,197,94,0.35); background: linear-gradient(90deg, rgba(34,197,94,0.08), rgba(8,8,8,0.9)); }

        .role-hierarchy-rank {
            flex-shrink: 0; width: 2rem; height: 2rem; border-radius: 0.65rem;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.62rem; font-weight: 900; letter-spacing: 0.02em;
        }
        .tier-admin .role-hierarchy-rank { background: rgba(250,204,21,0.15); color: #facc15; border: 1px solid rgba(250,204,21,0.3); }
        .tier-manager .role-hierarchy-rank { background: rgba(56,189,248,0.15); color: #38bdf8; border: 1px solid rgba(56,189,248,0.3); }
        .tier-seller .role-hierarchy-rank { background: rgba(34,197,94,0.15); color: #22c55e; border: 1px solid rgba(34,197,94,0.3); }

        .role-hierarchy-meta { min-width: 0; flex: 1; }
        .role-hierarchy-label { font-size: 0.58rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.08em; color: #9ca3af; }
        .role-hierarchy-name { font-size: 0.78rem; font-weight: 900; letter-spacing: 0.04em; text-transform: uppercase; color: #f3f4f6; }
        .role-hierarchy-desc { font-size: 0.62rem; color: #6b7280; margin-top: 0.1rem; line-height: 1.35; }
    </style>
</head>
<body class="bg-[#0b0c10] text-gray-300 font-sans min-h-screen">

<div class="staff-add-shell pb-10">
    <div class="flex flex-wrap items-center justify-between gap-4 mb-6 pb-4 border-b border-gray-800">
        <div>
            <h2 class="text-2xl font-bold text-white flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl flex items-center justify-center text-blue-500" style="background: rgba(59, 130, 246, 0.2);">
                    <i class="fas fa-user-plus"></i>
                </div>
                Thêm Nhân Sự Mới
            </h2>
            <p class="text-sm text-gray-500 mt-1">Cấp tài khoản nhân sự nội bộ và phân quyền hệ thống</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/staffs" onclick="return guardUnsavedNavigation(event, this.href)" class="px-4 py-2 rounded-xl bg-gray-800 hover:bg-gray-700 text-white text-sm font-medium transition duration-200 flex items-center gap-2">
            <i class="fas fa-arrow-left"></i> Trở về danh sách
        </a>
    </div>

    <input type="hidden" id="backend-error-bridge" value="${fn:escapeXml(errorMessage)}">
    <input type="hidden" id="backend-success-bridge" value="${fn:escapeXml(successMessage)}">
    <div id="premium-toast-container" class="fixed bottom-6 right-6 flex flex-col gap-3 z-[99999] max-w-sm w-full pointer-events-none"></div>

    <c:set var="selectedRoleIdsText" value=","/>
    <c:forEach var="selectedRoleId" items="${selectedRoleIds}">
        <c:set var="selectedRoleIdsText" value="${selectedRoleIdsText}${selectedRoleId},"/>
    </c:forEach>

    <c:set var="staffAvatarPreview" value=""/>
    <c:set var="staffAvatarInputValue" value=""/>

    <form id="staffAddForm" action="${pageContext.request.contextPath}/admin/staffs/add" method="POST" class="glass-card decor-card rounded-2xl border border-gray-800 p-5 md:p-6 relative overflow-hidden" onsubmit="return validateAddStaffForm()">
        <input type="hidden" name="password" value="Pass@123">

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 relative z-10">
            <div class="lg:col-span-4 flex flex-col gap-5">
                <div class="bg-[#0d0d0d] p-5 rounded-2xl border border-gray-800 text-center relative overflow-hidden sidebar-panel-card">
                    <div class="text-xs font-black text-gray-400 uppercase tracking-wider mb-4 border-b border-gray-800 pb-2">
                        <i class="fas fa-image text-blue-400 mr-1"></i> Ảnh đại diện
                    </div>

                    <div id="avatar-preview-container" class="staff-avatar-orb mx-auto mb-5 flex items-center justify-center shadow-xl">
                        <img id="avatar-preview-img" src="${staffAvatarPreview}" class="staff-avatar-img bg-gray-900 ${empty staffAvatarPreview ? 'hidden' : ''}" alt="Avatar" onerror="hideAvatarPreviewImage()">
                        <i id="avatar-error-icon" class="fas fa-image text-gray-500 ${empty staffAvatarPreview ? '' : 'hidden'}"></i>
                    </div>

                    <div class="text-left">
                        <label class="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Đường dẫn ảnh</label>
                        <div class="grid grid-cols-1 sm:grid-cols-4 gap-3">
                            <div class="sm:col-span-3 form-input-wrap">
                                <input type="text" name="avatar" id="avatar" value="${staffAvatarInputValue}" class="input-premium text-xs py-2" placeholder="" autocomplete="off" oninput="previewAvatar()">
                                <i class="fas fa-image form-input-icon"></i>
                            </div>
                            <div class="sm:col-span-1">
                                <input type="file" id="avatarFile" name="imageFile" accept="image/*" class="hidden" onchange="handleFileSelect(this)">
                                <button type="button" onclick="document.getElementById('avatarFile').click()" class="w-full h-full min-h-[40px] rounded-xl bg-zinc-900 hover:bg-zinc-800 border border-gray-800 hover:border-blue-500/40 text-gray-300 hover:text-white text-xs font-bold transition flex items-center justify-center gap-1">
                                    <i class="fas fa-upload text-blue-400"></i> Chọn
                                </button>
                            </div>
                        </div>
                        <p id="avatar-preview-text" class="text-[11px] text-gray-500 mt-2 leading-relaxed">Hỗ trợ link mạng, tên file trong assets/images/avatar hoặc để trống để dùng ảnh chữ cái.</p>
                    </div>
                </div>

                <div class="bg-[#0d0d0d] p-5 rounded-2xl border border-purple-500/20 sidebar-panel-card">
                    <div class="text-xs font-black text-purple-300 uppercase tracking-wider mb-4 border-b border-gray-800 pb-2">
                        <i class="fas fa-user-shield mr-1"></i> Cấp quyền ban đầu
                    </div>
                    <div id="rolesGroup" class="grid grid-cols-1 gap-2">
                        <c:forEach var="role" items="${roles}">
                            <c:set var="roleToken" value=",${role.id_Role},"/>
                            <label class="cursor-pointer group">
                                <input type="checkbox" name="roleIds" value="${role.id_Role}" data-role-name="${role.roleName}" data-role-desc="${role.description}" class="peer hidden role-checkbox-input" ${fn:contains(selectedRoleIdsText, roleToken) ? 'checked' : ''}>
                                <div class="flex items-center justify-between gap-2 rounded-xl border border-gray-700 bg-[#080808] px-3 py-2.5 text-xs text-gray-400 transition-all duration-300 peer-checked:border-purple-500/60 peer-checked:bg-purple-500/10 peer-checked:text-purple-300 group-hover:border-purple-500/30">
                                    <span class="inline-flex items-center gap-2 font-black uppercase tracking-wider">
                                        <i class="fas fa-id-badge text-[10px]"></i> ${role.roleName}
                                    </span>
                                    <i class="fas fa-check-circle text-[11px] opacity-0 peer-checked:opacity-100 transition-opacity"></i>
                                </div>
                            </label>
                        </c:forEach>
                    </div>

                    <span id="roles-error" class="field-live-error hidden"></span>
                    <p class="text-[11px] text-gray-500 mt-2 leading-relaxed">Có thể chọn nhiều quyền. Mỗi quyền sẽ tạo một dòng `UserRole` với trạng thái Active.</p>
                </div>

                <div class="rounded-2xl border border-yellow-500/20 bg-yellow-500/5 p-4 sidebar-panel-card">
                    <div class="flex items-start gap-3">
                        <div class="w-9 h-9 rounded-lg bg-yellow-500/10 border border-yellow-500/20 text-yellow-400 flex items-center justify-center flex-shrink-0">
                            <i class="fas fa-key"></i>
                        </div>
                        <div>
                            <p class="text-xs font-black uppercase tracking-wider text-yellow-300 mb-1">Mật khẩu mặc định</p>
                            <p class="text-[11px] text-gray-400 leading-relaxed">Tài khoản nhân sự mới sẽ dùng mật khẩu khởi tạo <strong class="text-white">Pass@123</strong>. Sau này admin chỉ reset về mặc định, không xem mật khẩu thật.</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="lg:col-span-8 flex flex-col gap-5">
                <h3 class="text-lg font-bold text-white border-b border-gray-800 pb-2"><i class="fas fa-id-card text-blue-500 mr-2"></i> Hồ sơ nhân sự</h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-medium text-gray-400 mb-1">Họ và tên <span class="text-red-500">*</span></label>
                        <div class="form-input-wrap">
                            <input type="text" name="fullName" id="fullName" value="${staff.fullName == 'Chưa cập nhật' ? '' : staff.fullName}" class="input-premium text-sm" placeholder="Nhập tên nhân sự">
                            <i class="fas fa-signature form-input-icon"></i>
                        </div>
                        <span id="fullName-error" class="field-live-error hidden"></span>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-400 mb-1">Số điện thoại <span class="text-red-500">*</span></label>
                        <div class="form-input-wrap">
                            <input type="text" name="phone" id="phone" value="${staff.phone}" class="input-premium text-sm font-mono" placeholder="Ví dụ: 0901234567">
                            <i class="fas fa-phone-alt form-input-icon"></i>
                        </div>
                        <span id="phone-error" class="field-live-error hidden"></span>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-1">Email <span class="text-red-500">*</span></label>
                    <div class="form-input-wrap">
                        <input type="text" name="email" id="email" value="${staff.email}" class="input-premium text-sm" placeholder="Ví dụ: nhansu@starlight.com">
                        <i class="fas fa-envelope form-input-icon"></i>
                    </div>
                    <span id="email-error" class="field-live-error hidden"></span>
                </div>

                <h3 class="text-lg font-bold text-white border-b border-gray-800 pb-2 mt-3"><i class="fas fa-lock text-blue-500 mr-2"></i> Tài khoản truy cập</h3>

                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-1">Tên đăng nhập <span class="text-red-500">*</span></label>
                    <div class="form-input-wrap">
                        <input type="text" name="username" id="username" value="${staff.username}" class="input-premium text-sm font-mono text-blue-300" placeholder="Không dấu, không khoảng trắng">
                        <i class="fas fa-user-circle form-input-icon"></i>
                    </div>
                    <span id="username-error" class="field-live-error hidden"></span>
                    <p class="text-[11px] text-gray-500 mt-1 leading-relaxed">Username được tạo một lần khi lập tài khoản, sau đó không chỉnh trong trang hồ sơ.</p>
                </div>

                <div class="rounded-xl border border-blue-500/20 bg-blue-500/5 p-4">
                    <div class="flex items-start gap-3">
                        <div class="w-9 h-9 rounded-lg bg-blue-500/10 border border-blue-500/20 text-blue-400 flex items-center justify-center flex-shrink-0">
                            <i class="fas fa-circle-info"></i>
                        </div>
                        <p class="text-xs text-gray-400 leading-relaxed">
                            Email hoặc số điện thoại trùng với tài khoản đã có sẽ không tạo được nhân sự mới.
                            Tài khoản vừa tạo mặc định ở trạng thái <strong class="text-blue-300">Active</strong>.
                        </p>
                    </div>
                </div>

                <div id="roleHierarchyPanel" class="role-hierarchy-panel" aria-live="polite">
                    <div class="role-hierarchy-header">
                        <span class="text-[10px] font-black uppercase tracking-wider text-purple-300">
                            <i class="fas fa-layer-group mr-1"></i> Danh sách quyền đã chọn
                        </span>
                        <span id="roleHierarchyCount" class="text-[10px] font-bold text-gray-500"></span>
                    </div>
                    <div id="roleHierarchyStack" class="role-hierarchy-stack"></div>
                </div>
            </div>
        </div>

        <div class="mt-8 pt-5 border-t border-gray-800 flex flex-wrap justify-end gap-4 relative z-10">
            <button type="button" onclick="guardResetForm()" class="px-6 py-2.5 rounded-xl border border-gray-700 text-gray-400 hover:text-white hover:bg-gray-800 transition duration-300 font-medium">
                <i class="fas fa-rotate-left mr-1"></i> Nhập lại
            </button>
            <button type="submit" class="px-8 py-2.5 rounded-xl btn-premium font-bold flex items-center gap-2">
                <i class="fas fa-save"></i> Lưu Nhân Sự
                <span class="unsaved-save-badge items-center gap-1 rounded-full bg-yellow-400/15 border border-yellow-400/30 text-yellow-200 px-2 py-0.5 text-[10px] uppercase tracking-wider">
                    <i class="fas fa-circle-exclamation text-[9px]"></i> Chưa lưu
                </span>
            </button>
        </div>
    </form>
</div>

<div id="confirmActionModal" class="fixed inset-0 z-[60] flex items-center justify-center bg-black/70 opacity-0 pointer-events-none transition-opacity duration-300 backdrop-blur-sm">
    <div class="bg-[#121212] border border-yellow-500/30 rounded-2xl w-full max-w-md p-6 shadow-2xl transform scale-95 transition-transform duration-300 text-center relative overflow-hidden">
        <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-yellow-500 via-orange-500 to-red-500"></div>
        <div class="unsaved-warning-icon w-20 h-20 rounded-full bg-yellow-500/10 text-yellow-400 border border-yellow-500/30 mx-auto mb-4 flex items-center justify-center text-4xl">
            <i id="confirmActionIcon" class="fas fa-triangle-exclamation"></i>
        </div>
        <h4 id="confirmActionTitle" class="text-white font-black text-xl mb-2 uppercase tracking-wider">Xác nhận</h4>
        <p id="confirmActionDesc" class="text-sm text-gray-400 mb-6 leading-relaxed"></p>
        <div class="flex gap-3">
            <button type="button" onclick="closeConfirmActionModal()" class="flex-1 px-5 py-2.5 rounded-xl bg-gray-800 hover:bg-gray-700 border border-gray-700 text-gray-300 hover:text-white transition font-bold">
                <i class="fas fa-rotate-left mr-1"></i> Ở lại
            </button>
            <button type="button" onclick="confirmPendingAction()" class="flex-1 px-5 py-2.5 rounded-xl bg-gradient-to-r from-yellow-600 to-orange-600 hover:from-yellow-500 hover:to-orange-500 text-white transition font-bold shadow-[0_0_16px_rgba(245,158,11,0.35)]">
                <i class="fas fa-check mr-1"></i> Xác nhận
            </button>
        </div>
    </div>
</div>

<script>
    let hasUnsavedAddChanges = false;
    let pendingAction = '';
    let pendingUrl = '';

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
        const autoDismissTimer = setTimeout(function () { dismissTargetToast(toast); }, 5000);
        toast.dataset.timerId = autoDismissTimer;
    }

    function dismissTargetToast(toast) {
        if (!toast || toast.classList.contains('toast-leave-active')) return;
        if (toast.dataset.timerId) clearTimeout(parseInt(toast.dataset.timerId, 10));
        toast.classList.add('toast-leave-active');
        setTimeout(function () { toast.remove(); }, 450);
    }

    function setFieldState(input, errorEl, message) {
        if (!input) return;
        if (message) {
            input.classList.add('field-has-error');
            input.classList.remove('field-is-valid');
            if (errorEl) {
                errorEl.innerText = message;
                errorEl.classList.remove('hidden');
            }
        } else {
            input.classList.remove('field-has-error');
            if (input.value && input.type !== 'checkbox') {
                input.classList.add('field-is-valid');
            }
            if (errorEl) {
                errorEl.innerText = '';
                errorEl.classList.add('hidden');
            }
        }
    }

    function getAddFieldRules() {
        const nameRegex = /^[A-Za-zÀ-ỹ\s]+$/u;
        const phoneRegex = /^(0[3|5|7|8|9])+([0-9]{8})$/;
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const usernameRegex = /^[a-zA-Z0-9_]{4,50}$/;

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
                    if (!emailRegex.test(value)) return 'Email không đúng định dạng, ví dụ staff@starlight.com.';
                    return '';
                }
            },
            username: {
                input: document.getElementById('username'),
                errorEl: document.getElementById('username-error'),
                validate: function (value) {
                    if (!value) return 'Vui lòng không để trống tên đăng nhập.';
                    if (!usernameRegex.test(value)) return 'Tên đăng nhập từ 4-50 ký tự, không dấu, không khoảng trắng.';
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

    function validateRoles() {
        const checkedRoles = document.querySelectorAll('input[name="roleIds"]:checked');
        const errorEl = document.getElementById('roles-error');
        if (checkedRoles.length === 0) {
            if (errorEl) {
                errorEl.innerText = 'Vui lòng chọn ít nhất một quyền cho nhân sự.';
                errorEl.classList.remove('hidden');
            }
            return 'Vui lòng chọn ít nhất một quyền cho nhân sự.';
        }
        if (errorEl) {
            errorEl.innerText = '';
            errorEl.classList.add('hidden');
        }
        return '';
    }

    const ROLE_HIERARCHY_META = {
        ADMIN: { rank: 1, tierClass: 'tier-admin', icon: 'fa-crown', desc: 'Quản trị toàn hệ thống' },
        MANAGER: { rank: 2, tierClass: 'tier-manager', icon: 'fa-user-tie', desc: 'Quản lý vận hành rạp' },
        TICKETSELLER: { rank: 3, tierClass: 'tier-seller', icon: 'fa-ticket-alt', desc: 'Nhân viên bán vé' }
    };
    const ROLE_ORDINAL_LABELS = ['Quyền thứ nhất', 'Quyền thứ hai', 'Quyền thứ ba'];

    function updateRoleHierarchyPanel() {
        const panel = document.getElementById('roleHierarchyPanel');
        const stack = document.getElementById('roleHierarchyStack');
        const countEl = document.getElementById('roleHierarchyCount');
        if (!panel || !stack) return;

        const selectedRoles = [];
        document.querySelectorAll('input[name="roleIds"]:checked').forEach(function (input) {
            const roleName = (input.getAttribute('data-role-name') || '').trim().toUpperCase();
            const meta = ROLE_HIERARCHY_META[roleName];
            if (meta) {
                selectedRoles.push({
                    name: roleName,
                    desc: input.getAttribute('data-role-desc') || meta.desc,
                    rank: meta.rank,
                    tierClass: meta.tierClass,
                    icon: meta.icon
                });
            }
        });

        selectedRoles.sort(function (a, b) { return a.rank - b.rank; });
        stack.innerHTML = '';

        panel.classList.remove('is-visible', 'count-1', 'count-2', 'count-3');
        if (selectedRoles.length === 0) {
            if (countEl) countEl.innerText = '';
            return;
        }

        panel.classList.add('is-visible', 'count-' + selectedRoles.length);
        if (countEl) countEl.innerText = selectedRoles.length + ' quyền';

        selectedRoles.forEach(function (role, index) {
            const ordinalLabel = ROLE_ORDINAL_LABELS[index] || ('Quyền thứ ' + (index + 1));
            const tier = document.createElement('div');
            tier.className = 'role-hierarchy-tier ' + role.tierClass;
            tier.innerHTML =
                '<div class="role-hierarchy-tier-row">' +
                    '<div class="role-hierarchy-rank"><i class="fas ' + role.icon + ' text-[11px]"></i></div>' +
                    '<div class="role-hierarchy-meta">' +
                        '<div class="role-hierarchy-label">' + ordinalLabel + '</div>' +
                        '<div class="role-hierarchy-name">' + escapeToastText(role.name) + '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="role-hierarchy-desc">' + escapeToastText(role.desc) + '</div>';
            stack.appendChild(tier);
        });
    }

    function validateAddStaffForm() {
        const fields = getAddFieldRules();
        let firstError = '';
        Object.keys(fields).forEach(function (key) {
            const message = validateSingleField(fields[key]);
            if (message && !firstError) firstError = message;
        });
        const roleError = validateRoles();
        if (roleError && !firstError) firstError = roleError;

        if (firstError) {
            triggerPremiumToast('error', 'Lỗi Nhập Liệu', firstError);
            return false;
        }
        hasUnsavedAddChanges = false;
        const form = document.getElementById('staffAddForm');
        if (form) form.classList.remove('staff-add-unsaved');
        return true;
    }

    function syncAvatarImages(src) {
        const img = document.getElementById('avatar-preview-img');
        const icon = document.getElementById('avatar-error-icon');
        if (img) {
            img.src = src;
            img.classList.remove('hidden');
        }
        if (icon) icon.classList.add('hidden');
    }

    function hideAvatarPreviewImage() {
        const img = document.getElementById('avatar-preview-img');
        const icon = document.getElementById('avatar-error-icon');
        if (img) {
            img.removeAttribute('src');
            img.classList.add('hidden');
        }
        if (icon) icon.classList.remove('hidden');
    }

    function previewAvatar() {
        const avatarInput = document.getElementById('avatar');
        if (!avatarInput) return;
        const avatarUrl = avatarInput.value.trim();
        const fullName = document.getElementById('fullName') ? document.getElementById('fullName').value.trim() : '';
        const previewText = document.getElementById('avatar-preview-text');

        if (avatarUrl !== '') {
            if (avatarUrl.startsWith('http')) {
                syncAvatarImages(avatarUrl);
                if (previewText) previewText.innerText = 'Đang hiển thị ảnh xem trước từ đường link Internet.';
            } else if (avatarUrl.startsWith('/assets/')) {
                syncAvatarImages('${pageContext.request.contextPath}' + avatarUrl);
                if (previewText) previewText.innerText = 'Đang hiển thị ảnh xem trước từ thư mục assets.';
            } else {
                syncAvatarImages('${pageContext.request.contextPath}/assets/images/avatar/' + avatarUrl);
                if (previewText) previewText.innerText = 'Đang hiển thị ảnh xem trước từ tên file trong assets/images/avatar.';
            }
        } else if (fullName !== '') {
            syncAvatarImages('https://ui-avatars.com/api/?name=' + encodeURIComponent(fullName) + '&background=random');
            if (previewText) previewText.innerText = 'Đang hiển thị ảnh chữ cái theo họ tên.';
        } else {
            hideAvatarPreviewImage();
            if (previewText) previewText.innerText = '';
        }
    }

    function handleFileSelect(input) {
        if (input.files && input.files[0]) {
            const fileName = input.files[0].name;
            const avatarInput = document.getElementById('avatar');
            const previewText = document.getElementById('avatar-preview-text');
            avatarInput.value = fileName;
            syncAvatarImages(URL.createObjectURL(input.files[0]));
            markAddFormDirty();
            if (previewText) previewText.innerText = 'Đang xem trước ảnh vừa chọn. Hệ thống sẽ lưu tên file ' + fileName + '.';
        }
    }

    function markAddFormDirty() {
        hasUnsavedAddChanges = true;
        const form = document.getElementById('staffAddForm');
        if (form) form.classList.add('staff-add-unsaved');
    }

    function hasAnyAddInput() {
        const fields = ['fullName', 'phone', 'email', 'username', 'avatar'];
        for (let i = 0; i < fields.length; i++) {
            const field = document.getElementById(fields[i]);
            if (field && field.value.trim() !== '') return true;
        }
        return document.querySelectorAll('input[name="roleIds"]:checked').length > 0;
    }

    function guardUnsavedNavigation(event, targetUrl) {
        if (!hasUnsavedAddChanges && !hasAnyAddInput()) return true;
        if (event) event.preventDefault();
        pendingAction = 'navigate';
        pendingUrl = targetUrl;
        openConfirmActionModal('Rời khỏi trang?', 'Bạn đã nhập thông tin nhân sự mới nhưng chưa lưu. Bạn có chắc chắn muốn rời khỏi trang này không?', 'fa-door-open');
        return false;
    }

    function guardResetForm() {
        if (!hasUnsavedAddChanges && !hasAnyAddInput()) {
            resetAddFormNow();
            return;
        }
        pendingAction = 'reset';
        pendingUrl = '';
        openConfirmActionModal('Nhập lại biểu mẫu?', 'Toàn bộ thông tin đang nhập sẽ bị xóa trắng. Bạn có chắc chắn muốn nhập lại không?', 'fa-rotate-left');
    }

    function openConfirmActionModal(title, desc, iconClass) {
        const modal = document.getElementById('confirmActionModal');
        if (!modal) return;
        document.getElementById('confirmActionTitle').innerText = title;
        document.getElementById('confirmActionDesc').innerText = desc;
        document.getElementById('confirmActionIcon').className = 'fas ' + iconClass;
        modal.classList.remove('opacity-0', 'pointer-events-none');
        modal.children[0].classList.remove('scale-95');
    }

    function closeConfirmActionModal() {
        const modal = document.getElementById('confirmActionModal');
        if (!modal) return;
        modal.classList.add('opacity-0', 'pointer-events-none');
        modal.children[0].classList.add('scale-95');
        pendingAction = '';
        pendingUrl = '';
    }

    function confirmPendingAction() {
        if (pendingAction === 'reset') {
            resetAddFormNow();
            closeConfirmActionModal();
            return;
        }
        if (pendingAction === 'reload') {
            hasUnsavedAddChanges = false;
            window.location.reload();
            return;
        }
        if (pendingAction === 'navigate' && pendingUrl) {
            hasUnsavedAddChanges = false;
            window.location.href = pendingUrl;
        }
    }

    function resetAddFormNow() {
        const form = document.getElementById('staffAddForm');
        if (!form) return;
        form.reset();
        document.querySelectorAll('input[name="roleIds"]').forEach(function (role) { role.checked = false; });
        document.querySelectorAll('.field-live-error').forEach(function (errorEl) { errorEl.classList.add('hidden'); errorEl.innerText = ''; });
        document.querySelectorAll('.input-premium').forEach(function (input) { input.classList.remove('field-has-error', 'field-is-valid'); });
        hasUnsavedAddChanges = false;
        form.classList.remove('staff-add-unsaved');
        previewAvatar();
        updateRoleHierarchyPanel();
        triggerPremiumToast('success', 'Đã Nhập Lại', 'Biểu mẫu thêm nhân sự đã được làm mới.');
    }

    window.addEventListener('beforeunload', function (event) {
        if (!hasUnsavedAddChanges) return;
        event.preventDefault();
        event.returnValue = '';
    });

    window.addEventListener('DOMContentLoaded', function () {
        const errorBridge = document.getElementById('backend-error-bridge');
        const successBridge = document.getElementById('backend-success-bridge');
        if (errorBridge && errorBridge.value.trim() !== '') {
            triggerPremiumToast('error', 'Lỗi Thêm Nhân Sự', errorBridge.value.trim());
        }
        if (successBridge && successBridge.value.trim() !== '') {
            triggerPremiumToast('success', 'Thành Công', successBridge.value.trim());
        }

        const fields = getAddFieldRules();
        Object.keys(fields).forEach(function (key) {
            const field = fields[key];
            if (field.input) {
                field.input.addEventListener('input', function () {
                    markAddFormDirty();
                    validateSingleField(field);
                    if (key === 'fullName') {
                        const avatarInput = document.getElementById('avatar');
                        if (avatarInput && avatarInput.value.trim() === '') {
                            previewAvatar();
                        }
                    }
                });
                field.input.addEventListener('blur', function () { validateSingleField(field); });
                field.input.addEventListener('change', function () { markAddFormDirty(); validateSingleField(field); });
            }
        });
        document.querySelectorAll('input[name="roleIds"]').forEach(function (roleInput) {
            roleInput.addEventListener('change', function () {
                markAddFormDirty();
                validateRoles();
                updateRoleHierarchyPanel();
            });
        });

        document.addEventListener('keydown', function (event) {
            const isReloadShortcut = event.key === 'F5' || ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'r');
            if (!isReloadShortcut || !hasUnsavedAddChanges) return;
            event.preventDefault();
            pendingAction = 'reload';
            pendingUrl = '';
            openConfirmActionModal('Tải lại trang?', 'Bạn đã nhập thông tin nhân sự mới nhưng chưa lưu. Xác nhận tải lại sẽ mất dữ liệu đang nhập.', 'fa-rotate');
        });

        previewAvatar();
        updateRoleHierarchyPanel();
    });
</script>
</body>
</html>
