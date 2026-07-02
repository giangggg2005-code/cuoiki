<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="displayFullName" value="${not empty formFullName ? formFullName : customer.fullName}" />
<c:set var="displayEmail" value="${not empty formEmail ? formEmail : customer.email}" />
<c:set var="displayPhone" value="${not empty formPhone ? formPhone : customer.phone}" />
<c:set var="displayAvatar" value="${not empty formAvatar ? formAvatar : customer.avatar}" />

<c:set var="previewSrc" value=""/>
<c:choose>
    <c:when test="${not empty displayAvatar && displayAvatar != 'null' && fn:trim(displayAvatar) != ''}">
        <c:choose>
            <c:when test="${fn:startsWith(fn:trim(displayAvatar), 'http')}">
                <c:set var="previewSrc" value="${fn:trim(displayAvatar)}"/>
            </c:when>
            <c:otherwise>
                <c:set var="previewSrc" value="${pageContext.request.contextPath}/assets/images/avatar/${fn:trim(displayAvatar)}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="previewSrc" value="https://ui-avatars.com/api/?name=${not empty displayFullName ? displayFullName : 'User'}&background=random"/>
    </c:otherwise>
</c:choose>

<c:if test="${not empty errorMessage}">
    <input type="hidden" id="backend-error-bridge" value="<c:out value='${errorMessage}'/>">
</c:if>
<c:if test="${not empty successMessage}">
    <input type="hidden" id="backend-success-bridge" value="<c:out value='${successMessage}'/>">
</c:if>
<c:if test="${not empty errorFieldFullName}">
    <input type="hidden" id="server-error-fullName" value="<c:out value='${errorFieldFullName}'/>">
</c:if>
<c:if test="${not empty errorFieldEmail}">
    <input type="hidden" id="server-error-email" value="<c:out value='${errorFieldEmail}'/>">
</c:if>
<c:if test="${not empty errorFieldPhone}">
    <input type="hidden" id="server-error-phone" value="<c:out value='${errorFieldPhone}'/>">
</c:if>
<c:if test="${not empty errorFieldAvatar}">
    <input type="hidden" id="server-error-avatar" value="<c:out value='${errorFieldAvatar}'/>">
</c:if>

<style>
    .input-premium {
        background-color: #1a1a1a;
        border: 1px solid #374151;
        color: #f3f4f6;
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        width: 100%;
        transition: all 0.3s ease;
    }
    .input-premium:focus {
        border-color: #ef4444;
        outline: none;
        box-shadow: 0 0 12px rgba(239, 68, 68, 0.25);
    }
    @keyframes shake-error {
        0%, 100% { transform: translateX(0); }
        20%, 60% { transform: translateX(-4px); }
        40%, 80% { transform: translateX(4px); }
    }
    .shake-animation { animation: shake-error 0.4s ease-in-out; }
    @keyframes toastFlyIn {
        0% { transform: translateX(130%) scale(0.9); opacity: 0; filter: blur(5px); }
        60% { transform: translateX(-15px) scale(1.02); filter: blur(0); }
        80% { transform: translateX(5px) scale(0.99); }
        100% { transform: translateX(0) scale(1); opacity: 1; filter: blur(0); }
    }
    @keyframes toastFadeZoomOut {
        0% { transform: translate(0) scale(1); opacity: 1; }
        100% { transform: translateX(60px) scale(0.85); opacity: 0; filter: blur(6px); }
    }
    @keyframes toastTimeline { 0% { width: 100%; } 100% { width: 0%; } }
    @keyframes glowPulseRed {
        0%, 100% { border-color: rgba(239, 68, 68, 0.35); box-shadow: 0 10px 30px -5px rgba(239, 68, 68, 0.15); }
        50% { border-color: rgba(239, 68, 68, 0.8); box-shadow: 0 15px 35px -2px rgba(239, 68, 68, 0.35); }
    }
    @keyframes glowPulseGreen {
        0%, 100% { border-color: rgba(34, 197, 94, 0.35); box-shadow: 0 10px 30px -5px rgba(34, 197, 94, 0.15); }
        50% { border-color: rgba(34, 197, 94, 0.8); box-shadow: 0 15px 35px -2px rgba(34, 197, 94, 0.35); }
    }
    @keyframes glowPulseBlue {
        0%, 100% { border-color: rgba(59, 130, 246, 0.35); box-shadow: 0 10px 30px -5px rgba(59, 130, 246, 0.15); }
        50% { border-color: rgba(59, 130, 246, 0.8); box-shadow: 0 15px 35px -2px rgba(59, 130, 246, 0.35); }
    }
    @keyframes subtleBounce {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-3px); }
    }
    .toast-item { animation: toastFlyIn 0.55s cubic-bezier(0.25, 1, 0.5, 1) forwards; z-index: 99999; }
    .toast-item.toast-leave-active { animation: toastFadeZoomOut 0.45s cubic-bezier(0.25, 1, 0.5, 1) forwards !important; }
    .toast-error-glow { animation: glowPulseRed 3s infinite ease-in-out; }
    .toast-success-glow { animation: glowPulseGreen 3s infinite ease-in-out; }
    .toast-info-glow { animation: glowPulseBlue 3s infinite ease-in-out; }
    .toast-progress-countdown { animation: toastTimeline 5s linear forwards; }
    .animate-subtle-bounce { animation: subtleBounce 2.5s ease-in-out infinite; }
</style>

<div id="premium-toast-container" class="fixed bottom-6 right-6 flex flex-col gap-3 z-[99999] max-w-sm w-full pointer-events-none"></div>

<div class="max-w-5xl mx-auto space-y-8">
    <div>
        <h1 class="text-3xl font-black text-white uppercase tracking-tight">Thông tin cá nhân</h1>
        <p class="text-gray-500 mt-2 text-sm">Quản lý và cập nhật hồ sơ tài khoản của bạn.</p>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div class="lg:col-span-1">
            <div class="bg-[#121212] border border-gray-800 rounded-2xl p-8 text-center">
                <div class="w-28 h-28 mx-auto mb-5 rounded-full overflow-hidden border-4 border-red-600 shadow-lg shadow-red-600/20 bg-gray-800">
                    <img id="profile-avatar-preview"
                         src="${previewSrc}"
                         alt="Avatar"
                         class="w-full h-full object-cover"
                         onerror="this.src='${pageContext.request.contextPath}/assets/images/brand/logo/logo-icon.svg';">
                </div>
                <h2 class="text-xl font-black text-white mb-1"><c:out value="${displayFullName}" /></h2>
                <p class="text-gray-500 text-sm mb-6"><c:out value="${displayEmail}" /></p>

                <div class="bg-[#1a1a1a] border border-gray-800 rounded-xl p-4 text-left mb-6">
                    <p class="text-[10px] font-bold uppercase tracking-widest text-red-500 mb-2">Starlight Rewards</p>
                    <p class="text-2xl font-black text-white">
                        <fmt:formatNumber value="${customer.totalSpent / 1000}" maxFractionDigits="0" />
                        <span class="text-xs font-normal text-gray-500">PTS</span>
                    </p>
                    <p class="text-xs text-gray-500 mt-2 flex items-center gap-2">
                        <i class="fas fa-crown text-yellow-500"></i>
                        <c:choose>
                            <c:when test="${customer.totalBookings >= 10}">Thành viên Vàng</c:when>
                            <c:when test="${customer.totalBookings >= 3}">Thành viên Bạc</c:when>
                            <c:otherwise>Thành viên Mới</c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <div class="space-y-2 text-left text-sm">
                    <div class="flex justify-between text-gray-500">
                        <span>Tên đăng nhập</span>
                        <span class="text-white font-semibold"><c:out value="${customer.username}" /></span>
                    </div>
                    <div class="flex justify-between text-gray-500">
                        <span>Số điện thoại</span>
                        <span class="text-white font-semibold"><c:out value="${displayPhone}" /></span>
                    </div>
                    <div class="flex justify-between text-gray-500">
                        <span>Trạng thái</span>
                        <span class="text-green-400 font-semibold"><c:out value="${customer.status}" /></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="lg:col-span-2">
            <div class="bg-[#121212] border border-gray-800 rounded-2xl p-8">
                <h3 class="text-lg font-bold text-white mb-6 flex items-center gap-2">
                    <i class="fas fa-user-pen text-red-500"></i> Chỉnh sửa hồ sơ
                </h3>

                <form id="customerProfileForm" action="${pageContext.request.contextPath}/customer/profile/update" method="post" enctype="multipart/form-data" class="space-y-5" novalidate>
                    <div>
                        <label for="fullName" class="block text-xs font-bold uppercase tracking-widest text-gray-500 mb-2">Họ và tên <span class="text-red-500">*</span></label>
                        <input type="text" id="fullName" name="fullName" maxlength="100"
                               value="<c:out value='${displayFullName}' />"
                               class="input-premium profile-field"
                               placeholder="Nguyễn Văn A...">
                        <span id="error-fullName" class="text-[11px] text-red-400 mt-1 hidden"></span>
                    </div>

                    <div>
                        <label for="email" class="block text-xs font-bold uppercase tracking-widest text-gray-500 mb-2">Email <span class="text-red-500">*</span></label>
                        <input type="email" id="email" name="email"
                               value="<c:out value='${displayEmail}' />"
                               class="input-premium profile-field"
                               placeholder="example@gmail.com">
                        <span id="error-email" class="text-[11px] text-red-400 mt-1 hidden"></span>
                    </div>

                    <div>
                        <label for="phone" class="block text-xs font-bold uppercase tracking-widest text-gray-500 mb-2">Số điện thoại <span class="text-red-500">*</span></label>
                        <input type="text" id="phone" name="phone"
                               value="<c:out value='${displayPhone}' />"
                               class="input-premium profile-field"
                               placeholder="VD: 0987654321">
                        <span id="error-phone" class="text-[11px] text-red-400 mt-1 hidden"></span>
                        <p class="text-xs text-gray-600 mt-1">10 số, bắt đầu 03/05/07/08/09 hoặc +84</p>
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase tracking-widest text-gray-500 mb-2">Ảnh đại diện (Nhập URL hoặc chọn file từ máy)</label>
                        <div class="grid grid-cols-1 sm:grid-cols-4 gap-3">
                            <div class="sm:col-span-3">
                                <input type="text" id="avatar" name="avatar"
                                       value="<c:out value='${displayAvatar}' />"
                                       placeholder="https://... hoặc đường dẫn tự động khi chọn file"
                                       class="input-premium profile-field"
                                       oninput="previewAvatar()">
                            </div>
                            <div class="sm:col-span-1">
                                <input type="file" id="avatarFile" name="imageFile" accept="image/*" class="hidden" onchange="handleFileSelect(this)"/>
                                <button type="button" onclick="document.getElementById('avatarFile').click()"
                                        class="w-full py-3 px-4 bg-[#1a1a1a] hover:bg-[#222] text-gray-300 rounded-xl border border-gray-700 hover:border-red-500/50 transition flex items-center justify-center gap-2 text-sm font-medium min-h-[48px]">
                                    <i class="fas fa-upload text-red-500"></i> Chọn ảnh
                                </button>
                            </div>
                        </div>
                        <span id="error-avatar" class="text-[11px] text-red-400 mt-1 hidden"></span>

                        <div class="mt-3 flex items-center gap-3 transition-all duration-300" id="avatar-preview-container">
                            <div class="w-12 h-12 rounded-full border border-gray-600 shadow-lg overflow-hidden flex-shrink-0 bg-gray-800 flex items-center justify-center">
                                <img id="avatar-preview-img"
                                     src="${previewSrc}"
                                     alt="Preview"
                                     class="w-full h-full object-cover"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/brand/logo/logo-icon.svg'; this.classList.remove('hidden');">
                                <i id="avatar-error-icon" class="fas fa-image text-gray-500 hidden"></i>
                            </div>
                            <span class="text-xs text-gray-400 italic" id="avatar-preview-text">Đang hiển thị ảnh xem trước...</span>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase tracking-widest text-gray-500 mb-2">Tên đăng nhập</label>
                        <input type="text" value="<c:out value='${customer.username}' />" disabled
                               class="w-full bg-[#0b0c10] border border-gray-800 rounded-xl px-4 py-3 text-gray-500 cursor-not-allowed">
                        <p class="text-xs text-gray-600 mt-1">Tên đăng nhập không thể thay đổi.</p>
                    </div>

                    <div class="flex flex-wrap gap-4 pt-4 border-t border-gray-800">
                        <button type="button" onclick="validateProfileForm()"
                                class="bg-red-600 hover:bg-red-700 text-white font-bold px-8 py-3 rounded-xl text-sm uppercase tracking-widest transition-all">
                            <i class="fas fa-save mr-2"></i> Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/customer/history"
                           class="inline-flex items-center px-6 py-3 rounded-xl border border-gray-700 text-gray-400 hover:text-white hover:border-gray-500 text-sm font-semibold transition-all">
                            <i class="fas fa-clock-rotate-left mr-2"></i> Lịch sử đặt vé
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<div id="customConfirmModal" class="fixed inset-0 bg-black/80 z-[10000] hidden items-center justify-center backdrop-blur-sm transition-opacity duration-300 opacity-0">
    <div id="confirmModalBox" class="bg-[#121212] border border-red-500/50 rounded-2xl p-6 max-w-md w-full shadow-2xl transform scale-95 transition-all duration-300 mx-4">
        <div class="text-center mb-5">
            <div class="w-20 h-20 bg-red-500/10 border-red-500/30 rounded-full flex items-center justify-center mx-auto mb-4 border">
                <i class="fas fa-user-pen text-4xl text-red-500 animate-subtle-bounce"></i>
            </div>
            <h3 class="text-xl font-bold text-white mb-2 uppercase tracking-wider">Xác nhận cập nhật</h3>
            <p class="text-sm text-gray-400 leading-relaxed">Bạn có chắc chắn muốn <strong class="text-red-400">lưu thông tin cá nhân</strong> mới không?</p>
        </div>
        <div class="flex gap-3">
            <button type="button" onclick="closeConfirmModal()" class="flex-1 px-4 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 hover:text-white rounded-xl text-sm font-medium transition">
                <i class="fas fa-times mr-1"></i> Hủy bỏ
            </button>
            <button type="button" id="btn-confirm-submit" onclick="submitProfileForm()" class="flex-1 px-4 py-2.5 bg-red-600 hover:bg-red-700 text-white rounded-xl text-sm font-bold transition">
                <i id="btn-confirm-icon" class="fas fa-check mr-1"></i> <span id="btn-confirm-text">Xác nhận</span>
            </button>
        </div>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const phoneRegex = /^(03|05|07|08|09)\d{8}$/;
    const phoneRegexServer = /^(0|\+84)[0-9]{9}$/;
    const MAX_AVATAR_SIZE = 5 * 1024 * 1024;

    function triggerPremiumToast(type, title, message) {
        const container = document.getElementById('premium-toast-container');
        if (!container) return;

        const toast = document.createElement('div');
        let wrapperClass, iconHtml, titleColorClass, iconBgClass, barGradientClass, subIconHtml;

        if (type === 'success') {
            wrapperClass = 'bg-zinc-950/90 text-white toast-success-glow border-green-500/30';
            iconHtml = '<i class="fas fa-check-circle text-base animate-pulse"></i>';
            titleColorClass = 'text-green-400';
            iconBgClass = 'bg-green-500/10 border-green-500/20 text-green-400';
            barGradientClass = 'from-green-500 via-emerald-400 to-teal-500';
            subIconHtml = '<i class="fas fa-star text-[10px]"></i>';
        } else if (type === 'info') {
            wrapperClass = 'bg-zinc-950/90 text-white toast-info-glow border-blue-500/30';
            iconHtml = '<i class="fas fa-spinner fa-spin text-base"></i>';
            titleColorClass = 'text-blue-400';
            iconBgClass = 'bg-blue-500/10 border-blue-500/20 text-blue-400';
            barGradientClass = 'from-blue-500 via-cyan-400 to-indigo-500';
            subIconHtml = '<i class="fas fa-info-circle text-[10px]"></i>';
        } else {
            wrapperClass = 'bg-zinc-950/90 text-white toast-error-glow border-red-500/30';
            iconHtml = '<i class="fas fa-exclamation-triangle text-base animate-subtle-bounce"></i>';
            titleColorClass = 'text-red-400';
            iconBgClass = 'bg-red-500/10 border-red-500/20 text-red-400';
            barGradientClass = 'from-red-500 via-rose-500 to-amber-500';
            subIconHtml = '<i class="fas fa-shield-alt text-[10px]"></i>';
        }

        toast.className = 'toast-item pointer-events-auto relative overflow-hidden backdrop-blur-xl rounded-2xl border p-4 flex items-start gap-3.5 shadow-2xl ' + wrapperClass;
        toast.innerHTML =
            '<div class="flex-shrink-0 w-9 h-9 rounded-xl border flex items-center justify-center ' + iconBgClass + '">' + iconHtml + '</div>' +
            '<div class="flex-1 min-w-0 pt-0.5">' +
            '<h4 class="text-xs font-black uppercase tracking-wider ' + titleColorClass + ' mb-0.5 flex items-center gap-1.5">' + subIconHtml + ' ' + title + '</h4>' +
            '<p class="text-xs text-zinc-300 font-medium leading-relaxed">' + message + '</p>' +
            '</div>' +
            '<button onclick="dismissTargetToast(this.closest(\'.toast-item\'))" class="w-6 h-6 rounded-lg bg-white/5 hover:bg-white/10 text-zinc-400 hover:text-white flex items-center justify-center" type="button">' +
            '<i class="fas fa-times text-[10px]"></i></button>' +
            '<div class="absolute bottom-0 left-0 h-[3px] bg-gradient-to-r ' + barGradientClass + ' toast-progress-countdown"></div>';

        container.appendChild(toast);
        toast.dataset.timerId = setTimeout(() => dismissTargetToast(toast), 5000);
    }

    function dismissTargetToast(toast) {
        if (!toast || toast.classList.contains('toast-leave-active')) return;
        if (toast.dataset.timerId) clearTimeout(parseInt(toast.dataset.timerId, 10));
        toast.classList.add('toast-leave-active');
        setTimeout(() => toast.remove(), 450);
    }

    function clearErrors() {
        document.querySelectorAll('span[id^="error-"]').forEach(el => {
            el.classList.add('hidden');
            el.classList.remove('block');
            el.textContent = '';
        });
        document.querySelectorAll('.profile-field').forEach(el => {
            el.classList.remove('border-red-500/50', 'bg-red-500/5', 'shake-animation');
        });
    }

    function showError(inputEl, errorSpanId, message) {
        const span = document.getElementById(errorSpanId);
        if (!span || !inputEl) return;
        span.textContent = message;
        span.classList.remove('hidden');
        span.classList.add('block');
        inputEl.classList.add('border-red-500/50', 'bg-red-500/5', 'shake-animation');
        setTimeout(() => inputEl.classList.remove('shake-animation'), 400);
    }

    function validateFullName(showMsg) {
        const el = document.getElementById('fullName');
        const val = el.value.trim();
        if (val === '') {
            if (showMsg) showError(el, 'error-fullName', 'Họ tên không được để trống.');
            return false;
        }
        if (val.length > 100) {
            if (showMsg) showError(el, 'error-fullName', 'Họ và tên không được vượt quá 100 ký tự.');
            return false;
        }
        return true;
    }

    function validateEmail(showMsg) {
        const el = document.getElementById('email');
        const val = el.value.trim();
        if (!emailRegex.test(val)) {
            if (showMsg) showError(el, 'error-email', 'Vui lòng nhập đúng định dạng Email (VD: abc@domain.com).');
            return false;
        }
        return true;
    }

    function validatePhone(showMsg) {
        const el = document.getElementById('phone');
        const val = el.value.trim();
        if (!phoneRegex.test(val) && !phoneRegexServer.test(val)) {
            if (showMsg) showError(el, 'error-phone', 'Số điện thoại không hợp lệ. Phải là 10 số bắt đầu bằng 03, 05, 07, 08, 09 hoặc +84.');
            return false;
        }
        return true;
    }

    function validateAvatarUrl(showMsg) {
        const avatarInput = document.getElementById('avatar');
        const val = avatarInput.value.trim();
        if (val === '') return true;

        if (val.startsWith('http')) {
            try {
                const parsed = new URL(val);
                if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
                    throw new Error('invalid protocol');
                }
                return true;
            } catch (e) {
                if (showMsg) {
                    showError(avatarInput, 'error-avatar', 'URL ảnh đại diện không hợp lệ. Vui lòng nhập link bắt đầu bằng http:// hoặc https://');
                }
                return false;
            }
        }
        return true;
    }

    function validateAvatarFile(showMsg) {
        const fileInput = document.getElementById('avatarFile');
        const avatarInput = document.getElementById('avatar');
        if (!fileInput.files || !fileInput.files[0]) return true;

        const file = fileInput.files[0];
        if (file.size > MAX_AVATAR_SIZE) {
            if (showMsg) showError(avatarInput, 'error-avatar', 'Ảnh đại diện không được vượt quá 5MB.');
            return false;
        }
        if (!file.type.startsWith('image/')) {
            if (showMsg) showError(avatarInput, 'error-avatar', 'File tải lên phải là ảnh (JPEG, PNG, GIF, WEBP).');
            return false;
        }
        return true;
    }

    function validateProfileForm() {
        clearErrors();
        let isValid = true;
        if (!validateFullName(true)) isValid = false;
        if (!validateEmail(true)) isValid = false;
        if (!validatePhone(true)) isValid = false;
        if (!validateAvatarUrl(true)) isValid = false;
        if (!validateAvatarFile(true)) isValid = false;

        if (isValid) {
            openConfirmModal();
        } else {
            triggerPremiumToast('error', 'Thiếu Thông Tin', 'Vui lòng kiểm tra lại các trường dữ liệu bị đỏ.');
            const firstError = document.querySelector('.bg-red-500\\/5');
            if (firstError) firstError.focus();
        }
    }

    function openConfirmModal() {
        const modal = document.getElementById('customConfirmModal');
        const box = document.getElementById('confirmModalBox');
        modal.classList.remove('hidden');
        modal.classList.add('flex');
        setTimeout(() => {
            modal.classList.remove('opacity-0');
            box.classList.remove('scale-95');
            box.classList.add('scale-100');
        }, 10);
    }

    function closeConfirmModal() {
        const modal = document.getElementById('customConfirmModal');
        const box = document.getElementById('confirmModalBox');
        modal.classList.add('opacity-0');
        box.classList.remove('scale-100');
        box.classList.add('scale-95');
        setTimeout(() => {
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }, 300);
    }

    function submitProfileForm() {
        const confirmBtn = document.getElementById('btn-confirm-submit');
        const confirmIcon = document.getElementById('btn-confirm-icon');
        const confirmText = document.getElementById('btn-confirm-text');
        confirmBtn.disabled = true;
        confirmIcon.className = 'fas fa-spinner fa-spin mr-1';
        confirmText.innerText = 'Đang xử lý...';
        triggerPremiumToast('info', 'Đang xử lý', 'Hệ thống đang cập nhật hồ sơ của bạn...');
        setTimeout(() => document.getElementById('customerProfileForm').submit(), 400);
    }

    function handleFileSelect(input) {
        if (input.files && input.files[0]) {
            if (!validateAvatarFile(true)) {
                input.value = '';
                return;
            }

            const fileName = input.files[0].name;
            document.getElementById('avatar').value = fileName;

            const container = document.getElementById('avatar-preview-container');
            const img = document.getElementById('avatar-preview-img');
            const profileImg = document.getElementById('profile-avatar-preview');
            const icon = document.getElementById('avatar-error-icon');

            container.classList.remove('hidden');
            container.classList.add('flex');

            const previewUrl = URL.createObjectURL(input.files[0]);
            img.src = previewUrl;
            profileImg.src = previewUrl;
            img.classList.remove('hidden');
            if (icon) icon.classList.add('hidden');
        }
    }

    function previewAvatar() {
        const avatarUrl = document.getElementById('avatar').value.trim();
        const fullName = document.getElementById('fullName').value.trim() || 'User';
        const img = document.getElementById('avatar-preview-img');
        const profileImg = document.getElementById('profile-avatar-preview');
        const icon = document.getElementById('avatar-error-icon');
        const fileInput = document.getElementById('avatarFile');

        img.classList.remove('hidden');
        if (icon) icon.classList.add('hidden');

        if (avatarUrl !== '') {
            if (avatarUrl.startsWith('http')) {
                if (fileInput) fileInput.value = '';
                img.src = avatarUrl;
                profileImg.src = avatarUrl;
            } else if (!avatarUrl.startsWith('/assets/')) {
                const localSrc = contextPath + '/assets/images/avatar/' + avatarUrl;
                img.src = localSrc;
                profileImg.src = localSrc;
            }
        } else {
            const fallback = 'https://ui-avatars.com/api/?name=' + encodeURIComponent(fullName) + '&background=random';
            img.src = fallback;
            profileImg.src = fallback;
        }
    }

    function applyServerFieldErrors() {
        const mappings = [
            ['server-error-fullName', 'fullName', 'error-fullName'],
            ['server-error-email', 'email', 'error-email'],
            ['server-error-phone', 'phone', 'error-phone'],
            ['server-error-avatar', 'avatar', 'error-avatar']
        ];
        mappings.forEach(([bridgeId, inputId, errorId]) => {
            const bridge = document.getElementById(bridgeId);
            if (bridge && bridge.value.trim() !== '') {
                showError(document.getElementById(inputId), errorId, bridge.value.trim());
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        setTimeout(() => {
            const errorBridge = document.getElementById('backend-error-bridge');
            const successBridge = document.getElementById('backend-success-bridge');
            if (errorBridge && errorBridge.value.trim() !== '') {
                triggerPremiumToast('error', 'Lỗi Từ Hệ Thống', errorBridge.value.trim());
            }
            if (successBridge && successBridge.value.trim() !== '') {
                triggerPremiumToast('success', 'Thành Công', successBridge.value.trim());
            }
            applyServerFieldErrors();
        }, 100);

        document.getElementById('avatar')?.addEventListener('input', function () {
            validateAvatarUrl(false);
            previewAvatar();
        });

        document.getElementById('fullName')?.addEventListener('input', function () {
            validateFullName(false);
            const avatarUrl = document.getElementById('avatar').value.trim();
            if (avatarUrl === '') previewAvatar();
        });
        document.getElementById('avatar')?.addEventListener('blur', function () { validateAvatarUrl(true); });

        document.getElementById('fullName')?.addEventListener('blur', function () { validateFullName(true); });

        document.getElementById('email')?.addEventListener('input', function () { validateEmail(false); });
        document.getElementById('email')?.addEventListener('blur', function () { validateEmail(true); });

        document.getElementById('phone')?.addEventListener('input', function () { validatePhone(false); });
        document.getElementById('phone')?.addEventListener('blur', function () { validatePhone(true); });
    });
</script>
