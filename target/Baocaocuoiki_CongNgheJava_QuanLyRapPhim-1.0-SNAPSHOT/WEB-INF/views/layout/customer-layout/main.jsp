<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Starlight Cinema - Khách Hàng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
        #customer-sidebar { transition: transform 0.3s ease-in-out; }
        #main-container-wrapper { transition: margin-left 0.3s ease-in-out; }
        .glass-header {
            background: rgba(11, 12, 16, 0.8);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }
        .top-nav a { font-size: 12px; font-weight: 700; text-transform: uppercase; color: #9ca3af; transition: color 0.2s; white-space: nowrap; }
        .top-nav a:hover, .top-nav a.active { color: #ef4444; }
        .top-nav-dropdown { position: relative; }
        .top-nav-dropdown-menu {
            position: absolute; top: 100%; left: 0; margin-top: 8px;
            min-width: 200px; max-height: 320px; overflow-y: auto;
            background: #121212; border: 1px solid #374151; border-radius: 12px;
            padding: 8px 0; opacity: 0; visibility: hidden; transform: translateY(8px);
            transition: all 0.2s; z-index: 50; box-shadow: 0 16px 40px rgba(0,0,0,0.5);
        }
        .top-nav-dropdown:hover .top-nav-dropdown-menu { opacity: 1; visibility: visible; transform: translateY(0); }
        .top-nav-dropdown-menu a {
            display: block; padding: 10px 16px; font-size: 12px; font-weight: 500;
            text-transform: none; color: #9ca3af !important;
        }
        .top-nav-dropdown-menu a:hover { background: #1e1e1e; color: #ef4444 !important; }
    </style>
</head>
<body class="bg-[#0b0c10] text-gray-100 font-sans overflow-x-hidden">

    <!-- Notification Container -->
    <div id="notification-container" class="fixed top-4 right-4 z-[9999] space-y-3 w-80 max-w-full">
        <!-- Notifications will be appended here by JavaScript -->
    </div>

    <!-- Sidebar dành riêng cho Giao diện Khách hàng -->
    <aside id="customer-sidebar" class="fixed left-0 top-0 h-full w-64 bg-[#121212] border-r border-gray-800 z-50 transform md:translate-x-0 -translate-x-full shadow-2xl">
        <div class="p-6">
            <div class="flex items-center space-x-3 mb-10">
                <div class="w-10 h-10 bg-red-600 rounded-lg flex items-center justify-center shadow-[0_0_15px_rgba(220,38,38,0.5)]">
                    <i class="fas fa-film text-white text-xl"></i>
                </div>
                <span class="text-xl font-black tracking-tighter uppercase">Starlight <span class="text-red-500">Cinema</span></span>
            </div>

            <nav id="sidebar-menu" class="space-y-2">
                <!-- Danh sách menu đã loại bỏ Khuyến mãi và tập trung vào các chức năng chính -->
                <a href="${pageContext.request.contextPath}/customer/home" 
                   class="menu-item w-full flex items-center space-x-3 ${view == 'home' ? 'bg-red-600 text-white shadow-lg shadow-red-600/20' : 'text-gray-400 hover:bg-[#1e1e1e] hover:text-white'} px-4 py-3 rounded-xl font-medium transition-all duration-200">
                    <i class="fas fa-house-chimney w-5 text-center"></i>
                    <span>Trang chủ</span>
                </a>
                <a href="${pageContext.request.contextPath}/customer/profile" 
                   class="menu-item w-full flex items-center space-x-3 ${view == 'profile' ? 'bg-red-600 text-white shadow-lg shadow-red-600/20' : 'text-gray-400 hover:bg-[#1e1e1e] hover:text-white'} px-4 py-3 rounded-xl font-medium transition-all duration-200">
                    <i class="fas fa-user-circle w-5 text-center"></i>
                    <span>Thông tin cá nhân</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/customer/history" 
                   class="menu-item w-full flex items-center space-x-3 ${view == 'history' ? 'bg-red-600 text-white shadow-lg shadow-red-600/20' : 'text-gray-400 hover:bg-[#1e1e1e] hover:text-white'} px-4 py-3 rounded-xl font-medium transition-all duration-200">
                    <i class="fas fa-clock-rotate-left w-5 text-center"></i>
                    <span>Lịch sử đặt vé</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/customer/showtimes" 
                   class="menu-item w-full flex items-center space-x-3 ${view == 'showtimes' ? 'bg-red-600 text-white shadow-lg shadow-red-600/20' : 'text-gray-400 hover:bg-[#1e1e1e] hover:text-white'} px-4 py-3 rounded-xl font-medium transition-all duration-200">
                    <i class="fas fa-calendar-alt w-5 text-center"></i>
                    <span>Lịch chiếu</span>
                </a>
                <a href="${pageContext.request.contextPath}/customer/movies" 
                   class="menu-item w-full flex items-center space-x-3 ${view == 'movies' ? 'bg-red-600 text-white shadow-lg shadow-red-600/20' : 'text-gray-400 hover:bg-[#1e1e1e] hover:text-white'} px-4 py-3 rounded-xl font-medium transition-all duration-200">
                    <i class="fas fa-film w-5 text-center"></i>
                    <span>Phim</span>
                </a>

                <div class="pt-2 pb-1 px-4 text-[10px] font-bold uppercase tracking-widest text-gray-600">Thể loại</div>
                <div class="max-h-40 overflow-y-auto space-y-1 px-2 mb-2">
                    <c:url var="sidebarAllGenreUrl" value="/customer/movies" />
                    <a href="${sidebarAllGenreUrl}" class="block px-3 py-2 rounded-lg text-xs text-gray-500 hover:text-white hover:bg-[#1e1e1e] transition-all">Tất cả</a>
                    <c:forEach var="g" items="${genreList}">
                        <c:url var="sidebarGenreUrl" value="/customer/movies">
                            <c:param name="genre" value="${g}" />
                        </c:url>
                        <a href="${sidebarGenreUrl}" class="block px-3 py-2 rounded-lg text-xs text-gray-500 hover:text-white hover:bg-[#1e1e1e] transition-all">${g}</a>
                    </c:forEach>
                </div>
                
                <!-- Đẩy nút đăng xuất xuống cuối -->
                <div class="mt-auto pt-6 border-t border-gray-800">
                    <a href="${pageContext.request.contextPath}/logout-customer" 
                       class="menu-item w-full flex items-center space-x-3 text-gray-500 hover:text-red-500 px-4 py-3 rounded-xl font-medium transition-all duration-200">
                        <i class="fas fa-arrow-right-from-bracket w-5 text-center"></i>
                        <span>Đăng xuất</span>
                    </a>
                </div>
            </nav>
        </div>
    </aside>

    <!-- Main Content Wrapper -->
    <main id="main-container-wrapper" class="md:ml-64 min-h-screen sidebar-transition">
        <!-- Header: toggle + điều hướng nhanh -->
        <div class="sticky top-0 z-40 px-4 py-4 bg-[#0b0c10]/80 backdrop-blur-md border-b border-gray-800/50">
            <div class="flex items-center justify-between gap-4 flex-wrap">
                <div class="flex items-center gap-4">
                    <button id="sidebar-toggle" class="p-3 rounded-2xl bg-[#121212] border border-gray-800 text-red-500 shadow-xl hover:bg-red-600/10 transition-all duration-300">
                        <i class="fas fa-bars text-xl"></i>
                    </button>
                    <!-- Brand logo in header (visible on mobile when sidebar is hidden) -->
                    <a href="${pageContext.request.contextPath}/customer/home" class="flex items-center space-x-2 md:hidden">
                        <div class="w-8 h-8 bg-red-600 rounded-lg flex items-center justify-center shadow-[0_0_10px_rgba(220,38,38,0.4)]">
                            <i class="fas fa-film text-white text-sm"></i>
                        </div>
                        <span class="text-base font-black tracking-tighter uppercase">Starlight <span class="text-red-500">Cinema</span></span>
                    </a>
                    <nav class="top-nav hidden md:flex items-center gap-6">
                        <a href="${pageContext.request.contextPath}/customer/home" class="${view == 'home' ? 'active' : ''}">Trang chủ</a>
                        <a href="${pageContext.request.contextPath}/customer/showtimes" class="${view == 'showtimes' ? 'active' : ''}">Lịch chiếu</a>
                        <a href="${pageContext.request.contextPath}/customer/movies" class="${view == 'movies' ? 'active' : ''}">Phim</a>
                        <div class="top-nav-dropdown">
                            <a href="javascript:void(0)">Thể loại <i class="fas fa-chevron-down text-[10px] ml-1"></i></a>
                            <div class="top-nav-dropdown-menu">
                                <a href="${pageContext.request.contextPath}/customer/movies">Tất cả thể loại</a>
                                <c:forEach var="g" items="${genreList}">
                                    <c:url var="headerGenreUrl" value="/customer/movies">
                                        <c:param name="genre" value="${g}" />
                                    </c:url>
                                    <a href="${headerGenreUrl}">${g}</a>
                                </c:forEach>
                            </div>
                        </div>
                    </nav>
                </div>
            </div>
        </div>

        <!-- Nội dung trang -->
        <div class="px-6 md:px-10 pb-10">
            <jsp:include page="${body}" />
        </div>
    </main>

    <!-- Shared Booking Modal (Đưa từ home.jsp ra dùng chung cho tất cả các tab) -->
    <div id="booking-modal" class="fixed inset-0 z-[100] bg-black/95 backdrop-blur-xl hidden flex items-center justify-center p-4">
        <div class="bg-[#121212] border border-gray-800 w-full max-w-5xl h-[90vh] rounded-[2.5rem] overflow-hidden flex shadow-2xl">
            <!-- Main Area -->
            <div class="flex-1 p-10 overflow-y-auto flex flex-col">
                <div class="flex items-center justify-between mb-6 shrink-0">
                    <button type="button" onclick="changeStep(-1)" class="booking-step-back">
                        <i class="fas fa-arrow-left"></i>
                        <span id="btn-booking-top-back-label">Quay về trang trước</span>
                    </button>
                    <button type="button" onclick="closeBooking()" class="w-10 h-10 rounded-full bg-[#1a1a1a] border border-gray-700 text-gray-400 hover:text-white hover:border-gray-500 flex items-center justify-center transition-all" title="Đóng đặt vé">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <div class="flex gap-6 mb-10 text-[10px] font-black uppercase tracking-[0.2em] flex-wrap shrink-0">
                    <div id="step-idx-1" class="text-red-500 border-b-2 border-red-500 pb-2">01. Suất Chiếu</div>
                    <div id="step-idx-2" class="text-gray-600">02. Chọn Ghế</div>
                    <div id="step-idx-3" class="text-gray-600">03. Thanh Toán</div>
                    <div id="step-idx-4" class="text-gray-600">04. Xác Nhận</div>
                </div>

                <div id="step-1" class="booking-step-content space-y-8 flex-1">
                    <button type="button" class="booking-step-back booking-step-back-inline" onclick="changeStep(-1)">
                        <i class="fas fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay về trang trước</span>
                    </button>
                    <h3 class="text-2xl font-black text-white uppercase">Chọn ngày & giờ chiếu</h3>
                    <div id="dynamic-date-list" class="flex gap-3 overflow-x-auto pb-4"></div>
                    <div id="dynamic-time-slots" class="flex flex-wrap gap-3"></div>
                </div>

                <div id="step-2" class="booking-step-content hidden space-y-10 flex-1">
                    <button type="button" class="booking-step-back booking-step-back-inline" onclick="changeStep(-1)">
                        <i class="fas fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay lại chọn suất</span>
                    </button>
                    <div class="w-4/5 h-1 bg-gradient-to-r from-transparent via-gray-700 to-transparent mx-auto relative rounded-full">
                        <span class="absolute -top-6 left-1/2 -translate-x-1/2 text-[10px] text-gray-500 font-bold tracking-[0.5em]">MÀN HÌNH</span>
                    </div>
                    <div id="seat-grid" class="grid gap-2 justify-center"></div>
                    <div class="flex flex-wrap justify-center gap-5 sm:gap-8 mt-8 text-[10px] font-bold uppercase tracking-wider">
                        <div class="flex items-center gap-2">
                            <div class="w-6 h-6 rounded-t-lg rounded-b-sm bg-gradient-to-b from-red-500 to-red-600 border-b-2 border-red-800 shadow-[0_0_10px_rgba(220,38,38,0.4)]"></div>
                            <span class="text-red-400">Trống</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-6 h-6 rounded-t-lg rounded-b-sm bg-yellow-500 border-b-2 border-yellow-700 shadow-[0_0_10px_rgba(234,179,8,0.5)]"></div>
                            <span class="text-yellow-500">Đã bán</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-6 h-6 rounded-t-lg rounded-b-sm bg-gray-700/80 border-b-2 border-gray-900 opacity-70"></div>
                            <span class="text-gray-400">Bảo trì</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-6 h-6 rounded-t-lg rounded-b-sm bg-gradient-to-b from-emerald-500 to-emerald-600 border-b-2 border-emerald-800"></div>
                            <span class="text-emerald-400">Đang chọn</span>
                        </div>
                    </div>
                </div>
                
                <div id="step-3" class="booking-step-content hidden space-y-8 flex-1">
                    <button type="button" class="booking-step-back booking-step-back-inline" onclick="changeStep(-1)">
                        <i class="fas fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay lại chọn ghế</span>
                    </button>
                    <h3 class="text-2xl font-black text-white uppercase">Thanh toán</h3>

                    <div class="flex gap-4 mb-6">
                        <button type="button" onclick="selectPaymentMethod('Card')" id="btn-pay-card"
                            class="flex-1 py-4 px-6 rounded-xl border-2 border-red-500 bg-red-600/10 text-white font-bold text-sm uppercase tracking-wider transition-all">
                            <i class="fas fa-credit-card mr-2"></i> Thẻ tín dụng
                        </button>
                        <button type="button" onclick="selectPaymentMethod('QR')" id="btn-pay-qr"
                            class="flex-1 py-4 px-6 rounded-xl border-2 border-gray-700 text-gray-400 font-bold text-sm uppercase tracking-wider hover:border-gray-500 transition-all">
                            <i class="fas fa-qrcode mr-2"></i> Mã QR
                        </button>
                    </div>

                    <div id="panel-card" class="bg-[#1a1a1a] border border-gray-800 rounded-2xl p-8 space-y-6">
                        <div>
                            <label class="block text-[10px] text-gray-500 font-bold uppercase mb-2">Số thẻ thanh toán</label>
                            <input type="text" id="payment-card-number" maxlength="19"
                                placeholder="9704-0000-1111-0001"
                                class="w-full bg-[#0b0c10] border border-gray-700 rounded-xl px-4 py-3 text-white focus:border-red-500 outline-none font-mono tracking-wider"
                                autocomplete="off" spellcheck="false">
                            <p class="text-[10px] text-gray-600 mt-2">Nhập chính xác số thẻ trong hệ thống (VD: 9704-0000-1111-0001).</p>
                        </div>
                        <div>
                            <label class="block text-[10px] text-gray-500 font-bold uppercase mb-2">Mã PIN (6 số)</label>
                            <input type="password" id="payment-pin" maxlength="6" placeholder="123456"
                                class="w-full bg-[#0b0c10] border border-gray-700 rounded-xl px-4 py-3 text-white focus:border-red-500 outline-none tracking-widest"
                                autocomplete="off" inputmode="numeric">
                            <p id="payment-pin-error" class="hidden text-xs text-red-400 mt-2 font-bold"></p>
                            <p class="text-[10px] text-gray-600 mt-2">Mã PIN trong database: <span class="text-gray-400 font-mono">123456</span></p>
                        </div>
                        <p class="text-xs text-gray-500"><i class="fas fa-shield-halved mr-1"></i> Số tiền sẽ được trừ trực tiếp từ số dư thẻ sau khi xác nhận thanh toán.</p>
                    </div>

                    <div id="panel-qr" class="hidden bg-[#1a1a1a] border border-gray-800 rounded-2xl p-8 text-center space-y-4">
                        <img id="qr-code-image" src="" alt="QR Thanh toán" class="mx-auto w-52 h-52 rounded-xl border border-gray-700 bg-white p-2">
                        <p class="text-white font-bold">Quét mã để thanh toán</p>
                        <p class="text-xs text-gray-500">Mở ứng dụng Ngân hàng hoặc Ví điện tử (MoMo, ZaloPay, VNPay...)</p>
                        <table class="qr-info-table w-full text-left text-xs mt-2 border border-gray-800 rounded-xl overflow-hidden">
                            <tbody class="divide-y divide-gray-800">
                                <tr class="bg-[#0b0c10]"><td class="px-4 py-2 text-gray-500">Ngân hàng</td><td class="px-4 py-2 text-white font-bold text-right qr-bank-name">—</td></tr>
                                <tr><td class="px-4 py-2 text-gray-500">Số tài khoản</td><td class="px-4 py-2 text-white font-bold text-right qr-account-number">—</td></tr>
                                <tr class="bg-[#0b0c10]"><td class="px-4 py-2 text-gray-500">Chủ tài khoản</td><td class="px-4 py-2 text-white font-bold text-right qr-account-name">—</td></tr>
                                <tr><td class="px-4 py-2 text-gray-500">Nội dung CK</td><td class="px-4 py-2 text-gray-400 font-mono text-[10px] text-right break-all" id="qr-transaction-code"></td></tr>
                                <tr class="bg-[#0b0c10]"><td class="px-4 py-2 text-gray-500">Số tiền</td><td class="px-4 py-2 text-red-500 font-black text-right" id="qr-amount-display">0đ</td></tr>
                            </tbody>
                        </table>
                        <button type="button" onclick="loadQrCode()" class="mt-2 text-xs text-gray-400 hover:text-white underline">Tạo lại mã QR</button>
                    </div>
                </div>

                <div id="step-4" class="booking-step-content hidden space-y-6 flex-1">
                    <button type="button" class="booking-step-back booking-step-back-inline" onclick="changeStep(-1)">
                        <i class="fas fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay lại thanh toán</span>
                    </button>
                    <h3 class="text-2xl font-black text-white uppercase">Xác nhận đơn đặt vé</h3>
                    <p class="text-gray-500 text-sm">Vui lòng kiểm tra lại thông tin trước khi thanh toán.</p>

                    <div class="bg-[#1a1a1a] border border-gray-800 rounded-2xl overflow-hidden">
                        <div class="p-6 border-b border-gray-800">
                            <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Phim</p>
                            <p id="confirm-movie-title" class="text-white font-bold text-lg"></p>
                        </div>
                        <div class="p-6 border-b border-gray-800 grid grid-cols-2 gap-4">
                            <div>
                                <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Ngày chiếu</p>
                                <p id="confirm-date" class="text-white font-bold"></p>
                            </div>
                            <div>
                                <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Giờ chiếu</p>
                                <p id="confirm-time" class="text-red-500 font-bold"></p>
                            </div>
                        </div>
                        <div class="p-6 border-b border-gray-800">
                            <p class="text-[10px] text-gray-500 font-bold uppercase mb-3">Chi tiết ghế</p>
                            <div id="confirm-seats-list" class="space-y-2 text-sm"></div>
                        </div>
                        <div class="p-6 border-b border-gray-800">
                            <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Phương thức thanh toán</p>
                            <p id="confirm-payment-method" class="text-white font-bold"></p>
                            <p id="confirm-payment-detail" class="text-gray-400 text-sm mt-1"></p>
                        </div>
                        <div class="p-6 flex justify-between items-center bg-[#0b0c10]">
                            <span class="text-gray-400 font-bold uppercase text-xs">Tổng thanh toán</span>
                            <span id="confirm-total" class="text-2xl font-black text-red-500"></span>
                        </div>
                    </div>

                    <label class="flex items-start gap-3 cursor-pointer group">
                        <input type="checkbox" id="confirm-agree" class="mt-1 w-4 h-4 accent-red-600 cursor-pointer">
                        <span class="text-sm text-gray-400 group-hover:text-gray-300">
                            Tôi xác nhận thông tin đặt vé và phương thức thanh toán ở trên là chính xác. Đồng ý với
                            <a href="#" class="text-red-500 hover:underline">điều khoản sử dụng</a> của Starlight Cinema.
                        </span>
                    </label>
                </div>

                <div class="flex justify-between items-center gap-4 mt-8 pt-6 border-t border-gray-800 shrink-0">
                    <button type="button" id="btn-booking-main-prev" onclick="changeStep(-1)" class="booking-step-back px-6 py-3">
                        <i class="fas fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay lại</span>
                    </button>
                    <button type="button" id="btn-booking-main-next" onclick="changeStep(1)" class="bg-red-600 hover:bg-red-700 text-white font-black py-3 px-8 rounded-xl text-xs uppercase tracking-widest transition-all">
                        Tiếp tục
                    </button>
                </div>
            </div>

            <!-- Sidebar Info -->
            <div class="w-80 bg-[#080808] border-l border-gray-800 p-10 flex flex-col">
                <img id="modal-movie-poster" src="" class="w-full aspect-[2/3] object-cover rounded-2xl shadow-2xl mb-6">
                <h3 id="modal-movie-title" class="text-xl font-bold text-white mb-8 leading-tight">Tên Phim</h3>
                
                <div class="space-y-6 flex-1 text-sm">
                    <div class="border-b border-gray-800 pb-4">
                        <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Thời gian</p>
                        <p class="text-white font-bold"><span id="summary-date">Hôm nay</span> | <span id="summary-time" class="text-red-500">--:--</span></p>
                    </div>
                    <div class="border-b border-gray-800 pb-4">
                        <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Ghế chọn</p>
                        <p id="summary-seats" class="text-white font-bold">Chưa chọn ghế</p>
                        <div id="summary-seats-detail" class="mt-2 space-y-1.5 max-h-36 overflow-y-auto"></div>
                    </div>
                    <div class="mt-auto">
                        <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Tổng tiền</p>
                        <p id="summary-total" class="text-3xl font-black text-red-500">0đ</p>
                    </div>
                </div>

                <div class="flex flex-col gap-3 mt-10">
                    <button onclick="changeStep(1)" id="btn-booking-next" class="w-full bg-red-600 hover:bg-red-700 text-white font-black py-4 rounded-xl text-xs uppercase tracking-widest transition-all">Tiếp tục</button>
                    <button onclick="changeStep(-1)" id="btn-booking-prev" class="w-full text-gray-500 hover:text-white font-bold text-xs uppercase transition-all">Quay lại</button>
                </div>
            </div>
        </div>
    </div>

    <form id="submit-booking-form" action="${pageContext.request.contextPath}/customer/booking/checkout" method="POST" class="hidden">
        <input type="hidden" name="movieId" id="form-movie-id">
        <input type="hidden" name="showtimeId" id="form-showtime-id">
        <input type="hidden" name="showTime" id="form-show-time">
        <input type="hidden" name="showDate" id="form-show-date">
        <input type="hidden" name="selectedSeats" id="form-selected-seats">
        <input type="hidden" name="paymentMethod" id="form-payment-method" value="Card">
        <input type="hidden" name="cardNumber" id="form-card-number">
        <input type="hidden" name="paymentId" id="form-payment-id">
        <input type="hidden" name="pinCode" id="form-pin-code">
        <input type="hidden" name="qrTransactionCode" id="form-qr-transaction-code">
    </form>

    <style>
        .seat {
            width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;
            font-size: 10px; font-weight: 700; border-radius: 10px 10px 4px 4px; cursor: pointer;
            background: linear-gradient(to bottom, #ef4444, #dc2626); color: #fff;
            border-bottom: 3px solid #991b1b;
            box-shadow: 0 0 12px rgba(220, 38, 38, 0.45);
            transition: all 0.2s;
        }
        .seat:hover:not(.sold):not(.maintenance):not(.selected) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(220, 38, 38, 0.65);
        }
        .seat.sold {
            background: #eab308; color: #713f12;
            border-bottom: 3px solid #a16207;
            box-shadow: 0 0 15px rgba(234, 179, 8, 0.55);
            cursor: not-allowed; opacity: 1;
        }
        .seat.maintenance {
            background: rgba(55, 65, 81, 0.85); color: #9ca3af;
            border-bottom: 3px solid #111827;
            cursor: not-allowed; opacity: 0.75; box-shadow: none;
        }
        .seat.selected {
            background: linear-gradient(to bottom, #22c55e, #16a34a) !important;
            border-bottom-color: #15803d !important;
            color: #fff !important;
            box-shadow: 0 0 18px rgba(34, 197, 94, 0.75) !important;
        }
        .date-btn { padding: 12px 20px; border-radius: 12px; border: 1px solid #333; background: #1e1e1e;
            color: #aaa; font-weight: 700; font-size: 12px; white-space: nowrap; cursor: pointer; transition: all 0.2s; }
        .date-btn.active { border-color: #dc2626; color: #ef4444; background: rgba(220,38,38,0.1); }
        #step-idx-1.active, #step-idx-2.active, #step-idx-3.active, #step-idx-4.active { color: #ef4444; border-bottom: 2px solid #ef4444; padding-bottom: 8px; }
        .booking-step-back {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 8px 14px; border-radius: 10px;
            border: 1px solid #374151; background: transparent;
            color: #9ca3af; font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.05em;
            cursor: pointer; transition: all 0.2s;
        }
        .booking-step-back:hover { color: #fff; border-color: #6b7280; }
    </style>

    <script>
        const contextPath = "${pageContext.request.contextPath}";
        let currentStep = 1;
        let selectedTime = null;
        let selectedShowtimeId = null;
        let selectedDate = null;
        let selectedSeats = [];
        let currentMovieId = null;
        let ticketPrice = 0;
        let paymentMethod = 'Card';
        let qrTransactionCode = '';

        function getBookingBackLabel(step) {
            if (step === 1) {
                const path = window.location.pathname || '';
                if (path.includes('/customer/movies')) return 'Quay lại danh sách phim';
                if (path.includes('/customer/showtimes')) return 'Quay lại lịch chiếu';
                if (path.includes('/customer/home')) return 'Quay về trang chủ';
                return 'Quay về trang trước';
            }
            if (step === 2) return 'Quay lại chọn suất';
            if (step === 3) return 'Quay lại chọn ghế';
            if (step === 4) return 'Quay lại thanh toán';
            return 'Quay lại';
        }

        function getBookingNextLabel(step) {
            if (step === 4) return 'Xác nhận & Thanh toán';
            if (step === 3) return 'Xem lại đơn hàng';
            return 'Tiếp tục';
        }

        function updateBookingNavLabels() {
            const backLabel = getBookingBackLabel(currentStep);
            const nextLabel = getBookingNextLabel(currentStep);

            const prevBtn = document.getElementById('btn-booking-prev');
            if (prevBtn) prevBtn.innerText = backLabel;

            const topBackLabel = document.getElementById('btn-booking-top-back-label');
            if (topBackLabel) topBackLabel.innerText = backLabel;

            document.querySelectorAll('.booking-step-back-label').forEach(el => {
                el.innerText = backLabel;
            });

            const nextBtn = document.getElementById('btn-booking-next');
            if (nextBtn) nextBtn.innerText = nextLabel;

            const mainNextBtn = document.getElementById('btn-booking-main-next');
            if (mainNextBtn) mainNextBtn.innerText = nextLabel;
        }

        window.openBooking = function(movieId, title, posterUrl, basePrice, defaultDate) {
            const modal = document.getElementById('booking-modal');
            modal.classList.remove('hidden');
            document.body.style.overflow = 'hidden';

            currentStep = 1;
            selectedTime = null;
            selectedShowtimeId = null;
            selectedSeats = [];
            currentMovieId = movieId;
            ticketPrice = basePrice || 85000;

            document.getElementById('modal-movie-title').innerText = title;
            document.getElementById('modal-movie-poster').src = posterUrl;
            document.getElementById('form-movie-id').value = movieId;

            document.querySelectorAll('.booking-step-content').forEach(el => el.classList.add('hidden'));
            document.getElementById('step-1').classList.remove('hidden');
            ['step-idx-1','step-idx-2','step-idx-3','step-idx-4'].forEach(id => document.getElementById(id).classList.remove('active'));
            document.getElementById('step-idx-1').classList.add('active');
            document.getElementById('confirm-agree').checked = false;
            updateBookingNavLabels();

            let dateStr = defaultDate;
            if (!dateStr) {
                const tzoffset = (new Date()).getTimezoneOffset() * 60000;
                dateStr = (new Date(Date.now() - tzoffset)).toISOString().split('T')[0];
            }
            selectedDate = dateStr;
            document.getElementById('form-show-date').value = dateStr;

            generateDateButtons(dateStr);
            fetchShowtimes(movieId, dateStr);
            renderSeats();
            updateSummary();
            selectPaymentMethod('Card');
        };

        function generateDateButtons(activeDate) {
            const container = document.getElementById('dynamic-date-list');
            container.innerHTML = '';
            const dayNames = ['CN','T2','T3','T4','T5','T6','T7'];
            const today = new Date();
            for (let i = 0; i < 7; i++) {
                const d = new Date(today);
                d.setDate(today.getDate() + i);
                const tzoffset = d.getTimezoneOffset() * 60000;
                const dateStr = (new Date(d.getTime() - tzoffset)).toISOString().split('T')[0];
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'date-btn' + (dateStr === activeDate ? ' active' : '');
                btn.innerHTML = '<div>' + (i === 0 ? 'Hôm nay' : dayNames[d.getDay()]) + '</div><div style="font-size:16px;margin-top:4px">' + d.getDate() + '/' + (d.getMonth()+1) + '</div>';
                btn.onclick = () => selectDate(btn, dateStr, i === 0 ? 'Hôm nay' : dayNames[d.getDay()], d.getDate() + '/' + (d.getMonth()+1));
                container.appendChild(btn);
            }
        }

        function selectDate(element, dateStr, dayLabel, dayNum) {
            document.querySelectorAll('.date-btn').forEach(b => b.classList.remove('active'));
            element.classList.add('active');
            selectedDate = dateStr;
            document.getElementById('form-show-date').value = dateStr;
            document.getElementById('summary-date').innerText = dayLabel + ' ' + dayNum;
            selectedTime = null;
            selectedShowtimeId = null;
            document.getElementById('summary-time').innerText = '--:--';
            document.getElementById('form-show-time').value = '';
            document.getElementById('form-showtime-id').value = '';
            fetchShowtimes(currentMovieId, dateStr);
        }

        function fetchShowtimes(movieId, dateStr) {
            const container = document.getElementById('dynamic-time-slots');
            container.innerHTML = '<p class="text-gray-500 animate-pulse">Đang tải suất chiếu...</p>';

            fetch(contextPath + '/customer/api/showtimes?movieId=' + movieId + '&date=' + dateStr, {
                headers: { 'Accept': 'application/json' }
            })
                .then(async res => {
                    if (!res.ok) {
                        throw new Error('Lỗi Server ' + res.status + ': Không tải được suất chiếu.');
                    }
                    const contentType = res.headers.get('content-type') || '';
                    if (!contentType.includes('application/json')) {
                        throw new Error('Dữ liệu trả về không phải JSON.');
                    }
                    return res.json();
                })
                .then(data => {
                    container.innerHTML = '';
                    if (data.length > 0) {
                        data.forEach(st => {
                            const btn = document.createElement('button');
                            btn.type = 'button';
                            btn.className = "px-6 py-3 bg-[#1e1e1e] border border-gray-800 rounded-xl text-white font-bold hover:border-red-500 transition-all";
                            btn.innerText = st.startTime;
                            btn.onclick = () => {
                                document.querySelectorAll('#dynamic-time-slots button').forEach(b => b.classList.remove('border-red-500', 'text-red-500'));
                                btn.classList.add('border-red-500', 'text-red-500');
                                selectedTime = st.startTime;
                                selectedShowtimeId = st.id_Showtime;
                                document.getElementById('summary-time').innerText = st.startTime;
                                document.getElementById('form-show-time').value = st.startTime;
                                document.getElementById('form-showtime-id').value = st.id_Showtime;
                                loadSeatsForShowtime(st.id_Showtime);
                            };
                            container.appendChild(btn);
                        });
                    } else {
                        container.innerHTML = '<p class="text-gray-600 italic">Không có suất chiếu cho ngày này.</p>';
                    }
                })
                .catch(err => {
                    console.error('fetchShowtimes:', err);
                    container.innerHTML = '<p class="text-red-500 text-sm">' + err.message + '</p>';
                });
        }

        function resolveSeatDisplayStatus(seat) {
            if (seat.status) return seat.status;
            if (seat.sold) return 'Sold';
            if (seat.unavailable) return 'Maintenance';
            return 'Available';
        }

        function loadSeatsForShowtime(showtimeId) {
            if (!showtimeId) return;
            fetch(contextPath + '/customer/api/seats?showtimeId=' + showtimeId, {
                headers: { 'Accept': 'application/json' }
            })
                .then(async res => {
                    if (!res.ok) throw new Error('Không tải được sơ đồ ghế (mã ' + res.status + ')');
                    return res.json();
                })
                .then(data => {
                    window._seatLayout = data || { totalRows: 0, totalCols: 0, seats: [] };
                    window._soldSeats = new Set();
                    window._unavailableSeats = new Set();
                    (data.seats || []).forEach(s => {
                        const st = resolveSeatDisplayStatus(s);
                        if (st === 'Sold') window._soldSeats.add(s.seatName);
                        if (st === 'Maintenance') window._unavailableSeats.add(s.seatName);
                    });
                    selectedSeats = [];
                    document.querySelectorAll('#form-selected-seats').forEach(el => { el.value = ''; });
                    renderSeats();
                    updateSummary();
                })
                .catch(err => {
                    alert(err.message || 'Không tải được sơ đồ ghế. Vui lòng chọn lại suất chiếu!');
                });
        }

        function renderSeats() {
            const grid = document.getElementById('seat-grid');
            grid.innerHTML = '';
            const layout = window._seatLayout || { totalRows: 0, totalCols: 0, seats: [] };
            const totalRows = layout.totalRows || 0;
            const totalCols = layout.totalCols || 1;
            grid.style.gridTemplateColumns = 'repeat(' + totalCols + ', minmax(36px, 1fr))';

            const seatMap = {};
            (layout.seats || []).forEach(s => {
                seatMap[s.rowPos + '-' + s.colPos] = s;
            });

            for (let r = 1; r <= totalRows; r++) {
                for (let c = 1; c <= totalCols; c++) {
                    const seat = seatMap[r + '-' + c];
                    if (!seat) continue;
                    const seatId = seat.seatName;
                    const displayStatus = resolveSeatDisplayStatus(seat);
                    const div = document.createElement('div');
                    let className = 'seat';
                    if (displayStatus === 'Sold') className += ' sold';
                    else if (displayStatus === 'Maintenance') className += ' maintenance';
                    div.className = className;
                    div.innerText = seatId;
                    if (displayStatus === 'Sold') {
                        div.title = 'Ghế đã bán';
                        div.onclick = () => alert('Ghế ' + seatId + ' đã được đặt! Vui lòng chọn ghế khác.');
                    } else if (displayStatus === 'Maintenance') {
                        div.title = 'Ghế bảo trì';
                        div.onclick = () => alert('Ghế ' + seatId + ' đang bảo trì, không thể đặt!');
                    } else {
                        div.title = 'Ghế trống';
                        div.onclick = () => toggleSeat(div, seatId);
                    }
                    grid.appendChild(div);
                }
            }
        }

        function getSeatPrice() {
            return ticketPrice;
        }

        function toggleSeat(element, seatId) {
            if (element.classList.contains('sold')) {
                alert('Ghế ' + seatId + ' đã được đặt! Vui lòng chọn ghế khác.');
                return;
            }
            if (element.classList.contains('maintenance')) {
                alert('Ghế ' + seatId + ' đang bảo trì, không thể đặt!');
                return;
            }
            if (element.classList.contains('selected')) {
                element.classList.remove('selected');
                selectedSeats = selectedSeats.filter(s => s.id !== seatId);
            } else {
                if (selectedSeats.length >= 8) { alert('Bạn chỉ được chọn tối đa 8 ghế!'); return; }
                element.classList.add('selected');
                selectedSeats.push({ id: seatId });
            }
            document.getElementById('form-selected-seats').value = selectedSeats.map(s => s.id).join(',');
            updateSummary();
        }

        function updateSummary() {
            const fmt = n => new Intl.NumberFormat('vi-VN').format(n) + 'đ';
            const seatsEl = document.getElementById('summary-seats');
            const detailEl = document.getElementById('summary-seats-detail');

            if (selectedSeats.length === 0) {
                seatsEl.innerText = 'Chưa chọn ghế';
                if (detailEl) detailEl.innerHTML = '';
            } else {
                seatsEl.innerText = selectedSeats.map(s => s.id).join(', ');
                if (detailEl) {
                    detailEl.innerHTML = '';
                    selectedSeats.forEach(s => {
                        const price = getSeatPrice();
                        const row = document.createElement('div');
                        row.className = 'flex justify-between items-center text-xs text-gray-400';
                        row.innerHTML =
                            '<span>Ghế <span class="text-white font-semibold">' + s.id + '</span></span>' +
                            '<span class="text-red-400 font-bold">' + fmt(price) + '</span>';
                        detailEl.appendChild(row);
                    });
                }
            }

            const total = selectedSeats.reduce((sum, s) => sum + getSeatPrice(), 0);
            document.getElementById('summary-total').innerText = fmt(total);
            return total;
        }

        function setPaymentPanelVisible(panelId, visible) {
            document.querySelectorAll('#' + panelId).forEach(el => {
                el.classList.toggle('hidden', !visible);
                el.style.display = visible ? '' : 'none';
            });
        }

        function selectPaymentMethod(method) {
            paymentMethod = method;
            document.querySelectorAll('#form-payment-method').forEach(el => { el.value = method; });
            const isCard = method === 'Card';
            const cardBtn = document.getElementById('btn-pay-card');
            const qrBtn = document.getElementById('btn-pay-qr');
            if (cardBtn && cardBtn.classList) {
                cardBtn.className = isCard
                    ? 'flex-1 py-4 px-6 rounded-xl border-2 border-red-500 bg-red-600/10 text-white font-bold text-sm uppercase tracking-wider transition-all'
                    : 'flex-1 py-4 px-6 rounded-xl border-2 border-gray-700 text-gray-400 font-bold text-sm uppercase tracking-wider hover:border-gray-500 transition-all';
            } else if (cardBtn) {
                cardBtn.style.borderColor = isCard ? '#ef4444' : '#333';
                cardBtn.style.color = isCard ? '#fff' : '#888';
            }
            if (qrBtn && qrBtn.classList) {
                qrBtn.className = !isCard
                    ? 'flex-1 py-4 px-6 rounded-xl border-2 border-red-500 bg-red-600/10 text-white font-bold text-sm uppercase tracking-wider transition-all'
                    : 'flex-1 py-4 px-6 rounded-xl border-2 border-gray-700 text-gray-400 font-bold text-sm uppercase tracking-wider hover:border-gray-500 transition-all';
            } else if (qrBtn) {
                qrBtn.style.borderColor = !isCard ? 'var(--primary-color)' : '#333';
                qrBtn.style.color = !isCard ? '#fff' : '#888';
            }
            setPaymentPanelVisible('panel-card', isCard);
            setPaymentPanelVisible('panel-qr', !isCard);
            if (!isCard) loadQrCode();
        }
        window.selectPaymentMethod = selectPaymentMethod;

        const CARD_NUMBER_PATTERN = /^9704-0000-1111-\d{4}$/;
        const PIN_LENGTH = 6;

        function maskCardNumber(value) {
            if (!value || value.length < 4) return value || '';
            return '**** **** **** ' + value.slice(-4);
        }

        function validateCardPaymentInput() {
            const cardInput = document.getElementById('payment-card-number');
            const pinInput = document.getElementById('payment-pin');
            const cardNumber = cardInput ? cardInput.value : '';
            const pin = pinInput ? pinInput.value : '';

            if (!cardNumber) {
                alert('Vui lòng nhập số thẻ thanh toán!');
                if (cardInput) cardInput.focus();
                return false;
            }
            if (!CARD_NUMBER_PATTERN.test(cardNumber)) {
                alert('Số thẻ thanh toán không hợp lệ! Vui lòng nhập chính xác theo định dạng: 9704-0000-1111-0001');
                if (cardInput) cardInput.focus();
                return false;
            }
            if (!pin) {
                alert('Vui lòng nhập mã PIN!');
                if (pinInput) pinInput.focus();
                return false;
            }
            if (pin.length !== PIN_LENGTH || !/^\d+$/.test(pin)) {
                alert('Mã PIN phải khớp chính xác với mã PIN của thẻ trong hệ thống (6 chữ số)!');
                if (pinInput) pinInput.focus();
                return false;
            }
            return true;
        }

        function showPinError(message) {
            document.querySelectorAll('#payment-pin-error').forEach(function (el) {
                el.textContent = message || '';
                el.classList.toggle('hidden', !message);
            });
        }

        function advanceBookingStep(n) {
            const newStep = currentStep + n;
            if (newStep < 1 || newStep > 4) return;
            document.getElementById('step-' + currentStep).classList.add('hidden');
            document.getElementById('step-idx-' + currentStep).classList.remove('active');
            currentStep = newStep;
            document.getElementById('step-' + currentStep).classList.remove('hidden');
            document.getElementById('step-idx-' + currentStep).classList.add('active');
            updateBookingNavLabels();
        }

        function verifyCardPinWithServer(cardNumber, pin) {
            const body = new URLSearchParams();
            body.append('cardNumber', cardNumber);
            body.append('pinCode', pin);
            return fetch(contextPath + '/customer/api/verify-card-pin', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: body.toString()
            }).then(function (res) { return res.json(); });
        }

        function applyQrPaymentData(data) {
            if (!data || data.error) {
                if (data && data.error) alert(data.error);
                qrTransactionCode = '';
                return;
            }
            const fmt = n => new Intl.NumberFormat('vi-VN').format(n) + 'đ';
            document.querySelectorAll('#qr-code-image').forEach(img => { img.src = data.qrUrl || ''; });
            document.querySelectorAll('#qr-transaction-code').forEach(el => { el.innerText = data.transactionCode || ''; });
            document.querySelectorAll('#qr-amount-display').forEach(el => { el.innerText = fmt(data.amount || 0); });
            document.querySelectorAll('.qr-bank-name').forEach(el => { el.innerText = data.bankName || 'Vietcombank'; });
            document.querySelectorAll('.qr-account-number').forEach(el => { el.innerText = data.accountNumber || '—'; });
            document.querySelectorAll('.qr-account-name').forEach(el => { el.innerText = data.accountName || 'STARLIGHT CINEMA'; });
            qrTransactionCode = data.transactionCode || '';
        }

        function loadQrCode() {
            const total = selectedSeats.reduce((sum, s) => sum + getSeatPrice(), 0);
            if (total <= 0) {
                alert('Vui lòng chọn ghế trước khi tạo mã QR!');
                return;
            }
            fetch(contextPath + '/customer/api/qr-code?amount=' + total, {
                headers: { 'Accept': 'application/json' }
            })
                .then(async res => {
                    const data = await res.json();
                    if (!res.ok) throw new Error(data.error || 'Không tạo được mã QR');
                    return data;
                })
                .then(applyQrPaymentData)
                .catch(err => alert(err.message || 'Không tạo được mã QR thanh toán!'));
        }
        window.loadQrCode = loadQrCode;

        function populateConfirmForm() {
            const total = selectedSeats.reduce((sum, s) => sum + getSeatPrice(), 0);
            const fmt = n => new Intl.NumberFormat('vi-VN').format(n) + 'đ';

            document.getElementById('confirm-movie-title').innerText = document.getElementById('modal-movie-title').innerText;
            document.getElementById('confirm-date').innerText = document.getElementById('summary-date').innerText;
            document.getElementById('confirm-time').innerText = selectedTime || '--:--';
            document.getElementById('confirm-total').innerText = fmt(total);

            const seatsList = document.getElementById('confirm-seats-list');
            seatsList.innerHTML = '';
            selectedSeats.forEach(s => {
                const price = getSeatPrice();
                const row = document.createElement('div');
                row.className = 'flex justify-between text-gray-300';
                row.innerHTML = '<span>Ghế <strong class="text-white">' + s.id + '</strong></span><span>' + fmt(price) + '</span>';
                seatsList.appendChild(row);
            });

            if (paymentMethod === 'Card') {
                const cardNumber = document.getElementById('payment-card-number').value;
                document.getElementById('confirm-payment-method').innerHTML = '<i class="fas fa-credit-card mr-1"></i> Thẻ tín dụng';
                document.getElementById('confirm-payment-detail').innerText = 'Thẻ: ' + maskCardNumber(cardNumber);
            } else {
                document.getElementById('confirm-payment-method').innerHTML = '<i class="fas fa-qrcode mr-1"></i> Mã QR';
                document.getElementById('confirm-payment-detail').innerText = qrTransactionCode
                    ? 'Mã giao dịch: ' + qrTransactionCode : 'Thanh toán qua ví điện tử / ngân hàng';
            }
            document.getElementById('confirm-agree').checked = false;
        }

        function submitBooking() {
            if (paymentMethod === 'Card') {
                document.getElementById('form-card-number').value = document.getElementById('payment-card-number').value;
                document.getElementById('form-payment-id').value = '';
                document.getElementById('form-pin-code').value = document.getElementById('payment-pin').value;
                document.getElementById('form-qr-transaction-code').value = '';
            } else {
                document.getElementById('form-card-number').value = '';
                document.getElementById('form-payment-id').value = '';
                document.getElementById('form-pin-code').value = '';
                document.getElementById('form-qr-transaction-code').value = qrTransactionCode || '';
            }
            document.getElementById('submit-booking-form').submit();
        }

        function closeBooking() {
            document.getElementById('booking-modal').classList.add('hidden');
            document.body.style.overflow = 'auto';
            currentStep = 1;
            updateBookingNavLabels();
        }

        window.closeBooking = closeBooking;

        window.changeStep = function changeStep(n) {
            if (n === -1 && currentStep === 1) { closeBooking(); return; }

            if (n === 1) {
                if (currentStep === 1 && !selectedTime) {
                    alert('Vui lòng chọn suất chiếu để tiếp tục!'); return;
                }
                if (currentStep === 2 && selectedSeats.length === 0) {
                    alert('Vui lòng chọn ít nhất một chỗ ngồi!'); return;
                }
                if (currentStep === 3) {
                    const checkLogin = "${sessionScope.loggedInUser != null ? 'true' : 'false'}";
                    if (checkLogin === 'false') {
                        alert('Vui lòng đăng nhập để tiến hành thanh toán!');
                        window.location.href = contextPath + '/login-customer'; return;
                    }
                    if (paymentMethod === 'Card') {
                        if (!validateCardPaymentInput()) return;
                        showPinError('');
                        const cardNumber = document.getElementById('payment-card-number').value;
                        const pin = document.getElementById('payment-pin').value;
                        verifyCardPinWithServer(cardNumber, pin)
                            .then(function (data) {
                                if (!data.valid) {
                                    const msg = data.error || 'Mã PIN không chính xác! Vui lòng nhập đúng mã PIN của thẻ.';
                                    showPinError(msg);
                                    alert(msg);
                                    document.getElementById('payment-pin').focus();
                                    return;
                                }
                                showPinError('');
                                populateConfirmForm();
                                advanceBookingStep(1);
                            })
                            .catch(function () {
                                alert('Không thể xác minh mã PIN. Vui lòng thử lại.');
                            });
                        return;
                    } else if (paymentMethod === 'QR') {
                        if (!qrTransactionCode) {
                            alert('Vui lòng tạo mã QR thanh toán trước khi tiếp tục!');
                            loadQrCode();
                            return;
                        }
                    }
                    populateConfirmForm();
                }
                if (currentStep === 4) {
                    if (!document.getElementById('confirm-agree').checked) {
                        alert('Vui lòng xác nhận thông tin đặt vé trước khi thanh toán!'); return;
                    }
                    submitBooking();
                    return;
                }
                if (currentStep === 2) {
                    loadQrCode();
                }
            }

            advanceBookingStep(n);
        }
    </script>

    <!-- Import JS duy nhất xử lý đồng bộ Sidebar -->
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

    <script>
        // Check for messages from the server and display notifications
        <c:if test="${not empty successMessage}">
            window.showNotification('${successMessage}', 'success');
        </c:if>
        <c:if test="${not empty errorMessage}">
            window.showNotification('${errorMessage}', 'error');
        </c:if>
    </script>
</body>
</html>