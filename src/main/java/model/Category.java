package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho bảng categories trong database
 */
public class Category {
    private int id;
    private String name;
    private String slug;
    private String description;
    private String image;
    private Integer parentId;
    private int displayOrder;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Thêm trường cho category cha (nếu cần)
    private Category parentCategory;
    
    // Số lượng sản phẩm trong danh mục
    private int productCount;
    
    // Constructors
    public Category() {}
    
    public Category(String name, String slug) {
        this.name = name;
        this.slug = slug;
        this.isActive = true;
    }
    
    public Category(int id, String name, String slug, String description, String image,
                   Integer parentId, int displayOrder, boolean isActive,
                   Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.name = name;
        this.slug = slug;
        this.description = description;
        this.image = image;
        this.parentId = parentId;
        this.displayOrder = displayOrder;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }
    
    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public Category getParentCategory() { return parentCategory; }
    public void setParentCategory(Category parentCategory) { this.parentCategory = parentCategory; }
    
    public int getProductCount() { return productCount; }
    public void setProductCount(int productCount) { this.productCount = productCount; }
    
    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", slug='" + slug + '\'' +
                ", parentId=" + parentId +
                ", isActive=" + isActive +
                '}';
    }
}
