package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho bảng wishlist trong database
 */
public class Wishlist {
    private int id;
    private int userId;
    private int productId;
    private Timestamp createdAt;
    
    // Thêm trường cho product (khi join)
    private Product product;
    
    // Constructors
    public Wishlist() {}
    
    public Wishlist(int userId, int productId) {
        this.userId = userId;
        this.productId = productId;
    }
    
    public Wishlist(int id, int userId, int productId, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
    }
    
    @Override
    public String toString() {
        return "Wishlist{" +
                "id=" + id +
                ", userId=" + userId +
                ", productId=" + productId +
                ", createdAt=" + createdAt +
                '}';
    }
}
