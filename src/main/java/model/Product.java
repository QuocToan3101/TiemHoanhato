package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model đại diện cho bảng products trong database
 */
public class Product {
    private int id;
    private Integer categoryId;
    private String name;
    private String slug;
    private String description;
    private String shortDescription;
    private BigDecimal price;
    private BigDecimal salePrice;
    private int quantity;
    private String image;
    private String images; // JSON array
    private boolean isFeatured;
    private boolean isActive;
    private int viewCount;
    private int soldCount;
    private BigDecimal averageRating; // Điểm đánh giá trung bình
    private int reviewCount; // Số lượng đánh giá
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Thêm trường cho category (nếu cần join)
    private Category category;
    
    // Constructors
    public Product() {}
    
    public Product(String name, String slug, BigDecimal price) {
        this.name = name;
        this.slug = slug;
        this.price = price;
        this.isActive = true;
    }
    
    public Product(int id, Integer categoryId, String name, String slug, String description,
                  String shortDescription, BigDecimal price, BigDecimal salePrice,
                  int quantity, String image, String images, boolean isFeatured,
                  boolean isActive, int viewCount, int soldCount,
                  Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.slug = slug;
        this.description = description;
        this.shortDescription = shortDescription;
        this.price = price;
        this.salePrice = salePrice;
        this.quantity = quantity;
        this.image = image;
        this.images = images;
        this.isFeatured = isFeatured;
        this.isActive = isActive;
        this.viewCount = viewCount;
        this.soldCount = soldCount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getShortDescription() { return shortDescription; }
    public void setShortDescription(String shortDescription) { this.shortDescription = shortDescription; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    
    public boolean isFeatured() { return isFeatured; }
    public void setFeatured(boolean featured) { isFeatured = featured; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }
    
    public int getSoldCount() { return soldCount; }
    public void setSoldCount(int soldCount) { this.soldCount = soldCount; }
    
    public BigDecimal getAverageRating() { return averageRating; }
    public void setAverageRating(BigDecimal averageRating) { this.averageRating = averageRating; }
    
    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    
    // Helper methods
    /**
     * Lấy giá hiển thị (giá sale nếu có, không thì giá gốc)
     */
    public BigDecimal getDisplayPrice() {
        if (salePrice != null && salePrice.compareTo(BigDecimal.ZERO) > 0) {
            return salePrice;
        }
        return price != null ? price : BigDecimal.ZERO;
    }
    
    /**
     * Kiểm tra sản phẩm có đang giảm giá không
     */
    public boolean isOnSale() {
        return salePrice != null && salePrice.compareTo(price) < 0;
    }
    
    /**
     * Tính phần trăm giảm giá
     */
    public int getDiscountPercent() {
        if (!isOnSale()) return 0;
        return price.subtract(salePrice)
                   .multiply(new BigDecimal(100))
                   .divide(price, 0, java.math.RoundingMode.HALF_UP)
                   .intValue();
    }
    
    /**
     * Kiểm tra còn hàng không
     */
    public boolean isInStock() {
        return quantity > 0;
    }
    
    /**
     * Format giá thành chuỗi VND
     */
    public String getFormattedPrice() {
        return formatCurrency(price);
    }
    
    public String getFormattedSalePrice() {
        return salePrice != null ? formatCurrency(salePrice) : null;
    }
    
    public String getFormattedDisplayPrice() {
        return formatCurrency(getDisplayPrice());
    }
    
    private String formatCurrency(BigDecimal amount) {
        if (amount == null) return "0 ₫";
        return String.format("%,.0f ₫", amount);
    }
    
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", salePrice=" + salePrice +
                ", quantity=" + quantity +
                ", isActive=" + isActive +
                '}';
    }
}
