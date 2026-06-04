package service;

import java.awt.Font;
import java.awt.GraphicsEnvironment;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * Premium Font Manager - Thread-safe & Linux-compatible
 * Dynamically downloads, caches, and registers playfair display, cormorant garamond,
 * and Noto fonts into AWT Graphics Environment for Batik rendering.
 */
public class FontManager {

    private static FontManager instance;
    private static final String CACHE_DIR_PATH = System.getProperty("user.home") + "/.flowerstore/fonts";
    
    // Public Font Names registered in system
    public static final String PLAYFAIR_DISPLAY = "Playfair Display";
    public static final String CORMORANT_GARAMOND = "Cormorant Garamond";
    public static final String NOTO_SERIF = "Noto Serif";
    public static final String NOTO_SANS = "Noto Sans";

    private final Map<String, Font> fontCache = new HashMap<>();
    private boolean initialized = false;

    private FontManager() {}

    public static synchronized FontManager getInstance() {
        if (instance == null) {
            instance = new FontManager();
        }
        return instance;
    }

    /**
     * Initializes and registers all required fonts
     */
    public synchronized void initializeFonts() {
        if (initialized) {
            return;
        }

        System.out.println("🔤 Initializing premium Vietnamese fonts...");
        File cacheDir = new File(CACHE_DIR_PATH);
        if (!cacheDir.exists()) {
            cacheDir.mkdirs();
        }

        // Define fonts to download
        Map<String, String> fontsToLoad = new HashMap<>();
        fontsToLoad.put("PlayfairDisplay-Regular.ttf", "https://raw.githubusercontent.com/google/fonts/main/ofl/playfairdisplay/static/PlayfairDisplay-Regular.ttf");
        fontsToLoad.put("PlayfairDisplay-Bold.ttf", "https://raw.githubusercontent.com/google/fonts/main/ofl/playfairdisplay/static/PlayfairDisplay-Bold.ttf");
        fontsToLoad.put("CormorantGaramond-Regular.ttf", "https://raw.githubusercontent.com/google/fonts/main/ofl/cormorantgaramond/CormorantGaramond-Regular.ttf");
        fontsToLoad.put("CormorantGaramond-Italic.ttf", "https://raw.githubusercontent.com/google/fonts/main/ofl/cormorantgaramond/CormorantGaramond-Italic.ttf");
        fontsToLoad.put("NotoSerif-Regular.ttf", "https://raw.githubusercontent.com/google/fonts/main/ofl/notoserif/static/NotoSerif-Regular.ttf");
        fontsToLoad.put("NotoSans-Regular.ttf", "https://raw.githubusercontent.com/google/fonts/main/ofl/notosans/static/NotoSans-Regular.ttf");

        GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();

        for (Map.Entry<String, String> entry : fontsToLoad.entrySet()) {
            String fontName = entry.getKey();
            String fontUrl = entry.getValue();
            File fontFile = new File(cacheDir, fontName);

            if (!fontFile.exists()) {
                System.out.println("⬇️ Downloading " + fontName + " from Google Fonts...");
                try {
                    downloadFile(fontUrl, fontFile);
                } catch (IOException e) {
                    System.err.println("❌ Failed to download " + fontName + ": " + e.getMessage() + ". Falling back to logical fonts.");
                    continue;
                }
            }

            try {
                Font font = Font.createFont(Font.TRUETYPE_FONT, fontFile);
                ge.registerFont(font);
                fontCache.put(fontName, font);
                System.out.println("✓ Registered font: " + font.getFontName());
            } catch (Exception e) {
                System.err.println("❌ Error registering font " + fontName + ": " + e.getMessage());
            }
        }

        initialized = true;
        System.out.println("✓ Premium fonts initialization completed.");
    }

    /**
     * Helper to download file
     */
    private void downloadFile(String urlStr, File targetFile) throws IOException {
        URL url = new URL(urlStr);
        try (BufferedInputStream in = new BufferedInputStream(url.openStream());
             FileOutputStream fileOutputStream = new FileOutputStream(targetFile)) {
            byte[] dataBuffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(dataBuffer, 0, 1024)) != -1) {
                fileOutputStream.write(dataBuffer, 0, bytesRead);
            }
        }
    }

    /**
     * Get font instance by file name
     */
    public Font getFont(String fontFileName) {
        if (!initialized) {
            initializeFonts();
        }
        return fontCache.get(fontFileName);
    }
}
