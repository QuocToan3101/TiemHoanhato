plugins {
    id 'java'
    id 'war' // Dành cho Servlet
}

repositories {
    mavenCentral()
}

dependencies {
    compileOnly 'javax.servlet:javax.servlet-api:4.0.1'
    implementation 'com.google.code.gson:gson:2.10.1'
    // Các thư viện khác của bạn (JDBC, v.v.)
}package controller;

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
        String categoryIdStr = request.getParameter("categoryId");
        String ajax = request.getParameter("ajax");

        // 1. Xử lý logic AJAX
        if ("true".equals(ajax) || request.getServletPath().equals("/api/search")) {
            handleAjaxSearch(request, response, query, categoryIdStr);
            return;
        }

        // 2. Xử lý logic lọc dữ liệu cho JSP
        List<Product> products;
        Integer categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : null;
        String keyword = (query != null && !query.trim().isEmpty()) ? query.trim() : null;

        // Gọi hàm DAO linh hoạt (Bạn cần cập nhật ProductDAO để hỗ trợ lọc kép)
        if (keyword != null && categoryId != null) {
            products = productDAO.searchByKeywordAndCategory(keyword, categoryId);
        } else if (keyword != null) {
            products = productDAO.search(keyword);
        } else if (categoryId != null) {
            products = productDAO.findByCategoryId(categoryId);
        } else {
            products = productDAO.findAll();
        }

        // Trả dữ liệu về cho Sidebar và Filter
        List<Category> parentCategories = categoryDAO.findParentCategories();

        request.setAttribute("products", products);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("selectedCategoryId", categoryId); // Để giữ trạng thái active trên giao diện
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("totalProducts", products.size());

        request.getRequestDispatcher("/view/products.jsp").forward(request, response);
    }

    private void handleAjaxSearch(HttpServletRequest request, HttpServletResponse response, String query, String categoryIdStr)
            throws IOException {

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            // Logic AJAX thường dùng cho gợi ý (Autocomplete) nên thường ưu tiên keyword
            List<Product> results;
            if (query != null && !query.trim().isEmpty()) {
                results = productDAO.searchWithLimit(query.trim(), 8);
                jsonResponse.addProperty("success", true);
                jsonResponse.add("products", gson.toJsonTree(results));
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Từ khóa trống");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        out.print(gson.toJson(jsonResponse));
    }
}