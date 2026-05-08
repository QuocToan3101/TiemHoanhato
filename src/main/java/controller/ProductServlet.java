package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@WebServlet(urlPatterns = {"/products", "/products/*", "/san-pham", "/san-pham/*"})
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || "/".equals(pathInfo)) {
            handleListPage(request, response);
            return;
        }

        if (pathInfo.startsWith("/category/")) {
            handleCategoryPage(request, response, pathInfo.substring("/category/".length()));
            return;
        }

        handleDetailPage(request, response, pathInfo.substring(1));
    }

    private void handleListPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        final int PAGE_SIZE = 12; // 3 hàng x 4 cột
        
        // Lấy page number từ request, mặc định là 1
        int pageNumber = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                pageNumber = Integer.parseInt(pageParam);
                if (pageNumber < 1) pageNumber = 1;
            }
        } catch (NumberFormatException e) {
            pageNumber = 1;
        }
        
        // Lấy tổng số sản phẩm
        int totalProducts = productDAO.countAll();
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
        
        // Đảm bảo page không vượt quá tổng số trang
        if (pageNumber > totalPages && totalPages > 0) {
            pageNumber = totalPages;
        }
        
        // Lấy sản phẩm của trang hiện tại
        List<Product> products = productDAO.findWithPagination(pageNumber, PAGE_SIZE);
        List<Category> parentCategories = categoryDAO.findParentCategories();
        
        // Kiểm tra xem có phải AJAX request không
        String isAjax = request.getParameter("ajax");
        
        if ("true".equals(isAjax)) {
            // Trả về JSON cho AJAX
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("currentPage", pageNumber);
            jsonResponse.addProperty("totalPages", totalPages);
            jsonResponse.addProperty("totalProducts", totalProducts);
            
            // Convert products to JSON array
            Gson gson = new Gson();
            jsonResponse.add("products", gson.toJsonTree(products));
            
            response.getWriter().print(jsonResponse.toString());
        } else {
            // Regular page load - trả về JSP
            request.setAttribute("products", products);
            request.setAttribute("parentCategories", parentCategories);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("currentPage", pageNumber);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", PAGE_SIZE);
            
            request.getRequestDispatcher("/view/products.jsp").forward(request, response);
        }
    }

    private void handleCategoryPage(HttpServletRequest request, HttpServletResponse response, String categorySlug)
            throws ServletException, IOException {

        if (categorySlug == null || categorySlug.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        Category category = categoryDAO.findBySlug(categorySlug);
        List<Product> products = (category != null) ? productDAO.findByCategorySlug(categorySlug) : new ArrayList<>();
        List<Category> parentCategories = categoryDAO.findParentCategories();

        request.setAttribute("products", products);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("category", category);
        request.setAttribute("searchKeyword", null);
        request.setAttribute("totalProducts", products.size());

        request.getRequestDispatcher("/view/products.jsp").forward(request, response);
    }

    private void handleDetailPage(HttpServletRequest request, HttpServletResponse response, String slug)
            throws ServletException, IOException {

        if (slug == null || slug.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        Product product = productDAO.findBySlug(slug);
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        productDAO.incrementViewCount(product.getId());

        int categoryId = product.getCategoryId() != null ? product.getCategoryId() : 0;
        List<Product> relatedProducts = categoryId > 0
                ? productDAO.findRelated(product.getId(), categoryId, 4)
                : new ArrayList<>();
        List<String> productImages = buildProductImages(product);

        request.setAttribute("product", product);
        request.setAttribute("category", product.getCategory());
        request.setAttribute("productImages", productImages);
        request.setAttribute("relatedProducts", relatedProducts);

        request.getRequestDispatcher("/view/product-detail.jsp").forward(request, response);
    }

    private List<String> buildProductImages(Product product) {
        Set<String> uniqueImages = new LinkedHashSet<>();

        if (product.getImage() != null && !product.getImage().trim().isEmpty()) {
            uniqueImages.add(product.getImage().trim());
        }

        String imagesJson = product.getImages();
        if (imagesJson != null && !imagesJson.trim().isEmpty()) {
            String raw = imagesJson.trim();
            if (raw.startsWith("[") && raw.endsWith("]")) {
                raw = raw.substring(1, raw.length() - 1);
            }

            if (!raw.isEmpty()) {
                String[] parts = raw.split("\",\\s*\"");
                for (String part : parts) {
                    String cleaned = part.replaceAll("^\\\"|\\\"$", "").replace("\\/", "/").trim();
                    if (!cleaned.isEmpty()) {
                        uniqueImages.add(cleaned);
                    }
                }
            }
        }

        List<String> images = new ArrayList<>(uniqueImages);
        if (images.isEmpty()) {
            images.add("https://via.placeholder.com/500x450?text=No+Image");
        }

        // Keep at least 3 thumbnails for a consistent detail-page gallery layout.
        while (images.size() < 3) {
            images.add(images.get(0));
        }

        return images;
    }
}
