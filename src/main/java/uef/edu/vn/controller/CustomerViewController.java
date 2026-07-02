package uef.edu.vn.controller;

import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import uef.edu.vn.util.AvatarUtils;
import uef.edu.vn.util.SecurityUtils;

import uef.edu.vn.exception.CustomerException;
import uef.edu.vn.exception.PaymentException;
import uef.edu.vn.model.Booking;
import uef.edu.vn.model.Movie;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.Seat;
import uef.edu.vn.model.Showtime;
import uef.edu.vn.model.User;
import uef.edu.vn.repository.RoomRepository;
import uef.edu.vn.service.BookingService;
import uef.edu.vn.service.CustomerService;
import uef.edu.vn.service.MovieService;
import uef.edu.vn.service.PaymentService;

@Controller
@RequestMapping("/customer")
public class CustomerViewController {

    private static final List<String> GENRE_LIST = List.of(
            "Hành động", "Kinh dị", "Tình cảm", "Hoạt hình", "Hài hước",
            "Viễn tưởng", "Phiêu lưu", "Tâm lý", "Gia đình");

    private final CustomerService customerService;
    private final BookingService bookingService;
    private final MovieService movieService;
    private final PaymentService paymentService;
    private final RoomRepository roomRepository;

    private final String path = "/WEB-INF/views/customer/";
    private final String pathview = "layout/customer-layout/main";

    @Autowired
    public CustomerViewController(CustomerService customerService,
                                  BookingService bookingService,
                                  MovieService movieService,
                                  PaymentService paymentService,
                                  RoomRepository roomRepository) {
        this.customerService = customerService;
        this.bookingService = bookingService;
        this.movieService = movieService;
        this.paymentService = paymentService;
        this.roomRepository = roomRepository;
    }

    @ModelAttribute("genreList")
    public List<String> genreList() {
        return GENRE_LIST;
    }

    @GetMapping({"", "/", "/home"})
    public String showCustomerHome(Model model, @RequestParam(value = "date", required = false) String dateStr) {
        List<Map<String, Object>> dateTabs = new ArrayList<>();
        java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("dd/MM");
        java.text.SimpleDateFormat labelFormat = new java.text.SimpleDateFormat("EEE", new java.util.Locale("vi", "VN"));
        java.text.SimpleDateFormat dbFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
        java.text.SimpleDateFormat displayFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");

        Calendar cal = Calendar.getInstance();
        java.sql.Date todaySql = new java.sql.Date(cal.getTimeInMillis());
        String todayStr = dbFormat.format(cal.getTime());

        String selectedDateStr = (dateStr != null && !dateStr.isBlank()) ? dateStr.trim() : todayStr;
        java.sql.Date selectedSql;
        try {
            selectedSql = java.sql.Date.valueOf(selectedDateStr);
        } catch (Exception e) {
            selectedSql = todaySql;
            selectedDateStr = todayStr;
        }

        for (int i = 0; i < 7; i++) {
            Map<String, Object> tab = new HashMap<>();
            String dbDateStr = dbFormat.format(cal.getTime());
            String dayStr = dayFormat.format(cal.getTime());
            String dayLabel = (i == 0) ? "Hôm nay" : labelFormat.format(cal.getTime());

            tab.put("dbDate", dbDateStr);
            tab.put("dayStr", dayStr);
            tab.put("dayLabel", dayLabel);

            dateTabs.add(tab);
            cal.add(Calendar.DAY_OF_YEAR, 1);
        }
        model.addAttribute("dateTabs", dateTabs);
        model.addAttribute("selectedDate", selectedDateStr);
        model.addAttribute("selectedDateDisplay", displayFormat.format(selectedSql));

        List<Movie> movieList = movieService.getMoviesWithShowtimesForCalendarDate(selectedSql);
        model.addAttribute("movieList", movieList);

        if (movieList != null && !movieList.isEmpty()) {
            model.addAttribute("heroMovie", movieList.get(0));
        }

        model.addAttribute("totalMovies", movieList != null ? movieList.size() : 0);
        model.addAttribute("totalRooms", 5);
        model.addAttribute("totalMembers", customerService.getTotalCustomerCount());

        model.addAttribute("view", "home");
        model.addAttribute("body", path + "home.jsp");
        
        return pathview;
    }

    @GetMapping(value = "/api/showtimes", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Map<String, Object>> getShowtimesByJson(@RequestParam("movieId") int movieId, @RequestParam("date") String dateStr) {
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
            return responseData;
        } catch (Exception e) {
            e.printStackTrace();
            return responseData;
        }
    }

    @GetMapping(value = "/api/movies-by-date", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Map<String, Object>> getMoviesByDate(@RequestParam("date") String dateStr) {
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            java.sql.Date selectedDate = java.sql.Date.valueOf(dateStr);
            List<Movie> movies = movieService.getMoviesWithShowtimesForCalendarDate(selectedDate);
            for (Movie movie : movies) {
                Map<String, Object> map = new HashMap<>();
                map.put("id_Movie", movie.getId_Movie());
                map.put("title", movie.getTitle());
                map.put("posterUrl", movie.getPosterUrl());
                map.put("basePrice", movie.getBasePrice());
                map.put("genre", movie.getGenre());
                map.put("duration", movie.getDuration());

                List<String> times = new ArrayList<>();
                if (movie.getShowtimes() != null) {
                    for (Showtime st : movie.getShowtimes()) {
                        if (st.getStartTime() != null) {
                            String t = st.getStartTime().toString();
                            times.add(t.length() >= 5 ? t.substring(0, 5) : t);
                        }
                    }
                }
                map.put("showtimes", times);
                result.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @GetMapping(value = "/api/payments", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Map<String, Object>> getUserPayments(HttpSession session) {
        List<Map<String, Object>> result = new ArrayList<>();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return result;
        }
        List<Payment> payments = paymentService.getPaymentsByUser(loggedInUser.getId_User());
        for (Payment p : payments) {
            Map<String, Object> map = new HashMap<>();
            map.put("id_Payment", p.getId_Payment());
            String card = p.getCardNumber();
            String masked = card.length() >= 4 ? "**** **** **** " + card.substring(card.length() - 4) : card;
            map.put("cardNumberMasked", masked);
            map.put("balance", p.getBalance());
            result.add(map);
        }
        return result;
    }

    @GetMapping(value = "/api/seats", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> getSeatsByShowtime(@RequestParam("showtimeId") int showtimeId) {
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
                String seatName = seat.getSeatName();
                String rawStatus = seat.getStatus();
                boolean sold = "Sold".equalsIgnoreCase(rawStatus) || "Sold_Maintenance".equalsIgnoreCase(rawStatus);
                boolean unavailable = !sold && ("Broken".equalsIgnoreCase(rawStatus)
                        || "Maintenance".equalsIgnoreCase(rawStatus));
                String displayStatus = sold ? "Sold" : (unavailable ? "Maintenance" : "Available");
                map.put("seatName", seatName);
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
        result.put("roomType", room.getRoomType());
        result.put("roomPrice", room.getRoomPrice());
        result.put("seats", seats);
        return result;
    }

    @GetMapping(value = "/api/qr-code", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> generateQrPayment(@RequestParam("amount") double amount, HttpSession session) {
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

    @GetMapping(value = "/api/booking-detail", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> getBookingDetail(@RequestParam("bookingId") int bookingId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            result.put("error", "Chưa đăng nhập");
            return result;
        }
        try {
            return bookingService.getCustomerBookingDetail(bookingId, loggedInUser.getId_User());
        } catch (Exception e) {
            result.put("error", e.getMessage());
            return result;
        }
    }

    @PostMapping(value = "/api/verify-card-pin", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> verifyCardPin(@RequestParam("cardNumber") String cardNumber,
                                             @RequestParam("pinCode") String pinCode,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            result.put("valid", false);
            result.put("error", "Chưa đăng nhập");
            return result;
        }
        try {
            paymentService.verifyCardPin(cardNumber, pinCode);
            result.put("valid", true);
        } catch (PaymentException e) {
            result.put("valid", false);
            result.put("error", e.getMessage());
        }
        return result;
    }

    @GetMapping("/profile")
    public String showCustomerProfile(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-customer";
        }

        try {
            User customer = customerService.getCustomerById(loggedInUser.getId_User());
            model.addAttribute("customer", customer);
            model.addAttribute("view", "profile");
            model.addAttribute("body", path + "profile.jsp");
            return pathview;
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/login-customer";
        }
    }

    @PostMapping("/profile/update")
    public String updateCustomerProfile(HttpSession session,
                                        HttpServletRequest request,
                                        @RequestParam("fullName") String fullName,
                                        @RequestParam("email") String email,
                                        @RequestParam("phone") String phone,
                                        @RequestParam(value = "avatar", required = false) String avatar,
                                        @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                        RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-customer";
        }

        try {
            User customer = customerService.getCustomerById(loggedInUser.getId_User());
            customer.setFullName(fullName != null ? fullName.trim() : "");
            customer.setEmail(email != null ? email.trim() : "");
            customer.setPhone(phone != null ? phone.trim() : "");

            String updatedAvatar = AvatarUtils.applyAvatarFromRequest(
                    customer.getAvatar(), avatar, imageFile, request.getServletContext());
            customer.setAvatar(updatedAvatar);

            customerService.updateCustomer(customer);

            User refreshed = customerService.getCustomerById(loggedInUser.getId_User());
            session.setAttribute("loggedInUser", SecurityUtils.sanitizeUserForSession(refreshed));

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin cá nhân thành công!");
        } catch (CustomerException | IllegalArgumentException e) {
            preserveProfileForm(redirectAttributes, fullName, email, phone, avatar);
            mapProfileFieldError(redirectAttributes, e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            preserveProfileForm(redirectAttributes, fullName, email, phone, avatar);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }
        return "redirect:/customer/profile";
    }

    private void preserveProfileForm(RedirectAttributes redirectAttributes,
                                     String fullName, String email, String phone, String avatar) {
        redirectAttributes.addFlashAttribute("formFullName", fullName != null ? fullName.trim() : "");
        redirectAttributes.addFlashAttribute("formEmail", email != null ? email.trim() : "");
        redirectAttributes.addFlashAttribute("formPhone", phone != null ? phone.trim() : "");
        redirectAttributes.addFlashAttribute("formAvatar", avatar != null ? avatar.trim() : "");
    }

    private void mapProfileFieldError(RedirectAttributes redirectAttributes, String message) {
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
    
    @GetMapping("/history")
    public String showBookingHistory(HttpSession session, Model model,
                                     @RequestParam(value = "bookingSuccess", required = false) String bookingSuccess,
                                     @RequestParam(value = "bookingError", required = false) String bookingError) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-customer";
        }

        try {
            List<Booking> bookingList = bookingService.getBookingHistoryByUser(loggedInUser.getId_User());
            model.addAttribute("bookingList", bookingList != null ? bookingList : new ArrayList<>());
            
            model.addAttribute("view", "history");
            model.addAttribute("body", path + "history.jsp");

            // Add messages to model for notification
            if (bookingSuccess != null) {
                model.addAttribute("successMessage", "Đặt vé thành công! Cảm ơn bạn đã sử dụng dịch vụ.");
            }
            if (bookingError != null) {
                model.addAttribute("errorMessage", "Đặt vé thất bại: " + bookingError);
            }

            return pathview;
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("errorMessage", "Không thể tải lịch sử đặt vé: " + e.getMessage());
            return "redirect:/customer/home";
        }
    }
    
    @GetMapping("/showtimes")
    public String showCustomerShowtimes(@RequestParam(value = "date", required = false) String dateStr, Model model) {
        List<Map<String, Object>> dateTabs = new ArrayList<>();
        java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("dd/MM");
        java.text.SimpleDateFormat labelFormat = new java.text.SimpleDateFormat("EEE", new java.util.Locale("vi", "VN"));
        java.text.SimpleDateFormat dbFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");

        Calendar cal = Calendar.getInstance();
        String todayStr = dbFormat.format(cal.getTime());
        String selectedDateStr = (dateStr != null && !dateStr.isEmpty()) ? dateStr : todayStr;
        
        // Khởi tạo lại Calendar để tạo 7 ngày bắt đầu từ hôm nay
        cal = Calendar.getInstance();
        for (int i = 0; i < 7; i++) {
            Map<String, Object> tab = new HashMap<>();
            String dStr = dbFormat.format(cal.getTime());
            tab.put("dbDate", dStr);
            tab.put("dayStr", dayFormat.format(cal.getTime()));
            tab.put("dayLabel", (i == 0) ? "Hôm nay" : labelFormat.format(cal.getTime()));
            dateTabs.add(tab);
            cal.add(Calendar.DAY_OF_YEAR, 1);
        }
        
        java.sql.Date sqlDate;
        try {
            sqlDate = java.sql.Date.valueOf(selectedDateStr);
        } catch (Exception e) {
            sqlDate = new java.sql.Date(System.currentTimeMillis());
            selectedDateStr = todayStr;
        }

        List<Movie> movieList = movieService.getMoviesWithShowtimesForDate(sqlDate);
        
        model.addAttribute("dateTabs", dateTabs);
        model.addAttribute("selectedDate", selectedDateStr);
        model.addAttribute("movieList", movieList);
        model.addAttribute("view", "showtimes");
        model.addAttribute("body", path + "showtimes.jsp");
        return pathview;
    }
    
    @GetMapping("/movies")
    public String showCustomerMovies(@RequestParam(value = "genre", required = false) String genre,
                                     @RequestParam(value = "keyword", required = false) String keyword,
                                     Model model) {
        String genreFilter = (genre != null && !genre.trim().isEmpty() && !"all".equalsIgnoreCase(genre.trim()))
                ? genre.trim() : null;
        String keywordFilter = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;

        List<Movie> movieList = movieService.searchMoviesWithShowtimesIn7Days(keywordFilter, genreFilter);
        model.addAttribute("movieList", movieList);
        model.addAttribute("currentGenre", genreFilter != null ? genreFilter : "all");
        model.addAttribute("currentKeyword", keywordFilter != null ? keywordFilter : "");

        model.addAttribute("view", "movies");
        model.addAttribute("body", path + "movies.jsp");
        return pathview;
    }
}