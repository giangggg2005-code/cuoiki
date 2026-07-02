package uef.edu.vn.security;

import jakarta.servlet.http.HttpSession;

public final class PortalSessionHelper {

    public static final String PORTAL_ROLE = "portalRole";
    public static final String READ_ONLY_MODE = "readOnlyMode";

    private PortalSessionHelper() {
    }

    public static boolean isAdmin(HttpSession session) {
        return session != null && AdminAccessPolicy.ROLE_ADMIN.equals(session.getAttribute(PORTAL_ROLE));
    }

    public static boolean isManager(HttpSession session) {
        return session != null && AdminAccessPolicy.ROLE_MANAGER.equals(session.getAttribute(PORTAL_ROLE));
    }

    public static boolean isReadOnly(HttpSession session) {
        return session != null && Boolean.TRUE.equals(session.getAttribute(READ_ONLY_MODE));
    }

    public static String getPortalRole(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object role = session.getAttribute(PORTAL_ROLE);
        return role != null ? role.toString() : null;
    }

    public static String denyWriteMessage(HttpSession session) {
        if (isManager(session) && !isAdmin(session)) {
            return AdminAccessPolicy.NO_PERMISSION_MSG;
        }
        return AdminAccessPolicy.NO_PERMISSION_MSG;
    }
}
