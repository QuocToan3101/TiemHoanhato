package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Security Headers Filter
 * Thêm các HTTP security headers để bảo vệ ứng dụng
 */
@WebFilter(urlPatterns = {"/*"})
public class SecurityHeadersFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // X-Frame-Options: Chống Clickjacking
        httpResponse.setHeader("X-Frame-Options", "DENY");
        
        // X-Content-Type-Options: Chống MIME sniffing
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        
        // X-XSS-Protection: Bật bộ lọc XSS của trình duyệt
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
        
        String csp = "default-src 'self'; " +
                     "script-src 'self' 'unsafe-inline' https://cdn.hstatic.net https://cdnjs.cloudflare.com https://fonts.googleapis.com https://code.jquery.com https://stackpath.bootstrapcdn.com; " +
                     "style-src 'self' 'unsafe-inline' https://cdn.hstatic.net https://cdnjs.cloudflare.com https://fonts.googleapis.com https://stackpath.bootstrapcdn.com; " +
                     "img-src 'self' data: https: http: blob:; " +
                     "font-src 'self' data: https://fonts.gstatic.com https://cdnjs.cloudflare.com; " +
                     "connect-src 'self' https:; " +
                     "frame-src 'self' https://sandbox.vnpayment.vn https://pay.vnpay.vn https://test-payment.momo.vn https://*.paypal.com https://*.sandbox.paypal.com; " +
                     "frame-ancestors 'none';";
        httpResponse.setHeader("Content-Security-Policy", csp);
        
        // Referrer-Policy: Kiểm soát thông tin referrer
        httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        
        // Permissions-Policy: Kiểm soát browser features
        httpResponse.setHeader("Permissions-Policy", 
            "geolocation=(), microphone=(), camera=()");
        
        // Chỉ bật HSTS khi request chạy qua HTTPS
        if (httpRequest.isSecure()) {
            httpResponse.setHeader("Strict-Transport-Security", 
                "max-age=31536000; includeSubDomains; preload");
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup
    }
}
