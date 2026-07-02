package uef.edu.vn.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import uef.edu.vn.exception.CustomerException;
import uef.edu.vn.exception.UserException;
import uef.edu.vn.model.User;
import uef.edu.vn.service.UserService;
import uef.edu.vn.util.AvatarUtils;
import uef.edu.vn.util.SecurityUtils;

@Controller
@RequestMapping("/admin")
public class AdminProfileController {

    private final String path = "/WEB-INF/views/admin/";
    private final String pathview = "layout/admin-layout/main";

    private final UserService userService;

    @Autowired
    public AdminProfileController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/profile")
    public String showAdminProfile(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-admin";
        }

        try {
            User adminUser = userService.getUserById(loggedInUser.getId_User());
            model.addAttribute("adminUser", adminUser);
            model.addAttribute("view", "profile");
            model.addAttribute("body", path + "profile.jsp");
            return pathview;
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/dashboard";
        }
    }

    @PostMapping("/profile/update")
    public String updateAdminProfile(HttpSession session,
                                     HttpServletRequest request,
                                     @RequestParam("fullName") String fullName,
                                     @RequestParam("email") String email,
                                     @RequestParam("phone") String phone,
                                     @RequestParam(value = "avatar", required = false) String avatar,
                                     @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                     RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login-admin";
        }

        try {
            User adminUser = userService.getUserById(loggedInUser.getId_User());
            adminUser.setFullName(fullName != null ? fullName.trim() : "");
            adminUser.setEmail(email != null ? email.trim() : "");
            adminUser.setPhone(phone != null ? phone.trim() : "");

            String updatedAvatar = AvatarUtils.applyAvatarFromRequest(
                    adminUser.getAvatar(), avatar, imageFile, request.getServletContext());
            adminUser.setAvatar(updatedAvatar);

            userService.updateProfile(adminUser);

            User refreshed = userService.getUserById(loggedInUser.getId_User());
            session.setAttribute("loggedInUser", SecurityUtils.sanitizeUserForSession(refreshed));
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin cá nhân thành công!");
        } catch (UserException | CustomerException | IllegalArgumentException e) {
            preserveProfileForm(redirectAttributes, fullName, email, phone, avatar);
            mapProfileFieldError(redirectAttributes, e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            preserveProfileForm(redirectAttributes, fullName, email, phone, avatar);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        return "redirect:/admin/profile";
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
}
