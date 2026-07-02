package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import uef.edu.vn.exception.BookingException;
import uef.edu.vn.exception.PaymentException;
import uef.edu.vn.model.User;
import uef.edu.vn.service.BookingService;

@Controller
@RequestMapping("/customer/booking")
public class BookingController {

    private final BookingService bookingService;

    @Autowired
    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping("/checkout")
    public String checkout(@RequestParam("showtimeId") int showtimeId,
                           @RequestParam("selectedSeats") String selectedSeats,
                           @RequestParam("paymentMethod") String paymentMethod,
                           @RequestParam(value = "paymentId", required = false) Integer paymentId,
                           @RequestParam(value = "cardNumber", required = false) String cardNumber,
                           @RequestParam(value = "pinCode", required = false) String pinCode,
                           @RequestParam(value = "qrTransactionCode", required = false) String qrTransactionCode,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-customer";
        }

        try {
            String[] seatNames = selectedSeats.split(",");
            int bookingId = bookingService.processCustomerCheckout(
                    loggedInUser.getId_User(),
                    showtimeId,
                    seatNames,
                    paymentMethod,
                    paymentId,
                    cardNumber,
                    pinCode,
                    qrTransactionCode,
                    null
            );
            redirectAttributes.addAttribute("bookingSuccess", "true");
            redirectAttributes.addAttribute("bookingId", bookingId);
            return "redirect:/customer/history";
        } catch (BookingException | PaymentException e) {
            redirectAttributes.addAttribute("bookingError", e.getMessage());
            return "redirect:/customer/history";
        } catch (Exception e) {
            redirectAttributes.addAttribute("bookingError", "Lỗi hệ thống: " + e.getMessage());
            return "redirect:/customer/history";
        }
    }
}
