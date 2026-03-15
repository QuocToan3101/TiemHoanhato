package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.PasswordResetDAO;
import dao.UserDAO;
import model.User;
import service.EmailService;

/**
 * Servlet xử lý quên mật khẩu với email service
 */
@WebServlet(urlPatterns = {"/forgot-password", "/reset-password"})
public class ForgotPasswordServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private PasswordResetDAO resetDAO;
    private EmailService emailService;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        resetDAO = new PasswordResetDAO();
        emailService = EmailService.getInstance();
    }
    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        
        if ("/reset-password".equals(servletPath)) {
            // Hiển thị trang reset password
            String token = request.getParameter("token");
            
            if (token == null || token.isEmpty()) {
                request.setAttribute("error", "Token không hợp lệ");
                request.getRequestDispatcher("/view/ForgotPassword.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra token từ database
            String email = resetDAO.validateToken(token);
            if (email == null) {
                request.setAttribute("error", "Token đã hết hạn hoặc không tồn tại");
                request.getRequestDispatcher("/view/ForgotPassword.jsp").forward(request, response);
                return;
            }
            
            // Token hợp lệ, chuyển đến trang reset password
            request.setAttribute("token", token);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/ResetPassword.jsp").forward(request, response);
        } else {
            // Hiển thị trang forgot password
            request.getRequestDispatcher("/view/ForgotPassword.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        String servletPath = request.getServletPath();
        PrintWriter out = response.getWriter();
        
        if ("/forgot-password".equals(servletPath)) {
            handleForgotPassword(request, out);
        } else if ("/reset-password".equals(servletPath)) {
            handleResetPassword(request, out);
        }
    }
    
    /**
     * Xử lý yêu cầu quên mật khẩu
     */
    private void handleForgotPassword(HttpServletRequest request, PrintWriter out) {
        String email = request.getParameter("email");
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Vui lòng nhập email\"}");
            return;
        }
        
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            out.write("{\"success\": false, \"message\": \"Email không hợp lệ\"}");
            return;
        }
        
        // Kiểm tra email có tồn tại không
        User user = userDAO.findByEmail(email.trim());
        
        if (user == null) {
            // Không tiết lộ email có tồn tại hay không (bảo mật)
            out.write("{\"success\": true, \"message\": \"Nếu email tồn tại, chúng tôi đã gửi hướng dẫn đặt lại mật khẩu\"}");
            return;
        }
        
        // Tạo token trong database
        String token = resetDAO.createResetToken(email.trim());
        
        if (token == null) {
            out.write("{\"success\": false, \"message\": \"Có lỗi xảy ra, vui lòng thử lại\"}");
            return;
        }
        
        // Gửi email với link reset
        boolean emailSent = emailService.sendPasswordResetEmail(
            email.trim(), 
            user.getFullname(), 
            token
        );
        
        if (emailSent) {
            System.out.println("✓ Email reset password đã được gửi đến: " + email);
            out.write("{\"success\": true, \"message\": \"Vui lòng kiểm tra email để đặt lại mật khẩu\"}");
        } else {
            System.err.println("✗ Không thể gửi email đến: " + email);
            // Vẫn trả về success để không tiết lộ email có tồn tại
            out.write("{\"success\": true, \"message\": \"Nếu email tồn tại, chúng tôi đã gửi hướng dẫn đặt lại mật khẩu\"}");
        }
    }
    
    /**
     * Xử lý đặt lại mật khẩu
     */
    private void handleResetPassword(HttpServletRequest request, PrintWriter out) {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate
        if (token == null || token.isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Token không hợp lệ\"}");
            return;
        }
        
        if (newPassword == null || newPassword.isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Vui lòng nhập mật khẩu mới\"}");
            return;
        }
        
        if (newPassword.length() < 6) {
            out.write("{\"success\": false, \"message\": \"Mật khẩu phải có ít nhất 6 ký tự\"}");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            out.write("{\"success\": false, \"message\": \"Mật khẩu xác nhận không khớp\"}");
            return;
        }
        
        // Kiểm tra token từ database
        String email = resetDAO.validateToken(token);
        if (email == null) {
            out.write("{\"success\": false, \"message\": \"Token đã hết hạn hoặc không tồn tại\"}");
            return;
        }
        
        // Đặt lại mật khẩu
        boolean success = userDAO.resetPassword(email, newPassword);
        
        if (success) {
            // Đánh dấu token đã sử dụng
            resetDAO.markTokenAsUsed(token);
            out.write("{\"success\": true, \"message\": \"Đặt lại mật khẩu thành công. Vui lòng đăng nhập.\"}");
        } else {
            out.write("{\"success\": false, \"message\": \"Có lỗi xảy ra. Vui lòng thử lại.\"}");
        }
    }
}
