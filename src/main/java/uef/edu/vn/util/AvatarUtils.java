package uef.edu.vn.util;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.web.multipart.MultipartFile;

import uef.edu.vn.exception.CustomerException;

import jakarta.servlet.ServletContext;

public final class AvatarUtils {

    private static final String AVATAR_DIR = "/assets/images/avatar/";
    private static final String[] AVATAR_PATH_SEGMENTS = {"assets", "images", "avatar"};
    private static final String WAR_ARTIFACT = "Baocaocuoiki_CongNgheJava_QuanLyRapPhim-1.0-SNAPSHOT";
    private static final long MAX_AVATAR_SIZE = 5L * 1024 * 1024;

    private AvatarUtils() {
    }

    public static void validateAvatarFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return;
        }
        if (file.getSize() > MAX_AVATAR_SIZE) {
            throw new CustomerException("Ảnh đại diện không được vượt quá 5MB!");
        }
        String contentType = file.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
            throw new CustomerException("File tải lên phải là ảnh (JPEG, PNG, GIF, WEBP)!");
        }
    }

    public static String resolveDisplayUrl(String avatar, String contextPath, String fullName) {
        String ctx = contextPath != null ? contextPath : "";
        String name = (fullName != null && !fullName.isBlank()) ? fullName.trim() : "User";

        if (avatar == null || avatar.isBlank() || "null".equalsIgnoreCase(avatar.trim())) {
            return "https://ui-avatars.com/api/?name=" + java.net.URLEncoder.encode(name, java.nio.charset.StandardCharsets.UTF_8) + "&background=random";
        }

        String trimmed = avatar.trim();
        if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
            return trimmed;
        }

        return ctx + AVATAR_DIR + sanitizeFileName(trimmed);
    }

    public static void validateAvatarUrl(String avatar) {
        if (avatar == null || avatar.isBlank()) {
            return;
        }
        String trimmed = avatar.trim();
        if (!trimmed.startsWith("http")) {
            return;
        }
        try {
            java.net.URI uri = new java.net.URI(trimmed);
            String scheme = uri.getScheme();
            String host = uri.getHost();
            if (scheme == null || host == null || host.isBlank()) {
                throw new CustomerException("URL ảnh đại diện không hợp lệ! Vui lòng nhập link bắt đầu bằng http:// hoặc https://");
            }
            if (!"http".equalsIgnoreCase(scheme) && !"https".equalsIgnoreCase(scheme)) {
                throw new CustomerException("URL ảnh đại diện chỉ hỗ trợ giao thức http:// hoặc https://");
            }
        } catch (CustomerException e) {
            throw e;
        } catch (java.net.URISyntaxException e) {
            throw new CustomerException("URL ảnh đại diện không hợp lệ! Vui lòng kiểm tra lại đường link.");
        }
        if (trimmed.length() > 255) {
            throw new CustomerException("Đường dẫn Avatar quá dài!");
        }
    }

    public static String applyAvatarFromRequest(String currentAvatar, String avatarText,
                                                MultipartFile imageFile, ServletContext servletContext) throws IOException {
        String trimmedText = avatarText != null ? avatarText.trim() : "";
        boolean hasUrlAvatar = trimmedText.startsWith("http");

        if (hasUrlAvatar) {
            validateAvatarUrl(trimmedText);
            return trimmedText;
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            validateAvatarFile(imageFile);
            String savedFileName = saveAvatarFile(imageFile, servletContext);
            if (savedFileName == null || savedFileName.isBlank()) {
                throw new CustomerException("Không thể lưu ảnh đại diện. Vui lòng thử lại!");
            }
            return savedFileName;
        }

        if (avatarText == null) {
            return currentAvatar;
        }

        String trimmed = trimmedText;
        if (trimmed.isEmpty()) {
            return currentAvatar;
        }

        String previous = currentAvatar != null ? currentAvatar.trim() : "";
        if (trimmed.equals(previous)) {
            return previous;
        }
        if (trimmed.startsWith("avatar_") || fileExists(trimmed, servletContext)) {
            return sanitizeFileName(trimmed);
        }
        if (!trimmed.contains("..") && !trimmed.startsWith("/")) {
            return sanitizeFileName(trimmed);
        }

        return currentAvatar;
    }

    public static String saveAvatarFile(MultipartFile file, ServletContext servletContext) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }

        String original = file.getOriginalFilename();
        String extension = "";
        if (original != null && original.contains(".")) {
            extension = original.substring(original.lastIndexOf('.'));
        }

        String fileName = "avatar_" + System.currentTimeMillis() + extension;
        Path targetDir = resolveAvatarDirectory(servletContext);
        Files.createDirectories(targetDir);

        Path targetFile = targetDir.resolve(fileName);
        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, targetFile, StandardCopyOption.REPLACE_EXISTING);
        }
        return fileName;
    }

    public static Path resolveAvatarFilePath(String fileName, ServletContext servletContext) throws IOException {
        String safeName = sanitizeFileName(fileName);
        for (Path dir : listAvatarDirectories(servletContext)) {
            Path candidate = dir.resolve(safeName);
            if (Files.isRegularFile(candidate)) {
                return candidate;
            }
        }
        return resolveAvatarDirectory(servletContext).resolve(safeName);
    }

    public static boolean fileExists(String fileName, ServletContext servletContext) {
        try {
            String safeName = sanitizeFileName(fileName);
            for (Path dir : listAvatarDirectories(servletContext)) {
                if (Files.isRegularFile(dir.resolve(safeName))) {
                    return true;
                }
            }
            return false;
        } catch (IOException | IllegalArgumentException e) {
            return false;
        }
    }

    public static String sanitizeFileName(String fileName) {
        if (fileName == null || fileName.isBlank()) {
            throw new IllegalArgumentException("Tên file avatar không hợp lệ!");
        }
        String safeName = Paths.get(fileName.trim()).getFileName().toString();
        if (safeName.isBlank() || safeName.contains("..")) {
            throw new IllegalArgumentException("Tên file avatar không hợp lệ!");
        }
        return safeName;
    }

    private static Path resolveAvatarDirectory(ServletContext servletContext) throws IOException {
        for (Path dir : listAvatarDirectories(servletContext)) {
            Files.createDirectories(dir);
            if (Files.isWritable(dir)) {
                return dir;
            }
        }

        Path externalDir = Paths.get(System.getProperty("user.home"), ".starlight-cinema", "avatars");
        Files.createDirectories(externalDir);
        return externalDir;
    }

    private static java.util.List<Path> listAvatarDirectories(ServletContext servletContext) throws IOException {
        java.util.LinkedHashSet<Path> dirs = new java.util.LinkedHashSet<>();

        if (servletContext != null) {
            String webappRoot = servletContext.getRealPath("/");
            if (webappRoot != null) {
                dirs.add(resolveAvatarPath(Paths.get(webappRoot)));
            }

            String avatarRealPath = servletContext.getRealPath(AVATAR_DIR);
            if (avatarRealPath != null) {
                dirs.add(Paths.get(avatarRealPath));
            }
        }

        dirs.add(resolveAvatarPath(Paths.get(System.getProperty("user.dir"), "target", WAR_ARTIFACT)));
        dirs.add(resolveAvatarPath(Paths.get(System.getProperty("user.dir"), "src", "main", "webapp")));
        dirs.add(Paths.get(System.getProperty("user.home"), ".starlight-cinema", "avatars"));

        java.util.List<Path> writableDirs = new java.util.ArrayList<>();
        for (Path dir : dirs) {
            Files.createDirectories(dir);
            if (Files.isWritable(dir)) {
                writableDirs.add(dir);
            }
        }
        return writableDirs;
    }

    private static Path resolveAvatarPath(Path base) {
        Path path = base;
        for (String segment : AVATAR_PATH_SEGMENTS) {
            path = path.resolve(segment);
        }
        return path;
    }
}
