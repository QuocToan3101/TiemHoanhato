package filter;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.SessionCookieConfig;

@WebListener
public class SessionConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext sc = sce.getServletContext();
        SessionCookieConfig scc = sc.getSessionCookieConfig();
        // Make session cookie HttpOnly to mitigate XSS stealing
        scc.setHttpOnly(true);
        // Set secure flag if application forces HTTPS via context-param (optional)
        String forceHttps = sc.getInitParameter("app.forceHttps");
        boolean secure = "true".equalsIgnoreCase(forceHttps);
        scc.setSecure(secure);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Shutdown EmailService thread pool to avoid classloader / thread leaks on Tomcat
        try {
            service.EmailService.getInstance().shutdown();
            System.out.println("✓ EmailService background thread pool shut down successfully.");
        } catch (Exception e) {
            System.err.println("Error shutting down EmailService thread pool: " + e.getMessage());
        }
    }
}
