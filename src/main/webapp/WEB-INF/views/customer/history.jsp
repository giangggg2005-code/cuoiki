<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="max-w-5xl mx-auto">
    <h1 class="text-3xl font-black text-white mb-8 uppercase tracking-tight">Lịch sử đặt vé</h1>

    <c:choose>
        <c:when test="${empty bookingList}">
            <div class="bg-[#121212] border border-gray-800 rounded-2xl p-16 text-center">
                <i class="fas fa-ticket text-5xl text-gray-700 mb-4"></i>
                <p class="text-gray-500">Bạn chưa có lịch sử đặt vé nào.</p>
                <a href="${pageContext.request.contextPath}/customer/movies" class="inline-block mt-6 bg-red-600 hover:bg-red-700 text-white font-bold px-6 py-3 rounded-xl text-sm uppercase tracking-widest transition-all">
                    Đặt vé ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="space-y-4">
                <c:forEach var="booking" items="${bookingList}">
                    <div class="bg-[#121212] border border-gray-800 rounded-2xl p-6 flex flex-col md:flex-row md:items-center justify-between gap-4 hover:border-gray-700 transition-all">
                        <div>
                            <h3 class="text-lg font-bold text-white mb-2">Đơn đặt vé #${booking.id_Booking}</h3>
                            <div class="flex flex-wrap gap-4 text-sm text-gray-400">
                                <span><i class="fas fa-calendar mr-1"></i>
                                    <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" />
                                </span>
                                <span><i class="fas fa-credit-card mr-1"></i>
                                    <c:out value="${booking.paymentMethod}" />
                                </span>
                                <c:if test="${booking.paymentId != null}">
                                    <span><i class="fas fa-receipt mr-1"></i> Thẻ #${booking.paymentId}</span>
                                </c:if>
                            </div>
                        </div>
                        <div class="flex flex-col items-end gap-3">
                            <span class="inline-block px-3 py-1 rounded-full text-xs font-bold uppercase
                                ${booking.status == 'Completed' ? 'bg-green-900/40 text-green-400' : 'bg-yellow-900/40 text-yellow-400'}">
                                <c:out value="${booking.status}" />
                            </span>
                            <p class="text-2xl font-black text-red-500">
                                <fmt:formatNumber value="${booking.totalAmount}" type="number" maxFractionDigits="0" />đ
                            </p>
                            <button type="button"
                                    class="btn-view-booking-detail bg-gray-800 hover:bg-gray-700 text-white text-xs font-bold uppercase tracking-wider px-4 py-2 rounded-lg transition-all"
                                    data-booking-id="${booking.id_Booking}">
                                <i class="fas fa-eye mr-1"></i> Xem chi tiết
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div id="booking-detail-modal" class="fixed inset-0 z-[200] hidden items-center justify-center p-4 bg-black/80 backdrop-blur-sm">
    <div class="bg-[#121212] border border-gray-800 rounded-2xl w-full max-w-3xl max-h-[90vh] overflow-hidden flex flex-col shadow-2xl">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-800">
            <h2 class="text-lg font-black text-white uppercase tracking-wide" id="detail-modal-title">Chi tiết đơn đặt vé</h2>
            <button type="button" id="btn-close-booking-detail" class="text-gray-400 hover:text-white transition-colors">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>
        <div id="booking-detail-loading" class="hidden p-12 text-center">
            <i class="fas fa-spinner fa-spin text-3xl text-red-500 mb-4"></i>
            <p class="text-gray-400 text-sm">Đang tải thông tin vé...</p>
        </div>
        <div id="booking-detail-error" class="hidden p-8 text-center">
            <i class="fas fa-exclamation-circle text-3xl text-red-500 mb-3"></i>
            <p class="text-red-400 text-sm font-bold" id="booking-detail-error-msg"></p>
        </div>
        <div id="booking-detail-content" class="hidden overflow-y-auto p-6 space-y-6">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                <div>
                    <p class="text-gray-500 text-xs uppercase mb-1">Mã đơn</p>
                    <p class="text-white font-bold" id="detail-booking-id">-</p>
                </div>
                <div>
                    <p class="text-gray-500 text-xs uppercase mb-1">Ngày đặt</p>
                    <p class="text-white font-bold" id="detail-booking-date">-</p>
                </div>
                <div>
                    <p class="text-gray-500 text-xs uppercase mb-1">Thanh toán</p>
                    <p class="text-white font-bold" id="detail-payment-method">-</p>
                </div>
                <div>
                    <p class="text-gray-500 text-xs uppercase mb-1">Trạng thái</p>
                    <p class="font-bold" id="detail-booking-status">-</p>
                </div>
            </div>
            <div id="detail-payment-extra" class="hidden bg-[#0b0c10] border border-gray-800 rounded-xl p-4 text-sm">
                <p class="text-gray-500 text-xs uppercase mb-1">Thông tin thẻ</p>
                <p class="text-white font-mono" id="detail-card-masked">-</p>
            </div>
            <div>
                <h3 class="text-sm font-bold text-white uppercase mb-3">
                    <i class="fas fa-ticket-alt text-red-500 mr-2"></i>
                    Danh sách vé (<span id="detail-ticket-count">0</span>)
                </h3>
                <div id="detail-tickets-list" class="space-y-3"></div>
            </div>
            <div class="flex items-center justify-between pt-4 border-t border-gray-800">
                <span class="text-gray-400 text-sm uppercase font-bold">Tổng thanh toán</span>
                <span class="text-2xl font-black text-red-500" id="detail-total-amount">0đ</span>
            </div>
        </div>
    </div>
</div>

<script>
(function () {
    const ctx = '${pageContext.request.contextPath}';
    const modal = document.getElementById('booking-detail-modal');
    const loadingEl = document.getElementById('booking-detail-loading');
    const errorEl = document.getElementById('booking-detail-error');
    const contentEl = document.getElementById('booking-detail-content');
    const errorMsgEl = document.getElementById('booking-detail-error-msg');

    function formatMoney(amount) {
        return new Intl.NumberFormat('vi-VN').format(Math.round(amount || 0)) + 'đ';
    }

    function statusClass(status) {
        if (status === 'Completed' || status === 'Sold') {
            return 'text-green-400';
        }
        if (status === 'Pending' || status === 'Available') {
            return 'text-yellow-400';
        }
        return 'text-gray-400';
    }

    function showModalState(state) {
        loadingEl.classList.toggle('hidden', state !== 'loading');
        errorEl.classList.toggle('hidden', state !== 'error');
        contentEl.classList.toggle('hidden', state !== 'content');
    }

    function openModal() {
        modal.classList.remove('hidden');
        modal.classList.add('flex');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        modal.classList.add('hidden');
        modal.classList.remove('flex');
        document.body.style.overflow = '';
    }

    function renderTicketCard(ticket) {
        const poster = ticket.posterUrl
            ? '<img src="' + ticket.posterUrl + '" alt="" class="w-16 h-24 object-cover rounded-lg border border-gray-800">'
            : '<div class="w-16 h-24 bg-gray-800 rounded-lg flex items-center justify-center"><i class="fas fa-film text-gray-600"></i></div>';

        return '<div class="bg-[#0b0c10] border border-gray-800 rounded-xl p-4">' +
            '<div class="flex gap-4">' +
                poster +
                '<div class="flex-1 min-w-0">' +
                    '<div class="flex flex-wrap items-start justify-between gap-2 mb-2">' +
                        '<p class="text-white font-bold text-base truncate">' + (ticket.movieTitle || '—') + '</p>' +
                        '<span class="text-xs font-bold uppercase ' + statusClass(ticket.status) + '">' + (ticket.status || '') + '</span>' +
                    '</div>' +
                    '<div class="grid grid-cols-2 gap-x-4 gap-y-1 text-xs text-gray-400">' +
                        '<span><i class="fas fa-ticket mr-1 text-red-500"></i> Vé #' + ticket.ticketId + '</span>' +
                        '<span><i class="fas fa-chair mr-1 text-red-500"></i> Ghế ' + (ticket.seatName || '—') + '</span>' +
                        '<span><i class="fas fa-calendar mr-1"></i> ' + (ticket.showDate || '—') + ' ' + (ticket.startTime || '') + '</span>' +
                        '<span><i class="fas fa-door-open mr-1"></i> ' + (ticket.roomName || '—') + (ticket.roomType ? ' (' + ticket.roomType + ')' : '') + '</span>' +
                        '<span><i class="fas fa-tag mr-1"></i> ' + (ticket.movieGenre || '—') + '</span>' +
                        '<span><i class="fas fa-clock mr-1"></i> ' + (ticket.movieDuration || '—') + ' phút</span>' +
                        '<span><i class="fas fa-language mr-1"></i> ' + (ticket.movieLanguage || '—') + '</span>' +
                        '<span class="text-red-400 font-bold">' + formatMoney(ticket.price) + '</span>' +
                    '</div>' +
                '</div>' +
            '</div>' +
        '</div>';
    }

    function renderDetail(data) {
        const booking = data.booking || {};
        document.getElementById('detail-modal-title').textContent = 'Chi tiết đơn #' + booking.id;
        document.getElementById('detail-booking-id').textContent = '#' + booking.id;
        document.getElementById('detail-booking-date').textContent = booking.bookingDate || '—';
        document.getElementById('detail-payment-method').textContent = booking.paymentMethod || '—';

        const statusEl = document.getElementById('detail-booking-status');
        statusEl.textContent = booking.status || '—';
        statusEl.className = 'font-bold uppercase text-xs ' + statusClass(booking.status);

        const paymentExtra = document.getElementById('detail-payment-extra');
        if (booking.cardMasked) {
            paymentExtra.classList.remove('hidden');
            document.getElementById('detail-card-masked').textContent = booking.cardMasked;
        } else {
            paymentExtra.classList.add('hidden');
        }

        document.getElementById('detail-ticket-count').textContent = data.ticketCount || 0;
        document.getElementById('detail-total-amount').textContent = formatMoney(booking.totalAmount);

        const ticketsList = document.getElementById('detail-tickets-list');
        const tickets = data.tickets || [];
        ticketsList.innerHTML = tickets.length
            ? tickets.map(renderTicketCard).join('')
            : '<p class="text-gray-500 text-sm text-center py-4">Không có vé trong đơn này.</p>';

        showModalState('content');
    }

    async function loadBookingDetail(bookingId) {
        openModal();
        showModalState('loading');

        try {
            const res = await fetch(ctx + '/customer/api/booking-detail?bookingId=' + encodeURIComponent(bookingId));
            const data = await res.json();
            if (data.error) {
                errorMsgEl.textContent = data.error;
                showModalState('error');
                return;
            }
            renderDetail(data);
        } catch (err) {
            errorMsgEl.textContent = 'Không thể tải chi tiết đơn đặt vé. Vui lòng thử lại.';
            showModalState('error');
        }
    }

    document.querySelectorAll('.btn-view-booking-detail').forEach(function (btn) {
        btn.addEventListener('click', function () {
            loadBookingDetail(this.getAttribute('data-booking-id'));
        });
    });

    document.getElementById('btn-close-booking-detail').addEventListener('click', closeModal);
    modal.addEventListener('click', function (e) {
        if (e.target === modal) {
            closeModal();
        }
    });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && !modal.classList.contains('hidden')) {
            closeModal();
        }
    });
})();
</script>
