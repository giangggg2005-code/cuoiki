package uef.edu.vn.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import uef.edu.vn.exception.BookingException;
import uef.edu.vn.exception.CustomerException;
import uef.edu.vn.exception.PaymentException;
import uef.edu.vn.exception.ReportException;
import uef.edu.vn.exception.UserException;
import uef.edu.vn.model.Movie;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.Seat;
import uef.edu.vn.model.Showtime;
import uef.edu.vn.model.Ticket;
import uef.edu.vn.model.User;
import uef.edu.vn.repository.ReportRepository;
import uef.edu.vn.repository.RoomRepository;
import uef.edu.vn.service.BookingService;
import uef.edu.vn.service.MovieService;
import uef.edu.vn.service.PaymentService;
import uef.edu.vn.service.ReportService;
import uef.edu.vn.service.ShowtimeService;
import uef.edu.vn.service.TicketService;
import uef.edu.vn.service.UserService;
import java.time.LocalDateTime;
import uef.edu.vn.util.AvatarUtils;
import uef.edu.vn.util.SecurityUtils;
import uef.edu.vn.util.TicketCheckPdfExporter;

@Controller
@RequestMapping("/staff")
public class StaffController {

    private final String path = "/WEB-INF/views/staff/";
    private final String pathview = "layout/staff-layout/main";

    private final ReportService reportService;
    private final ReportRepository reportRepository;
    private final TicketService ticketService;
    private final MovieService movieService;
    private final UserService userService;
    private final BookingService bookingService;
    private final RoomRepository roomRepository;
    private final PaymentService paymentService;
    private final ShowtimeService showtimeService;

    @Autowired
    public StaffController(ReportService reportService, ReportRepository reportRepository,
                           TicketService ticketService, MovieService movieService,
                           UserService userService, BookingService bookingService,
                           RoomRepository roomRepository, PaymentService paymentService,
                           ShowtimeService showtimeService) {
        this.reportService = reportService;
        this.reportRepository = reportRepository;
        this.ticketService = ticketService;
        this.movieService = movieService;
        this.userService = userService;
        this.bookingService = bookingService;
        this.roomRepository = roomRepository;
        this.paymentService = paymentService;
        this.showtimeService = showtimeService;
    }

    @GetMapping({"", "/", "/dashboard"})
    public String showDashboard(Model model) {
        try {
            Map<String, Object> data = reportService.getStaffDashboardData();
            model.addAttribute("summary", data.getOrDefault("summary", new HashMap<>()));
            model.addAttribute("todayShowtimes", data.getOrDefault("todayShowtimes", new ArrayList<>()));
            model.addAttribute("revenueByShift", data.getOrDefault("revenueByShift", new ArrayList<>()));
            model.addAttribute("ticketSalesByMovie", data.getOrDefault("ticketSalesByMovie", new ArrayList<>()));
            model.addAttribute("recentBookings", data.getOrDefault("recentBookings", new ArrayList<>()));
        } catch (ReportException e) {
            initEmptyStaffDashboard(model);
            model.addAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            initEmptyStaffDashboard(model);
            model.addAttribute("errorMessage", "Không thể tải dữ liệu tổng quan. Vui lòng thử lại sau.");
        }

        model.addAttribute("view", "dashboard");
        model.addAttribute("body", path + "dashboard.jsp");
        return pathview;
    }

    @GetMapping("/profile")
    public String showStaffProfile(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-staff";
        }

        try {
            User staff = userService.getUserById(loggedInUser.getId_User());
            model.addAttribute("staff", staff);
            model.addAttribute("view", "profile");
            model.addAttribute("body", path + "profile.jsp");
            return pathview;
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/dashboard";
        }
    }

    @PostMapping("/profile/update")
    public String updateStaffProfile(HttpSession session,
                                     HttpServletRequest request,
                                     @RequestParam("fullName") String fullName,
                                     @RequestParam("email") String email,
                                     @RequestParam("phone") String phone,
                                     @RequestParam(value = "avatar", required = false) String avatar,
                                     @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                     RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-staff";
        }

        try {
            User staff = userService.getUserById(loggedInUser.getId_User());
            staff.setFullName(fullName != null ? fullName.trim() : "");
            staff.setEmail(email != null ? email.trim() : "");
            staff.setPhone(phone != null ? phone.trim() : "");

            String updatedAvatar = AvatarUtils.applyAvatarFromRequest(
                    staff.getAvatar(), avatar, imageFile, request.getServletContext());
            staff.setAvatar(updatedAvatar);

            userService.updateProfile(staff);

            User refreshed = userService.getUserById(loggedInUser.getId_User());
            session.setAttribute("loggedInUser", SecurityUtils.sanitizeUserForSession(refreshed));
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin cá nhân thành công!");
        } catch (UserException | CustomerException | IllegalArgumentException e) {
            preserveStaffProfileForm(redirectAttributes, fullName, email, phone, avatar);
            mapStaffProfileFieldError(redirectAttributes, e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            preserveStaffProfileForm(redirectAttributes, fullName, email, phone, avatar);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        return "redirect:/staff/profile";
    }

    private void preserveStaffProfileForm(RedirectAttributes redirectAttributes,
                                          String fullName, String email, String phone, String avatar) {
        redirectAttributes.addFlashAttribute("formFullName", fullName != null ? fullName.trim() : "");
        redirectAttributes.addFlashAttribute("formEmail", email != null ? email.trim() : "");
        redirectAttributes.addFlashAttribute("formPhone", phone != null ? phone.trim() : "");
        redirectAttributes.addFlashAttribute("formAvatar", avatar != null ? avatar.trim() : "");
    }

    private void mapStaffProfileFieldError(RedirectAttributes redirectAttributes, String message) {
        if (message == null || message.isBlank()) {
            return;
        }
        String lower = message.toLowerCase();
        if (lower.contains("email")) {
            redirectAttributes.addFlashAttribute("errorFieldEmail", message);
        } else if (lower.contains("điện thoại") || lower.contains("phone")) {
            redirectAttributes.addFlashAttribute("errorFieldPhone", message);
        } else if (lower.contains("họ") || lower.contains("tên") || lower.contains("fullname")) {
            redirectAttributes.addFlashAttribute("errorFieldFullName", message);
        } else if (lower.contains("avatar") || lower.contains("ảnh")) {
            redirectAttributes.addFlashAttribute("errorFieldAvatar", message);
        }
    }

    @GetMapping("/tickets")
    public String showTickets(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            Model model) {
        try {
            String filterStatus = (status == null || status.isBlank()) ? "all" : status;
            List<Ticket> tickets = ticketService.searchTickets(keyword, filterStatus);
            model.addAttribute("ticketList", tickets);
            model.addAttribute("currentKeyword", keyword);
            model.addAttribute("currentStatus", filterStatus);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Lỗi tải danh sách vé: " + e.getMessage());
            model.addAttribute("ticketList", new ArrayList<>());
        }

        model.addAttribute("view", "tickets");
        model.addAttribute("body", path + "tickets.jsp");
        return pathview;
    }

    @GetMapping("/check-ticket")
    public String showCheckTicket(Model model) {
        model.addAttribute("view", "check_ticket");
        model.addAttribute("body", path + "check_ticket.jsp");
        return pathview;
    }

    @PostMapping("/check-ticket")
    public String processCheckTicket(
            @RequestParam(required = false) Integer ticketId,
            @RequestParam(required = false) Integer bookingId,
            Model model) {
        model.addAttribute("view", "check_ticket");

        try {
            if (ticketId != null && ticketId > 0) {
                Map<String, Object> result = ticketService.validateTicketForCheck(ticketId);
                model.addAttribute("checkResult", result);
                model.addAttribute("checkedTickets", List.of(result.get("ticket")));
                model.addAttribute("exportTicketId", ticketId);
            } else if (bookingId != null && bookingId > 0) {
                List<Ticket> tickets = ticketService.getTicketsByBookingId(bookingId);
                if (tickets.isEmpty()) {
                    model.addAttribute("errorMessage", "Không tìm thấy vé cho đơn đặt #" + bookingId);
                } else {
                    List<Map<String, Object>> results = new ArrayList<>();
                    for (Ticket t : tickets) {
                        results.add(ticketService.validateTicketForCheck(t.getId_Ticket()));
                    }
                    model.addAttribute("bookingResults", results);
                    model.addAttribute("checkedTickets", tickets);
                    model.addAttribute("exportBookingId", bookingId);
                }
            } else {
                model.addAttribute("errorMessage", "Vui lòng nhập mã vé hoặc mã đơn đặt vé");
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Lỗi soát vé: " + e.getMessage());
        }

        model.addAttribute("body", path + "check_ticket.jsp");
        return pathview;
    }

    @GetMapping("/check-ticket/export-pdf")
    public void exportCheckTicketPdf(
            @RequestParam(required = false) Integer ticketId,
            @RequestParam(required = false) Integer bookingId,
            HttpServletResponse response) throws java.io.IOException {
        try {
            Map<String, Object> exportData = ticketService.buildCheckTicketExportData(ticketId, bookingId);
            byte[] pdfBytes = TicketCheckPdfExporter.export(exportData, ticketId, bookingId);

            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd-HHmmss"));
            String fileName;
            if (ticketId != null && ticketId > 0) {
                fileName = "hoa-don-soat-ve-" + ticketId + "-" + timestamp + ".pdf";
            } else {
                fileName = "hoa-don-soat-don-" + bookingId + "-" + timestamp + ".pdf";
            }

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength(pdfBytes.length);
            response.getOutputStream().write(pdfBytes);
            response.getOutputStream().flush();
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không thể xuất file PDF: " + e.getMessage());
        }
    }

    @GetMapping("/showtimes")
    public String showShowtimes(
            @RequestParam(required = false) String date,
            Model model) {
        try {
            String targetDate = (date != null && !date.isBlank())
                    ? date
                    : LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
            List<Map<String, Object>> showtimes = reportRepository.getShowtimesWithRoomByDate(targetDate);
            model.addAttribute("showtimeList", showtimes);
            model.addAttribute("movieListForDate", buildUniqueMovies(showtimes));
            model.addAttribute("selectedDate", targetDate);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Lỗi tải lịch chiếu: " + e.getMessage());
            model.addAttribute("showtimeList", new ArrayList<>());
            model.addAttribute("movieListForDate", new ArrayList<>());
            model.addAttribute("selectedDate", LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE));
        }

        model.addAttribute("view", "showtimes");
        model.addAttribute("body", path + "showtimes.jsp");
        return pathview;
    }

    @GetMapping(value = "/api/showtimes", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Map<String, Object>> getStaffShowtimes(@RequestParam("movieId") int movieId,
                                                       @RequestParam("date") String dateStr) {
        List<Map<String, Object>> responseData = new ArrayList<>();
        try {
            java.sql.Date selectedDate = java.sql.Date.valueOf(dateStr);
            List<Showtime> showtimes = movieService.getShowtimesByMovieAndDate(movieId, selectedDate);
            for (Showtime st : showtimes) {
                Map<String, Object> map = new HashMap<>();
                map.put("id_Showtime", st.getId_Showtime());
                map.put("roomId", st.getRoomId());
                String timeStr = "";
                if (st.getStartTime() != null) {
                    timeStr = st.getStartTime().toString();
                    if (timeStr.length() >= 5) {
                        timeStr = timeStr.substring(0, 5);
                    }
                }
                map.put("startTime", timeStr);
                responseData.add(map);
            }
        } catch (Exception ignored) {
        }
        return responseData;
    }

    @GetMapping(value = "/api/show-dates", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<String> getStaffShowDates(@RequestParam("movieId") int movieId) {
        List<String> dates = new ArrayList<>();
        try {
            java.util.LinkedHashSet<String> unique = new java.util.LinkedHashSet<>();
            List<Showtime> showtimes = showtimeService.getUpcomingShowtimesByMovie(movieId);
            for (Showtime st : showtimes) {
                if (st.getShowDate() != null) {
                    unique.add(st.getShowDate().toLocalDate().format(DateTimeFormatter.ISO_LOCAL_DATE));
                }
            }
            dates.addAll(unique);
        } catch (Exception ignored) {
        }
        return dates;
    }

    @GetMapping(value = "/api/seats", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> getStaffSeats(@RequestParam("showtimeId") int showtimeId) {
        Map<String, Object> result = new HashMap<>();
        Room room = roomRepository.findRoomWithSeatStatusByShowtimeId(showtimeId);
        if (room == null) {
            result.put("totalRows", 0);
            result.put("totalCols", 0);
            result.put("seats", List.of());
            return result;
        }

        List<Map<String, Object>> seats = new ArrayList<>();
        if (room.getSeats() != null) {
            for (Seat seat : room.getSeats()) {
                Map<String, Object> map = new HashMap<>();
                String rawStatus = seat.getStatus();
                boolean sold = "Sold".equalsIgnoreCase(rawStatus) || "Sold_Maintenance".equalsIgnoreCase(rawStatus);
                boolean unavailable = !sold && ("Broken".equalsIgnoreCase(rawStatus)
                        || "Maintenance".equalsIgnoreCase(rawStatus));
                String displayStatus = sold ? "Sold" : (unavailable ? "Maintenance" : "Available");
                map.put("seatName", seat.getSeatName());
                map.put("rowPos", seat.getRowPos());
                map.put("colPos", seat.getColPos());
                map.put("status", displayStatus);
                map.put("sold", sold);
                map.put("unavailable", unavailable);
                seats.add(map);
            }
        }

        result.put("totalRows", room.getTotalRows());
        result.put("totalCols", room.getTotalCols());
        result.put("roomName", room.getRoomName());
        result.put("seats", seats);
        return result;
    }

    @GetMapping(value = "/api/qr-code", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> generateStaffQrPayment(@RequestParam("amount") double amount, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            result.put("error", "Chưa đăng nhập");
            return result;
        }
        String code = paymentService.generateQrTransactionCode(loggedInUser.getId_User(), amount);
        result.put("transactionCode", code);
        result.put("qrUrl", "https://api.qrserver.com/v1/create-qr-code/?size=220x220&data="
                + java.net.URLEncoder.encode(code, java.nio.charset.StandardCharsets.UTF_8));
        result.put("amount", amount);
        result.put("bankName", "Vietcombank");
        result.put("accountNumber", "1028888999");
        result.put("accountName", "CONG TY STARLIGHT CINEMA");
        return result;
    }

    @GetMapping(value = "/api/customer/check-contact", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> checkCustomerContact(@RequestParam(value = "phone", required = false) String phone,
                                                    @RequestParam(value = "email", required = false) String email) {
        Map<String, Object> result = new HashMap<>();
        try {
            return userService.checkCustomerContact(phone, email);
        } catch (UserException e) {
            result.put("exists", false);
            result.put("conflict", false);
            result.put("error", e.getMessage());
            result.put("message", e.getMessage());
            return result;
        }
    }

    @GetMapping(value = "/api/customer/check-name", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> checkCustomerName(@RequestParam("fullName") String fullName) {
        Map<String, Object> result = new HashMap<>();
        boolean exists = userService.customerNameExists(fullName);
        result.put("exists", exists);
        result.put("message", exists
                ? "Tên đã có trong hệ thống — nhập số điện thoại để tìm khách hàng."
                : "Tên chưa có — nhập đầy đủ họ tên, SĐT và email để tạo khách mới.");
        return result;
    }

    @GetMapping(value = "/api/customer/lookup", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> lookupCustomer(@RequestParam("fullName") String fullName,
                                              @RequestParam(value = "phone", required = false) String phone,
                                              @RequestParam(value = "email", required = false) String email) {
        Map<String, Object> result = new HashMap<>();
        User customer = userService.findCustomerByFullNameAndContact(fullName, phone, email);
        if (customer == null) {
            result.put("found", false);
            result.put("error", "Không tìm thấy khách hàng với họ tên và thông tin liên hệ đã nhập!");
            return result;
        }
        result.put("found", true);
        Map<String, Object> info = new HashMap<>();
        info.put("id", customer.getId_User());
        info.put("fullName", customer.getFullName());
        info.put("phone", customer.getPhone());
        info.put("email", customer.getEmail());
        result.put("customer", info);
        return result;
    }

    @PostMapping("/booking/checkout")
    public String staffCheckout(@RequestParam("showtimeId") int showtimeId,
                                @RequestParam("selectedSeats") String selectedSeats,
                                @RequestParam("paymentMethod") String paymentMethod,
                                @RequestParam("customerFullName") String customerFullName,
                                @RequestParam("customerPhone") String customerPhone,
                                @RequestParam(value = "customerEmail", required = false) String customerEmail,
                                @RequestParam(value = "qrTransactionCode", required = false) String qrTransactionCode,
                                @RequestParam(value = "returnDate", required = false) String returnDate,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-staff";
        }

        String dateParam = (returnDate != null && !returnDate.isBlank())
                ? "?date=" + returnDate.trim() : "";

        try {
            int customerUserId = userService.resolveCustomerForStaffBooking(
                    customerFullName, customerPhone, customerEmail);

            String[] seatNames = selectedSeats.split(",");
            int bookingId = bookingService.processCustomerCheckout(
                    customerUserId,
                    showtimeId,
                    seatNames,
                    paymentMethod,
                    null,
                    null,
                    null,
                    qrTransactionCode,
                    loggedInUser.getId_User()
            );
            redirectAttributes.addFlashAttribute("successMessage",
                    "Đặt vé thành công! Mã đơn #" + bookingId);
        } catch (BookingException | PaymentException | UserException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        return "redirect:/staff/showtimes" + dateParam;
    }

    @GetMapping("/movies")
    public String showMovies(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) String status,
            Model model) {
        try {
            List<Movie> movies = movieService.searchAndFilterMovies(keyword, genre, status);
            model.addAttribute("movieList", movies);
            model.addAttribute("currentKeyword", keyword);
            model.addAttribute("currentGenre", genre);
            model.addAttribute("currentStatus", status);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Lỗi tải danh sách phim: " + e.getMessage());
            model.addAttribute("movieList", new ArrayList<>());
        }

        model.addAttribute("view", "movies");
        model.addAttribute("body", path + "movies.jsp");
        return pathview;
    }

    @GetMapping("/movies/detail")
    public String showMovieDetail(@RequestParam("id") int id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Movie movie = movieService.getMovieById(id);
            model.addAttribute("movie", movie);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi tải chi tiết phim: " + e.getMessage());
            return "redirect:/staff/movies";
        }

        model.addAttribute("view", "movies");
        model.addAttribute("body", path + "movie_detail.jsp");
        return pathview;
    }

    private void initEmptyStaffDashboard(Model model) {
        model.addAttribute("summary", new HashMap<>());
        model.addAttribute("todayShowtimes", new ArrayList<>());
        model.addAttribute("revenueByShift", new ArrayList<>());
        model.addAttribute("ticketSalesByMovie", new ArrayList<>());
        model.addAttribute("recentBookings", new ArrayList<>());
    }

    private List<Map<String, Object>> buildUniqueMovies(List<Map<String, Object>> showtimes) {
        Map<Integer, Map<String, Object>> unique = new java.util.LinkedHashMap<>();
        if (showtimes == null) {
            return new ArrayList<>();
        }
        for (Map<String, Object> st : showtimes) {
            Object movieIdObj = st.get("movieId");
            if (movieIdObj == null) {
                continue;
            }
            int movieId = ((Number) movieIdObj).intValue();
            if (!unique.containsKey(movieId)) {
                Map<String, Object> movie = new HashMap<>();
                movie.put("movieId", movieId);
                movie.put("movieTitle", st.get("movieTitle"));
                movie.put("posterUrl", st.get("posterUrl"));
                movie.put("basePrice", st.get("basePrice"));
                unique.put(movieId, movie);
            }
        }
        return new ArrayList<>(unique.values());
    }
}
