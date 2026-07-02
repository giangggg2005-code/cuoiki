package uef.edu.vn.filter;

import uef.edu.vn.model.User;
import uef.edu.vn.util.SecurityUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login-admin");
            return;
        }

        if (!"Active".equalsIgnoreCase(loggedInUser.getStatus())) {
            if (session != null) {
                session.invalidate();
            }
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login-admin");
            return;
        }

        if (SecurityUtils.hasAdminAccess(loggedInUser)) {
            chain.doFilter(request, response);
        } else if (SecurityUtils.hasStaffAccess(loggedInUser)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/staff/dashboard");
        } else if (loggedInUser != null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/customer/home");
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login-admin");
        }
    }

    @Override
    public void destroy() {}
}
