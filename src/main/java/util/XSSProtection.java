package util;

import org.owasp.encoder.Encode;

/**
 * XSS Protection Utility
 * Cung cấp các phương thức để chống tấn công Cross-Site Scripting
 */
public class XSSProtection {
    
    /**
     * Escape HTML để hiển thị an toàn
     */
    public static String escapeHtml(String input) {
        if (input == null) {
            return null;
        }
        return Encode.forHtml(input);
    }
    
    /**
     * Escape cho HTML attribute
     */
    public static String escapeHtmlAttribute(String input) {
        if (input == null) {
            return null;
        }
        return Encode.forHtmlAttribute(input);
    }
    
    /**
     * Escape cho JavaScript
     */
    public static String escapeJavaScript(String input) {
        if (input == null) {
            return null;
        }
        return Encode.forJavaScript(input);
    }
    
    /**
     * Escape cho URL
     */
    public static String escapeUrl(String input) {
        if (input == null) {
            return null;
        }
        return Encode.forUriComponent(input);
    }
    
    /**
     * Escape cho CSS
     */
    public static String escapeCss(String input) {
        if (input == null) {
            return null;
        }
        return Encode.forCssString(input);
    }
    
    /**
     * Sanitize input - loại bỏ các ký tự nguy hiểm
     */
    public static String sanitize(String input) {
        if (input == null) {
            return null;
        }
        
        // Loại bỏ script tags
        String cleaned = input.replaceAll("<script[^>]*>.*?</script>", "");
        
        // Loại bỏ các tag nguy hiểm khác
        cleaned = cleaned.replaceAll("<iframe[^>]*>.*?</iframe>", "");
        cleaned = cleaned.replaceAll("<object[^>]*>.*?</object>", "");
        cleaned = cleaned.replaceAll("<embed[^>]*>", "");
        
        // Loại bỏ javascript: trong href
        cleaned = cleaned.replaceAll("javascript:", "");
        
        // Loại bỏ on* event handlers
        cleaned = cleaned.replaceAll("\\s*on\\w+\\s*=", "");
        
        return cleaned;
    }
    
    /**
     * Validate và làm sạch số điện thoại
     */
    public static String sanitizePhone(String phone) {
        if (phone == null) {
            return null;
        }
        // Chỉ giữ lại số và dấu +
        return phone.replaceAll("[^0-9+]", "");
    }
    
    /**
     * Validate và làm sạch email
     */
    public static String sanitizeEmail(String email) {
        if (email == null) {
            return null;
        }
        // Chuyển về lowercase và trim
        email = email.toLowerCase().trim();
        
        // Validate format cơ bản
        if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            return null;
        }
        
        return email;
    }
}
