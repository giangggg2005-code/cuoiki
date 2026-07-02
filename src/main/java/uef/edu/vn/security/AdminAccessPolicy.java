package uef.edu.vn.security;

import org.springframework.http.HttpMethod;

public final class AdminAccessPolicy {

    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_MANAGER = "MANAGER";
    public static final String NO_PERMISSION_MSG = "Bạn không có quyền chỉnh sửa";

    private AdminAccessPolicy() {
    }

    public static boolean isManagerAllowed(String path, String method) {
        if (path == null) {
            return false;
        }
        String normalized = normalizePath(path);
        String httpMethod = method == null ? "GET" : method.toUpperCase();

        if (matchesDashboard(normalized)) {
            return true;
        }
        if (matchesShowtimes(normalized)) {
            return true;
        }
        if (matchesMonitoring(normalized)) {
            return true;
        }
        if (matchesReports(normalized)) {
            return true;
        }
        if (isManagerReadOnlyGet(normalized)) {
            return HttpMethod.GET.matches(httpMethod);
        }
        if (isManagerReadOnlyApi(normalized, httpMethod)) {
            return true;
        }
        if (isManagerPriceWritePath(normalized, httpMethod)) {
            return true;
        }
        if (matchesProfile(normalized)) {
            return true;
        }
        return false;
    }

    private static boolean matchesProfile(String path) {
        return path.equals("/admin/profile")
                || path.equals("/admin/profile/update");
    }

    private static boolean isManagerReadOnlyApi(String path, String httpMethod) {
        if (!HttpMethod.GET.matches(httpMethod)) {
            return false;
        }
        return path.matches("/admin/customers/\\d+/booking-history");
    }

    public static boolean isManagerReadOnlyPage(String path, String method) {
        if (!HttpMethod.GET.matches(method == null ? "GET" : method.toUpperCase())) {
            return false;
        }
        return isManagerReadOnlyGet(normalizePath(path));
    }

    private static boolean isManagerPriceWritePath(String path, String httpMethod) {
        if (!HttpMethod.POST.matches(httpMethod)) {
            return false;
        }
        return path.equals("/admin/movies/update-base-price")
                || path.equals("/admin/rooms/update-room-price");
    }

    private static boolean isManagerReadOnlyGet(String path) {
        return path.startsWith("/admin/customers/detail/")
                || path.startsWith("/admin/staffs/detail/")
                || path.equals("/admin/movies/detail")
                || path.equals("/admin/rooms/detail");
    }

    private static boolean matchesDashboard(String path) {
        return path.equals("/admin")
                || path.equals("/admin/")
                || path.startsWith("/admin/dashboard");
    }

    private static boolean matchesShowtimes(String path) {
        return path.equals("/admin/showtimes")
                || path.startsWith("/admin/showtimes/");
    }

    private static boolean matchesMonitoring(String path) {
        return path.equals("/admin/monitoring")
                || path.startsWith("/admin/monitoring/");
    }

    private static boolean matchesReports(String path) {
        return path.equals("/admin/reports")
                || path.startsWith("/admin/reports/");
    }

    private static String normalizePath(String path) {
        if (path.length() > 1 && path.endsWith("/")) {
            return path.substring(0, path.length() - 1);
        }
        return path;
    }
}
