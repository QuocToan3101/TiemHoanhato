package controller;

import dao.OrderDAO;
import model.Order;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

/**
 * Servlet xử lý hiển thị trang đặt hàng thành công
 */
@WebServlet(urlPatterns = {"/order-success", "/don-hang-thanh-cong"})
public class OrderSuccessServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        request.setAttribute("showInvoice", false);
        request.setAttribute("paymentConfirmed", false);
        request.setAttribute("paymentPending", false);
        
        // Lấy mã đơn hàng từ parameter
        String orderCode = request.getParameter("orderCode");
        
        if (orderCode != null && !orderCode.isEmpty()) {
            // Lấy thông tin đơn hàng từ database
            Order order = orderDAO.findByOrderCode(orderCode);
            
            if (order != null) {
                request.setAttribute("order", order);
                boolean isVnPayOrder = "vnpay".equalsIgnoreCase(order.getPaymentMethod());
                boolean isPaid = "paid".equalsIgnoreCase(order.getPaymentStatus());
                boolean isFailed = "failed".equalsIgnoreCase(order.getPaymentStatus()) || "failed".equals(request.getParameter("payment"));

                request.setAttribute("showInvoice", !isVnPayOrder || isPaid || isFailed);
                request.setAttribute("paymentConfirmed", isPaid);
                request.setAttribute("paymentPending", isVnPayOrder && !isPaid && !isFailed);
            }
        }
        
        // Forward đến trang success
        request.getRequestDispatcher("/view/orderSuccess.jsp").forward(request, response);
    }
}
