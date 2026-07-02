<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script>
    window.staffMovieChartLabels = [
        <c:forEach var="item" items="${ticketSalesByMovie}" varStatus="s">
            '${fn:replace(item.movieName, "'", "\\'")}'${not s.last ? ',' : ''}
        </c:forEach>
    ];
    window.staffMovieChartData = [
        <c:forEach var="item" items="${ticketSalesByMovie}" varStatus="s">
            ${item.tickets}${not s.last ? ',' : ''}
        </c:forEach>
    ];
</script>

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
    <div>
        <h2 class="text-xl font-black text-white uppercase tracking-wider">Tổng Quan Hôm Nay</h2>
        <p class="text-xs text-gray-500">Giám sát hoạt động bán vé và lịch chiếu theo thời gian thực</p>
    </div>
</div>

<c:if test="${not empty errorMessage}">
    <div class="bg-red-900/30 border border-red-500/40 rounded-xl p-4 mb-6 text-xs text-red-400 flex items-center">
        <i class="fas fa-exclamation-triangle text-base mr-3"></i> ${errorMessage}
    </div>
</c:if>

<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
    <div class="glass-card border border-gray-800 p-5 rounded-2xl flex items-center justify-between hover-glow">
        <div>
            <p class="text-[11px] font-semibold text-gray-500 uppercase tracking-wider">Vé đã bán hôm nay</p>
            <h3 class="text-xl font-bold text-white mt-1">
                <fmt:formatNumber value="${not empty summary.todayTickets ? summary.todayTickets : 0}" pattern="#,###"/> Vé
            </h3>
        </div>
        <div class="w-12 h-12 rounded-xl bg-red-500/10 text-red-500 flex items-center justify-center text-xl"><i class="fas fa-ticket-alt"></i></div>
    </div>
    <div class="glass-card border border-gray-800 p-5 rounded-2xl flex items-center justify-between hover-glow">
        <div>
            <p class="text-[11px] font-semibold text-gray-500 uppercase tracking-wider">Doanh thu hôm nay</p>
            <h3 class="text-xl font-bold text-white mt-1">
                <fmt:formatNumber value="${not empty summary.todayRevenue ? summary.todayRevenue : 0}" pattern="#,###"/> ₫
            </h3>
        </div>
        <div class="w-12 h-12 rounded-xl bg-green-500/10 text-green-500 flex items-center justify-center text-xl"><i class="fas fa-wallet"></i></div>
    </div>
    <div class="glass-card border border-gray-800 p-5 rounded-2xl flex items-center justify-between hover-glow">
        <div>
            <p class="text-[11px] font-semibold text-gray-500 uppercase tracking-wider">Tổng khách hàng</p>
            <h3 class="text-xl font-bold text-white mt-1">
                <fmt:formatNumber value="${not empty summary.totalCustomers ? summary.totalCustomers : 0}" pattern="#,###"/>
            </h3>
        </div>
        <div class="w-12 h-12 rounded-xl bg-blue-500/10 text-blue-500 flex items-center justify-center text-xl"><i class="fas fa-users"></i></div>
    </div>
    <div class="glass-card border border-gray-800 p-5 rounded-2xl flex items-center justify-between hover-glow">
        <div>
            <p class="text-[11px] font-semibold text-gray-500 uppercase tracking-wider">Suất chiếu hôm nay</p>
            <h3 class="text-xl font-bold text-white mt-1">${not empty summary.todayShowtimeCount ? summary.todayShowtimeCount : 0} Suất</h3>
        </div>
        <div class="w-12 h-12 rounded-xl bg-amber-500/10 text-amber-500 flex items-center justify-center text-xl"><i class="fas fa-clock"></i></div>
    </div>
</div>

<div class="grid grid-cols-1 xl:grid-cols-2 gap-6 mb-6">
    <div class="glass-card border border-gray-800 rounded-2xl p-5 hover-glow">
        <h3 class="text-xs font-bold text-white mb-4 uppercase tracking-wider"><i class="fas fa-chart-pie text-blue-500 mr-2"></i> Tỷ lệ vé bán theo phim (hôm nay)</h3>
        <div class="h-64 relative w-full">
            <canvas id="staffMovieChart"></canvas>
        </div>
        <c:if test="${empty ticketSalesByMovie}">
            <p class="text-center text-gray-500 text-xs mt-2">Chưa có dữ liệu bán vé hôm nay</p>
        </c:if>
    </div>

    <div class="glass-card border border-gray-800 rounded-2xl p-5 hover-glow">
        <h3 class="text-xs font-bold text-white mb-4 uppercase tracking-wider"><i class="fas fa-sun text-amber-500 mr-2"></i> Doanh thu theo ca (hôm nay)</h3>
        <div class="space-y-3">
            <c:choose>
                <c:when test="${not empty revenueByShift}">
                    <c:forEach var="shift" items="${revenueByShift}">
                        <div class="p-3 bg-[#141414] rounded-xl border border-gray-800/50 flex items-center justify-between">
                            <div>
                                <p class="text-white font-bold text-sm">${shift.shift}</p>
                                <p class="text-gray-500 text-[10px]">${shift.bookings} đơn hàng</p>
                            </div>
                            <span class="text-green-500 font-bold font-mono text-sm"><fmt:formatNumber value="${shift.revenue}" pattern="#,###"/> ₫</span>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-500 text-xs text-center py-8">Chưa có doanh thu hôm nay</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
    <div class="glass-card border border-gray-800 rounded-2xl p-5 hover-glow">
        <h4 class="text-xs font-bold text-gray-400 mb-3 uppercase tracking-wider flex items-center justify-between">
            <span><i class="far fa-clock text-blue-500 mr-2"></i> Lịch chiếu hôm nay</span>
            <span class="text-[9px] bg-blue-500/10 text-blue-500 px-1.5 py-0.5 rounded font-bold animate-pulse">LIVE</span>
        </h4>
        <div class="space-y-2 max-h-80 overflow-y-auto pr-1 custom-scrollbar">
            <c:choose>
                <c:when test="${not empty todayShowtimes}">
                    <c:forEach var="st" items="${todayShowtimes}">
                        <div class="p-2.5 bg-[#141414] rounded-xl border border-gray-800/50 text-[11px] flex items-center justify-between">
                            <div class="truncate mr-2">
                                <p class="text-white font-bold truncate">${st.movieTitle}</p>
                                <p class="text-gray-400 text-[10px]"><i class="fas fa-door-open mr-1"></i>${st.roomName}</p>
                            </div>
                            <div class="text-right flex-shrink-0">
                                <span class="px-1.5 py-0.5 bg-blue-500/10 text-blue-500 rounded font-mono font-bold">${st.startTime}</span>
                                <p class="text-[9px] text-gray-500 mt-0.5">${st.bookedSeats}/${st.totalSeats} Ghế</p>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-500 text-xs text-center py-6">Chưa có lịch chiếu hôm nay</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="glass-card border border-gray-800 rounded-2xl p-5 hover-glow">
        <h4 class="text-xs font-bold text-gray-400 mb-3 uppercase tracking-wider"><i class="fas fa-receipt text-green-500 mr-2"></i> Đơn đặt vé gần đây (hôm nay)</h4>
        <div class="space-y-2 max-h-80 overflow-y-auto pr-1 custom-scrollbar">
            <c:choose>
                <c:when test="${not empty recentBookings}">
                    <c:forEach var="bk" items="${recentBookings}">
                        <div class="p-2.5 bg-[#141414] rounded-xl border border-gray-800/50 text-[11px] flex items-center justify-between">
                            <div class="truncate mr-2">
                                <p class="text-white font-bold truncate">#${bk.bookingId} - ${bk.customerName}</p>
                                <p class="text-gray-500 text-[10px] truncate">${bk.movieTitle} • ${bk.ticketCount} vé</p>
                                <p class="text-gray-400 text-[10px]"><fmt:formatDate value="${bk.bookingDate}" pattern="HH:mm:ss dd/MM/yyyy"/></p>
                            </div>
                            <div class="text-right flex-shrink-0">
                                <span class="text-green-500 font-bold font-mono"><fmt:formatNumber value="${bk.amount}" pattern="#,###"/> ₫</span>
                                <p class="text-[9px] mt-0.5 ${bk.status == 'Completed' ? 'text-green-500' : 'text-amber-500'}">${bk.status}</p>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-500 text-xs text-center py-6">Chưa có đơn đặt vé hôm nay</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const canvas = document.getElementById('staffMovieChart');
    if (!canvas || !window.staffMovieChartLabels || window.staffMovieChartLabels.length === 0) return;
    new Chart(canvas.getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: window.staffMovieChartLabels,
            datasets: [{
                data: window.staffMovieChartData,
                backgroundColor: ['#3b82f6','#ef4444','#22c55e','#f59e0b','#8b5cf6','#06b6d4','#ec4899','#84cc16','#f97316','#6366f1'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom', labels: { color: '#9ca3af', font: { size: 10 } } } }
        }
    });
});
</script>
