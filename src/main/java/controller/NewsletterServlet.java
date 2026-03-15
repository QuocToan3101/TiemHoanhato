package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonObject;

import service.EmailService;
import util.DBConnection;

/**
 * Servlet xử lý đăng ký newsletter
 */
@WebServlet("/api/newsletter/subscribe")
public class NewsletterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String email = request.getParameter("email");
            
            if (email == null || email.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Email không được để trống");
                out.print(jsonResponse.toString());
                return;
            }
            
            email = email.trim().toLowerCase();
            
            // Validate email format
            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Email không hợp lệ");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Save to database (nếu bảng newsletter_subscribers tồn tại)
            // Hoặc có thể chỉ log email
            try (Connection conn = DBConnection.getInstance().getConnection()) {
                // Kiểm tra email đã tồn tại chưa
                String checkSql = "SELECT COUNT(*) FROM users WHERE email = ?";
                try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                    checkPs.setString(1, email);
                    var rs = checkPs.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        jsonResponse.addProperty("success", true);
                        jsonResponse.addProperty("message", "Email đã được đăng ký. Cảm ơn bạn!");
                        out.print(jsonResponse.toString());
                        return;
                    }
                }
                
                // Tạo bảng newsletter_subscribers nếu chưa có
                String createTableSql = "CREATE TABLE IF NOT EXISTS newsletter_subscribers (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "email VARCHAR(255) NOT NULL UNIQUE, " +
                        "subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "is_active BOOLEAN DEFAULT TRUE, " +
                        "INDEX idx_email (email)" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                
                try (PreparedStatement createPs = conn.prepareStatement(createTableSql)) {
                    createPs.execute();
                }
                
                // Insert email
                String insertSql = "INSERT INTO newsletter_subscribers (email) VALUES (?) " +
                        "ON DUPLICATE KEY UPDATE is_active = TRUE, subscribed_at = CURRENT_TIMESTAMP";
                
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setString(1, email);
                    insertPs.executeUpdate();
                }
                
                // Tạo mã giảm giá cho người dùng
                String couponCode = generateUniqueCouponCode();
                boolean couponCreated = createWelcomeCoupon(conn, couponCode, email);
                
                if (couponCreated) {
                    // Gửi email với mã giảm giá
                    sendWelcomeEmail(email, couponCode);
                    
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Đăng ký thành công! Mã giảm giá 10% đã được gửi đến email của bạn.");
                    jsonResponse.addProperty("couponCode", couponCode);
                } else {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Đăng ký thành công! Cảm ơn bạn đã đăng ký nhận tin.");
                }
                
            } catch (Exception e) {
                System.err.println("[NewsletterServlet] Database error: " + e.getMessage());
                e.printStackTrace();
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            }
            
        } catch (Exception e) {
            System.err.println("[NewsletterServlet] Error: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra. Vui lòng thử lại sau.");
        }
        
        out.print(jsonResponse.toString());
    }
    
    /**
     * Tạo mã coupon unique
     */
    private String generateUniqueCouponCode() {
        String prefix = "WELCOME";
        String uniquePart = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return prefix + uniquePart;
    }
    
    /**
     * Tạo coupon chào mừng giảm 10%
     */
    private boolean createWelcomeCoupon(Connection conn, String couponCode, String email) {
        String sql = "INSERT INTO coupons (code, discount_type, discount_value, min_order_value, " +
                     "max_discount_amount, usage_limit, used_count, valid_from, valid_to, " +
                     "is_active, description, created_at) " +
                     "VALUES (?, 'percentage', 10, 0, 50000, 1, 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), " +
                     "TRUE, ?, NOW())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, couponCode);
            ps.setString(2, "Mã giảm giá 10% chào mừng khách hàng mới đăng ký newsletter - " + email);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Lỗi tạo coupon: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email chào mừng với mã giảm giá
     */
    private void sendWelcomeEmail(String toEmail, String couponCode) {
        try {
            String subject = "🎉 Chào mừng bạn đến với Tiệm Hoa Nhà Tôi!";
            
            String htmlBody = "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Arial, sans-serif; line-height: 1.6; color: #333; }" +
                ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                ".header { background: linear-gradient(135deg, #c89f7f 0%, #a67c5f 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
                ".content { background: #fff; padding: 30px; border: 1px solid #e0e0e0; }" +
                ".coupon-box { background: #f8f9fa; border: 2px dashed #c89f7f; padding: 20px; margin: 20px 0; text-align: center; border-radius: 8px; }" +
                ".coupon-code { font-size: 28px; font-weight: bold; color: #c89f7f; letter-spacing: 2px; margin: 10px 0; }" +
                ".discount-info { color: #28a745; font-size: 18px; font-weight: bold; margin: 10px 0; }" +
                ".btn { display: inline-block; background: #c89f7f; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; margin: 15px 0; }" +
                ".footer { text-align: center; padding: 20px; color: #666; font-size: 14px; }" +
                ".highlight { color: #c89f7f; font-weight: bold; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🌸 Tiệm Hoa Nhà Tôi 🌸</h1>" +
                "<p>Cảm ơn bạn đã đăng ký nhận tin!</p>" +
                "</div>" +
                "<div class='content'>" +
                "<h2>Xin chào! 👋</h2>" +
                "<p>Chào mừng bạn đến với <strong>Tiệm Hoa Nhà Tôi</strong> - nơi mang đến những bó hoa tươi đẹp nhất cho mọi dịp đặc biệt!</p>" +
                "<p>Để chào đón bạn, chúng tôi gửi tặng bạn một món quà đặc biệt:</p>" +
                "<div class='coupon-box'>" +
                "<div class='discount-info'>🎁 GIẢM GIÁ 10% 🎁</div>" +
                "<p>Mã giảm giá của bạn:</p>" +
                "<div class='coupon-code'>" + couponCode + "</div>" +
                "<p style='color: #666; font-size: 14px; margin-top: 15px;'>" +
                "✨ Giảm tối đa 50,000đ<br>" +
                "📅 Có hiệu lực trong 30 ngày<br>" +
                "🎯 Sử dụng 1 lần</p>" +
                "</div>" +
                "<h3>📝 Cách sử dụng:</h3>" +
                "<ol>" +
                "<li>Chọn sản phẩm yêu thích và thêm vào giỏ hàng</li>" +
                "<li>Tại trang thanh toán, nhập mã <span class='highlight'>" + couponCode + "</span></li>" +
                "<li>Nhấn \"Áp dụng\" để nhận ưu đãi ngay!</li>" +
                "</ol>" +
                "<div style='text-align: center; margin-top: 30px;'>" +
                "<a href='http://tiemhoanhato.site/flowerstore/products' class='btn'>🛍️ Mua Sắm Ngay</a>" +
                "</div>" +
                "<hr style='margin: 30px 0; border: none; border-top: 1px solid #e0e0e0;'>" +
                "<h3>🌟 Tại sao chọn chúng tôi?</h3>" +
                "<ul>" +
                "<li>🌺 Hoa tươi 100% nhập khẩu và trong nước</li>" +
                "<li>🚚 Giao hàng nhanh chóng trong 2 giờ</li>" +
                "<li>💝 Thiết kế theo yêu cầu</li>" +
                "<li>💯 Cam kết chất lượng hoàn tiền</li>" +
                "</ul>" +
                "<p style='margin-top: 30px;'>Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi!</p>" +
                "<p>Trân trọng,<br><strong>Đội ngũ Tiệm Hoa Nhà Tôi</strong> 🌸</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>📧 Email: duongquoctoan3101@gmail.com<br>" +
                "🌐 Website: <a href='http://tiemhoanhato.site/flowerstore'>tiemhoanhato.site</a></p>" +
                "<p style='font-size: 12px; color: #999; margin-top: 15px;'>" +
                "Bạn nhận được email này vì đã đăng ký nhận tin từ Tiệm Hoa Nhà Tôi.<br>" +
                "Nếu không muốn nhận email, vui lòng <a href='#'>hủy đăng ký</a>.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
            
            EmailService emailService = EmailService.getInstance();
            boolean sent = emailService.sendEmail(toEmail, subject, htmlBody, true);
            
            if (sent) {
                System.out.println("[NewsletterServlet] Email sent successfully to: " + toEmail);
            } else {
                System.err.println("[NewsletterServlet] Failed to send email to: " + toEmail);
            }
            
        } catch (Exception e) {
            System.err.println("[NewsletterServlet] Error sending email: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
