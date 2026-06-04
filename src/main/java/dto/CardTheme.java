package dto;

import java.io.Serializable;

/**
 * AI Greeting Card Themes - Professional Canva/Hallmark designs
 */
public enum CardTheme implements Serializable {
    LUXURY_ROSE("luxury_rose", "Luxury Rose", "#FDF7F7", "#F6D6D6", "#C97B84", "#EAB8B8", "rose"),
    SUNFLOWER_BIRTHDAY("sunflower_birthday", "Sunflower Birthday", "#FFF8E7", "#FFD95A", "#8F6B00", "#F4B400", "sunflower"),
    WEDDING_GOLD("wedding_gold", "Wedding Gold", "#FFFFFF", "#F8F4EC", "#5A4B29", "#D4AF37", "baby_flower"),
    MOTHERS_DAY("mothers_day", "Mothers Day", "#FFF0F5", "#FFE4E1", "#8B4513", "#FFB6C1", "carnation"),
    THANK_YOU("thank_you", "Thank You", "#F4F9F4", "#E8F5E9", "#2E7D32", "#A9DFBF", "tulip"),
    CONGRATULATION("congratulation", "Congratulation", "#F0F4C3", "#E8F8F5", "#0E6251", "#76D7C4", "hydrangea"),
    VALENTINE("valentine", "Valentine", "#FFF5F5", "#FFE3E3", "#C92A2A", "#FFA8A8", "red_rose"),
    ANNIVERSARY("anniversary", "Anniversary", "#FFF0F6", "#FFDEEB", "#A61E4D", "#FAA2C1", "peony"),
    GRADUATION("graduation", "Graduation", "#F3F0FC", "#E5DBFF", "#3F1B93", "#B197FC", "sunflower_eucalyptus"),
    CHRISTMAS("christmas", "Christmas", "#FFF5F5", "#FFD6D6", "#C92A2A", "#FFA8A8", "christmas"),
    CUSTOM_AI("custom_ai", "Custom AI Theme", "#FAF6F0", "#F3E9E3", "#5C3D2E", "#C99366", "rose");

    private final String id;
    private final String displayName;
    private String bgColor1;
    private String bgColor2;
    private String textColor;
    private String borderColor;
    private String flowerType;

    CardTheme(String id, String displayName, String bgColor1, String bgColor2, 
              String textColor, String borderColor, String flowerType) {
        this.id = id;
        this.displayName = displayName;
        this.bgColor1 = bgColor1;
        this.bgColor2 = bgColor2;
        this.textColor = textColor;
        this.borderColor = borderColor;
        this.flowerType = flowerType;
    }

    public String getId() { return id; }
    public String getDisplayName() { return displayName; }
    public String getBgColor1() { return bgColor1; }
    public String getBgColor2() { return bgColor2; }
    public String getTextColor() { return textColor; }
    public String getBorderColor() { return borderColor; }
    public String getFlowerType() { return flowerType; }

    // Allows dynamic custom AI theme updates
    public void updateCustomTheme(String bg1, String bg2, String text, String border, String flower) {
        if (this == CUSTOM_AI) {
            if (bg1 != null && !bg1.isEmpty()) this.bgColor1 = bg1;
            if (bg2 != null && !bg2.isEmpty()) this.bgColor2 = bg2;
            if (text != null && !text.isEmpty()) this.textColor = text;
            if (border != null && !border.isEmpty()) this.borderColor = border;
            if (flower != null && !flower.isEmpty()) this.flowerType = flower;
        }
    }

    /**
     * Get theme by ID, falls back to LUXURY_ROSE
     */
    public static CardTheme getById(String id) {
        if (id == null) return LUXURY_ROSE;
        for (CardTheme theme : values()) {
            if (theme.getId().equalsIgnoreCase(id.trim())) {
                return theme;
            }
        }
        return LUXURY_ROSE;
    }
}
