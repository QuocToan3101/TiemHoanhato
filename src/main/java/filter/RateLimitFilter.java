package filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Simple in-memory rate limiter for shipping endpoints.
 * Production deployments can replace this with a Redis-backed implementation.
 */
@WebFilter(filterName = "RateLimitFilter", urlPatterns = {"/api/shipping/*"})
public class RateLimitFilter implements Filter {
    private final Map<String, WindowState> states = new ConcurrentHashMap<>();
    private int maxRequests = 30;
    private int windowSeconds = 60;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String maxRequestsParam = filterConfig.getInitParameter("rate.max");
        String windowSecondsParam = filterConfig.getInitParameter("rate.window.seconds");
        if (maxRequestsParam != null) {
            try { maxRequests = Integer.parseInt(maxRequestsParam); } catch (NumberFormatException ignored) {}
        }
        if (windowSecondsParam != null) {
            try { windowSeconds = Integer.parseInt(windowSecondsParam); } catch (NumberFormatException ignored) {}
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String clientKey = extractClientKey(req);
        WindowState state = states.computeIfAbsent(clientKey, key -> new WindowState());

        synchronized (state) {
            long now = System.currentTimeMillis();
            long windowLengthMs = windowSeconds * 1000L;
            if (now - state.windowStart >= windowLengthMs) {
                state.windowStart = now;
                state.count.set(0);
            }

            int currentCount = state.count.incrementAndGet();
            resp.setHeader("X-RateLimit-Limit", String.valueOf(maxRequests));
            resp.setHeader("X-RateLimit-Remaining", String.valueOf(Math.max(0, maxRequests - currentCount)));
            resp.setHeader("X-RateLimit-Reset", String.valueOf((state.windowStart + windowLengthMs) / 1000L));

            if (currentCount > maxRequests) {
                resp.setStatus(429);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"error\":\"Too many requests\"}");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        states.clear();
    }

    private String extractClientKey(HttpServletRequest req) {
        String forwardedFor = req.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            return forwardedFor.split(",")[0].trim();
        }
        String realIp = req.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isBlank()) {
            return realIp.trim();
        }
        return req.getRemoteAddr();
    }

    private static class WindowState {
        private final AtomicInteger count = new AtomicInteger(0);
        private long windowStart = System.currentTimeMillis();
    }
}
