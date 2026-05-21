package service;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import util.AppConfig;

/**
 * Service để sinh background image cho thiệp bằng Pollinations AI (miễn phí)
 * - Fast generation
 * - Caching để tránh regenerate
 * - Fallback gradient khi fail
 */
public class AIImageService {
    
    private static AIImageService instance;
    private Gson gson;
    private OkHttpClient httpClient;
    private Map<String, String> imageCache;  // Caching image URLs
    private static final int CACHE_SIZE = 50;
    private static final int MAX_RETRIES = 2;
    private static final int RETRY_DELAY_MS = 500;
    
    private AIImageService() {
        gson = new Gson();
        imageCache = new HashMap<>();
        
        // HTTP client cho image generation (shorter timeout)
        httpClient = new OkHttpClient.Builder()
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(20, TimeUnit.SECONDS)
            .writeTimeout(5, TimeUnit.SECONDS)
            .retryOnConnectionFailure(true)
            .build();
    }
    
    public static synchronized AIImageService getInstance() {
        if (instance == null) {
            instance = new AIImageService();
        }
        return instance;
    }
    
    /**
     * Sinh background image URL từ prompt
     * @return image URL hoặc gradient fallback
     */
    public String generateBackgroundImage(String occasion, String tone, String message) {
        
        // Tạo cache key
        String cacheKey = buildCacheKey(occasion, tone);
        if (imageCache.containsKey(cacheKey)) {
            System.out.println("✓ Image cache hit: " + cacheKey);
            return imageCache.get(cacheKey);
        }
        
        // Xây dựng prompt cho Pollinations
        String prompt = buildImagePrompt(occasion, tone, message);
        
        // Thử generate từ Pollinations AI
        String imageUrl = generateFromPollinationsAI(prompt);
        
        if (imageUrl != null && isValidImageUrl(imageUrl)) {
            imageCache.put(cacheKey, imageUrl);
            System.out.println("✓ Pollinations AI image generated: " + cacheKey);
            return imageUrl;
        }
        
        // Fallback: gradient CSS
        System.err.println("⚠️ Image generation failed, using gradient fallback");
        String gradientFallback = getGradientFallback(occasion);
        imageCache.put(cacheKey, gradientFallback);
        return gradientFallback;
    }
    
    /**
     * Generate image từ Pollinations AI (free tier)
     * API: https://image.pollinations.ai/prompt/...
     */
    private String generateFromPollinationsAI(String prompt) {
        
        try {
            // Xây dựng URL - Pollinations API
            String encodedPrompt = encodePrompt(prompt);
            String imageUrl = String.format(
                "https://image.pollinations.ai/prompt/%s?seed=%d&nologo=true&width=800&height=600",
                encodedPrompt,
                System.currentTimeMillis() % 10000
            );
            
            // Test URL validity bằng HEAD request
            Request headRequest = new Request.Builder()
                .url(imageUrl)
                .head()
                .addHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
                .build();
            
            try (Response response = httpClient.newCall(headRequest).execute()) {
                if (response.isSuccessful() && response.header("content-type", "").contains("image")) {
                    System.out.println("✓ Pollinations image URL valid: " + imageUrl);
                    return imageUrl;
                }
            }
            
            System.err.println("⚠️ Pollinations image generation failed");
            return null;
            
        } catch (Exception e) {
            System.err.println("⚠️ Pollinations API error: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Xây dựng prompt tối ưu cho Pollinations AI
     */
    private String buildImagePrompt(String occasion, String tone, String message) {
        
        String basePrompt = "watercolor flowers, soft pastel, romantic, elegant, floral pattern, " +
                           "painted flowers, botanical illustration, light gradient background, ";
        
        // Thêm description theo occasion
        switch (occasion) {
            case "sinhnhat":
                basePrompt += "birthday celebration, colorful flowers, joyful, vibrant pastel colors";
                break;
            case "kyniem":
                basePrompt += "romantic flowers, love, roses, hearts, soft pink, elegant";
                break;
            case "camtaden":
                basePrompt += "gratitude flowers, warm colors, sunflowers, thankyou card, warm palette";
                break;
            case "khaitruong":
                basePrompt += "celebration, lucky colors, auspicious, gold, red, flowers";
                break;
            case "totnghiep":
                basePrompt += "graduation, academic flowers, blue, purple, sophisticated";
                break;
            default:
                basePrompt += "beautiful flowers, peaceful, serene, minimalist";
        }
        
        // Thêm tone
        switch (tone) {
            case "warm":
                basePrompt += ", warm lighting, cozy";
                break;
            case "funny":
                basePrompt += ", playful, quirky, colorful";
                break;
            case "formal":
                basePrompt += ", professional, elegant, refined";
                break;
            case "sweet":
                basePrompt += ", cute, sweet, adorable, pastel";
                break;
            case "inspiring":
                basePrompt += ", uplifting, bright, hopeful";
                break;
        }
        
        basePrompt += ", high quality, professional illustration, 4k, ultra detailed";
        
        return basePrompt;
    }
    
    /**
     * Mã hóa prompt cho URL
     */
    private String encodePrompt(String prompt) {
        return prompt.replaceAll(" ", "%20")
                    .replaceAll(",", "%2C")
                    .replaceAll("'", "%27")
                    .replaceAll("\"", "%22");
    }
    
    /**
     * Lấy gradient CSS fallback theo occasion
     */
    private String getGradientFallback(String occasion) {
        
        switch (occasion) {
            case "sinhnhat":
                // Hồng vàng - sinh nhật
                return "linear-gradient(135deg, #FFE5EC 0%, #FFB3D9 50%, #FFA3C7 100%)";
            case "kyniem":
                // Hồng đỏ - kỷ niệm
                return "linear-gradient(135deg, #FFE5E5 0%, #FF99B3 50%, #FF6B9D 100%)";
            case "camtaden":
                // Vàng cam - cảm ơn
                return "linear-gradient(135deg, #FFF3E0 0%, #FFE0B2 50%, #FFCC80 100%)";
            case "khaitruong":
                // Vàng đỏ - khai trương (may mắn)
                return "linear-gradient(135deg, #FFFDE7 0%, #FFF176 50%, #FFD54F 100%)";
            case "totnghiep":
                // Xanh tím - tốt nghiệp
                return "linear-gradient(135deg, #E1BEE7 0%, #CE93D8 50%, #BA68C8 100%)";
            default:
                // Tím lavender - generic
                return "linear-gradient(135deg, #F3E5F5 0%, #E1BEE7 50%, #CE93D8 100%)";
        }
    }
    
    /**
     * Validate image URL có thật sự là image không
     */
    private boolean isValidImageUrl(String url) {
        return url != null && 
               (url.startsWith("http://") || url.startsWith("https://")) &&
               (url.endsWith(".jpg") || url.endsWith(".png") || url.endsWith(".webp") ||
                url.contains("image.pollinations.ai"));
    }
    
    private String buildCacheKey(String occasion, String tone) {
        return String.format("%s_%s", occasion, tone);
    }
    
    /**
     * Clear cache khi cần
     */
    public void clearCache() {
        imageCache.clear();
        System.out.println("✓ AI Image Service cache cleared");
    }
    
    /**
     * Get cache size (for monitoring)
     */
    public int getCacheSize() {
        return imageCache.size();
    }
}
