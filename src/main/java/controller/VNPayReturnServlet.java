package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.OrderDAO;
import model.Order;
import payment.VNPayConfig;

/**
 * Servlet xử lý VNPay callback
 */
@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {
    
    private VNPayConfig vnpayConfig;
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        vnpayConfig = new VNPayConfig();
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy tất cả parameters từ VNPay
        Map<String, String> fields = new HashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String fieldName = entry.getKey();
            String fieldValue = entry.getValue()[0];
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }
        
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef"); // Order Code
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_Amount = request.getParameter("vnp_Amount");
        
        // Xác thực chữ ký
        boolean isValidSignature = vnpayConfig.validateSignature(fields, vnp_SecureHash);
        
        if (isValidSignature) {
            // Chữ ký hợp lệ
            if ("00".equals(vnp_ResponseCode)) {
                // Thanh toán thành công
                Order order = orderDAO.findByOrderCode(vnp_TxnRef);
                
                if (order != null) {
                    // Cập nhật trạng thái thanh toán
                    orderDAO.updatePaymentStatus(order.getId(), "paid");
                    
                    // Log transaction
                    System.out.println("✓ VNPay payment successful:");
                    System.out.println("  Order Code: " + vnp_TxnRef);
                    System.out.println("  Transaction No: " + vnp_TransactionNo);
                    System.out.println("  Amount: " + (Long.parseLong(vnp_Amount) / 100) + " VND");
                    
                    // Redirect to success page
                    response.sendRedirect(request.getContextPath() + 
                        "/order-success?orderCode=" + vnp_TxnRef + 
                        "&payment=success");
                } else {
                    System.err.println("✗ Order not found: " + vnp_TxnRef);
                    response.sendRedirect(request.getContextPath() + 
                        "/order-success?error=order_not_found");
                }
            } else {
                // Thanh toán thất bại
                String statusMessage = vnpayConfig.getTransactionStatus(vnp_ResponseCode);
                
                System.err.println("✗ VNPay payment failed:");
                System.err.println("  Order Code: " + vnp_TxnRef);
                System.err.println("  Response Code: " + vnp_ResponseCode);
                System.err.println("  Message: " + statusMessage);
                
                // Cập nhật trạng thái thanh toán thất bại
                Order order = orderDAO.findByOrderCode(vnp_TxnRef);
                if (order != null) {
                    orderDAO.updatePaymentStatus(order.getId(), "failed");
                }
                
                // Redirect to error page
                response.sendRedirect(request.getContextPath() + 
                    "/checkout?error=payment_failed&message=" + 
                    java.net.URLEncoder.encode(statusMessage, "UTF-8"));
            }
        } else {
            // Chữ ký không hợp lệ
            System.err.println("✗ Invalid VNPay signature!");
            response.sendRedirect(request.getContextPath() + 
                "/checkout?error=invalid_signature");
        }
    }
}
