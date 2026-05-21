package service;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import util.AppConfig;

/**
 * Service chuyên biệt để sinh lời chúc thiệp bằng AI (Gemini hoặc fallback)
 * - Caching response để tránh duplicate call
 * - Smart fallback khi AI fail
 * - Tone/Style options phong phú
 */
public class AIContentService {
    
    private static AIContentService instance;
    private AppConfig config;
    private Gson gson;
    private OkHttpClient httpClient;
    private Map<String, String> responseCache;  // Caching AI response
    private static final int CACHE_SIZE = 100;
    
    private AIContentService() {
        config = AppConfig.getInstance();
        gson = new Gson();
        responseCache = new HashMap<>();
        
        // HTTP client với timeout hợp lý
        httpClient = new OkHttpClient.Builder()
            .connectTimeout(20, TimeUnit.SECONDS)
            .readTimeout(25, TimeUnit.SECONDS)
            .writeTimeout(10, TimeUnit.SECONDS)
            .retryOnConnectionFailure(true)
            .build();
    }
    
    public static synchronized AIContentService getInstance() {
        if (instance == null) {
            instance = new AIContentService();
        }
        return instance;
    }
    
    /**
     * Sinh lời chúc thiệp bằng AI hoặc fallback
     * @return lời chúc sinh ra (không null)
     */
    public String generateGreeting(String recipient, String occasion, 
                                   String tone, String customMessage, String length) {
        
        // Kiểm tra cache trước
        String cacheKey = buildCacheKey(recipient, occasion, tone, length);
        if (responseCache.containsKey(cacheKey)) {
            System.out.println("✓ Cache hit for greeting: " + cacheKey);
            return responseCache.get(cacheKey);
        }
        
        String result = null;
        
        // Thử dùng AI (Gemini)
        if (isAIEnabled()) {
            try {
                result = callGeminiAPI(recipient, occasion, tone, customMessage, length);
                if (result != null && !result.trim().isEmpty()) {
                    System.out.println("✓ Gemini AI generated successfully");
                    responseCache.put(cacheKey, result);
                    return result;
                }
            } catch (Exception e) {
                System.err.println("⚠️ Gemini API error: " + e.getMessage());
            }
        }
        
        // Fallback: dùng template thủ công
        result = generateFallbackGreeting(recipient, occasion, tone, customMessage, length);
        responseCache.put(cacheKey, result);
        return result;
    }
    
    /**
     * Gọi Gemini API để sinh lời chúc
     */
    private String callGeminiAPI(String recipient, String occasion, String tone,
                                 String customMessage, String length) throws IOException {
        
        String apiKey = config.getGeminiApiKey();
        if (apiKey == null || apiKey.equals("YOUR_GEMINI_API_KEY_HERE")) {
            throw new IllegalArgumentException("Gemini API key not configured");
        }
        
        String prompt = buildOptimizedPrompt(recipient, occasion, tone, customMessage, length);
        
        // Tạo request JSON cho Gemini API
        JsonObject requestBody = new JsonObject();
        
        // Contents array
        JsonArray contents = new JsonArray();
        JsonObject content = new JsonObject();
        JsonArray parts = new JsonArray();
        JsonObject part = new JsonObject();
        part.addProperty("text", prompt);
        parts.add(part);
        content.add("parts", parts);
        contents.add(content);
        requestBody.add("contents", contents);
        
        // Generation config - tuned for greeting cards
        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.85);  // Creative nhưng consistent
        generationConfig.addProperty("maxOutputTokens", 256);
        requestBody.add("generationConfig", generationConfig);
        
        // API URL với key
        String apiUrl = config.getGeminiApiUrl() + "?key=" + apiKey;
        
        RequestBody body = RequestBody.create(
            requestBody.toString(),
            MediaType.parse("application/json; charset=utf-8")
        );
        
        Request request = new Request.Builder()
            .url(apiUrl)
            .header("Content-Type", "application/json")
            .post(body)
            .build();
        
        // Execute request với timeout handling
        try (Response response = httpClient.newCall(request).execute()) {
            
            if (!response.isSuccessful()) {
                String errorMsg = response.body() != null ? response.body().string() : response.message();
                throw new IOException("Gemini API error: " + response.code() + " - " + errorMsg);
            }
            
            String responseBody = response.body().string();
            JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);
            
            // Parse Gemini response
            if (jsonResponse.has("candidates") && jsonResponse.getAsJsonArray("candidates").size() > 0) {
                JsonObject candidate = jsonResponse.getAsJsonArray("candidates").get(0).getAsJsonObject();
                if (candidate.has("content")) {
                    JsonObject contentObj = candidate.getAsJsonObject("content");
                    if (contentObj.has("parts") && contentObj.getAsJsonArray("parts").size() > 0) {
                        JsonObject partObj = contentObj.getAsJsonArray("parts").get(0).getAsJsonObject();
                        if (partObj.has("text")) {
                            return partObj.get("text").getAsString().trim();
                        }
                    }
                }
            }
            
            throw new IOException("Invalid Gemini API response format");
        }
    }
    
    /**
     * Xây dựng prompt tối ưu cho Gemini
     */
    private String buildOptimizedPrompt(String recipient, String occasion, 
                                       String tone, String customMessage, String length) {
        
        StringBuilder prompt = new StringBuilder();
        prompt.append("Bạn là chuyên gia viết lời chúc cho thiệp hoa. ");
        prompt.append("Viết lời chúc ngắn gọn, chân thành và sâu sắc.\n\n");
        
        prompt.append("📋 THÔNG TIN:\n");
        
        if (recipient != null && !recipient.isEmpty()) {
            prompt.append("👤 Người nhận: ").append(recipient).append("\n");
        }
        
        if (occasion != null && !occasion.isEmpty()) {
            String occasionText = getOccasionDescription(occasion);
            prompt.append("🎉 Dịp: ").append(occasionText).append("\n");
        }
        
        if (tone != null && !tone.isEmpty()) {
            String toneText = getToneDescription(tone);
            prompt.append("💬 Giọng điệu: ").append(toneText).append("\n");
        }
        
        if (length != null && !length.isEmpty()) {
            String lengthText = getLengthDescription(length);
            prompt.append("📏 Độ dài: ").append(lengthText).append("\n");
        }
        
        if (customMessage != null && !customMessage.isEmpty()) {
            prompt.append("💡 Gợi ý: ").append(customMessage).append("\n");
        }
        
        prompt.append("\n✨ YÊU CẦU:\n");
        prompt.append("- Viết tiếng Việt chuẩn mực\n");
        prompt.append("- Sử dụng emoji hoa (🌸 🌷 🌹 🌻) một cách tinh tế\n");
        prompt.append("- Không quá dài dòng, ngắn gọn nhưng ý nghĩa\n");
        prompt.append("- Phù hợp với việc gửi kèm bó hoa tươi\n");
        prompt.append("- Kết thúc ấm áp, chân thành\n");
        prompt.append("- CHỈ trả về nội dung thiệp, không giải thích\n");
        
        return prompt.toString();
    }
    
    /**
     * Sinh lời chúc fallback khi AI không khả dụng
     */
    private String generateFallbackGreeting(String recipient, String occasion,
                                           String tone, String customMessage, String length) {
        
        if (customMessage != null && !customMessage.trim().isEmpty()) {
            return customMessage;
        }
        
        // Template sẵn có
        String[][] templates = getTemplates(occasion, tone);
        if (templates != null && templates.length > 0) {
            StringBuilder greeting = new StringBuilder();
            
            // Chọn ngẫu nhiên mỗi phần
            String opener = pickRandom(templates[0]);
            String body = pickRandom(templates[1]);
            String closer = pickRandom(templates[2]);
            
            if (!recipient.isEmpty()) {
                greeting.append("Gửi ").append(recipient).append(",\n\n");
            }
            
            greeting.append(body).append("\n\n");
            greeting.append(closer);
            
            if ("dai".equals(length)) {
                greeting.append("\n\nP/S: Cảm ơn bạn đã là chính mình! 🌸");
            }
            
            return greeting.toString();
        }
        
        // Fallback cuối cùng - lời chúc generic
        return "Gửi " + (recipient.isEmpty() ? "bạn" : recipient) + ",\n\n" +
               "Chúc bạn một ngày tuyệt vời cùng bó hoa tươi này. 🌸\n\n" +
               "Thương mến,\nMình";
    }
    
    /**
     * Lấy template lời chúc theo dịp và tone
     */
    private String[][] getTemplates(String occasion, String tone) {
        
        // Map occasion -> tone -> [openers, bodies, closers]
        Map<String, Map<String, String[][]>> templates = new HashMap<>();
        
        // SINH NHẬT
        Map<String, String[][]> birthdayTemplates = new HashMap<>();
        
        birthdayTemplates.put("warm", new String[][] {
            {"Gửi bạn thân mến,", "Bạn ơi,", "Thương gửi bạn,"},
            {
                "Chúc mừng sinh nhật! 🎂🌸 Mong bạn có một năm mới đầy niềm vui, sức khỏe và những điều tuyệt vời.",
                "Chúc bạn tuổi mới với nụ cười rạng rỡ, tim luôn ấm áp và cuộc sống đầy sắc màu! 🌷"
            },
            {"Thương mến,", "Ôm bạn,"}
        });
        
        birthdayTemplates.put("funny", new String[][] {
            {"Hello bạn!",},
            {
                "Sinh nhật vui vẻ! 🎉 Một năm nữa bạn lại trẻ thêm... (khi so với năm tới) 😆🌸"
            },
            {"Yêu bạn, shipper cảm xúc 😎"}
        });
        
        birthdayTemplates.put("formal", new String[][] {
            {"Kính gửi bạn,", "Trân trọng gửi bạn,"},
            {
                "Kính chúc mừng ngày sinh nhật. Chúc bạn sức khỏe dồi dào, thành công rực rỡ."
            },
            {"Trân trọng,", "Thân ái,"}
        });
        
        templates.put("sinhnhat", birthdayTemplates);
        
        // KỶ NIỆM
        Map<String, String[][]> anniversaryTemplates = new HashMap<>();
        anniversaryTemplates.put("warm", new String[][] {
            {"Gửi các bạn,"},
            {
                "Kỷ niệm đáng nhớ! 💕 Cảm ơn vì những khoảnh khắc đẹp. Mong ta luôn yêu thương nhau như thế này."
            },
            {"Yêu thương,"}
        });
        templates.put("kyniem", anniversaryTemplates);
        
        // CẢM ƠN
        Map<String, String[][]> thankTemplates = new HashMap<>();
        thankTemplates.put("warm", new String[][] {
            {"Gửi bạn,"},
            {
                "Cảm ơn bạn vì sự tận tình! 🌸 Mong bó hoa này gửi đến bạn lời cảm ơn chân thành của mình."
            },
            {"Cảm ơn từ trái tim,"}
        });
        templates.put("camtaden", thankTemplates);
        
        // Lấy template phù hợp
        Map<String, String[][]> occasionTemplates = templates.getOrDefault(occasion, birthdayTemplates);
        return occasionTemplates.get(tone);
    }
    
    private String getOccasionDescription(String occasion) {
        switch (occasion) {
            case "sinhnhat": return "Sinh nhật";
            case "kyniem": return "Kỷ niệm";
            case "camtaden": return "Cảm ơn/Động viên";
            case "khaitruong": return "Khai trương";
            case "totnghiep": return "Tốt nghiệp";
            default: return "Chúc mừng";
        }
    }
    
    private String getToneDescription(String tone) {
        switch (tone) {
            case "warm": return "Ấm áp, chân thành";
            case "funny": return "Vui vẻ, hài hước";
            case "formal": return "Trang trọng, lịch sự";
            case "sweet": return "Ngọt ngào, dễ thương";
            case "inspiring": return "Động viên, lạc quan";
            default: return "Ấm áp";
        }
    }
    
    private String getLengthDescription(String length) {
        switch (length) {
            case "ngan": return "Ngắn gọn (1-2 câu)";
            case "trungbinh": return "Trung bình (2-3 câu)";
            case "dai": return "Dài (3-4 câu + P/S)";
            default: return "Vừa phải";
        }
    }
    
    private String buildCacheKey(String recipient, String occasion, String tone, String length) {
        return String.format("%s|%s|%s|%s",
            recipient.hashCode(),
            occasion,
            tone,
            length
        );
    }
    
    private String pickRandom(String[] options) {
        if (options == null || options.length == 0) return "";
        return options[(int)(Math.random() * options.length)];
    }
    
    private boolean isAIEnabled() {
        return config.isGeminiEnabled() && 
               config.getGeminiApiKey() != null &&
               !config.getGeminiApiKey().equals("YOUR_GEMINI_API_KEY_HERE");
    }
    
    /**
     * Clear cache khi cần (ví dụ: after restart)
     */
    public void clearCache() {
        responseCache.clear();
        System.out.println("✓ AI Content Service cache cleared");
    }
}
