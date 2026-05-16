package model;

import java.math.BigDecimal;

/**
 * Generic response model for cart operations.
 */
public class CartOperationResult {
    private boolean success;
    private String message;
    private int cartCount;
    private BigDecimal cartTotal;

    public CartOperationResult() {
        this.cartTotal = BigDecimal.ZERO;
    }

    public CartOperationResult(boolean success, String message) {
        this.success = success;
        this.message = message;
        this.cartTotal = BigDecimal.ZERO;
    }

    public CartOperationResult(boolean success, String message, int cartCount, BigDecimal cartTotal) {
        this.success = success;
        this.message = message;
        this.cartCount = cartCount;
        this.cartTotal = cartTotal != null ? cartTotal : BigDecimal.ZERO;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getCartCount() {
        return cartCount;
    }

    public void setCartCount(int cartCount) {
        this.cartCount = cartCount;
    }

    public BigDecimal getCartTotal() {
        return cartTotal;
    }

    public void setCartTotal(BigDecimal cartTotal) {
        this.cartTotal = cartTotal != null ? cartTotal : BigDecimal.ZERO;
    }
}
