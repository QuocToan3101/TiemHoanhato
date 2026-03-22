package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.CartDAO;
import dao.CouponDAO;
import dao.OrderDAO;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.Product;
import model.User;
import payment.MoMoConfig;
import payment.VNPayConfig;
import service.EmailService;
import util.AppConfig;

/**
 * Servlet xử lý thanh toán với VNPay/MoMo integration
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final BigDecimal DEFAULT_SHIPPING_FEE = new BigDecimal("30000");
    
    private CartDAO cartDAO;
    private CouponDAO couponDAO;
    private OrderDAO orderDAO;
    private Gson gson;
    private VNPayConfig vnpayConfig;
    private MoMoConfig momoConfig;
    private EmailService emailService;
    private AppConfig appConfig;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        couponDAO = new CouponDAO();
        orderDAO = new OrderDAO();
        gson = new Gson();
        vnpayConfig = new VNPayConfig();
        momoConfig = new MoMoConfig();
        emailService = EmailService.getInstance();
        appConfig = AppConfig.getInstance();
    }
    
    /**
     * GET - Hiển thị trang thanh toán
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            
            // Kiểm tra đăng nhập
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/view/login_1.jsp?redirect=checkout");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            
            // Lấy giỏ hàng của user
            List<CartItem> cartItems = cartDAO.findByUserId(user.getId());
            
            // Kiểm tra giỏ hàng trống
            if (cartItems == null || cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            // Tính tổng tiền
            BigDecimal cartTotal = BigDecimal.ZERO;
            int cartCount = 0;
            for (CartItem item : cartItems) {
                BigDecimal subtotal = item.getSubtotal();
                if (subtotal != null) {
                    cartTotal = cartTotal.add(subtotal);
                }
                cartCount += item.getQuantity();
            }
            
            // Set attributes
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartTotal", cartTotal);
            request.setAttribute("cartCount", cartCount);
            
            request.getRequestDispatcher("/view/checkout.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            System.err.println("[CheckoutServlet] Lỗi: " + e.getMessage());
            // Hiển thị lỗi chi tiết thay vì redirect
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/view/checkout.jsp").forward(request, response);
        }
    }
    
    /**
     * POST - Xử lý đặt hàng
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            HttpSession session = request.getSession(false);
            
            // Kiểm tra đăng nhập
            if (session == null || session.getAttribute("user") == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng đăng nhập để tiếp tục");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            User user = (User) session.getAttribute("user");
            
            // Lấy giỏ hàng
            List<CartItem> cartItems = cartDAO.findByUserId(user.getId());
            
            if (cartItems == null || cartItems.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Giỏ hàng trống");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Lấy thông tin từ form
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String receiverEmail = request.getParameter("receiverEmail");
            String addressDetail = request.getParameter("addressDetail");
            String note = request.getParameter("note");
            String paymentMethod = request.getParameter("paymentMethod");
            String attachGreetingCard = request.getParameter("attachGreetingCard");
            String printGreetingCard = request.getParameter("printGreetingCard");
            
            // Chống gian lận: luôn tính tiền ở server dựa trên dữ liệu DB, không tin giá từ client
            BigDecimal subtotal = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                if (item.getSubtotal() != null) {
                    subtotal = subtotal.add(item.getSubtotal());
                }
            }

            BigDecimal shippingFee = DEFAULT_SHIPPING_FEE;
            BigDecimal discount = BigDecimal.ZERO;

            String couponCode = request.getParameter("appliedCouponCode");
            if (couponCode == null || couponCode.trim().isEmpty()) {
                // Fallback cho trường hợp frontend cũ gửi trực tiếp couponCode
                couponCode = request.getParameter("couponCode");
            }

            if (couponCode != null && !couponCode.trim().isEmpty()) {
                String normalizedCouponCode = couponCode.trim().toUpperCase();
                model.Coupon coupon = couponDAO.findByCode(normalizedCouponCode);

                if (coupon == null || !coupon.isValid()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Mã giảm giá không hợp lệ hoặc đã hết hạn");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }

                if (coupon.getMinOrderValue() != null && subtotal.compareTo(coupon.getMinOrderValue()) < 0) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Đơn hàng chưa đạt giá trị tối thiểu để áp dụng mã giảm giá");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }

                discount = coupon.calculateDiscount(subtotal);

                // Không cho discount vượt quá subtotal + shipping
                BigDecimal maxAllowedDiscount = subtotal.add(shippingFee);
                if (discount.compareTo(maxAllowedDiscount) > 0) {
                    discount = maxAllowedDiscount;
                }
            }

            BigDecimal total = subtotal.add(shippingFee).subtract(discount);
            if (total.compareTo(BigDecimal.ZERO) < 0) {
                total = BigDecimal.ZERO;
            }
            
            // Lấy thiệp chúc mừng từ session (nếu có)
            byte[] greetingCardImage = null;
            boolean shouldPrintCard = "on".equals(printGreetingCard);
            
            if ("on".equals(attachGreetingCard) || shouldPrintCard) {
                greetingCardImage = (byte[]) session.getAttribute("greetingCardImage");
                System.out.println("Đính kèm thiệp chúc mừng - Email: " + 
                    ("on".equals(attachGreetingCard)) + ", In thiệp: " + shouldPrintCard);
            }
            
            // Địa chỉ giao hàng - sử dụng trực tiếp từ form
            String shippingAddress = addressDetail != null ? addressDetail.trim() : "";
            
            // Validate dữ liệu
            if (receiverName == null || receiverName.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập tên người nhận");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (receiverPhone == null || !receiverPhone.matches("^[0-9]{10,11}$")) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Số điện thoại không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập địa chỉ giao hàng");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Tạo đơn hàng
            Order order = new Order();
            order.setUserId(user.getId());
            order.setReceiverName(receiverName.trim());
            order.setReceiverPhone(receiverPhone.trim());
            order.setReceiverEmail(receiverEmail != null ? receiverEmail.trim() : user.getEmail());
            order.setShippingAddress(shippingAddress);
            order.setNote(note);
            order.setSubtotal(subtotal);
            order.setShippingFee(shippingFee);
            order.setDiscount(discount);
            order.setTotal(total);
            order.setPaymentMethod(paymentMethod != null ? paymentMethod : "cod");
            order.setPaymentStatus("pending");
            order.setOrderStatus("pending");
            
            // Tạo danh sách order items
            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem cartItem : cartItems) {
                Product product = cartItem.getProduct();
                OrderItem orderItem = new OrderItem(
                    0, // orderId sẽ được set sau
                    product.getId(),
                    product.getName(),
                    product.getImage(),
                    product.getDisplayPrice(),
                    cartItem.getQuantity()
                );
                orderItems.add(orderItem);
            }
            
            // Lưu đơn hàng vào database
            boolean success = orderDAO.createOrder(order, orderItems);
            
            if (success) {
                // Xóa giỏ hàng sau khi đặt hàng thành công
                cartDAO.clearCart(user.getId());
                
                // Gửi email xác nhận đơn hàng
                try {
                    emailService.sendOrderConfirmation(
                        order.getReceiverEmail(),
                        order.getReceiverName(),
                        order.getOrderCode(),
                        String.format("%,d đ", order.getTotal().longValue()),
                        "on".equals(attachGreetingCard) ? greetingCardImage : null  // Chỉ đính kèm nếu chọn email
                    );
                } catch (Exception emailError) {
                    System.err.println("Không thể gửi email xác nhận: " + emailError.getMessage());
                }
                
                // Gửi thông báo cho admin nếu khách yêu cầu in thiệp
                if (shouldPrintCard && greetingCardImage != null) {
                    try {
                        emailService.sendAdminPrintCardNotification(
                            order.getOrderCode(),
                            order.getReceiverName(),
                            order.getReceiverPhone(),
                            order.getShippingAddress(),
                            greetingCardImage
                        );
                        System.out.println("✓ Đã gửi thông báo in thiệp cho admin - Đơn hàng: " + order.getOrderCode());
                    } catch (Exception adminEmailError) {
                        System.err.println("Không thể gửi email cho admin: " + adminEmailError.getMessage());
                    }
                }
                
                // Xử lý payment gateway
                if ("vnpay".equals(paymentMethod)) {
                    // VNPay payment
                    if (appConfig.isVNPayEnabled()) {
                        try {
                            String paymentUrl = vnpayConfig.createPaymentUrl(
                                request,
                                order.getOrderCode(),
                                order.getTotal().longValue(),
                                "Thanh toan don hang " + order.getOrderCode()
                            );
                            
                            jsonResponse.addProperty("success", true);
                            jsonResponse.addProperty("orderCode", order.getOrderCode());
                            jsonResponse.addProperty("paymentMethod", "vnpay");
                            jsonResponse.addProperty("redirectUrl", paymentUrl);
                            jsonResponse.addProperty("message", "Đang chuyển đến trang thanh toán VNPay...");
                        } catch (Exception e) {
                            System.err.println("Lỗi tạo VNPay URL: " + e.getMessage());
                            jsonResponse.addProperty("success", true);
                            jsonResponse.addProperty("orderCode", order.getOrderCode());
                            jsonResponse.addProperty("redirectUrl", request.getContextPath() + "/order-success?orderCode=" + order.getOrderCode());
                            jsonResponse.addProperty("message", "Đặt hàng thành công! (Lỗi VNPay, vui lòng chọn phương thức khác)");
                        }
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "VNPay hiện không khả dụng");
                    }
                    
                } else if ("momo".equals(paymentMethod)) {
                    // MoMo payment
                    if (appConfig.isMoMoEnabled()) {
                        try {
                            String paymentUrl = momoConfig.createPaymentUrl(
                                order.getOrderCode(),
                                order.getTotal().longValue(),
                                "Thanh toan don hang " + order.getOrderCode()
                            );
                            
                            if (paymentUrl != null) {
                                jsonResponse.addProperty("success", true);
                                jsonResponse.addProperty("orderCode", order.getOrderCode());
                                jsonResponse.addProperty("paymentMethod", "momo");
                                jsonResponse.addProperty("redirectUrl", paymentUrl);
                                jsonResponse.addProperty("message", "Đang chuyển đến trang thanh toán MoMo...");
                            } else {
                                jsonResponse.addProperty("success", true);
                                jsonResponse.addProperty("orderCode", order.getOrderCode());
                                jsonResponse.addProperty("redirectUrl", request.getContextPath() + "/order-success?orderCode=" + order.getOrderCode());
                                jsonResponse.addProperty("message", "Đặt hàng thành công! (Lỗi MoMo, vui lòng chọn phương thức khác)");
                            }
                        } catch (Exception e) {
                            System.err.println("Lỗi tạo MoMo URL: " + e.getMessage());
                            jsonResponse.addProperty("success", true);
                            jsonResponse.addProperty("orderCode", order.getOrderCode());
                            jsonResponse.addProperty("redirectUrl", request.getContextPath() + "/order-success?orderCode=" + order.getOrderCode());
                            jsonResponse.addProperty("message", "Đặt hàng thành công! (Lỗi MoMo, vui lòng chọn phương thức khác)");
                        }
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "MoMo hiện không khả dụng");
                    }
                    
                } else {
                    // COD hoặc Bank Transfer
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("orderCode", order.getOrderCode());
                    jsonResponse.addProperty("paymentMethod", paymentMethod);
                    jsonResponse.addProperty("redirectUrl", request.getContextPath() + "/order-success?orderCode=" + order.getOrderCode());
                    jsonResponse.addProperty("message", "Đặt hàng thành công!");
                }
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Có lỗi xảy ra khi tạo đơn hàng. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            System.err.println("[CheckoutServlet] Lỗi: " + e.getMessage());
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
}
