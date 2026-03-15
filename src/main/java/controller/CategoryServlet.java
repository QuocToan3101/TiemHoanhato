package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.CategoryDAO;
import model.Category;

/**
 * Servlet xử lý danh mục sản phẩm
 */
@WebServlet(urlPatterns = {"/categories", "/api/categories", "/api/categories/*"})
public class CategoryServlet extends HttpServlet {
    
    private CategoryDAO categoryDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String servletPath = request.getServletPath();
        
        // Nếu là API request
        if (servletPath.startsWith("/api/")) {
            handleApiRequest(request, response);
            return;
        }
        
        // Hiển thị trang danh mục
        showCategories(request, response);
    }
    
    /**
     * Hiển thị trang danh mục
     */
    private void showCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Category> allCategories = categoryDAO.findAll();
        List<Category> parentCategories = categoryDAO.findParentCategories();
        
        // Tạo map để lưu các danh mục con
        Map<Integer, List<Category>> childCategoriesMap = new HashMap<>();
        for (Category parent : parentCategories) {
            List<Category> children = categoryDAO.findByParentId(parent.getId());
            childCategoriesMap.put(parent.getId(), children);
        }
        
        request.setAttribute("categories", allCategories);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("childCategoriesMap", childCategoriesMap);
        
        request.getRequestDispatcher("/view/categories.jsp").forward(request, response);
    }
    
    /**
     * Xử lý API request
     */
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Lấy tất cả danh mục
                String type = request.getParameter("type");
                List<Category> categories;
                
                if ("parent".equals(type)) {
                    categories = categoryDAO.findParentCategories();
                } else if ("tree".equals(type)) {
                    // Trả về cấu trúc cây
                    categories = buildCategoryTree();
                } else {
                    categories = categoryDAO.findAll();
                }
                
                jsonResponse.addProperty("success", true);
                jsonResponse.add("categories", gson.toJsonTree(categories));
                
            } else if (pathInfo.matches("/\\d+")) {
                // Lấy danh mục theo ID
                int id = Integer.parseInt(pathInfo.substring(1));
                Category category = categoryDAO.findById(id);
                
                if (category != null) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.add("category", gson.toJsonTree(category));
                    
                    // Lấy danh mục con
                    List<Category> children = categoryDAO.findByParentId(id);
                    jsonResponse.add("children", gson.toJsonTree(children));
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Danh mục không tồn tại");
                }
                
            } else if (pathInfo.startsWith("/slug/")) {
                // Lấy danh mục theo slug
                String slug = pathInfo.substring(6);
                Category category = categoryDAO.findBySlug(slug);
                
                if (category != null) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.add("category", gson.toJsonTree(category));
                    
                    // Lấy danh mục con
                    List<Category> children = categoryDAO.findByParentId(category.getId());
                    jsonResponse.add("children", gson.toJsonTree(children));
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Danh mục không tồn tại");
                }
                
            } else if (pathInfo.startsWith("/children/")) {
                // Lấy danh mục con theo parent ID
                int parentId = Integer.parseInt(pathInfo.substring(10));
                List<Category> children = categoryDAO.findByParentId(parentId);
                
                jsonResponse.addProperty("success", true);
                jsonResponse.add("categories", gson.toJsonTree(children));
                
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Invalid endpoint");
            }
            
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Invalid ID format");
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Xây dựng cây danh mục
     */
    private List<Category> buildCategoryTree() {
        List<Category> parentCategories = categoryDAO.findParentCategories();
        // Trong thực tế, bạn có thể thêm children vào mỗi parent
        // Nhưng model Category hiện tại chưa có field List<Category> children
        return parentCategories;
    }
}
