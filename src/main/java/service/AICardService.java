package service;

import java.io.IOException;
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
 * Service để tạo lời chúc thiệp tự động bằng Google Gemini AI
 */
public class AICardService {
    
    private static AICardService instance;
    private AppConfig config;
    private Gson gson;
    private OkHttpClient httpClient;
    
    private AICardService() {
        config = AppConfig.getInstance();
        gson = new Gson();
        
        // Tạo HTTP client với timeout
        httpClient = new OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build();
    }
    
    public static synchronized AICardService getInstance() {
        if (instance == null) {
            instance = new AICardService();
        }
        return instance;
    }
    
    /**
     * Tạo lời chúc thiệp tự động bằng Gemini AI
     */
    public String generateCardMessage(String recipient, String occasion, String tone, 
                                      String customMessage, String length) {
        
        if (!config.isGeminiEnabled()) {
            System.err.println("Gemini AI is disabled. Using fallback message.");
            return generateFallbackMessage(recipient, occasion, tone, customMessage, length);
        }
        
        String apiKey = config.getGeminiApiKey();
        if (apiKey == null || apiKey.equals("YOUR_GEMINI_API_KEY_HERE")) {
            System.err.println("Gemini API key not configured. Using fallback message.");
            return generateFallbackMessage(recipient, occasion, tone, customMessage, length);
        }
        
        try {
            String prompt = buildPrompt(recipient, occasion, tone, customMessage, length);
            String response = callGemini(prompt, apiKey);
            
            if (response != null && !response.isEmpty()) {
                System.out.println("✓ Gemini AI generated message successfully");
                return response;
            } else {
                System.err.println("Empty response from Gemini");
                return generateFallbackMessage(recipient, occasion, tone, customMessage, length);
            }
            
        } catch (Exception e) {
            System.err.println("Error calling Gemini API: " + e.getMessage());
            return generateFallbackMessage(recipient, occasion, tone, customMessage, length);
        }
    }
    
    /**
     * Xây dựng prompt cho OpenAI
     */
    private String buildPrompt(String recipient, String occasion, String tone, 
                               String customMessage, String length) {
        
        StringBuilder prompt = new StringBuilder();
        prompt.append("Bạn là chuyên gia viết thiệp chúc mừng cho tiệm hoa. ");
        prompt.append("Hãy viết lời chúc ngắn gọn, chân thành và đẹp cho thiệp hoa.\n\n");
        
        prompt.append("Thông tin:\n");
        
        if (recipient != null && !recipient.isEmpty()) {
            prompt.append("- Người nhận: ").append(recipient).append("\n");
        }
        
        if (occasion != null && !occasion.isEmpty()) {
            String occasionText = getOccasionText(occasion);
            prompt.append("- Dịp: ").append(occasionText).append("\n");
        }
        
        if (tone != null && !tone.isEmpty()) {
            String toneText = getToneText(tone);
            prompt.append("- Giọng điệu: ").append(toneText).append("\n");
        }
        
        if (length != null && !length.isEmpty()) {
            String lengthText = getLengthText(length);
            prompt.append("- Độ dài: ").append(lengthText).append("\n");
        }
        
        if (customMessage != null && !customMessage.isEmpty()) {
            prompt.append("- Gợi ý nội dung: ").append(customMessage).append("\n");
        }
        
        prompt.append("\nYêu cầu:\n");
        prompt.append("- Viết bằng tiếng Việt\n");
        prompt.append("- Sử dụng emoji hoa (🌸, 🌷, 🌹, 🌻, 💐) một cách tinh tế\n");
        prompt.append("- Không quá dài dòng, ngắn gọn nhưng đủ ý\n");
        prompt.append("- Phù hợp với việc gửi kèm hoa tươi\n");
        prompt.append("- Kết thúc ấm áp và chân thành\n");
        prompt.append("- CHỈ trả về nội dung thiệp, không thêm giải thích hay tiêu đề\n");
        
        return prompt.toString();
    }
    
    /**
     * Gọi Gemini API
     */
    private String callGemini(String prompt, String apiKey) throws IOException {
        String apiUrl = config.getGeminiApiUrl();
        
        // Build request body cho Gemini API
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
        
        // Generation config
        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", config.getGeminiTemperature());
        generationConfig.addProperty("maxOutputTokens", config.getGeminiMaxTokens());
        requestBody.add("generationConfig", generationConfig);
        
        // Create request - Gemini sử dụng API key trong URL
        String urlWithKey = apiUrl + "?key=" + apiKey;
        
        RequestBody body = RequestBody.create(
            requestBody.toString(),
            MediaType.parse("application/json; charset=utf-8")
        );
        
        Request request = new Request.Builder()
            .url(urlWithKey)
            .header("Content-Type", "application/json")
            .post(body)
            .build();
        
        // Execute request
        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                System.err.println("Gemini API error: " + response.code() + " - " + response.message());
                if (response.body() != null) {
                    System.err.println("Response: " + response.body().string());
                }
                return null;
            }
            
            String responseBody = response.body().string();
            JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);
            
            // Parse Gemini response structure
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
            
            return null;
        }
    }
    
    /**
     * Tạo message dự phòng khi không dùng được AI
     */
    private String generateFallbackMessage(String recipient, String occasion, String tone, 
                                          String customMessage, String length) {
        
        StringBuilder message = new StringBuilder();
        
        // Lời mở đầu
        if (recipient != null && !recipient.isEmpty()) {
            message.append("Gửi ").append(recipient).append(",\n\n");
        } else {
            message.append("Gửi bạn,\n\n");
        }
        
        // Nội dung chính dựa vào dịp
        if (customMessage != null && !customMessage.isEmpty()) {
            message.append(customMessage);
        } else {
            switch (occasion != null ? occasion : "khac") {
                case "sinhnhat":
                    message.append("Chúc mừng sinh nhật! 🎂🌸\n\n");
                    message.append("Chúc bạn một tuổi mới tràn đầy niềm vui, sức khỏe và thành công. ");
                    message.append("Mong rằng mọi điều tốt đẹp nhất sẽ đến với bạn!");
                    break;
                case "kyniem":
                    message.append("Kỷ niệm đáng nhớ! 💐💕\n\n");
                    message.append("Chúc mừng ngày kỷ niệm đặc biệt của các bạn. ");
                    message.append("Chúc cho tình yêu của hai bạn mãi bền chặt và hạnh phúc!");
                    break;
                case "camtaden":
                    message.append("Chúc sức khỏe và bình an! 🌹\n\n");
                    message.append("Gửi đến bạn những lời chúc ấm áp nhất. ");
                    message.append("Mong bạn mau bình phục và luôn mạnh khỏe!");
                    break;
                case "khaitruong":
                    message.append("Chúc mừng khai trương! 🎊🌻\n\n");
                    message.append("Chúc công việc kinh doanh thuận lợi, phát đạt và thành công rực rỡ!");
                    break;
                case "totnghiep":
                    message.append("Chúc mừng tốt nghiệp! 🎓🌸\n\n");
                    message.append("Chúc mừng những nỗ lực đã được đền đáp! ");
                    message.append("Chúc bạn tương lai rộng mở và thành công trên con đường sắp tới!");
                    break;
                default:
                    message.append("Gửi bạn những bông hoa tươi thắm! 🌸🌷\n\n");
                    message.append("Chúc bạn luôn vui vẻ, hạnh phúc và tràn đầy năng lượng tích cực!");
            }
        }
        
        // Lời kết
        if (length != null && length.equals("dai")) {
            message.append("\n\nP/S: Mọi điều tốt đẹp đang đến gần bạn. Hãy luôn tự tin và yêu đời nhé! 💫");
        }
        
        return message.toString();
    }
    
    private String getOccasionText(String occasion) {
        switch (occasion) {
            case "sinhnhat": return "Sinh nhật";
            case "kyniem": return "Kỷ niệm";
            case "camtaden": return "Cảm ơn/Động viên";
            case "khaitruong": return "Khai trương";
            case "totnghiep": return "Tốt nghiệp";
            default: return "Chúc mừng";
        }
    }
    
    private String getToneText(String tone) {
        switch (tone) {
            case "formal": return "Trang trọng, lịch sự";
            case "casual": return "Thân mật, gần gũi";
            case "funny": return "Vui vẻ, hài hước";
            default: return "Ấm áp, chân thành";
        }
    }
    
    private String getLengthText(String length) {
        switch (length) {
            case "ngan": return "Ngắn gọn (2-3 câu)";
            case "trungbinh": return "Trung bình (4-5 câu)";
            case "dai": return "Dài (6-8 câu)";
            default: return "Vừa phải";
        }
    }
}
