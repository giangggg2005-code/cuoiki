package uef.edu.vn.interceptor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import uef.edu.vn.annotation.RoleRequired;
import uef.edu.vn.model.User;
import uef.edu.vn.repository.UserRoleRepository;
import uef.edu.vn.security.AdminAccessPolicy;
import uef.edu.vn.security.PortalSessionHelper;

@Component
public class RoleInterceptor implements HandlerInterceptor {

    @Autowired
    private UserRoleRepository userRoleRepository;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        RoleRequired roleRequired = handlerMethod.getMethodAnnotation(RoleRequired.class);
        if (roleRequired == null) {
            roleRequired = handlerMethod.getBeanType().getAnnotation(RoleRequired.class);
        }

        String contextPath = request.getContextPath();
        String path = request.getRequestURI().substring(contextPath.length());
        boolean adminPath = path.startsWith("/admin");

        if (!adminPath && roleRequired == null) {
            return true;
        }

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null) {
            response.sendRedirect(contextPath + "/login-admin");
            return false;
        }

        int userId = loggedInUser.getId_User();
        String method = request.getMethod();

        if (userRoleRepository.hasActiveAdminAccess(userId)) {
            session.setAttribute("userRole", AdminAccessPolicy.ROLE_ADMIN);
            session.setAttribute(PortalSessionHelper.PORTAL_ROLE, AdminAccessPolicy.ROLE_ADMIN);
            session.setAttribute(PortalSessionHelper.READ_ONLY_MODE, Boolean.FALSE);
            request.setAttribute(PortalSessionHelper.READ_ONLY_MODE, Boolean.FALSE);
            return true;
        }

        if (userRoleRepository.hasActiveManagerAccess(userId)) {
            if (!AdminAccessPolicy.isManagerAllowed(path, method)) {
                response.sendRedirect(contextPath + "/admin/dashboard?denied=1");
                return false;
            }
            session.setAttribute("userRole", AdminAccessPolicy.ROLE_MANAGER);
            session.setAttribute(PortalSessionHelper.PORTAL_ROLE, AdminAccessPolicy.ROLE_MANAGER);
            boolean readOnly = AdminAccessPolicy.isManagerReadOnlyPage(path, method);
            session.setAttribute(PortalSessionHelper.READ_ONLY_MODE, readOnly);
            request.setAttribute(PortalSessionHelper.READ_ONLY_MODE, readOnly);
            return true;
        }

        if (roleRequired != null) {
            for (String role : roleRequired.value()) {
                if (userRoleRepository.checkUserHasRole(userId, role)) {
                    session.setAttribute("userRole", role.toUpperCase());
                    return true;
                }
            }
        }

        session.invalidate();
        response.sendRedirect(contextPath + "/login-admin");
        return false;
    }
}
