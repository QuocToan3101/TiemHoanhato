package model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Session cart item for guest users.
 */
public class SessionCartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int productId;
    private String name;
    private BigDecimal price;
    private int quantity;
    private String image;

    public SessionCartItem() {
    }

    public SessionCartItem(int productId, String name, BigDecimal price, int quantity, String image) {
        this.productId = productId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public BigDecimal getSubtotal() {
        if (price == null) {
            return BigDecimal.ZERO;
        }
        return price.multiply(BigDecimal.valueOf(quantity));
    }
}
