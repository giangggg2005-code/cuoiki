<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="mb-6">
    <h2 class="text-xl font-black text-white uppercase tracking-wider">Soát Vé</h2>
    <p class="text-xs text-gray-500">Kiểm tra tính hợp lệ của vé trước khi cho khách vào rạp</p>
</div>

<c:if test="${not empty errorMessage}">
    <div class="bg-red-500/10 border border-red-500 text-red-500 px-4 py-3 rounded-xl mb-4 text-sm font-bold">
        <i class="fas fa-exclamation-triangle mr-2"></i> ${errorMessage}
    </div>
</c:if>

<div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
    <div class="glass-card border border-gray-800 rounded-2xl p-6">
        <h3 class="text-sm font-bold text-white mb-4 uppercase"><i class="fas fa-ticket-alt text-blue-500 mr-2"></i> Soát theo mã vé</h3>
        <form action="${pageContext.request.contextPath}/staff/check-ticket" method="POST" class="space-y-4">
            <input type="number" name="ticketId" min="1" placeholder="Nhập mã vé (VD: 123)"
                   class="w-full bg-[#0b0c10] border border-gray-800 text-white rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-blue-500">
            <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-xl transition">
                <i class="fas fa-search mr-2"></i> Kiểm tra vé
            </button>
        </form>
    </div>
    <div class="glass-card border border-gray-800 rounded-2xl p-6">
        <h3 class="text-sm font-bold text-white mb-4 uppercase"><i class="fas fa-receipt text-green-500 mr-2"></i> Soát theo mã đơn đặt</h3>
        <form action="${pageContext.request.contextPath}/staff/check-ticket" method="POST" class="space-y-4">
            <input type="number" name="bookingId" min="1" placeholder="Nhập mã đơn đặt (VD: 45)"
                   class="w-full bg-[#0b0c10] border border-gray-800 text-white rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-blue-500">
            <button type="submit" class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 rounded-xl transition">
                <i class="fas fa-list mr-2"></i> Kiểm tra đơn
            </button>
        </form>
    </div>
</div>

<c:if test="${not empty checkResult}">
    <div class="glass-card border ${checkResult.valid ? 'border-green-500/40' : 'border-red-500/40'} rounded-2xl p-6 mb-6">
        <div class="flex items-center gap-3 mb-4">
            <i class="fas ${checkResult.valid ? 'fa-check-circle text-green-500' : 'fa-times-circle text-red-500'} text-2xl"></i>
            <p class="text-white font-bold text-lg">${checkResult.message}</p>
        </div>
        <c:if test="${not empty checkResult.ticket}">
            <c:set var="t" value="${checkResult.ticket}" />
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                <div><p class="text-gray-500 text-xs">Mã vé</p><p class="text-white font-bold">#${t.id_Ticket}</p></div>
                <div><p class="text-gray-500 text-xs">Phim</p><p class="text-white font-bold">${t.showtime.movie.title}</p></div>
                <div><p class="text-gray-500 text-xs">Ghế</p><p class="text-white font-bold">${t.seat.seatName}</p></div>
                <div><p class="text-gray-500 text-xs">Suất chiếu</p><p class="text-white font-bold"><fmt:formatDate value="${t.showtime.showDate}" pattern="dd/MM/yyyy"/> <fmt:formatDate value="${t.showtime.startTime}" pattern="HH:mm"/></p></div>
            </div>
        </c:if>
        <c:if test="${not empty exportTicketId}">
            <div class="mt-5 pt-4 border-t border-gray-800">
                <a href="${pageContext.request.contextPath}/staff/check-ticket/export-pdf?ticketId=${exportTicketId}"
                   class="inline-flex items-center gap-2 bg-red-600 hover:bg-red-700 text-white font-bold px-5 py-2.5 rounded-xl text-sm transition">
                    <i class="fas fa-file-pdf"></i> Xuất hóa đơn PDF
                </a>
            </div>
        </c:if>
    </div>
</c:if>

<c:if test="${not empty bookingResults}">
    <div class="space-y-4">
        <div class="flex flex-wrap items-center justify-between gap-3">
            <h3 class="text-sm font-bold text-white uppercase">Kết quả soát đơn đặt vé</h3>
            <c:if test="${not empty exportBookingId}">
                <a href="${pageContext.request.contextPath}/staff/check-ticket/export-pdf?bookingId=${exportBookingId}"
                   class="inline-flex items-center gap-2 bg-red-600 hover:bg-red-700 text-white font-bold px-5 py-2.5 rounded-xl text-sm transition">
                    <i class="fas fa-file-pdf"></i> Xuất hóa đơn PDF
                </a>
            </c:if>
        </div>
        <c:forEach var="result" items="${bookingResults}">
            <div class="glass-card border ${result.valid ? 'border-green-500/30' : 'border-red-500/30'} rounded-2xl p-4">
                <c:set var="t" value="${result.ticket}" />
                <div class="flex items-center justify-between mb-2">
                    <span class="text-white font-bold">Vé #${t.id_Ticket} - Ghế ${t.seat.seatName}</span>
                    <span class="text-xs font-bold ${result.valid ? 'text-green-500' : 'text-red-500'}">${result.message}</span>
                </div>
                <p class="text-gray-400 text-xs">${t.showtime.movie.title} | <fmt:formatDate value="${t.showtime.showDate}" pattern="dd/MM/yyyy"/> <fmt:formatDate value="${t.showtime.startTime}" pattern="HH:mm"/></p>
            </div>
        </c:forEach>
    </div>
</c:if>
