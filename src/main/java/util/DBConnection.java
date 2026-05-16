package util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Lớp quản lý kết nối Database sử dụng HikariCP connection pool
 */
public class DBConnection {

    private static DBConnection instance;
    private HikariDataSource dataSource;
    private SQLException initializationError;
    private final AppConfig config = AppConfig.getInstance();

    private DBConnection() {
        String jdbcUrl = config.getDbUrl();
        String dbUser = config.getDbUsername();
        String dbPassword = config.getDbPassword();

        HikariConfig hikariConfig = new HikariConfig();
        hikariConfig.setJdbcUrl(jdbcUrl);
        if (dbUser != null) hikariConfig.setUsername(dbUser);
        if (dbPassword != null) hikariConfig.setPassword(dbPassword);
        hikariConfig.setMaximumPoolSize(20);
        hikariConfig.setMinimumIdle(2);
        hikariConfig.setPoolName("FlowerStorePool");
        hikariConfig.addDataSourceProperty("cachePrepStmts", "true");
        hikariConfig.addDataSourceProperty("prepStmtCacheSize", "250");
        hikariConfig.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        try {
            dataSource = new HikariDataSource(hikariConfig);
            System.out.println("HikariCP pool initialized (poolName=" + hikariConfig.getPoolName() + ")");
        } catch (Exception e) {
            initializationError = e instanceof SQLException ? (SQLException) e : new SQLException("Không thể khởi tạo HikariCP", e);
            System.err.println("Failed to initialize HikariCP: " + e.getMessage());
        }

        // Add shutdown hook to close pool gracefully
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            if (dataSource != null && !dataSource.isClosed()) {
                dataSource.close();
                System.out.println("HikariCP pool closed.");
            }
        }));
    }

    public static synchronized DBConnection getInstance() {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        Connection jndiConnection = tryGetJndiConnection();
        if (jndiConnection != null) {
            return jndiConnection;
        }

        if (dataSource == null) {
            if (initializationError != null) {
                throw new SQLException("Connection pool chưa khởi tạo được", initializationError);
            }
            throw new SQLException("Connection pool chưa khởi tạo được");
        }

        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            System.err.println("Lỗi lấy connection từ pool: " + e.getMessage());
            throw e;
        }
    }

    private Connection tryGetJndiConnection() {
        try {
            Context initContext = new InitialContext();
            DataSource jndiDataSource = (DataSource) initContext.lookup("java:comp/env/jdbc/FlowerStoreDB");
            if (jndiDataSource != null) {
                return jndiDataSource.getConnection();
            }
        } catch (NamingException | ClassCastException e) {
            // Outside Tomcat or when JNDI is not configured, fall back to Hikari.
        } catch (SQLException e) {
            System.err.println("Lỗi lấy connection từ JNDI pool: " + e.getMessage());
        }
        return null;
    }

    public void closePool() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }

    public boolean testConnection() {
        try (Connection conn = getConnection()) {
            if (!conn.isClosed()) {
                System.out.println("✓ Kết nối database thành công (via pool)!");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("✗ Kết nối database thất bại: " + e.getMessage());
        }
        return false;
    }
}
