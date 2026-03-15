package model;

import java.util.Date;

/**
 * Model cho bảng news - Tin tức/Blog
 */
public class News {
    private int id;
    private String title;
    private String slug;
    private String excerpt;
    private String content;
    private String imageUrl;
    private String category;
    private String author;
    private int views;
    private boolean isPublished;
    private Date publishedDate;
    private Date createdAt;
    private Date updatedAt;
    
    public News() {
    }
    
    public News(String title, String excerpt, String content) {
        this.title = title;
        this.excerpt = excerpt;
        this.content = content;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getSlug() {
        return slug;
    }
    
    public void setSlug(String slug) {
        this.slug = slug;
    }
    
    public String getExcerpt() {
        return excerpt;
    }
    
    public void setExcerpt(String excerpt) {
        this.excerpt = excerpt;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getAuthor() {
        return author;
    }
    
    public void setAuthor(String author) {
        this.author = author;
    }
    
    public int getViews() {
        return views;
    }
    
    public void setViews(int views) {
        this.views = views;
    }
    
    public boolean isPublished() {
        return isPublished;
    }
    
    public void setPublished(boolean published) {
        isPublished = published;
    }
    
    public Date getPublishedDate() {
        return publishedDate;
    }
    
    public void setPublishedDate(Date publishedDate) {
        this.publishedDate = publishedDate;
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
    
    /**
     * Get category display name
     */
    public String getCategoryName() {
        switch (category != null ? category : "") {
            case "tips": return "Tips chọn hoa";
            case "opening": return "Khai trương";
            case "story": return "Câu chuyện";
            case "proposal": return "Cầu hôn";
            case "wedding": return "Đám cưới";
            case "birthday": return "Sinh nhật";
            default: return category;
        }
    }
    
    @Override
    public String toString() {
        return "News{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", slug='" + slug + '\'' +
                ", category='" + category + '\'' +
                ", views=" + views +
                ", isPublished=" + isPublished +
                '}';
    }
}
