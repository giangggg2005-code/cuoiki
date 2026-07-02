package uef.edu.vn.service.impl;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import uef.edu.vn.exception.BookingException;
import uef.edu.vn.model.Booking;
import uef.edu.vn.model.BookingDetail;
import uef.edu.vn.model.Movie;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Seat;
import uef.edu.vn.model.Showtime;
import uef.edu.vn.model.Ticket;
import uef.edu.vn.model.User;
import uef.edu.vn.repository.BookingDetailRepository;
import uef.edu.vn.repository.BookingRepository;
import uef.edu.vn.repository.MovieRepository;
import uef.edu.vn.repository.SeatRepository;
import uef.edu.vn.repository.ShowtimeRepository;
import uef.edu.vn.repository.TicketRepository;
import uef.edu.vn.repository.UserRepository;
import uef.edu.vn.service.BookingService;
import uef.edu.vn.service.PaymentService;

@Service
public class BookingServiceImpl implements BookingService {

    private final BookingRepository bookingRepo;
    private final BookingDetailRepository bookingDetailRepo;
    private final TicketRepository ticketRepo;
    private final SeatRepository seatRepo;
    private final ShowtimeRepository showtimeRepo;
    private final MovieRepository movieRepo;
    private final PaymentService paymentService;
    private final UserRepository userRepo;

    @Autowired
    public BookingServiceImpl(BookingRepository bookingRepo,
                              BookingDetailRepository bookingDetailRepo,
                              TicketRepository ticketRepo,
                              SeatRepository seatRepo,
                              ShowtimeRepository showtimeRepo,
                              MovieRepository movieRepo,
                              PaymentService paymentService,
                              UserRepository userRepo) {
        this.bookingRepo = bookingRepo;
        this.bookingDetailRepo = bookingDetailRepo;
        this.ticketRepo = ticketRepo;
        this.seatRepo = seatRepo;
        this.showtimeRepo = showtimeRepo;
        this.movieRepo = movieRepo;
        this.paymentService = paymentService;
        this.userRepo = userRepo;
    }

    @Override
    public List<Booking> getAllBookings() {
        return bookingRepo.findAll();
    }

    @Override
    public Booking getBookingById(int bookingId) {
        if (bookingId <= 0) {
            throw new BookingException("Lỗi: ID hóa đơn đặt vé không hợp lệ!");
        }
        Booking booking = bookingRepo.findById(bookingId);
        if (booking == null) {
            throw new BookingException("Lỗi truy xuất: Không tìm thấy đơn đặt vé mang mã số: " + bookingId);
        }
        return booking;
    }

    @Override
    public List<Booking> getBookingHistoryByUser(int userId) {
        if (userId <= 0) {
            throw new BookingException("Lỗi: ID người dùng không hợp lệ để tra cứu lịch sử!");
        }
        return bookingRepo.getHistoryByUser(userId);
    }

    @Override
    public List<Booking> getBookingsByStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            throw new BookingException("Lỗi: Trạng thái cần lọc không được để trống!");
        }
        return bookingRepo.findByStatus(status.trim());
    }

    @Override
    public List<Booking> getBookingsWithPagination(int limit, int offset) {
        if (limit < 0 || offset < 0) {
            throw new BookingException("Lỗi phân trang: Chỉ số dòng hiển thị hoặc vị trí bắt đầu không được âm!");
        }
        return bookingRepo.findWithPagination(limit, offset);
    }

    @Override
    public boolean createBooking(Booking booking) {
        validateBookingData(booking);

        if (booking.getStatus() == null || booking.getStatus().trim().isEmpty()) {
            booking.setStatus("Pending");
        }
        if (booking.getBookingDate() == null) {
            booking.setBookingDate(new Timestamp(System.currentTimeMillis()));
        }

        bookingRepo.save(booking);
        return true;
    }

    @Override
    public int createBookingAndGetId(Booking booking) {
        validateBookingData(booking);

        if (booking.getStatus() == null || booking.getStatus().trim().isEmpty()) {
            booking.setStatus("Pending");
        }
        if (booking.getBookingDate() == null) {
            booking.setBookingDate(new Timestamp(System.currentTimeMillis()));
        }

        int generatedId = bookingRepo.saveAndGetId(booking);
        if (generatedId == -1) {
            throw new BookingException("Lỗi hệ thống: Không thể khởi tạo đơn đặt vé mới trong CSDL!");
        }
        return generatedId;
    }

    @Override
    public boolean updateBooking(Booking booking) {
        if (bookingRepo.findById(booking.getId_Booking()) == null) {
            throw new BookingException("Lỗi truy xuất: Không tìm thấy đơn đặt vé cần cập nhật dữ liệu!");
        }
        validateBookingData(booking);

        bookingRepo.update(booking);
        return true;
    }

    @Override
    @Transactional
    public boolean deleteBooking(int bookingId) {
        Booking booking = bookingRepo.findById(bookingId);
        if (booking == null) {
            throw new BookingException("Lỗi truy xuất: Không thể xóa! Không tìm thấy đơn đặt vé yêu cầu.");
        }

        List<BookingDetail> details = bookingDetailRepo.getDetailsByBooking(bookingId);
        for (BookingDetail detail : details) {
            ticketRepo.deleteById(detail.getTicketId());
        }
        bookingDetailRepo.deleteByBookingId(bookingId);

        if ("Completed".equalsIgnoreCase(booking.getStatus())
                && "Card".equalsIgnoreCase(booking.getPaymentMethod())
                && booking.getPaymentId() != null
                && booking.getUserId() != null) {
            paymentService.refundCardPayment(booking.getPaymentId(), booking.getUserId(), booking.getTotalAmount());
        }

        bookingRepo.deleteById(bookingId);
        return true;
    }

    @Override
    public boolean updateBookingStatus(int bookingId, String status) {
        if (bookingRepo.findById(bookingId) == null) {
            throw new BookingException("Lỗi truy xuất: Không tìm thấy đơn đặt vé để thực hiện đổi trạng thái!");
        }
        if (status == null || status.trim().isEmpty()) {
            throw new BookingException("Lỗi: Trạng thái mới của đơn đặt vé không hợp lệ!");
        }

        bookingRepo.updateStatus(bookingId, status.trim());
        return true;
    }

    @Override
    @Transactional
    public int processCustomerCheckout(int userId, int showtimeId, String[] seatNames,
                                       String paymentMethod, Integer paymentId, String cardNumber,
                                       String pinCode, String qrTransactionCode,
                                       Integer qrPaymentUserId) {
        if (userId <= 0) {
            throw new BookingException("Vui lòng đăng nhập để đặt vé!");
        }
        if (showtimeId <= 0) {
            throw new BookingException("Vui lòng chọn suất chiếu!");
        }
        if (seatNames == null || seatNames.length == 0) {
            throw new BookingException("Vui lòng chọn ít nhất một ghế!");
        }
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            throw new BookingException("Vui lòng chọn phương thức thanh toán!");
        }

        User user = userRepo.findById(userId);
        if (user == null) {
            throw new BookingException("Tài khoản không tồn tại!");
        }
        if ("Locked".equalsIgnoreCase(user.getStatus()) || "Banned".equalsIgnoreCase(user.getStatus())) {
            throw new BookingException("Tài khoản đã bị khóa, không thể đặt vé!");
        }
        if ("Inactive".equalsIgnoreCase(user.getStatus())) {
            throw new BookingException("Tài khoản chưa được kích hoạt!");
        }

        Showtime showtime = showtimeRepo.findById(showtimeId);
        if (showtime == null) {
            throw new BookingException("Suất chiếu không tồn tại!");
        }
        if (!"Active".equalsIgnoreCase(showtime.getStatus())) {
            throw new BookingException("Suất chiếu không còn khả dụng!");
        }
        if (isShowtimePast(showtime)) {
            throw new BookingException("Suất chiếu đã qua, không thể đặt vé!");
        }

        Movie movie = movieRepo.findById(showtime.getMovieId());
        if (movie == null) {
            throw new BookingException("Không tìm thấy thông tin phim!");
        }

        double basePrice = movie.getBasePrice();
        if (basePrice <= 0) {
            throw new BookingException("Giá vé chưa được cấu hình!");
        }

        List<Ticket> ticketsToCreate = new ArrayList<>();
        double totalAmount = 0;
        Set<String> selectedSeatNames = new HashSet<>();

        for (String seatName : seatNames) {
            String trimmed = seatName != null ? seatName.trim().toUpperCase() : "";
            if (trimmed.isEmpty()) {
                continue;
            }
            if (!selectedSeatNames.add(trimmed)) {
                throw new BookingException("Ghế " + trimmed + " bị chọn trùng lặp!");
            }

            Seat seat = seatRepo.findBySeatNameAndRoomId(trimmed, showtime.getRoomId());
            if (seat == null) {
                throw new BookingException("Ghế " + trimmed + " không tồn tại trong phòng chiếu!");
            }
            if (!seatRepo.isSeatAvailable(seat.getId_Seat())) {
                throw new BookingException("Ghế " + trimmed + " không khả dụng (đang bảo trì hoặc hỏng)!");
            }
            if (ticketRepo.isSeatTakenForShowtime(showtimeId, seat.getId_Seat())) {
                throw new BookingException("Ghế " + trimmed + " đã được đặt! Vui lòng chọn ghế khác.");
            }

            double seatPrice = calculateSeatPrice(basePrice, trimmed);
            totalAmount += seatPrice;

            Ticket ticket = new Ticket();
            ticket.setShowtimeId(showtimeId);
            ticket.setSeatId(seat.getId_Seat());
            ticket.setPrice(seatPrice);
            ticket.setStatus("Sold");
            ticketsToCreate.add(ticket);
        }

        if (ticketsToCreate.isEmpty()) {
            throw new BookingException("Danh sách ghế không hợp lệ!");
        }

        String method = paymentMethod.trim();
        Integer linkedPaymentId = null;

        if ("Card".equalsIgnoreCase(method) || "Thẻ".equalsIgnoreCase(method)
                || "Credit Card".equalsIgnoreCase(method)) {
            if (cardNumber != null && !cardNumber.trim().isEmpty()) {
                linkedPaymentId = paymentService.processCardPaymentByCardNumber(
                        cardNumber.trim(), userId, pinCode, totalAmount);
            } else if (paymentId != null && paymentId > 0) {
                paymentService.processCardPayment(paymentId, userId, pinCode, totalAmount);
                linkedPaymentId = paymentId;
            } else {
                throw new BookingException("Vui lòng nhập số thẻ thanh toán!");
            }
            method = "Credit Card";
        } else if ("QR".equalsIgnoreCase(method) || "QR Code".equalsIgnoreCase(method)
                || "Momo".equalsIgnoreCase(method)) {
            int qrUserId = (qrPaymentUserId != null && qrPaymentUserId > 0) ? qrPaymentUserId : userId;
            paymentService.verifyAndConsumeQrPayment(qrUserId, qrTransactionCode, totalAmount);
            method = "Momo";
        } else if ("Cash".equalsIgnoreCase(method) || "Tiền mặt".equalsIgnoreCase(method)) {
            method = "Tiền mặt";
        } else {
            throw new BookingException("Phương thức thanh toán không được hỗ trợ!");
        }

        Booking booking = new Booking();
        booking.setBookingDate(new Timestamp(System.currentTimeMillis()));
        booking.setTotalAmount(totalAmount);
        booking.setPaymentMethod(method);
        booking.setStatus("Completed");
        booking.setUserId(userId);
        booking.setPaymentId(linkedPaymentId);

        int bookingId = bookingRepo.saveAndGetId(booking);
        if (bookingId <= 0) {
            throw new BookingException("Không thể tạo đơn đặt vé!");
        }

        List<BookingDetail> details = new ArrayList<>();
        for (Ticket ticket : ticketsToCreate) {
            int ticketId = ticketRepo.saveAndGetId(ticket);
            if (ticketId <= 0) {
                throw new BookingException("Ghế đã được người khác đặt trước! Vui lòng chọn ghế khác.");
            }

            BookingDetail detail = new BookingDetail();
            detail.setPrice(ticket.getPrice());
            detail.setBookingId(bookingId);
            detail.setTicketId(ticketId);
            details.add(detail);
        }
        bookingDetailRepo.saveMultipleDetails(details);

        return bookingId;
    }

    private boolean isShowtimePast(Showtime showtime) {
        if (showtime.getShowDate() == null || showtime.getStartTime() == null) {
            return true;
        }
        Calendar showStart = Calendar.getInstance();
        showStart.setTime(showtime.getShowDate());
        Calendar startTime = Calendar.getInstance();
        startTime.setTime(showtime.getStartTime());
        showStart.set(Calendar.HOUR_OF_DAY, startTime.get(Calendar.HOUR_OF_DAY));
        showStart.set(Calendar.MINUTE, startTime.get(Calendar.MINUTE));
        showStart.set(Calendar.SECOND, startTime.get(Calendar.SECOND));
        showStart.set(Calendar.MILLISECOND, 0);
        return showStart.getTimeInMillis() <= System.currentTimeMillis();
    }

    private double calculateSeatPrice(double basePrice, String seatName) {
        return basePrice;
    }

    @Override
    public Map<String, Object> getCustomerBookingDetail(int bookingId, int userId) {
        Booking booking = bookingRepo.findById(bookingId);
        if (booking == null) {
            throw new BookingException("Không tìm thấy đơn đặt vé!");
        }
        if (booking.getUserId() == null || booking.getUserId() != userId) {
            throw new BookingException("Bạn không có quyền xem đơn đặt vé này!");
        }

        List<Ticket> tickets = ticketRepo.findFullDetailsByBookingId(bookingId);
        if (tickets == null || tickets.isEmpty()) {
            throw new BookingException("Đơn đặt vé không có thông tin vé chi tiết!");
        }

        SimpleDateFormat dateTimeFmt = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        SimpleDateFormat dateFmt = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat timeFmt = new SimpleDateFormat("HH:mm");

        Map<String, Object> result = new HashMap<>();
        Map<String, Object> bookingMap = new HashMap<>();
        bookingMap.put("id", booking.getId_Booking());
        bookingMap.put("bookingDate", booking.getBookingDate() != null
                ? dateTimeFmt.format(booking.getBookingDate()) : "");
        bookingMap.put("totalAmount", booking.getTotalAmount());
        bookingMap.put("paymentMethod", booking.getPaymentMethod());
        bookingMap.put("status", booking.getStatus());
        bookingMap.put("paymentId", booking.getPaymentId());

        if (booking.getPaymentId() != null) {
            try {
                Payment payment = paymentService.getPaymentById(booking.getPaymentId());
                if (payment.getUserId() == userId) {
                    bookingMap.put("cardMasked", maskCardNumber(payment.getCardNumber()));
                }
            } catch (Exception ignored) {
            }
        }

        List<Map<String, Object>> ticketList = new ArrayList<>();
        for (Ticket ticket : tickets) {
            Map<String, Object> ticketMap = new HashMap<>();
            ticketMap.put("ticketId", ticket.getId_Ticket());
            ticketMap.put("price", ticket.getPrice());
            ticketMap.put("status", ticket.getStatus());

            Seat seat = ticket.getSeat();
            if (seat != null) {
                ticketMap.put("seatName", seat.getSeatName());
                ticketMap.put("rowPos", seat.getRowPos());
                ticketMap.put("colPos", seat.getColPos());
                ticketMap.put("seatStatus", seat.getStatus());
            }

            Showtime showtime = ticket.getShowtime();
            if (showtime != null) {
                ticketMap.put("showDate", showtime.getShowDate() != null
                        ? dateFmt.format(showtime.getShowDate()) : "");
                ticketMap.put("startTime", showtime.getStartTime() != null
                        ? timeFmt.format(showtime.getStartTime()) : "");
                ticketMap.put("endTime", showtime.getEndTime() != null
                        ? timeFmt.format(showtime.getEndTime()) : "");
                ticketMap.put("showtimeStatus", showtime.getStatus());

                Movie movie = showtime.getMovie();
                if (movie != null) {
                    ticketMap.put("movieTitle", movie.getTitle());
                    ticketMap.put("movieGenre", movie.getGenre());
                    ticketMap.put("movieDuration", movie.getDuration());
                    ticketMap.put("movieLanguage", movie.getLanguage());
                    ticketMap.put("posterUrl", movie.getPosterUrl());
                }

                if (showtime.getRoom() != null) {
                    ticketMap.put("roomName", showtime.getRoom().getRoomName());
                    ticketMap.put("roomType", showtime.getRoom().getRoomType());
                }
            }

            ticketList.add(ticketMap);
        }

        result.put("booking", bookingMap);
        result.put("tickets", ticketList);
        result.put("ticketCount", ticketList.size());
        return result;
    }

    private String maskCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.length() < 4) {
            return "";
        }
        return "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
    }

    private void validateBookingData(Booking booking) {
        if (booking == null) {
            throw new BookingException("Lỗi: Dữ liệu đơn đặt vé (Booking) trống rỗng!");
        }

        if (booking.getUserId() != null && booking.getUserId() <= 0) {
            throw new BookingException("Lỗi nghiệp vụ: Mã khách hàng (User ID) không hợp lệ!");
        }

        if (booking.getTotalAmount() < 0) {
            throw new BookingException("Lỗi nghiệp vụ: Tổng số tiền thanh toán của hóa đơn không được phép nhỏ hơn 0!");
        }
        if (booking.getPaymentMethod() == null || booking.getPaymentMethod().trim().isEmpty()) {
            throw new BookingException("Lỗi dữ liệu: Vui lòng chọn phương thức thanh toán!");
        }
    }
}
