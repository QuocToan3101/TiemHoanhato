package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model đại diện cho bảng order_items trong database
 */
public class OrderItem {
    private int id;
    private int orderId;
    private Integer productId;
    private String productName;
    private String productImage;
    private BigDecimal price;
    private int quantity;
    private BigDecimal total;
    private Timestamp createdAt;
    
    // Quan hệ
    private Product product;
    
    // Constructors
    public OrderItem() {}
    
    public OrderItem(int orderId, int productId, String productName, 
                    String productImage, BigDecimal price, int quantity) {
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.productImage = productImage;
        this.price = price;
        this.quantity = quantity;
        this.total = price.multiply(new BigDecimal(quantity));
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    
    // Helper methods
    public String getFormattedPrice() {
        return String.format("%,.0f ₫", price);
    }
    
    public String getFormattedTotal() {
        return String.format("%,.0f ₫", total);
    }
    
    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", productName='" + productName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", total=" + total +
                '}';
    }
}
