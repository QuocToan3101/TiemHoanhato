package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;

@WebServlet("/verify-email")
public class VerifyEmailServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token xác thực không hợp lệ!");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        // Xác thực email
        boolean success = userDAO.verifyEmail(token);
        
        if (success) {
            request.setAttribute("success", "✅ Xác thực email thành công! Bạn có thể đăng nhập ngay bây giờ.");
        } else {
            request.setAttribute("error", "❌ Token xác thực không hợp lệ hoặc đã hết hạn. Vui lòng đăng ký lại.");
        }
        
        request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
    }
}
