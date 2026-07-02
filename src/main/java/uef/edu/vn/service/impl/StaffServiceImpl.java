package uef.edu.vn.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import uef.edu.vn.exception.StaffException;
import uef.edu.vn.model.Quyen;
import uef.edu.vn.model.User;
import uef.edu.vn.model.UserRole;
import uef.edu.vn.repository.StaffRepository;
import uef.edu.vn.service.StaffService;

@Service
public class StaffServiceImpl implements StaffService {

    private final StaffRepository staffRepo;

    @Autowired
    public StaffServiceImpl(StaffRepository staffRepo) {
        this.staffRepo = staffRepo;
    }

    @Override
    public List<UserRole> getAllStaffs() {
        return staffRepo.findAll();
    }

    @Override
    public UserRole getStaffById(int staffId) {
        if (staffId <= 0) throw new StaffException("ID nhân sự không hợp lệ!");
        UserRole staffRole = staffRepo.findById(staffId);
        if (staffRole == null) throw new StaffException("Không tìm thấy thông tin quyền hoặc tài khoản nhân sự với ID: " + staffId);
        return staffRole;
    }

    @Override
    public List<UserRole> getStaffRoleHistory(int staffId) {
        if (staffId <= 0) throw new StaffException("ID nhân sự không hợp lệ!");
        return staffRepo.findRoleHistoryByUserId(staffId);
    }

    @Override
    public List<Quyen> getAllStaffRoles() {
        return staffRepo.getAllStaffRoles();
    }

    @Override
    public boolean addStaff(User staff, int roleId) {
        if (roleId <= 0) throw new StaffException("Vui lòng chọn chức vụ cho nhân sự!");
        return addStaffWithRoles(staff, java.util.Collections.singletonList(roleId));
    }

    @Override
    public boolean addStaffWithRoles(User staff, List<Integer> roleIds) {
        if (staff == null) {
            throw new StaffException("Thông tin nhân sự không hợp lệ!");
        }
        if (roleIds == null || roleIds.isEmpty()) {
            throw new StaffException("Vui lòng chọn ít nhất một quyền cho nhân sự!");
        }
        List<Integer> validRoleIds = new java.util.ArrayList<>();
        for (Integer roleId : roleIds) {
            if (roleId != null && roleId > 0 && !validRoleIds.contains(roleId)) {
                validRoleIds.add(roleId);
            }
        }
        if (validRoleIds.isEmpty()) {
            throw new StaffException("Vui lòng chọn ít nhất một quyền hợp lệ cho nhân sự!");
        }
        if (staff.getFullName() == null || staff.getFullName().trim().isEmpty()) {
            throw new StaffException("Họ và tên nhân sự không được để trống!");
        }
        if (staff.getUsername() == null || staff.getUsername().trim().isEmpty()) {
            throw new StaffException("Tên đăng nhập không được để trống!");
        }
        if (staff.getEmail() == null || staff.getEmail().trim().isEmpty()) {
            throw new StaffException("Email nhân sự không được để trống!");
        }
        if (staff.getPhone() == null || staff.getPhone().trim().isEmpty()) {
            throw new StaffException("Số điện thoại nhân sự không được để trống!");
        }
        staff.setFullName(staff.getFullName().trim());
        staff.setUsername(staff.getUsername().trim());
        staff.setEmail(staff.getEmail().trim());
        staff.setPhone(staff.getPhone().trim());
        if (staff.getAvatar() != null) {
            staff.setAvatar(staff.getAvatar().trim());
        }
        if (staff.getPassword() == null || staff.getPassword().trim().isEmpty()) {
            staff.setPassword("Pass@123");
        } else {
            staff.setPassword(staff.getPassword().trim());
        }
        if (staff.getUsername() != null && staffRepo.isUsernameTaken(staff.getUsername().trim())) {
            throw new StaffException("Tên đăng nhập '" + staff.getUsername() + "' đã tồn tại!");
        }
        if (staff.getEmail() != null && staffRepo.isEmailTakenByOther(staff.getEmail().trim(), 0)) {
            throw new StaffException("Email '" + staff.getEmail() + "' đã được sử dụng!");
        }
        if (staff.getPhone() != null && staffRepo.isPhoneTakenByOther(staff.getPhone().trim(), 0)) {
            throw new StaffException("Số điện thoại '" + staff.getPhone() + "' đã được sử dụng!");
        }

        try {
            staffRepo.addStaffWithRoles(staff, validRoleIds);
            return true;
        } catch (DataAccessException e) {
            throw new StaffException("Lỗi CSDL khi thêm nhân sự: " + e.getMessage());
        }
    }

    @Override
    public boolean updateStaffFullInfo(User staff, int roleId) {
        if (staff == null || staff.getId_User() <= 0) throw new StaffException("Thông tin nhân sự không hợp lệ!");
        if (staff.getFullName() == null || staff.getFullName().trim().isEmpty()) {
            throw new StaffException("Họ và tên nhân sự không được để trống!");
        }
        if (staff.getEmail() == null || staff.getEmail().trim().isEmpty()) {
            throw new StaffException("Email nhân sự không được để trống!");
        }
        if (staff.getPhone() == null || staff.getPhone().trim().isEmpty()) {
            throw new StaffException("Số điện thoại nhân sự không được để trống!");
        }
        staff.setFullName(staff.getFullName().trim());
        staff.setEmail(staff.getEmail().trim());
        staff.setPhone(staff.getPhone().trim());
        if (staff.getEmail() != null && staffRepo.isEmailTakenByOther(staff.getEmail().trim(), staff.getId_User())) {
            throw new StaffException("Email '" + staff.getEmail() + "' đã được sử dụng bởi tài khoản khác trong hệ thống!");
        }
        if (staff.getPhone() != null && staffRepo.isPhoneTakenByOther(staff.getPhone().trim(), staff.getId_User())) {
            throw new StaffException("Số điện thoại '" + staff.getPhone() + "' đã được sử dụng bởi tài khoản khác trong hệ thống!");
        }

        try {
            staffRepo.updateStaffFullInfo(staff, roleId);
            return true;
        } catch (DataAccessException e) {
            throw new StaffException("Lỗi CSDL khi cập nhật: " + e.getMessage());
        }
    }

    @Override
    public boolean updateStaffStatus(int staffId, String status) {
        if (staffId <= 0) throw new StaffException("ID nhân sự không hợp lệ!");
        if (!"Active".equals(status) && !"Locked".equals(status)) {
            throw new StaffException("Trạng thái tài khoản không hợp lệ!");
        }
        try {
            staffRepo.updateStaffStatus(staffId, status);
            return true;
        } catch (DataAccessException e) {
            // Chuyển đổi lỗi thô của CSDL thành StaffException thân thiện với giao diện
            throw new StaffException("Lỗi hệ thống: Không thể cập nhật trạng thái tài khoản vào CSDL!");
        }
    }

    @Override
    public boolean addStaffRole(int staffId, int roleId) {
        if (staffId <= 0) throw new StaffException("ID nhân sự không hợp lệ!");
        if (roleId <= 0) throw new StaffException("Vui lòng chọn quyền cần cấp!");

        try {
            String userStatus = staffRepo.getUserStatus(staffId);
            if (userStatus == null) {
                throw new StaffException("Không tìm thấy tài khoản nhân sự để cấp quyền!");
            }
            if (staffRepo.countStaffRole(staffId, roleId) > 0) {
                throw new StaffException("Nhân sự này đã có quyền được chọn. Vui lòng cập nhật trạng thái quyền hiện có thay vì thêm trùng!");
            }

            String roleStatus = "Locked".equals(userStatus) ? "Locked" : "Active";
            staffRepo.addStaffRole(staffId, roleId, roleStatus);
            return true;
        } catch (DataAccessException e) {
            throw new StaffException("Lỗi CSDL khi cấp thêm quyền cho nhân sự: " + e.getMessage());
        }
    }

    @Override
    public boolean updateStaffRoleStatus(int staffId, int userRoleId, String status) {
        if (staffId <= 0 || userRoleId <= 0) throw new StaffException("Thông tin quyền nhân sự không hợp lệ!");
        if (!"Active".equals(status) && !"Locked".equals(status)) {
            throw new StaffException("Trạng thái quyền không hợp lệ!");
        }

        try {
            UserRole userRole = staffRepo.findUserRoleById(userRoleId);
            if (userRole == null || userRole.getUser() == null || userRole.getUser().getId_User() != staffId) {
                throw new StaffException("Không tìm thấy quyền hợp lệ của nhân sự này!");
            }
            if ("Locked".equals(userRole.getUser().getStatus()) && "Active".equals(status)) {
                throw new StaffException("Không thể bật Active cho quyền khi tài khoản nhân sự đang Locked. Vui lòng mở khóa tài khoản trước!");
            }

            staffRepo.updateStaffRoleStatus(userRoleId, status);
            return true;
        } catch (DataAccessException e) {
            throw new StaffException("Lỗi CSDL khi cập nhật trạng thái quyền: " + e.getMessage());
        }
    }

    @Override
    public boolean resetPassword(int staffId) {
        try {
            staffRepo.resetPassword(staffId, "Pass@123"); 
            return true;
        } catch (DataAccessException e) {
            // Chuyển đổi lỗi thô của CSDL thành StaffException thân thiện với giao diện
            throw new StaffException("Lỗi hệ thống: Không thể khôi phục mật khẩu trên cơ sở dữ liệu!");
        }
    }

    @Override
    public List<UserRole> filterStaffsAdvanced(String nameKeyword, String contactKeyword, String status, List<Integer> roleIds, String roleStatusFilter, String startDate, String endDate, List<String> dateFilterType) {
        if (roleStatusFilter != null && !roleStatusFilter.trim().isEmpty()
                && !"ALL".equals(roleStatusFilter)
                && !"Active".equals(roleStatusFilter)
                && !"Locked".equals(roleStatusFilter)) {
            throw new StaffException("Trạng thái quyền dùng để lọc không hợp lệ!");
        }
        if ("Locked".equals(status) && "Active".equals(roleStatusFilter)) {
            throw new StaffException("Tài khoản nhân sự đang Locked thì tất cả quyền phải Locked, không thể lọc kết hợp User Locked với Quyền Active!");
        }
        return staffRepo.filterStaffsAdvanced(nameKeyword, contactKeyword, status, roleIds, roleStatusFilter, startDate, endDate, dateFilterType);
    }
}