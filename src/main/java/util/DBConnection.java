package util;

import java.sql.Connection;
import java.sql.SQLException;

import org.apache.commons.dbcp2.BasicDataSource;

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
    private final String DB_DRIVER;
    private BasicDataSource dataSource;
    
    // Singleton instance
    private static DBConnection instance;
    
    // Constructor private để ngăn tạo instance từ bên ngoài
    private DBConnection() {
        // Đọc config từ application.properties
        this.DB_URL = config.getDbUrl();
        this.DB_USER = config.getDbUsername();
        this.DB_PASSWORD = config.getDbPassword();
        this.DB_DRIVER = config.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
        
        try {
            // Load MySQL JDBC Driver
            Class.forName(DB_DRIVER);
            initializeDataSource();
            System.out.println("Connection pool đã được khởi tạo thành công!");
        } catch (ClassNotFoundException e) {
            System.err.println("Lỗi: Không tìm thấy MySQL JDBC Driver!");
            System.err.println("Chi tiết lỗi: " + e.getClass().getName() + ": " + e.getMessage());
        }
    }

    private void initializeDataSource() {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName(DB_DRIVER);
        ds.setUrl(DB_URL);
        ds.setUsername(DB_USER);
        ds.setPassword(DB_PASSWORD);

        ds.setInitialSize(config.getDbPoolInitialSize());
        ds.setMaxTotal(config.getDbPoolMaxTotal());
        ds.setMaxIdle(config.getDbPoolMaxIdle());
        ds.setMinIdle(config.getDbPoolMinIdle());
        ds.setMaxWaitMillis(config.getDbPoolMaxWaitMillis());

        ds.setValidationQuery("SELECT 1");
        ds.setTestOnBorrow(true);
        ds.setTestWhileIdle(true);
        ds.setTimeBetweenEvictionRunsMillis(30000);
        ds.setMinEvictableIdleTimeMillis(300000);

        this.dataSource = ds;
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
        if (dataSource == null) {
            return null;
        }
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
            return null;
        }
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
     * Đóng toàn bộ pool khi ứng dụng shutdown
     */
    public void shutdown() {
        if (dataSource != null) {
            try {
                dataSource.close();
            } catch (SQLException e) {
                System.err.println("Lỗi đóng connection pool: " + e.getMessage());
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
