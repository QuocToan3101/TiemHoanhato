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
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

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

        disableCaching(response);

        request.setCharacterEncoding("UTF-8");

        String query = request.getParameter("q");
        String categoryIdStr = request.getParameter("categoryId");
        String ajax = request.getParameter("ajax");

        if ("true".equals(ajax) || "/api/search".equals(request.getServletPath())) {
            handleAjaxSearch(response, query);
            return;
        }

        Integer categoryId = parseIntOrNull(categoryIdStr);
        String keyword = normalizeKeyword(query);

        List<Product> products = searchProducts(keyword, categoryId);
        List<Category> parentCategories = categoryDAO.findParentCategories();

        request.setAttribute("products", products);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("totalProducts", products.size());

        request.getRequestDispatcher("/view/products.jsp").forward(request, response);
    }

    private void handleAjaxSearch(HttpServletResponse response, String query) throws IOException {
        response.setContentType("application/json; charset=UTF-8");

        JsonObject jsonResponse = new JsonObject();
        try (PrintWriter out = response.getWriter()) {
            String keyword = normalizeKeyword(query);
            if (keyword == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Từ khóa trống");
            } else {
                List<Product> results = productDAO.searchWithLimit(keyword, 8);
                jsonResponse.addProperty("success", true);
                jsonResponse.add("products", gson.toJsonTree(results));
            }
            out.print(gson.toJson(jsonResponse));
        }
    }

    private List<Product> searchProducts(String keyword, Integer categoryId) {
        if (keyword == null && categoryId == null) {
            return productDAO.findAll();
        }

        if (keyword == null) {
            return productDAO.findByCategory(categoryId);
        }

        List<Product> keywordResults = productDAO.search(keyword);
        if (categoryId == null) {
            return keywordResults;
        }

        List<Product> filtered = new ArrayList<>();
        for (Product product : keywordResults) {
            if (product.getCategoryId() != null && product.getCategoryId().equals(categoryId)) {
                filtered.add(product);
            }
        }
        return filtered;
    }

    private Integer parseIntOrNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String normalizeKeyword(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void disableCaching(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
}
