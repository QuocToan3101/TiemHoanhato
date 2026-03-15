package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;

/**
 * Servlet xử lý tìm kiếm sản phẩm
 */
@WebServlet(urlPatterns = {"/search", "/api/search"})
public class SearchServlet extends HttpServlet {
    
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String query = request.getParameter("q");
        String ajax = request.getParameter("ajax");
        
        // API endpoint for AJAX search
        if ("true".equals(ajax) || request.getServletPath().equals("/api/search")) {
            handleAjaxSearch(request, response, query);
            return;
        }
        
        // Forward to products.jsp with search results
        List<Product> products;
        if (query != null && !query.trim().isEmpty()) {
            products = productDAO.search(query.trim());
            request.setAttribute("searchKeyword", query.trim());
        } else {
            products = productDAO.findAll();
        }
        
        // Get categories for sidebar/filter
        List<Category> parentCategories = categoryDAO.findParentCategories();
        
        request.setAttribute("products", products);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("totalProducts", products.size());
        request.setAttribute("pageTitle", query != null ? "Tìm kiếm: " + query : "Tìm kiếm");
        
        request.getRequestDispatcher("/view/products.jsp").forward(request, response);
    }
    
    /**
     * AJAX search for live search suggestions
     */
    private void handleAjaxSearch(HttpServletRequest request, HttpServletResponse response, String query)
            throws IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            if (query == null || query.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập từ khóa tìm kiếm");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Search with limit for suggestions
            List<Product> results = productDAO.searchWithLimit(query.trim(), 8);
            
            jsonResponse.addProperty("success", true);
            jsonResponse.add("products", gson.toJsonTree(results));
            jsonResponse.addProperty("count", results.size());
            jsonResponse.addProperty("query", query.trim());
            
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
}
