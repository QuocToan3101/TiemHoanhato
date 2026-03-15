package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet để hiển thị trang wishlist
 */
@WebServlet("/wishlist")
public class WishlistPageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Forward to wishlist.jsp
        request.getRequestDispatcher("/view/wishlist.jsp").forward(request, response);
    }
}
