package uef.edu.vn.service;

import java.util.List;
import java.util.Map;
import uef.edu.vn.model.Ticket;

public interface TicketService {

    List<Ticket> searchTickets(String keyword, String status);

    Ticket getTicketById(int ticketId);

    List<Ticket> getTicketsByBookingId(int bookingId);

    Map<String, Object> validateTicketForCheck(int ticketId);

    List<Map<String, Object>> buildCheckTicketResults(Integer ticketId, Integer bookingId);

    Map<String, Object> buildCheckTicketExportData(Integer ticketId, Integer bookingId);
}
