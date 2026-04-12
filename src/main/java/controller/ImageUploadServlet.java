package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Servlet xử lý upload ảnh
 * Hỗ trợ upload ảnh sản phẩm, avatar, banner, v.v.
 */
@WebServlet("/api/upload-image")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ImageUploadServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    private static final Set<String> ALLOWED_TYPES = Set.of("product", "avatar", "banner");
    private Gson gson;
    
    @Override
    public void init() {
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.addProperty("success", false);
                result.addProperty("message", "Vui lòng đăng nhập trước khi upload");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print(gson.toJson(result));
                return;
            }

            // Lấy upload type (product, avatar, banner, v.v.)
            String uploadType = sanitizeUploadType(request.getParameter("type"));
            if (!ALLOWED_TYPES.contains(uploadType)) {
                result.addProperty("success", false);
                result.addProperty("message", "Loại upload không hợp lệ");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(result));
                return;
            }
            
            // Tạo thư mục upload nếu chưa có
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + UPLOAD_DIR + 
                              File.separator + uploadType;
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            List<String> uploadedFiles = new ArrayList<>();
            
            // Xử lý từng file được upload
            for (Part part : request.getParts()) {
                String fileName = extractFileName(part);
                
                if (fileName != null && !fileName.isEmpty()) {
                    // Validate file extension
                    if (!isValidExtension(fileName)) {
                        result.addProperty("success", false);
                        result.addProperty("message", "File không hợp lệ. Chỉ chấp nhận: jpg, jpeg, png, gif, webp");
                        out.print(gson.toJson(result));
                        return;
                    }
                    if (!isValidMimeType(part.getContentType())) {
                        result.addProperty("success", false);
                        result.addProperty("message", "File không hợp lệ. Sai định dạng MIME");
                        out.print(gson.toJson(result));
                        return;
                    }
                    
                    // Generate unique filename
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                    
                    // Save file
                    Path filePath = Paths.get(uploadPath, uniqueFileName);
                    Files.copy(part.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                    
                    // Tạo relative path để lưu vào database
                    String relativePath = request.getContextPath() + "/" + UPLOAD_DIR + 
                                        "/" + uploadType + "/" + uniqueFileName;
                    uploadedFiles.add(relativePath);
                }
            }
            
            if (uploadedFiles.isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("message", "Không có file nào được upload");
            } else {
                result.addProperty("success", true);
                result.addProperty("message", "Upload thành công " + uploadedFiles.size() + " file");
                
                // Nếu chỉ upload 1 file, trả về string
                // Nếu nhiều file, trả về array
                if (uploadedFiles.size() == 1) {
                    result.addProperty("url", uploadedFiles.get(0));
                } else {
                    result.add("urls", gson.toJsonTree(uploadedFiles));
                }
            }
            
        } catch (Exception e) {
            result.addProperty("success", false);
            result.addProperty("message", "Lỗi upload: " + e.getMessage());
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Extract file name from HTTP header
     */
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return null;
    }
    
    /**
     * Validate file extension
     */
    private boolean isValidExtension(String fileName) {
        String lowerFileName = fileName.toLowerCase();
        for (String ext : ALLOWED_EXTENSIONS) {
            if (lowerFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    private boolean isValidMimeType(String contentType) {
        if (contentType == null) return false;
        String lower = contentType.toLowerCase();
        return lower.startsWith("image/");
    }

    private String sanitizeUploadType(String rawType) {
        if (rawType == null || rawType.isEmpty()) {
            return "product";
        }
        String cleaned = rawType.replaceAll("[^a-zA-Z0-9_-]", "");
        if (cleaned.isEmpty()) {
            return "product";
        }
        return cleaned;
    }
}
