package uef.edu.vn.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uef.edu.vn.util.AvatarUtils;

@Controller
public class AvatarResourceController {

    @GetMapping("/assets/images/avatar/{fileName:.+}")
    public void serveAvatar(@PathVariable("fileName") String fileName,
                            HttpServletRequest request,
                            HttpServletResponse response) throws IOException {
        Path filePath;
        try {
            filePath = AvatarUtils.resolveAvatarFilePath(fileName, request.getServletContext());
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if (!Files.isRegularFile(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(filePath);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLengthLong(Files.size(filePath));
        Files.copy(filePath, response.getOutputStream());
    }
}
