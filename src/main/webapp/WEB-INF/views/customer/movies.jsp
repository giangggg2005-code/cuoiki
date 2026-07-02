<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="space-y-8">
    <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h2 class="text-3xl font-black text-white uppercase tracking-tighter">
                Danh Sách <span class="text-red-500">Phim</span>
                <c:if test="${currentGenre != null && currentGenre != 'all'}">
                    <span class="text-gray-500 text-lg normal-case font-bold"> — ${currentGenre}</span>
                </c:if>
            </h2>
            <p class="text-gray-500 text-sm mt-1">Phim có suất chiếu từ hôm nay đến 7 ngày tới. Lọc theo thể loại hoặc tìm kiếm tên phim.</p>
        </div>
        <form action="${pageContext.request.contextPath}/customer/movies" method="GET" class="flex gap-2 w-full md:w-auto">
            <input type="hidden" name="genre" value="${currentGenre != null ? currentGenre : 'all'}">
            <input type="text" name="keyword" value="${currentKeyword}" placeholder="Tìm kiếm phim..."
                class="flex-1 md:w-64 bg-[#121212] border border-gray-800 rounded-xl px-4 py-2.5 text-white text-sm focus:border-red-500 outline-none">
            <button type="submit" class="bg-red-600 hover:bg-red-700 text-white font-bold px-5 py-2.5 rounded-xl text-sm uppercase tracking-wider">
                <i class="fas fa-search"></i>
            </button>
        </form>
    </div>

    <div class="flex flex-wrap gap-2">
        <c:url var="allMoviesUrl" value="/customer/movies">
            <c:if test="${not empty currentKeyword}">
                <c:param name="keyword" value="${currentKeyword}" />
            </c:if>
        </c:url>
        <a href="${allMoviesUrl}"
           class="px-4 py-2 rounded-full text-xs font-bold uppercase tracking-wider border transition-all
           ${currentGenre == 'all' ? 'bg-red-600 border-red-600 text-white' : 'border-gray-700 text-gray-400 hover:border-red-500 hover:text-white'}">
            Tất cả
        </a>
        <c:forEach var="g" items="${genreList}">
            <c:url var="genreFilterUrl" value="/customer/movies">
                <c:param name="genre" value="${g}" />
                <c:if test="${not empty currentKeyword}">
                    <c:param name="keyword" value="${currentKeyword}" />
                </c:if>
            </c:url>
            <a href="${genreFilterUrl}"
               class="px-4 py-2 rounded-full text-xs font-bold uppercase tracking-wider border transition-all
               ${currentGenre == g ? 'bg-red-600 border-red-600 text-white' : 'border-gray-700 text-gray-400 hover:border-red-500 hover:text-white'}">
                ${g}
            </a>
        </c:forEach>
    </div>

  <c:choose>
    <c:when test="${empty movieList}">
        <div class="text-center py-20 bg-[#121212] border border-gray-800 rounded-2xl">
            <i class="fas fa-film text-5xl text-gray-700 mb-4"></i>
            <p class="text-gray-500">Không tìm thấy phim phù hợp.</p>
            <a href="${pageContext.request.contextPath}/customer/movies" class="inline-block mt-4 text-red-500 hover:underline text-sm font-bold">Xem tất cả phim</a>
        </div>
    </c:when>
    <c:otherwise>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
        <c:forEach var="movie" items="${movieList}">
            <div class="movie-glass-card group cursor-pointer" onclick="openBooking('${movie.id_Movie}', '${movie.title}', '${movie.posterUrl}', ${movie.basePrice})">
                <div class="relative aspect-[2/3] overflow-hidden">
                    <img src="${movie.posterUrl}" alt="${movie.title}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" onerror="this.src='https://via.placeholder.com/300x450?text=No+Poster'">
                    <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center">
                        <div class="bg-red-600 text-white px-6 py-3 rounded-xl font-bold uppercase text-sm tracking-widest shadow-lg transform translate-y-4 group-hover:translate-y-0 transition-transform duration-300">
                            Đặt vé ngay
                        </div>
                    </div>
                </div>
                <div class="p-5">
                    <h3 class="text-lg font-bold text-white mb-1 truncate">${movie.title}</h3>
                    <div class="flex items-center text-sm text-gray-400 space-x-3">
                        <span>${movie.genre}</span>
                        <span class="w-1 h-1 bg-gray-600 rounded-full"></span>
                        <span>${movie.duration} phút</span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    </c:otherwise>
  </c:choose>
</div>
