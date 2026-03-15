package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model đại diện cho bảng cart trong database
 */
public class CartItem {
    private int id;
    private int userId;
    private int productId;
    private int quantity;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Quan hệ với Product
    private Product product;
    
    // Constructors
    public CartItem() {}
    
    public CartItem(int userId, int productId, int quantity) {
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    
    // Helper methods
    /**
     * Tính tổng tiền của item này
     */
    public BigDecimal getSubtotal() {
        if (product == null) return BigDecimal.ZERO;
        return product.getDisplayPrice().multiply(new BigDecimal(quantity));
    }
    
    public String getFormattedSubtotal() {
        return String.format("%,.0f ₫", getSubtotal());
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", userId=" + userId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                '}';
    }
}
