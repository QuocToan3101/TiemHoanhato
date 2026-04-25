package controller;

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
import java.util.List;

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

        List<Product> products = productDAO.findAll();
        List<Category> parentCategories = categoryDAO.findParentCategories();

        request.setAttribute("products", products);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("totalProducts", products.size());

        request.getRequestDispatcher("/view/products.jsp").forward(request, response);
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

        request.setAttribute("product", product);
        request.setAttribute("relatedProducts", relatedProducts);

        request.getRequestDispatcher("/view/product-detail.jsp").forward(request, response);
    }
}
