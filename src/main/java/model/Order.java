package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Model đại diện cho bảng orders trong database
 */
public class Order {
    private int id;
    private String orderCode;
    private Integer userId;
    private String receiverName;
    private String receiverPhone;
    private String receiverEmail;
    private String shippingAddress;
    private String note;
    private BigDecimal subtotal;
    private BigDecimal shippingFee;
    private BigDecimal discount;
    private BigDecimal total;
    private String paymentMethod; // cod, bank_transfer, vnpay, momo
    private String paymentStatus; // pending, paid, failed, refunded
    private String orderStatus; // pending, confirmed, processing, shipping, delivered, cancelled
    private String cancelledReason;
    private Timestamp deliveredAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Quan hệ
    private User user;
    private List<OrderItem> orderItems = new ArrayList<>();
    
    // Constructors
    public Order() {}
    
    public Order(String orderCode, String receiverName, String receiverPhone, 
                String shippingAddress, BigDecimal total) {
        this.orderCode = orderCode;
        this.receiverName = receiverName;
        this.receiverPhone = receiverPhone;
        this.shippingAddress = shippingAddress;
        this.total = total;
        this.paymentMethod = "cod";
        this.paymentStatus = "pending";
        this.orderStatus = "pending";
    }
    
    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
    
    public String getReceiverPhone() { return receiverPhone; }
    public void setReceiverPhone(String receiverPhone) { this.receiverPhone = receiverPhone; }
    
    public String getReceiverEmail() { return receiverEmail; }
    public void setReceiverEmail(String receiverEmail) { this.receiverEmail = receiverEmail; }
    
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    
    public BigDecimal getShippingFee() { return shippingFee; }
    public void setShippingFee(BigDecimal shippingFee) { this.shippingFee = shippingFee; }
    
    public BigDecimal getDiscount() { return discount; }
    public void setDiscount(BigDecimal discount) { this.discount = discount; }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }
    
    public String getCancelledReason() { return cancelledReason; }
    public void setCancelledReason(String cancelledReason) { this.cancelledReason = cancelledReason; }
    
    public Timestamp getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(Timestamp deliveredAt) { this.deliveredAt = deliveredAt; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public List<OrderItem> getOrderItems() { return orderItems; }
    public void setOrderItems(List<OrderItem> orderItems) { this.orderItems = orderItems; }
    
    // Helper methods
    public String getPaymentMethodText() {
        switch (paymentMethod) {
            case "cod": return "Thanh toán khi nhận hàng";
            case "bank_transfer": return "Chuyển khoản ngân hàng";
            case "vnpay": return "VNPay";
            case "momo": return "Ví MoMo";
            default: return paymentMethod;
        }
    }
    
    public String getPaymentStatusText() {
        switch (paymentStatus) {
            case "pending": return "Chờ thanh toán";
            case "paid": return "Đã thanh toán";
            case "failed": return "Thanh toán thất bại";
            case "refunded": return "Đã hoàn tiền";
            default: return paymentStatus;
        }
    }
    
    public String getOrderStatusText() {
        switch (orderStatus) {
            case "pending": return "Chờ xác nhận";
            case "confirmed": return "Đã xác nhận";
            case "processing": return "Đang xử lý";
            case "shipping": return "Đang giao hàng";
            case "delivered": return "Đã giao hàng";
            case "cancelled": return "Đã hủy";
            default: return orderStatus;
        }
    }
    
    public String getOrderStatusColor() {
        switch (orderStatus) {
            case "pending": return "#f59e0b";
            case "confirmed": return "#3b82f6";
            case "processing": return "#8b5cf6";
            case "shipping": return "#06b6d4";
            case "delivered": return "#10b981";
            case "cancelled": return "#ef4444";
            default: return "#6b7280";
        }
    }
    
    public String getFormattedTotal() {
        return String.format("%,.0f ₫", total);
    }
    
    public void addOrderItem(OrderItem item) {
        this.orderItems.add(item);
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", orderCode='" + orderCode + '\'' +
                ", receiverName='" + receiverName + '\'' +
                ", total=" + total +
                ", orderStatus='" + orderStatus + '\'' +
                '}';
    }
}
