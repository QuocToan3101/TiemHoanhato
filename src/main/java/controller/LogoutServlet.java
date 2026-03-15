package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
// serverlet xu ly log out
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy session hiện tại
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Xóa tất cả attributes
            session.removeAttribute("user");
            session.removeAttribute("userId");
            session.removeAttribute("userEmail");
            session.removeAttribute("userName");
            session.removeAttribute("userRole");
            
            // Hủy session
            session.invalidate();
        }
        
        // Xóa cookie remember me nếu có
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberEmail".equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                    break;
                }
            }
        }
        
        // Chuyển về trang login
        response.sendRedirect(request.getContextPath() + "/view/login_1.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
