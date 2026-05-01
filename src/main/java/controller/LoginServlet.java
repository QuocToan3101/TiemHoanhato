package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;
import service.CartService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private CartService cartService;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        cartService = new CartService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập rồi thì chuyển về home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/view/home.jsp");
            return;
        }
        request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // Validate input
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu!");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }

        // Kiểm tra đăng nhập từ database
        User user = userDAO.login(email.trim(), password);
        
        if (user != null) {
            // Đăng nhập thành công
            HttpSession existing = request.getSession(false);
            String redirectUrl = null;
            Object guestCart = null;
            if (existing != null) {
                redirectUrl = (String) existing.getAttribute("redirectUrl");
                guestCart = existing.getAttribute(CartService.SESSION_CART_KEY);
                existing.invalidate();
            }
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getFullname());
            session.setAttribute("userRole", user.getRole());
            
            // Set session timeout (30 phút)
            session.setMaxInactiveInterval(30 * 60);

            // Merge guest cart (session) vào cart của user trong DB sau khi đăng nhập.
            if (guestCart != null) {
                session.setAttribute(CartService.SESSION_CART_KEY, guestCart);
                cartService.mergeSessionCartToDb(session, user.getId());
            }
            
            // Nếu chọn "Remember me", tạo cookie với bảo vệ tốt hơn
            if ("on".equals(remember)) {
                Cookie emailCookie = new Cookie("rememberEmail", email);
                emailCookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
                emailCookie.setPath("/");
                emailCookie.setHttpOnly(true);
                emailCookie.setSecure(request.isSecure());
                response.addCookie(emailCookie);
            }

            // Nếu có redirectUrl (được AuthFilter lưu), ưu tiên redirect về đó
            if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                response.sendRedirect(redirectUrl);
                return;
            }

            // Chuyển hướng theo role mặc định
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.setAttribute("email", email); // Giữ lại email đã nhập
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
        }
    }
}
