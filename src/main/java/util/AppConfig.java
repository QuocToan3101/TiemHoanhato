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

    private String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return null;
    }

    private boolean isPlaceholder(String value) {
        if (value == null) {
            return true;
        }
        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            return true;
        }
        return trimmed.startsWith("CHANGE_ME")
                || trimmed.startsWith("YOUR_")
                || trimmed.equalsIgnoreCase("your_client_id_here")
                || trimmed.equalsIgnoreCase("your_client_secret_here");
    }

    private String getSecretWithEnvFallback(String propertyKey, String... envKeys) {
        String envValue = null;
        if (envKeys != null) {
            for (String envKey : envKeys) {
                envValue = firstNonBlank(envValue, System.getenv(envKey), System.getProperty(envKey));
            }
        }

        if (!isPlaceholder(envValue)) {
            return envValue;
        }

        String propertyValue = getProperty(propertyKey);
        if (!isPlaceholder(propertyValue)) {
            return propertyValue.trim();
        }

        return propertyValue;
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

    public double getDoubleProperty(String key, double defaultValue) {
        String value = properties.getProperty(key);
        if (value == null) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    // Database Configuration
    public String getDbUrl() {
        return firstNonBlank(
                getProperty("db.url"),
                System.getenv("DB_URL"),
                System.getProperty("DB_URL")
        );
    }
    
    public String getDbUsername() {
        return firstNonBlank(
                getProperty("db.username"),
                System.getenv("DB_USERNAME"),
                System.getProperty("DB_USERNAME")
        );
    }
    
    public String getDbPassword() {
        String propertyValue = getProperty("db.password");
        if (propertyValue != null) {
            return propertyValue;
        }
        return firstNonBlank(System.getenv("DB_PASSWORD"), System.getProperty("DB_PASSWORD"));
    }
    
    // Email Configuration
    public String getEmailHost() {
        return firstNonBlank(
                System.getenv("EMAIL_SMTP_HOST"),
                System.getProperty("EMAIL_SMTP_HOST"),
                getProperty("email.smtp.host")
        );
    }
    
    public int getEmailPort() {
        String envPort = firstNonBlank(
                System.getenv("EMAIL_SMTP_PORT"),
                System.getProperty("EMAIL_SMTP_PORT")
        );
        if (envPort != null) {
            try {
                return Integer.parseInt(envPort);
            } catch (NumberFormatException ignored) {
                // Fallback to properties/default below.
            }
        }
        return getIntProperty("email.smtp.port", 587);
    }
    
    public String getEmailUsername() {
        return firstNonBlank(
                System.getenv("EMAIL_USERNAME"),
                System.getProperty("EMAIL_USERNAME"),
                System.getenv("SMTP_USERNAME"),
                System.getProperty("SMTP_USERNAME"),
                getProperty("email.username")
        );
    }
    
    public String getEmailPassword() {
        return getSecretWithEnvFallback(
                "email.password",
                "EMAIL_PASSWORD",
                "SMTP_PASSWORD",
                "GMAIL_APP_PASSWORD"
        );
    }
    
    public String getEmailFromName() {
        return firstNonBlank(
                System.getenv("EMAIL_FROM_NAME"),
                System.getProperty("EMAIL_FROM_NAME"),
                getProperty("email.from.name")
        );
    }
    
    public String getEmailFromAddress() {
        return firstNonBlank(
                System.getenv("EMAIL_FROM_ADDRESS"),
                System.getProperty("EMAIL_FROM_ADDRESS"),
                getProperty("email.from.address")
        );
    }
    
    public String getEmailAdminAddress() {
        return firstNonBlank(
                System.getenv("EMAIL_ADMIN_ADDRESS"),
                System.getProperty("EMAIL_ADMIN_ADDRESS"),
                getProperty("email.admin.address", getEmailFromAddress())
        );
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
    
    // Application Settings
    public String getAppName() {
        return getProperty("app.name", "Flower Store");
    }
    
    public String getAppUrl() {
        return firstNonBlank(
                System.getenv("APP_URL"),
                System.getProperty("APP_URL"),
                getProperty("app.url")
        );
    }

    /**
     * Upload directory for user-uploaded files.
     * Priority: ENV UPLOAD_DIR -> system property UPLOAD_DIR -> application.properties app.upload.directory -> default 'uploads'
     */
    public String getUploadDirectory() {
        return firstNonBlank(
                System.getenv("UPLOAD_DIR"),
                System.getProperty("UPLOAD_DIR"),
                getProperty("app.upload.directory", "uploads")
        );
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

    // ML Image Search Configuration
    public boolean isMlImageSearchEnabled() {
        String env = firstNonBlank(
                System.getenv("ML_IMAGE_SEARCH_ENABLED"),
                System.getProperty("ML_IMAGE_SEARCH_ENABLED")
        );
        if (env != null) {
            return Boolean.parseBoolean(env);
        }
        return getBooleanProperty("ml.image_search.enabled", true);
    }

    public String getMlImageSearchBaseUrl() {
        return firstNonBlank(
                System.getenv("ML_IMAGE_SEARCH_URL"),
                System.getProperty("ML_IMAGE_SEARCH_URL"),
                getProperty("ml.image_search.url", "http://127.0.0.1:5000")
        );
    }

    public int getMlImageSearchTimeoutMs() {
        String env = firstNonBlank(
                System.getenv("ML_IMAGE_SEARCH_TIMEOUT_MS"),
                System.getProperty("ML_IMAGE_SEARCH_TIMEOUT_MS")
        );
        if (env != null) {
            try {
                return Integer.parseInt(env);
            } catch (NumberFormatException ignored) {
                // Fallback to property/default below.
            }
        }
        return getIntProperty("ml.image_search.timeout_ms", 20000);
    }

    public boolean isMlImageSearchAutoStartEnabled() {
        String env = firstNonBlank(
                System.getenv("ML_IMAGE_SEARCH_AUTOSTART"),
                System.getProperty("ML_IMAGE_SEARCH_AUTOSTART")
        );
        if (env != null) {
            return Boolean.parseBoolean(env);
        }
        return getBooleanProperty("ml.image_search.autostart", true);
    }

    public String getMlImageSearchPythonCommand() {
        return firstNonBlank(
                System.getenv("ML_IMAGE_SEARCH_PYTHON"),
                System.getProperty("ML_IMAGE_SEARCH_PYTHON"),
                getProperty("ml.image_search.python_command", "python")
        );
    }

    public String getMlImageSearchWorkingDir() {
        return firstNonBlank(
                System.getenv("ML_IMAGE_SEARCH_WORKING_DIR"),
                System.getProperty("ML_IMAGE_SEARCH_WORKING_DIR"),
                getProperty("ml.image_search.working_dir", "ml-service")
        );
    }

    public int getMlImageSearchStartupTimeoutMs() {
        String env = firstNonBlank(
                System.getenv("ML_IMAGE_SEARCH_STARTUP_TIMEOUT_MS"),
                System.getProperty("ML_IMAGE_SEARCH_STARTUP_TIMEOUT_MS")
        );
        if (env != null) {
            try {
                return Integer.parseInt(env);
            } catch (NumberFormatException ignored) {
                // Fallback to property/default below.
            }
        }
        return getIntProperty("ml.image_search.startup_timeout_ms", 40000);
    }
}
