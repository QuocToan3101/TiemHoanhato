package dao;

import model.News;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho bảng news
 */
public class NewsDAO {
    
    private DBConnection dbConnection;
    
    public NewsDAO() {
        this.dbConnection = DBConnection.getInstance();
    }
    
    /**
     * Lấy tất cả tin tức đã publish, sắp xếp theo ngày mới nhất
     */
    public List<News> getAllPublished() {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE is_published = 1 ORDER BY published_date DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting published news: " + e.getMessage());
        }
        return newsList;
    }
    
    /**
     * Lấy tin tức theo category
     */
    public List<News> getByCategory(String category) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE is_published = 1 AND category = ? ORDER BY published_date DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting news by category: " + e.getMessage());
        }
        return newsList;
    }
    
    /**
     * Lấy tin tức theo slug
     */
    public News getBySlug(String slug) {
        String sql = "SELECT * FROM news WHERE slug = ? AND is_published = 1";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                News news = mapResultSetToNews(rs);
                // Tăng số lượt xem
                incrementViews(news.getId());
                return news;
            }
        } catch (SQLException e) {
            System.err.println("Error getting news by slug: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Lấy tin tức theo ID
     */
    public News getById(int id) {
        String sql = "SELECT * FROM news WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToNews(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting news by id: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Lấy tất cả tin tức (cho admin)
     */
    public List<News> getAll() {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news ORDER BY created_at DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all news: " + e.getMessage());
        }
        return newsList;
    }
    
    /**
     * Tìm kiếm tin tức
     */
    public List<News> search(String keyword) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE is_published = 1 AND (title LIKE ? OR excerpt LIKE ? OR content LIKE ?) ORDER BY published_date DESC";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error searching news: " + e.getMessage());
        }
        return newsList;
    }
    
    /**
     * Thêm tin tức mới
     */
    public int add(News news) {
        String sql = "INSERT INTO news (title, slug, excerpt, content, image_url, category, author, is_published, published_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSlug());
            ps.setString(3, news.getExcerpt());
            ps.setString(4, news.getContent());
            ps.setString(5, news.getImageUrl());
            ps.setString(6, news.getCategory());
            ps.setString(7, news.getAuthor());
            ps.setBoolean(8, news.isPublished());
            ps.setTimestamp(9, news.getPublishedDate() != null ? 
                            new Timestamp(news.getPublishedDate().getTime()) : 
                            new Timestamp(System.currentTimeMillis()));
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding news: " + e.getMessage());
        }
        return -1;
    }
    
    /**
     * Cập nhật tin tức
     */
    public boolean update(News news) {
        String sql = "UPDATE news SET title = ?, slug = ?, excerpt = ?, content = ?, image_url = ?, " +
                     "category = ?, author = ?, is_published = ?, published_date = ? WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSlug());
            ps.setString(3, news.getExcerpt());
            ps.setString(4, news.getContent());
            ps.setString(5, news.getImageUrl());
            ps.setString(6, news.getCategory());
            ps.setString(7, news.getAuthor());
            ps.setBoolean(8, news.isPublished());
            ps.setTimestamp(9, news.getPublishedDate() != null ? 
                            new Timestamp(news.getPublishedDate().getTime()) : null);
            ps.setInt(10, news.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating news: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Xóa tin tức
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM news WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting news: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Cập nhật trạng thái publish
     */
    public boolean updatePublishStatus(int id, boolean isPublished) {
        String sql = "UPDATE news SET is_published = ? WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isPublished);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating publish status: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Tăng số lượt xem
     */
    private void incrementViews(int id) {
        String sql = "UPDATE news SET views = views + 1 WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error incrementing views: " + e.getMessage());
        }
    }
    
    /**
     * Lấy tin tức phổ biến (xem nhiều nhất)
     */
    public List<News> getPopular(int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE is_published = 1 ORDER BY views DESC LIMIT ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting popular news: " + e.getMessage());
        }
        return newsList;
    }
    
    /**
     * Lấy tin tức liên quan (cùng category, khác ID)
     */
    public List<News> getRelated(int newsId, String category, int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE is_published = 1 AND category = ? AND id != ? ORDER BY published_date DESC LIMIT ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category);
            ps.setInt(2, newsId);
            ps.setInt(3, limit);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting related news: " + e.getMessage());
        }
        return newsList;
    }
    
    /**
     * Map ResultSet to News object
     */
    private News mapResultSetToNews(ResultSet rs) throws SQLException {
        News news = new News();
        news.setId(rs.getInt("id"));
        news.setTitle(rs.getString("title"));
        news.setSlug(rs.getString("slug"));
        news.setExcerpt(rs.getString("excerpt"));
        news.setContent(rs.getString("content"));
        news.setImageUrl(rs.getString("image_url"));
        news.setCategory(rs.getString("category"));
        news.setAuthor(rs.getString("author"));
        news.setViews(rs.getInt("views"));
        news.setPublished(rs.getBoolean("is_published"));
        news.setPublishedDate(rs.getTimestamp("published_date"));
        news.setCreatedAt(rs.getTimestamp("created_at"));
        news.setUpdatedAt(rs.getTimestamp("updated_at"));
        return news;
    }
}
