package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Address;
import util.DBConnection;

/**
 * Data Access Object cho bảng addresses
 */
public class AddressDAO {
    
    private DBConnection dbConnection;
    
    public AddressDAO() {
        dbConnection = DBConnection.getInstance();
    }
    
    private void logSQLError(String operation, SQLException e) {
        System.err.println("[AddressDAO] Lỗi " + operation + ": " + e.getMessage());
        System.err.println("SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
    }
    
    /**
     * Lấy tất cả địa chỉ của user
     */
    public List<Address> findByUserId(int userId) {
        List<Address> addresses = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, created_at DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                addresses.add(mapResultSetToAddress(rs));
            }
        } catch (SQLException e) {
            logSQLError("lấy danh sách địa chỉ", e);
        }
        return addresses;
    }
    
    /**
     * Lấy địa chỉ theo ID
     */
    public Address findById(int id) {
        String sql = "SELECT * FROM addresses WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAddress(rs);
            }
        } catch (SQLException e) {
        }
        return null;
    }
    
    /**
     * Lấy địa chỉ mặc định của user
     */
    public Address findDefaultByUserId(int userId) {
        String sql = "SELECT * FROM addresses WHERE user_id = ? AND is_default = TRUE LIMIT 1";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAddress(rs);
            }
        } catch (SQLException e) {
        }
        return null;
    }
    
    /**
     * Thêm địa chỉ mới
     */
    public int add(Address address) {
        String sql = "INSERT INTO addresses (user_id, receiver_name, phone, province, district, ward, address_detail, note, is_default) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Nếu là địa chỉ mặc định, bỏ mặc định của các địa chỉ khác
            if (address.isDefault()) {
                clearDefaultAddresses(conn, address.getUserId());
            }
            
            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getReceiverName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getProvince());
            ps.setString(5, address.getDistrict());
            ps.setString(6, address.getWard());
            ps.setString(7, address.getAddressDetail());
            ps.setString(8, address.getNote());
            ps.setBoolean(9, address.isDefault());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            logSQLError("thêm địa chỉ", e);
        }
        return -1;
    }
    
    /**
     * Cập nhật địa chỉ
     */
    public boolean update(Address address) {
        String sql = "UPDATE addresses SET receiver_name = ?, phone = ?, province = ?, district = ?, " +
                     "ward = ?, address_detail = ?, note = ?, is_default = ? WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Nếu là địa chỉ mặc định, bỏ mặc định của các địa chỉ khác
            if (address.isDefault()) {
                clearDefaultAddresses(conn, address.getUserId());
            }
            
            ps.setString(1, address.getReceiverName());
            ps.setString(2, address.getPhone());
            ps.setString(3, address.getProvince());
            ps.setString(4, address.getDistrict());
            ps.setString(5, address.getWard());
            ps.setString(6, address.getAddressDetail());
            ps.setString(7, address.getNote());
            ps.setBoolean(8, address.isDefault());
            ps.setInt(9, address.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }
    
    /**
     * Xóa địa chỉ
     */
    public boolean delete(int id, int userId) {
        String sql = "DELETE FROM addresses WHERE id = ? AND user_id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }
    
    /**
     * Đặt địa chỉ mặc định
     */
    public boolean setDefault(int addressId, int userId) {
        try (Connection conn = dbConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                // Bỏ mặc định của tất cả địa chỉ
                clearDefaultAddresses(conn, userId);
                
                // Đặt địa chỉ này làm mặc định
                String sql = "UPDATE addresses SET is_default = TRUE WHERE id = ? AND user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, addressId);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            logSQLError("đặt địa chỉ mặc định", e);
        }
        return false;
    }
    
    /**
     * Đếm số địa chỉ của user
     */
    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM addresses WHERE user_id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logSQLError("đếm địa chỉ", e);
        }
        return 0;
    }
    
    /**
     * Bỏ mặc định của tất cả địa chỉ của user
     */
    private void clearDefaultAddresses(Connection conn, int userId) throws SQLException {
        String sql = "UPDATE addresses SET is_default = FALSE WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
    
    /**
     * Map ResultSet to Address object
     */
    private Address mapResultSetToAddress(ResultSet rs) throws SQLException {
        Address address = new Address();
        address.setId(rs.getInt("id"));
        address.setUserId(rs.getInt("user_id"));
        address.setReceiverName(rs.getString("receiver_name"));
        address.setPhone(rs.getString("phone"));
        address.setProvince(rs.getString("province"));
        address.setDistrict(rs.getString("district"));
        address.setWard(rs.getString("ward"));
        address.setAddressDetail(rs.getString("address_detail"));
        address.setNote(rs.getString("note"));
        address.setDefault(rs.getBoolean("is_default"));
        address.setCreatedAt(rs.getTimestamp("created_at"));
        address.setUpdatedAt(rs.getTimestamp("updated_at"));
        return address;
    }
}
