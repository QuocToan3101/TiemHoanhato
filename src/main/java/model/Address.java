package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho bảng addresses trong database
 */
public class Address {
    private int id;
    private int userId;
    private String receiverName;
    private String phone;
    private String province;
    private String district;
    private String ward;
    private String addressDetail;
    private String note;
    private boolean isDefault;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructors
    public Address() {}
    
    public Address(int userId, String receiverName, String phone, String addressDetail) {
        this.userId = userId;
        this.receiverName = receiverName;
        this.phone = phone;
        this.addressDetail = addressDetail;
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }
    
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    
    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }
    
    public String getAddressDetail() { return addressDetail; }
    public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }
    
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    
    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean aDefault) { isDefault = aDefault; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    // Helper methods
    /**
     * Lấy địa chỉ đầy đủ
     */
    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();
        sb.append(addressDetail);
        if (ward != null && !ward.isEmpty()) {
            sb.append(", ").append(ward);
        }
        if (district != null && !district.isEmpty()) {
            sb.append(", ").append(district);
        }
        if (province != null && !province.isEmpty()) {
            sb.append(", ").append(province);
        }
        return sb.toString();
    }
    
    @Override
    public String toString() {
        return "Address{" +
                "id=" + id +
                ", receiverName='" + receiverName + '\'' +
                ", phone='" + phone + '\'' +
                ", fullAddress='" + getFullAddress() + '\'' +
                ", isDefault=" + isDefault +
                '}';
    }
}
