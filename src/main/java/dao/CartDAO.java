package dao;

import model.CartItem;
import model.Product;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO để thao tác với bảng cart
 */
public class CartDAO {
    
    private Connection getConnection() {
        return DBConnection.getInstance().getConnection();
    }
    
    /**
     * Lấy giỏ hàng của user
     */
    public List<CartItem> findByUserId(int userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT c.*, p.name as product_name, p.slug, p.price, p.sale_price, " +
                    "p.image, p.quantity as product_quantity " +
                    "FROM cart c " +
                    "JOIN products p ON c.product_id = p.id " +
                    "WHERE c.user_id = ? AND p.is_active = TRUE " +
                    "ORDER BY c.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CartItem item = mapResultSetToCartItem(rs);
                
                // Map product info
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("product_name"));
                product.setSlug(rs.getString("slug"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setSalePrice(rs.getBigDecimal("sale_price"));
                product.setImage(rs.getString("image"));
                product.setQuantity(rs.getInt("product_quantity"));
                item.setProduct(product);
                
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy cart: " + e.getMessage());
        }
        return items;
    }
    
    /**
     * Thêm sản phẩm vào giỏ hàng
     */
    public boolean addToCart(int userId, int productId, int quantity) {
        // Kiểm tra sản phẩm đã có trong giỏ chưa
        CartItem existing = findByUserAndProduct(userId, productId);
        
        if (existing != null) {
            // Cập nhật số lượng
            return updateQuantity(userId, productId, existing.getQuantity() + quantity);
        }
        
        // Thêm mới
        String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi thêm vào cart: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Cập nhật số lượng sản phẩm trong giỏ
     */
    public boolean updateQuantity(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return removeFromCart(userId, productId);
        }
        
        String sql = "UPDATE cart SET quantity = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật cart: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    public boolean removeFromCart(int userId, int productId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi xóa khỏi cart: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Xóa toàn bộ giỏ hàng của user
     */
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            System.err.println("Lỗi xóa cart: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Tìm cart item theo user và product
     */
    public CartItem findByUserAndProduct(int userId, int productId) {
        String sql = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCartItem(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tìm cart item: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Đếm số sản phẩm trong giỏ hàng
     */
    public int countItems(int userId) {
        String sql = "SELECT COUNT(*) FROM cart WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm cart items: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Tính tổng số lượng sản phẩm (quantity) trong giỏ
     */
    public int getTotalQuantity(int userId) {
        String sql = "SELECT SUM(quantity) FROM cart WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tính tổng quantity: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Map ResultSet sang CartItem
     */
    private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setId(rs.getInt("id"));
        item.setUserId(rs.getInt("user_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setUpdatedAt(rs.getTimestamp("updated_at"));
        return item;
    }
}
