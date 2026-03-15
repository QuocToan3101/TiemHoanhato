<%@ page import="util.XSSProtection" %>
<%!
    /**
     * JSP Helper Functions for Security
     * Sử dụng trong JSP: <%@ include file="/view/partials/security-helpers.jsp" %>
     */
    
    // Escape HTML
    public static String escHtml(String input) {
        return XSSProtection.escapeHtml(input);
    }
    
    // Escape HTML Attribute
    public static String escAttr(String input) {
        return XSSProtection.escapeHtmlAttribute(input);
    }
    
    // Escape JavaScript
    public static String escJs(String input) {
        return XSSProtection.escapeJavaScript(input);
    }
    
    // Escape URL
    public static String escUrl(String input) {
        return XSSProtection.escapeUrl(input);
    }
    
    // Get CSRF Token
    public static String getCsrfToken(HttpServletRequest req) {
        String token = (String) req.getAttribute("csrfToken");
        if (token == null) {
            token = (String) req.getSession().getAttribute("csrfToken");
        }
        return token != null ? token : "";
    }
%>
