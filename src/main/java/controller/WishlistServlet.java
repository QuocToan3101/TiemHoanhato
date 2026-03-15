package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
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

import dao.WishlistDAO;
import model.User;
import model.Wishlist;

/**
 * Servlet để xử lý các yêu cầu liên quan đến wishlist
 */
@WebServlet("/api/wishlist/*")
public class WishlistServlet extends HttpServlet {
    
    private WishlistDAO wishlistDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        wishlistDAO = new WishlistDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập để sử dụng wishlist");
            out.print(gson.toJson(result));
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/wishlist - Lấy danh sách wishlist
                handleGetWishlist(user.getId(), out);
            } else if (pathInfo.equals("/count")) {
                // GET /api/wishlist/count - Đếm số lượng
                handleGetCount(user.getId(), out);
            } else if (pathInfo.equals("/check")) {
                // GET /api/wishlist/check?productId=123 - Kiểm tra sản phẩm có trong wishlist
                int productId = Integer.parseInt(request.getParameter("productId"));
                handleCheckWishlist(user.getId(), productId, out);
            } else if (pathInfo.equals("/product-ids")) {
                // GET /api/wishlist/product-ids - Lấy danh sách product IDs
                handleGetProductIds(user.getId(), out);
            } else {
                sendError(out, "Endpoint không hợp lệ");
            }
        } catch (Exception e) {
            sendError(out, "Lỗi server: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập để sử dụng wishlist");
            out.print(gson.toJson(result));
            return;
        }
        
        try {
            // Đọc JSON từ request body
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            @SuppressWarnings("unchecked")
            Map<String, Object> jsonData = gson.fromJson(sb.toString(), Map.class);
            String action = (String) jsonData.get("action");
            
            if (action == null) {
                sendError(out, "Thiếu tham số action");
                return;
            }
            
            switch (action) {
                case "add":
                    handleAddToWishlist(user.getId(), jsonData, out);
                    break;
                case "remove":
                    handleRemoveFromWishlist(user.getId(), jsonData, out);
                    break;
                case "toggle":
                    handleToggleWishlist(user.getId(), jsonData, out);
                    break;
                case "clear":
                    handleClearWishlist(user.getId(), out);
                    break;
                default:
                    sendError(out, "Action không hợp lệ: " + action);
            }
            
        } catch (Exception e) {
            sendError(out, "Lỗi server: " + e.getMessage());
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            sendError(out, "Vui lòng đăng nhập");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                // DELETE /api/wishlist/123 - Xóa theo product ID
                int productId = Integer.parseInt(pathInfo.substring(1));
                handleRemoveById(user.getId(), productId, out);
            } else {
                sendError(out, "ID sản phẩm không hợp lệ");
            }
        } catch (Exception e) {
            sendError(out, "Lỗi server: " + e.getMessage());
        }
    }
    
    // ===== Handler Methods =====
    
    private void handleGetWishlist(int userId, PrintWriter out) {
        List<Wishlist> wishlist = wishlistDAO.getByUserIdWithProducts(userId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", wishlist);
        result.put("count", wishlist.size());
        
        out.print(gson.toJson(result));
    }
    
    private void handleGetCount(int userId, PrintWriter out) {
        int count = wishlistDAO.countByUserId(userId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("count", count);
        
        out.print(gson.toJson(result));
    }
    
    private void handleCheckWishlist(int userId, int productId, PrintWriter out) {
        boolean inWishlist = wishlistDAO.isInWishlist(userId, productId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("inWishlist", inWishlist);
        
        out.print(gson.toJson(result));
    }
    
    private void handleGetProductIds(int userId, PrintWriter out) {
        List<Integer> productIds = wishlistDAO.getProductIdsByUserId(userId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("productIds", productIds);
        
        out.print(gson.toJson(result));
    }
    
    private void handleAddToWishlist(int userId, Map<String, Object> data, PrintWriter out) {
        Double productIdDouble = (Double) data.get("productId");
        if (productIdDouble == null) {
            sendError(out, "Thiếu productId");
            return;
        }
        
        int productId = productIdDouble.intValue();
        
        // Kiểm tra xem đã có trong wishlist chưa
        if (wishlistDAO.isInWishlist(userId, productId)) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Sản phẩm đã có trong wishlist");
            result.put("inWishlist", true);
            out.print(gson.toJson(result));
            return;
        }
        
        boolean success = wishlistDAO.add(userId, productId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", success ? "Đã thêm vào wishlist" : "Không thể thêm vào wishlist");
        result.put("inWishlist", success);
        result.put("count", wishlistDAO.countByUserId(userId));
        
        out.print(gson.toJson(result));
    }
    
    private void handleRemoveFromWishlist(int userId, Map<String, Object> data, PrintWriter out) {
        Double productIdDouble = (Double) data.get("productId");
        if (productIdDouble == null) {
            sendError(out, "Thiếu productId");
            return;
        }
        
        int productId = productIdDouble.intValue();
        boolean success = wishlistDAO.remove(userId, productId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", success ? "Đã xóa khỏi wishlist" : "Không thể xóa khỏi wishlist");
        result.put("inWishlist", false);
        result.put("count", wishlistDAO.countByUserId(userId));
        
        out.print(gson.toJson(result));
    }
    
    private void handleToggleWishlist(int userId, Map<String, Object> data, PrintWriter out) {
        Double productIdDouble = (Double) data.get("productId");
        if (productIdDouble == null) {
            sendError(out, "Thiếu productId");
            return;
        }
        
        int productId = productIdDouble.intValue();
        boolean isInWishlist = wishlistDAO.isInWishlist(userId, productId);
        boolean success;
        String message;
        
        if (isInWishlist) {
            success = wishlistDAO.remove(userId, productId);
            message = success ? "Đã xóa khỏi wishlist" : "Không thể xóa";
        } else {
            success = wishlistDAO.add(userId, productId);
            message = success ? "Đã thêm vào wishlist" : "Không thể thêm";
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", message);
        result.put("inWishlist", !isInWishlist && success);
        result.put("count", wishlistDAO.countByUserId(userId));
        
        out.print(gson.toJson(result));
    }
    
    private void handleClearWishlist(int userId, PrintWriter out) {
        boolean success = wishlistDAO.clearByUserId(userId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", success ? "Đã xóa tất cả wishlist" : "Không thể xóa wishlist");
        result.put("count", 0);
        
        out.print(gson.toJson(result));
    }
    
    private void handleRemoveById(int userId, int productId, PrintWriter out) {
        boolean success = wishlistDAO.remove(userId, productId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", success ? "Đã xóa khỏi wishlist" : "Không thể xóa");
        result.put("count", wishlistDAO.countByUserId(userId));
        
        out.print(gson.toJson(result));
    }
    
    private void sendError(PrintWriter out, String message) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);
        out.print(gson.toJson(result));
    }
}
