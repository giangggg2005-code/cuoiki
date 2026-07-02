<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="space-y-10">
    <!-- Tiêu đề & Thanh chọn ngày -->
    <div class="flex flex-col lg:flex-row lg:items-end justify-between gap-8">
        <div class="space-y-2">
            <h2 class="text-4xl font-black text-white uppercase tracking-tighter">Lịch Chiếu <span class="text-red-500">Phim</span></h2>
            <p class="text-gray-500 font-medium italic">Khám phá lịch chiếu và đặt vé cho những siêu phẩm điện ảnh mới nhất.</p>
        </div>
        
        <!-- Bộ chọn ngày (Date Selector) -->
        <div class="flex gap-3 overflow-x-auto pb-2 no-scrollbar">
            <c:forEach var="tab" items="${dateTabs}">
                <a href="${pageContext.request.contextPath}/customer/showtimes?date=${tab.dbDate}" 
                   class="flex flex-col items-center min-w-[90px] p-4 rounded-3xl border transition-all duration-300 group ${tab.dbDate == selectedDate ? 'bg-red-600 border-red-600 text-white shadow-xl shadow-red-600/30' : 'bg-[#121212] border-gray-800 text-gray-500 hover:border-red-500/50 hover:bg-[#1a1a1a]'}">
                    <span class="text-[10px] font-bold uppercase tracking-[0.2em] mb-1 group-hover:text-white transition-colors">${tab.dayLabel}</span>
                    <span class="text-xl font-black">${tab.dayStr}</span>
                </a>
            </c:forEach>
        </div>
    </div>
    
    <!-- Danh sách phim -->
    <div class="grid gap-6">
        <c:choose>
            <c:when test="${not empty movieList}">
                <c:forEach var="movie" items="${movieList}">
                    <div class="group bg-[#121212] border border-gray-800 rounded-[2rem] p-6 flex flex-col md:flex-row gap-10 hover:border-red-500/40 transition-all duration-500 hover:shadow-2xl hover:shadow-red-900/10">
                        <!-- Ảnh Poster -->
                        <div class="w-full md:w-56 flex-shrink-0 relative overflow-hidden rounded-2xl shadow-2xl">
                            <img src="${movie.posterUrl}" 
                                 class="w-full aspect-[2/3] object-cover transition-transform duration-700 group-hover:scale-110" 
                                 alt="${movie.title}" 
                                 onerror="this.src='https://via.placeholder.com/300x450?text=No+Poster'">
                            <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                        </div>

                        <!-- Nội dung chi tiết -->
                        <div class="flex-1 flex flex-col justify-between py-2">
                            <div class="space-y-6">
                                <div class="space-y-3">
                                    <div class="flex items-center gap-3">
                                        <span class="bg-red-600 text-white px-3 py-1 rounded-lg text-[10px] font-black uppercase tracking-widest">${movie.censorship != null ? movie.censorship : 'P'}</span>
                                        <span class="text-gray-500 text-sm font-bold uppercase tracking-widest">${movie.genre}</span>
                                    </div>
                                    <h3 class="text-3xl font-black text-white group-hover:text-red-500 transition-colors duration-300 uppercase tracking-tight">${movie.title}</h3>
                                </div>
                                
                                <p class="text-gray-400 text-base leading-relaxed line-clamp-3 max-w-3xl">${movie.description}</p>
                                
                                <div class="flex flex-wrap items-center gap-8 text-sm font-bold text-gray-500">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-full bg-[#1e1e1e] flex items-center justify-center text-red-500">
                                            <i class="far fa-clock"></i>
                                        </div>
                                        <span>${movie.duration} PHÚT</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-full bg-[#1e1e1e] flex items-center justify-center text-red-500">
                                            <i class="fas fa-tags"></i>
                                        </div>
                                        <span class="uppercase">${movie.language != null ? movie.language : 'Tiếng Việt'}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-8 md:mt-0 flex items-center justify-between border-t border-gray-800 pt-8">
                                <div class="space-y-1">
                                    <p class="text-[10px] text-gray-500 font-bold uppercase tracking-[0.2em]">Giá vé cơ bản</p>
                                    <p class="text-2xl font-black text-white">${movie.basePrice}đ</p>
                                </div>
                                <button onclick="openBooking('${movie.id_Movie}', '${movie.title}', '${movie.posterUrl}', ${movie.basePrice}, '${selectedDate}')" 
                                        class="bg-red-600 hover:bg-red-700 text-white font-black py-4 px-10 rounded-2xl transition-all shadow-xl shadow-red-600/20 uppercase text-xs tracking-[0.2em] transform hover:-translate-y-1 active:scale-95">
                                    <i class="fas fa-ticket mr-2"></i> Chọn suất chiếu
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="py-32 text-center bg-[#121212] rounded-[3rem] border border-dashed border-gray-800 flex flex-col items-center justify-center space-y-4">
                    <div class="w-20 h-20 bg-gray-800/50 rounded-full flex items-center justify-center text-gray-600 text-3xl">
                        <i class="fas fa-calendar-times"></i>
                    </div>
                    <div class="space-y-1">
                        <p class="text-xl font-bold text-white">Rất tiếc, không có lịch chiếu!</p>
                        <p class="text-gray-500">Vui lòng chọn một ngày khác hoặc quay lại sau.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>