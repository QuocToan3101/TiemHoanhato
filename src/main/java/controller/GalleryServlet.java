package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.GalleryDAO;
import model.Gallery;
import model.User;

/**
 * Servlet xử lý gallery
 */
@WebServlet(urlPatterns = {"/gallery", "/api/gallery/*"})
public class GalleryServlet extends HttpServlet {
    
    private GalleryDAO galleryDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        galleryDAO = new GalleryDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        // API endpoints
        if (request.getRequestURI().contains("/api/gallery")) {
            handleApiGet(request, response, pathInfo);
            return;
        }
        
        // Forward to intro page (default)
        request.getRequestDispatcher("/view/intro.jsp").forward(request, response);
    }
    
    private void handleApiGet(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                // Get all active galleries for public
                List<Gallery> galleries = galleryDAO.getAllActive();
                jsonResponse.addProperty("success", true);
                jsonResponse.add("data", gson.toJsonTree(galleries));
                
            } else if (pathInfo.equals("/all")) {
                // Get all galleries (for admin)
                if (!isAdmin(request)) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Unauthorized");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                
                List<Gallery> galleries = galleryDAO.getAll();
                jsonResponse.addProperty("success", true);
                jsonResponse.add("data", gson.toJsonTree(galleries));
                
            } else {
                // Get by ID
                try {
                    int id = Integer.parseInt(pathInfo.substring(1));
                    Gallery gallery = galleryDAO.getById(id);
                    
                    if (gallery != null) {
                        jsonResponse.addProperty("success", true);
                        jsonResponse.add("data", gson.toJsonTree(gallery));
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "Gallery not found");
                    }
                } catch (NumberFormatException e) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Invalid gallery ID");
                }
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        if (!isAdmin(request)) {
            sendUnauthorized(response);
            return;
        }
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String action = request.getParameter("action");
            
            if ("add".equals(action)) {
                // Add new gallery
                Gallery gallery = new Gallery();
                gallery.setImageUrl(request.getParameter("imageUrl"));
                gallery.setCaption(request.getParameter("caption"));
                gallery.setDescription(request.getParameter("description"));
                gallery.setDisplayOrder(parseIntOrDefault(request.getParameter("displayOrder"), 0));
                gallery.setActive(Boolean.parseBoolean(request.getParameter("isActive")));
                
                int newId = galleryDAO.add(gallery);
                
                if (newId > 0) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Thêm thành công");
                    jsonResponse.addProperty("id", newId);
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Thêm thất bại");
                }
                
            } else if ("update".equals(action)) {
                // Update gallery
                int id = Integer.parseInt(request.getParameter("id"));
                Gallery gallery = galleryDAO.getById(id);
                
                if (gallery != null) {
                    gallery.setImageUrl(request.getParameter("imageUrl"));
                    gallery.setCaption(request.getParameter("caption"));
                    gallery.setDescription(request.getParameter("description"));
                    gallery.setDisplayOrder(parseIntOrDefault(request.getParameter("displayOrder"), gallery.getDisplayOrder()));
                    gallery.setActive(Boolean.parseBoolean(request.getParameter("isActive")));
                    
                    boolean success = galleryDAO.update(gallery);
                    jsonResponse.addProperty("success", success);
                    jsonResponse.addProperty("message", success ? "Cập nhật thành công" : "Cập nhật thất bại");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không tìm thấy gallery");
                }
                
            } else if ("updateStatus".equals(action)) {
                // Update active status
                int id = Integer.parseInt(request.getParameter("id"));
                boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
                
                boolean success = galleryDAO.updateActiveStatus(id, isActive);
                jsonResponse.addProperty("success", success);
                jsonResponse.addProperty("message", success ? "Cập nhật trạng thái thành công" : "Cập nhật thất bại");
                
            } else if ("updateOrder".equals(action)) {
                // Update display order
                int id = Integer.parseInt(request.getParameter("id"));
                int order = Integer.parseInt(request.getParameter("order"));
                
                boolean success = galleryDAO.updateDisplayOrder(id, order);
                jsonResponse.addProperty("success", success);
                jsonResponse.addProperty("message", success ? "Cập nhật thứ tự thành công" : "Cập nhật thất bại");
                
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Invalid action");
            }
            
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        
        if (!isAdmin(request)) {
            sendUnauthorized(response);
            return;
        }
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.length() > 1) {
                int id = Integer.parseInt(pathInfo.substring(1));
                boolean success = galleryDAO.delete(id);
                
                jsonResponse.addProperty("success", success);
                jsonResponse.addProperty("message", success ? "Xóa thành công" : "Xóa thất bại");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Invalid gallery ID");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Check if user is admin
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            return user != null && "admin".equals(user.getRole());
        }
        return false;
    }
    
    /**
     * Send unauthorized response
     */
    private void sendUnauthorized(HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("message", "Unauthorized");
        response.getWriter().print(gson.toJson(jsonResponse));
    }
    
    /**
     * Parse int with default value
     */
    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return value != null ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
