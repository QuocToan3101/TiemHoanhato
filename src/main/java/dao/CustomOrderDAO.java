package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.CustomOrder;

/**
 * DAO xử lý các thao tác cơ sở dữ liệu liên quan đến Custom Bouquet Order (Đơn đặt hoa tùy chỉnh)
 */
public class CustomOrderDAO extends BaseDAO {

    public CustomOrderDAO() {
        // Tự động tạo bảng custom_orders nếu chưa tồn tại để đảm bảo tính tự phục hồi (self-healing)
        ensureTableExists();
    }

    private void ensureTableExists() {
        String sql = "CREATE TABLE IF NOT EXISTS custom_orders (" +
                "  id INT PRIMARY KEY AUTO_INCREMENT," +
                "  user_id INT NOT NULL," +
                "  flower_type VARCHAR(128) NOT NULL," +
                "  main_flower VARCHAR(128) NOT NULL," +
                "  support_flower VARCHAR(128) NOT NULL," +
                "  quantity VARCHAR(64) NOT NULL," +
                "  wrap_paper VARCHAR(128) NOT NULL," +
                "  color_tone VARCHAR(64) NOT NULL," +
                "  accessories VARCHAR(512)," +
                "  occasion VARCHAR(128) NOT NULL," +
                "  budget DECIMAL(15,2) NOT NULL," +
                "  estimated_price DECIMAL(15,2) NOT NULL," +
                "  customer_note TEXT," +
                "  status VARCHAR(32) DEFAULT 'pending'," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                "  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";

        try {
            executeUpdateQuery(sql);
            logger.info("✓ Khởi tạo bảng custom_orders thành công hoặc bảng đã tồn tại!");
        } catch (SQLException e) {
            logger.error("✗ Lỗi khi khởi tạo bảng custom_orders: " + e.getMessage(), e);
        }
    }

    /**
     * Tạo đơn đặt hàng hoa tùy chỉnh mới
     */
    public boolean createCustomOrder(CustomOrder order) {
        String sql = "INSERT INTO custom_orders (user_id, flower_type, main_flower, support_flower, quantity, " +
                "wrap_paper, color_tone, accessories, occasion, budget, estimated_price, customer_note, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            long generatedId = executeInsertAndGetId(sql,
                    order.getUserId(),
                    order.getFlowerType(),
                    order.getMainFlower(),
                    order.getSupportFlower(),
                    order.getQuantity(),
                    order.getWrapPaper(),
                    order.getColorTone(),
                    order.getAccessories(),
                    order.getOccasion(),
                    order.getBudget(),
                    order.getEstimatedPrice(),
                    order.getCustomerNote(),
                    order.getStatus());

            if (generatedId > 0) {
                order.setId((int) generatedId);
                return true;
            }
        } catch (SQLException e) {
            logSQLError("tạo custom order", e);
        }
        return false;
    }

    /**
     * Tìm đơn đặt hoa tùy chỉnh theo ID
     */
    public CustomOrder findById(int id) {
        String sql = "SELECT co.*, u.fullname, u.email, u.phone FROM custom_orders co " +
                "JOIN users u ON co.user_id = u.id WHERE co.id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomOrder(rs);
                }
            }
        } catch (SQLException e) {
            logSQLError("tìm custom order theo ID: " + id, e);
        }
        return null;
    }

    /**
     * Lấy danh sách các đơn đặt hoa tùy chỉnh của một khách hàng cụ thể
     */
    public List<CustomOrder> findByUserId(int userId) {
        List<CustomOrder> list = new ArrayList<>();
        String sql = "SELECT co.*, u.fullname, u.email, u.phone FROM custom_orders co " +
                "JOIN users u ON co.user_id = u.id WHERE co.user_id = ? ORDER BY co.created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCustomOrder(rs));
                }
            }
        } catch (SQLException e) {
            logSQLError("tìm custom orders theo user ID: " + userId, e);
        }
        return list;
    }

    /**
     * Lấy tất cả các đơn đặt hoa tùy chỉnh (dành cho Admin dashboard)
     */
    public List<CustomOrder> findAll() {
        List<CustomOrder> list = new ArrayList<>();
        String sql = "SELECT co.*, u.fullname, u.email, u.phone FROM custom_orders co " +
                "JOIN users u ON co.user_id = u.id ORDER BY co.created_at DESC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapResultSetToCustomOrder(rs));
            }
        } catch (SQLException e) {
            logSQLError("lấy tất cả custom orders", e);
        }
        return list;
    }

    /**
     * Cập nhật trạng thái của đơn đặt hoa tùy chỉnh (pending, confirmed, processing, completed, cancelled)
     */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE custom_orders SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try {
            int rows = executeUpdateQuery(sql, status, id);
            return rows > 0;
        } catch (SQLException e) {
            logSQLError("cập nhật trạng thái custom order ID: " + id, e);
        }
        return false;
    }

    /**
     * Map ResultSet thành đối tượng CustomOrder
     */
    private CustomOrder mapResultSetToCustomOrder(ResultSet rs) throws SQLException {
        CustomOrder order = new CustomOrder();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setFlowerType(rs.getString("flower_type"));
        order.setMainFlower(rs.getString("main_flower"));
        order.setSupportFlower(rs.getString("support_flower"));
        order.setQuantity(rs.getString("quantity"));
        order.setWrapPaper(rs.getString("wrap_paper"));
        order.setColorTone(rs.getString("color_tone"));
        order.setAccessories(rs.getString("accessories"));
        order.setOccasion(rs.getString("occasion"));
        order.setBudget(rs.getBigDecimal("budget"));
        order.setEstimatedPrice(rs.getBigDecimal("estimated_price"));
        order.setCustomerNote(rs.getString("customer_note"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Join fields
        order.setUserFullname(rs.getString("fullname"));
        order.setUserEmail(rs.getString("email"));
        order.setUserPhone(rs.getString("phone"));

        return order;
    }
}
