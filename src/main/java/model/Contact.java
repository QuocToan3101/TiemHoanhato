package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho liên hệ từ khách hàng
 */
public class Contact {
    private int id;
    private String name;
    private String phone;
    private String email;
    private String subject;
    private String message;
    private String status; // new, read, replied
    private String adminNote;
    private Integer userId; // Có thể null nếu khách vãng lai
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructors
    public Contact() {}
    
    public Contact(String name, String phone, String message) {
        this.name = name;
        this.phone = phone;
        this.message = message;
        this.status = "new";
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getAdminNote() { return adminNote; }
    public void setAdminNote(String adminNote) { this.adminNote = adminNote; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    /**
     * Lấy tên chủ đề tiếng Việt
     */
    public String getSubjectName() {
        if (subject == null) return "Khác";
        switch (subject) {
            case "order": return "Đặt hoa theo yêu cầu";
            case "consult": return "Tư vấn tone màu / concept";
            case "event": return "Hoa khai trương - sự kiện";
            case "wedding": return "Hoa cưới";
            case "partner": return "Hợp tác / đối tác";
            default: return "Khác";
        }
    }
    
    /**
     * Lấy tên trạng thái tiếng Việt
     */
    public String getStatusName() {
        if (status == null) return "Mới";
        switch (status) {
            case "new": return "Mới";
            case "read": return "Đã xem";
            case "replied": return "Đã phản hồi";
            default: return status;
        }
    }
    
    @Override
    public String toString() {
        return "Contact{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", phone='" + phone + '\'' +
                ", subject='" + subject + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
