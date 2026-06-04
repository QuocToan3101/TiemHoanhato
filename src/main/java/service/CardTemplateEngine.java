package service;

import java.util.List;
import dto.AICardState;
import dto.CardTheme;
import service.LayoutEngine.LayoutCoordinates;
import service.TextWrapper.WrappedTextResult;

/**
 * Premium SVG Template Engine for Greeting Cards
 * Assembles SVG XML documents combining colors, fonts, vector artwork,
 * dynamic text wrapping, and alignment calculations.
 */
public class CardTemplateEngine {

    private static CardTemplateEngine instance;

    private CardTemplateEngine() {}

    public static synchronized CardTemplateEngine getInstance() {
        if (instance == null) {
            instance = new CardTemplateEngine();
        }
        return instance;
    }

    /**
     * Generates complete SVG source string for the greeting card
     */
    public String buildSvg(AICardState cardState) {
        // Resolve theme
        String themeId = cardState.getTheme();
        CardTheme theme = CardTheme.getById(themeId);

        // If custom_ai, handle potential updates from state if any (fallback to luxury theme otherwise)
        if (theme == CardTheme.CUSTOM_AI) {
            // Can extract custom styles from JSON if needed, or use default custom_ai colors
        }

        String bg1 = theme.getBgColor1();
        String bg2 = theme.getBgColor2();
        String textColor = theme.getTextColor();
        String borderColor = theme.getBorderColor();
        String flowerType = theme.getFlowerType();

        // Wrap message text using Playfair Display font (registered in FontManager)
        int maxWidth = 800;
        int maxHeight = 240;
        WrappedTextResult wrapResult = TextWrapper.getInstance().wrapAndScaleText(
            cardState.getGeneratedMessage(),
            FontManager.PLAYFAIR_DISPLAY,
            maxWidth,
            maxHeight
        );

        // Calculate layout coordinates
        LayoutEngine layoutEngine = LayoutEngine.getInstance();
        LayoutCoordinates coords = layoutEngine.calculateLayout(wrapResult.lines.size(), wrapResult.lineHeight);

        // Map occasion to a corner dingbat symbol
        String cornerDingbat = getCornerDingbat(cardState.getOccasion());

        // Construct Title text
        String titleText = buildTitleText(cardState);

        // Build SVG XML
        StringBuilder svg = new StringBuilder();
        svg.append("<?xml version='1.0' encoding='UTF-8' standalone='no'?>\n");
        svg.append("<svg xmlns='http://www.w3.org/2000/svg' width='1024' height='768' viewBox='0 0 1024 768'>\n");
        
        // Define gradients and filter effects
        svg.append("  <defs>\n");
        svg.append("    <linearGradient id='cardBgGrad' x1='0%' y1='0%' x2='0%' y2='100%'>\n");
        svg.append("      <stop offset='0%' stop-color='").append(bg1).append("' />\n");
        svg.append("      <stop offset='100%' stop-color='").append(bg2).append("' />\n");
        svg.append("    </linearGradient>\n");
        
        // Soft drop shadow for elements if needed
        svg.append("    <filter id='softShadow' x='-10%' y='-10%' width='120%' height='120%'>\n");
        svg.append("      <feDropShadow dx='0' dy='4' stdDeviation='6' flood-color='#000000' flood-opacity='0.08'/>\n");
        svg.append("    </filter>\n");
        svg.append("  </defs>\n");

        // 1. Background Rect
        svg.append("  <!-- Background Card -->\n");
        svg.append("  <rect width='1024' height='768' rx='40' ry='40' fill='url(#cardBgGrad)' />\n");

        // 2. Dual Elegant Inner Borders
        svg.append("  <!-- Double Letterpress Borders -->\n");
        svg.append("  <rect x='52' y='52' width='920' height='664' rx='30' ry='30' fill='none' stroke='").append(borderColor).append("' stroke-width='2' stroke-opacity='0.6' />\n");
        svg.append("  <rect x='60' y='60' width='904' height='648' rx='26' ry='26' fill='none' stroke='").append(borderColor).append("' stroke-width='1' stroke-opacity='0.3' />\n");

        // 3. Corner Dingbats
        svg.append("  <!-- Corner Symbols -->\n");
        svg.append("  <text x='82' y='95' font-family='").append(FontManager.NOTO_SERIF).append("' font-size='22' fill='").append(borderColor).append("' text-anchor='middle'>").append(cornerDingbat).append("</text>\n");
        svg.append("  <text x='942' y='95' font-family='").append(FontManager.NOTO_SERIF).append("' font-size='22' fill='").append(borderColor).append("' text-anchor='middle'>").append(cornerDingbat).append("</text>\n");
        svg.append("  <text x='82' y='690' font-family='").append(FontManager.NOTO_SERIF).append("' font-size='22' fill='").append(borderColor).append("' text-anchor='middle'>").append(cornerDingbat).append("</text>\n");
        svg.append("  <text x='942' y='690' font-family='").append(FontManager.NOTO_SERIF).append("' font-size='22' fill='").append(borderColor).append("' text-anchor='middle'>").append(cornerDingbat).append("</text>\n");

        // 4. Vector Flower Illustration
        svg.append("  <!-- Flower Vector Art -->\n");
        svg.append("  <g transform='translate(512, ").append(coords.flowerY).append(") scale(").append(coords.flowerScale).append(")' filter='url(#softShadow)'>\n");
        svg.append("    ").append(FlowerPainter.getInstance().getFlowerSvg(flowerType, textColor, borderColor)).append("\n");
        svg.append("  </g>\n");

        // 5. Title Text
        svg.append("  <!-- Greeting Header -->\n");
        svg.append("  <text x='512' y='").append(coords.titleY).append("' font-family='").append(FontManager.CORMORANT_GARAMOND).append("' font-size='38' font-style='italic' font-weight='bold' fill='").append(textColor).append("' text-anchor='middle'>")
           .append(escapeXml(titleText))
           .append("</text>\n");

        // 6. Message Body Lines
        svg.append("  <!-- Message Content -->\n");
        String messageSvgText = layoutEngine.buildMessageSvg(
            wrapResult.lines,
            coords.messageStartY,
            wrapResult.lineHeight,
            FontManager.PLAYFAIR_DISPLAY,
            wrapResult.fontSize,
            textColor
        );
        svg.append("  ").append(messageSvgText).append("\n");

        // 7. Sender Signature
        if (cardState.getSender() != null && !cardState.getSender().trim().isEmpty()) {
            svg.append("  <!-- Signature -->\n");
            String signature = "Thương gửi, " + cardState.getSender().trim();
            svg.append("  <text x='512' y='").append(coords.senderY).append("' font-family='").append(FontManager.CORMORANT_GARAMOND).append("' font-size='26' font-style='italic' fill='").append(textColor).append("' text-anchor='middle'>")
               .append(escapeXml(signature))
               .append("</text>\n");
        }

        // 8. Bottom Brand Slogan
        svg.append("  <!-- Brand Slogan -->\n");
        String brandSlogan = "✿ Tiệm Hoa Nhà Tôi ✿";
        svg.append("  <text x='512' y='").append(coords.brandY).append("' font-family='").append(FontManager.CORMORANT_GARAMOND).append("' font-size='16' font-weight='bold' letter-spacing='2' fill='").append(borderColor).append("' text-anchor='middle'>")
           .append(escapeXml(brandSlogan))
           .append("</text>\n");

        svg.append("</svg>");
        return svg.toString();
    }

    private String buildTitleText(AICardState cardState) {
        String recipient = cardState.getRecipient().trim();
        
        if (recipient.isEmpty()) {
            String occasion = cardState.getOccasion() != null ? cardState.getOccasion().toLowerCase().trim() : "";
            switch (occasion) {
                case "sinhnhat":
                case "sinh nhật":
                    return "Chúc Mừng Sinh Nhật";
                case "kyniem":
                case "kỷ niệm":
                    return "Mừng Kỷ Niệm";
                case "camon":
                case "cảm ơn":
                    return "Cảm Ơn Chân Thành";
                case "totnghiep":
                case "tốt nghiệp":
                    return "Chúc Mừng Tốt Nghiệp";
                case "mothers_day":
                    return "Chúc Mừng Ngày Của Mẹ";
                case "valentine":
                    return "Happy Valentine's Day";
                default:
                    return "Gửi Trao Yêu Thương";
            }
        }
        
        return "Thân gửi " + recipient;
    }

    private String getCornerDingbat(String occasion) {
        if (occasion == null) return "✿";
        switch (occasion.toLowerCase().trim()) {
            case "sinhnhat":
            case "sinh nhật":
                return "✿";
            case "kyniem":
            case "kỷ niệm":
                return "♥";
            case "camon":
            case "cảm ơn":
            case "camtaden":
                return "❀";
            case "chucmung":
            case "chúc mừng":
            case "khaitruong":
            case "khai trương":
                return "✦";
            case "totnghiep":
            case "tốt nghiệp":
                return "★";
            default:
                return "✿";
        }
    }

    private String escapeXml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&apos;");
    }
}
