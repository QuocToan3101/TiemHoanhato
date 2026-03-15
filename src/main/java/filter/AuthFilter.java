package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;

/**
 * Filter bảo vệ các trang cần đăng nhập
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {
    
    // Các URL cần đăng nhập mới truy cập được
    private static final List<String> PROTECTED_URLS = Arrays.asList(
        "/view/cart.jsp",
        "/view/settingProfile.jsp",
        "/view/checkout.jsp",
        "/view/orderSuccess.jsp",
        "/view/purchaseHistory.jsp",
        "/api/cart",
        "/api/order",
        "/profile",
        "/checkout"
    );
    
    // Các URL chỉ admin mới truy cập được
    private static final List<String> ADMIN_URLS = Arrays.asList(
        "/view/admin_1.jsp",
        "/admin"
    );
    
    // Các URL không cần kiểm tra (static resources, login, register)
    private static final List<String> PUBLIC_URLS = Arrays.asList(
        "/view/login_1.jsp",
        "/view/registration.jsp",
        "/view/ForgotPassword.jsp",
        "/view/home.jsp",
        "/view/products.jsp",
        "/view/product-detail.jsp",
        "/view/intro.jsp",
        "/view/contact.jsp",
        "/view/tintuc.jsp",
        "/view/boHoa.jsp",
        "/view/binhHoa.jsp",
        "/view/gioHoa.jsp",
        "/view/langHoa.jsp",
        "/view/hoaTulip.jsp",
        "/view/hoaCuoi.jsp",
        "/view/hoaMauDon.jsp",
        "/view/hoaTotNghiep.jsp",
        "/view/lanHoDiep.jsp",
        "/view/keHoaChiaBuon.jsp",
        "/view/keHoaChucMung.jsp",
        "/view/silkFlower.jsp",
        "/view/plasticFlower.jsp",
        "/view/paperFlower.jsp",
        "/view/fabricFlower.jsp",
        "/view/boxFlower.jsp",
        "/view/flowerBasket.jsp",
        "/view/graduateFlower.jsp",
        "/view/trangChuHoaGia.jsp",
        "/view/partials/",
        "/san-pham",
        "/products",
        "/login",
        "/register",
        "/logout",
        ".css",
        ".js",
        ".png",
        ".jpg",
        ".jpeg",
        ".gif",
        ".ico",
        ".woff",
        ".woff2",
        ".ttf",
        ".svg",
        ".eot",
        ".map"
    );
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Kiểm tra nếu là public URL (static resources, login, register)
        if (isPublicUrl(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        HttpSession session = httpRequest.getSession(false);
        User user = null;
        
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        // Kiểm tra admin URLs
        if (isAdminUrl(path)) {
            if (user == null) {
                // Chưa đăng nhập
                httpResponse.sendRedirect(contextPath + "/view/login_1.jsp?error=Vui lòng đăng nhập để tiếp tục");
                return;
            }
            if (!"admin".equals(user.getRole())) {
                // Không phải admin
                httpResponse.sendRedirect(contextPath + "/view/home.jsp?error=Bạn không có quyền truy cập trang này");
                return;
            }
            chain.doFilter(request, response);
            return;
        }
        
        // Kiểm tra protected URLs
        if (isProtectedUrl(path)) {
            if (user == null) {
                // Chưa đăng nhập - lưu URL đang truy cập để redirect sau khi login
                session = httpRequest.getSession(true);
                session.setAttribute("redirectUrl", requestURI);
                httpResponse.sendRedirect(contextPath + "/view/login_1.jsp?error=Vui lòng đăng nhập để tiếp tục");
                return;
            }
        }
        
        // Cho phép truy cập
        chain.doFilter(request, response);
    }
    
    /**
     * Kiểm tra xem URL có phải là public không
     */
    private boolean isPublicUrl(String path) {
        for (String publicUrl : PUBLIC_URLS) {
            if (path.contains(publicUrl)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem URL có cần đăng nhập không
     */
    private boolean isProtectedUrl(String path) {
        for (String protectedUrl : PROTECTED_URLS) {
            if (path.startsWith(protectedUrl) || path.contains(protectedUrl)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem URL có phải dành cho admin không
     */
    private boolean isAdminUrl(String path) {
        for (String adminUrl : ADMIN_URLS) {
            if (path.startsWith(adminUrl) || path.contains(adminUrl)) {
                return true;
            }
        }
        return false;
    }
    
    @Override
    public void destroy() {
        // Cleanup
    }
}
