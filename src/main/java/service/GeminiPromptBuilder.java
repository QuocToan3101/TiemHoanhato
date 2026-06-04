package service;

/**
 * Premium Gemini AI Prompt Builder
 * Custom-crafted to output professional, emotional, and culturally appropriate
 * Vietnamese greeting text (under 80 words) and avoid formatting issues.
 */
public class GeminiPromptBuilder {

    private static GeminiPromptBuilder instance;

    private GeminiPromptBuilder() {}

    public static synchronized GeminiPromptBuilder getInstance() {
        if (instance == null) {
            instance = new GeminiPromptBuilder();
        }
        return instance;
    }

    /**
     * Constructs the highly-optimized prompt for the Gemini AI text model
     */
    public String buildPrompt(String recipient, String occasion, String tone, 
                              String customMessage, String length, String holiday) {
        StringBuilder prompt = new StringBuilder();
        
        // System Role Instruction
        prompt.append("Bạn là một chuyên gia sáng tạo nội dung và viết lời chúc thiệp cao cấp tại 'Tiệm Hoa Nhà Tôi'.\n");
        prompt.append("Nhiệm vụ của bạn là viết một lời chúc thiệp bằng tiếng Việt tinh tế, giàu cảm xúc, tự nhiên và phù hợp với thuần phong mỹ tục Việt Nam.\n\n");

        // Context Parameters
        prompt.append("📋 THÔNG TIN THIỆP:\n");
        
        if (recipient != null && !recipient.trim().isEmpty()) {
            prompt.append("- Người nhận: ").append(recipient.trim()).append("\n");
        } else {
            prompt.append("- Người nhận: Một người bạn/người thân yêu quý\n");
        }
        
        if (occasion != null && !occasion.trim().isEmpty()) {
            prompt.append("- Dịp tặng: ").append(translateOccasion(occasion)).append("\n");
        }
        
        if (holiday != null && !holiday.trim().isEmpty() && !holiday.equalsIgnoreCase("none")) {
            prompt.append("- Ngày lễ đặc biệt: ").append(holiday.trim()).append("\n");
        }
        
        if (tone != null && !tone.trim().isEmpty()) {
            prompt.append("- Giọng điệu/Phong cách: ").append(translateTone(tone)).append("\n");
        }
        
        if (length != null && !length.trim().isEmpty()) {
            prompt.append("- Độ dài mong muốn: ").append(translateLength(length)).append("\n");
        }
        
        if (customMessage != null && !customMessage.trim().isEmpty()) {
            prompt.append("- Ý chính/Chi tiết khách muốn đưa vào: ").append(customMessage.trim()).append("\n");
        }

        // Rules and Output Constraints
        prompt.append("\n⚠️ QUY TẮC BẮT BUỘC:\n");
        prompt.append("1. NGÔN NGỮ: Viết tiếng Việt tự nhiên, ấm áp, tránh dịch nghĩa khô khan. Không dùng từ ngữ sáo rỗng.\n");
        prompt.append("2. ĐỘ DÀI: Ngắn gọn, súc tích (Tối đa 80 từ), vừa vặn để in lên thiệp A6 mà không bị tràn chữ.\n");
        prompt.append("3. KHÔNG DÙNG EMOJI MÀU: Tuyệt đối không dùng emoji màu thông thường (như ❤️, 🎉, 🎂, 🌸). Chỉ dùng tối đa 1-2 ký tự đặc biệt dạng Dingbat cổ điển nếu cần thiết: ✿, ♥, ❀, ✦, ★.\n");
        prompt.append("4. FORMAT: Chỉ trả về nội dung lời chúc để in trực tiếp lên thiệp. KHÔNG thêm dấu ngoặc kép bọc ngoài toàn bộ lời chúc. KHÔNG thêm các câu dẫn như 'Dưới đây là lời chúc...', KHÔNG dùng định dạng markdown codeblock (```text).\n");
        prompt.append("5. Không có dòng tiêu đề 'Thân gửi...' hoặc ký tên người gửi ở trong nội dung này, vì hệ thống sẽ tự động vẽ tiêu đề và chữ ký ở các khu vực riêng trên thiệp.\n");
        
        return prompt.toString();
    }

    private String translateOccasion(String occasion) {
        switch (occasion.toLowerCase().trim()) {
            case "sinhnhat":
            case "sinh nhật":
                return "Sinh nhật";
            case "kyniem":
            case "kỷ niệm":
                return "Kỷ niệm ngày cưới / kỷ niệm tình yêu";
            case "camon":
            case "cảm ơn":
            case "camtaden":
                return "Cảm ơn hoặc Động viên tinh thần";
            case "chucmung":
            case "chúc mừng":
            case "khaitruong":
            case "khai trương":
                return "Chúc mừng thành công, khai trương hồng phát";
            case "totnghiep":
            case "tốt nghiệp":
                return "Tốt nghiệp";
            case "valentine":
                return "Lễ tình nhân Valentine";
            case "mothers_day":
                return "Ngày của Mẹ (Mother's Day)";
            default:
                return "Chúc mừng chung / Gửi gắm tình cảm";
        }
    }

    private String translateTone(String tone) {
        switch (tone.toLowerCase().trim()) {
            case "warm": return "Ấm áp, chân thành, sâu lắng";
            case "funny": return "Hóm hỉnh, hài hước, vui tươi, trẻ trung";
            case "formal": return "Trang trọng, lịch thiệp, tôn kính (cho đối tác, người lớn tuổi)";
            case "sweet": return "Ngọt ngào, lãng mạn, dễ thương (cho người yêu)";
            case "inspiring": return "Truyền cảm hứng, tích cực, động viên vượt qua khó khăn";
            default: return "Chân thành, tự nhiên";
        }
    }

    private String translateLength(String length) {
        switch (length.toLowerCase().trim()) {
            case "ngan":
            case "short": 
                return "Rất ngắn gọn (1-2 câu, dưới 40 từ)";
            case "trungbinh":
            case "medium": 
                return "Trung bình (2-3 câu, khoảng 40-60 từ)";
            case "dai":
            case "long": 
                return "Đầy đủ (3-4 câu, khoảng 60-80 từ)";
            default: 
                return "Khoảng 50 từ";
        }
    }
}
