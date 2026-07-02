<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="mb-4">
    <a href="${pageContext.request.contextPath}/staff/movies" class="text-blue-400 hover:text-blue-300 text-xs font-bold">
        <i class="fas fa-arrow-left mr-1"></i> Quay lại danh sách
    </a>
</div>

<div class="glass-card border border-gray-800 rounded-2xl overflow-hidden">
    <div class="flex flex-col md:flex-row">
        <div class="md:w-1/3 p-6 flex justify-center bg-[#0e0f14]">
            <img src="${movie.posterUrl}" alt="${movie.title}" class="w-48 h-72 object-cover rounded-xl shadow-2xl border border-gray-700">
        </div>
        <div class="flex-1 p-6">
            <h2 class="text-2xl font-black text-white mb-2">${movie.title}</h2>
            <div class="flex flex-wrap gap-2 mb-4">
                <span class="px-3 py-1 bg-blue-500/10 text-blue-400 rounded-lg text-xs font-bold">${movie.genre}</span>
                <span class="px-3 py-1 bg-gray-500/10 text-gray-400 rounded-lg text-xs font-bold">${movie.duration} phút</span>
                <span class="px-3 py-1 ${movie.status == 'Showing' ? 'bg-green-500/10 text-green-500' : 'bg-amber-500/10 text-amber-500'} rounded-lg text-xs font-bold">${movie.status}</span>
            </div>
            <div class="space-y-3 text-sm">
                <p><span class="text-gray-500 w-28 inline-block">Đạo diễn:</span> <span class="text-white">${not empty movie.director ? movie.director : 'N/A'}</span></p>
                <p><span class="text-gray-500 w-28 inline-block">Diễn viên:</span> <span class="text-white">${not empty movie.cast ? movie.cast : 'N/A'}</span></p>
                <p><span class="text-gray-500 w-28 inline-block">Ngày khởi chiếu:</span> <span class="text-white"><fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/></span></p>
                <p><span class="text-gray-500 w-28 inline-block">Ngôn ngữ:</span> <span class="text-white">${not empty movie.language ? movie.language : 'N/A'}</span></p>
            </div>
            <div class="mt-6 pt-4 border-t border-gray-800">
                <h3 class="text-xs font-bold text-gray-400 uppercase mb-2">Mô tả</h3>
                <p class="text-gray-300 text-sm leading-relaxed">${not empty movie.description ? movie.description : 'Chưa có mô tả'}</p>
            </div>
        </div>
    </div>
</div>
