package dto;

import java.io.Serializable;

/**
 * Immutable state object cho AI Card generation
 * Lưu trữ toàn bộ thông tin thiệp được tạo
 */
public class AICardState implements Serializable {
    private static final long serialVersionUID = 1L;

    private final String recipient;
    private final String occasion;
    private final String tone;
    private final String customMessage;
    private final String length;
    private final String sender;

    // NEW
    private final String theme;       // Chủ đề thiệp
    private final String holiday;     // Ngày lễ

    private final String generatedMessage;
    private final String imageData;
    private final String backgroundImageUrl;
    private final String createdAt;
    private final String source;

    public AICardState(Builder builder) {
        this.recipient = builder.recipient;
        this.occasion = builder.occasion;
        this.tone = builder.tone;
        this.customMessage = builder.customMessage;
        this.length = builder.length;
        this.sender = builder.sender;

        // NEW
        this.theme = builder.theme;
        this.holiday = builder.holiday;

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

    // NEW
    public String getTheme() { return theme; }
    public String getHoliday() { return holiday; }

    public String getGeneratedMessage() { return generatedMessage; }
    public String getImageData() { return imageData; }
    public String getBackgroundImageUrl() { return backgroundImageUrl; }
    public String getCreatedAt() { return createdAt; }
    public String getSource() { return source; }

    public boolean isValid() {
        return recipient != null &&
                occasion != null &&
                tone != null &&
                generatedMessage != null;
    }

    @Override
    public String toString() {
        return "AICardState{" +
                "recipient='" + recipient + '\'' +
                ", occasion='" + occasion + '\'' +
                ", tone='" + tone + '\'' +
                ", theme='" + theme + '\'' +
                ", holiday='" + holiday + '\'' +
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

        // NEW
        private String theme = "default";
        private String holiday = "none";

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

        // NEW
        public Builder theme(String val) {
            this.theme = val != null ? val : "default";
            return this;
        }

        public Builder holiday(String val) {
            this.holiday = val != null ? val : "none";
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
            this.createdAt = val != null
                    ? val
                    : System.currentTimeMillis() + "";
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