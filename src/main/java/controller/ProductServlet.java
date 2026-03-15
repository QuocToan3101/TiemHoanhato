package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
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
 * Servlet xử lý hiển thị sản phẩm
 */
@WebServlet(urlPatterns = {"/products", "/products/*", "/san-pham", "/san-pham/*"})
public class ProductServlet extends HttpServlet {
    
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private Gson gson;
    
    private static final int PRODUCTS_PER_PAGE = 12;
    
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
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        
        // Nếu là AJAX request - trả về JSON
        if ("true".equals(request.getParameter("ajax"))) {
            handleAjaxRequest(request, response);
            return;
        }
        
        // Xử lý theo path
        if (pathInfo == null || pathInfo.equals("/")) {
            // Kiểm tra có parameter category không
            String categoryParam = request.getParameter("category");
            if (categoryParam != null && !categoryParam.isEmpty()) {
                showProductsByCategory(request, response, categoryParam);
            } else {
                // Hiển thị tất cả sản phẩm
                showAllProducts(request, response);
            }
        } else if (pathInfo.startsWith("/category/") || pathInfo.startsWith("/danh-muc/")) {
            // Hiển thị sản phẩm theo danh mục
            String categorySlug = pathInfo.substring(pathInfo.lastIndexOf("/") + 1);
            showProductsByCategory(request, response, categorySlug);
        } else if (pathInfo.startsWith("/search") || pathInfo.startsWith("/tim-kiem")) {
            // Tìm kiếm sản phẩm
            searchProducts(request, response);
        } else {
            // Xem chi tiết sản phẩm theo slug
            String slug = pathInfo.substring(1);
            showProductDetail(request, response, slug);
        }
    }
    
    /**
     * Xử lý AJAX request - trả về JSON
     */
    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy tham số phân trang
            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            // Lấy tham số sắp xếp
            String sort = request.getParameter("sort");
            String categorySlug = request.getParameter("category");
            
            // Lấy sản phẩm
            List<Product> products;
            int totalProducts;
            
            if (categorySlug != null && !categorySlug.isEmpty()) {
                // Lấy theo danh mục
                Category category = categoryDAO.findBySlug(categorySlug);
                if (category != null) {
                    products = productDAO.findByCategoryWithPagination(category.getId(), page, PRODUCTS_PER_PAGE);
                    totalProducts = productDAO.countByCategory(category.getId());
                } else {
                    products = productDAO.findWithPagination(page, PRODUCTS_PER_PAGE);
                    totalProducts = productDAO.countAll();
                }
            } else {
                // Lấy tất cả
                products = productDAO.findWithPagination(page, PRODUCTS_PER_PAGE);
                totalProducts = productDAO.countAll();
            }
            
            // Sắp xếp nếu cần
            if (sort != null) {
                sortProducts(products, sort);
            }
            
            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);
            
            // Tạo JSON response
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("currentPage", page);
            jsonResponse.addProperty("totalPages", totalPages);
            jsonResponse.addProperty("totalProducts", totalProducts);
            jsonResponse.add("products", gson.toJsonTree(products));
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(jsonResponse));
            out.flush();
            
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("error", e.getMessage());
            
            try {
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(errorResponse));
                out.flush();
            } catch (IOException ex) {
                // Log error if needed
            }
        }
    }
    
    /**
     * Hiển thị tất cả sản phẩm
     */
    private void showAllProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy tham số phân trang
            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            // Lấy tham số sắp xếp
            String sort = request.getParameter("sort");
            
            // Lấy tham số lọc giá
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");
            
            // Lấy sản phẩm
            List<Product> products;
            int totalProducts;
            
            if (minPriceStr != null && maxPriceStr != null) {
                BigDecimal minPrice = new BigDecimal(minPriceStr);
                BigDecimal maxPrice = new BigDecimal(maxPriceStr);
                products = productDAO.findByPriceRange(minPrice, maxPrice);
                if (products == null) products = new ArrayList<>();
                totalProducts = products.size();
            } else {
                products = productDAO.findWithPagination(page, PRODUCTS_PER_PAGE);
                if (products == null) products = new ArrayList<>();
                totalProducts = productDAO.countAll();
            }
            
            // Sắp xếp nếu cần
            if (sort != null) {
                sortProducts(products, sort);
            }
            
            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);
            
            // Lấy danh mục cho sidebar/filter
            List<Category> categories = categoryDAO.findAll();
            if (categories == null) categories = new ArrayList<>();
            
            List<Category> parentCategories = categoryDAO.findParentCategories();
            if (parentCategories == null) parentCategories = new ArrayList<>();
            
            // Lấy sản phẩm nổi bật cho sidebar
            List<Product> featuredProducts = productDAO.findFeatured(4);
            if (featuredProducts == null) featuredProducts = new ArrayList<>();
            
            // Set attributes
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("parentCategories", parentCategories);
            request.setAttribute("featuredProducts", featuredProducts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("pageTitle", "Tất cả sản phẩm");
            
            request.getRequestDispatcher("/view/products.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            throw e;
        } catch (RuntimeException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải trang sản phẩm: " + e.getMessage());
        }
    }
    
    /**
     * Hiển thị sản phẩm theo danh mục
     */
    private void showProductsByCategory(HttpServletRequest request, HttpServletResponse response, String categorySlug)
            throws ServletException, IOException {
        
        try {
            // Tìm category
            Category category = categoryDAO.findBySlug(categorySlug);
            
            if (category == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Danh mục không tồn tại");
                return;
            }
            
            // Lấy sản phẩm theo category
            List<Product> products = productDAO.findByCategorySlug(categorySlug);
            if (products == null) products = new ArrayList<>();
            
            // Lấy sản phẩm của các danh mục con (nếu có)
            List<Category> childCategories = categoryDAO.findByParentId(category.getId());
            if (childCategories == null) childCategories = new ArrayList<>();
            
            for (Category child : childCategories) {
                List<Product> childProducts = productDAO.findByCategory(child.getId());
                if (childProducts != null) {
                    products.addAll(childProducts);
                }
            }
            
            // Lấy tham số sắp xếp
            String sort = request.getParameter("sort");
            if (sort != null) {
                sortProducts(products, sort);
            }
            
            // Lấy danh mục cho sidebar
            List<Category> categories = categoryDAO.findAll();
            if (categories == null) categories = new ArrayList<>();
            
            List<Category> parentCategories = categoryDAO.findParentCategories();
            if (parentCategories == null) parentCategories = new ArrayList<>();
            
            // Set attributes
            request.setAttribute("products", products);
            request.setAttribute("category", category);
            request.setAttribute("childCategories", childCategories);
            request.setAttribute("categories", categories);
            request.setAttribute("parentCategories", parentCategories);
            request.setAttribute("totalProducts", products.size());
            request.setAttribute("pageTitle", category.getName());
            
            request.getRequestDispatcher("/view/products.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            throw e;
        } catch (RuntimeException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải danh mục sản phẩm: " + e.getMessage());
        }
    }
    
    /**
     * Tìm kiếm sản phẩm
     */
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String keyword = request.getParameter("q");
            
            List<Product> products;
            if (keyword != null && !keyword.trim().isEmpty()) {
                products = productDAO.search(keyword.trim());
            } else {
                products = productDAO.findAll();
            }
            if (products == null) products = new ArrayList<>();
            
            // Lấy danh mục cho sidebar
            List<Category> categories = categoryDAO.findAll();
            if (categories == null) categories = new ArrayList<>();
            
            List<Category> parentCategories = categoryDAO.findParentCategories();
            if (parentCategories == null) parentCategories = new ArrayList<>();
            
            // Set attributes
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("parentCategories", parentCategories);
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("totalProducts", products.size());
            request.setAttribute("pageTitle", "Kết quả tìm kiếm: " + keyword);
            
            request.getRequestDispatcher("/view/products.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            throw e;
        } catch (RuntimeException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tìm kiếm sản phẩm: " + e.getMessage());
        }
    }
    
    /**
     * Hiển thị chi tiết sản phẩm
     */
    private void showProductDetail(HttpServletRequest request, HttpServletResponse response, String slug)
            throws ServletException, IOException {
        
        Product product = productDAO.findBySlug(slug);
        
        if (product == null) {
            // Thử tìm theo ID
            try {
                int id = Integer.parseInt(slug);
                product = productDAO.findById(id);
            } catch (NumberFormatException e) {
                // Không phải ID
            }
        }
        
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
            return;
        }
        
        // Tăng view count
        productDAO.incrementViewCount(product.getId());
        
        // Lấy sản phẩm liên quan
        List<Product> relatedProducts = null;
        if (product.getCategoryId() != null) {
            relatedProducts = productDAO.findRelated(product.getId(), product.getCategoryId(), 4);
        }
        
        // Lấy category
        Category category = null;
        if (product.getCategoryId() != null) {
            category = categoryDAO.findById(product.getCategoryId());
        }
        
        // Lấy danh mục cho breadcrumb
        List<Category> categories = categoryDAO.findAll();
        
        // Set attributes
        request.setAttribute("product", product);
        request.setAttribute("category", category);
        request.setAttribute("relatedProducts", relatedProducts);
        request.setAttribute("categories", categories);
        request.setAttribute("pageTitle", product.getName());
        
        request.getRequestDispatcher("/view/product-detail.jsp").forward(request, response);
    }
    
    /**
     * Sắp xếp danh sách sản phẩm
     */
    private void sortProducts(List<Product> products, String sort) {
        if (products == null || products.isEmpty() || sort == null) {
            return;
        }
        
        switch (sort) {
            case "price-asc":
                products.sort((a, b) -> {
                    BigDecimal priceA = a.getDisplayPrice();
                    BigDecimal priceB = b.getDisplayPrice();
                    if (priceA == null) return 1;
                    if (priceB == null) return -1;
                    return priceA.compareTo(priceB);
                });
                break;
            case "price-desc":
                products.sort((a, b) -> {
                    BigDecimal priceA = a.getDisplayPrice();
                    BigDecimal priceB = b.getDisplayPrice();
                    if (priceA == null) return 1;
                    if (priceB == null) return -1;
                    return priceB.compareTo(priceA);
                });
                break;
            case "name-asc":
                products.sort((a, b) -> {
                    String nameA = a.getName();
                    String nameB = b.getName();
                    if (nameA == null) return 1;
                    if (nameB == null) return -1;
                    return nameA.compareToIgnoreCase(nameB);
                });
                break;
            case "name-desc":
                products.sort((a, b) -> {
                    String nameA = a.getName();
                    String nameB = b.getName();
                    if (nameA == null) return 1;
                    if (nameB == null) return -1;
                    return nameB.compareToIgnoreCase(nameA);
                });
                break;
            case "newest":
                products.sort((a, b) -> {
                    java.sql.Timestamp timeA = a.getCreatedAt();
                    java.sql.Timestamp timeB = b.getCreatedAt();
                    if (timeA == null) return 1;
                    if (timeB == null) return -1;
                    return timeB.compareTo(timeA);
                });
                break;
            case "bestselling":
                products.sort((a, b) -> Integer.compare(b.getSoldCount(), a.getSoldCount()));
                break;
        }
    }
}
