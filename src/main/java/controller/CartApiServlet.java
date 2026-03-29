package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.CartDAO;
import model.CartItem;
import model.User;

/**
 * API Servlet để quản lý giỏ hàng
 */
@WebServlet("/api/cart/*")
public class CartApiServlet extends HttpServlet {
    
    private CartDAO cartDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        gson = new Gson();
    }
    
    /**
     * GET - Lấy thông tin giỏ hàng
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Chưa đăng nhập");
            jsonResponse.addProperty("itemCount", 0);
            out.print(gson.toJson(jsonResponse));
            return;
        }
        
        User user = (User) session.getAttribute("user");
        List<CartItem> cartItems = cartDAO.findByUserId(user.getId());
        
        BigDecimal total = BigDecimal.ZERO;
        int itemCount = 0;
        
        for (CartItem item : cartItems) {
            total = total.add(item.getSubtotal());
            itemCount += item.getQuantity();
        }
        
        jsonResponse.addProperty("success", true);
        jsonResponse.addProperty("itemCount", itemCount);
        jsonResponse.addProperty("total", total.toString());
        jsonResponse.add("items", gson.toJsonTree(cartItems));
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * POST - Thêm sản phẩm vào giỏ hàng
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng đăng nhập để thêm vào giỏ hàng");
            out.print(gson.toJson(jsonResponse));
            return;
        }
        
        try {
            User user = (User) session.getAttribute("user");
            
            // Kiểm tra xem có phải là path /add hay không
            String pathInfo = request.getPathInfo();
            
            int productId;
            int quantity;
            
            // Đọc dữ liệu từ JSON body
            if (pathInfo != null && pathInfo.equals("/add")) {
                // Đọc JSON từ body
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = request.getReader().readLine()) != null) {
                    sb.append(line);
                }
                
                String jsonString = sb.toString();
                System.out.println("Received JSON: " + jsonString);
                
                JsonObject jsonRequest = gson.fromJson(jsonString, JsonObject.class);
                if (jsonRequest == null || !jsonRequest.has("productId")) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Thiếu productId");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                try {
                    productId = jsonRequest.get("productId").getAsInt();
                    quantity = jsonRequest.has("quantity") ? jsonRequest.get("quantity").getAsInt() : 1;
                } catch (Exception ex) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Tham số không hợp lệ");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
            } else {
                // Đọc từ parameters (backward compatibility)
                try {
                    productId = Integer.parseInt(request.getParameter("productId"));
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                } catch (NumberFormatException ex) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Tham số không hợp lệ");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
            }
            
            if (quantity <= 0) {
                quantity = 1;
            }
            
            boolean success = cartDAO.addToCart(user.getId(), productId, quantity);
            
            if (success) {
                int cartCount = cartDAO.getTotalQuantity(user.getId());
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đã thêm vào giỏ hàng");
                jsonResponse.addProperty("cartItemCount", cartCount);
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể thêm vào giỏ hàng");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * PUT - Cập nhật số lượng sản phẩm
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Chưa đăng nhập");
            out.print(gson.toJson(jsonResponse));
            return;
        }
        
        try {
            User user = (User) session.getAttribute("user");
            int productId;
            int quantity;
            try {
                productId = Integer.parseInt(request.getParameter("productId"));
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException ex) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Tham số không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            boolean success;
            if (quantity <= 0) {
                success = cartDAO.removeFromCart(user.getId(), productId);
            } else {
                success = cartDAO.updateQuantity(user.getId(), productId, quantity);
            }
            
            if (success) {
                // Lấy thông tin giỏ hàng mới
                List<CartItem> cartItems = cartDAO.findByUserId(user.getId());
                BigDecimal total = BigDecimal.ZERO;
                int itemCount = 0;
                
                for (CartItem item : cartItems) {
                    total = total.add(item.getSubtotal());
                    itemCount += item.getQuantity();
                }
                
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đã cập nhật giỏ hàng");
                jsonResponse.addProperty("cartCount", itemCount);
                jsonResponse.addProperty("total", total.toString());
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể cập nhật giỏ hàng");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * DELETE - Xóa sản phẩm khỏi giỏ hàng
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Chưa đăng nhập");
            out.print(gson.toJson(jsonResponse));
            return;
        }
        
        try {
            User user = (User) session.getAttribute("user");
            String pathInfo = request.getPathInfo();
            
            if (pathInfo != null && pathInfo.equals("/clear")) {
                // Xóa toàn bộ giỏ hàng
                boolean success = cartDAO.clearCart(user.getId());
                jsonResponse.addProperty("success", success);
                jsonResponse.addProperty("message", success ? "Đã xóa giỏ hàng" : "Không thể xóa giỏ hàng");
            } else {
                // Xóa một sản phẩm
                int productId;
                try {
                    productId = Integer.parseInt(request.getParameter("productId"));
                } catch (NumberFormatException ex) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Tham số không hợp lệ");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                boolean success = cartDAO.removeFromCart(user.getId(), productId);
                
                if (success) {
                    int cartCount = cartDAO.getTotalQuantity(user.getId());
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Đã xóa khỏi giỏ hàng");
                    jsonResponse.addProperty("cartCount", cartCount);
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không thể xóa khỏi giỏ hàng");
                }
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
}
