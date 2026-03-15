package util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Database Connection Pool Manager
 * Sử dụng JNDI DataSource để quản lý connection pool hiệu quả
 */
public class ConnectionPool {
    
    private static DataSource dataSource;
    private static final String JNDI_NAME = "java:comp/env/jdbc/FlowerStoreDB";
    
    static {
        try {
            Context initContext = new InitialContext();
            dataSource = (DataSource) initContext.lookup(JNDI_NAME);
        } catch (NamingException e) {
            // Nếu không có JNDI, fallback về DBConnect cũ
            System.err.println("Warning: JNDI DataSource not found. Using fallback connection.");
            e.printStackTrace();
        }
    }
    
    /**
     * Lấy connection từ pool
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource != null) {
            return dataSource.getConnection();
        } else {
            // Fallback về cách cũ nếu không có pool
            return DBConnection.getInstance().getConnection();
        }
    }
    
    /**
     * Đóng connection (trả về pool)
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close(); // Với pool, close() sẽ trả connection về pool
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Kiểm tra xem có đang sử dụng connection pool không
     */
    public static boolean isPoolEnabled() {
        return dataSource != null;
    }
}
