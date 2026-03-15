package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Script kiểm tra cấu hình VNPay
 * Chạy script này để xác minh config trước khi test
 */
public class VNPayConfigChecker {
    
    public static void main(String[] args) {
        System.out.println("╔═══════════════════════════════════════════════════════════╗");
        System.out.println("║         VNPAY CONFIGURATION CHECKER                       ║");
        System.out.println("║         Flower Store Web - VNPay Integration              ║");
        System.out.println("╚═══════════════════════════════════════════════════════════╝");
        System.out.println();
        
        Properties props = new Properties();
        
        try (InputStream input = VNPayConfigChecker.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            
            if (input == null) {
                System.out.println("❌ ERROR: Không tìm thấy file application.properties");
                System.out.println("   Đường dẫn: src/main/resources/application.properties");
                return;
            }
            
            props.load(input);
            
            // Check VNPay configuration
            System.out.println("📋 KIỂM TRA CẤU HÌNH VNPAY");
            System.out.println("─────────────────────────────────────────────────────────");
            
            checkConfig(props, "vnpay.enabled", "Trạng thái VNPay", false);
            checkConfig(props, "vnpay.url", "URL VNPay", false);
            checkConfig(props, "vnpay.return.url", "Return URL", false);
            checkConfig(props, "vnpay.tmn.code", "TMN Code", true);
            checkConfig(props, "vnpay.hash.secret", "Hash Secret", true);
            checkConfig(props, "vnpay.version", "Version", false);
            checkConfig(props, "vnpay.command", "Command", false);
            checkConfig(props, "vnpay.order.type", "Order Type", false);
            
            System.out.println();
            System.out.println("📊 PHÂN TÍCH CẤU HÌNH");
            System.out.println("─────────────────────────────────────────────────────────");
            
            // Analyze configuration
            String enabled = props.getProperty("vnpay.enabled", "false");
            String tmnCode = props.getProperty("vnpay.tmn.code", "");
            String hashSecret = props.getProperty("vnpay.hash.secret", "");
            String returnUrl = props.getProperty("vnpay.return.url", "");
            String vnpayUrl = props.getProperty("vnpay.url", "");
            
            // Check if enabled
            if ("true".equals(enabled)) {
                System.out.println("✅ VNPay: ENABLED");
            } else {
                System.out.println("❌ VNPay: DISABLED");
                System.out.println("   → Đổi vnpay.enabled=true để bật VNPay");
            }
            
            // Check environment
            if (vnpayUrl.contains("sandbox")) {
                System.out.println("🧪 Environment: SANDBOX (Test)");
                System.out.println("   → Sử dụng thẻ test để thanh toán");
            } else if (vnpayUrl.contains("vnpayment.vn")) {
                System.out.println("🚀 Environment: PRODUCTION (Live)");
                System.out.println("   → Giao dịch thật, thu phí thật");
            } else {
                System.out.println("⚠️  Environment: UNKNOWN");
            }
            
            // Check credentials
            if (isDefaultValue(tmnCode) || isDefaultValue(hashSecret)) {
                System.out.println("❌ Credentials: CHƯA CẤU HÌNH");
                System.out.println();
                System.out.println("⚠️  BẠN CẦN LÀM:");
                System.out.println("   1. Đăng ký tài khoản sandbox: https://sandbox.vnpayment.vn/devreg/");
                System.out.println("   2. Lấy TMN Code và Hash Secret");
                System.out.println("   3. Cập nhật vào application.properties:");
                System.out.println("      vnpay.tmn.code=YOUR_TMN_CODE");
                System.out.println("      vnpay.hash.secret=YOUR_HASH_SECRET");
            } else {
                System.out.println("✅ Credentials: ĐÃ CẤU HÌNH");
                System.out.println("   TMN Code: " + maskSecret(tmnCode));
                System.out.println("   Hash Secret: " + maskSecret(hashSecret));
            }
            
            // Check return URL
            if (returnUrl.contains("localhost")) {
                System.out.println("🏠 Return URL: LOCALHOST (Development)");
                System.out.println("   → OK cho test local");
                System.out.println("   → Khi deploy, đổi thành domain thật");
            } else if (returnUrl.startsWith("https://")) {
                System.out.println("🔒 Return URL: HTTPS (Secure)");
                System.out.println("   → Good! Production ready");
            } else if (returnUrl.startsWith("http://") && !returnUrl.contains("localhost")) {
                System.out.println("⚠️  Return URL: HTTP (Not Secure)");
                System.out.println("   → Production yêu cầu HTTPS!");
            }
            
            // Test cases
            System.out.println();
            System.out.println("🧪 THẺ TEST (CHỈ CHO SANDBOX)");
            System.out.println("─────────────────────────────────────────────────────────");
            System.out.println("Ngân hàng: NCB");
            System.out.println("Số thẻ: 9704198526191432198");
            System.out.println("Tên chủ thẻ: NGUYEN VAN A");
            System.out.println("Ngày phát hành: 07/15");
            System.out.println("Mật khẩu OTP: 123456");
            
            // Overall status
            System.out.println();
            System.out.println("═══════════════════════════════════════════════════════════");
            
            boolean isReady = "true".equals(enabled) 
                           && !isDefaultValue(tmnCode) 
                           && !isDefaultValue(hashSecret);
            
            if (isReady) {
                System.out.println("✅ TRẠNG THÁI: SẴN SÀNG TEST");
                System.out.println();
                System.out.println("Bước tiếp theo:");
                System.out.println("1. Chạy ứng dụng: mvn tomcat7:run");
                System.out.println("2. Truy cập: http://localhost:8080/flowerstore");
                System.out.println("3. Thêm sản phẩm vào giỏ hàng");
                System.out.println("4. Checkout → Chọn VNPay");
                System.out.println("5. Sử dụng thẻ test để thanh toán");
            } else {
                System.out.println("❌ TRẠNG THÁI: CHƯA SẴN SÀNG");
                System.out.println();
                System.out.println("Cần hoàn thiện:");
                if (!"true".equals(enabled)) {
                    System.out.println("• Bật VNPay (vnpay.enabled=true)");
                }
                if (isDefaultValue(tmnCode)) {
                    System.out.println("• Cập nhật TMN Code");
                }
                if (isDefaultValue(hashSecret)) {
                    System.out.println("• Cập nhật Hash Secret");
                }
                System.out.println();
                System.out.println("📖 Xem hướng dẫn chi tiết: VNPAY_SETUP_GUIDE.md");
            }
            
            System.out.println("═══════════════════════════════════════════════════════════");
            
        } catch (IOException ex) {
            System.out.println("❌ Lỗi đọc file configuration: " + ex.getMessage());
        }
    }
    
    /**
     * Kiểm tra một config property
     */
    private static void checkConfig(Properties props, String key, String name, boolean isSecret) {
        String value = props.getProperty(key);
        
        if (value == null || value.trim().isEmpty()) {
            System.out.printf("❌ %-20s : MISSING%n", name);
        } else {
            String displayValue = isSecret ? maskSecret(value) : value;
            
            // Check if default value
            if (isDefaultValue(value)) {
                System.out.printf("⚠️  %-20s : %s (DEFAULT - Cần thay đổi!)%n", name, displayValue);
            } else {
                System.out.printf("✅ %-20s : %s%n", name, displayValue);
            }
        }
    }
    
    /**
     * Mask secret values
     */
    private static String maskSecret(String value) {
        if (value == null || value.length() < 4) {
            return "***";
        }
        
        int showLength = Math.min(4, value.length() / 4);
        String show = value.substring(0, showLength);
        String masked = "*".repeat(Math.max(8, value.length() - showLength));
        
        return show + masked;
    }
    
    /**
     * Kiểm tra giá trị mặc định
     */
    private static boolean isDefaultValue(String value) {
        if (value == null || value.trim().isEmpty()) {
            return true;
        }
        
        String upper = value.toUpperCase();
        return upper.contains("YOUR_") 
            || upper.contains("CHANGE_ME")
            || upper.contains("REPLACE_")
            || upper.equals("TMN_CODE")
            || upper.equals("HASH_SECRET");
    }
}
