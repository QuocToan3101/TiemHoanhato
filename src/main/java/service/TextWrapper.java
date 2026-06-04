package service;

import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.List;

/**
 * Text Wrapping & Font Autoscale Engine
 * Uses Java AWT FontMetrics to dynamically wrap text and scale font size down
 * to prevent clipping and layout breaks.
 */
public class TextWrapper {

    private static TextWrapper instance;
    private final FontMetricsDummy dummyMetrics;

    private TextWrapper() {
        dummyMetrics = new FontMetricsDummy();
    }

    public static synchronized TextWrapper getInstance() {
        if (instance == null) {
            instance = new TextWrapper();
        }
        return instance;
    }

    public static class WrappedTextResult {
        public final int fontSize;
        public final List<String> lines;
        public final int lineHeight;

        public WrappedTextResult(int fontSize, List<String> lines, int lineHeight) {
            this.fontSize = fontSize;
            this.lines = lines;
            this.lineHeight = lineHeight;
        }
    }

    /**
     * Dynamically wraps text and scales down font size until it fits the bounds
     */
    public WrappedTextResult wrapAndScaleText(String text, String fontName, int maxWidth, int maxHeight) {
        int[] fontSizes = {40, 38, 36, 34, 32, 30, 28, 26};
        
        for (int fontSize : fontSizes) {
            Font font = new Font(fontName, Font.PLAIN, fontSize);
            FontMetrics fm = dummyMetrics.getMetrics(font);
            int lineHeight = (int) (fontSize * 1.55);
            
            List<String> wrappedLines = wrapText(text, maxWidth, fm);
            int totalHeight = wrappedLines.size() * lineHeight;
            
            if (totalHeight <= maxHeight || fontSize == 26) {
                // Fits, or we reached the minimum size
                return new WrappedTextResult(fontSize, wrappedLines, lineHeight);
            }
        }
        
        // Final fallback with minimum font size
        Font font = new Font(fontName, Font.PLAIN, 26);
        FontMetrics fm = dummyMetrics.getMetrics(font);
        int lineHeight = (int) (26 * 1.55);
        return new WrappedTextResult(26, wrapText(text, maxWidth, fm), lineHeight);
    }

    /**
     * Standard greedy word wrap algorithm
     */
    private List<String> wrapText(String text, int maxWidth, FontMetrics fm) {
        List<String> lines = new ArrayList<>();
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

        return lines;
    }

    /**
     * Helper to retrieve FontMetrics off-screen
     */
    private static class FontMetricsDummy {
        private final Graphics2D g2d;

        public FontMetricsDummy() {
            BufferedImage img = new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB);
            this.g2d = img.createGraphics();
        }

        public FontMetrics getMetrics(Font font) {
            return g2d.getFontMetrics(font);
        }
    }
}
