package model;

import java.util.Date;

/**
 * Model cho bảng gallery - Khoảnh khắc đáng nhớ
 */
public class Gallery {
    private int id;
    private String imageUrl;
    private String caption;
    private String description;
    private int displayOrder;
    private boolean isActive;
    private Date createdAt;
    private Date updatedAt;
    
    public Gallery() {
    }
    
    public Gallery(String imageUrl, String caption) {
        this.imageUrl = imageUrl;
        this.caption = caption;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getCaption() {
        return caption;
    }
    
    public void setCaption(String caption) {
        this.caption = caption;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getDisplayOrder() {
        return displayOrder;
    }
    
    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Date getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @Override
    public String toString() {
        return "Gallery{" +
                "id=" + id +
                ", caption='" + caption + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", displayOrder=" + displayOrder +
                ", isActive=" + isActive +
                '}';
    }
}
