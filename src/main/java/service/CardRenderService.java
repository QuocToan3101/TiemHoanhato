package service;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.Base64;
import javax.imageio.ImageIO;

import dto.AICardState;

/**
 * Premium Card Render Service
 * Orchestrates CardTemplateEngine and SVGRenderer using Apache Batik.
 * Ensures extremely clean, scalable vector output for Vietnamese text.
 */
public class CardRenderService {
    
    private static CardRenderService instance;
    
    private CardRenderService() {
    }
    
    public static synchronized CardRenderService getInstance() {
        if (instance == null) {
            instance = new CardRenderService();
        }
        return instance;
    }
    
    /**
     * Renders card from AICardState into a BufferedImage
     */
    public BufferedImage renderCard(AICardState cardState) {
        if (!cardState.isValid()) {
            throw new IllegalArgumentException("Invalid card state");
        }
        
        try {
            // 1. Build SVG source
            String svgContent = CardTemplateEngine.getInstance().buildSvg(cardState);
            
            // 2. Transcode to BufferedImage
            return SVGRenderer.getInstance().renderToImage(svgContent);
        } catch (Exception e) {
            System.err.println("❌ Error rendering card via Batik: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Card rendering failed: " + e.getMessage(), e);
        }
    }

    /**
     * Renders card from AICardState directly into a PNG byte array
     * Bypasses extra conversions to save memory
     */
    public byte[] renderCardToBytes(AICardState cardState) {
        if (!cardState.isValid()) {
            throw new IllegalArgumentException("Invalid card state");
        }
        
        try {
            String svgContent = CardTemplateEngine.getInstance().buildSvg(cardState);
            return SVGRenderer.getInstance().renderToPngBytes(svgContent);
        } catch (Exception e) {
            System.err.println("❌ Error rendering card bytes via Batik: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Card rendering failed: " + e.getMessage(), e);
        }
    }
    
    /**
     * Convert BufferedImage to PNG byte array
     */
    public byte[] imageToBytes(BufferedImage image) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, "PNG", baos);
        byte[] imageBytes = baos.toByteArray();
        baos.close();
        return imageBytes;
    }
    
    /**
     * Convert BufferedImage to Base64 data URL string
     */
    public String imageToBase64(BufferedImage image) throws Exception {
        byte[] imageBytes = imageToBytes(image);
        String base64String = Base64.getEncoder().encodeToString(imageBytes);
        return "data:image/png;base64," + base64String;
    }
}
