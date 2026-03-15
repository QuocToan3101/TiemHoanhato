package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import model.User;
import util.DBConnection;

/**
 * DAO (Data Access Object) để thao tác với bảng users
 */
public class UserDAO {
    
    private Connection getConnection() {
        return DBConnection.getInstance().getConnection();
    }
    
    private void logSQLError(String operation, SQLException e) {
        System.err.println("[UserDAO] Lỗi " + operation + ": " + e.getMessage());
        System.err.println("SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
    }
    
    /**
     * Đăng ký user mới với verification token
     */
    public boolean registerWithVerification(User user, String verificationToken) {
        String sql = "INSERT INTO users (email, password, fullname, phone, role, status, verification_token) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Hash password trước khi lưu
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            
            ps.setString(1, user.getEmail());
            ps.setString(2, hashedPassword);
            ps.setString(3, user.getFullname());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole() != null ? user.getRole() : "customer");
            ps.setString(6, user.getStatus() != null ? user.getStatus() : "pending");
            ps.setString(7, verificationToken);
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logSQLError("đăng ký user với verification", e);
        }
        return false;
    }
    
    /**
     * Xác thực email bằng token
     */
    public boolean verifyEmail(String token) {
        String sql = "UPDATE users SET status = 'active', verification_token = NULL WHERE verification_token = ? AND status = 'pending'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, token);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            logSQLError("xác thực email", e);
        }
        return false;
    }
    
    /**
     * Đăng ký user mới
     */
    public boolean register(User user) {
        String sql = "INSERT INTO users (email, password, fullname, phone, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Hash password trước khi lưu
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            
            ps.setString(1, user.getEmail());
            ps.setString(2, hashedPassword);
            ps.setString(3, user.getFullname());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole() != null ? user.getRole() : "customer");
            ps.setString(6, user.getStatus() != null ? user.getStatus() : "active");
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logSQLError("đăng ký user", e);
        }
        return false;
    }
    
    /**
     * Đăng nhập - kiểm tra email và password
     */
    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND status = 'active'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                // Kiểm tra password với BCrypt
                if (BCrypt.checkpw(password, hashedPassword)) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            logSQLError("đăng nhập", e);
        }
        return null;
    }
    
    /**
     * Tìm user theo email
     */
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            logSQLError("tìm user theo email", e);
        }
        return null;
    }
    
    /**
     * Tìm user theo ID
     */
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            logSQLError("tìm user theo ID", e);
        }
        return null;
    }
    
    /**
     * Lấy tất cả users (cho Admin)
     */
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            logSQLError("lấy danh sách users", e);
        }
        return users;
    }
    
    /**
     * Lấy users theo role
     */
    public List<User> findByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            logSQLError("lấy users theo role", e);
        }
        return users;
    }
    
    /**
     * Cập nhật thông tin user
     */
    public boolean update(User user) {
        String sql = "UPDATE users SET fullname = ?, phone = ?, avatar = ?, bio = ?, " +
                    "gender = ?, birthday = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAvatar());
            ps.setString(4, user.getBio());
            ps.setString(5, user.getGender());
            ps.setDate(6, user.getBirthday());
            ps.setInt(7, user.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSQLError("cập nhật user", e);
        }
        return false;
    }
    
    /**
     * Đổi mật khẩu
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        // Kiểm tra mật khẩu cũ
        User user = findById(userId);
        if (user == null) return false;
        
        String sql = "SELECT password FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (!BCrypt.checkpw(oldPassword, hashedPassword)) {
                    return false; // Mật khẩu cũ không đúng
                }
            }
        } catch (SQLException e) {
            logSQLError("kiểm tra mật khẩu cũ", e);
            return false;
        }
        
        // Cập nhật mật khẩu mới
        String updateSql = "UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {
            
            String newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSQLError("đổi mật khẩu", e);
        }
        return false;
    }
    
    /**
     * Đặt lại mật khẩu (cho forgot password)
     */
    public boolean resetPassword(String email, String newPassword) {
        // Kiểm tra email tồn tại
        User user = findByEmail(email);
        if (user == null) {
            return false;
        }
        
        String sql = "UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSQLError("đặt lại mật khẩu", e);
        }
        return false;
    }
    
    /**
     * Cập nhật trạng thái user (cho Admin)
     */
    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSQLError("cập nhật status", e);
        }
        return false;
    }
    
    /**
     * Kiểm tra email đã tồn tại chưa
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logSQLError("kiểm tra email", e);
        }
        return false;
    }
    
    /**
     * Đếm tổng số users
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logSQLError("đếm users", e);
        }
        return 0;
    }
    
    /**
     * Xóa user (soft delete - đổi status thành inactive)
     */
    public boolean delete(int userId) {
        return updateStatus(userId, "inactive");
    }
    
    /**
     * Cập nhật một field cụ thể của user
     */
    public boolean updateField(int userId, String fieldName, String value) {
        // Chỉ cho phép cập nhật các field an toàn
        String[] allowedFields = {"fullname", "phone", "avatar", "bio", "gender"};
        boolean isAllowed = false;
        for (String field : allowedFields) {
            if (field.equals(fieldName)) {
                isAllowed = true;
                break;
            }
        }
        if (!isAllowed) return false;
        
        String sql = "UPDATE users SET " + fieldName + " = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, value);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSQLError("cập nhật field " + fieldName, e);
        }
        return false;
    }
    
    /**
     * Cập nhật ngày sinh
     */
    public boolean updateBirthday(int userId, java.sql.Date birthday) {
        String sql = "UPDATE users SET birthday = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, birthday);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSQLError("cập nhật birthday", e);
        }
        return false;
    }
    
    /**
     * Map ResultSet sang User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFullname(rs.getString("fullname"));
        user.setPhone(rs.getString("phone"));
        user.setAvatar(rs.getString("avatar"));
        user.setBio(rs.getString("bio"));
        user.setGender(rs.getString("gender"));
        user.setBirthday(rs.getDate("birthday"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
    
    /**
     * Đếm tổng số users
     */
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logSQLError("đếm tổng users", e);
        }
        return 0;
    }
}
