<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="staff-booking-modal" class="fixed inset-0 z-[200] bg-black/95 backdrop-blur-xl hidden flex items-center justify-center p-4">
    <div class="bg-[#121212] border border-gray-800 w-full max-w-5xl h-[90vh] rounded-[2.5rem] overflow-hidden flex shadow-2xl">
        <div class="flex-1 p-6 md:p-10 overflow-y-auto flex flex-col">
            <div class="flex items-center justify-between mb-6 shrink-0">
                <button type="button" onclick="staffChangeStep(-1)" class="text-gray-400 hover:text-white text-xs font-bold uppercase flex items-center gap-2">
                    <i class="fas fa-arrow-left"></i>
                    <span id="staff-btn-top-back-label">Quay lại</span>
                </button>
                <button type="button" onclick="closeStaffBooking()" class="w-10 h-10 rounded-full bg-[#1a1a1a] border border-gray-700 text-gray-400 hover:text-white flex items-center justify-center" title="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="flex gap-4 md:gap-6 mb-8 text-[10px] font-black uppercase tracking-[0.2em] flex-wrap shrink-0">
                <div id="staff-step-idx-1" class="text-gray-600 pb-2">01. Suất Chiếu</div>
                <div id="staff-step-idx-2" class="text-gray-600 pb-2">02. Chọn Ghế</div>
                <div id="staff-step-idx-3" class="text-gray-600 pb-2">03. Thanh Toán</div>
                <div id="staff-step-idx-4" class="text-gray-600 pb-2">04. Xác Nhận</div>
            </div>

            <div id="staff-step-1" class="staff-booking-step space-y-8 flex-1">
                <h3 class="text-2xl font-black text-white uppercase">Chọn ngày &amp; giờ chiếu</h3>
                <div class="space-y-3">
                    <p class="text-[10px] text-gray-500 font-bold uppercase">Ngày chiếu</p>
                    <div class="relative inline-flex items-center gap-2">
                        <input type="date" id="staff-pick-date-input" value="${selectedDate}"
                               class="bg-[#0b0c10] border border-gray-700 text-white text-sm rounded-xl px-4 py-2.5 focus:outline-none focus:border-blue-500 min-w-[180px]">
                        <button type="button" id="staff-btn-open-calendar"
                                class="w-11 h-11 rounded-xl bg-blue-600/15 border border-blue-500/40 text-blue-400 hover:bg-blue-600 hover:text-white hover:border-blue-500 flex items-center justify-center transition-all"
                                title="Chọn ngày có suất chiếu của phim">
                            <i class="fas fa-calendar-alt text-lg"></i>
                        </button>
                        <div id="staff-movie-calendar-popup"
                             class="hidden absolute top-full left-0 mt-2 z-[300] w-[300px] bg-[#161616] border border-gray-700 rounded-2xl shadow-2xl p-4">
                            <div class="flex items-center justify-between mb-3">
                                <button type="button" id="staff-cal-prev" class="w-8 h-8 rounded-lg border border-gray-700 text-gray-400 hover:text-white hover:border-blue-500">
                                    <i class="fas fa-chevron-left text-xs"></i>
                                </button>
                                <span id="staff-cal-month-label" class="text-white text-sm font-bold uppercase"></span>
                                <button type="button" id="staff-cal-next" class="w-8 h-8 rounded-lg border border-gray-700 text-gray-400 hover:text-white hover:border-blue-500">
                                    <i class="fas fa-chevron-right text-xs"></i>
                                </button>
                            </div>
                            <div class="grid grid-cols-7 gap-1 text-center text-[10px] text-gray-500 font-bold mb-2">
                                <span>T2</span><span>T3</span><span>T4</span><span>T5</span><span>T6</span><span>T7</span><span>CN</span>
                            </div>
                            <div id="staff-cal-days" class="grid grid-cols-7 gap-1"></div>
                            <p class="text-[10px] text-gray-500 mt-3 flex items-center gap-2">
                                <span class="inline-block w-2 h-2 rounded-full bg-blue-500"></span>
                                Chỉ các ngày có suất chiếu mới chọn được
                            </p>
                        </div>
                    </div>
                </div>
                <div id="staff-dynamic-date-list" class="flex gap-3 overflow-x-auto pb-4"></div>
                <div id="staff-dynamic-time-slots" class="flex flex-wrap gap-3"></div>
            </div>

            <div id="staff-step-2" class="staff-booking-step hidden space-y-8 flex-1">
                <div class="w-4/5 h-1 bg-gradient-to-r from-transparent via-gray-700 to-transparent mx-auto relative rounded-full">
                    <span class="absolute -top-6 left-1/2 -translate-x-1/2 text-[10px] text-gray-500 font-bold tracking-[0.5em]">MÀN HÌNH</span>
                </div>
                <div id="staff-seat-grid" class="grid gap-2 justify-center"></div>
                <div class="flex flex-wrap justify-center gap-5 text-[10px] font-bold uppercase tracking-wider">
                    <div class="flex items-center gap-2">
                        <div class="w-6 h-6 rounded-t-lg rounded-b-sm bg-gradient-to-b from-blue-500 to-blue-600 border-b-2 border-blue-800"></div>
                        <span class="text-blue-400">Trống</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <div class="w-6 h-6 rounded-t-lg rounded-b-sm bg-yellow-500 border-b-2 border-yellow-700"></div>
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

            <div id="staff-step-3" class="staff-booking-step hidden space-y-8 flex-1">
                <h3 class="text-2xl font-black text-white uppercase">Thanh toán tại quầy</h3>

                <div class="bg-[#1a1a1a] border border-gray-800 rounded-2xl p-6 space-y-4">
                    <div class="flex items-center justify-between gap-3">
                        <p class="text-sm font-bold text-white uppercase tracking-wider">
                            <i class="fas fa-user text-blue-500 mr-2"></i> Thông tin khách hàng
                        </p>
                        <span id="staff-customer-mode-badge" class="text-[10px] font-bold uppercase px-2 py-1 rounded-lg bg-gray-800 text-gray-400">Chưa kiểm tra</span>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-[10px] text-gray-500 font-bold uppercase mb-2">Số điện thoại</label>
                            <input type="tel" id="staff-customer-phone" placeholder="0902000001"
                                class="w-full bg-[#0b0c10] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-blue-500">
                        </div>
                        <div>
                            <label class="block text-[10px] text-gray-500 font-bold uppercase mb-2">Email</label>
                            <input type="email" id="staff-customer-email" placeholder="email@gmail.com"
                                class="w-full bg-[#0b0c10] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-blue-500">
                        </div>
                        <div class="md:col-span-2">
                            <button type="button" id="staff-btn-check-contact"
                                class="w-full md:w-auto px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold uppercase">
                                <i class="fas fa-search mr-2"></i> Kiểm tra SĐT / Email trong hệ thống
                            </button>
                            <p id="staff-customer-contact-hint" class="text-xs mt-2 text-gray-500"></p>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-[10px] text-gray-500 font-bold uppercase mb-2">Họ tên khách hàng</label>
                            <input type="text" id="staff-customer-name" placeholder="Tự động hiển thị khi SĐT/email đã có trong hệ thống" disabled
                                class="w-full bg-[#0b0c10] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-blue-500 disabled:opacity-50 disabled:cursor-not-allowed">
                            <p id="staff-customer-name-hint" class="text-xs mt-2 text-gray-500"></p>
                        </div>
                    </div>
                    <div id="staff-customer-found" class="hidden bg-green-500/10 border border-green-500/30 rounded-xl p-4 text-sm">
                        <p class="text-green-400 font-bold text-xs uppercase mb-1"><i class="fas fa-check-circle mr-1"></i> Đã xác định khách hàng</p>
                        <p class="text-white font-semibold" id="staff-customer-found-name"></p>
                        <p class="text-gray-400 text-xs mt-1"><span id="staff-customer-found-phone"></span> · <span id="staff-customer-found-email"></span></p>
                    </div>
                    <p id="staff-customer-error" class="hidden text-xs text-red-400 font-bold"></p>
                </div>

                <div class="flex gap-4 mb-2">
                    <button type="button" onclick="staffSelectPaymentMethod('QR')" id="staff-btn-pay-qr"
                        class="flex-1 py-4 px-6 rounded-xl border-2 border-blue-500 bg-blue-600/10 text-white font-bold text-sm uppercase tracking-wider transition-all">
                        <i class="fas fa-qrcode mr-2"></i> Mã QR
                    </button>
                    <button type="button" onclick="staffSelectPaymentMethod('Cash')" id="staff-btn-pay-cash"
                        class="flex-1 py-4 px-6 rounded-xl border-2 border-gray-700 text-gray-400 font-bold text-sm uppercase tracking-wider hover:border-gray-500 transition-all">
                        <i class="fas fa-money-bill-wave mr-2"></i> Tiền mặt
                    </button>
                </div>
                <p class="text-xs text-gray-500 italic">Mã QR và thông tin ngân hàng sẽ hiển thị ở bước xác nhận.</p>
            </div>

            <div id="staff-step-4" class="staff-booking-step hidden space-y-6 flex-1 overflow-y-auto">
                <h3 class="text-2xl font-black text-white uppercase">Xác nhận đơn đặt vé</h3>

                <div class="bg-[#1a1a1a] border border-gray-800 rounded-2xl p-6">
                    <p class="text-[10px] text-gray-500 font-bold uppercase mb-3"><i class="fas fa-user text-blue-500 mr-1"></i> Thông tin khách hàng</p>
                    <p id="staff-confirm-customer-name" class="text-white font-bold text-lg"></p>
                    <p id="staff-confirm-customer-contact" class="text-gray-400 text-sm mt-1"></p>
                </div>

                <div class="bg-[#1a1a1a] border border-gray-800 rounded-2xl overflow-hidden">
                    <div class="p-6 border-b border-gray-800">
                        <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Phim</p>
                        <p id="staff-confirm-movie-title" class="text-white font-bold text-lg"></p>
                    </div>
                    <div class="p-6 border-b border-gray-800 grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Ngày chiếu</p>
                            <p id="staff-confirm-date" class="text-white font-bold"></p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Giờ chiếu</p>
                            <p id="staff-confirm-time" class="text-blue-500 font-bold"></p>
                        </div>
                    </div>
                    <div class="p-6 border-b border-gray-800">
                        <p class="text-[10px] text-gray-500 font-bold uppercase mb-3">Chi tiết ghế</p>
                        <div id="staff-confirm-seats-list" class="space-y-2 text-sm"></div>
                    </div>
                    <div class="p-6 flex justify-between items-center bg-[#0b0c10]">
                        <span class="text-gray-400 font-bold uppercase text-xs">Tổng thanh toán</span>
                        <span id="staff-confirm-total" class="text-2xl font-black text-blue-500"></span>
                    </div>
                </div>

                <div class="bg-[#1a1a1a] border border-gray-800 rounded-2xl p-6 space-y-4">
                    <p class="text-[10px] text-gray-500 font-bold uppercase mb-1"><i class="fas fa-credit-card text-blue-500 mr-1"></i> Phương thức thanh toán</p>
                    <p id="staff-confirm-payment-method" class="text-white font-bold text-base"></p>
                    <p id="staff-confirm-payment-detail" class="text-gray-400 text-sm"></p>

                    <div id="staff-confirm-panel-qr" class="hidden bg-[#0b0c10] border border-gray-800 rounded-2xl p-6 text-center space-y-4 mt-4">
                        <img id="staff-confirm-qr-code-image" src="" alt="QR Thanh toán" class="mx-auto w-52 h-52 rounded-xl border border-gray-700 bg-white p-2">
                        <p class="text-white font-bold">Quét mã QR để thanh toán</p>
                        <table class="w-full text-left text-xs border border-gray-800 rounded-xl overflow-hidden">
                            <tbody class="divide-y divide-gray-800">
                                <tr class="bg-[#121212]"><td class="px-4 py-2 text-gray-500">Ngân hàng</td><td class="px-4 py-2 text-white font-bold text-right" id="staff-confirm-qr-bank-name">—</td></tr>
                                <tr><td class="px-4 py-2 text-gray-500">Số tài khoản</td><td class="px-4 py-2 text-white font-bold text-right" id="staff-confirm-qr-account-number">—</td></tr>
                                <tr class="bg-[#121212]"><td class="px-4 py-2 text-gray-500">Chủ tài khoản</td><td class="px-4 py-2 text-white font-bold text-right" id="staff-confirm-qr-account-name">—</td></tr>
                                <tr><td class="px-4 py-2 text-gray-500">Nội dung CK</td><td class="px-4 py-2 text-gray-400 font-mono text-[10px] text-right break-all" id="staff-confirm-qr-transaction-code"></td></tr>
                                <tr class="bg-[#121212]"><td class="px-4 py-2 text-gray-500">Số tiền</td><td class="px-4 py-2 text-blue-500 font-black text-right" id="staff-confirm-qr-amount-display">0đ</td></tr>
                            </tbody>
                        </table>
                        <button type="button" onclick="staffLoadQrCode()" class="text-xs text-gray-400 hover:text-white underline">Tạo lại mã QR</button>
                    </div>

                    <div id="staff-confirm-panel-cash" class="hidden bg-[#0b0c10] border border-gray-800 rounded-2xl p-6 space-y-4 mt-4">
                        <div class="text-center">
                            <div class="w-14 h-14 rounded-full bg-green-500/10 text-green-500 flex items-center justify-center mx-auto text-xl mb-3">
                                <i class="fas fa-cash-register"></i>
                            </div>
                            <p class="text-white font-bold">Thanh toán tiền mặt tại quầy</p>
                            <p class="text-gray-500 text-sm mt-1">Nhập số tiền khách đưa để tính tiền thối lại.</p>
                        </div>
                        <div class="text-left space-y-4">
                            <div>
                                <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Số tiền cần thanh toán</p>
                                <p class="text-blue-500 font-black text-2xl" id="staff-confirm-cash-amount-display">0đ</p>
                            </div>
                            <div>
                                <label for="staff-cash-received-input" class="text-[10px] text-gray-500 font-bold uppercase mb-1 block">Số tiền khách đưa</label>
                                <input type="number" id="staff-cash-received-input" min="0" step="1000" placeholder="Nhập số tiền..."
                                    oninput="staffUpdateCashChange()"
                                    class="w-full bg-[#121212] border border-gray-700 rounded-xl px-4 py-3 text-white font-bold text-lg focus:border-green-500 outline-none">
                            </div>
                            <div class="bg-[#121212] border border-gray-800 rounded-xl p-4 flex justify-between items-center">
                                <span class="text-gray-400 text-sm font-bold uppercase">Tiền thối lại</span>
                                <span id="staff-cash-change-display" class="text-gray-500 font-black text-xl">—</span>
                            </div>
                        </div>
                    </div>
                </div>

                <label class="flex items-start gap-3 cursor-pointer">
                    <input type="checkbox" id="staff-confirm-agree" class="mt-1 w-4 h-4 accent-blue-600 cursor-pointer">
                    <span class="text-sm text-gray-400">Tôi xác nhận thông tin đặt vé và thanh toán ở trên là chính xác.</span>
                </label>
            </div>

            <div class="flex justify-between items-center gap-4 mt-8 pt-6 border-t border-gray-800 shrink-0">
                <button type="button" onclick="staffChangeStep(-1)" class="text-gray-500 hover:text-white font-bold text-xs uppercase px-6 py-3">
                    <i class="fas fa-arrow-left mr-2"></i> Quay lại
                </button>
                <button type="button" id="staff-btn-main-next" onclick="staffChangeStep(1)" class="bg-blue-600 hover:bg-blue-700 text-white font-black py-3 px-8 rounded-xl text-xs uppercase tracking-widest">
                    Tiếp tục
                </button>
            </div>
        </div>

        <div class="hidden md:flex w-80 bg-[#080808] border-l border-gray-800 p-10 flex-col">
            <img id="staff-modal-movie-poster" src="" class="w-full aspect-[2/3] object-cover rounded-2xl shadow-2xl mb-6" alt="Poster">
            <h3 id="staff-modal-movie-title" class="text-xl font-bold text-white mb-8 leading-tight">Tên Phim</h3>
            <div class="space-y-6 flex-1 text-sm">
                <div class="border-b border-gray-800 pb-4">
                    <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Thời gian</p>
                    <p class="text-white font-bold"><span id="staff-summary-date">—</span> | <span id="staff-summary-time" class="text-blue-500">--:--</span></p>
                </div>
                <div class="border-b border-gray-800 pb-4">
                    <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Ghế chọn</p>
                    <p id="staff-summary-seats" class="text-white font-bold">Chưa chọn ghế</p>
                    <div id="staff-summary-seats-detail" class="mt-2 space-y-1.5 max-h-36 overflow-y-auto"></div>
                </div>
                <div class="mt-auto">
                    <p class="text-[10px] text-gray-500 font-bold uppercase mb-1">Tổng tiền</p>
                    <p id="staff-summary-total" class="text-3xl font-black text-blue-500">0đ</p>
                </div>
            </div>
        </div>
    </div>
</div>

<form id="staff-submit-booking-form" action="${pageContext.request.contextPath}/staff/booking/checkout" method="POST" class="hidden">
    <input type="hidden" name="showtimeId" id="staff-form-showtime-id">
    <input type="hidden" name="selectedSeats" id="staff-form-selected-seats">
    <input type="hidden" name="paymentMethod" id="staff-form-payment-method" value="QR">
    <input type="hidden" name="qrTransactionCode" id="staff-form-qr-transaction-code">
    <input type="hidden" name="returnDate" id="staff-form-return-date" value="${selectedDate}">
    <input type="hidden" name="customerFullName" id="staff-form-customer-name">
    <input type="hidden" name="customerPhone" id="staff-form-customer-phone">
    <input type="hidden" name="customerEmail" id="staff-form-customer-email">
</form>

<style>
    .staff-seat {
        width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;
        font-size: 10px; font-weight: 700; border-radius: 10px 10px 4px 4px; cursor: pointer;
        background: linear-gradient(to bottom, #3b82f6, #2563eb); color: #fff;
        border-bottom: 3px solid #1d4ed8;
        box-shadow: 0 0 12px rgba(59, 130, 246, 0.45);
        transition: all 0.2s;
    }
    .staff-seat:hover:not(.sold):not(.maintenance):not(.selected) { transform: translateY(-2px); }
    .staff-seat.sold {
        background: #eab308; color: #713f12; border-bottom: 3px solid #a16207;
        cursor: not-allowed;
    }
    .staff-seat.maintenance {
        background: rgba(55, 65, 81, 0.85); color: #9ca3af; border-bottom: 3px solid #111827;
        cursor: not-allowed; opacity: 0.75;
    }
    .staff-seat.selected {
        background: linear-gradient(to bottom, #22c55e, #16a34a) !important;
        border-bottom-color: #15803d !important; color: #fff !important;
    }
    .staff-date-btn {
        padding: 12px 20px; border-radius: 12px; border: 1px solid #333; background: #1e1e1e;
        color: #aaa; font-weight: 700; font-size: 12px; white-space: nowrap; cursor: pointer;
    }
    .staff-date-btn.active { border-color: #3b82f6; color: #fff; background: rgba(59, 130, 246, 0.15); }
    #staff-step-idx-1.active, #staff-step-idx-2.active, #staff-step-idx-3.active, #staff-step-idx-4.active {
        color: #3b82f6; border-bottom: 2px solid #3b82f6;
    }
    .staff-cal-day {
        width: 100%; aspect-ratio: 1; border: none; border-radius: 8px;
        font-size: 11px; font-weight: 700; cursor: pointer; background: transparent; color: #666;
    }
    .staff-cal-day.other-month { color: #333; }
    .staff-cal-day.has-showtime { color: #e5e7eb; position: relative; }
    .staff-cal-day.has-showtime::after {
        content: ''; position: absolute; bottom: 3px; left: 50%; transform: translateX(-50%);
        width: 4px; height: 4px; border-radius: 50%; background: #3b82f6;
    }
    .staff-cal-day.has-showtime:hover { background: rgba(59, 130, 246, 0.15); color: #fff; }
    .staff-cal-day.selected { background: #3b82f6 !important; color: #fff !important; }
    .staff-cal-day.selected.has-showtime::after { background: #fff; }
    .staff-cal-day:disabled { cursor: not-allowed; opacity: 0.35; }
</style>

<script>
(function () {
    const contextPath = '${pageContext.request.contextPath}';
    const staffPageDate = '${selectedDate}';
    let staffCurrentStep = 1;
    let staffCurrentMovieId = null;
    let staffTicketPrice = 85000;
    let staffSelectedDate = staffPageDate;
    let staffSelectedTime = null;
    let staffSelectedShowtimeId = null;
    let staffSelectedSeats = [];
    let staffPaymentMethod = 'QR';
    let staffQrTransactionCode = '';
    let staffMovieShowDates = new Set();
    let staffCalendarView = new Date();
    let staffCalendarOpen = false;
    let staffCustomerContactExists = null;
    let staffCustomerContactConflict = false;
    let staffResolvedCustomer = null;

    const monthNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
        'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];

    function staffShowCustomerError(msg) {
        const el = document.getElementById('staff-customer-error');
        if (!el) return;
        if (msg) {
            el.textContent = msg;
            el.classList.remove('hidden');
        } else {
            el.textContent = '';
            el.classList.add('hidden');
        }
    }

    function staffResetCustomerForm() {
        staffCustomerContactExists = null;
        staffCustomerContactConflict = false;
        staffResolvedCustomer = null;
        const nameEl = document.getElementById('staff-customer-name');
        const phoneEl = document.getElementById('staff-customer-phone');
        const emailEl = document.getElementById('staff-customer-email');
        if (nameEl) { nameEl.value = ''; nameEl.disabled = true; }
        if (phoneEl) phoneEl.value = '';
        if (emailEl) emailEl.value = '';
        document.getElementById('staff-customer-contact-hint').textContent = '';
        document.getElementById('staff-customer-name-hint').textContent = '';
        document.getElementById('staff-customer-mode-badge').textContent = 'Chưa kiểm tra';
        document.getElementById('staff-customer-mode-badge').className = 'text-[10px] font-bold uppercase px-2 py-1 rounded-lg bg-gray-800 text-gray-400';
        document.getElementById('staff-customer-found').classList.add('hidden');
        staffShowCustomerError('');
    }

    function staffShowResolvedCustomer(customer) {
        if (!customer) return;
        staffResolvedCustomer = customer;
        const nameEl = document.getElementById('staff-customer-name');
        const phoneEl = document.getElementById('staff-customer-phone');
        const emailEl = document.getElementById('staff-customer-email');
        if (nameEl) {
            nameEl.value = customer.fullName || '';
            nameEl.disabled = true;
        }
        if (phoneEl && customer.phone) phoneEl.value = customer.phone;
        if (emailEl && customer.email) emailEl.value = customer.email;
        document.getElementById('staff-customer-found-name').innerText = customer.fullName || '—';
        document.getElementById('staff-customer-found-phone').innerText = customer.phone || phoneEl?.value || '—';
        document.getElementById('staff-customer-found-email').innerText = customer.email || emailEl?.value || '—';
        document.getElementById('staff-customer-found').classList.remove('hidden');
    }

    function staffApplyCustomerMode(exists, conflict, message, customer) {
        staffCustomerContactExists = exists;
        staffCustomerContactConflict = !!conflict;
        staffResolvedCustomer = null;
        const badge = document.getElementById('staff-customer-mode-badge');
        const contactHint = document.getElementById('staff-customer-contact-hint');
        const nameHint = document.getElementById('staff-customer-name-hint');
        const nameEl = document.getElementById('staff-customer-name');
        const foundBox = document.getElementById('staff-customer-found');
        contactHint.textContent = message || '';
        nameHint.textContent = '';
        foundBox.classList.add('hidden');
        staffShowCustomerError('');

        if (conflict) {
            badge.textContent = 'Lỗi thông tin';
            badge.className = 'text-[10px] font-bold uppercase px-2 py-1 rounded-lg bg-red-500/10 text-red-400';
            if (nameEl) { nameEl.value = ''; nameEl.disabled = true; }
            return;
        }

        if (exists && customer) {
            badge.textContent = 'Khách đã có';
            badge.className = 'text-[10px] font-bold uppercase px-2 py-1 rounded-lg bg-blue-500/10 text-blue-400';
            nameHint.textContent = 'Họ tên được lấy tự động từ hệ thống. Hóa đơn sẽ lưu vào lịch sử thanh toán của khách này.';
            staffShowResolvedCustomer(customer);
        } else {
            badge.textContent = 'Khách mới';
            badge.className = 'text-[10px] font-bold uppercase px-2 py-1 rounded-lg bg-green-500/10 text-green-400';
            if (nameEl) { nameEl.value = ''; nameEl.disabled = false; }
            nameHint.textContent = 'Nhập họ tên đầy đủ. Hệ thống sẽ tạo tài khoản CUSTOMER mới (mật khẩu mặc định: Pass@123).';
        }
    }

    function staffCheckCustomerContact() {
        const phone = (document.getElementById('staff-customer-phone').value || '').trim();
        const email = (document.getElementById('staff-customer-email').value || '').trim();
        if (!phone && !email) {
            staffShowCustomerError('Vui lòng nhập số điện thoại hoặc email khách hàng!');
            return Promise.resolve(false);
        }
        let url = contextPath + '/staff/api/customer/check-contact?';
        if (phone) url += 'phone=' + encodeURIComponent(phone) + '&';
        if (email) url += 'email=' + encodeURIComponent(email);
        return fetch(url, { headers: { 'Accept': 'application/json' } })
            .then(res => res.json())
            .then(data => {
                if (data.error) {
                    staffShowCustomerError(data.error);
                    staffApplyCustomerMode(false, false, data.message || data.error, null);
                    return false;
                }
                staffApplyCustomerMode(!!data.exists, !!data.conflict, data.message || '', data.customer || null);
                if (data.conflict) {
                    staffShowCustomerError(data.message || 'Thông tin liên hệ không khớp!');
                    return false;
                }
                return true;
            })
            .catch(() => {
                staffShowCustomerError('Không kiểm tra được thông tin liên hệ. Vui lòng thử lại!');
                return false;
            });
    }

    function staffValidateCustomerInfo() {
        const name = (document.getElementById('staff-customer-name').value || '').trim();
        const phone = (document.getElementById('staff-customer-phone').value || '').trim();
        const email = (document.getElementById('staff-customer-email').value || '').trim();

        if (!phone && !email) {
            staffShowCustomerError('Vui lòng nhập số điện thoại hoặc email!');
            return false;
        }
        if (staffCustomerContactExists === null) {
            staffShowCustomerError('Vui lòng bấm "Kiểm tra SĐT / Email" trước!');
            return false;
        }
        if (staffCustomerContactConflict) {
            staffShowCustomerError('Số điện thoại và email thuộc hai tài khoản khác nhau!');
            return false;
        }
        if (staffCustomerContactExists) {
            if (!staffResolvedCustomer) {
                staffShowCustomerError('Không xác định được khách hàng. Vui lòng kiểm tra lại SĐT hoặc email!');
                return false;
            }
        } else {
            if (!name) {
                staffShowCustomerError('Vui lòng nhập họ tên khách hàng!');
                return false;
            }
            if (!phone) {
                staffShowCustomerError('Khách mới — vui lòng nhập số điện thoại!');
                return false;
            }
            if (!email) {
                staffShowCustomerError('Khách mới — vui lòng nhập email!');
                return false;
            }
            if (!/^(0|\+84)[0-9]{9}$/.test(phone)) {
                staffShowCustomerError('Số điện thoại không hợp lệ (10 số, bắt đầu 0 hoặc +84)!');
                return false;
            }
            if (!/^[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}$/.test(email)) {
                staffShowCustomerError('Email không đúng định dạng!');
                return false;
            }
        }
        staffShowCustomerError('');
        return true;
    }

    function fmtDateLabel(dateStr) {
        if (!dateStr) return '—';
        const d = new Date(dateStr + 'T12:00:00');
        return d.getDate() + '/' + (d.getMonth() + 1) + '/' + d.getFullYear();
    }

    function staffLoadMovieShowDates(movieId) {
        staffMovieShowDates = new Set();
        if (!movieId) return Promise.resolve();
        return fetch(contextPath + '/staff/api/show-dates?movieId=' + movieId, { headers: { 'Accept': 'application/json' } })
            .then(res => res.json())
            .then(dates => {
                (dates || []).forEach(d => staffMovieShowDates.add(d));
            })
            .catch(() => {});
    }

    function staffCloseCalendarPopup() {
        staffCalendarOpen = false;
        const popup = document.getElementById('staff-movie-calendar-popup');
        if (popup) popup.classList.add('hidden');
    }

    function staffToggleCalendarPopup() {
        if (!staffCurrentMovieId) return;
        staffCalendarOpen = !staffCalendarOpen;
        const popup = document.getElementById('staff-movie-calendar-popup');
        if (!popup) return;
        if (staffCalendarOpen) {
            const base = staffSelectedDate ? new Date(staffSelectedDate + 'T12:00:00') : new Date();
            staffCalendarView = new Date(base.getFullYear(), base.getMonth(), 1);
            staffRenderMovieCalendar();
            popup.classList.remove('hidden');
        } else {
            popup.classList.add('hidden');
        }
    }

    function staffRenderMovieCalendar() {
        const daysEl = document.getElementById('staff-cal-days');
        const monthLabel = document.getElementById('staff-cal-month-label');
        if (!daysEl || !monthLabel) return;

        const year = staffCalendarView.getFullYear();
        const month = staffCalendarView.getMonth();
        monthLabel.innerText = monthNames[month] + ' ' + year;
        daysEl.innerHTML = '';

        const firstDay = new Date(year, month, 1);
        let startPad = firstDay.getDay() - 1;
        if (startPad < 0) startPad = 6;

        const daysInMonth = new Date(year, month + 1, 0).getDate();
        const prevMonthDays = new Date(year, month, 0).getDate();

        for (let i = 0; i < startPad; i++) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'staff-cal-day other-month';
            btn.disabled = true;
            btn.innerText = prevMonthDays - startPad + i + 1;
            daysEl.appendChild(btn);
        }

        for (let day = 1; day <= daysInMonth; day++) {
            const tz = new Date(year, month, day).getTimezoneOffset() * 60000;
            const dateStr = new Date(new Date(year, month, day).getTime() - tz).toISOString().split('T')[0];
            const hasShow = staffMovieShowDates.has(dateStr);
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'staff-cal-day' + (hasShow ? ' has-showtime' : '') + (dateStr === staffSelectedDate ? ' selected' : '');
            btn.innerText = day;
            btn.disabled = !hasShow;
            if (hasShow) {
                btn.onclick = () => {
                    staffApplySelectedDate(dateStr);
                    staffCloseCalendarPopup();
                };
            }
            daysEl.appendChild(btn);
        }
    }

    function staffApplySelectedDate(dateStr) {
        if (!dateStr) return;
        if (staffMovieShowDates.size > 0 && !staffMovieShowDates.has(dateStr)) {
            alert('Ngày này không có suất chiếu cho phim đã chọn!');
            return;
        }
        staffSelectedDate = dateStr;
        const dateInput = document.getElementById('staff-pick-date-input');
        if (dateInput) dateInput.value = dateStr;
        document.getElementById('staff-summary-date').innerText = fmtDateLabel(dateStr);
        staffSelectedTime = null;
        staffSelectedShowtimeId = null;
        document.getElementById('staff-summary-time').innerText = '--:--';
        document.getElementById('staff-form-showtime-id').value = '';

        document.querySelectorAll('.staff-date-btn').forEach(b => {
            if (b.dataset.date === dateStr) {
                b.classList.add('active');
            } else {
                b.classList.remove('active');
            }
        });

        if (staffCurrentMovieId) {
            staffFetchShowtimes(staffCurrentMovieId, dateStr);
        }
    }

    function fmtMoney(n) {
        return new Intl.NumberFormat('vi-VN').format(n) + 'đ';
    }

    function staffSetStepActive(step) {
        for (let i = 1; i <= 4; i++) {
            const idx = document.getElementById('staff-step-idx-' + i);
            const panel = document.getElementById('staff-step-' + i);
            if (idx) idx.classList.toggle('active', i === step);
            if (panel) panel.classList.toggle('hidden', i !== step);
        }
        staffCurrentStep = step;
        const nextBtn = document.getElementById('staff-btn-main-next');
        if (nextBtn) nextBtn.innerText = step === 4 ? 'Hoàn tất đặt vé' : 'Tiếp tục';
    }

    function staffResolveSeatStatus(seat) {
        if (seat.status) return seat.status;
        if (seat.sold) return 'Sold';
        if (seat.unavailable) return 'Maintenance';
        return 'Available';
    }

    function staffUpdateSummary() {
        const seatsEl = document.getElementById('staff-summary-seats');
        const detailEl = document.getElementById('staff-summary-seats-detail');
        if (staffSelectedSeats.length === 0) {
            seatsEl.innerText = 'Chưa chọn ghế';
            if (detailEl) detailEl.innerHTML = '';
        } else {
            seatsEl.innerText = staffSelectedSeats.map(s => s.id).join(', ');
            if (detailEl) {
                detailEl.innerHTML = '';
                staffSelectedSeats.forEach(s => {
                    const row = document.createElement('div');
                    row.className = 'flex justify-between items-center text-xs text-gray-400';
                    row.innerHTML = '<span>Ghế <span class="text-white font-semibold">' + s.id + '</span></span>' +
                        '<span class="text-blue-400 font-bold">' + fmtMoney(staffTicketPrice) + '</span>';
                    detailEl.appendChild(row);
                });
            }
        }
        const total = staffSelectedSeats.length * staffTicketPrice;
        document.getElementById('staff-summary-total').innerText = fmtMoney(total);
        return total;
    }

    function staffRenderSeats() {
        const grid = document.getElementById('staff-seat-grid');
        grid.innerHTML = '';
        const layout = window._staffSeatLayout || { totalRows: 0, totalCols: 0, seats: [] };
        grid.style.gridTemplateColumns = 'repeat(' + (layout.totalCols || 1) + ', minmax(36px, 1fr))';
        const seatMap = {};
        (layout.seats || []).forEach(s => { seatMap[s.rowPos + '-' + s.colPos] = s; });
        for (let r = 1; r <= (layout.totalRows || 0); r++) {
            for (let c = 1; c <= (layout.totalCols || 0); c++) {
                const seat = seatMap[r + '-' + c];
                if (!seat) continue;
                const seatId = seat.seatName;
                const st = staffResolveSeatStatus(seat);
                const div = document.createElement('div');
                div.className = 'staff-seat' + (st === 'Sold' ? ' sold' : st === 'Maintenance' ? ' maintenance' : '');
                div.innerText = seatId;
                if (st === 'Sold') {
                    div.onclick = () => alert('Ghế ' + seatId + ' đã được đặt!');
                } else if (st === 'Maintenance') {
                    div.onclick = () => alert('Ghế ' + seatId + ' đang bảo trì!');
                } else {
                    div.onclick = () => staffToggleSeat(div, seatId);
                }
                grid.appendChild(div);
            }
        }
    }

    function staffToggleSeat(el, seatId) {
        if (el.classList.contains('selected')) {
            el.classList.remove('selected');
            staffSelectedSeats = staffSelectedSeats.filter(s => s.id !== seatId);
        } else {
            if (staffSelectedSeats.length >= 8) { alert('Chỉ được chọn tối đa 8 ghế!'); return; }
            el.classList.add('selected');
            staffSelectedSeats.push({ id: seatId });
        }
        document.getElementById('staff-form-selected-seats').value = staffSelectedSeats.map(s => s.id).join(',');
        staffUpdateSummary();
    }

    function staffLoadSeats(showtimeId) {
        if (!showtimeId) return;
        fetch(contextPath + '/staff/api/seats?showtimeId=' + showtimeId, { headers: { 'Accept': 'application/json' } })
            .then(res => { if (!res.ok) throw new Error('Không tải được sơ đồ ghế'); return res.json(); })
            .then(data => {
                window._staffSeatLayout = data || { totalRows: 0, totalCols: 0, seats: [] };
                staffSelectedSeats = [];
                document.getElementById('staff-form-selected-seats').value = '';
                staffRenderSeats();
                staffUpdateSummary();
            })
            .catch(err => alert(err.message || 'Lỗi tải sơ đồ ghế'));
    }

    function staffGenerateDateButtons(activeDate) {
        const container = document.getElementById('staff-dynamic-date-list');
        container.innerHTML = '';
        const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
        const base = staffPageDate ? new Date(staffPageDate + 'T12:00:00') : new Date();
        for (let i = 0; i < 7; i++) {
            const d = new Date(base);
            d.setDate(base.getDate() + i);
            const tz = d.getTimezoneOffset() * 60000;
            const dateStr = new Date(d.getTime() - tz).toISOString().split('T')[0];
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'staff-date-btn' + (dateStr === activeDate ? ' active' : '');
            btn.dataset.date = dateStr;
            btn.innerHTML = '<div>' + (i === 0 ? 'Ngày xem' : dayNames[d.getDay()]) + '</div><div style="font-size:16px;margin-top:4px">' +
                d.getDate() + '/' + (d.getMonth() + 1) + '</div>';
            if (staffMovieShowDates.has(dateStr)) {
                btn.innerHTML += '<div style="font-size:8px;color:#3b82f6;margin-top:2px">● Có suất</div>';
            }
            btn.onclick = () => staffApplySelectedDate(dateStr);
            container.appendChild(btn);
        }
    }

    function staffFetchShowtimes(movieId, dateStr) {
        const container = document.getElementById('staff-dynamic-time-slots');
        container.innerHTML = '<p class="text-gray-500 animate-pulse">Đang tải suất chiếu...</p>';
        fetch(contextPath + '/staff/api/showtimes?movieId=' + movieId + '&date=' + dateStr, { headers: { 'Accept': 'application/json' } })
            .then(res => res.json())
            .then(data => {
                container.innerHTML = '';
                if (!data || data.length === 0) {
                    container.innerHTML = '<p class="text-gray-600 italic">Không có suất chiếu.</p>';
                    return;
                }
                data.forEach(st => {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'px-6 py-3 bg-[#1e1e1e] border border-gray-800 rounded-xl text-white font-bold hover:border-blue-500 transition-all';
                    btn.innerText = st.startTime;
                    btn.onclick = () => {
                        document.querySelectorAll('#staff-dynamic-time-slots button').forEach(b => b.classList.remove('border-blue-500', 'text-blue-500'));
                        btn.classList.add('border-blue-500', 'text-blue-500');
                        staffSelectedTime = st.startTime;
                        staffSelectedShowtimeId = st.id_Showtime;
                        document.getElementById('staff-form-showtime-id').value = st.id_Showtime;
                        document.getElementById('staff-summary-time').innerText = st.startTime;
                        staffLoadSeats(st.id_Showtime);
                    };
                    container.appendChild(btn);
                });
            })
            .catch(() => { container.innerHTML = '<p class="text-red-500 text-sm">Lỗi tải suất chiếu.</p>'; });
    }

    function staffSelectPaymentMethod(method) {
        staffPaymentMethod = method;
        document.getElementById('staff-form-payment-method').value = method;
        const isQr = method === 'QR';
        document.getElementById('staff-btn-pay-qr').className = isQr
            ? 'flex-1 py-4 px-6 rounded-xl border-2 border-blue-500 bg-blue-600/10 text-white font-bold text-sm uppercase tracking-wider transition-all'
            : 'flex-1 py-4 px-6 rounded-xl border-2 border-gray-700 text-gray-400 font-bold text-sm uppercase tracking-wider hover:border-gray-500 transition-all';
        document.getElementById('staff-btn-pay-cash').className = !isQr
            ? 'flex-1 py-4 px-6 rounded-xl border-2 border-blue-500 bg-blue-600/10 text-white font-bold text-sm uppercase tracking-wider transition-all'
            : 'flex-1 py-4 px-6 rounded-xl border-2 border-gray-700 text-gray-400 font-bold text-sm uppercase tracking-wider hover:border-gray-500 transition-all';
    }

    function staffApplyQrData(data) {
        if (!data || data.error) {
            if (data && data.error) alert(data.error);
            staffQrTransactionCode = '';
            return;
        }
        const img = document.getElementById('staff-confirm-qr-code-image');
        if (img) img.src = data.qrUrl || '';
        const txEl = document.getElementById('staff-confirm-qr-transaction-code');
        if (txEl) txEl.innerText = data.transactionCode || '';
        const amtEl = document.getElementById('staff-confirm-qr-amount-display');
        if (amtEl) amtEl.innerText = fmtMoney(data.amount || 0);
        const bankEl = document.getElementById('staff-confirm-qr-bank-name');
        if (bankEl) bankEl.innerText = data.bankName || '—';
        const accNumEl = document.getElementById('staff-confirm-qr-account-number');
        if (accNumEl) accNumEl.innerText = data.accountNumber || '—';
        const accNameEl = document.getElementById('staff-confirm-qr-account-name');
        if (accNameEl) accNameEl.innerText = data.accountName || '—';
        staffQrTransactionCode = data.transactionCode || '';
        const detailEl = document.getElementById('staff-confirm-payment-detail');
        if (detailEl && staffQrTransactionCode) {
            detailEl.innerText = 'Mã giao dịch: ' + staffQrTransactionCode;
        }
    }

    function staffLoadQrCode() {
        const total = staffSelectedSeats.length * staffTicketPrice;
        if (total <= 0) { alert('Vui lòng chọn ghế trước!'); return; }
        fetch(contextPath + '/staff/api/qr-code?amount=' + total, { headers: { 'Accept': 'application/json' } })
            .then(res => res.json().then(data => { if (!res.ok) throw new Error(data.error || 'Lỗi QR'); return data; }))
            .then(staffApplyQrData)
            .catch(err => alert(err.message || 'Không tạo được mã QR'));
    }

    function staffUpdateCashChange() {
        const total = staffSelectedSeats.length * staffTicketPrice;
        const input = document.getElementById('staff-cash-received-input');
        const changeEl = document.getElementById('staff-cash-change-display');
        if (!input || !changeEl) return;
        const received = parseInt(input.value, 10) || 0;
        const change = received - total;
        if (received <= 0) {
            changeEl.innerText = '—';
            changeEl.className = 'text-gray-500 font-black text-xl';
        } else if (change < 0) {
            changeEl.innerText = 'Thiếu ' + fmtMoney(Math.abs(change));
            changeEl.className = 'text-red-500 font-black text-xl';
        } else {
            changeEl.innerText = fmtMoney(change);
            changeEl.className = 'text-green-500 font-black text-xl';
        }
    }

    function staffPopulateConfirm() {
        const total = staffSelectedSeats.length * staffTicketPrice;
        document.getElementById('staff-confirm-movie-title').innerText = document.getElementById('staff-modal-movie-title').innerText;
        document.getElementById('staff-confirm-date').innerText = document.getElementById('staff-summary-date').innerText;
        document.getElementById('staff-confirm-time').innerText = staffSelectedTime || '--:--';
        document.getElementById('staff-confirm-total').innerText = fmtMoney(total);
        const cName = (document.getElementById('staff-customer-name').value || '').trim();
        const cPhone = (document.getElementById('staff-customer-phone').value || '').trim();
        const cEmail = (document.getElementById('staff-customer-email').value || '').trim();
        document.getElementById('staff-confirm-customer-name').innerText = cName;
        let contact = 'SĐT: ' + cPhone;
        if (staffCustomerContactExists && staffResolvedCustomer) {
            contact += ' · Email: ' + (staffResolvedCustomer.email || cEmail || '—') + ' · Khách đã có trong hệ thống';
        } else if (!staffCustomerContactExists) {
            contact += ' · Email: ' + cEmail + ' · Tài khoản mới (mật khẩu mặc định: Pass@123)';
        }
        document.getElementById('staff-confirm-customer-contact').innerText = contact;
        const list = document.getElementById('staff-confirm-seats-list');
        list.innerHTML = '';
        staffSelectedSeats.forEach(s => {
            const row = document.createElement('div');
            row.className = 'flex justify-between text-gray-300';
            row.innerHTML = '<span>Ghế <strong class="text-white">' + s.id + '</strong></span><span>' + fmtMoney(staffTicketPrice) + '</span>';
            list.appendChild(row);
        });
        if (staffPaymentMethod === 'Cash') {
            document.getElementById('staff-confirm-payment-method').innerHTML = '<i class="fas fa-money-bill-wave mr-1"></i> Tiền mặt';
            document.getElementById('staff-confirm-payment-detail').innerText = 'Thanh toán tại quầy';
            document.getElementById('staff-confirm-panel-qr').classList.add('hidden');
            document.getElementById('staff-confirm-panel-cash').classList.remove('hidden');
            document.getElementById('staff-confirm-cash-amount-display').innerText = fmtMoney(total);
            const cashInput = document.getElementById('staff-cash-received-input');
            if (cashInput) cashInput.value = '';
            staffUpdateCashChange();
        } else {
            document.getElementById('staff-confirm-payment-method').innerHTML = '<i class="fas fa-qrcode mr-1"></i> Mã QR';
            document.getElementById('staff-confirm-payment-detail').innerText = 'Thanh toán qua ví / ngân hàng';
            document.getElementById('staff-confirm-panel-cash').classList.add('hidden');
            document.getElementById('staff-confirm-panel-qr').classList.remove('hidden');
            staffLoadQrCode();
        }
        document.getElementById('staff-confirm-agree').checked = false;
    }

    function staffSubmitBooking() {
        document.getElementById('staff-form-showtime-id').value = staffSelectedShowtimeId || '';
        document.getElementById('staff-form-qr-transaction-code').value =
            staffPaymentMethod === 'QR' ? (staffQrTransactionCode || '') : '';
        document.getElementById('staff-form-return-date').value = staffPageDate || staffSelectedDate;
        document.getElementById('staff-form-customer-name').value =
            (document.getElementById('staff-customer-name').value || '').trim();
        document.getElementById('staff-form-customer-phone').value =
            (document.getElementById('staff-customer-phone').value || '').trim();
        document.getElementById('staff-form-customer-email').value =
            (document.getElementById('staff-customer-email').value || '').trim();
        document.getElementById('staff-submit-booking-form').submit();
    }

    function staffResetBookingState() {
        staffSelectedTime = null;
        staffSelectedShowtimeId = null;
        staffSelectedSeats = [];
        staffQrTransactionCode = '';
        staffPaymentMethod = 'QR';
        document.getElementById('staff-form-selected-seats').value = '';
        document.getElementById('staff-form-showtime-id').value = '';
        document.getElementById('staff-confirm-agree').checked = false;
        staffResetCustomerForm();
        staffSelectPaymentMethod('QR');
    }

    window.openStaffBooking = function (movieId, title, posterUrl, basePrice) {
        staffResetBookingState();
        staffCurrentMovieId = movieId;
        staffTicketPrice = basePrice || 85000;
        staffSelectedDate = staffPageDate;
        document.getElementById('staff-modal-movie-title').innerText = title || 'Phim';
        document.getElementById('staff-modal-movie-poster').src = posterUrl || (contextPath + '/assets/images/no-poster.png');
        document.getElementById('staff-summary-date').innerText = fmtDateLabel(staffPageDate);
        const dateInput = document.getElementById('staff-pick-date-input');
        if (dateInput) dateInput.value = staffPageDate || '';
        staffCloseCalendarPopup();
        document.getElementById('staff-booking-modal').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        staffSetStepActive(1);
        staffLoadMovieShowDates(movieId).then(() => {
            staffGenerateDateButtons(staffPageDate);
            staffFetchShowtimes(movieId, staffPageDate);
        });
        staffRenderSeats();
        staffUpdateSummary();
    };

    window.openStaffBookingForShowtime = function (showtimeId, movieId, title, posterUrl, basePrice, timeStr, dateLabel) {
        staffResetBookingState();
        staffCurrentMovieId = movieId;
        staffTicketPrice = basePrice || 85000;
        staffSelectedShowtimeId = showtimeId;
        staffSelectedTime = timeStr;
        staffSelectedDate = staffPageDate;
        document.getElementById('staff-modal-movie-title').innerText = title || 'Phim';
        document.getElementById('staff-modal-movie-poster').src = posterUrl || (contextPath + '/assets/images/no-poster.png');
        document.getElementById('staff-summary-date').innerText = dateLabel || staffPageDate;
        document.getElementById('staff-summary-time').innerText = timeStr || '--:--';
        document.getElementById('staff-form-showtime-id').value = showtimeId;
        document.getElementById('staff-booking-modal').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        staffLoadSeats(showtimeId);
        staffSetStepActive(2);
    };

    window.closeStaffBooking = function () {
        document.getElementById('staff-booking-modal').classList.add('hidden');
        document.body.style.overflow = 'auto';
        staffCloseCalendarPopup();
        staffSetStepActive(1);
    };

    document.getElementById('staff-btn-open-calendar').addEventListener('click', function (e) {
        e.stopPropagation();
        staffToggleCalendarPopup();
    });
    document.getElementById('staff-cal-prev').addEventListener('click', function (e) {
        e.stopPropagation();
        staffCalendarView.setMonth(staffCalendarView.getMonth() - 1);
        staffRenderMovieCalendar();
    });
    document.getElementById('staff-cal-next').addEventListener('click', function (e) {
        e.stopPropagation();
        staffCalendarView.setMonth(staffCalendarView.getMonth() + 1);
        staffRenderMovieCalendar();
    });
    document.getElementById('staff-pick-date-input').addEventListener('change', function () {
        staffApplySelectedDate(this.value);
    });
    document.getElementById('staff-btn-check-contact').addEventListener('click', staffCheckCustomerContact);
    function staffResetContactCheck() {
        staffCustomerContactExists = null;
        staffCustomerContactConflict = false;
        staffResolvedCustomer = null;
        const nameEl = document.getElementById('staff-customer-name');
        if (nameEl) { nameEl.value = ''; nameEl.disabled = true; }
        document.getElementById('staff-customer-mode-badge').textContent = 'Chưa kiểm tra';
        document.getElementById('staff-customer-mode-badge').className = 'text-[10px] font-bold uppercase px-2 py-1 rounded-lg bg-gray-800 text-gray-400';
        document.getElementById('staff-customer-contact-hint').textContent = '';
        document.getElementById('staff-customer-name-hint').textContent = '';
        document.getElementById('staff-customer-found').classList.add('hidden');
    }
    document.getElementById('staff-customer-phone').addEventListener('input', staffResetContactCheck);
    document.getElementById('staff-customer-email').addEventListener('input', staffResetContactCheck);
    document.addEventListener('click', function (e) {
        if (!staffCalendarOpen) return;
        const popup = document.getElementById('staff-movie-calendar-popup');
        const btn = document.getElementById('staff-btn-open-calendar');
        if (popup && !popup.contains(e.target) && btn && !btn.contains(e.target)) {
            staffCloseCalendarPopup();
        }
    });

    window.staffSelectPaymentMethod = staffSelectPaymentMethod;
    window.staffLoadQrCode = staffLoadQrCode;
    window.staffUpdateCashChange = staffUpdateCashChange;

    window.staffChangeStep = function (n) {
        if (n === -1 && staffCurrentStep === 1) { closeStaffBooking(); return; }
        if (n === 1) {
            if (staffCurrentStep === 1 && !staffSelectedShowtimeId) {
                alert('Vui lòng chọn suất chiếu!'); return;
            }
            if (staffCurrentStep === 2 && staffSelectedSeats.length === 0) {
                alert('Vui lòng chọn ít nhất một ghế!'); return;
            }
            if (staffCurrentStep === 3) {
                if (!staffValidateCustomerInfo()) return;
                staffPopulateConfirm();
            }
            if (staffCurrentStep === 4) {
                if (!document.getElementById('staff-confirm-agree').checked) {
                    alert('Vui lòng xác nhận thông tin!'); return;
                }
                if (staffPaymentMethod === 'QR' && !staffQrTransactionCode) {
                    alert('Vui lòng tạo mã QR trước!'); staffLoadQrCode(); return;
                }
                if (staffPaymentMethod === 'Cash') {
                    const cashTotal = staffSelectedSeats.length * staffTicketPrice;
                    const cashReceived = parseInt(document.getElementById('staff-cash-received-input').value, 10) || 0;
                    if (cashReceived < cashTotal) {
                        alert('Số tiền khách đưa phải lớn hơn hoặc bằng số tiền cần thanh toán!');
                        document.getElementById('staff-cash-received-input').focus();
                        return;
                    }
                }
                staffSubmitBooking();
                return;
            }
        }
        staffSetStepActive(staffCurrentStep + n);
    };
})();
</script>
