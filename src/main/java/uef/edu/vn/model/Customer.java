package uef.edu.vn.model;

import jakarta.validation.constraints.*;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

public class Customer {

    @Min(value = 0, message = "ID khách hàng không được là số âm")
    private int id_Customer;

    @NotBlank(message = "Tên đăng nhập không được để trống")
    @Size(min = 4, max = 50, message = "Tên đăng nhập phải từ 4 đến 50 ký tự")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Tên đăng nhập không hợp lệ (Chỉ chứa chữ cái, số và dấu gạch dưới)")
    private String username;

    @NotBlank(message = "Họ và tên không được để trống")
    @Size(max = 100, message = "Họ và tên không được vượt quá 100 ký tự")
    private String fullName;

    @Size(max = 255, message = "Đường dẫn Avatar quá dài")
    private String avatar;

    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không đúng định dạng (Ví dụ: nguyenvan@gmail.com)")
    private String email;

    @NotBlank(message = "Số điện thoại không được để trống")
    @Pattern(regexp = "^(0|\\+84)[0-9]{9}$", message = "Số điện thoại không hợp lệ (Phải là số di động Việt Nam gồm 10 số)")
    private String phone;

    @PastOrPresent(message = "Ngày đăng ký không được nằm trong tương lai")
    private Date createdAt;

    @NotBlank(message = "Trạng thái tài khoản không được để trống")
    private String status;

    @PositiveOrZero(message = "Tổng số đơn đặt vé không được là số âm")
    private int totalBookings;

    @PositiveOrZero(message = "Tổng chi tiêu không được là số âm")
    private double totalSpent;

    @AssertTrue(message = "Lỗi logic: Trạng thái khách hàng không hợp lệ! (Chỉ chấp nhận: Active, Inactive, Locked, Unverified)")
    public boolean isStatusValid() {
        if (this.status != null) {
            List<String> validStatuses = Arrays.asList("Active", "Inactive", "Locked", "Unverified");
            return validStatuses.contains(this.status);
        }
        return true;
    }

    public Customer() {
        this.id_Customer = 0;
        this.username = "";
        this.fullName = "Chưa cập nhật";
        this.avatar = "default_avatar.png";
        this.email = "";
        this.phone = "";
        this.createdAt = new Date();
        this.status = "Active";
        this.totalBookings = 0;
        this.totalSpent = 0.0;
    }

    public Customer(int id_Customer, String username, String fullName, String avatar,
                    String email, String phone, Date createdAt, String status,
                    int totalBookings, double totalSpent) {
        this.id_Customer = id_Customer;
        this.username = username;
        this.fullName = fullName;
        this.avatar = avatar;
        this.email = email;
        this.phone = phone;
        this.createdAt = createdAt;
        this.status = status;
        this.totalBookings = totalBookings;
        this.totalSpent = totalSpent;
    }

    public int getId_Customer() { return id_Customer; }
    public void setId_Customer(int id_Customer) { this.id_Customer = id_Customer; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }

    public double getTotalSpent() { return totalSpent; }
    public void setTotalSpent(double totalSpent) { this.totalSpent = totalSpent; }
}