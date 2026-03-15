package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Coupon;
import util.DBConnection;

/**
 * DAO để thao tác với bảng coupons
 */
public class CouponDAO {
    
    private Connection getConnection() {
        return DBConnection.getInstance().getConnection();
    }
    
    /**
     * Lấy tất cả coupon
     */
    public List<Coupon> findAll() {
        List<Coupon> coupons = new ArrayList<>();
        String sql = "SELECT * FROM coupons ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                coupons.add(mapResultSetToCoupon(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy danh sách coupons: " + e.getMessage());
        }
        return coupons;
    }
    
    /**
     * Lấy coupon đang active
     */
    public List<Coupon> findActive() {
        List<Coupon> coupons = new ArrayList<>();
        String sql = "SELECT * FROM coupons WHERE is_active = TRUE " +
                    "AND (start_date IS NULL OR start_date <= NOW()) " +
                    "AND (end_date IS NULL OR end_date >= NOW()) " +
                    "ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                coupons.add(mapResultSetToCoupon(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy active coupons: " + e.getMessage());
        }
        return coupons;
    }
    
    /**
     * Tìm coupon theo code
     */
    public Coupon findByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCoupon(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tìm coupon theo code: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Tìm coupon theo ID
     */
    public Coupon findById(int id) {
        String sql = "SELECT * FROM coupons WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCoupon(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tìm coupon theo ID: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Thêm coupon mới
     */
    public boolean insert(Coupon coupon) {
        String sql = "INSERT INTO coupons (code, description, discount_type, discount_value, " +
                    "min_order_value, max_discount, usage_limit, start_date, end_date, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, coupon.getCode());
            ps.setString(2, coupon.getDescription());
            ps.setString(3, coupon.getDiscountType());
            ps.setBigDecimal(4, coupon.getDiscountValue());
            
            if (coupon.getMinOrderValue() != null) {
                ps.setBigDecimal(5, coupon.getMinOrderValue());
            } else {
                ps.setNull(5, Types.DECIMAL);
            }
            
            if (coupon.getMaxDiscount() != null) {
                ps.setBigDecimal(6, coupon.getMaxDiscount());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            
            if (coupon.getUsageLimit() != null) {
                ps.setInt(7, coupon.getUsageLimit());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            
            if (coupon.getStartDate() != null) {
                ps.setTimestamp(8, coupon.getStartDate());
            } else {
                ps.setNull(8, Types.TIMESTAMP);
            }
            
            if (coupon.getEndDate() != null) {
                ps.setTimestamp(9, coupon.getEndDate());
            } else {
                ps.setNull(9, Types.TIMESTAMP);
            }
            
            ps.setBoolean(10, coupon.isActive());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    coupon.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi thêm coupon: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Cập nhật coupon
     */
    public boolean update(Coupon coupon) {
        String sql = "UPDATE coupons SET code = ?, description = ?, discount_type = ?, " +
                    "discount_value = ?, min_order_value = ?, max_discount = ?, usage_limit = ?, " +
                    "start_date = ?, end_date = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, coupon.getCode());
            ps.setString(2, coupon.getDescription());
            ps.setString(3, coupon.getDiscountType());
            ps.setBigDecimal(4, coupon.getDiscountValue());
            
            if (coupon.getMinOrderValue() != null) {
                ps.setBigDecimal(5, coupon.getMinOrderValue());
            } else {
                ps.setNull(5, Types.DECIMAL);
            }
            
            if (coupon.getMaxDiscount() != null) {
                ps.setBigDecimal(6, coupon.getMaxDiscount());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            
            if (coupon.getUsageLimit() != null) {
                ps.setInt(7, coupon.getUsageLimit());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            
            if (coupon.getStartDate() != null) {
                ps.setTimestamp(8, coupon.getStartDate());
            } else {
                ps.setNull(8, Types.TIMESTAMP);
            }
            
            if (coupon.getEndDate() != null) {
                ps.setTimestamp(9, coupon.getEndDate());
            } else {
                ps.setNull(9, Types.TIMESTAMP);
            }
            
            ps.setBoolean(10, coupon.isActive());
            ps.setInt(11, coupon.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật coupon: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Xóa coupon
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM coupons WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi xóa coupon: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Toggle active status
     */
    public boolean toggleActive(int id) {
        String sql = "UPDATE coupons SET is_active = NOT is_active, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi toggle active coupon: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Tăng số lần sử dụng
     */
    public boolean incrementUsedCount(int id) {
        String sql = "UPDATE coupons SET used_count = used_count + 1, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi increment used count: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Validate coupon
     */
    public boolean validateCoupon(String code, BigDecimal orderTotal) {
        Coupon coupon = findByCode(code);
        if (coupon == null) return false;
        
        return coupon.isValid() && 
               (coupon.getMinOrderValue() == null || 
                orderTotal.compareTo(coupon.getMinOrderValue()) >= 0);
    }
    
    /**
     * Map ResultSet sang Coupon
     */
    private Coupon mapResultSetToCoupon(ResultSet rs) throws SQLException {
        Coupon coupon = new Coupon();
        coupon.setId(rs.getInt("id"));
        coupon.setCode(rs.getString("code"));
        coupon.setDescription(rs.getString("description"));
        coupon.setDiscountType(rs.getString("discount_type"));
        coupon.setDiscountValue(rs.getBigDecimal("discount_value"));
        coupon.setMinOrderValue(rs.getBigDecimal("min_order_value"));
        coupon.setMaxDiscount(rs.getBigDecimal("max_discount"));
        
        int usageLimit = rs.getInt("usage_limit");
        coupon.setUsageLimit(rs.wasNull() ? null : usageLimit);
        
        coupon.setUsedCount(rs.getInt("used_count"));
        coupon.setStartDate(rs.getTimestamp("start_date"));
        coupon.setEndDate(rs.getTimestamp("end_date"));
        coupon.setActive(rs.getBoolean("is_active"));
        coupon.setCreatedAt(rs.getTimestamp("created_at"));
        coupon.setUpdatedAt(rs.getTimestamp("updated_at"));
        return coupon;
    }
    
    /**
     * Đếm tổng số coupon
     */
    public int getTotalCoupons() {
        String sql = "SELECT COUNT(*) FROM coupons";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm coupons: " + e.getMessage());
        }
        return 0;
    }
}
