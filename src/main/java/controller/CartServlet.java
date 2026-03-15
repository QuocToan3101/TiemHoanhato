package controller;

import dao.CartDAO;
import model.CartItem;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet xử lý hiển thị trang giỏ hàng
 */
@WebServlet(urlPatterns = {"/cart", "/gio-hang"})
public class CartServlet extends HttpServlet {
    
    private CartDAO cartDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        
        // Nếu chưa đăng nhập, vẫn hiển thị trang giỏ hàng trống
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            
            // Lấy giỏ hàng của user
            List<CartItem> cartItems = cartDAO.findByUserId(user.getId());
            
            // Tính tổng tiền và số lượng
            BigDecimal cartTotal = BigDecimal.ZERO;
            int cartCount = 0;
            
            for (CartItem item : cartItems) {
                cartTotal = cartTotal.add(item.getSubtotal());
                cartCount += item.getQuantity();
            }
            
            // Set attributes
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartTotal", cartTotal);
            request.setAttribute("cartCount", cartCount);
        }
        
        request.getRequestDispatcher("/view/cart.jsp").forward(request, response);
    }
}
