package uef.edu.vn.util;

import uef.edu.vn.model.User;

public final class SecurityUtils {

    private static final String[] ADMIN_ROLES = {"ADMIN", "MANAGER"};
    private static final String[] STAFF_ROLES = {"SELLER", "STAFF", "TICKETSELLER"};

    private SecurityUtils() {
    }

    public static boolean hasAdminAccess(User user) {
        if (user == null) {
            return false;
        }
        for (String role : ADMIN_ROLES) {
            if (user.hasRole(role)) {
                return true;
            }
        }
        return false;
    }

    public static boolean hasStaffAccess(User user) {
        if (user == null) {
            return false;
        }
        for (String role : STAFF_ROLES) {
            if (user.hasRole(role)) {
                return true;
            }
        }
        return false;
    }

    /** Staff portal: seller + admin/manager */
    public static boolean hasStaffPortalAccess(User user) {
        return hasStaffAccess(user) || hasAdminAccess(user);
    }

    public static User sanitizeUserForSession(User user) {
        if (user == null) {
            return null;
        }
        User safe = new User();
        safe.setId_User(user.getId_User());
        safe.setUsername(user.getUsername());
        safe.setFullName(user.getFullName());
        safe.setAvatar(user.getAvatar());
        safe.setEmail(user.getEmail());
        safe.setPhone(user.getPhone());
        safe.setRoles(user.getRoles());
        safe.setCreatedAt(user.getCreatedAt());
        safe.setStatus(user.getStatus());
        safe.setTotalBookings(user.getTotalBookings());
        safe.setTotalSpent(user.getTotalSpent());
        return safe;
    }
}
