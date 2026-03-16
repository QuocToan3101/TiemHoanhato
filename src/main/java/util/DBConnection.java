package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Lớp quản lý kết nối Database
 * Sử dụng Singleton Pattern để đảm bảo chỉ có 1 connection pool
 */
public class DBConnection {
    
    // Đọc cấu hình từ application.properties thay vì hard-code
    private final AppConfig config = AppConfig.getInstance();
    private final String DB_URL;
    private final String DB_USER;
    private final String DB_PASSWORD;
    
    // Singleton instance
    private static DBConnection instance;
    
    // Constructor private để ngăn tạo instance từ bên ngoài
    private DBConnection() {
        // Đọc config từ application.properties
        this.DB_URL = config.getDbUrl();
        this.DB_USER = config.getDbUsername();
        this.DB_PASSWORD = config.getDbPassword();
        
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver đã được load thành công!");
            System.out.println("Database URL: " + DB_URL);
            System.out.println("Database User: " + DB_USER);
        } catch (ClassNotFoundException e) {
            System.err.println("Lỗi: Không tìm thấy MySQL JDBC Driver!");
            System.err.println("Chi tiết lỗi: " + e.getClass().getName() + ": " + e.getMessage());
        }
    }
    
    /**
     * Lấy instance của DBConnection (Singleton)
     */
    public static synchronized DBConnection getInstance() {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }
    
    /**
     * Lấy connection đến database
     * @return Connection object hoặc null nếu lỗi
     */
    public Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
        }
        return conn;
    }
    
    /**
     * Đóng connection
     * @param conn Connection cần đóng
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Lỗi đóng connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Kiểm tra kết nối database
     * @return true nếu kết nối thành công
     */
    public boolean testConnection() {
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✓ Kết nối database thành công!");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("✗ Kết nối database thất bại: " + e.getMessage());
        }
        return false;
    }
    
    // Main method để test connection
    public static void main(String[] args) {
        DBConnection db = DBConnection.getInstance();
        db.testConnection();
    }
}
