package uef.edu.vn.service;

import java.util.List;
import java.util.Map;
import uef.edu.vn.model.User;
import uef.edu.vn.model.Quyen;

public interface UserService {
    
    // 1. Chức năng xác thực & Đăng ký
    User authenticate(String username, String password);
    User authenticateAdmin(String username, String password);
    User authenticatePortalUser(String username, String password);
    String resolvePortalRole(int userId);
    User registerUser(User user);
    void registerCustomer(User user) throws Exception;
    
    // 2. Chức năng quản lý tài khoản (Dành cho Admin/Staff)
    boolean lockAccount(int userId);
    boolean unlockAccount(int userId);
    List<User> getAllUsers();
    User getUserById(int userId);
    
    // 3. Chức năng phân quyền (Role Assignment)
    boolean grantRoleToUser(int userId, String roleName);
    boolean revokeRoleFromUser(int userId, String roleName);
    List<Quyen> getUserRoles(int userId);
    
    // 4. Chức năng thông tin cá nhân (Profile)
    boolean changePassword(int userId, String oldPassword, String newPassword);
    boolean updateProfile(User user);

    // 5. Đặt vé tại quầy (Staff)
    boolean customerNameExists(String fullName);
    User findCustomerByFullNameAndPhone(String fullName, String phone);
    Map<String, Object> checkCustomerContact(String phone, String email);
    User findCustomerByFullNameAndContact(String fullName, String phone, String email);
    int resolveCustomerForStaffBooking(String fullName, String phone, String email);
}