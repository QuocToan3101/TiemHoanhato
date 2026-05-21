package service;

import java.awt.*;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.Base64;
import javax.imageio.ImageIO;

import dto.AICardState;

/**
 * Service chuyên biệt render thiệp thành ảnh PNG chất lượng cao
 * - Hỗ trợ multiple layouts
 * - Anti-aliasing mạnh mẽ
 * - Typography professional
 */
public class CardRenderService {
    
    private static CardRenderService instance;
    
    // Card dimensions (A6 size)
    private static final int CARD_WIDTH = 1024;
    private static final int CARD_HEIGHT = 768;
    private static final int PADDING = 60;
    private static final int CORNER_RADIUS = 40;
    
    private CardRenderService() {
    }
    
    public static synchronized CardRenderService getInstance() {
        if (instance == null) {
            instance = new CardRenderService();
        }
        return instance;
    }
    
    /**
     * Render thiệp từ AICardState thành BufferedImage
     */
    public BufferedImage renderCard(AICardState cardState) {
        
        if (!cardState.isValid()) {
            throw new IllegalArgumentException("Invalid card state");
        }
        
        BufferedImage image = new BufferedImage(CARD_WIDTH, CARD_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();
        
        // Anti-aliasing & rendering hints
        setupGraphicsQuality(g2d);
        
        // Draw layers
        drawBackgroundGradient(g2d, cardState.getOccasion());
        drawDecorativeFrame(g2d);
        drawDecorativeElements(g2d, cardState.getOccasion());
        drawContent(g2d, cardState);
        drawFooter(g2d);
        
        g2d.dispose();
        return image;
    }
    
    /**
     * Setup graphics rendering quality cao
     */
    private void setupGraphicsQuality(Graphics2D g2d) {
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, 
                           RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, 
                           RenderingHints.VALUE_TEXT_ANTIALIAS_LCD_HRGB);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, 
                           RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, 
                           RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g2d.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, 
                           RenderingHints.VALUE_STROKE_PURE);
        g2d.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, 
                           RenderingHints.VALUE_FRACTIONALMETRICS_ON);
    }
    
    /**
     * Vẽ background gradient theo occasion
     */
    private void drawBackgroundGradient(Graphics2D g2d, String occasion) {
        
        GradientPaint gradient = getGradientForOccasion(occasion);
        g2d.setPaint(gradient);
        g2d.fillRect(0, 0, CARD_WIDTH, CARD_HEIGHT);
    }
    
    /**
     * Lấy gradient màu theo dịp
     */
    private GradientPaint getGradientForOccasion(String occasion) {
        
        Color color1, color2;
        
        switch (occasion) {
            case "sinhnhat":
                color1 = new Color(255, 228, 225);  // Misty rose
                color2 = new Color(255, 192, 203);  // Light pink
                break;
            case "kyniem":
                color1 = new Color(255, 182, 193);  // Light pink
                color2 = new Color(255, 105, 180);  // Hot pink
                break;
            case "camtaden":
                color1 = new Color(255, 248, 220);  // Cornsilk
                color2 = new Color(255, 218, 185);  // Peach puff
                break;
            case "khaitruong":
                color1 = new Color(255, 255, 153);  // Light yellow
                color2 = new Color(255, 215, 0);    // Gold
                break;
            case "totnghiep":
                color1 = new Color(221, 237, 247);  // Light blue
                color2 = new Color(176, 215, 247);  // Cornflower blue
                break;
            default:
                color1 = new Color(245, 235, 250);  // Lavender blush
                color2 = new Color(230, 230, 250);  // Lavender
        }
        
        return new GradientPaint(0, 0, color1, 0, CARD_HEIGHT, color2);
    }
    
    /**
     * Vẽ frame bo góc
     */
    private void drawDecorativeFrame(Graphics2D g2d) {
        
        // White frame bên trong
        g2d.setColor(new Color(255, 255, 255, 240));
        g2d.setStroke(new BasicStroke(1.5f));
        
        RoundRectangle2D frame = new RoundRectangle2D.Double(
            PADDING - 8, PADDING - 8,
            CARD_WIDTH - 2 * (PADDING - 8),
            CARD_HEIGHT - 2 * (PADDING - 8),
            CORNER_RADIUS, CORNER_RADIUS
        );
        g2d.drawRoundRect(
            PADDING - 8, PADDING - 8,
            CARD_WIDTH - 2 * (PADDING - 8),
            CARD_HEIGHT - 2 * (PADDING - 8),
            CORNER_RADIUS, CORNER_RADIUS
        );
        
        // Inner shadow effect
        g2d.setColor(new Color(0, 0, 0, 15));
        g2d.setStroke(new BasicStroke(3));
        g2d.drawRoundRect(
            PADDING - 6, PADDING - 6,
            CARD_WIDTH - 2 * (PADDING - 6),
            CARD_HEIGHT - 2 * (PADDING - 6),
            CORNER_RADIUS - 2, CORNER_RADIUS - 2
        );
    }
    
    /**
     * Vẽ decorative elements (hoa, icon)
     */
    private void drawDecorativeElements(Graphics2D g2d, String occasion) {
        
        Font emojiFont = new Font("Segoe UI Emoji", Font.PLAIN, 60);
        g2d.setFont(emojiFont);
        g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.6f));
        
        String emoji = getEmojiForOccasion(occasion);
        
        // Vẽ ở 4 góc
        g2d.drawString(emoji, PADDING + 20, PADDING + 70);                    // Top-left
        g2d.drawString(emoji, CARD_WIDTH - PADDING - 60, PADDING + 70);       // Top-right
        g2d.drawString(emoji, PADDING + 20, CARD_HEIGHT - PADDING);            // Bottom-left
        g2d.drawString(emoji, CARD_WIDTH - PADDING - 60, CARD_HEIGHT - PADDING); // Bottom-right
        
        // Vẽ decorative lines
        g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1.0f));
        g2d.setColor(new Color(200, 160, 140, 100));
        g2d.setStroke(new BasicStroke(2, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        
        int lineY1 = PADDING + 140;
        int lineY2 = CARD_HEIGHT - PADDING - 120;
        g2d.drawLine(PADDING + 120, lineY1, CARD_WIDTH - PADDING - 120, lineY1);
        g2d.drawLine(PADDING + 120, lineY2, CARD_WIDTH - PADDING - 120, lineY2);
    }
    
    /**
     * Vẽ nội dung thiệp (text message)
     */
    private void drawContent(Graphics2D g2d, AICardState cardState) {
        
        String message = cardState.getGeneratedMessage();
        if (message == null || message.isEmpty()) {
            return;
        }
        
        // Main content area
        int contentX = PADDING + 50;
        int contentY = PADDING + 200;
        int contentWidth = CARD_WIDTH - 2 * (PADDING + 50);
        int contentHeight = CARD_HEIGHT - (2 * PADDING) - 280;
        
        // Font cho message
        Font messageFont = new Font("Segoe UI", Font.PLAIN, 24);
        g2d.setFont(messageFont);
        g2d.setColor(new Color(50, 40, 30));
        
        // Wrap text và draw
        FontMetrics fm = g2d.getFontMetrics();
        String[] lines = wrapText(message, contentWidth, fm);
        
        int lineHeight = (int)(fm.getHeight() * 1.4);
        int totalHeight = lines.length * lineHeight;
        int startY = contentY + (contentHeight - totalHeight) / 2;
        
        // Draw text với line spacing
        for (int i = 0; i < lines.length; i++) {
            String line = lines[i];
            int lineWidth = fm.stringWidth(line);
            int x = contentX + (contentWidth - lineWidth) / 2;
            int y = startY + i * lineHeight;
            
            // Shadow nhẹ
            g2d.setColor(new Color(255, 255, 255, 150));
            g2d.drawString(line, x + 1, y + 1);
            
            // Text chính
            g2d.setColor(new Color(50, 40, 30));
            g2d.drawString(line, x, y);
        }
    }
    
    /**
     * Vẽ footer branding
     */
    private void drawFooter(Graphics2D g2d) {
        
        Font footerFont = new Font("Segoe UI", Font.ITALIC, 16);
        g2d.setFont(footerFont);
        g2d.setColor(new Color(120, 100, 80, 200));
        
        String footer = "✿ Tiệm Hoa Nhà Tôi ✿";
        FontMetrics fm = g2d.getFontMetrics();
        int footerWidth = fm.stringWidth(footer);
        int x = (CARD_WIDTH - footerWidth) / 2;
        int y = CARD_HEIGHT - PADDING + 30;
        
        g2d.drawString(footer, x, y);
    }
    
    /**
     * Wrap text vào nhiều dòng
     */
    private String[] wrapText(String text, int maxWidth, FontMetrics fm) {
        
        java.util.List<String> lines = new java.util.ArrayList<>();
        
        // Split by paragraphs first
        String[] paragraphs = text.split("\\n");
        
        for (String paragraph : paragraphs) {
            if (paragraph.trim().isEmpty()) {
                lines.add("");
                continue;
            }
            
            String[] words = paragraph.split("\\s+");
            StringBuilder currentLine = new StringBuilder();
            
            for (String word : words) {
                String testLine = currentLine.length() == 0 ? word : currentLine + " " + word;
                int width = fm.stringWidth(testLine);
                
                if (width > maxWidth) {
                    if (currentLine.length() > 0) {
                        lines.add(currentLine.toString());
                    }
                    currentLine = new StringBuilder(word);
                } else {
                    if (currentLine.length() > 0) {
                        currentLine.append(" ");
                    }
                    currentLine.append(word);
                }
            }
            
            if (currentLine.length() > 0) {
                lines.add(currentLine.toString());
            }
        }
        
        return lines.toArray(new String[0]);
    }
    
    /**
     * Lấy emoji phù hợp với occasion
     */
    private String getEmojiForOccasion(String occasion) {
        
        switch (occasion) {
            case "sinhnhat": return "🎂";
            case "kyniem": return "💕";
            case "camtaden": return "🙏";
            case "khaitruong": return "🎊";
            case "totnghiep": return "🎓";
            default: return "🌸";
        }
    }
    
    /**
     * Convert BufferedImage thành byte array PNG
     */
    public byte[] imageToBytes(BufferedImage image) throws Exception {
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, "PNG", baos);
        byte[] imageBytes = baos.toByteArray();
        baos.close();
        
        return imageBytes;
    }
    
    /**
     * Convert BufferedImage thành Base64 string
     */
    public String imageToBase64(BufferedImage image) throws Exception {
        
        byte[] imageBytes = imageToBytes(image);
        String base64String = Base64.getEncoder().encodeToString(imageBytes);
        return "data:image/png;base64," + base64String;
    }
}
