package service;

import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.TranscoderOutput;
import org.apache.batik.transcoder.image.PNGTranscoder;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import javax.imageio.ImageIO;

/**
 * High-performance vector-to-raster SVG Renderer
 * Uses Apache Batik to convert SVG XML data to PNG bytes and BufferedImage.
 * Thread-safe and memory-optimized for low-RAM (1GB) environments.
 */
public class SVGRenderer {

    private static SVGRenderer instance;

    static {
        // Ensure headless mode is active so AWT doesn't seek X11 on minimal Linux server
        System.setProperty("java.awt.headless", "true");
    }

    private SVGRenderer() {}

    public static synchronized SVGRenderer getInstance() {
        if (instance == null) {
            instance = new SVGRenderer();
        }
        return instance;
    }

    /**
     * Transcodes SVG string to PNG byte array
     */
    public byte[] renderToPngBytes(String svgContent) throws Exception {
        // Initialize fonts first to make sure AWT GraphicsEnvironment is ready
        FontManager.getInstance().initializeFonts();

        try (InputStream is = new ByteArrayInputStream(svgContent.getBytes(StandardCharsets.UTF_8));
             ByteArrayOutputStream os = new ByteArrayOutputStream()) {

            TranscoderInput input = new TranscoderInput(is);
            TranscoderOutput output = new TranscoderOutput(os);

            PNGTranscoder transcoder = new PNGTranscoder();
            
            // Execute transcoding (stream-based to minimize memory allocations)
            transcoder.transcode(input, output);

            return os.toByteArray();
        }
    }

    /**
     * Transcodes SVG string to BufferedImage
     */
    public BufferedImage renderToImage(String svgContent) throws Exception {
        byte[] pngBytes = renderToPngBytes(svgContent);
        try (InputStream is = new ByteArrayInputStream(pngBytes)) {
            return ImageIO.read(is);
        }
    }
}
