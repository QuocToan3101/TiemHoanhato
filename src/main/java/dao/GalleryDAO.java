package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Gallery;
import util.DBConnection;

/**
 * DAO cho bảng gallery
 */
public class GalleryDAO {
    
    private DBConnection dbConnection;
    
    public GalleryDAO() {
        this.dbConnection = DBConnection.getInstance();
    }
    
    /**
     * Lấy tất cả gallery items đang active, sắp xếp theo display_order
     */
    public List<Gallery> getAllActive() {
        List<Gallery> galleries = new ArrayList<>();
        String sql = "SELECT * FROM gallery WHERE is_active = 1 ORDER BY display_order ASC, created_at DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                galleries.add(mapResultSetToGallery(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting active galleries: " + e.getMessage());
        }
        return galleries;
    }
    
    /**
     * Lấy tất cả gallery items (cho admin)
     */
    public List<Gallery> getAll() {
        List<Gallery> galleries = new ArrayList<>();
        String sql = "SELECT * FROM gallery ORDER BY display_order ASC, created_at DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                galleries.add(mapResultSetToGallery(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all galleries: " + e.getMessage());
        }
        return galleries;
    }
    
    /**
     * Lấy gallery theo ID
     */
    public Gallery getById(int id) {
        String sql = "SELECT * FROM gallery WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToGallery(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting gallery by id: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Thêm gallery mới
     */
    public int add(Gallery gallery) {
        String sql = "INSERT INTO gallery (image_url, caption, description, display_order, is_active) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, gallery.getImageUrl());
            ps.setString(2, gallery.getCaption());
            ps.setString(3, gallery.getDescription());
            ps.setInt(4, gallery.getDisplayOrder());
            ps.setBoolean(5, gallery.isActive());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding gallery: " + e.getMessage());
        }
        return -1;
    }
    
    /**
     * Cập nhật gallery
     */
    public boolean update(Gallery gallery) {
        String sql = "UPDATE gallery SET image_url = ?, caption = ?, description = ?, " +
                     "display_order = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, gallery.getImageUrl());
            ps.setString(2, gallery.getCaption());
            ps.setString(3, gallery.getDescription());
            ps.setInt(4, gallery.getDisplayOrder());
            ps.setBoolean(5, gallery.isActive());
            ps.setInt(6, gallery.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating gallery: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Xóa gallery
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM gallery WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting gallery: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Cập nhật trạng thái active
     */
    public boolean updateActiveStatus(int id, boolean isActive) {
        String sql = "UPDATE gallery SET is_active = ? WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating gallery status: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Cập nhật thứ tự hiển thị
     */
    public boolean updateDisplayOrder(int id, int order) {
        String sql = "UPDATE gallery SET display_order = ? WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, order);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating display order: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Map ResultSet to Gallery object
     */
    private Gallery mapResultSetToGallery(ResultSet rs) throws SQLException {
        Gallery gallery = new Gallery();
        gallery.setId(rs.getInt("id"));
        gallery.setImageUrl(rs.getString("image_url"));
        gallery.setCaption(rs.getString("caption"));
        gallery.setDescription(rs.getString("description"));
        gallery.setDisplayOrder(rs.getInt("display_order"));
        gallery.setActive(rs.getBoolean("is_active"));
        gallery.setCreatedAt(rs.getTimestamp("created_at"));
        gallery.setUpdatedAt(rs.getTimestamp("updated_at"));
        return gallery;
    }
}
