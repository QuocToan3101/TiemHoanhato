package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Lớp quản lý cấu hình ứng dụng từ application.properties
 */
public class AppConfig {
    
    private static AppConfig instance;
    private Properties properties;
    
    private AppConfig() {
        properties = new Properties();
        loadProperties();
    }
    
    public static synchronized AppConfig getInstance() {
        if (instance == null) {
            instance = new AppConfig();
        }
        return instance;
    }
    
    private void loadProperties() {
        try (InputStream input = getClass().getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (input == null) {
                System.err.println("Không tìm thấy application.properties");
                return;
            }
            properties.load(input);
            System.out.println("Đã load application.properties thành công!");
        } catch (IOException e) {
            System.err.println("Lỗi khi load application.properties: " + e.getMessage());
        }
    }
    
    public String getProperty(String key) {
        return properties.getProperty(key);
    }
    
    public String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }
    
    public boolean getBooleanProperty(String key, boolean defaultValue) {
        String value = properties.getProperty(key);
        if (value == null) {
            return defaultValue;
        }
        return Boolean.parseBoolean(value);
    }
    
    public int getIntProperty(String key, int defaultValue) {
        String value = properties.getProperty(key);
        if (value == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    // Database Configuration
    public String getDbUrl() {
        return getProperty("db.url");
    }
    
    public String getDbUsername() {
        return getProperty("db.username");
    }
    
    public String getDbPassword() {
        return getProperty("db.password", "");
    }

    public int getDbPoolInitialSize() {
        return getIntProperty("db.pool.initialSize", 5);
    }

    public int getDbPoolMaxTotal() {
        return getIntProperty("db.pool.maxTotal", 30);
    }

    public int getDbPoolMaxIdle() {
        return getIntProperty("db.pool.maxIdle", 10);
    }

    public int getDbPoolMinIdle() {
        return getIntProperty("db.pool.minIdle", 3);
    }

    public int getDbPoolMaxWaitMillis() {
        return getIntProperty("db.pool.maxWaitMillis", 10000);
    }
    
    // Email Configuration
    public String getEmailHost() {
        return getProperty("email.smtp.host");
    }
    
    public int getEmailPort() {
        return getIntProperty("email.smtp.port", 587);
    }
    
    public String getEmailUsername() {
        return getProperty("email.username");
    }
    
    public String getEmailPassword() {
        return getProperty("email.password");
    }
    
    public String getEmailFromName() {
        return getProperty("email.from.name");
    }
    
    public String getEmailFromAddress() {
        return getProperty("email.from.address");
    }
    
    public String getEmailAdminAddress() {
        return getProperty("email.admin.address", getEmailFromAddress());
    }
    
    // VNPay Configuration
    public boolean isVNPayEnabled() {
        return getBooleanProperty("vnpay.enabled", false);
    }
    
    public String getVNPayUrl() {
        return getProperty("vnpay.url");
    }
    
    public String getVNPayReturnUrl() {
        return getProperty("vnpay.return.url");
    }
    
    public String getVNPayTmnCode() {
        return getProperty("vnpay.tmn.code");
    }
    
    public String getVNPayHashSecret() {
        return getProperty("vnpay.hash.secret");
    }
    
    // MoMo Configuration
    public boolean isMoMoEnabled() {
        return getBooleanProperty("momo.enabled", false);
    }
    
    public String getMoMoPartnerCode() {
        return getProperty("momo.partner.code");
    }
    
    public String getMoMoAccessKey() {
        return getProperty("momo.access.key");
    }
    
    public String getMoMoSecretKey() {
        return getProperty("momo.secret.key");
    }
    
    public String getMoMoEndpoint() {
        return getProperty("momo.endpoint");
    }
    
    public String getMoMoReturnUrl() {
        return getProperty("momo.return.url");
    }
    
    public String getMoMoNotifyUrl() {
        return getProperty("momo.notify.url");
    }
    
    // Application Settings
    public String getAppName() {
        return getProperty("app.name", "Flower Store");
    }
    
    public String getAppUrl() {
        return getProperty("app.url");
    }
    
    // Gemini AI Configuration
    public boolean isGeminiEnabled() {
        return getBooleanProperty("gemini.enabled", false);
    }
    
    public String getGeminiApiKey() {
        return getProperty("gemini.api.key");
    }
    
    public String getGeminiApiUrl() {
        return getProperty("gemini.api.url", "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent");
    }
    
    public String getGeminiModel() {
        return getProperty("gemini.model", "gemini-pro");
    }
    
    public double getGeminiTemperature() {
        String temp = getProperty("gemini.temperature", "0.8");
        try {
            return Double.parseDouble(temp);
        } catch (NumberFormatException e) {
            return 0.8;
        }
    }
    
    public int getGeminiMaxTokens() {
        String tokens = getProperty("gemini.max.tokens", "500");
        try {
            return Integer.parseInt(tokens);
        } catch (NumberFormatException e) {
            return 500;
        }
    }
}
