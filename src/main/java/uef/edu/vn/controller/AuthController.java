package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import uef.edu.vn.model.User;
import uef.edu.vn.service.UserService;
import uef.edu.vn.util.SecurityUtils;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @GetMapping("/login-admin")
    public String showLoginAdmin() {
        return "auth/login-admin"; 
    }

    @PostMapping("/login-admin")
    public String processLoginAdmin(@RequestParam("username") String username, 
                                    @RequestParam("password") String password, 
                                    HttpSession session, Model model) {
        try {
            User user = userService.authenticatePortalUser(username, password);
            String portalRole = userService.resolvePortalRole(user.getId_User());
            User safeUser = SecurityUtils.sanitizeUserForSession(user);
            session.setAttribute("loggedInUser", safeUser);
            session.setAttribute("userRole", portalRole);
            session.setAttribute("portalRole", portalRole);
            session.setAttribute("readOnlyMode", Boolean.FALSE);
            return "redirect:/admin/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "auth/login-admin";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); 
        return "redirect:/login-admin"; 
    }

    @GetMapping("/login-staff")
    public String showLoginStaff() {
        return "auth/login-staff";
    }

    @PostMapping("/login-staff")
    public String processLoginStaff(@RequestParam("username") String username,
                                    @RequestParam("password") String password,
                                    HttpSession session, Model model) {
        try {
            User user = userService.authenticate(username, password);

            if (user != null) {
                if (!SecurityUtils.hasStaffPortalAccess(user)) {
                    model.addAttribute("error", "Tài khoản không có quyền truy cập hệ thống nhân viên!");
                    return "auth/login-staff";
                }

                session.setAttribute("loggedInUser", SecurityUtils.sanitizeUserForSession(user));
                session.setAttribute("userRole", resolvePrimaryRole(user, "STAFF"));
                return "redirect:/staff/dashboard";
            } else {
                model.addAttribute("error", "Đăng nhập thất bại!");
                return "auth/login-staff";
            }
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "auth/login-staff";
        }
    }

    @GetMapping("/logout-staff")
    public String logoutStaff(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("successMessage", "Đã đăng xuất thành công!");
        return "redirect:/login-staff";
    }

    @GetMapping("/login-customer")
    public String showLoginCustomer() {
        return "auth/login-customer";
    }

    @PostMapping("/login-customer")
    public String processLoginCustomer(@RequestParam("username") String username,
                                       @RequestParam("password") String password,
                                       HttpSession session, Model model) {
        try {
            User user = userService.authenticate(username, password);
            session.setAttribute("loggedInUser", SecurityUtils.sanitizeUserForSession(user));
            session.setAttribute("userRole", resolvePrimaryRole(user, "CUSTOMER"));
            return "redirect:/customer/home";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "auth/login-customer";
        }
    }

    @GetMapping("/register-customer")
    public String showRegisterCustomer() {
        return "auth/register-customer";
    }

    @PostMapping("/register-customer")
    public String processRegisterCustomer(@RequestParam("fullName") String fullName,
                                          @RequestParam("email") String email,
                                          @RequestParam("username") String username,
                                          @RequestParam("phone") String phone,
                                          @RequestParam("password") String password,
                                          Model model,
                                          RedirectAttributes redirectAttributes) {
        try {
            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim());
            user.setUsername(username.trim());
            user.setPhone(phone.trim());
            user.setPassword(password);

            userService.registerUser(user);
            redirectAttributes.addFlashAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "redirect:/login-customer";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "auth/register-customer";
        }
    }

    @GetMapping("/logout-customer")
    public String logoutCustomer(HttpSession session) {
        session.invalidate();
        return "redirect:/login-customer";
    }

    private String resolvePrimaryRole(User user, String fallback) {
        if (user.getRoles() != null && !user.getRoles().isEmpty()) {
            return user.getRoles().get(0).getRoleName().toUpperCase();
        }
        return fallback;
    }
}