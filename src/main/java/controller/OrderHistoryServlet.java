package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.OrderDAO;
import model.Order;
import model.User;

/**
 * Servlet xử lý trang lịch sử đơn hàng
 */
@WebServlet(urlPatterns = {"/orders", "/don-hang", "/orders/*", "/api/orders/list"})
public class OrderHistoryServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=orders");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        
        // API: Trả về danh sách đơn hàng JSON
        if ("/api/orders/list".equals(servletPath)) {
            getOrdersList(request, response, user);
            return;
        }
        
        // Check if API request for order detail
        if (pathInfo != null && pathInfo.startsWith("/detail/")) {
            getOrderDetail(request, response, user);
            return;
        }
        
        // Check if API request for cancel
        if (pathInfo != null && pathInfo.startsWith("/cancel/")) {
            // This should be POST, but handle GET for simplicity
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        
        // Load orders list page
        List<Order> orders = orderDAO.findByUserId(user.getId());
        
        request.setAttribute("orders", orders);
        request.setAttribute("pageTitle", "Đơn hàng của tôi");
        
        request.getRequestDispatcher("/view/purchaseHistory.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            sendJsonError(response, "Vui lòng đăng nhập");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/cancel/")) {
            cancelOrder(request, response, user);
        } else if (pathInfo != null && pathInfo.startsWith("/reorder/")) {
            reorder(request, response, user);
        } else {
            sendJsonError(response, "Invalid action");
        }
    }
    
    /**
     * Lấy danh sách đơn hàng (JSON API)
     */
    private void getOrdersList(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            List<Order> orders = orderDAO.findByUserId(user.getId());
            
            jsonResponse.addProperty("success", true);
            jsonResponse.add("orders", gson.toJsonTree(orders));
            jsonResponse.addProperty("count", orders.size());
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi khi tải danh sách đơn hàng: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Lấy chi tiết đơn hàng
     */
    private void getOrderDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String pathInfo = request.getPathInfo();
            int orderId = Integer.parseInt(pathInfo.substring("/detail/".length()));
            
            Order order = orderDAO.findById(orderId);
            
            if (order == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy đơn hàng");
            } else if (!order.getUserId().equals(user.getId())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn không có quyền xem đơn hàng này");
            } else {
                jsonResponse.addProperty("success", true);
                jsonResponse.add("order", gson.toJsonTree(order));
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID đơn hàng không hợp lệ");
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Hủy đơn hàng
     */
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String pathInfo = request.getPathInfo();
            int orderId = Integer.parseInt(pathInfo.substring("/cancel/".length()));
            
            Order order = orderDAO.findById(orderId);
            
            if (order == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy đơn hàng");
            } else if (!order.getUserId().equals(user.getId())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn không có quyền hủy đơn hàng này");
            } else if (!"pending".equals(order.getOrderStatus())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Chỉ có thể hủy đơn hàng đang chờ xác nhận");
            } else {
                // Update order status
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "Khách hàng hủy đơn";
                }
                boolean success = orderDAO.cancelOrder(orderId, reason);
                
                if (success) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Đã hủy đơn hàng thành công");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không thể hủy đơn hàng");
                }
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID đơn hàng không hợp lệ");
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Mua lại đơn hàng
     */
    private void reorder(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String pathInfo = request.getPathInfo();
            int orderId = Integer.parseInt(pathInfo.substring("/reorder/".length()));
            
            Order order = orderDAO.findById(orderId);
            
            if (order == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy đơn hàng");
            } else if (!order.getUserId().equals(user.getId())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn không có quyền thao tác đơn hàng này");
            } else {
                // Add items to cart
                dao.CartDAO cartDAO = new dao.CartDAO();
                int addedCount = 0;
                
                for (model.OrderItem item : order.getOrderItems()) {
                    if (item.getProductId() != null) {
                        cartDAO.addToCart(user.getId(), item.getProductId(), item.getQuantity());
                        addedCount++;
                    }
                }
                
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đã thêm " + addedCount + " sản phẩm vào giỏ hàng");
                jsonResponse.addProperty("cartCount", cartDAO.countItems(user.getId()));
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID đơn hàng không hợp lệ");
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();
        json.addProperty("success", false);
        json.addProperty("message", message);
        out.print(gson.toJson(json));
    }
}
