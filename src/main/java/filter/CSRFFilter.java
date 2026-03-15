package filter;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

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

/**
 * CSRF Protection Filter
 * Bảo vệ chống tấn công Cross-Site Request Forgery
 */
@WebFilter(urlPatterns = {"/*"})
public class CSRFFilter implements Filter {
    
    private static final String CSRF_TOKEN_ATTR = "csrfToken";
    private static final String CSRF_HEADER = "X-CSRF-Token";
    private static final String CSRF_PARAM = "csrfToken";
    private static final SecureRandom secureRandom = new SecureRandom();
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(true);
        
        // Tạo token nếu chưa có
        String token = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        if (token == null) {
            token = generateToken();
            session.setAttribute(CSRF_TOKEN_ATTR, token);
        }
        
        // Set token vào request attribute để JSP có thể sử dụng
        httpRequest.setAttribute(CSRF_TOKEN_ATTR, token);
        
        String method = httpRequest.getMethod();
        
        // Chỉ kiểm tra với POST, PUT, DELETE, PATCH
        if ("POST".equalsIgnoreCase(method) || 
            "PUT".equalsIgnoreCase(method) || 
            "DELETE".equalsIgnoreCase(method) ||
            "PATCH".equalsIgnoreCase(method)) {
            
            // Bỏ qua một số path không cần CSRF (login, register, OAuth)
            String path = httpRequest.getRequestURI();
            if (shouldSkipCSRFCheck(path)) {
                chain.doFilter(request, response);
                return;
            }
            
            // Lấy token từ header hoặc parameter
            String clientToken = httpRequest.getHeader(CSRF_HEADER);
            if (clientToken == null) {
                clientToken = httpRequest.getParameter(CSRF_PARAM);
            }
            
            // Kiểm tra token
            if (clientToken == null || !token.equals(clientToken)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, 
                    "CSRF token validation failed");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup
    }
    
    /**
     * Tạo CSRF token ngẫu nhiên
     */
    private String generateToken() {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
    
    /**
     * Kiểm tra xem path có cần skip CSRF check không
     */
    private boolean shouldSkipCSRFCheck(String path) {
        return path.contains("/login") || 
               path.contains("/register") ||
               path.contains("/verify-email") ||
               path.contains("/oauth/") ||
               path.contains("/reset-password") ||
               path.contains("/forgot-password");
    }
}
