
package uef.edu.vn.service.impl;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import uef.edu.vn.exception.UserException;
import uef.edu.vn.model.Quyen;
import uef.edu.vn.model.User;
import uef.edu.vn.model.UserRole;
import uef.edu.vn.repository.UserRepository;
import uef.edu.vn.repository.QuyenRepository;
import uef.edu.vn.repository.UserRoleRepository;
import uef.edu.vn.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepo;
    private final QuyenRepository quyenRepo;
    private final UserRoleRepository userRoleRepo;

    @Autowired
    public UserServiceImpl(UserRepository userRepo, QuyenRepository quyenRepo, UserRoleRepository userRoleRepo) {
        this.userRepo = userRepo;
        this.quyenRepo = quyenRepo;
        this.userRoleRepo = userRoleRepo;
    }

    @Override
    public User authenticate(String username, String password) {
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            throw new UserException("Tên đăng nhập và mật khẩu không được để trống!");
        }

        User user = userRepo.findByUsername(username.trim());
        
        if (user == null) {
            throw new UserException("Tài khoản đăng nhập không tồn tại trên hệ thống!");
        }

        if ("Locked".equalsIgnoreCase(user.getStatus()) || "Banned".equalsIgnoreCase(user.getStatus())) {
            throw new UserException("Tài khoản này đã bị khóa. Vui lòng liên hệ Admin để mở lại!");
        }
        if ("Inactive".equalsIgnoreCase(user.getStatus())) {
            throw new UserException("Tài khoản chưa được kích hoạt hoặc đã bị ngừng sử dụng!");
        }

         String hashedInputPassword = hashPassword(password);
        if (!password.equals(user.getPassword()) && !hashedInputPassword.equals(user.getPassword())) {
            throw new UserException("Mật khẩu đăng nhập không chính xác!");
        }

        return user;
    }

    @Override
    public User authenticateAdmin(String username, String password) {
        User user = authenticate(username, password);
        if (!userRoleRepo.hasActiveAdminAccess(user.getId_User())) {
            throw new UserException("Bạn không có quyền truy cập khu vực Admin!");
        }
        return user;
    }

    @Override
    public User authenticatePortalUser(String username, String password) {
        User user = authenticate(username, password);
        if (userRoleRepo.hasActiveAdminAccess(user.getId_User())) {
            return user;
        }
        if (userRoleRepo.hasActiveManagerAccess(user.getId_User())) {
            return user;
        }
        throw new UserException("Bạn không có quyền truy cập khu vực quản trị!");
    }

    @Override
    public String resolvePortalRole(int userId) {
        if (userRoleRepo.hasActiveAdminAccess(userId)) {
            return "ADMIN";
        }
        if (userRoleRepo.hasActiveManagerAccess(userId)) {
            return "MANAGER";
        }
        return null;
    }

    @Override
    public void registerCustomer(User user) throws Exception {
        if (userRepo.findByUsername(user.getUsername()) != null) {
            throw new Exception("Tên đăng nhập đã tồn tại trong hệ thống!");
        }
        if (userRepo.findByEmail(user.getEmail()) != null) {
            throw new Exception("Email này đã được sử dụng!");
        }
        user.setPassword(hashPassword(user.getPassword()));
        int userId = userRepo.saveCustomerAndGetId(user);
        userRepo.assignCustomerRole(userId);
    }

    @Override
    public User registerUser(User user) {
        if (userRepo.findByUsername(user.getUsername().trim()) != null) {
            throw new UserException("Tên đăng nhập đã được sử dụng!");
        }
        if (user.getEmail() != null && userRepo.findByEmail(user.getEmail().trim()) != null) {
            throw new UserException("Địa chỉ Email đã tồn tại trên hệ thống!");
        }

        user.setPassword(hashPassword(user.getPassword()));
        user.setStatus("Active");

        try {
            boolean isSaved = userRepo.save(user); 
            if (!isSaved) {
                throw new UserException("Lỗi hệ thống: Không thể khởi tạo dữ liệu tài khoản mới!");
            }

            User savedUser = userRepo.findByUsername(user.getUsername().trim());
            Quyen customerRole = quyenRepo.findByRoleName("Customer"); 
            if (customerRole != null && savedUser != null) {
                userRepo.assignRoleToUser(savedUser.getId_User(), customerRole.getId_Role());
            }

            return savedUser;
        } catch (DataAccessException e) {
             throw new UserException("Lỗi CSDL khi đăng ký người dùng: " + e.getMessage());
        }
    }

    @Override
    public boolean lockAccount(int userId) {
        if (userRepo.findById(userId) == null) throw new UserException("Không tìm thấy người dùng!");
        return userRepo.changeStatus(userId, "Locked");
    }

    @Override
    public boolean unlockAccount(int userId) {
        if (userRepo.findById(userId) == null) throw new UserException("Không tìm thấy người dùng!");
        return userRepo.changeStatus(userId, "Active");
    }

    @Override
    public List<User> getAllUsers() {
        return userRepo.findAll();
    }

    @Override
    public User getUserById(int userId) {
        return userRepo.findById(userId);
    }

    @Override
    public boolean grantRoleToUser(int userId, String roleName) {
        Quyen role = quyenRepo.findByRoleName(roleName);
        if (role == null) throw new UserException("Quyền hạn không tồn tại!");

        UserRole existingLink = userRoleRepo.findByUserAndRole(userId, role.getId_Role());
        if (existingLink != null) {
            if ("Inactive".equalsIgnoreCase(existingLink.getStatus())) {
                return userRoleRepo.restoreRole(userId, role.getId_Role());
            }
            return true; 
        }
        return userRepo.assignRoleToUser(userId, role.getId_Role());
    }

    @Override
    public boolean revokeRoleFromUser(int userId, String roleName) {
        Quyen role = quyenRepo.findByRoleName(roleName);
        if (role == null) throw new UserException("Không tìm thấy quyền!");

        if ("ADMIN".equalsIgnoreCase(roleName) || "Admin".equalsIgnoreCase(roleName)) {
            User user = userRepo.findById(userId);
            if (user != null && (user.getRoles() == null || user.getRoles().size() <= 1)) {
                throw new UserException("Lỗi an toàn: Không thể thu hồi quyền ADMIN cuối cùng!");
            }
        }
        return userRoleRepo.revokeRole(userId, role.getId_Role());
    }

    @Override
    public List<Quyen> getUserRoles(int userId) {
        return quyenRepo.getRolesByUserId(userId);
    }

    @Override
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        User user = userRepo.findById(userId);
        if (user == null) throw new UserException("Người dùng không hợp lệ!");

        String hashedOld = hashPassword(oldPassword);
        if (!oldPassword.equals(user.getPassword()) && !hashedOld.equals(user.getPassword())) {
            throw new UserException("Mật khẩu hiện tại không chính xác!");
        }
        user.setPassword(hashPassword(newPassword));
        return userRepo.update(user);
    }

    @Override
    public boolean updateProfile(User user) {
        User existingUser = userRepo.findById(user.getId_User());
        if (existingUser == null) throw new UserException("Không tìm thấy tài khoản!");

        User checkEmail = userRepo.findByEmail(user.getEmail());
        if (checkEmail != null && checkEmail.getId_User() != user.getId_User()) {
            throw new UserException("Địa chỉ email đã thuộc về người khác!");
        }

        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setPhone(user.getPhone());
        existingUser.setAvatar(user.getAvatar());
        return userRepo.update(existingUser);
    }

    @Override
    public boolean customerNameExists(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return false;
        }
        return userRepo.existsCustomerByFullName(fullName.trim());
    }

    @Override
    public User findCustomerByFullNameAndPhone(String fullName, String phone) {
        if (fullName == null || fullName.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            return null;
        }
        return userRepo.findCustomerByFullNameAndPhone(fullName.trim(), phone.trim());
    }

    @Override
    public Map<String, Object> checkCustomerContact(String phone, String email) {
        String phoneNum = phone != null ? phone.trim() : "";
        String mail = email != null ? email.trim() : "";

        if (phoneNum.isEmpty() && mail.isEmpty()) {
            throw new UserException("Vui lòng nhập số điện thoại hoặc email khách hàng!");
        }
        if (!phoneNum.isEmpty() && !phoneNum.matches("^(0|\\+84)[0-9]{9}$")) {
            throw new UserException("Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0 hoặc +84)!");
        }
        if (!mail.isEmpty() && !mail.matches("^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            throw new UserException("Email không đúng định dạng!");
        }

        User byPhone = phoneNum.isEmpty() ? null : userRepo.findCustomerByPhone(phoneNum);
        User byEmail = mail.isEmpty() ? null : userRepo.findCustomerByEmail(mail);

        Map<String, Object> result = new HashMap<>();
        if (byPhone != null && byEmail != null && byPhone.getId_User() != byEmail.getId_User()) {
            result.put("exists", false);
            result.put("conflict", true);
            result.put("message", "Số điện thoại và email thuộc hai tài khoản khách hàng khác nhau. Vui lòng kiểm tra lại!");
            return result;
        }

        User matched = byPhone != null ? byPhone : byEmail;
        boolean exists = matched != null;
        result.put("exists", exists);
        result.put("conflict", false);
        if (exists) {
            String matchedBy;
            if (byPhone != null && byEmail != null) {
                matchedBy = "both";
            } else if (byPhone != null) {
                matchedBy = "phone";
            } else {
                matchedBy = "email";
            }
            result.put("matchedBy", matchedBy);
            Map<String, Object> customerInfo = new HashMap<>();
            customerInfo.put("id", matched.getId_User());
            customerInfo.put("fullName", matched.getFullName());
            customerInfo.put("phone", matched.getPhone());
            customerInfo.put("email", matched.getEmail());
            result.put("customer", customerInfo);
            result.put("message",
                    "Đã tìm thấy khách hàng trong hệ thống. Hóa đơn sẽ được lưu vào lịch sử thanh toán của khách này.");
        } else {
            result.put("message",
                    "Khách hàng chưa có trong hệ thống — nhập họ tên, SĐT và email để tạo tài khoản mới.");
        }
        return result;
    }

    @Override
    public User findCustomerByFullNameAndContact(String fullName, String phone, String email) {
        String name = fullName != null ? fullName.trim() : "";
        String phoneNum = phone != null ? phone.trim() : "";
        String mail = email != null ? email.trim() : "";

        if (name.isEmpty() || (phoneNum.isEmpty() && mail.isEmpty())) {
            return null;
        }

        User byPhone = phoneNum.isEmpty() ? null : userRepo.findCustomerByPhone(phoneNum);
        User byEmail = mail.isEmpty() ? null : userRepo.findCustomerByEmail(mail);

        if (byPhone != null && byEmail != null && byPhone.getId_User() != byEmail.getId_User()) {
            return null;
        }

        User target = byPhone != null ? byPhone : byEmail;
        if (target == null) {
            return null;
        }

        if (!name.equalsIgnoreCase(target.getFullName() != null ? target.getFullName().trim() : "")) {
            return null;
        }
        if (!phoneNum.isEmpty() && target.getPhone() != null
                && !phoneNum.equals(target.getPhone().trim())) {
            return null;
        }
        if (!mail.isEmpty() && target.getEmail() != null
                && !mail.equalsIgnoreCase(target.getEmail().trim())) {
            return null;
        }
        return target;
    }

    @Override
    public int resolveCustomerForStaffBooking(String fullName, String phone, String email) {
        String name = fullName != null ? fullName.trim() : "";
        String phoneNum = phone != null ? phone.trim() : "";
        String mail = email != null ? email.trim() : "";

        if (phoneNum.isEmpty() && mail.isEmpty()) {
            throw new UserException("Vui lòng nhập số điện thoại hoặc email khách hàng!");
        }
        if (!phoneNum.isEmpty() && !phoneNum.matches("^(0|\\+84)[0-9]{9}$")) {
            throw new UserException("Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0 hoặc +84)!");
        }

        User byPhone = phoneNum.isEmpty() ? null : userRepo.findCustomerByPhone(phoneNum);
        User byEmail = mail.isEmpty() ? null : userRepo.findCustomerByEmail(mail);

        if (byPhone != null || byEmail != null) {
            if (byPhone != null && byEmail != null && byPhone.getId_User() != byEmail.getId_User()) {
                throw new UserException("Số điện thoại và email thuộc hai tài khoản khách hàng khác nhau!");
            }
            User existing = byPhone != null ? byPhone : byEmail;
            return existing.getId_User();
        }

        if (name.isEmpty()) {
            throw new UserException("Vui lòng nhập họ tên khách hàng!");
        }

        if (phoneNum.isEmpty()) {
            throw new UserException("Khách hàng mới — vui lòng nhập số điện thoại!");
        }
        if (mail.isEmpty()) {
            throw new UserException("Khách hàng mới — vui lòng nhập email!");
        }
        if (!mail.matches("^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            throw new UserException("Email không đúng định dạng!");
        }
        if (userRepo.findByEmail(mail) != null) {
            throw new UserException("Email đã tồn tại trên hệ thống!");
        }
        if (userRepo.findByPhone(phoneNum) != null) {
            throw new UserException("Số điện thoại đã được sử dụng bởi tài khoản khác!");
        }

        User created = createWalkInCustomer(name, phoneNum, mail);
        return created.getId_User();
    }

    private User createWalkInCustomer(String fullName, String phone, String email) {
        User user = new User();
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setEmail(email);
        user.setUsername(generateWalkInUsername(phone));
        user.setPassword(hashPassword("Pass@123"));
        user.setStatus("Active");

        if (!userRepo.save(user)) {
            throw new UserException("Không thể tạo tài khoản khách hàng mới!");
        }

        User saved = userRepo.findByUsername(user.getUsername());
        if (saved == null) {
            throw new UserException("Không thể tải thông tin khách hàng vừa tạo!");
        }

        grantRoleToUser(saved.getId_User(), "CUSTOMER");
        return saved;
    }

    private String generateWalkInUsername(String phone) {
        String digits = phone.replaceAll("\\D", "");
        if (digits.startsWith("84") && digits.length() > 9) {
            digits = digits.substring(digits.length() - 9);
        }
        String base = "khach_" + digits;
        String candidate = base;
        int suffix = 1;
        while (userRepo.findByUsername(candidate) != null) {
            candidate = base + "_" + suffix++;
        }
        return candidate;
    }

    private String hashPassword(String originalPassword) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(originalPassword.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedHash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi hệ thống mã hóa: " + e.getMessage());
        }
    }
}