package service;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import util.AppConfig;

/**
 * Service để gửi email
 */
public class EmailService {
    
    private static EmailService instance;
    private AppConfig config;
    
    private EmailService() {
        config = AppConfig.getInstance();
    }
    
    public static synchronized EmailService getInstance() {
        if (instance == null) {
            instance = new EmailService();
        }
        return instance;
    }
    
    /**
     * Gửi email
     */
    public boolean sendEmail(String toEmail, String subject, String body) {
        return sendEmail(toEmail, subject, body, false);
    }
    
    /**
     * Gửi email với HTML content
     */
    public boolean sendEmail(String toEmail, String subject, String htmlBody, boolean isHtml) {
        return sendEmailWithAttachment(toEmail, subject, htmlBody, isHtml, null);
    }
    
    /**
     * Gửi email với HTML content và attachment (thiệp chúc mừng)
     */
    public boolean sendEmailWithAttachment(String toEmail, String subject, String htmlBody, 
                                          boolean isHtml, byte[] attachmentBytes) {
        try {
            // Cấu hình properties
            Properties props = new Properties();
            props.put("mail.smtp.host", config.getEmailHost());
            props.put("mail.smtp.port", config.getEmailPort());
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            // Tạo session với authentication
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(
                        config.getEmailUsername(),
                        config.getEmailPassword()
                    );
                }
            });
            
            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(
                config.getEmailFromAddress(),
                config.getEmailFromName()
            ));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            
            if (attachmentBytes != null && attachmentBytes.length > 0) {
                // Email với attachment
                MimeMultipart multipart = new MimeMultipart();
                
                // HTML body part
                MimeBodyPart htmlPart = new MimeBodyPart();
                if (isHtml) {
                    htmlPart.setContent(htmlBody, "text/html; charset=UTF-8");
                } else {
                    htmlPart.setText(htmlBody);
                }
                multipart.addBodyPart(htmlPart);
                
                // Greeting card image attachment
                MimeBodyPart attachmentPart = new MimeBodyPart();
                javax.activation.DataSource source = new javax.mail.util.ByteArrayDataSource(
                    attachmentBytes, "image/png"
                );
                attachmentPart.setDataHandler(new javax.activation.DataHandler(source));
                attachmentPart.setFileName("greeting-card.png");
                multipart.addBodyPart(attachmentPart);
                
                message.setContent(multipart);
                
            } else {
                // Email không có attachment
                if (isHtml) {
                    message.setContent(htmlBody, "text/html; charset=UTF-8");
                } else {
                    message.setText(htmlBody);
                }
            }
            
            // Gửi email
            Transport.send(message);
            
            System.out.println("Email đã được gửi thành công đến: " + toEmail + 
                (attachmentBytes != null ? " (kèm thiệp chúc mừng)" : ""));
            return true;
            
        } catch (Exception e) {
            System.err.println("Lỗi khi gửi email: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Gửi email xác nhận đơn hàng (có thể kèm thiệp chúc mừng)
     */
    public boolean sendOrderConfirmation(String toEmail, String customerName, 
                                        String orderCode, String orderTotal) {
        return sendOrderConfirmation(toEmail, customerName, orderCode, orderTotal, null);
    }
    
    /**
     * Gửi email xác thực tài khoản
     */
    public boolean sendVerificationEmail(String toEmail, String customerName, String verificationLink) {
        String subject = "Xác thực tài khoản - " + config.getAppName();
        
        String htmlBody = buildVerificationEmail(customerName, verificationLink);
        
        return sendEmail(toEmail, subject, htmlBody, true);
    }
    
    /**
     * Gửi email xác nhận đơn hàng với thiệp chúc mừng đính kèm
     */
    public boolean sendOrderConfirmation(String toEmail, String customerName, 
                                        String orderCode, String orderTotal, 
                                        byte[] greetingCardImage) {
        String subject = "Xác nhận đơn hàng #" + orderCode;
        
        String htmlBody = buildOrderConfirmationEmail(customerName, orderCode, orderTotal, 
            greetingCardImage != null);
        
        return sendEmailWithAttachment(toEmail, subject, htmlBody, true, greetingCardImage);
    }
    
    /**
     * Gửi email reset mật khẩu
     */
    public boolean sendPasswordResetEmail(String toEmail, String customerName, String resetToken) {
        String subject = "Yêu cầu đặt lại mật khẩu - " + config.getAppName();
        
        String resetUrl = config.getAppUrl() + "/reset-password?token=" + resetToken;
        
        String htmlBody = buildPasswordResetEmail(customerName, resetUrl);
        
        return sendEmail(toEmail, subject, htmlBody, true);
    }
    
    /**
     * Gửi email cập nhật trạng thái đơn hàng
     */
    public boolean sendOrderStatusUpdate(String toEmail, String customerName, 
                                         String orderCode, String status) {
        String subject = "Cập nhật đơn hàng #" + orderCode;
        
        String htmlBody = buildOrderStatusEmail(customerName, orderCode, status);
        
        return sendEmail(toEmail, subject, htmlBody, true);
    }
    
    /**
     * Gửi thông báo cho admin về đơn hàng có yêu cầu in thiệp
     */
    public boolean sendAdminPrintCardNotification(String orderCode, String customerName,
                                                  String customerPhone, String shippingAddress,
                                                  byte[] greetingCardImage) {
        String adminEmail = config.getEmailAdminAddress();
        String subject = "🖨️ YÊU CẦU IN THIỆP - Đơn hàng #" + orderCode;
        
        String htmlBody = buildAdminPrintCardEmail(orderCode, customerName, 
                                                    customerPhone, shippingAddress);
        
        return sendEmailWithAttachment(adminEmail, subject, htmlBody, true, greetingCardImage);
    }
    
    /**
     * Build HTML email thông báo admin in thiệp
     */
    private String buildAdminPrintCardEmail(String orderCode, String customerName,
                                            String customerPhone, String shippingAddress) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            ".header { background: #ff6b6b; color: white; padding: 20px; text-align: center; }" +
            ".content { padding: 20px; background: #f9f9f9; }" +
            ".alert-box { background: #fff3cd; border: 2px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 8px; }" +
            ".order-info { background: white; padding: 15px; margin: 20px 0; border-left: 4px solid #ff6b6b; }" +
            ".footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }" +
            ".highlight { background: #ffe0e0; padding: 10px; border-radius: 5px; margin: 10px 0; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>🖨️ YÊU CẦU IN THIỆP</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<div class='alert-box'>" +
            "<h3 style='margin: 0 0 10px 0; color: #856404;'>⚠️ HÀNH ĐỘNG CẦN LÀM</h3>" +
            "<p style='margin: 0;'>Khách hàng yêu cầu <strong>IN THIỆP VÀ GỬI KÈM HOA</strong> cho đơn hàng này!</p>" +
            "</div>" +
            "<div class='order-info'>" +
            "<h3>Thông tin đơn hàng:</h3>" +
            "<p><strong>📦 Mã đơn hàng:</strong> " + orderCode + "</p>" +
            "<p><strong>👤 Khách hàng:</strong> " + customerName + "</p>" +
            "<p><strong>📞 Số điện thoại:</strong> " + customerPhone + "</p>" +
            "<p><strong>📍 Địa chỉ giao hàng:</strong> " + shippingAddress + "</p>" +
            "</div>" +
            "<div class='highlight'>" +
            "<h4 style='margin: 0 0 10px 0;'>📋 Các bước cần làm:</h4>" +
            "<ol style='margin: 5px 0; padding-left: 20px;'>" +
            "<li>Mở file thiệp đính kèm trong email này</li>" +
            "<li>In thiệp ra giấy chất lượng cao (khuyến nghị: giấy ảnh hoặc giấy mỹ thuật)</li>" +
            "<li>Đặt thiệp vào phong bì đẹp</li>" +
            "<li>Gửi kèm thiệp cùng với hoa tới địa chỉ của khách hàng</li>" +
            "</ol>" +
            "</div>" +
            "<p style='background: #e7f3ff; padding: 15px; border-left: 4px solid #2196F3; margin: 20px 0;'>" +
            "💡 <strong>Lưu ý:</strong> File thiệp được đính kèm trong email này có định dạng PNG, " +
            "sẵn sàng để in với chất lượng cao nhất!" +
            "</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>Email tự động từ hệ thống Flower Store</p>" +
            "<p>&copy; 2026 Tiệm Hoa nhà tớ. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build HTML email xác nhận đơn hàng
     */
    private String buildOrderConfirmationEmail(String customerName, String orderCode, 
                                              String orderTotal, boolean hasGreetingCard) {
        String greetingCardNote = hasGreetingCard ? 
            "<p style='padding: 15px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 8px; margin: 20px 0;'>" +
            "🎁 <strong>Đặc biệt:</strong> Thiệp chúc mừng đẹp được tạo bằng AI đã được đính kèm trong email này! " +
            "Hãy mở file đính kèm để xem thiệp đầy ấn tượng nhé! 💌" +
            "</p>" : "";
        
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            ".header { background: #c99366; color: white; padding: 20px; text-align: center; }" +
            ".content { padding: 20px; background: #f9f9f9; }" +
            ".order-info { background: white; padding: 15px; margin: 20px 0; border-left: 4px solid #c99366; }" +
            ".footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }" +
            ".button { display: inline-block; padding: 10px 20px; background: #c99366; color: white; text-decoration: none; border-radius: 5px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>Tiệm Hoa nhà tớ</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Xin chào " + customerName + ",</h2>" +
            "<p>Cảm ơn bạn đã đặt hàng tại <strong>Tiệm Hoa nhà tớ</strong>!</p>" +
            greetingCardNote +
            "<div class='order-info'>" +
            "<h3>Thông tin đơn hàng:</h3>" +
            "<p><strong>Mã đơn hàng:</strong> " + orderCode + "</p>" +
            "<p><strong>Tổng tiền:</strong> " + orderTotal + "</p>" +
            "<p><strong>Trạng thái:</strong> Đang xử lý</p>" +
            "</div>" +
            "<p>Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận đơn hàng.</p>" +
            "<p style='text-align: center; margin: 30px 0;'>" +
            "<a href='" + config.getAppUrl() + "/orders' class='button'>Xem đơn hàng</a>" +
            "</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>Đây là email tự động, vui lòng không trả lời email này.</p>" +
            "<p>&copy; 2026 Tiệm Hoa nhà tớ. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build HTML email reset password
     */
    private String buildPasswordResetEmail(String customerName, String resetUrl) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            ".header { background: #c99366; color: white; padding: 20px; text-align: center; }" +
            ".content { padding: 20px; background: #f9f9f9; }" +
            ".button { display: inline-block; padding: 12px 30px; background: #c99366; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }" +
            ".warning { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; }" +
            ".footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>Tiệm Hoa nhà tớ</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Xin chào " + customerName + ",</h2>" +
            "<p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>" +
            "<p style='text-align: center;'>" +
            "<a href='" + resetUrl + "' class='button'>Đặt lại mật khẩu</a>" +
            "</p>" +
            "<div class='warning'>" +
            "<p><strong>Lưu ý:</strong></p>" +
            "<ul>" +
            "<li>Link này chỉ có hiệu lực trong 1 giờ</li>" +
            "<li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>" +
            "</ul>" +
            "</div>" +
            "<p>Nếu nút bên trên không hoạt động, copy link sau vào trình duyệt:</p>" +
            "<p style='word-break: break-all; color: #666; font-size: 12px;'>" + resetUrl + "</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>Đây là email tự động, vui lòng không trả lời email này.</p>" +
            "<p>&copy; 2026 Tiệm Hoa nhà tớ. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build HTML email cập nhật trạng thái
     */
    private String buildOrderStatusEmail(String customerName, String orderCode, String status) {
        String statusText = getStatusText(status);
        String statusColor = getStatusColor(status);
        
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            ".header { background: #c99366; color: white; padding: 20px; text-align: center; }" +
            ".content { padding: 20px; background: #f9f9f9; }" +
            ".status { padding: 15px; margin: 20px 0; border-left: 4px solid " + statusColor + "; background: white; }" +
            ".footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }" +
            ".button { display: inline-block; padding: 10px 20px; background: #c99366; color: white; text-decoration: none; border-radius: 5px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>Tiệm Hoa nhà tớ</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Xin chào " + customerName + ",</h2>" +
            "<p>Đơn hàng của bạn đã được cập nhật trạng thái.</p>" +
            "<div class='status'>" +
            "<p><strong>Mã đơn hàng:</strong> " + orderCode + "</p>" +
            "<p><strong>Trạng thái:</strong> <span style='color: " + statusColor + ";'>" + statusText + "</span></p>" +
            "</div>" +
            "<p style='text-align: center;'>" +
            "<a href='" + config.getAppUrl() + "/orders' class='button'>Xem chi tiết</a>" +
            "</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>Cảm ơn bạn đã tin tưởng Tiệm Hoa nhà tớ!</p>" +
            "<p>&copy; 2026 Tiệm Hoa nhà tớ. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build HTML email xác thực tài khoản
     */
    private String buildVerificationEmail(String customerName, String verificationLink) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
            ".content { padding: 30px; background: #f9f9f9; }" +
            ".verify-box { background: white; padding: 20px; margin: 20px 0; border-radius: 8px; text-align: center; }" +
            ".footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }" +
            ".button { display: inline-block; padding: 15px 40px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white !important; text-decoration: none; border-radius: 8px; font-weight: bold; margin: 20px 0; }" +
            ".button:hover { opacity: 0.9; }" +
            ".emoji { font-size: 48px; margin: 20px 0; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>🌸 Tiệm Hoa nhà tớ</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Xin chào " + customerName + ",</h2>" +
            "<p>Cảm ơn bạn đã đăng ký tài khoản tại <strong>Tiệm Hoa nhà tớ</strong>!</p>" +
            "<p>Để hoàn tất đăng ký và kích hoạt tài khoản, vui lòng nhấn vào nút bên dưới:</p>" +
            "<div class='verify-box'>" +
            "<div class='emoji'>✉️</div>" +
            "<a href='" + verificationLink + "' class='button'>Xác thực tài khoản ngay</a>" +
            "<p style='margin-top: 20px; font-size: 12px; color: #666;'>Hoặc copy link này vào trình duyệt:</p>" +
            "<p style='font-size: 11px; color: #999; word-break: break-all;'>" + verificationLink + "</p>" +
            "</div>" +
            "<p><strong>⏰ Lưu ý:</strong> Link xác thực sẽ hết hạn sau 24 giờ.</p>" +
            "<p>Nếu bạn không đăng ký tài khoản này, vui lòng bỏ qua email này.</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>Cảm ơn bạn đã tin tưởng Tiệm Hoa nhà tớ!</p>" +
            "<p>📞 Hotline: 0123 456 789 | 📧 Email: support@tiemhoanhato.vn</p>" +
            "<p>&copy; 2026 Tiệm Hoa nhà tớ. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    private String getStatusText(String status) {
        switch (status) {
            case "pending": return "Chờ xác nhận";
            case "confirmed": return "Đã xác nhận";
            case "processing": return "Đang xử lý";
            case "shipping": return "Đang giao hàng";
            case "delivered": return "Đã giao hàng";
            case "cancelled": return "Đã hủy";
            default: return status;
        }
    }
    
    private String getStatusColor(String status) {
        switch (status) {
            case "pending": return "#ffc107";
            case "confirmed": return "#17a2b8";
            case "processing": return "#007bff";
            case "shipping": return "#6f42c1";
            case "delivered": return "#28a745";
            case "cancelled": return "#dc3545";
            default: return "#6c757d";
        }
    }
}
