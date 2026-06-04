package service;

import java.util.List;

/**
 * Layout Positioning Engine
 * Calculates vertical positions (Y-coordinates) for elements to achieve
 * premium balance and spacing, and converts wrapped lines to SVG tspan XML.
 */
public class LayoutEngine {

    private static LayoutEngine instance;

    private LayoutEngine() {}

    public static synchronized LayoutEngine getInstance() {
        if (instance == null) {
            instance = new LayoutEngine();
        }
        return instance;
    }

    public static class LayoutCoordinates {
        public final int flowerY;
        public final double flowerScale;
        public final int titleY;
        public final int messageStartY;
        public final int senderY;
        public final int brandY;

        public LayoutCoordinates(int flowerY, double flowerScale, int titleY, 
                                 int messageStartY, int senderY, int brandY) {
            this.flowerY = flowerY;
            this.flowerScale = flowerScale;
            this.titleY = titleY;
            this.messageStartY = messageStartY;
            this.senderY = senderY;
            this.brandY = brandY;
        }
    }

    /**
     * Calculates positions based on text line count and height
     */
    public LayoutCoordinates calculateLayout(int lineCount, int lineHeight) {
        int totalTextHeight = lineCount * lineHeight;
        
        // Canvas is 768px height
        int brandY = 710;
        int senderY = 640;
        
        int titleY = 320;
        int flowerY = 160;
        double flowerScale = 1.15;
        
        // Centering message vertically within the available region (360px to 600px)
        int messageContainerHeight = 240;
        int messageContainerStart = 370;
        
        int messageStartY;
        if (totalTextHeight < messageContainerHeight) {
            messageStartY = messageContainerStart + (messageContainerHeight - totalTextHeight) / 2;
        } else {
            messageStartY = messageContainerStart;
        }
        
        // If message is too long, push up the title and shrink the flower slightly
        if (lineCount > 5) {
            titleY = 295;
            flowerY = 135;
            flowerScale = 0.95;
        }

        return new LayoutCoordinates(flowerY, flowerScale, titleY, messageStartY, senderY, brandY);
    }

    /**
     * Formats wrapped lines to SVG text block with tspans
     */
    public String buildMessageSvg(List<String> lines, int startY, int lineHeight, String fontName, int fontSize, String textColor) {
        StringBuilder svg = new StringBuilder();
        
        // SVG text block with relative tspans
        svg.append("<text font-family='").append(fontName).append("' ")
           .append("font-size='").append(fontSize).append("' ")
           .append("fill='").append(textColor).append("' ")
           .append("text-anchor='middle'>\n");
        
        for (int i = 0; i < lines.size(); i++) {
            String line = lines.get(i);
            // Escape XML entities
            String escapedLine = escapeXml(line);
            
            if (i == 0) {
                svg.append("  <tspan x='512' y='").append(startY).append("'>").append(escapedLine).append("</tspan>\n");
            } else {
                svg.append("  <tspan x='512' dy='").append(lineHeight).append("'>").append(escapedLine).append("</tspan>\n");
            }
        }
        
        svg.append("</text>");
        return svg.toString();
    }

    /**
     * Simple XML escaper
     */
    private String escapeXml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&apos;");
    }
}
