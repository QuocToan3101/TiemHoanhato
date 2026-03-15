package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Category;
import util.DBConnection;

/**
 * DAO để thao tác với bảng categories
 */
public class CategoryDAO {
    
    private Connection getConnection() {
        return DBConnection.getInstance().getConnection();
    }
    
    /**
     * Lấy tất cả danh mục đang active
     */
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE is_active = TRUE ORDER BY display_order, name";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy danh sách categories: " + e.getMessage());
        }
        return categories;
    }
    
    /**
     * Lấy tất cả danh mục (bao gồm cả inactive - cho Admin)
     */
    public List<Category> findAllIncludeInactive() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY display_order, name";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy danh sách categories: " + e.getMessage());
        }
        return categories;
    }
    
    /**
     * Lấy danh mục cha (parent_id = NULL)
     */
    public List<Category> findParentCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE parent_id IS NULL AND is_active = TRUE ORDER BY display_order, name";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy parent categories: " + e.getMessage());
        }
        return categories;
    }
    
    /**
     * Lấy danh mục con theo parent_id
     */
    public List<Category> findByParentId(int parentId) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE parent_id = ? AND is_active = TRUE ORDER BY display_order, name";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, parentId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy child categories: " + e.getMessage());
        }
        return categories;
    }
    
    /**
     * Tìm danh mục theo ID
     */
    public Category findById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tìm category theo ID: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Tìm danh mục theo slug
     */
    public Category findBySlug(String slug) {
        String sql = "SELECT * FROM categories WHERE slug = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tìm category theo slug: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Thêm danh mục mới
     */
    public boolean insert(Category category) {
        String sql = "INSERT INTO categories (name, slug, description, image, parent_id, display_order, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getSlug());
            ps.setString(3, category.getDescription());
            ps.setString(4, category.getImage());
            if (category.getParentId() != null) {
                ps.setInt(5, category.getParentId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, category.getDisplayOrder());
            ps.setBoolean(7, category.isActive());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    category.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi thêm category: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Cập nhật danh mục
     */
    public boolean update(Category category) {
        String sql = "UPDATE categories SET name = ?, slug = ?, description = ?, image = ?, " +
                    "parent_id = ?, display_order = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getSlug());
            ps.setString(3, category.getDescription());
            ps.setString(4, category.getImage());
            if (category.getParentId() != null) {
                ps.setInt(5, category.getParentId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, category.getDisplayOrder());
            ps.setBoolean(7, category.isActive());
            ps.setInt(8, category.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật category: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Xóa danh mục (soft delete)
     */
    public boolean delete(int id) {
        String sql = "UPDATE categories SET is_active = FALSE, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi xóa category: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Đếm số sản phẩm trong danh mục
     */
    public int countProductsByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = ? AND is_active = TRUE";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm products: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Lấy danh mục nổi bật (có sản phẩm, có hình ảnh)
     */
    public List<Category> findFeaturedCategories(int limit) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(p.id) as product_count " +
                    "FROM categories c " +
                    "LEFT JOIN products p ON c.id = p.category_id AND p.is_active = TRUE " +
                    "WHERE c.is_active = TRUE AND c.image IS NOT NULL AND c.image != '' " +
                    "GROUP BY c.id " +
                    "HAVING product_count > 0 " +
                    "ORDER BY c.display_order, product_count DESC " +
                    "LIMIT ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Category cat = mapResultSetToCategory(rs);
                cat.setProductCount(rs.getInt("product_count"));
                categories.add(cat);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy featured categories: " + e.getMessage());
        }
        return categories;
    }
    
    /**
     * Map ResultSet sang Category object
     */
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setSlug(rs.getString("slug"));
        category.setDescription(rs.getString("description"));
        category.setImage(rs.getString("image"));
        int parentId = rs.getInt("parent_id");
        category.setParentId(rs.wasNull() ? null : parentId);
        category.setDisplayOrder(rs.getInt("display_order"));
        category.setActive(rs.getBoolean("is_active"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setUpdatedAt(rs.getTimestamp("updated_at"));
        return category;
    }
}
