package service;

import java.awt.*;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;

/**
 * Service để tạo thiệp hình ảnh đẹp với Typography chuyên nghiệp
 */
public class CardImageGenerator {
    
    private static final int CARD_WIDTH = 800;
    private static final int CARD_HEIGHT = 600;
    private static final int PADDING = 60;
    private static final int CORNER_RADIUS = 30;
    
    /**
     * Tạo ảnh thiệp từ text message
     * 
     * @param message Nội dung thiệp
     * @param occasion Dịp (để chọn màu phù hợp)
     * @return BufferedImage của thiệp
     */
    public BufferedImage generateCardImage(String message, String occasion) {
        // Tạo BufferedImage với kích thước chuẩn
        BufferedImage image = new BufferedImage(CARD_WIDTH, CARD_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();
        
        // Bật anti-aliasing cho chữ và hình đẹp hơn
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        
        // Vẽ background gradient tùy theo dịp
        drawBackgroundGradient(g2d, occasion);
        
        // Vẽ border bo góc
        drawRoundedBorder(g2d);
        
        // Vẽ decorative elements (hoa lá)
        drawDecorativeElements(g2d, occasion);
        
        // Vẽ text message với typography đẹp
        drawMessage(g2d, message);
        
        // Vẽ footer branding
        drawFooter(g2d);
        
        g2d.dispose();
        return image;
    }
    
    /**
     * Vẽ gradient background theo dịp
     */
    private void drawBackgroundGradient(Graphics2D g2d, String occasion) {
        Color color1, color2;
        
        switch (occasion != null ? occasion : "khac") {
            case "sinhnhat":
                // Hồng pastel cho sinh nhật
                color1 = new Color(255, 200, 221);
                color2 = new Color(255, 175, 204);
                break;
            case "kyniem":
                // Đỏ romantic cho kỷ niệm
                color1 = new Color(255, 182, 193);
                color2 = new Color(255, 105, 135);
                break;
            case "camtaden":
                // Vàng ấm cho cảm ơn
                color1 = new Color(255, 245, 220);
                color2 = new Color(255, 218, 185);
                break;
            case "khaitruong":
                // Đỏ vàng may mắn cho khai trương
                color1 = new Color(255, 215, 0);
                color2 = new Color(255, 140, 0);
                break;
            case "totnghiep":
                // Xanh dương tươi sáng cho tốt nghiệp
                color1 = new Color(173, 216, 230);
                color2 = new Color(135, 206, 250);
                break;
            default:
                // Lavender nhẹ nhàng mặc định
                color1 = new Color(230, 230, 250);
                color2 = new Color(216, 191, 216);
        }
        
        GradientPaint gradient = new GradientPaint(0, 0, color1, 0, CARD_HEIGHT, color2);
        g2d.setPaint(gradient);
        g2d.fillRect(0, 0, CARD_WIDTH, CARD_HEIGHT);
    }
    
    /**
     * Vẽ border bo góc
     */
    private void drawRoundedBorder(Graphics2D g2d) {
        g2d.setColor(new Color(255, 255, 255, 180));
        g2d.setStroke(new BasicStroke(3));
        RoundRectangle2D border = new RoundRectangle2D.Double(
            15, 15, CARD_WIDTH - 30, CARD_HEIGHT - 30, CORNER_RADIUS, CORNER_RADIUS
        );
        g2d.draw(border);
    }
    
    /**
     * Vẽ các elements trang trí (hoa, lá)
     */
    private void drawDecorativeElements(Graphics2D g2d, String occasion) {
        // Vẽ emoji hoa ở 4 góc
        Font emojiFont = new Font("Segoe UI Emoji", Font.PLAIN, 50);
        g2d.setFont(emojiFont);
        
        String emoji = getEmojiForOccasion(occasion);
        
        // Góc trái trên
        g2d.setColor(new Color(255, 255, 255, 150));
        g2d.drawString(emoji, 40, 70);
        
        // Góc phải trên
        g2d.drawString(emoji, CARD_WIDTH - 90, 70);
        
        // Góc trái dưới
        g2d.drawString(emoji, 40, CARD_HEIGHT - 30);
        
        // Góc phải dưới
        g2d.drawString(emoji, CARD_WIDTH - 90, CARD_HEIGHT - 30);
        
        // Vẽ decorative line
        g2d.setStroke(new BasicStroke(2, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        g2d.setColor(new Color(255, 255, 255, 100));
        g2d.drawLine(PADDING + 50, 100, CARD_WIDTH - PADDING - 50, 100);
        g2d.drawLine(PADDING + 50, CARD_HEIGHT - 100, CARD_WIDTH - PADDING - 50, CARD_HEIGHT - 100);
    }
    
    /**
     * Vẽ message với typography đẹp
     */
    private void drawMessage(Graphics2D g2d, String message) {
        // Font cho nội dung chính
        Font messageFont = new Font("Arial", Font.PLAIN, 22);
        g2d.setFont(messageFont);
        g2d.setColor(new Color(50, 50, 50));
        
        // Tính toán và vẽ từng dòng
        FontMetrics fm = g2d.getFontMetrics();
        String[] lines = wrapText(message, CARD_WIDTH - 2 * PADDING - 100, fm);
        
        int lineHeight = fm.getHeight();
        int totalHeight = lines.length * lineHeight;
        int startY = (CARD_HEIGHT - totalHeight) / 2 + fm.getAscent();
        
        for (int i = 0; i < lines.length; i++) {
            int lineWidth = fm.stringWidth(lines[i]);
            int x = (CARD_WIDTH - lineWidth) / 2;
            int y = startY + i * lineHeight;
            
            // Vẽ shadow nhẹ
            g2d.setColor(new Color(255, 255, 255, 200));
            g2d.drawString(lines[i], x + 2, y + 2);
            
            // Vẽ text chính
            g2d.setColor(new Color(50, 50, 50));
            g2d.drawString(lines[i], x, y);
        }
    }
    
    /**
     * Vẽ footer branding
     */
    private void drawFooter(Graphics2D g2d) {
        Font footerFont = new Font("Arial", Font.ITALIC, 14);
        g2d.setFont(footerFont);
        g2d.setColor(new Color(100, 100, 100, 150));
        
        String footer = "🌸 Tiệm Hoa nhà tôi 🌸";
        FontMetrics fm = g2d.getFontMetrics();
        int footerWidth = fm.stringWidth(footer);
        int x = (CARD_WIDTH - footerWidth) / 2;
        int y = CARD_HEIGHT - 40;
        
        g2d.drawString(footer, x, y);
    }
    
    /**
     * Tự động xuống dòng cho text
     */
    private String[] wrapText(String text, int maxWidth, FontMetrics fm) {
        String[] words = text.split("\\s+");
        java.util.List<String> lines = new java.util.ArrayList<>();
        StringBuilder currentLine = new StringBuilder();
        
        for (String word : words) {
            String testLine = currentLine.length() == 0 ? word : currentLine + " " + word;
            int width = fm.stringWidth(testLine);
            
            if (width <= maxWidth) {
                if (currentLine.length() > 0) {
                    currentLine.append(" ");
                }
                currentLine.append(word);
            } else {
                if (currentLine.length() > 0) {
                    lines.add(currentLine.toString());
                    currentLine = new StringBuilder(word);
                } else {
                    lines.add(word);
                }
            }
        }
        
        if (currentLine.length() > 0) {
            lines.add(currentLine.toString());
        }
        
        return lines.toArray(new String[0]);
    }
    
    /**
     * Chọn emoji phù hợp với dịp
     */
    private String getEmojiForOccasion(String occasion) {
        switch (occasion != null ? occasion : "khac") {
            case "sinhnhat":
                return "🎂";
            case "kyniem":
                return "💝";
            case "camtaden":
                return "🌹";
            case "khaitruong":
                return "🎊";
            case "totnghiep":
                return "🎓";
            default:
                return "🌸";
        }
    }
    
    /**
     * Chuyển BufferedImage thành byte array (PNG)
     */
    public byte[] imageToBytes(BufferedImage image) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, "PNG", baos);
        return baos.toByteArray();
    }
    
    /**
     * Lưu ảnh vào file
     */
    public void saveImage(BufferedImage image, String filepath) throws IOException {
        File outputFile = new File(filepath);
        outputFile.getParentFile().mkdirs();
        ImageIO.write(image, "PNG", outputFile);
    }
}
