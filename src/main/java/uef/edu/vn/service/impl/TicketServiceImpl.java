package uef.edu.vn.service.impl;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uef.edu.vn.model.Booking;
import uef.edu.vn.model.BookingDetail;
import uef.edu.vn.model.Ticket;
import uef.edu.vn.model.User;
import uef.edu.vn.repository.BookingDetailRepository;
import uef.edu.vn.repository.BookingRepository;
import uef.edu.vn.repository.TicketRepository;
import uef.edu.vn.repository.UserRepository;
import uef.edu.vn.service.TicketService;

@Service
public class TicketServiceImpl implements TicketService {

    private final TicketRepository ticketRepository;
    private final BookingRepository bookingRepository;
    private final BookingDetailRepository bookingDetailRepository;
    private final UserRepository userRepository;

    @Autowired
    public TicketServiceImpl(TicketRepository ticketRepository,
                             BookingRepository bookingRepository,
                             BookingDetailRepository bookingDetailRepository,
                             UserRepository userRepository) {
        this.ticketRepository = ticketRepository;
        this.bookingRepository = bookingRepository;
        this.bookingDetailRepository = bookingDetailRepository;
        this.userRepository = userRepository;
    }

    @Override
    public List<Ticket> searchTickets(String keyword, String status) {
        return ticketRepository.searchTickets(keyword, status);
    }

    @Override
    public Ticket getTicketById(int ticketId) {
        return ticketRepository.findById(ticketId);
    }

    @Override
    public List<Ticket> getTicketsByBookingId(int bookingId) {
        return ticketRepository.findByBookingIdForCheck(bookingId);
    }

    @Override
    public Map<String, Object> validateTicketForCheck(int ticketId) {
        Map<String, Object> result = new HashMap<>();
        Ticket ticket = ticketRepository.findById(ticketId);

        if (ticket == null) {
            result.put("valid", false);
            result.put("message", "Không tìm thấy vé với mã #" + ticketId);
            return result;
        }

        result.put("ticket", ticket);

        if (!"Sold".equalsIgnoreCase(ticket.getStatus())) {
            result.put("valid", false);
            result.put("message", "Vé chưa thanh toán hoặc không hợp lệ (Trạng thái: " + ticket.getStatus() + ")");
            return result;
        }

        if (ticket.getShowtime() != null && ticket.getShowtime().getShowDate() != null) {
            Date showDate = ticket.getShowtime().getShowDate();
            LocalDate today = LocalDate.now();
            LocalDate showLocalDate = showDate.toLocalDate();

            if (showLocalDate.isBefore(today)) {
                result.put("valid", false);
                result.put("message", "Vé đã hết hạn (Suất chiếu: " + showLocalDate + ")");
                return result;
            }
            if (showLocalDate.isAfter(today)) {
                result.put("valid", false);
                result.put("message", "Vé chưa đến ngày chiếu (Suất chiếu: " + showLocalDate + ")");
                return result;
            }
        }

        result.put("valid", true);
        result.put("message", "Vé hợp lệ - Cho phép vào rạp");
        return result;
    }

    @Override
    public List<Map<String, Object>> buildCheckTicketResults(Integer ticketId, Integer bookingId) {
        if (ticketId != null && ticketId > 0) {
            return List.of(validateTicketForCheck(ticketId));
        }
        if (bookingId != null && bookingId > 0) {
            List<Ticket> tickets = getTicketsByBookingId(bookingId);
            if (tickets.isEmpty()) {
                throw new IllegalArgumentException("Không tìm thấy vé cho đơn đặt #" + bookingId);
            }
            List<Map<String, Object>> results = new ArrayList<>();
            for (Ticket ticket : tickets) {
                results.add(validateTicketForCheck(ticket.getId_Ticket()));
            }
            return results;
        }
        throw new IllegalArgumentException("Vui lòng nhập mã vé hoặc mã đơn đặt vé");
    }

    @Override
    public Map<String, Object> buildCheckTicketExportData(Integer ticketId, Integer bookingId) {
        Map<String, Object> exportData = new HashMap<>();
        exportData.put("checkResults", buildCheckTicketResults(ticketId, bookingId));

        Integer resolvedBookingId = (bookingId != null && bookingId > 0) ? bookingId : null;
        if (resolvedBookingId == null && ticketId != null && ticketId > 0) {
            BookingDetail detail = bookingDetailRepository.findByTicketId(ticketId);
            if (detail != null) {
                resolvedBookingId = detail.getBookingId();
            }
        }

        if (resolvedBookingId != null) {
            Booking booking = bookingRepository.findById(resolvedBookingId);
            if (booking != null) {
                Map<String, Object> invoiceInfo = new HashMap<>();
                invoiceInfo.put("bookingId", resolvedBookingId);
                invoiceInfo.put("bookingDate", booking.getBookingDate());
                invoiceInfo.put("totalAmount", booking.getTotalAmount());
                invoiceInfo.put("paymentMethod", booking.getPaymentMethod());
                invoiceInfo.put("bookingStatus", booking.getStatus());

                if (booking.getUserId() != null) {
                    User customer = userRepository.findById(booking.getUserId());
                    if (customer != null) {
                        invoiceInfo.put("customerName", customer.getFullName());
                        invoiceInfo.put("customerPhone", customer.getPhone());
                        invoiceInfo.put("customerEmail", customer.getEmail());
                    }
                }
                exportData.put("invoiceInfo", invoiceInfo);
            }
        }

        return exportData;
    }
}
