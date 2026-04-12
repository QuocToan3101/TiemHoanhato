package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.OrderDAO;
import model.Order;
import payment.MoMoConfig;
import util.AppConfig;

/**
 * Servlet xử lý MoMo callback (return url và IPN)
 */
@WebServlet(urlPatterns = {"/momo-return", "/momo-notify"})
public class MoMoReturnServlet extends HttpServlet {
    
    private MoMoConfig momoConfig;
    private OrderDAO orderDAO;
    private AppConfig appConfig;
    
    @Override
    public void init() throws ServletException {
        momoConfig = new MoMoConfig();
        orderDAO = new OrderDAO();
        appConfig = AppConfig.getInstance();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleMoMoCallback(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleMoMoCallback(request, response);
    }
    
    private void handleMoMoCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String partnerCode = request.getParameter("partnerCode");
        String orderId = request.getParameter("orderId");
        String requestId = request.getParameter("requestId");
        String amount = request.getParameter("amount");
        String orderInfo = request.getParameter("orderInfo");
        String orderType = request.getParameter("orderType");
        String transId = request.getParameter("transId");
        String resultCode = request.getParameter("resultCode");
        String message = request.getParameter("message");
        String payType = request.getParameter("payType");
        String responseTime = request.getParameter("responseTime");
        String extraData = request.getParameter("extraData");
        String signature = request.getParameter("signature");
        
        // Build raw signature to validate
        String rawSignature = "accessKey=" + appConfig.getMoMoAccessKey() +
                "&amount=" + amount +
                "&extraData=" + extraData +
                "&message=" + message +
                "&orderId=" + orderId +
                "&orderInfo=" + orderInfo +
                "&orderType=" + orderType +
                "&partnerCode=" + partnerCode +
                "&payType=" + payType +
                "&requestId=" + requestId +
                "&responseTime=" + responseTime +
                "&resultCode=" + resultCode +
                "&transId=" + transId;
        
        // Validate signature
        boolean isValidSignature = momoConfig.validateSignature(rawSignature, signature);
        
        if (isValidSignature) {
            int resultCodeInt = Integer.parseInt(resultCode);
            
            if (resultCodeInt == 0) {
                // Thanh toán thành công
                Order order = orderDAO.findByOrderCode(orderId);
                
                if (order != null) {
                    if ("paid".equals(order.getPaymentStatus())) {
                        System.out.println("ℹ MoMo callback duplicate (already paid): " + orderId);

                        if (request.getServletPath().equals("/momo-notify")) {
                            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                            return;
                        }

                        response.sendRedirect(request.getContextPath() +
                            "/order-success?orderCode=" + orderId +
                            "&payment=success");
                        return;
                    }

                    long receivedAmount = Long.parseLong(amount);
                    long expectedAmount = order.getTotal().longValue();

                    if (receivedAmount != expectedAmount) {
                        System.err.println("✗ MoMo amount mismatch for order: " + orderId);
                        System.err.println("  Expected: " + expectedAmount + ", Received: " + receivedAmount);

                        if ("pending".equals(order.getPaymentStatus())) {
                            orderDAO.updatePaymentStatusIfCurrent(order.getId(), "pending", "failed");
                        }

                        if (request.getServletPath().equals("/momo-notify")) {
                            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                            return;
                        }

                        response.sendRedirect(request.getContextPath() + "/checkout?error=amount_mismatch");
                        return;
                    }

                    // Idempotency: chỉ cho phép pending -> paid
                    boolean updated = orderDAO.updatePaymentStatusIfCurrent(order.getId(), "pending", "paid");
                    if (!updated) {
                        Order latestOrder = orderDAO.findByOrderCode(orderId);
                        if (latestOrder != null && "paid".equals(latestOrder.getPaymentStatus())) {
                            System.out.println("ℹ MoMo callback duplicate after update race: " + orderId);
                        } else {
                            System.err.println("✗ MoMo callback ignored due to non-pending status: " + orderId);
                        }
                    }
                    
                    System.out.println("✓ MoMo payment successful:");
                    System.out.println("  Order Code: " + orderId);
                    System.out.println("  Transaction ID: " + transId);
                    System.out.println("  Amount: " + amount + " VND");
                    
                    // If this is IPN (notify), return 204
                    if (request.getServletPath().equals("/momo-notify")) {
                        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                        return;
                    }
                    
                    // Redirect to success page
                    response.sendRedirect(request.getContextPath() + 
                        "/order-success?orderCode=" + orderId + 
                        "&payment=success");
                } else {
                    System.err.println("✗ Order not found: " + orderId);
                    response.sendRedirect(request.getContextPath() + 
                        "/order-success?error=order_not_found");
                }
            } else {
                // Thanh toán thất bại
                String statusMessage = momoConfig.getResultMessage(resultCodeInt);
                
                System.err.println("✗ MoMo payment failed:");
                System.err.println("  Order Code: " + orderId);
                System.err.println("  Result Code: " + resultCode);
                System.err.println("  Message: " + message);
                
                // Cập nhật trạng thái thanh toán thất bại
                Order order = orderDAO.findByOrderCode(orderId);
                if (order != null) {
                    if ("pending".equals(order.getPaymentStatus())) {
                        orderDAO.updatePaymentStatusIfCurrent(order.getId(), "pending", "failed");
                    } else if ("paid".equals(order.getPaymentStatus())) {
                        System.out.println("ℹ MoMo failure callback ignored (order already paid): " + orderId);
                    }
                }
                
                // If this is IPN (notify), return 204
                if (request.getServletPath().equals("/momo-notify")) {
                    response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                    return;
                }
                
                // Redirect to error page
                response.sendRedirect(request.getContextPath() + 
                    "/checkout?error=payment_failed&message=" + 
                    java.net.URLEncoder.encode(statusMessage, "UTF-8"));
            }
        } else {
            // Chữ ký không hợp lệ
            System.err.println("✗ Invalid MoMo signature!");
            
            // If this is IPN (notify), return 204
            if (request.getServletPath().equals("/momo-notify")) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                return;
            }
            
            response.sendRedirect(request.getContextPath() + 
                "/checkout?error=invalid_signature");
        }
    }
}
