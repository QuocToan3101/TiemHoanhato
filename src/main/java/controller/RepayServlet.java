package controller;

import dao.OrderDAO;
import model.Order;
import payment.VNPayConfig;
import util.AppConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet xử lý thanh toán lại cho đơn hàng hiện tại bằng VNPay
 */
@WebServlet("/repay")
public class RepayServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    private VNPayConfig vnpayConfig;
    private AppConfig appConfig;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        vnpayConfig = new VNPayConfig();
        appConfig = AppConfig.getInstance();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/view/login_1.jsp?redirect=repay");
            return;
        }
        
        String orderCode = request.getParameter("orderCode");
        if (orderCode == null || orderCode.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        Order order = orderDAO.findByOrderCode(orderCode);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Kiểm tra quyền sở hữu đơn hàng
        model.User user = (model.User) session.getAttribute("user");
        if (order.getUserId() != user.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thanh toán đơn hàng này");
            return;
        }
        
        // Nếu đã thanh toán rồi, redirect thẳng về thành công
        if ("paid".equalsIgnoreCase(order.getPaymentStatus())) {
            response.sendRedirect(request.getContextPath() + "/order-success?orderCode=" + orderCode + "&payment=success");
            return;
        }
        
        // Thực hiện tạo link thanh toán VNPay và chuyển hướng
        if ("vnpay".equalsIgnoreCase(order.getPaymentMethod()) && appConfig.isVNPayEnabled()) {
            try {
                String paymentUrl = vnpayConfig.createPaymentUrl(
                    request,
                    order.getOrderCode(),
                    order.getTotal().longValue(),
                    "Thanh toan lai don hang " + order.getOrderCode()
                );
                response.sendRedirect(paymentUrl);
            } catch (Exception e) {
                System.err.println("[RepayServlet] Lỗi tạo VNPay URL thanh toán lại: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/order-success?orderCode=" + orderCode + 
                    "&payment=failed&message=" + java.net.URLEncoder.encode("Không thể khởi tạo cổng thanh toán VNPay. Vui lòng thử lại sau.", "UTF-8"));
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/order-success?orderCode=" + orderCode);
        }
    }
}
