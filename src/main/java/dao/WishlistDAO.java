package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Product;
import model.Wishlist;
import util.DBConnection;

/**
 * DAO để quản lý wishlist trong database
 */
public class WishlistDAO {
    
    /**
     * Thêm sản phẩm vào wishlist
     */
    public boolean add(int userId, int productId) {
        String sql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            return false;
        }
    }
    
    /**
     * Xóa sản phẩm khỏi wishlist
     */
    public boolean remove(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            return false;
        }
    }
    
    /**
     * Kiểm tra xem sản phẩm có trong wishlist hay không
     */
    public boolean isInWishlist(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
        }
        
        return false;
    }
    
    /**
     * Lấy tất cả wishlist của user (không join product)
     */
    public List<Wishlist> getByUserId(int userId) {
        List<Wishlist> wishlist = new ArrayList<>();
        String sql = "SELECT * FROM wishlist WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Wishlist item = new Wishlist();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                wishlist.add(item);
            }
            
        } catch (SQLException e) {
        }
        
        return wishlist;
    }
    
    /**
     * Lấy wishlist của user cùng với thông tin product (join)
     */
    public List<Wishlist> getByUserIdWithProducts(int userId) {
        List<Wishlist> wishlist = new ArrayList<>();
        String sql = "SELECT w.*, p.id as product_id, p.name, p.slug, p.price, p.sale_price, " +
                     "p.image, p.quantity, p.is_active, p.average_rating, p.review_count " +
                     "FROM wishlist w " +
                     "INNER JOIN products p ON w.product_id = p.id " +
                     "WHERE w.user_id = ? AND p.is_active = 1 " +
                     "ORDER BY w.created_at DESC";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Wishlist item = new Wishlist();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Tạo Product object
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setSlug(rs.getString("slug"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setSalePrice(rs.getBigDecimal("sale_price"));
                product.setImage(rs.getString("image"));
                product.setQuantity(rs.getInt("quantity"));
                product.setActive(rs.getBoolean("is_active"));
                product.setAverageRating(rs.getBigDecimal("average_rating"));
                product.setReviewCount(rs.getInt("review_count"));
                
                item.setProduct(product);
                wishlist.add(item);
            }
            
        } catch (SQLException e) {
        }
        
        return wishlist;
    }
    
    /**
     * Đếm số lượng sản phẩm trong wishlist của user
     */
    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
        }
        
        return 0;
    }
    
    /**
     * Xóa tất cả wishlist của user
     */
    public boolean clearByUserId(int userId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            return false;
        }
    }
    
    /**
     * Lấy danh sách product IDs trong wishlist của user
     */
    public List<Integer> getProductIdsByUserId(int userId) {
        List<Integer> productIds = new ArrayList<>();
        String sql = "SELECT product_id FROM wishlist WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                productIds.add(rs.getInt("product_id"));
            }
            
        } catch (SQLException e) {
        }
        
        return productIds;
    }
}
