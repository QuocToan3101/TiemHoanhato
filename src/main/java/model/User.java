package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho bảng users trong database
 */
public class User {
    private int id;
    private String email;
    private String password;
    private String fullname;
    private String phone;
    private String avatar;
    private String bio;
    private String gender;
    private java.sql.Date birthday;
    private String role; // customer, admin
    private String status; // active, inactive, banned
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructors
    public User() {}
    
    public User(String email, String password, String fullname) {
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.role = "customer";
        this.status = "active";
    }
    
    public User(int id, String email, String password, String fullname, String phone, 
                String avatar, String bio, String gender, java.sql.Date birthday,
                String role, String status, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.phone = phone;
        this.avatar = avatar;
        this.bio = bio;
        this.gender = gender;
        this.birthday = birthday;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public java.sql.Date getBirthday() { return birthday; }
    public void setBirthday(java.sql.Date birthday) { this.birthday = birthday; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    // Helper methods
    public boolean isAdmin() {
        return "admin".equals(this.role);
    }
    
    public boolean isActive() {
        return "active".equals(this.status);
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", email='" + email + '\'' +
                ", fullname='" + fullname + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
