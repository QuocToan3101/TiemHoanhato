package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;

/**
 * Đại diện cho một mục hàng trong giỏ hàng lưu tại Session (dành cho Khách).
 */
public class SessionCartItem implements Serializable {
    private static final long serialVersionUID = 20260521L; // Đổi số serial tương thích

    private int productId;
    private String name;
    private BigDecimal price;
    private int quantity;
    private String image;

    // Constructor mặc định
    public SessionCartItem() {
    }

    // Backward-compatible constructor
    public SessionCartItem(int productId, String name, java.math.BigDecimal price, int quantity, String image) {
        this.productId = productId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
    }

    // Toàn bộ tham số constructor (được tối ưu hóa bằng Builder)
    private SessionCartItem(Builder builder) {
        this.productId = builder.productId;
        this.name = builder.name;
        this.price = builder.price;
        this.quantity = builder.quantity;
        this.image = builder.image;
    }

    // --- Tính toán phụ trợ ---
    public BigDecimal getSubtotal() {
        return (this.price == null)
                ? BigDecimal.ZERO
                : this.price.multiply(BigDecimal.valueOf(this.quantity));
    }

    // --- Getters và Setters (Viết theo phong cách Fluent/Chainable hoặc chuẩn JavaBean) ---
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    // --- Bổ sung hàm tiện ích để tăng tính chuyên nghiệp ---
    public void incrementQuantity(int amount) {
        this.quantity += amount;
    }

    // --- Builder Pattern để khởi tạo đối tượng "clean" hơn ---
    public static class Builder {
        private int productId;
        private String name;
        private BigDecimal price;
        private int quantity = 1; // mặc định là 1 hàng
        private String image;

        public Builder productId(int productId) { this.productId = productId; return this; }
        public Builder name(String name) { this.name = name; return this; }
        public Builder price(BigDecimal price) { this.price = price; return this; }
        public Builder quantity(int quantity) { this.quantity = quantity; return this; }
        public Builder image(String image) { this.image = image; return this; }

        public SessionCartItem build() {
            return new SessionCartItem(this);
        }
    }

    // --- Ghi đè toString phục vụ cho việc Debug/Log thuận tiện ---
    @Override
    public String toString() {
        return String.format("CartItem[ID=%d, Name=%s, Qty=%d, Subtotal=%s]",
                productId, name, quantity, getSubtotal());
    }
}