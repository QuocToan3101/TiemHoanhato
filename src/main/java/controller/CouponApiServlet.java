package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import dao.CouponDAO;
import model.Coupon;

/**
 * API Servlet để validate và áp dụng mã giảm giá
 */
@WebServlet("/api/coupon/*")
public class CouponApiServlet extends HttpServlet {
    
    private Gson gson;
    private CouponDAO couponDAO;
    
    @Override
    public void init() throws ServletException {
        gson = new Gson();
        couponDAO = new CouponDAO();
    }
    
    /**
     * POST - Validate mã giảm giá
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        // Require authenticated user to limit brute-force coupon abuse
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng đăng nhập để áp dụng mã giảm giá");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(jsonResponse));
            return;
        }

        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.equals("/validate")) {
            validateCoupon(request, jsonResponse);
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Invalid endpoint");
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Validate mã giảm giá
     */
    private void validateCoupon(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            // Đọc JSON từ request body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject requestData = JsonParser.parseString(sb.toString()).getAsJsonObject();
            
            String code = requestData.has("code") ? requestData.get("code").getAsString() : null;
            BigDecimal subtotal = requestData.has("subtotal") 
                ? new BigDecimal(requestData.get("subtotal").getAsString()) 
                : BigDecimal.ZERO;
            
            if (code == null || code.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập mã giảm giá");
                return;
            }
            
            code = code.trim().toUpperCase();
            
            // Tìm mã giảm giá từ database
            Coupon coupon = couponDAO.findByCode(code);
            
            if (coupon == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Mã giảm giá không tồn tại");
                return;
            }
            
            // Kiểm tra mã còn active không
            if (!coupon.isActive()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Mã giảm giá đã hết hạn hoặc không còn hiệu lực");
                return;
            }
            
            // Kiểm tra số lần sử dụng
            if (coupon.getUsageLimit() != null && coupon.getUsedCount() >= coupon.getUsageLimit()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Mã giảm giá đã hết lượt sử dụng");
                return;
            }
            
            // Kiểm tra giá trị đơn hàng tối thiểu
            if (coupon.getMinOrderValue() != null && subtotal.compareTo(coupon.getMinOrderValue()) < 0) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Đơn hàng tối thiểu " + formatCurrency(coupon.getMinOrderValue()) + " để sử dụng mã này");
                return;
            }
            
            // Tính toán giảm giá
            BigDecimal discountAmount;
            
            if ("percentage".equals(coupon.getDiscountType())) {
                // Giảm theo phần trăm
                discountAmount = subtotal.multiply(coupon.getDiscountValue()).divide(new BigDecimal(100));
                
                // Áp dụng giảm tối đa nếu có
                if (coupon.getMaxDiscount() != null && discountAmount.compareTo(coupon.getMaxDiscount()) > 0) {
                    discountAmount = coupon.getMaxDiscount();
                }
            } else {
                // Giảm cố định
                discountAmount = coupon.getDiscountValue();
            }
            
            // Trả về kết quả
            JsonObject couponInfo = new JsonObject();
            couponInfo.addProperty("id", coupon.getId());
            couponInfo.addProperty("code", coupon.getCode());
            couponInfo.addProperty("type", coupon.getDiscountType());
            couponInfo.addProperty("value", coupon.getDiscountValue().toString());
            couponInfo.addProperty("description", coupon.getDescription());
            
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "Áp dụng mã giảm giá thành công");
            jsonResponse.add("coupon", couponInfo);
            jsonResponse.addProperty("discountAmount", discountAmount.toString());
            
        } catch (Exception e) {
            System.err.println("[CouponApiServlet] Error: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    /**
     * Format tiền tệ
     */
    private String formatCurrency(BigDecimal amount) {
        return String.format("%,.0f₫", amount);
    }
}
