package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Contact;
import util.DBConnection;

/**
 * Data Access Object cho bảng contacts
 */
public class ContactDAO {
    
    private DBConnection dbConnection;
    
    public ContactDAO() {
        dbConnection = DBConnection.getInstance();
    }
    
    /**
     * Thêm liên hệ mới
     */
    public int add(Contact contact) {
        String sql = "INSERT INTO contacts (name, phone, email, subject, message, status, user_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, contact.getName());
            ps.setString(2, contact.getPhone());
            ps.setString(3, contact.getEmail());
            ps.setString(4, contact.getSubject());
            ps.setString(5, contact.getMessage());
            ps.setString(6, contact.getStatus() != null ? contact.getStatus() : "new");
            
            if (contact.getUserId() != null) {
                ps.setInt(7, contact.getUserId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
        }
        return -1;
    }
    
    /**
     * Lấy tất cả liên hệ (cho admin)
     */
    public List<Contact> findAll() {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts ORDER BY created_at DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                contacts.add(mapResultSetToContact(rs));
            }
        } catch (SQLException e) {
        }
        return contacts;
    }
    
    /**
     * Lấy liên hệ theo trạng thái
     */
    public List<Contact> findByStatus(String status) {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE status = ? ORDER BY created_at DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                contacts.add(mapResultSetToContact(rs));
            }
        } catch (SQLException e) {
        }
        return contacts;
    }
    
    /**
     * Lấy liên hệ theo ID
     */
    public Contact findById(int id) {
        String sql = "SELECT * FROM contacts WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToContact(rs);
            }
        } catch (SQLException e) {
        }
        return null;
    }
    
    /**
     * Cập nhật trạng thái liên hệ
     */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE contacts SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }
    
    /**
     * Cập nhật ghi chú admin
     */
    public boolean updateAdminNote(int id, String note) {
        String sql = "UPDATE contacts SET admin_note = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, note);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }
    
    /**
     * Xóa liên hệ
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM contacts WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }
    
    /**
     * Đếm số liên hệ mới (chưa đọc)
     */
    public int countNewContacts() {
        String sql = "SELECT COUNT(*) FROM contacts WHERE status = 'new'";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
        }
        return 0;
    }
    
    /**
     * Đếm tổng số liên hệ
     */
    public int getTotalContacts() {
        String sql = "SELECT COUNT(*) FROM contacts";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
        }
        return 0;
    }
    
    /**
     * Đếm số liên hệ theo status
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM contacts WHERE status = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
        }
        return 0;
    }
    
    /**
     * Map ResultSet to Contact object
     */
    private Contact mapResultSetToContact(ResultSet rs) throws SQLException {
        Contact contact = new Contact();
        contact.setId(rs.getInt("id"));
        contact.setName(rs.getString("name"));
        contact.setPhone(rs.getString("phone"));
        contact.setEmail(rs.getString("email"));
        contact.setSubject(rs.getString("subject"));
        contact.setMessage(rs.getString("message"));
        contact.setStatus(rs.getString("status"));
        
        // Xử lý admin_note nếu có
        try {
            contact.setAdminNote(rs.getString("admin_note"));
        } catch (SQLException e) {
            // Column không tồn tại, bỏ qua
        }
        
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            contact.setUserId(userId);
        }
        
        contact.setCreatedAt(rs.getTimestamp("created_at"));
        contact.setUpdatedAt(rs.getTimestamp("updated_at"));
        return contact;
    }
}
