package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;

/**
 * Servlet xử lý trang chủ
 */
@WebServlet(urlPatterns = {"/home", "/trang-chu", ""})
public class HomeServlet extends HttpServlet {
    
    private CategoryDAO categoryDAO;
    private ProductDAO productDAO;
    
    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== HomeServlet được gọi ===");
        
        // Lấy danh mục nổi bật (8 danh mục con có sản phẩm)
        List<Category> featuredCategories = categoryDAO.findFeaturedCategories(8);
        System.out.println("Featured Categories: " + (featuredCategories != null ? featuredCategories.size() : "null"));
        
        // Lấy sản phẩm best seller (bán chạy nhất - 8 sản phẩm)
        List<Product> bestSellerProducts = productDAO.findBestSellers(8);
        System.out.println("Best Sellers: " + (bestSellerProducts != null ? bestSellerProducts.size() : "null"));
        
        // Lấy sản phẩm mới nhất (4 sản phẩm)
        List<Product> newProducts = productDAO.findLatest(4);
        
        // Lấy sản phẩm nổi bật/featured (4 sản phẩm)
        List<Product> featuredProducts = productDAO.findFeatured(4);
        
        // Set attributes
        request.setAttribute("featuredCategories", featuredCategories);
        request.setAttribute("bestSellerProducts", bestSellerProducts);
        request.setAttribute("newProducts", newProducts);
        request.setAttribute("featuredProducts", featuredProducts);
        
        // Forward đến trang home.jsp
        request.getRequestDispatcher("/view/home.jsp").forward(request, response);
    }
}
