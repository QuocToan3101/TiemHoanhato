package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.Review;
import util.DBConnection;

public class ReviewDAO {
    
    private Connection getConnection() throws SQLException {
        return DBConnection.getInstance().getConnection();
    }
    
    /**
     * Thêm đánh giá mới
     */
    public boolean addReview(Review review) {
        String sql = "INSERT INTO product_reviews (product_id, user_id, rating, comment, status) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, review.getProductId());
            pstmt.setInt(2, review.getUserId());
            pstmt.setInt(3, review.getRating());
            pstmt.setString(4, review.getComment());
            pstmt.setString(5, review.getStatus() != null ? review.getStatus() : "approved");
            
            int affected = pstmt.executeUpdate();
            
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    review.setId(rs.getInt(1));
                }
                
                // Cập nhật average_rating cho sản phẩm
                updateProductRating(review.getProductId());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error adding review: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Lấy tất cả đánh giá của một sản phẩm
     */
    public List<Review> getReviewsByProduct(int productId) {
        return getReviewsByProduct(productId, "approved");
    }
    
    /**
     * Lấy đánh giá theo sản phẩm và trạng thái
     */
    public List<Review> getReviewsByProduct(int productId, String status) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.fullname as user_name, u.email as user_email " +
                     "FROM product_reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.product_id = ? ";
        
        if (status != null && !status.isEmpty()) {
            sql += "AND r.status = ? ";
        }
        
        sql += "ORDER BY r.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            if (status != null && !status.isEmpty()) {
                pstmt.setString(2, status);
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting reviews: " + e.getMessage());
        }
        
        return reviews;
    }
    
    /**
     * Lấy đánh giá theo ID
     */
    public Review getReviewById(int id) {
        String sql = "SELECT r.*, u.fullname as user_name, u.email as user_email, p.name as product_name " +
                     "FROM product_reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN products p ON r.product_id = p.id " +
                     "WHERE r.id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToReview(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting review by id: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Kiểm tra user đã đánh giá sản phẩm chưa
     */
    public boolean hasUserReviewed(int productId, int userId) {
        String sql = "SELECT COUNT(*) FROM product_reviews WHERE product_id = ? AND user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            pstmt.setInt(2, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking user review: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Cập nhật đánh giá
     */
    public boolean updateReview(Review review) {
        String sql = "UPDATE product_reviews SET rating = ?, comment = ?, status = ? " +
                     "WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, review.getRating());
            pstmt.setString(2, review.getComment());
            pstmt.setString(3, review.getStatus());
            pstmt.setInt(4, review.getId());
            
            int affected = pstmt.executeUpdate();
            
            if (affected > 0) {
                updateProductRating(review.getProductId());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error updating review: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Xóa đánh giá
     */
    public boolean deleteReview(int id) {
        Review review = getReviewById(id);
        if (review == null) return false;
        
        String sql = "DELETE FROM product_reviews WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            int affected = pstmt.executeUpdate();
            
            if (affected > 0) {
                updateProductRating(review.getProductId());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error deleting review: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Lấy thống kê rating của sản phẩm
     */
    public Map<String, Object> getProductRatingStats(int productId) {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = "SELECT " +
                     "COUNT(*) as total_reviews, " +
                     "AVG(rating) as average_rating, " +
                     "SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as five_star, " +
                     "SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as four_star, " +
                     "SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as three_star, " +
                     "SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as two_star, " +
                     "SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as one_star " +
                     "FROM product_reviews " +
                     "WHERE product_id = ? AND status = 'approved'";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                stats.put("totalReviews", rs.getInt("total_reviews"));
                stats.put("averageRating", rs.getBigDecimal("average_rating"));
                stats.put("fiveStar", rs.getInt("five_star"));
                stats.put("fourStar", rs.getInt("four_star"));
                stats.put("threeStar", rs.getInt("three_star"));
                stats.put("twoStar", rs.getInt("two_star"));
                stats.put("oneStar", rs.getInt("one_star"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting rating stats: " + e.getMessage());
        }
        
        return stats;
    }
    
    /**
     * Cập nhật average_rating và review_count trong bảng products
     */
    private void updateProductRating(int productId) {
        String sql = "UPDATE products SET " +
                     "average_rating = (SELECT COALESCE(AVG(rating), 0) FROM product_reviews " +
                     "                  WHERE product_id = ? AND status = 'approved'), " +
                     "review_count = (SELECT COUNT(*) FROM product_reviews " +
                     "                WHERE product_id = ? AND status = 'approved') " +
                     "WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, productId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("Error updating product rating: " + e.getMessage());
        }
    }
    
    /**
     * Lấy tất cả đánh giá (admin)
     */
    public List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.fullname as user_name, u.email as user_email, p.name as product_name " +
                     "FROM product_reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN products p ON r.product_id = p.id " +
                     "ORDER BY r.created_at DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all reviews: " + e.getMessage());
        }
        
        return reviews;
    }
    
    /**
     * Thay đổi trạng thái đánh giá
     */
    public boolean updateReviewStatus(int id, String status) {
        String sql = "UPDATE product_reviews SET status = ? WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            
            int affected = pstmt.executeUpdate();
            
            if (affected > 0) {
                Review review = getReviewById(id);
                if (review != null) {
                    updateProductRating(review.getProductId());
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error updating review status: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Map ResultSet to Review object
     */
    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getInt("id"));
        review.setProductId(rs.getInt("product_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        review.setUpdatedAt(rs.getTimestamp("updated_at"));
        review.setStatus(rs.getString("status"));
        
        // Thông tin bổ sung
        try {
            review.setUserName(rs.getString("user_name"));
            review.setUserEmail(rs.getString("user_email"));
        } catch (SQLException e) {
            // Columns không tồn tại
        }
        
        try {
            review.setProductName(rs.getString("product_name"));
        } catch (SQLException e) {
            // Column không tồn tại
        }
        
        return review;
    }
}
