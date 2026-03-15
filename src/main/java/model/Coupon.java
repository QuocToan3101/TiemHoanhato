package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model đại diện cho bảng coupons trong database
 */
public class Coupon {
    private int id;
    private String code;
    private String description;
    private String discountType; // percent, fixed
    private BigDecimal discountValue;
    private BigDecimal minOrderValue;
    private BigDecimal maxDiscount;
    private Integer usageLimit;
    private int usedCount;
    private Timestamp startDate;
    private Timestamp endDate;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructors
    public Coupon() {}
    
    public Coupon(String code, String discountType, BigDecimal discountValue) {
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.isActive = true;
        this.usedCount = 0;
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    
    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }
    
    public BigDecimal getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(BigDecimal minOrderValue) { this.minOrderValue = minOrderValue; }
    
    public BigDecimal getMaxDiscount() { return maxDiscount; }
    public void setMaxDiscount(BigDecimal maxDiscount) { this.maxDiscount = maxDiscount; }
    
    public Integer getUsageLimit() { return usageLimit; }
    public void setUsageLimit(Integer usageLimit) { this.usageLimit = usageLimit; }
    
    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }
    
    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }
    
    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    // Helper methods
    public boolean isValid() {
        if (!isActive) return false;
        
        Timestamp now = new Timestamp(System.currentTimeMillis());
        
        if (startDate != null && now.before(startDate)) return false;
        if (endDate != null && now.after(endDate)) return false;
        
        if (usageLimit != null && usedCount >= usageLimit) return false;
        
        return true;
    }
    
    public BigDecimal calculateDiscount(BigDecimal orderTotal) {
        if (!isValid()) return BigDecimal.ZERO;
        if (minOrderValue != null && orderTotal.compareTo(minOrderValue) < 0) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal discount;
        if ("percent".equals(discountType)) {
            discount = orderTotal.multiply(discountValue).divide(new BigDecimal(100));
            if (maxDiscount != null && discount.compareTo(maxDiscount) > 0) {
                discount = maxDiscount;
            }
        } else {
            discount = discountValue;
        }
        
        return discount;
    }
    
    @Override
    public String toString() {
        return "Coupon{" +
                "id=" + id +
                ", code='" + code + '\'' +
                ", discountType='" + discountType + '\'' +
                ", discountValue=" + discountValue +
                ", isActive=" + isActive +
                '}';
    }
}
