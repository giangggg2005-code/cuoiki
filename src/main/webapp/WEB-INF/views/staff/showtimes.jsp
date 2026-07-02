<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-4">
    <div>
        <h2 class="text-xl font-black text-white uppercase tracking-wider">Lịch Chiếu</h2>
        <p class="text-xs text-gray-500">Xem lịch chiếu và đặt vé tại quầy</p>
    </div>
    <form method="GET" action="${pageContext.request.contextPath}/staff/showtimes" class="flex items-center gap-2">
        <input type="date" name="date" value="${selectedDate}"
               class="bg-[#0b0c10] border border-gray-800 text-white text-xs rounded-lg px-3 py-2 focus:outline-none focus:border-blue-600">
        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-xs font-bold transition">Xem</button>
    </form>
</div>

<c:if test="${not empty successMessage}">
    <div class="bg-green-500/10 border border-green-500 text-green-500 px-4 py-3 rounded-xl mb-4 text-sm font-bold">${successMessage}</div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="bg-red-500/10 border border-red-500 text-red-500 px-4 py-3 rounded-xl mb-4 text-sm font-bold">${errorMessage}</div>
</c:if>

<c:if test="${not empty movieListForDate}">
    <div class="glass-card border border-gray-800 rounded-2xl overflow-hidden mb-6">
        <div class="p-4 border-b border-gray-800 bg-[#161616]">
            <h3 class="text-sm font-bold text-white uppercase">
                <i class="fas fa-film text-blue-500 mr-2"></i> Chọn phim để đặt vé — ${selectedDate}
            </h3>
        </div>
        <div class="p-4 grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
            <c:forEach var="m" items="${movieListForDate}">
                <button type="button"
                        class="staff-pick-movie group text-left bg-[#0e0f14] border border-gray-800 rounded-xl overflow-hidden hover:border-blue-500 transition-all"
                        data-movie-id="${m.movieId}"
                        data-title="${fn:escapeXml(m.movieTitle)}"
                        data-poster="${fn:escapeXml(m.posterUrl)}"
                        data-price="${m.basePrice}">
                    <div class="aspect-[2/3] bg-gray-900 overflow-hidden">
                        <c:choose>
                            <c:when test="${not empty m.posterUrl}">
                                <img src="${m.posterUrl}" alt="${m.movieTitle}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-full flex items-center justify-center text-gray-600"><i class="fas fa-film text-3xl"></i></div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="p-3">
                        <p class="text-white text-xs font-bold line-clamp-2 leading-snug">${m.movieTitle}</p>
                        <p class="text-blue-400 text-[10px] font-bold mt-1">
                            <fmt:formatNumber value="${m.basePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </p>
                        <span class="inline-block mt-2 text-[10px] font-black uppercase text-blue-500 tracking-wider">Đặt vé <i class="fas fa-arrow-right ml-1"></i></span>
                    </div>
                </button>
            </c:forEach>
        </div>
    </div>
</c:if>

<div class="glass-card border border-gray-800 rounded-2xl overflow-hidden">
    <div class="p-4 border-b border-gray-800 bg-[#161616]">
        <h3 class="text-sm font-bold text-white uppercase"><i class="fas fa-calendar-day text-blue-500 mr-2"></i> Lịch ngày ${selectedDate}</h3>
    </div>
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm">
            <thead class="text-xs text-gray-400 uppercase bg-[#0e0f14] border-b border-gray-800">
                <tr>
                    <th class="p-4">Phim</th>
                    <th class="p-4">Phòng</th>
                    <th class="p-4 text-center">Giờ chiếu</th>
                    <th class="p-4 text-center">Ghế đã bán</th>
                    <th class="p-4 text-center">Trạng thái</th>
                    <th class="p-4 text-center">Thao tác</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-800/50">
                <c:forEach var="st" items="${showtimeList}">
                    <tr class="hover:bg-white/[0.02] transition">
                        <td class="p-4 text-white font-semibold">${st.movieTitle}</td>
                        <td class="p-4 text-gray-400">${st.roomName}</td>
                        <td class="p-4 text-center font-mono text-blue-400 font-bold">${st.startTime}</td>
                        <td class="p-4 text-center">
                            <span class="text-white font-bold">${st.bookedSeats}</span>
                            <span class="text-gray-500">/ ${st.totalSeats}</span>
                        </td>
                        <td class="p-4 text-center">
                            <span class="px-2 py-1 ${st.status == 'Active' ? 'bg-green-500/10 text-green-500' : 'bg-gray-500/10 text-gray-400'} rounded-lg text-[10px] font-bold">${st.status}</span>
                        </td>
                        <td class="p-4 text-center">
                            <c:if test="${st.status == 'Active'}">
                                <button type="button"
                                        class="staff-book-showtime bg-blue-600 hover:bg-blue-700 text-white px-3 py-1.5 rounded-lg text-[10px] font-bold uppercase transition"
                                        data-showtime-id="${st.showtimeId}"
                                        data-movie-id="${st.movieId}"
                                        data-title="${fn:escapeXml(st.movieTitle)}"
                                        data-poster="${fn:escapeXml(st.posterUrl)}"
                                        data-price="${st.basePrice}"
                                        data-time="${st.startTime}">
                                    <i class="fas fa-ticket-alt mr-1"></i> Đặt vé
                                </button>
                            </c:if>
                            <c:if test="${st.status != 'Active'}">
                                <span class="text-gray-600 text-[10px]">—</span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty showtimeList}">
                    <tr><td colspan="6" class="p-8 text-center text-gray-500">Không có suất chiếu trong ngày này</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="staff_booking_modal.jsp" />

<script>
(function () {
    document.querySelectorAll('.staff-pick-movie').forEach(function (btn) {
        btn.addEventListener('click', function () {
            openStaffBooking(
                parseInt(btn.dataset.movieId, 10),
                btn.dataset.title,
                btn.dataset.poster,
                parseFloat(btn.dataset.price) || 85000
            );
        });
    });

    document.querySelectorAll('.staff-book-showtime').forEach(function (btn) {
        btn.addEventListener('click', function () {
            openStaffBookingForShowtime(
                parseInt(btn.dataset.showtimeId, 10),
                parseInt(btn.dataset.movieId, 10),
                btn.dataset.title,
                btn.dataset.poster,
                parseFloat(btn.dataset.price) || 85000,
                btn.dataset.time,
                '${selectedDate}'
            );
        });
    });
})();
</script>
