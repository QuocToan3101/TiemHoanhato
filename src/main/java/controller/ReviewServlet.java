package controller;

import java.io.IOException;
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

import dao.ReviewDAO;
import model.Review;
import model.User;

@WebServlet("/review/*")
public class ReviewServlet extends HttpServlet {
    
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
            return;
        }
        
        if (pathInfo.startsWith("/product/")) {
            // Lấy reviews của sản phẩm
            handleGetProductReviews(request, response, pathInfo);
        } else if (pathInfo.equals("/stats")) {
            // Lấy thống kê rating
            handleGetRatingStats(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        Map<String, Object> result = new HashMap<>();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
            return;
        }
        
        if (pathInfo.equals("/add")) {
            handleAddReview(request, response, result);
        } else if (pathInfo.equals("/update")) {
            handleUpdateReview(request, response, result);
        } else {
            result.put("success", false);
            result.put("message", "Invalid action");
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        Map<String, Object> result = new HashMap<>();
        
        if (pathInfo != null && pathInfo.matches("/\\d+")) {
            int reviewId = Integer.parseInt(pathInfo.substring(1));
            
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                result.put("success", false);
                result.put("message", "Bạn cần đăng nhập để xóa đánh giá");
            } else {
                Review review = reviewDAO.getReviewById(reviewId);
                
                if (review == null) {
                    result.put("success", false);
                    result.put("message", "Không tìm thấy đánh giá");
                } else if (review.getUserId() != user.getId() && !"admin".equals(user.getRole())) {
                    result.put("success", false);
                    result.put("message", "Bạn không có quyền xóa đánh giá này");
                } else {
                    boolean deleted = reviewDAO.deleteReview(reviewId);
                    if (deleted) {
                        result.put("success", true);
                        result.put("message", "Xóa đánh giá thành công");
                    } else {
                        result.put("success", false);
                        result.put("message", "Xóa đánh giá thất bại");
                    }
                }
            }
        } else {
            result.put("success", false);
            result.put("message", "Invalid review ID");
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    private void handleGetProductReviews(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            String productIdStr = pathInfo.substring("/product/".length());
            int productId = Integer.parseInt(productIdStr);
            
            List<Review> reviews = reviewDAO.getReviewsByProduct(productId);
            
            result.put("success", true);
            result.put("data", reviews);
            result.put("count", reviews.size());
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid product ID");
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    private void handleGetRatingStats(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        String productIdStr = request.getParameter("productId");
        
        if (productIdStr == null || productIdStr.isEmpty()) {
            result.put("success", false);
            result.put("message", "Missing product ID");
        } else {
            try {
                int productId = Integer.parseInt(productIdStr);
                Map<String, Object> stats = reviewDAO.getProductRatingStats(productId);
                
                result.put("success", true);
                result.put("data", stats);
                
            } catch (NumberFormatException e) {
                result.put("success", false);
                result.put("message", "Invalid product ID");
            }
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    private void handleAddReview(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "Bạn cần đăng nhập để đánh giá sản phẩm");
            return;
        }
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            if (rating < 1 || rating > 5) {
                result.put("success", false);
                result.put("message", "Đánh giá phải từ 1 đến 5 sao");
                return;
            }
            
            // Kiểm tra user đã đánh giá chưa
            if (reviewDAO.hasUserReviewed(productId, user.getId())) {
                result.put("success", false);
                result.put("message", "Bạn đã đánh giá sản phẩm này rồi");
                return;
            }
            
            Review review = new Review(productId, user.getId(), rating, comment);
            review.setStatus("approved"); // Auto-approve, có thể đổi thành "pending" nếu cần duyệt
            
            boolean added = reviewDAO.addReview(review);
            
            if (added) {
                result.put("success", true);
                result.put("message", "Cảm ơn bạn đã đánh giá sản phẩm!");
                result.put("data", review);
            } else {
                result.put("success", false);
                result.put("message", "Không thể thêm đánh giá. Vui lòng thử lại.");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
    }
    
    private void handleUpdateReview(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "Bạn cần đăng nhập để cập nhật đánh giá");
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            Review review = reviewDAO.getReviewById(reviewId);
            
            if (review == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy đánh giá");
                return;
            }
            
            if (review.getUserId() != user.getId()) {
                result.put("success", false);
                result.put("message", "Bạn không có quyền sửa đánh giá này");
                return;
            }
            
            review.setRating(rating);
            review.setComment(comment);
            
            boolean updated = reviewDAO.updateReview(review);
            
            if (updated) {
                result.put("success", true);
                result.put("message", "Cập nhật đánh giá thành công");
                result.put("data", review);
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật đánh giá");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
    }
}
