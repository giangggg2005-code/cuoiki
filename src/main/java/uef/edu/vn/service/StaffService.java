package uef.edu.vn.service;

import java.util.List;
import uef.edu.vn.model.Quyen;
import uef.edu.vn.model.User;
import uef.edu.vn.model.UserRole;

public interface StaffService {
    List<UserRole> getAllStaffs();
    UserRole getStaffById(int staffId);
    List<UserRole> getStaffRoleHistory(int staffId);
    List<Quyen> getAllStaffRoles();
    
    boolean addStaff(User staff, int roleId);
    boolean addStaffWithRoles(User staff, List<Integer> roleIds);
    boolean updateStaffFullInfo(User staff, int roleId);
    boolean updateStaffStatus(int staffId, String status);
    boolean addStaffRole(int staffId, int roleId);
    boolean updateStaffRoleStatus(int staffId, int userRoleId, String status);
    boolean resetPassword(int staffId);
    
    List<UserRole> filterStaffsAdvanced(String nameKeyword, String contactKeyword, String status, List<Integer> roleIds, 
                                        String roleStatusFilter, String startDate, String endDate, List<String> dateFilterType);
}