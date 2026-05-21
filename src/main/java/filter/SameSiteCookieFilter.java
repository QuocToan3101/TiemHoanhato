package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletResponse;
import javax.servlet.ServletRequest;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

@WebFilter(urlPatterns = {"/*"})
public class SameSiteCookieFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no-op
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (!(response instanceof HttpServletResponse)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletResponse httpResp = (HttpServletResponse) response;

        HttpServletResponseWrapper wrapper = new HttpServletResponseWrapper(httpResp) {
            @Override
            public void addHeader(String name, String value) {
                if ("Set-Cookie".equalsIgnoreCase(name) && value != null && !value.toLowerCase().contains("samesite")) {
                    super.addHeader(name, value + "; SameSite=Lax");
                } else {
                    super.addHeader(name, value);
                }
            }

            @Override
            public void setHeader(String name, String value) {
                if ("Set-Cookie".equalsIgnoreCase(name) && value != null && !value.toLowerCase().contains("samesite")) {
                    super.setHeader(name, value + "; SameSite=Lax");
                } else {
                    super.setHeader(name, value);
                }
            }
        };

        chain.doFilter(request, wrapper);
    }

    @Override
    public void destroy() {
        // no-op
    }
}
