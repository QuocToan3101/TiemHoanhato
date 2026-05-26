package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model đại diện cho một đơn đặt hàng tùy chỉnh (Custom Bouquet Order)
 */
public class CustomOrder {
    private int id;
    private int userId;
    private String flowerType;
    private String mainFlower;
    private String supportFlower;
    private String quantity;
    private String wrapPaper;
    private String colorTone;
    private String accessories;
    private String occasion;
    private BigDecimal budget;
    private BigDecimal estimatedPrice;
    private String customerNote;
    private String status; // pending, confirmed, processing, completed, cancelled
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Các trường phụ trợ cho việc hiển thị ở Admin dashboard
    private String userFullname;
    private String userEmail;
    private String userPhone;

    public CustomOrder() {
        this.status = "pending";
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

    public String getFlowerType() {
        return flowerType;
    }

    public void setFlowerType(String flowerType) {
        this.flowerType = flowerType;
    }

    public String getMainFlower() {
        return mainFlower;
    }

    public void setMainFlower(String mainFlower) {
        this.mainFlower = mainFlower;
    }

    public String getSupportFlower() {
        return supportFlower;
    }

    public void setSupportFlower(String supportFlower) {
        this.supportFlower = supportFlower;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public String getWrapPaper() {
        return wrapPaper;
    }

    public void setWrapPaper(String wrapPaper) {
        this.wrapPaper = wrapPaper;
    }

    public String getColorTone() {
        return colorTone;
    }

    public void setColorTone(String colorTone) {
        this.colorTone = colorTone;
    }

    public String getAccessories() {
        return accessories;
    }

    public void setAccessories(String accessories) {
        this.accessories = accessories;
    }

    public String getOccasion() {
        return occasion;
    }

    public void setOccasion(String occasion) {
        this.occasion = occasion;
    }

    public BigDecimal getBudget() {
        return budget;
    }

    public void setBudget(BigDecimal budget) {
        this.budget = budget;
    }

    public BigDecimal getEstimatedPrice() {
        return estimatedPrice;
    }

    public void setEstimatedPrice(BigDecimal estimatedPrice) {
        this.estimatedPrice = estimatedPrice;
    }

    public String getCustomerNote() {
        return customerNote;
    }

    public void setCustomerNote(String customerNote) {
        this.customerNote = customerNote;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUserFullname() {
        return userFullname;
    }

    public void setUserFullname(String userFullname) {
        this.userFullname = userFullname;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }

    @Override
    public String toString() {
        return "CustomOrder{" +
                "id=" + id +
                ", userId=" + userId +
                ", flowerType='" + flowerType + '\'' +
                ", mainFlower='" + mainFlower + '\'' +
                ", budget=" + budget +
                ", status='" + status + '\'' +
                '}';
    }
}
