package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.UserDAO;
import model.User;
import service.CartService;
import util.AppConfig;

@WebServlet(urlPatterns = {"/oauth/google", "/oauth/google/callback"})
public class GoogleOAuthServlet extends HttpServlet {

    private static final String STATE_SESSION_KEY = "oauth_google_state";

    private static final String CALLBACK_PATH = "/oauth/google/callback";

    private final CartService cartService = new CartService();

    private String getRedirectUri(HttpServletRequest request) {
        AppConfig config = AppConfig.getInstance();

        String configuredRedirect = normalizeConfigValue(firstNonBlank(
                System.getenv("GOOGLE_REDIRECT_URI"),
                System.getProperty("GOOGLE_REDIRECT_URI")
        ));

        if (configuredRedirect != null) {
            return configuredRedirect;
        }

        String forwardedProto = firstForwardedValue(request.getHeader("X-Forwarded-Proto"));
        String forwardedHost = firstForwardedValue(request.getHeader("X-Forwarded-Host"));
        String forwardedPort = firstForwardedValue(request.getHeader("X-Forwarded-Port"));

        String scheme = (forwardedProto != null) ? forwardedProto : request.getScheme();
        String hostHeader = (forwardedHost != null) ? forwardedHost : request.getHeader("Host");

        String host = request.getServerName();
        int port = request.getServerPort();

        if (hostHeader != null && !hostHeader.trim().isEmpty()) {
            String normalizedHostHeader = hostHeader.trim();
            if (normalizedHostHeader.contains(":")) {
                String[] hostPortParts = normalizedHostHeader.split(":", 2);
                host = hostPortParts[0].trim();
                if (hostPortParts.length > 1) {
                    try {
                        port = Integer.parseInt(hostPortParts[1].trim());
                    } catch (NumberFormatException ignored) {
                        // Keep current port.
                    }
                }
            } else {
                host = normalizedHostHeader;
            }
        }

        if (forwardedPort != null) {
            try {
                port = Integer.parseInt(forwardedPort);
            } catch (NumberFormatException ignored) {
                // Keep current port.
            }
        }

        boolean isDefaultPort = ("http".equalsIgnoreCase(scheme) && port == 80)
                || ("https".equalsIgnoreCase(scheme) && port == 443);
        return scheme + "://" + host + (isDefaultPort ? "" : ":" + port)
                + request.getContextPath() + CALLBACK_PATH;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if (path.equals("/oauth/google")) {
            // Bước 1: Chuyển hướng đến Google OAuth
            initiateGoogleLogin(request, response);
        } else if (path.equals("/oauth/google/callback")) {
            // Bước 2: Xử lý callback từ Google
            handleGoogleCallback(request, response);
        }
    }
    
    private void initiateGoogleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        String clientId = getClientId();
        String clientSecret = getClientSecret();
        
        // Kiểm tra nếu chưa cấu hình OAuth
        if (!isConfigured(clientId, clientSecret)) {
            request.setAttribute("error", "🔑 Đăng nhập bằng Google chưa được cấu hình. Vui lòng xem file OAUTH_SETUP.md để cấu hình.");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        // Tạo URL OAuth của Google
        String redirectUri = getRedirectUri(request);
        String state = generateStateToken(request);
        String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
            + "?client_id=" + clientId
                + "&redirect_uri=" + java.net.URLEncoder.encode(redirectUri, "UTF-8")
                + "&response_type=code"
                + "&scope=openid%20email%20profile"
                + "&access_type=offline"
            + "&prompt=consent"
            + "&state=" + java.net.URLEncoder.encode(state, "UTF-8");
        
        response.sendRedirect(googleAuthUrl);
    }
    
    private void handleGoogleCallback(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String clientId = getClientId();
        String clientSecret = getClientSecret();
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        String state = request.getParameter("state");
        HttpSession session = request.getSession(false);

        if (!isConfigured(clientId, clientSecret)) {
            request.setAttribute("error", "Đăng nhập Google chưa được cấu hình đầy đủ.");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        if (error != null) {
            // User từ chối hoặc có lỗi
            request.setAttribute("error", "Đăng nhập Google thất bại: " + error);
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        if (code == null) {
            request.setAttribute("error", "Không nhận được mã xác thực từ Google");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }

        if (session == null || !validateState(session, state)) {
            request.setAttribute("error", "Yêu cầu không hợp lệ (state mismatch)");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        try {
            // Bước 1: Đổi authorization code lấy access token
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    GsonFactory.getDefaultInstance(),
                    "https://oauth2.googleapis.com/token",
                    clientId,
                    clientSecret,
                    code,
                    getRedirectUri(request)
            ).execute();
            
            String accessToken = tokenResponse.getAccessToken();
            
            // Bước 2: Dùng access token để lấy thông tin user
            String userInfoUrl = "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken;
            URL url = new URL(userInfoUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder jsonResponse = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonResponse.append(line);
            }
            reader.close();
            
            // Parse JSON response
            Gson gson = new Gson();
            JsonObject userInfo = gson.fromJson(jsonResponse.toString(), JsonObject.class);
            
            String googleId = userInfo.get("id").getAsString();
            String email = userInfo.get("email").getAsString();
            String name = userInfo.has("name") ? userInfo.get("name").getAsString() : "User";
            
            // Bước 3: Kiểm tra user đã tồn tại chưa
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);
            
            if (user == null) {
                // Tạo user mới
                user = new User();
                user.setEmail(email);
                user.setFullname(name);
                user.setPassword(BCrypt.hashpw(java.util.UUID.randomUUID().toString(), BCrypt.gensalt()));
                user.setRole("customer");
                user.setStatus("active");
                
                boolean created = userDAO.register(user);
                if (!created) {
                    request.setAttribute("error", "Không thể tạo tài khoản. Vui lòng thử lại.");
                    request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
                    return;
                }
                
                // Lấy lại user để có ID
                user = userDAO.findByEmail(email);
            }
            
            // Bước 4: Đăng nhập thành công - Tạo session mới và merge giỏ hàng guest nếu có
            HttpSession existingSession = request.getSession(false);
            Object guestCart = existingSession != null ? existingSession.getAttribute(CartService.SESSION_CART_KEY) : null;

            if (existingSession != null) {
                existingSession.invalidate();
            }

            session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getFullname());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60);

            if (guestCart != null) {
                session.setAttribute(CartService.SESSION_CART_KEY, guestCart);
                cartService.mergeSessionCartToDb(session, user.getId());
            }
            
            // Redirect về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi đăng nhập bằng Google: " + e.getMessage());
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
        }
    }

    private String getClientId() {
        AppConfig config = AppConfig.getInstance();
        String value = firstNonBlank(
                System.getenv("GOOGLE_CLIENT_ID"),
                System.getProperty("GOOGLE_CLIENT_ID"),
                config.getProperty("google.oauth.client.id"),
                config.getProperty("google.client.id")
        );
        return normalizeConfigValue(value);
    }

    private String getClientSecret() {
        AppConfig config = AppConfig.getInstance();
        String value = firstNonBlank(
                System.getenv("GOOGLE_CLIENT_SECRET"),
                System.getProperty("GOOGLE_CLIENT_SECRET"),
                config.getProperty("google.oauth.client.secret"),
                config.getProperty("google.client.secret")
        );
        return normalizeConfigValue(value);
    }

    private boolean isConfigured(String clientId, String clientSecret) {
        return clientId != null && !clientId.isEmpty() && clientSecret != null && !clientSecret.isEmpty();
    }

    private String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return null;
    }

    private String normalizeConfigValue(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            return null;
        }
        // Ignore placeholders so we don't treat template values as valid secrets.
        if (trimmed.startsWith("CHANGE_ME") || trimmed.startsWith("YOUR_") || trimmed.equalsIgnoreCase("your_client_id_here")
                || trimmed.equalsIgnoreCase("your_client_secret_here")) {
            return null;
        }
        return trimmed;
    }

    private String firstForwardedValue(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        String[] parts = value.split(",");
        if (parts.length == 0) {
            return null;
        }
        String first = parts[0].trim();
        return first.isEmpty() ? null : first;
    }

    private String stripTrailingSlash(String value) {
        if (value == null) {
            return null;
        }
        if (value.endsWith("/")) {
            return value.substring(0, value.length() - 1);
        }
        return value;
    }

    private boolean shouldUseConfiguredBaseUrl(String appUrl, HttpServletRequest request) {
        try {
            java.net.URI uri = new java.net.URI(appUrl);
            String configuredHost = uri.getHost();
            if (configuredHost == null || configuredHost.trim().isEmpty()) {
                return false;
            }

            String requestHost = request.getServerName();
            if (isLocalAddress(configuredHost) && !isLocalAddress(requestHost)) {
                return false;
            }
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean isLocalAddress(String host) {
        if (host == null) {
            return true;
        }
        String normalized = host.trim().toLowerCase();
        return normalized.equals("localhost")
                || normalized.equals("127.0.0.1")
                || normalized.equals("::1");
    }

    private String generateStateToken(HttpServletRequest request) {
        String state = java.util.UUID.randomUUID().toString();
        HttpSession session = request.getSession(true);
        session.setAttribute(STATE_SESSION_KEY, state);
        return state;
    }

    private boolean validateState(HttpSession session, String state) {
        if (state == null) {
            return false;
        }
        String sessionState = (String) session.getAttribute(STATE_SESSION_KEY);
        return state.equals(sessionState);
    }
}
