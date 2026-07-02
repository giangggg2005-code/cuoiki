<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-4">
    <div>
        <h2 class="text-xl font-black text-white uppercase tracking-wider">Quản Lý Vé</h2>
        <p class="text-xs text-gray-500">Tra cứu và theo dõi trạng thái vé trên hệ thống</p>
    </div>
    <a href="${pageContext.request.contextPath}/staff/check-ticket" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-xl text-sm font-bold transition flex items-center">
        <i class="fas fa-qrcode mr-2"></i> Soát vé
    </a>
</div>

<c:if test="${not empty errorMessage}">
    <div class="bg-red-500/10 border border-red-500 text-red-500 px-4 py-3 rounded-xl mb-4 text-sm font-bold">
        <i class="fas fa-exclamation-triangle mr-2"></i> ${errorMessage}
    </div>
</c:if>

<div class="glass-card border border-gray-800 rounded-2xl overflow-hidden mb-6">
    <div class="p-4 border-b border-gray-800 bg-[#161616]">
        <form action="${pageContext.request.contextPath}/staff/tickets" method="GET" class="flex flex-col md:flex-row gap-3">
            <div class="relative flex-1">
                <input type="text" name="keyword" value="${currentKeyword}" placeholder="Tìm theo mã vé, tên phim, ghế..."
                       class="bg-[#0b0c10] border border-gray-800 text-gray-300 text-xs rounded-lg px-4 py-2 w-full pr-10 focus:outline-none focus:border-blue-600">
                <button type="submit" class="absolute right-3 top-2 text-gray-500 hover:text-white"><i class="fas fa-search"></i></button>
            </div>
            <select name="status" onchange="this.form.submit()"
                    class="bg-[#0b0c10] border border-gray-800 text-gray-300 text-xs rounded-lg px-4 py-2 focus:outline-none focus:border-blue-600">
                <option value="all" ${currentStatus == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                <option value="Sold" ${currentStatus == 'Sold' ? 'selected' : ''}>Đã bán (Sold)</option>
                <option value="Booked" ${currentStatus == 'Booked' ? 'selected' : ''}>Đã đặt (Booked)</option>
                <option value="Pending" ${currentStatus == 'Pending' ? 'selected' : ''}>Chờ xử lý (Pending)</option>
                <option value="Available" ${currentStatus == 'Available' ? 'selected' : ''}>Còn trống (Available)</option>
            </select>
        </form>
    </div>
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm whitespace-nowrap">
            <thead class="text-xs text-gray-400 uppercase bg-[#0e0f14] border-b border-gray-800">
                <tr>
                    <th class="p-4 font-semibold">Mã vé</th>
                    <th class="p-4 font-semibold">Phim</th>
                    <th class="p-4 font-semibold">Ghế</th>
                    <th class="p-4 font-semibold text-center">Ngày chiếu</th>
                    <th class="p-4 font-semibold text-center">Giờ</th>
                    <th class="p-4 font-semibold text-right">Giá</th>
                    <th class="p-4 font-semibold text-center">Trạng thái</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-800/50">
                <c:forEach var="ticket" items="${ticketList}">
                    <tr class="hover:bg-white/[0.02] transition">
                        <td class="p-4 font-mono text-blue-400 font-bold">#${ticket.id_Ticket}</td>
                        <td class="p-4 text-white font-semibold">${ticket.showtime.movie.title}</td>
                        <td class="p-4 text-gray-300">${ticket.seat.seatName}</td>
                        <td class="p-4 text-center text-gray-400"><fmt:formatDate value="${ticket.showtime.showDate}" pattern="dd/MM/yyyy"/></td>
                        <td class="p-4 text-center text-gray-400"><fmt:formatDate value="${ticket.showtime.startTime}" pattern="HH:mm"/></td>
                        <td class="p-4 text-right text-green-500 font-bold"><fmt:formatNumber value="${ticket.price}" pattern="#,###"/> ₫</td>
                        <td class="p-4 text-center">
                            <c:choose>
                                <c:when test="${ticket.status == 'Sold'}">
                                    <span class="px-2 py-1 bg-green-500/10 text-green-500 rounded-lg text-[10px] font-bold">Sold</span>
                                </c:when>
                                <c:when test="${ticket.status == 'Booked'}">
                                    <span class="px-2 py-1 bg-amber-500/10 text-amber-500 rounded-lg text-[10px] font-bold">Booked</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="px-2 py-1 bg-gray-500/10 text-gray-400 rounded-lg text-[10px] font-bold">${ticket.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty ticketList}">
                    <tr><td colspan="7" class="p-8 text-center text-gray-500">Không tìm thấy vé phù hợp</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
