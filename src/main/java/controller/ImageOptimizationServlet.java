package controller;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/api/image/*")
public class ImageOptimizationServlet extends HttpServlet {
    
    // Get web root directory
    private static final String UPLOADS_DIR = "uploads";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            
            // Decode path and remove leading slash
            String imagePath = URLDecoder.decode(pathInfo.substring(1), StandardCharsets.UTF_8);
            
            // Get size parameter (default: original)
            String sizeParam = request.getParameter("size");
            int targetWidth = 0;
            int targetHeight = 0;
            
            if ("carousel".equals(sizeParam)) {
                targetWidth = 349;
                targetHeight = 384;
            } else if ("thumbnail".equals(sizeParam)) {
                targetWidth = 200;
                targetHeight = 200;
            } else if ("small".equals(sizeParam)) {
                targetWidth = 100;
                targetHeight = 100;
            } else if ("medium".equals(sizeParam)) {
                targetWidth = 400;
                targetHeight = 400;
            } else if ("large".equals(sizeParam)) {
                targetWidth = 800;
                targetHeight = 600;
            }
            
            // Find and serve image
            File imageFile = resolveImagePath(imagePath);
            if (imageFile != null && imageFile.exists() && imageFile.isFile()) {
                
                // Set caching headers
                response.setHeader("Cache-Control", "public, max-age=86400, immutable");
                response.setHeader("Expires", String.valueOf(System.currentTimeMillis() + 86400000L));
                
                // Set content type based on file extension
                String fileName = imageFile.getName().toLowerCase();
                String contentType = "image/jpeg";
                if (fileName.endsWith(".webp")) {
                    contentType = "image/webp";
                } else if (fileName.endsWith(".png")) {
                    contentType = "image/png";
                } else if (fileName.endsWith(".gif")) {
                    contentType = "image/gif";
                }
                response.setContentType(contentType);
                
                try (OutputStream output = response.getOutputStream()) {
                    
                    if (targetWidth > 0 && targetHeight > 0) {
                        // Resize and compress
                        resizeAndCompress(imageFile, output, targetWidth, targetHeight, contentType);
                    } else {
                        // Serve original
                        byte[] buffer = new byte[8192];
                        int bytesRead;
                        try (var input = Files.newInputStream(imageFile.toPath())) {
                            while ((bytesRead = input.read(buffer)) != -1) {
                                output.write(buffer, 0, bytesRead);
                            }
                        }
                    }
                    output.flush();
                }
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void resizeAndCompress(File imageFile, OutputStream output, 
                                   int targetWidth, int targetHeight, String contentType) 
            throws IOException {
        try {
            // Read original image
            BufferedImage originalImage = ImageIO.read(imageFile);
            if (originalImage == null) {
                throw new IOException("Cannot read image: " + imageFile.getAbsolutePath());
            }
            
            // Calculate scaled dimensions (maintain aspect ratio)
            int origWidth = originalImage.getWidth();
            int origHeight = originalImage.getHeight();
            float aspectRatio = (float) origWidth / origHeight;
            
            int newWidth = targetWidth;
            int newHeight = targetHeight;
            
            if (aspectRatio > (float) targetWidth / targetHeight) {
                newHeight = Math.round(targetWidth / aspectRatio);
            } else {
                newWidth = Math.round(targetHeight * aspectRatio);
            }
            
            // Resize image
            Image scaledImage = originalImage.getScaledInstance(newWidth, newHeight, Image.SCALE_SMOOTH);
            BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
            resizedImage.getGraphics().drawImage(scaledImage, 0, 0, null);
            
            // Write compressed image
            if ("image/png".equals(contentType)) {
                ImageIO.write(resizedImage, "PNG", output);
            } else if ("image/gif".equals(contentType)) {
                ImageIO.write(resizedImage, "GIF", output);
            } else {
                // Default to JPEG with quality setting
                ImageIO.write(resizedImage, "JPEG", output);
            }
        } catch (Exception e) {
            // Fallback: serve original
            byte[] buffer = new byte[8192];
            int bytesRead;
            try (var input = Files.newInputStream(imageFile.toPath())) {
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }
        }
    }
    
    private File resolveImagePath(String imagePath) {
        try {
            // Get application root
            String appRoot = getServletContext().getRealPath("/");
            if (appRoot == null) {
                appRoot = System.getProperty("user.dir");
            }
            
            // Try to resolve from uploads directory
            Path uploadPath = Paths.get(appRoot, UPLOADS_DIR, imagePath);
            File file = uploadPath.normalize().toFile();
            
            // Security check: ensure path is within uploads directory
            if (!file.getCanonicalPath().startsWith(new File(appRoot).getCanonicalPath())) {
                return null;
            }
            
            if (file.exists()) {
                return file;
            }
            
            // Try relative to webapp root if not in uploads
            Path webappPath = Paths.get(appRoot, imagePath);
            file = webappPath.normalize().toFile();
            if (file.exists() && file.getCanonicalPath().startsWith(new File(appRoot).getCanonicalPath())) {
                return file;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
