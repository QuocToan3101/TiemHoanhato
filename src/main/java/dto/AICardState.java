package dto;

import java.io.Serializable;

/**
 * Immutable state object cho AI Card generation
 * Lưu trữ toàn bộ thông tin thiệp được tạo
 */
public class AICardState implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private final String recipient;           // Người nhận
    private final String occasion;            // Dịp (sinh nhật, kỷ niệm, etc)
    private final String tone;                // Giọng điệu (ấm áp, hài hước, etc)
    private final String customMessage;       // Lời nhắn tùy chỉnh (nếu có)
    private final String length;              // Độ dài (ngắn, vừa, dài)
    private final String sender;              // Người gửi
    private final String generatedMessage;    // Lời chúc được sinh ra
    private final String imageData;           // Base64 image data
    private final String backgroundImageUrl;  // Background image URL
    private final String createdAt;           // Timestamp tạo
    private final String source;              // Nguồn (gemini-ai, fallback, etc)
    
    public AICardState(Builder builder) {
        this.recipient = builder.recipient;
        this.occasion = builder.occasion;
        this.tone = builder.tone;
        this.customMessage = builder.customMessage;
        this.length = builder.length;
        this.sender = builder.sender;
        this.generatedMessage = builder.generatedMessage;
        this.imageData = builder.imageData;
        this.backgroundImageUrl = builder.backgroundImageUrl;
        this.createdAt = builder.createdAt;
        this.source = builder.source;
    }
    
    // Getters
    public String getRecipient() { return recipient; }
    public String getOccasion() { return occasion; }
    public String getTone() { return tone; }
    public String getCustomMessage() { return customMessage; }
    public String getLength() { return length; }
    public String getSender() { return sender; }
    public String getGeneratedMessage() { return generatedMessage; }
    public String getImageData() { return imageData; }
    public String getBackgroundImageUrl() { return backgroundImageUrl; }
    public String getCreatedAt() { return createdAt; }
    public String getSource() { return source; }
    
    public boolean isValid() {
        return recipient != null && occasion != null && 
               tone != null && generatedMessage != null;
    }
    
    @Override
    public String toString() {
        return "AICardState{" +
                "recipient='" + recipient + '\'' +
                ", occasion='" + occasion + '\'' +
                ", tone='" + tone + '\'' +
                ", length='" + length + '\'' +
                ", source='" + source + '\'' +
                ", createdAt='" + createdAt + '\'' +
                '}';
    }
    
    // Builder Pattern
    public static class Builder {
        private String recipient = "";
        private String occasion = "khac";
        private String tone = "warm";
        private String customMessage = "";
        private String length = "trungbinh";
        private String sender = "";
        private String generatedMessage = "";
        private String imageData = "";
        private String backgroundImageUrl = "";
        private String createdAt = System.currentTimeMillis() + "";
        private String source = "fallback";
        
        public Builder recipient(String val) {
            this.recipient = val != null ? val : "";
            return this;
        }
        
        public Builder occasion(String val) {
            this.occasion = val != null ? val : "khac";
            return this;
        }
        
        public Builder tone(String val) {
            this.tone = val != null ? val : "warm";
            return this;
        }
        
        public Builder customMessage(String val) {
            this.customMessage = val != null ? val : "";
            return this;
        }
        
        public Builder length(String val) {
            this.length = val != null ? val : "trungbinh";
            return this;
        }
        
        public Builder sender(String val) {
            this.sender = val != null ? val : "";
            return this;
        }
        
        public Builder generatedMessage(String val) {
            this.generatedMessage = val != null ? val : "";
            return this;
        }
        
        public Builder imageData(String val) {
            this.imageData = val != null ? val : "";
            return this;
        }
        
        public Builder backgroundImageUrl(String val) {
            this.backgroundImageUrl = val != null ? val : "";
            return this;
        }
        
        public Builder createdAt(String val) {
            this.createdAt = val != null ? val : System.currentTimeMillis() + "";
            return this;
        }
        
        public Builder source(String val) {
            this.source = val != null ? val : "fallback";
            return this;
        }
        
        public AICardState build() {
            return new AICardState(this);
        }
    }
}
