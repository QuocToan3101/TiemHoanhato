package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.NewsDAO;
import model.News;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Servlet xử lý tin tức
 */
@WebServlet(urlPatterns = {"/news", "/news/*", "/api/news/*"})
public class NewsServlet extends HttpServlet {
    
    private NewsDAO newsDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        newsDAO = new NewsDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        // API endpoints
        if (request.getRequestURI().contains("/api/news")) {
            handleApiGet(request, response, pathInfo);
            return;
        }
        
        // Web pages
        if (pathInfo == null || pathInfo.equals("/")) {
            // News list page
            List<News> newsList = newsDAO.getAllPublished();
            request.setAttribute("newsList", newsList);
            request.getRequestDispatcher("/view/tintuc.jsp").forward(request, response);
            
        } else {
            // News detail page by slug
            String slug = pathInfo.substring(1);
            News news = newsDAO.getBySlug(slug);
            
            if (news != null) {
                // Get related news
                List<News> relatedNews = newsDAO.getRelated(news.getId(), news.getCategory(), 3);
                
                request.setAttribute("news", news);
                request.setAttribute("relatedNews", relatedNews);
                request.getRequestDispatcher("/view/news-detail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }
    
    private void handleApiGet(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                // Get all published news
                String category = request.getParameter("category");
                List<News> newsList;
                
                if (category != null && !category.isEmpty()) {
                    newsList = newsDAO.getByCategory(category);
                } else {
                    newsList = newsDAO.getAllPublished();
                }
                
                jsonResponse.addProperty("success", true);
                jsonResponse.add("data", gson.toJsonTree(newsList));
                
            } else if (pathInfo.equals("/all")) {
                // Get all news (for admin)
                if (!isAdmin(request)) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Unauthorized");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                
                List<News> newsList = newsDAO.getAll();
                jsonResponse.addProperty("success", true);
                jsonResponse.add("data", gson.toJsonTree(newsList));
                
            } else if (pathInfo.equals("/popular")) {
                // Get popular news
                int limit = parseIntOrDefault(request.getParameter("limit"), 5);
                List<News> newsList = newsDAO.getPopular(limit);
                
                jsonResponse.addProperty("success", true);
                jsonResponse.add("data", gson.toJsonTree(newsList));
                
            } else if (pathInfo.startsWith("/search")) {
                // Search news
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    List<News> newsList = newsDAO.search(keyword.trim());
                    jsonResponse.addProperty("success", true);
                    jsonResponse.add("data", gson.toJsonTree(newsList));
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Keyword required");
                }
                
            } else {
                // Get by ID
                try {
                    int id = Integer.parseInt(pathInfo.substring(1));
                    News news = newsDAO.getById(id);
                    
                    if (news != null) {
                        jsonResponse.addProperty("success", true);
                        jsonResponse.add("data", gson.toJsonTree(news));
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "News not found");
                    }
                } catch (NumberFormatException e) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Invalid news ID");
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
                // Add new news
                News news = new News();
                news.setTitle(request.getParameter("title"));
                news.setSlug(generateSlug(request.getParameter("title")));
                news.setExcerpt(request.getParameter("excerpt"));
                news.setContent(request.getParameter("content"));
                news.setImageUrl(request.getParameter("imageUrl"));
                news.setCategory(request.getParameter("category"));
                news.setAuthor(request.getParameter("author"));
                news.setPublished(Boolean.parseBoolean(request.getParameter("isPublished")));
                
                String publishedDateStr = request.getParameter("publishedDate");
                if (publishedDateStr != null && !publishedDateStr.isEmpty()) {
                    news.setPublishedDate(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(publishedDateStr));
                } else {
                    news.setPublishedDate(new Date());
                }
                
                int newId = newsDAO.add(news);
                
                if (newId > 0) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Thêm tin tức thành công");
                    jsonResponse.addProperty("id", newId);
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Thêm tin tức thất bại");
                }
                
            } else if ("update".equals(action)) {
                // Update news
                int id = Integer.parseInt(request.getParameter("id"));
                News news = newsDAO.getById(id);
                
                if (news != null) {
                    news.setTitle(request.getParameter("title"));
                    news.setSlug(request.getParameter("slug"));
                    news.setExcerpt(request.getParameter("excerpt"));
                    news.setContent(request.getParameter("content"));
                    news.setImageUrl(request.getParameter("imageUrl"));
                    news.setCategory(request.getParameter("category"));
                    news.setAuthor(request.getParameter("author"));
                    news.setPublished(Boolean.parseBoolean(request.getParameter("isPublished")));
                    
                    String publishedDateStr = request.getParameter("publishedDate");
                    if (publishedDateStr != null && !publishedDateStr.isEmpty()) {
                        news.setPublishedDate(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(publishedDateStr));
                    }
                    
                    boolean success = newsDAO.update(news);
                    jsonResponse.addProperty("success", success);
                    jsonResponse.addProperty("message", success ? "Cập nhật thành công" : "Cập nhật thất bại");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không tìm thấy tin tức");
                }
                
            } else if ("updateStatus".equals(action)) {
                // Update publish status
                int id = Integer.parseInt(request.getParameter("id"));
                boolean isPublished = Boolean.parseBoolean(request.getParameter("isPublished"));
                
                boolean success = newsDAO.updatePublishStatus(id, isPublished);
                jsonResponse.addProperty("success", success);
                jsonResponse.addProperty("message", success ? "Cập nhật trạng thái thành công" : "Cập nhật thất bại");
                
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
                boolean success = newsDAO.delete(id);
                
                jsonResponse.addProperty("success", success);
                jsonResponse.addProperty("message", success ? "Xóa thành công" : "Xóa thất bại");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Invalid news ID");
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
    
    /**
     * Generate slug from title
     */
    private String generateSlug(String title) {
        if (title == null || title.isEmpty()) {
            return "";
        }
        
        // Convert to lowercase and replace spaces with hyphens
        String slug = title.toLowerCase()
                          .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                          .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                          .replaceAll("[ìíịỉĩ]", "i")
                          .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                          .replaceAll("[ùúụủũưừứựửữ]", "u")
                          .replaceAll("[ỳýỵỷỹ]", "y")
                          .replaceAll("đ", "d")
                          .replaceAll("[^a-z0-9\\s-]", "")
                          .trim()
                          .replaceAll("\\s+", "-")
                          .replaceAll("-+", "-");
        
        return slug;
    }
}
