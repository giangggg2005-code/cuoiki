<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-4">
    <div>
        <h2 class="text-xl font-black text-white uppercase tracking-wider">Danh Sách Phim</h2>
        <p class="text-xs text-gray-500">Tra cứu thông tin phim đang chiếu tại rạp (chỉ xem)</p>
    </div>
</div>

<c:if test="${not empty errorMessage}">
    <div class="bg-red-500/10 border border-red-500 text-red-500 px-4 py-3 rounded-xl mb-4 text-sm font-bold">${errorMessage}</div>
</c:if>

<div class="glass-card border border-gray-800 rounded-2xl overflow-hidden mb-6">
    <div class="p-4 border-b border-gray-800 bg-[#161616]">
        <form action="${pageContext.request.contextPath}/staff/movies" method="GET" id="searchForm" class="flex flex-col md:flex-row gap-3">
            <div class="relative flex-1">
                <input type="text" name="keyword" value="${currentKeyword}" placeholder="Tìm tên phim..."
                       class="bg-[#0b0c10] border border-gray-800 text-gray-300 text-xs rounded-lg px-4 py-2 w-full pr-10 focus:outline-none focus:border-blue-600">
                <button type="submit" class="absolute right-3 top-2 text-gray-500 hover:text-white"><i class="fas fa-search"></i></button>
            </div>
            <select name="status" onchange="document.getElementById('searchForm').submit();"
                    class="bg-[#0b0c10] border border-gray-800 text-gray-300 text-xs rounded-lg px-4 py-2 focus:outline-none focus:border-blue-600">
                <option value="all" ${currentStatus == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                <option value="Showing" ${currentStatus == 'Showing' ? 'selected' : ''}>Đang chiếu</option>
                <option value="Coming Soon" ${currentStatus == 'Coming Soon' ? 'selected' : ''}>Sắp chiếu</option>
                <option value="Closed" ${currentStatus == 'Closed' ? 'selected' : ''}>Đã ngưng</option>
            </select>
        </form>
    </div>
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm whitespace-nowrap">
            <thead class="text-xs text-gray-400 uppercase bg-[#0e0f14] border-b border-gray-800">
                <tr>
                    <th class="p-4 text-center w-16">Poster</th>
                    <th class="p-4">Tên phim</th>
                    <th class="p-4">Thể loại</th>
                    <th class="p-4 text-center">Thời lượng</th>
                    <th class="p-4 text-center">Trạng thái</th>
                    <th class="p-4 text-center">Chi tiết</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-800/50">
                <c:forEach var="movie" items="${movieList}">
                    <tr class="hover:bg-white/[0.02] transition">
                        <td class="p-4 text-center">
                            <img src="${movie.posterUrl}" class="w-12 h-16 object-cover rounded shadow-md border border-gray-700 mx-auto" alt="Poster">
                        </td>
                        <td class="p-4 font-bold text-white">${movie.title}</td>
                        <td class="p-4 text-gray-400">${movie.genre}</td>
                        <td class="p-4 text-center text-gray-400">${movie.duration} phút</td>
                        <td class="p-4 text-center">
                            <c:choose>
                                <c:when test="${movie.status == 'Showing'}">
                                    <span class="px-2 py-1 bg-green-500/10 text-green-500 rounded-lg text-[10px] font-bold">Showing</span>
                                </c:when>
                                <c:when test="${movie.status == 'Coming Soon'}">
                                    <span class="px-2 py-1 bg-amber-500/10 text-amber-500 rounded-lg text-[10px] font-bold">Coming Soon</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="px-2 py-1 bg-gray-500/10 text-gray-400 rounded-lg text-[10px] font-bold">Closed</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="p-4 text-center">
                            <a href="${pageContext.request.contextPath}/staff/movies/detail?id=${movie.id_Movie}"
                               class="text-blue-400 hover:text-blue-300 text-xs font-bold"><i class="fas fa-eye mr-1"></i> Xem</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty movieList}">
                    <tr><td colspan="6" class="p-8 text-center text-gray-500">Không tìm thấy phim</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
