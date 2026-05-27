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
            
            // Read JSON request body if present
            JsonObject body = null;
            String contentType = request.getContentType();
            if (contentType != null && contentType.toLowerCase().contains("application/json")) {
                try {
                    body = gson.fromJson(request.getReader(), JsonObject.class);
                } catch (Exception e) {
                    System.err.println("[NewsServlet] Error parsing JSON body: " + e.getMessage());
                }
            }
            
            final JsonObject jsonBody = body;
            
            // Helper functions to fetch parameters from either JSON or standard form parameters
            java.util.function.Function<String, String> getParam = (name) -> {
                if (jsonBody != null && jsonBody.has(name) && !jsonBody.get(name).isJsonNull()) {
                    return jsonBody.get(name).getAsString();
                }
                return request.getParameter(name);
            };
            
            java.util.function.Function<String, Boolean> getParamBool = (name) -> {
                if (jsonBody != null) {
                    if (jsonBody.has(name) && !jsonBody.get(name).isJsonNull()) {
                        return jsonBody.get(name).getAsBoolean();
                    }
                    if ("isPublished".equals(name) && jsonBody.has("published") && !jsonBody.get("published").isJsonNull()) {
                        return jsonBody.get("published").getAsBoolean();
                    }
                    if ("published".equals(name) && jsonBody.has("isPublished") && !jsonBody.get("isPublished").isJsonNull()) {
                        return jsonBody.get("isPublished").getAsBoolean();
                    }
                }
                String val = request.getParameter(name);
                if (val == null) {
                    if ("isPublished".equals(name)) {
                        val = request.getParameter("published");
                    } else if ("published".equals(name)) {
                        val = request.getParameter("isPublished");
                    }
                }
                return Boolean.parseBoolean(val);
            };
            
            java.util.function.Function<String, Integer> getParamInt = (name) -> {
                if (jsonBody != null && jsonBody.has(name) && !jsonBody.get(name).isJsonNull()) {
                    return jsonBody.get(name).getAsInt();
                }
                String val = request.getParameter(name);
                return val != null ? Integer.parseInt(val) : null;
            };
            
            if ("add".equals(action)) {
                // Add new news
                News news = new News();
                news.setTitle(getParam.apply("title"));
                news.setSlug(generateSlug(getParam.apply("title")));
                news.setExcerpt(getParam.apply("excerpt"));
                news.setContent(getParam.apply("content"));
                news.setImageUrl(getParam.apply("imageUrl"));
                news.setCategory(getParam.apply("category"));
                news.setAuthor(getParam.apply("author"));
                news.setPublished(getParamBool.apply("isPublished"));
                
                String publishedDateStr = getParam.apply("publishedDate");
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
                int id = getParamInt.apply("id");
                News news = newsDAO.getById(id);
                
                if (news != null) {
                    news.setTitle(getParam.apply("title"));
                    news.setSlug(getParam.apply("slug"));
                    news.setExcerpt(getParam.apply("excerpt"));
                    news.setContent(getParam.apply("content"));
                    news.setImageUrl(getParam.apply("imageUrl"));
                    news.setCategory(getParam.apply("category"));
                    news.setAuthor(getParam.apply("author"));
                    news.setPublished(getParamBool.apply("isPublished"));
                    
                    String publishedDateStr = getParam.apply("publishedDate");
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
                int id = getParamInt.apply("id");
                boolean isPublished = getParamBool.apply("isPublished");
                
                boolean success = newsDAO.updatePublishStatus(id, isPublished);
                jsonResponse.addProperty("success", success);
                jsonResponse.addProperty("message", success ? "Cập nhật trạng thái thành công" : "Cập nhật thất bại");
                
            } else if ("delete".equals(action)) {
                // Delete news via POST
                int id = getParamInt.apply("id");
                boolean success = newsDAO.delete(id);
                jsonResponse.addProperty("success", success);
                jsonResponse.addProperty("message", success ? "Xóa thành công" : "Xóa thất bại");
                
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
