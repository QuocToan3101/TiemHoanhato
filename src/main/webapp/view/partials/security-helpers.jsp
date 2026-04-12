<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Security helpers (JSTL/EL only)
  - Escape HTML/text: use fn:escapeXml, e.g. ${fn:escapeXml(value)}
  - Escape for attributes: still use fn:escapeXml
  - CSRF token: use ${csrfToken} made available by filter
  - Avoid scriptlets; rely on JSTL tags and functions
--%>
