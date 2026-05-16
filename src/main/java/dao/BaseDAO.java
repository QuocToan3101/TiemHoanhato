package dao;

import util.Constants;
import util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Base class cho tất cả DAO classes
 * Cung cấp utility methods cho SQL execution, connection management, parameter binding
 * 
 * REFACTOR BENEFITS:
 * - Unify query execution pattern
 * - Centralized error handling
 * - Consistent logging
 * - Type-safe parameter binding
 */
public abstract class BaseDAO {
    
    protected static final Logger logger = LoggerFactory.getLogger(BaseDAO.class);
    protected final DBConnection dbConnection = DBConnection.getInstance();
    
    /**
     * Lấy connection từ HikariCP pool
     * @return Connection object
     * @throws SQLException nếu không thể lấy connection
     */
    protected Connection getConnection() throws SQLException {
        try {
            return dbConnection.getConnection();
        } catch (SQLException e) {
            logger.error("Lỗi kết nối database", e);
            throw e;
        }
    }
    
    /**
     * Execute SELECT query và return count
     * TỐI ƯU: Dùng COUNT(*) trực tiếp trong SQL thay vì load all rồi count
     * 
     * @param sql SQL query với COUNT(*)
     * @param params Các parameter để bind
     * @return Số lượng records
     * @throws SQLException
     */
    protected int executeCountQuery(String sql, Object... params) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            setParameters(ps, params);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error("Lỗi thực hiện COUNT query: {}", sql, e);
            throw e;
        }
        return 0;
    }
    
    /**
     * Execute UPDATE/INSERT/DELETE query
     * @param sql SQL query
     * @param params Các parameter để bind
     * @return Số rows được affect
     * @throws SQLException
     */
    protected int executeUpdateQuery(String sql, Object... params) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            setParameters(ps, params);
            int affectedRows = ps.executeUpdate();
            logger.debug("UPDATE query executed: {} rows affected", affectedRows);
            return affectedRows;
            
        } catch (SQLException e) {
            logger.error("Lỗi thực hiện UPDATE query: {}", sql, e);
            throw e;
        }
    }
    
    /**
     * Execute INSERT query và return generated ID
     * @param sql SQL query (phải có RETURN_GENERATED_KEYS)
     * @param params Các parameter để bind
     * @return ID được tạo
     * @throws SQLException
     */
    protected long executeInsertAndGetId(String sql, Object... params) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            setParameters(ps, params);
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Insert không thành công, không có row nào được tạo");
            }
            
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong(1);
                    logger.debug("INSERT query executed: new ID = {}", id);
                    return id;
                } else {
                    throw new SQLException("Không thể lấy ID được tạo");
                }
            }
            
        } catch (SQLException e) {
            logger.error("Lỗi thực hiện INSERT query: {}", sql, e);
            throw e;
        }
    }
    
    /**
     * Execute batch update queries
     * TỐI ƯU: Batch processing để giảm network round-trips
     * 
     * @param sql SQL query
     * @param paramsList Danh sách các parameter sets
     * @return Danh sách số rows được affect cho mỗi statement
     * @throws SQLException
     */
    protected int[] executeBatchUpdate(String sql, List<Object[]> paramsList) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (Object[] params : paramsList) {
                setParameters(ps, params);
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            logger.debug("Batch update executed: {} statements", results.length);
            return results;
            
        } catch (SQLException e) {
            logger.error("Lỗi thực hiện batch update query: {}", sql, e);
            throw e;
        }
    }
    
    /**
     * Set parameters cho PreparedStatement
     * BENEFIT: Type-safe parameter binding, prevent SQL injection
     * 
     * @param ps PreparedStatement
     * @param params Array of parameters
     * @throws SQLException
     */
    protected void setParameters(PreparedStatement ps, Object... params) throws SQLException {
        for (int i = 0; i < params.length; i++) {
            Object param = params[i];
            int paramIndex = i + 1;
            
            if (param == null) {
                ps.setNull(paramIndex, Types.NULL);
            } else if (param instanceof String) {
                ps.setString(paramIndex, (String) param);
            } else if (param instanceof Integer) {
                ps.setInt(paramIndex, (Integer) param);
            } else if (param instanceof Long) {
                ps.setLong(paramIndex, (Long) param);
            } else if (param instanceof Boolean) {
                ps.setBoolean(paramIndex, (Boolean) param);
            } else if (param instanceof java.math.BigDecimal) {
                ps.setBigDecimal(paramIndex, (java.math.BigDecimal) param);
            } else if (param instanceof java.sql.Date) {
                ps.setDate(paramIndex, (java.sql.Date) param);
            } else if (param instanceof Timestamp) {
                ps.setTimestamp(paramIndex, (Timestamp) param);
            } else if (param instanceof Double) {
                ps.setDouble(paramIndex, (Double) param);
            } else if (param instanceof Float) {
                ps.setFloat(paramIndex, (Float) param);
            } else {
                ps.setObject(paramIndex, param);
            }
        }
    }
    
    /**
     * Validate input string parameter
     * @param value String value
     * @param fieldName Tên field cho error message
     * @param minLength Độ dài tối thiểu
     * @param maxLength Độ dài tối đa
     * @return Trimmed value nếu hợp lệ
     * @throws IllegalArgumentException nếu không hợp lệ
     */
    protected String validateStringParam(String value, String fieldName, int minLength, int maxLength) 
            throws IllegalArgumentException {
        
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(fieldName + " không được để trống");
        }
        
        String trimmed = value.trim();
        
        if (trimmed.length() < minLength) {
            throw new IllegalArgumentException(fieldName + " phải có ít nhất " + minLength + " ký tự");
        }
        
        if (trimmed.length() > maxLength) {
            throw new IllegalArgumentException(fieldName + " không được vượt quá " + maxLength + " ký tự");
        }
        
        return trimmed;
    }
    
    /**
     * Validate email format
     * @param email Email address
     * @return Email nếu hợp lệ
     * @throws IllegalArgumentException nếu không hợp lệ
     */
    protected String validateEmail(String email) throws IllegalArgumentException {
        if (email == null || !email.matches(Constants.REGEX.EMAIL)) {
            throw new IllegalArgumentException("Email không hợp lệ: " + email);
        }
        return email.trim();
    }
    
    /**
     * Validate phone number
     * @param phone Phone number
     * @return Phone nếu hợp lệ
     * @throws IllegalArgumentException nếu không hợp lệ
     */
    protected String validatePhone(String phone) throws IllegalArgumentException {
        if (phone == null || !phone.matches(Constants.REGEX.PHONE)) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ: " + phone);
        }
        return phone.trim();
    }
    
    /**
     * Validate numeric parameter
     * @param value Giá trị
     * @param fieldName Tên field
     * @param minValue Giá trị tối thiểu
     * @param maxValue Giá trị tối đa
     * @return Giá trị nếu hợp lệ
     * @throws IllegalArgumentException nếu không hợp lệ
     */
    protected int validateIntParam(int value, String fieldName, int minValue, int maxValue) 
            throws IllegalArgumentException {
        
        if (value < minValue || value > maxValue) {
            throw new IllegalArgumentException(
                fieldName + " phải trong khoảng [" + minValue + ", " + maxValue + "], nhận được: " + value
            );
        }
        return value;
    }
    
    /**
     * Log SQL error với đầy đủ context
     * @param operation Tên operation (vd: "lấy danh sách products")
     * @param e SQLException
     */
    protected void logSQLError(String operation, SQLException e) {
        logger.error("Lỗi {} - SQL State: {}, Error Code: {}, Message: {}", 
            operation, e.getSQLState(), e.getErrorCode(), e.getMessage(), e);
    }
    
    /**
     * Close ResultSet an cách an toàn
     * @param rs ResultSet
     */
    protected void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                logger.warn("Lỗi khi đóng ResultSet", e);
            }
        }
    }
    
    /**
     * Close PreparedStatement an cách an toàn
     * @param ps PreparedStatement
     */
    protected void closePreparedStatement(PreparedStatement ps) {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                logger.warn("Lỗi khi đóng PreparedStatement", e);
            }
        }
    }
    
    /**
     * Close Connection an cách an toàn
     * @param conn Connection
     */
    protected void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                logger.warn("Lỗi khi đóng Connection", e);
            }
        }
    }
}
