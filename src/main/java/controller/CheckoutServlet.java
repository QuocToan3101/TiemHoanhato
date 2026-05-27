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
import dao.AddressDAO;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.Product;
import model.User;
import model.Address;
import payment.VNPayConfig;
import service.EmailService;
import util.AppConfig;
/**
 * Servlet xử lý thanh toán với VNPay integration
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final BigDecimal DEFAULT_SHIPPING_FEE = new BigDecimal("30000");
    private CartDAO cartDAO;
    private CouponDAO couponDAO;
    private OrderDAO orderDAO;
    private AddressDAO addressDAO;
    private Gson gson;
    private VNPayConfig vnpayConfig;
    private EmailService emailService;
    private AppConfig appConfig;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        couponDAO = new CouponDAO();
        orderDAO = new OrderDAO();
        addressDAO = new AddressDAO();
        gson = new Gson();
        vnpayConfig = new VNPayConfig();
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
            
            // Lấy danh sách địa chỉ đã lưu
            List<Address> addresses = addressDAO.findByUserId(user.getId());
            request.setAttribute("addresses", addresses);
            
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
            String normalizedPaymentMethod = paymentMethod != null ? paymentMethod.trim().toLowerCase() : "cod";

            if (!"cod".equals(normalizedPaymentMethod)
                    && !"bank_transfer".equals(normalizedPaymentMethod)
                    && !"vnpay".equals(normalizedPaymentMethod)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Phương thức thanh toán không được hỗ trợ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Chống gian lận: luôn tính tiền ở server dựa trên dữ liệu DB, không tin giá từ client
            BigDecimal subtotal = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                if (item.getSubtotal() != null) {
                    subtotal = subtotal.add(item.getSubtotal());
                }
            }

            // Đọc phí vận chuyển động từ frontend gửi lên
            String shippingFeeParam = request.getParameter("shippingFee");
            BigDecimal shippingFee = DEFAULT_SHIPPING_FEE;
            if (shippingFeeParam != null && !shippingFeeParam.trim().isEmpty()) {
                try {
                    shippingFee = new BigDecimal(shippingFeeParam.trim());
                    if (shippingFee.compareTo(BigDecimal.ZERO) < 0) {
                        shippingFee = BigDecimal.ZERO;
                    }
                } catch (NumberFormatException e) {
                    System.err.println("[CheckoutServlet] Phí vận chuyển không hợp lệ: " + shippingFeeParam);
                }
            }
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
            
            // Địa chỉ giao hàng - xử lý Sổ địa chỉ (Saved Address) hoặc Địa chỉ mới
            String addressIdParam = request.getParameter("addressId");
            String finalReceiverName = receiverName != null ? receiverName.trim() : "";
            String finalReceiverPhone = receiverPhone != null ? receiverPhone.trim() : "";
            String finalShippingAddress = addressDetail != null ? addressDetail.trim() : "";

            if (addressIdParam != null && !addressIdParam.trim().isEmpty()) {
                try {
                    int addressId = Integer.parseInt(addressIdParam.trim());
                    Address savedAddress = addressDAO.findById(addressId);
                    if (savedAddress != null && savedAddress.getUserId() == user.getId()) {
                        finalReceiverName = savedAddress.getReceiverName();
                        finalReceiverPhone = savedAddress.getPhone();
                        finalShippingAddress = savedAddress.getFullAddress();
                    }
                } catch (NumberFormatException e) {
                    System.err.println("[CheckoutServlet] addressId không hợp lệ: " + addressIdParam);
                }
            }
            
            // Validate dữ liệu
            if (finalReceiverName.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập tên người nhận");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (finalReceiverPhone.isEmpty() || !finalReceiverPhone.matches("^[0-9]{10,11}$")) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Số điện thoại không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (finalShippingAddress.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập địa chỉ giao hàng");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Tạo đơn hàng
            Order order = new Order();
            order.setUserId(user.getId());
            order.setReceiverName(finalReceiverName);
            order.setReceiverPhone(finalReceiverPhone);
            order.setReceiverEmail(receiverEmail != null ? receiverEmail.trim() : user.getEmail());
            order.setShippingAddress(finalShippingAddress);
            order.setNote(note);
            order.setSubtotal(subtotal);
            order.setShippingFee(shippingFee);
            order.setDiscount(discount);
            order.setTotal(total);
            order.setPaymentMethod(normalizedPaymentMethod);
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
                if ("vnpay".equals(normalizedPaymentMethod)) {
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
                } else {
                    // COD hoặc Bank Transfer
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("orderCode", order.getOrderCode());
                    jsonResponse.addProperty("paymentMethod", normalizedPaymentMethod);
                    jsonResponse.addProperty("redirectUrl", request.getContextPath() + "/order-success?orderCode=" + order.getOrderCode());
                    jsonResponse.addProperty("message", "Đặt hàng thành công!");
                }
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể tạo đơn hàng. Có thể một số sản phẩm đã hết hàng hoặc không đủ tồn kho, vui lòng kiểm tra lại giỏ hàng.");
            }
            
        } catch (Exception e) {
            System.err.println("[CheckoutServlet] Lỗi: " + e.getMessage());
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
}
