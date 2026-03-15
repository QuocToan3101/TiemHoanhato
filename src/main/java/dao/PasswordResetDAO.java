package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.UUID;

import util.DBConnection;

/**
 * DAO để quản lý password reset tokens
 */
public class PasswordResetDAO {
    
    private Connection getConnection() {
        return DBConnection.getInstance().getConnection();
    }
    
    /**
     * Tạo token reset password mới
     */
    public String createResetToken(String email) {
        // Tạo token ngẫu nhiên
        String token = UUID.randomUUID().toString();
        
        // Xóa các token cũ của email này
        deleteTokensByEmail(email);
        
        String sql = "INSERT INTO password_reset_tokens (email, token, expires_at) " +
                    "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 1 HOUR))";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, token);
            ps.executeUpdate();
            
            return token;
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo reset token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Kiểm tra token có hợp lệ không
     */
    public String validateToken(String token) {
        String sql = "SELECT email FROM password_reset_tokens " +
                    "WHERE token = ? AND expires_at > NOW() AND used = FALSE";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("email");
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi validate token: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Đánh dấu token đã được sử dụng
     */
    public boolean markTokenAsUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET used = TRUE WHERE token = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi mark token as used: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Xóa các token cũ của email
     */
    private void deleteTokensByEmail(String email) {
        String sql = "DELETE FROM password_reset_tokens WHERE email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa token cũ: " + e.getMessage());
        }
    }
    
    /**
     * Dọn dẹp các token đã hết hạn
     */
    public void cleanupExpiredTokens() {
        String sql = "DELETE FROM password_reset_tokens WHERE expires_at < NOW()";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            
            int deleted = stmt.executeUpdate(sql);
            System.out.println("Đã xóa " + deleted + " token hết hạn");
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi cleanup expired tokens: " + e.getMessage());
        }
    }
}
