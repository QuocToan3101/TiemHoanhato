package filter;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

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
 * Rate Limiting Filter
 * Giới hạn số lượng request từ một IP trong khoảng thời gian
 */
@WebFilter(urlPatterns = {"/*"})
public class RateLimitFilter implements Filter {
    
    // Lưu trữ số request của mỗi IP
    private static final ConcurrentHashMap<String, RequestCounter> requestCounts = new ConcurrentHashMap<>();
    
    // Cấu hình
    private static final int MAX_REQUESTS_PER_MINUTE = 60; // 60 requests/phút
    private static final int MAX_AUTH_REQUESTS_PER_MINUTE = 12; // Auth endpoints strict limit
    private static final long TIME_WINDOW_MS = 60 * 1000; // 1 phút
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Start cleanup thread
        startCleanupThread();
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (!shouldApplyRateLimit(httpRequest)) {
            chain.doFilter(request, response);
            return;
        }
        
        String clientIp = getClientIP(httpRequest);
        String bucket = getBucket(httpRequest);
        int requestLimit = getLimitForPath(httpRequest);
        
        // Kiểm tra rate limit
        RequestCounter counter = requestCounts.computeIfAbsent(clientIp + ":" + bucket,
            k -> new RequestCounter());
        
        long currentTime = System.currentTimeMillis();
        
        synchronized (counter) {
            // Reset counter nếu đã hết time window
            if (currentTime - counter.windowStart > TIME_WINDOW_MS) {
                counter.count.set(0);
                counter.windowStart = currentTime;
            }
            
            // Kiểm tra số lượng request
            if (counter.count.get() >= requestLimit) {
                // Trả về 429 Too Many Requests
                httpResponse.setStatus(429);
                httpResponse.setContentType("application/json");
                httpResponse.getWriter().write(
                    "{\"error\": \"Too many requests. Please try again later.\"}"
                );
                return;
            }
            
            // Tăng counter
            counter.count.incrementAndGet();
        }
        
        // Set header để client biết rate limit
        httpResponse.setHeader("X-RateLimit-Limit", String.valueOf(requestLimit));
        httpResponse.setHeader("X-RateLimit-Remaining", 
            String.valueOf(Math.max(0, requestLimit - counter.count.get())));
        httpResponse.setHeader("X-RateLimit-Reset", 
            String.valueOf((counter.windowStart + TIME_WINDOW_MS) / 1000));
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        requestCounts.clear();
    }
    
    /**
     * Lấy IP thực của client (xử lý proxy/load balancer)
     */
    private String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // Nếu có nhiều IP (qua nhiều proxy), lấy IP đầu tiên
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }

    private boolean shouldApplyRateLimit(HttpServletRequest request) {
        String path = request.getServletPath();
        if (path == null || path.isEmpty()) {
            path = request.getRequestURI().substring(request.getContextPath().length());
        }

        return path.startsWith("/api/")
                || path.startsWith("/ajax/")
                || "/login".equals(path)
                || "/register".equals(path)
                || "/forgot-password".equals(path)
                || "/reset-password".equals(path)
                || path.startsWith("/oauth/");
    }

    private int getLimitForPath(HttpServletRequest request) {
        String path = request.getServletPath();
        if (path == null || path.isEmpty()) {
            path = request.getRequestURI().substring(request.getContextPath().length());
        }

        if ("/login".equals(path)
                || "/register".equals(path)
                || "/forgot-password".equals(path)
                || "/reset-password".equals(path)
                || path.startsWith("/oauth/")) {
            return MAX_AUTH_REQUESTS_PER_MINUTE;
        }

        return MAX_REQUESTS_PER_MINUTE;
    }

    private String getBucket(HttpServletRequest request) {
        String path = request.getServletPath();
        if (path == null || path.isEmpty()) {
            path = request.getRequestURI().substring(request.getContextPath().length());
        }

        if ("/login".equals(path)) {
            return "auth-login";
        }
        if ("/register".equals(path)) {
            return "auth-register";
        }
        if ("/forgot-password".equals(path) || "/reset-password".equals(path)) {
            return "auth-password";
        }
        if (path.startsWith("/oauth/")) {
            return "auth-oauth";
        }
        return "api-generic";
    }
    
    /**
     * Thread cleanup để xóa các entry cũ
     */
    private void startCleanupThread() {
        Thread cleanupThread = new Thread(() -> {
            while (true) {
                try {
                    Thread.sleep(TIME_WINDOW_MS);
                    
                    long currentTime = System.currentTimeMillis();
                    requestCounts.entrySet().removeIf(entry -> 
                        currentTime - entry.getValue().windowStart > TIME_WINDOW_MS * 2
                    );
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        });
        cleanupThread.setDaemon(true);
        cleanupThread.start();
    }
    
    /**
     * Class lưu trữ thông tin counter
     */
    private static class RequestCounter {
        AtomicLong count = new AtomicLong(0);
        long windowStart = System.currentTimeMillis();
    }
}
