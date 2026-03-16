package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dao.CategoryDAO;
import dao.ContactDAO;
import dao.CouponDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.UserDAO;
import model.Category;
import model.Contact;
import model.Coupon;
import model.Order;
import model.Product;
import model.User;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private UserDAO userDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    private CategoryDAO categoryDAO;
    private CouponDAO couponDAO;
    private ContactDAO contactDAO;
    private Gson gson;

    @Override
    public void init() {
        userDAO = new UserDAO();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
        categoryDAO = new CategoryDAO();
        couponDAO = new CouponDAO();
        contactDAO = new ContactDAO();
        gson = new Gson();
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập và quyền admin
        if (!checkAdmin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            showDashboard(request, response);
        } else if (pathInfo.equals("/users")) {
            showUsers(request, response);
        } else if (pathInfo.equals("/products")) {
            showProducts(request, response);
        } else if (pathInfo.equals("/orders")) {
            showOrders(request, response);
        } else if (pathInfo.equals("/categories")) {
            showCategories(request, response);
        } else if (pathInfo.startsWith("/api/")) {
            handleApiGet(request, response, pathInfo);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdmin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/api/")) {
            handleApiPost(request, response, pathInfo);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdmin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/api/")) {
            handleApiDelete(request, response, pathInfo);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này");
            return false;
        }

        return true;
    }
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy thống kê
        int totalUsers = userDAO.getTotalUsers();
        int totalProducts = productDAO.getTotalProducts();
        int totalOrders = orderDAO.getTotalOrders();
        java.math.BigDecimal totalRevenue = orderDAO.getTotalRevenue();
        
        // Lấy đơn hàng mới nhất
        List<Order> recentOrders = orderDAO.getRecentOrders(10);
        
        // Lấy sản phẩm bán chạy
        List<Product> topProducts = productDAO.findBestSellers(5);

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("topProducts", topProducts);

        request.getRequestDispatcher("/view/admin.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin.jsp").forward(request, response);
    }

    private void showProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin.jsp").forward(request, response);
    }

    private void showOrders(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin.jsp").forward(request, response);
    }

    private void showCategories(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin.jsp").forward(request, response);
    }

    private void handleApiGet(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            if (pathInfo.equals("/api/users")) {
                List<User> users = userDAO.findAll();
                result.put("success", true);
                result.put("data", users);
            } else if (pathInfo.equals("/api/products/top")) {
                // API cho top sản phẩm bán chạy
                int limit = 5;
                String limitParam = request.getParameter("limit");
                if (limitParam != null && !limitParam.isEmpty()) {
                    limit = Integer.parseInt(limitParam);
                }
                List<Product> topProducts = productDAO.getTopSellingProducts(limit);
                result.put("success", true);
                result.put("data", topProducts);
            } else if (pathInfo.equals("/api/products")) {
                // API cho sản phẩm với tìm kiếm và filter
                String search = request.getParameter("search");
                String categoryIdStr = request.getParameter("categoryId");
                String statusStr = request.getParameter("status");
                
                List<Product> products;
                
                if (search != null && !search.trim().isEmpty()) {
                    // Có tìm kiếm, dùng search method (nhưng cần bao gồm cả inactive cho admin)
                    products = productDAO.searchIncludeInactive(search);
                } else if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                    // Filter theo category
                    try {
                        int categoryId = Integer.parseInt(categoryIdStr);
                        products = productDAO.findByCategoryIncludeInactive(categoryId);
                    } catch (NumberFormatException e) {
                        products = productDAO.findAllIncludeInactive();
                    }
                } else {
                    // Không có filter, lấy tất cả
                    products = productDAO.findAllIncludeInactive();
                }
                
                // Filter theo status nếu có
                if (statusStr != null && !statusStr.trim().isEmpty()) {
                    boolean isActive = "active".equals(statusStr);
                    products = products.stream()
                        .filter(p -> p.isActive() == isActive)
                        .collect(java.util.stream.Collectors.toList());
                }
                
                result.put("success", true);
                result.put("data", products);
            } else if (pathInfo.startsWith("/api/product/")) {
                int productId = Integer.parseInt(pathInfo.substring("/api/product/".length()));
                Product product = productDAO.findById(productId);
                if (product != null) {
                    result.put("success", true);
                    result.put("data", product);
                } else {
                    result.put("success", false);
                    result.put("message", "Không tìm thấy sản phẩm");
                }
            } else if (pathInfo.equals("/api/orders/recent")) {
                // API cho đơn hàng gần đây
                int limit = 10;
                String limitParam = request.getParameter("limit");
                if (limitParam != null && !limitParam.isEmpty()) {
                    limit = Integer.parseInt(limitParam);
                }
                List<Order> orders = orderDAO.getRecentOrders(limit);
                result.put("success", true);
                result.put("data", orders);
            } else if (pathInfo.equals("/api/orders")) {
                // API cho đơn hàng với tìm kiếm và filter
                String search = request.getParameter("search");
                String status = request.getParameter("status");
                String dateFromStr = request.getParameter("dateFrom");
                String dateToStr = request.getParameter("dateTo");
                
                java.sql.Date dateFrom = null;
                java.sql.Date dateTo = null;
                
                if (dateFromStr != null && !dateFromStr.isEmpty()) {
                    try {
                        dateFrom = java.sql.Date.valueOf(dateFromStr);
                    } catch (IllegalArgumentException e) {
                        System.err.println("Invalid dateFrom: " + dateFromStr);
                    }
                }
                
                if (dateToStr != null && !dateToStr.isEmpty()) {
                    try {
                        dateTo = java.sql.Date.valueOf(dateToStr);
                    } catch (IllegalArgumentException e) {
                        System.err.println("Invalid dateTo: " + dateToStr);
                    }
                }
                
                List<Order> orders;
                if ((search != null && !search.trim().isEmpty()) || 
                    (status != null && !status.trim().isEmpty()) ||
                    dateFrom != null || dateTo != null) {
                    // Có filter hoặc search, dùng searchWithFilters
                    orders = orderDAO.searchWithFilters(search, status, dateFrom, dateTo);
                } else {
                    // Không có filter, lấy tất cả
                    orders = orderDAO.findAll();
                }
                
                result.put("success", true);
                result.put("data", orders);
            } else if (pathInfo.startsWith("/api/order/")) {
                int orderId = Integer.parseInt(pathInfo.substring("/api/order/".length()));
                Order order = orderDAO.findById(orderId);
                if (order != null) {
                    result.put("success", true);
                    result.put("data", order);
                } else {
                    result.put("success", false);
                    result.put("message", "Không tìm thấy đơn hàng");
                }
            } else if (pathInfo.equals("/api/categories")) {
                List<Category> categories = categoryDAO.findAllIncludeInactive();
                result.put("success", true);
                result.put("data", categories);
            } else if (pathInfo.startsWith("/api/category/")) {
                int categoryId = Integer.parseInt(pathInfo.substring("/api/category/".length()));
                Category category = categoryDAO.findById(categoryId);
                if (category != null) {
                    result.put("success", true);
                    result.put("data", category);
                } else {
                    result.put("success", false);
                    result.put("message", "Không tìm thấy danh mục");
                }
            } else if (pathInfo.equals("/api/coupons")) {
                List<Coupon> coupons = couponDAO.findAll();
                result.put("success", true);
                result.put("data", coupons);
            } else if (pathInfo.startsWith("/api/coupon/")) {
                int couponId = Integer.parseInt(pathInfo.substring("/api/coupon/".length()));
                Coupon coupon = couponDAO.findById(couponId);
                if (coupon != null) {
                    result.put("success", true);
                    result.put("data", coupon);
                } else {
                    result.put("success", false);
                    result.put("message", "Không tìm thấy mã giảm giá");
                }
            } else if (pathInfo.equals("/api/contacts")) {
                String status = request.getParameter("status");
                List<Contact> contacts;
                if (status != null && !status.isEmpty()) {
                    contacts = contactDAO.findByStatus(status);
                } else {
                    contacts = contactDAO.findAll();
                }
                result.put("success", true);
                result.put("data", contacts);
            } else if (pathInfo.startsWith("/api/contact/")) {
                int contactId = Integer.parseInt(pathInfo.substring("/api/contact/".length()));
                Contact contact = contactDAO.findById(contactId);
                if (contact != null) {
                    result.put("success", true);
                    result.put("data", contact);
                } else {
                    result.put("success", false);
                    result.put("message", "Không tìm thấy liên hệ");
                }
            } else if (pathInfo.equals("/api/stats")) {
                Map<String, Object> stats = new HashMap<>();
                int totalUsers = userDAO.getTotalUsers();
                int totalProducts = productDAO.getTotalProducts();
                int totalOrders = orderDAO.getTotalOrders();
                BigDecimal totalRevenue = orderDAO.getTotalRevenue();
                
                System.out.println("[AdminServlet] Stats API called");
                System.out.println("  Total Users: " + totalUsers);
                System.out.println("  Total Products: " + totalProducts);
                System.out.println("  Total Orders: " + totalOrders);
                System.out.println("  Total Revenue: " + totalRevenue);
                
                stats.put("totalUsers", totalUsers);
                stats.put("totalProducts", totalProducts);
                stats.put("totalOrders", totalOrders);
                stats.put("totalRevenue", totalRevenue);
                stats.put("totalCoupons", couponDAO.getTotalCoupons());
                stats.put("totalContacts", contactDAO.getTotalContacts());
                stats.put("pendingOrders", orderDAO.countByStatus("pending"));
                stats.put("confirmedOrders", orderDAO.countByStatus("confirmed"));
                stats.put("shippingOrders", orderDAO.countByStatus("shipping"));
                stats.put("deliveredOrders", orderDAO.countByStatus("delivered"));
                stats.put("cancelledOrders", orderDAO.countByStatus("cancelled"));
                stats.put("newContacts", contactDAO.countByStatus("new"));
                result.put("success", true);
                result.put("data", stats);
            } else if (pathInfo.equals("/api/revenue")) {
                // API cho biểu đồ doanh thu
                String period = request.getParameter("period");
                if (period == null) period = "week";
                
                List<Map<String, Object>> revenueData = new ArrayList<>();
                java.time.LocalDate today = java.time.LocalDate.now();
                
                if ("week".equals(period)) {
                    // 7 ngày gần đây
                    for (int i = 6; i >= 0; i--) {
                        java.time.LocalDate date = today.minusDays(i);
                        BigDecimal revenue = orderDAO.getRevenueByDate(java.sql.Date.valueOf(date));
                        Map<String, Object> dayData = new HashMap<>();
                        dayData.put("date", date.toString());
                        dayData.put("revenue", revenue != null ? revenue : BigDecimal.ZERO);
                        revenueData.add(dayData);
                    }
                } else if ("month".equals(period)) {
                    // 30 ngày gần đây
                    for (int i = 29; i >= 0; i--) {
                        java.time.LocalDate date = today.minusDays(i);
                        BigDecimal revenue = orderDAO.getRevenueByDate(java.sql.Date.valueOf(date));
                        Map<String, Object> dayData = new HashMap<>();
                        dayData.put("date", date.toString());
                        dayData.put("revenue", revenue != null ? revenue : BigDecimal.ZERO);
                        revenueData.add(dayData);
                    }
                }
                
                result.put("success", true);
                result.put("data", revenueData);
            } else if (pathInfo.equals("/api/analytics")) {
                // API cho thống kê và báo cáo chi tiết
                String daysParam = request.getParameter("days");
                int days = daysParam != null ? Integer.parseInt(daysParam) : 7;
                
                Map<String, Object> analyticsData = new HashMap<>();
                java.time.LocalDate today = java.time.LocalDate.now();
                java.time.LocalDate startDate = today.minusDays(days - 1);
                
                // Tính tổng doanh thu và đơn hàng trong khoảng thời gian
                BigDecimal totalRevenue = BigDecimal.ZERO;
                int totalOrders = 0;
                
                List<Map<String, Object>> dailyRevenue = new ArrayList<>();
                for (int i = days - 1; i >= 0; i--) {
                    java.time.LocalDate date = today.minusDays(i);
                    BigDecimal revenue = orderDAO.getRevenueByDate(java.sql.Date.valueOf(date));
                    if (revenue != null) {
                        totalRevenue = totalRevenue.add(revenue);
                    }
                    Map<String, Object> dayData = new HashMap<>();
                    dayData.put("date", date.toString());
                    dayData.put("revenue", revenue != null ? revenue : BigDecimal.ZERO);
                    dailyRevenue.add(dayData);
                }
                
                // Lấy số đơn hàng trong kỳ
                totalOrders = orderDAO.countOrdersByDateRange(
                    java.sql.Date.valueOf(startDate), 
                    java.sql.Date.valueOf(today)
                );
                
                // Tính giá trị trung bình
                BigDecimal avgOrderValue = totalOrders > 0 
                    ? totalRevenue.divide(new BigDecimal(totalOrders), 0, java.math.RoundingMode.HALF_UP)
                    : BigDecimal.ZERO;
                
                // Tỷ lệ hoàn thành
                int deliveredOrders = orderDAO.countByStatusAndDateRange(
                    "delivered",
                    java.sql.Date.valueOf(startDate),
                    java.sql.Date.valueOf(today)
                );
                double completeRate = totalOrders > 0 
                    ? (double) deliveredOrders / totalOrders * 100 
                    : 0;
                
                // Thống kê theo trạng thái
                Map<String, Integer> statusStats = new HashMap<>();
                statusStats.put("pending", orderDAO.countByStatusAndDateRange("pending", 
                    java.sql.Date.valueOf(startDate), java.sql.Date.valueOf(today)));
                statusStats.put("shipping", orderDAO.countByStatusAndDateRange("shipping", 
                    java.sql.Date.valueOf(startDate), java.sql.Date.valueOf(today)));
                statusStats.put("delivered", deliveredOrders);
                statusStats.put("cancelled", orderDAO.countByStatusAndDateRange("cancelled", 
                    java.sql.Date.valueOf(startDate), java.sql.Date.valueOf(today)));
                
                // Top sản phẩm bán chạy
                List<Product> topProducts = productDAO.getTopSellingProducts(5);
                
                // Đóng gói dữ liệu
                analyticsData.put("totalRevenue", totalRevenue);
                analyticsData.put("totalOrders", totalOrders);
                analyticsData.put("avgOrderValue", avgOrderValue);
                analyticsData.put("completeRate", Math.round(completeRate * 10) / 10.0);
                analyticsData.put("revenueByDay", dailyRevenue);
                analyticsData.put("orderStatus", statusStats);
                analyticsData.put("topProducts", topProducts);
                
                result.put("success", true);
                result.put("data", analyticsData);
            } else {
                result.put("success", false);
                result.put("message", "API không tồn tại: " + pathInfo);
            }
        } catch (NumberFormatException e) {
            System.err.println("[AdminServlet] Invalid ID format: " + e.getMessage());
            result.put("success", false);
            result.put("message", "ID không hợp lệ");
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error in handleApiGet: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
        }
        
        response.getWriter().write(gson.toJson(result));
    }

    private void handleApiPost(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            switch (pathInfo) {
                case "/api/product/add":
                    handleAddProduct(request, result);
                    break;
                    
                case "/api/product/update":
                    handleUpdateProduct(request, result);
                    break;
                    
                case "/api/category/add":
                    handleAddCategory(request, result);
                    break;
                    
                case "/api/category/update":
                    handleUpdateCategory(request, result);
                    break;
                    
                case "/api/product/toggle-active":
                    int productId = Integer.parseInt(request.getParameter("id"));
                    boolean productSuccess = productDAO.toggleActive(productId);
                    result.put("success", productSuccess);
                    result.put("message", productSuccess ? "Cập nhật trạng thái sản phẩm thành công" : "Cập nhật thất bại");
                    break;
                    
                case "/api/order/update-status":
                    int orderId = Integer.parseInt(request.getParameter("id"));
                    String orderStatus = request.getParameter("status");
                    boolean orderSuccess = orderDAO.updateStatus(orderId, orderStatus);
                    result.put("success", orderSuccess);
                    result.put("message", orderSuccess ? "Cập nhật trạng thái đơn hàng thành công" : "Cập nhật thất bại");
                    break;
                    
                case "/api/user/update-status":
                    int userId = Integer.parseInt(request.getParameter("id"));
                    String userStatus = request.getParameter("status");
                    boolean userSuccess = userDAO.updateStatus(userId, userStatus);
                    result.put("success", userSuccess);
                    result.put("message", userSuccess ? "Cập nhật trạng thái người dùng thành công" : "Cập nhật thất bại");
                    break;
                    
                case "/api/coupon/add":
                    handleAddCoupon(request, result);
                    break;
                    
                case "/api/coupon/update":
                    handleUpdateCoupon(request, result);
                    break;
                    
                case "/api/coupon/toggle-active":
                    int couponId = Integer.parseInt(request.getParameter("id"));
                    boolean couponSuccess = couponDAO.toggleActive(couponId);
                    result.put("success", couponSuccess);
                    result.put("message", couponSuccess ? "Cập nhật trạng thái mã giảm giá thành công" : "Cập nhật thất bại");
                    break;
                    
                case "/api/contact/update-status":
                    int contactId = Integer.parseInt(request.getParameter("id"));
                    String contactStatus = request.getParameter("status");
                    boolean contactSuccess = contactDAO.updateStatus(contactId, contactStatus);
                    result.put("success", contactSuccess);
                    result.put("message", contactSuccess ? "Cập nhật trạng thái liên hệ thành công" : "Cập nhật thất bại");
                    break;
                    
                default:
                    result.put("success", false);
                    result.put("message", "API không tồn tại: " + pathInfo);
            }
        } catch (NumberFormatException e) {
            System.err.println("[AdminServlet] Invalid number format: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Tham số không hợp lệ");
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error in handleApiPost: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    private void handleAddProduct(HttpServletRequest request, Map<String, Object> result) {
        try {
            String name = request.getParameter("name");
            String slug = request.getParameter("slug");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String salePriceStr = request.getParameter("salePrice");
            BigDecimal salePrice = (salePriceStr != null && !salePriceStr.isEmpty()) ? new BigDecimal(salePriceStr) : null;
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String categoryIdStr = request.getParameter("categoryId");
            Integer categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : null;
            String description = request.getParameter("description");
            String shortDescription = request.getParameter("shortDescription");
            String image = request.getParameter("image");
            String isFeaturedStr = request.getParameter("isFeatured");
            boolean isFeatured = "true".equalsIgnoreCase(isFeaturedStr) || "on".equalsIgnoreCase(isFeaturedStr);
            
            Product newProduct = new Product();
            newProduct.setName(name);
            newProduct.setSlug(slug != null && !slug.isEmpty() ? slug : generateSlug(name));
            newProduct.setPrice(price);
            newProduct.setSalePrice(salePrice);
            newProduct.setQuantity(quantity);
            newProduct.setCategoryId(categoryId);
            newProduct.setDescription(description);
            newProduct.setShortDescription(shortDescription);
            newProduct.setImage(image);
            newProduct.setFeatured(isFeatured);
            newProduct.setActive(true);
            
            boolean success = productDAO.insert(newProduct);
            result.put("success", success);
            result.put("message", success ? "Thêm sản phẩm thành công" : "Thêm sản phẩm thất bại");
            if (success) {
                result.put("productId", newProduct.getId());
            }
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error adding product: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
    }
    
    private void handleUpdateProduct(HttpServletRequest request, Map<String, Object> result) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.findById(id);
            if (product == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy sản phẩm");
                return;
            }
            
            String name = request.getParameter("name");
            String slug = request.getParameter("slug");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String salePriceStr = request.getParameter("salePrice");
            BigDecimal salePrice = (salePriceStr != null && !salePriceStr.isEmpty()) ? new BigDecimal(salePriceStr) : null;
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String categoryIdStr = request.getParameter("categoryId");
            Integer categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : null;
            String description = request.getParameter("description");
            String shortDescription = request.getParameter("shortDescription");
            String image = request.getParameter("image");
            String isFeaturedStr = request.getParameter("isFeatured");
            boolean isFeatured = "true".equalsIgnoreCase(isFeaturedStr) || "on".equalsIgnoreCase(isFeaturedStr);
            
            product.setName(name);
            product.setSlug(slug);
            product.setPrice(price);
            product.setSalePrice(salePrice);
            product.setQuantity(quantity);
            product.setCategoryId(categoryId);
            product.setDescription(description);
            product.setShortDescription(shortDescription);
            if (image != null && !image.isEmpty()) {
                product.setImage(image);
            }
            product.setFeatured(isFeatured);
            
            boolean success = productDAO.update(product);
            result.put("success", success);
            result.put("message", success ? "Cập nhật sản phẩm thành công" : "Cập nhật sản phẩm thất bại");
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error updating product: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
    }
    
    private void handleAddCategory(HttpServletRequest request, Map<String, Object> result) {
        try {
            String name = request.getParameter("name");
            String slug = request.getParameter("slug");
            String description = request.getParameter("description");
            String image = request.getParameter("image");
            String parentIdStr = request.getParameter("parentId");
            Integer parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : null;
            
            Category newCategory = new Category();
            newCategory.setName(name);
            newCategory.setSlug(slug != null && !slug.isEmpty() ? slug : generateSlug(name));
            newCategory.setDescription(description);
            newCategory.setImage(image);
            newCategory.setParentId(parentId);
            newCategory.setActive(true);
            
            boolean success = categoryDAO.insert(newCategory);
            result.put("success", success);
            result.put("message", success ? "Thêm danh mục thành công" : "Thêm danh mục thất bại");
            if (success) {
                result.put("categoryId", newCategory.getId());
            }
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error adding category: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
    }
    
    private void handleUpdateCategory(HttpServletRequest request, Map<String, Object> result) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Category category = categoryDAO.findById(id);
            if (category == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy danh mục");
                return;
            }
            
            String name = request.getParameter("name");
            String slug = request.getParameter("slug");
            if (slug == null || slug.isEmpty()) {
                // Tự động tạo slug từ name nếu không có
                slug = name.toLowerCase()
                    .replaceAll("\\s+", "-")
                    .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                    .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                    .replaceAll("[ìíịỉĩ]", "i")
                    .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                    .replaceAll("[ùúụủũưừứựửữ]", "u")
                    .replaceAll("[ỳýỵỷỹ]", "y")
                    .replaceAll("[đ]", "d")
                    .replaceAll("[^a-z0-9-]", "");
            }
            String description = request.getParameter("description");
            String image = request.getParameter("image");
            String parentIdStr = request.getParameter("parentId");
            String displayOrderStr = request.getParameter("displayOrder");
            
            Integer parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : null;
            Integer displayOrder = (displayOrderStr != null && !displayOrderStr.isEmpty()) ? Integer.parseInt(displayOrderStr) : 0;
            
            category.setName(name);
            category.setSlug(slug);
            category.setDescription(description);
            if (image != null && !image.isEmpty()) {
                category.setImage(image);
            }
            category.setParentId(parentId);
            category.setDisplayOrder(displayOrder);
            
            System.out.println("[AdminServlet] Updating category: id=" + id + ", name=" + name + ", displayOrder=" + displayOrder);
            
            boolean success = categoryDAO.update(category);
            result.put("success", success);
            result.put("message", success ? "Cập nhật danh mục thành công" : "Cập nhật danh mục thất bại");
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error updating category: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
    }
    
    private void handleAddCoupon(HttpServletRequest request, Map<String, Object> result) {
        try {
            String code = request.getParameter("code");
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));
            
            String minOrderValueStr = request.getParameter("minOrderValue");
            BigDecimal minOrderValue = (minOrderValueStr != null && !minOrderValueStr.isEmpty()) 
                ? new BigDecimal(minOrderValueStr) : null;
                
            String maxDiscountStr = request.getParameter("maxDiscount");
            BigDecimal maxDiscount = (maxDiscountStr != null && !maxDiscountStr.isEmpty()) 
                ? new BigDecimal(maxDiscountStr) : null;
                
            String usageLimitStr = request.getParameter("usageLimit");
            Integer usageLimit = (usageLimitStr != null && !usageLimitStr.isEmpty()) 
                ? Integer.parseInt(usageLimitStr) : null;
            
            Coupon newCoupon = new Coupon();
            newCoupon.setCode(code);
            newCoupon.setDescription(description);
            newCoupon.setDiscountType(discountType);
            newCoupon.setDiscountValue(discountValue);
            newCoupon.setMinOrderValue(minOrderValue);
            newCoupon.setMaxDiscount(maxDiscount);
            newCoupon.setUsageLimit(usageLimit);
            newCoupon.setActive(true);
            
            boolean success = couponDAO.insert(newCoupon);
            result.put("success", success);
            result.put("message", success ? "Thêm mã giảm giá thành công" : "Thêm mã giảm giá thất bại");
            if (success) {
                result.put("couponId", newCoupon.getId());
            }
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error adding coupon: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
    }
    
    private void handleUpdateCoupon(HttpServletRequest request, Map<String, Object> result) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Coupon coupon = couponDAO.findById(id);
            if (coupon == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy mã giảm giá");
                return;
            }
            
            String code = request.getParameter("code");
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));
            
            String minOrderValueStr = request.getParameter("minOrderValue");
            BigDecimal minOrderValue = (minOrderValueStr != null && !minOrderValueStr.isEmpty()) 
                ? new BigDecimal(minOrderValueStr) : null;
                
            String maxDiscountStr = request.getParameter("maxDiscount");
            BigDecimal maxDiscount = (maxDiscountStr != null && !maxDiscountStr.isEmpty()) 
                ? new BigDecimal(maxDiscountStr) : null;
                
            String usageLimitStr = request.getParameter("usageLimit");
            Integer usageLimit = (usageLimitStr != null && !usageLimitStr.isEmpty()) 
                ? Integer.parseInt(usageLimitStr) : null;
            
            coupon.setCode(code);
            coupon.setDescription(description);
            coupon.setDiscountType(discountType);
            coupon.setDiscountValue(discountValue);
            coupon.setMinOrderValue(minOrderValue);
            coupon.setMaxDiscount(maxDiscount);
            coupon.setUsageLimit(usageLimit);
            
            boolean success = couponDAO.update(coupon);
            result.put("success", success);
            result.put("message", success ? "Cập nhật mã giảm giá thành công" : "Cập nhật mã giảm giá thất bại");
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error updating coupon: " + e.getMessage());
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
    }
    
    private String generateSlug(String name) {
        return name.toLowerCase()
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");
    }

    private void handleApiDelete(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            if (pathInfo.startsWith("/api/product/")) {
                int productId = Integer.parseInt(pathInfo.substring("/api/product/".length()));
                System.out.println("[AdminServlet] Deleting product ID: " + productId);
                boolean success = productDAO.delete(productId);
                System.out.println("[AdminServlet] Delete result: " + success);
                result.put("success", success);
                result.put("message", success ? "Xóa sản phẩm thành công" : "Không thể xóa sản phẩm");
            } else if (pathInfo.startsWith("/api/user/")) {
                int userId = Integer.parseInt(pathInfo.substring("/api/user/".length()));
                boolean success = userDAO.delete(userId);
                result.put("success", success);
                result.put("message", success ? "Xóa người dùng thành công" : "Không thể xóa người dùng");
            } else if (pathInfo.startsWith("/api/category/")) {
                int categoryId = Integer.parseInt(pathInfo.substring("/api/category/".length()));
                boolean success = categoryDAO.delete(categoryId);
                result.put("success", success);
                result.put("message", success ? "Xóa danh mục thành công" : "Không thể xóa danh mục");
            } else if (pathInfo.startsWith("/api/coupon/")) {
                int couponId = Integer.parseInt(pathInfo.substring("/api/coupon/".length()));
                boolean success = couponDAO.delete(couponId);
                result.put("success", success);
                result.put("message", success ? "Xóa mã giảm giá thành công" : "Không thể xóa mã giảm giá");
            } else if (pathInfo.startsWith("/api/contact/")) {
                int contactId = Integer.parseInt(pathInfo.substring("/api/contact/".length()));
                boolean success = contactDAO.delete(contactId);
                result.put("success", success);
                result.put("message", success ? "Xóa liên hệ thành công" : "Không thể xóa liên hệ");
            } else {
                result.put("success", false);
                result.put("message", "API không tồn tại: " + pathInfo);
            }
        } catch (NumberFormatException e) {
            System.err.println("[AdminServlet] Invalid ID format: " + e.getMessage());
            result.put("success", false);
            result.put("message", "ID không hợp lệ");
        } catch (Exception e) {
            System.err.println("[AdminServlet] Error in handleApiDelete: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
        }
        
        String jsonResponse = gson.toJson(result);
        System.out.println("[AdminServlet] Sending response: " + jsonResponse);
        response.getWriter().write(jsonResponse);
    }
}
