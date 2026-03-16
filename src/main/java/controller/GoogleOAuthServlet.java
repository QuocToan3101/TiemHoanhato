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
import util.AppConfig;

@WebServlet(urlPatterns = {"/oauth/google", "/oauth/google/callback"})
public class GoogleOAuthServlet extends HttpServlet {
    private static final String OAUTH_CONFIG_MISSING_MESSAGE =
            "Dang nhap bang Google chua duoc cau hinh. Vui long lien he quan tri vien.";
    private final AppConfig config = AppConfig.getInstance();
    
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
        String clientId = config.getGoogleClientId();
        String clientSecret = config.getGoogleClientSecret();
        String redirectUri = resolveRedirectUri(request);
        
        // Kiểm tra nếu chưa cấu hình OAuth
        if (isMissingGoogleConfig(clientId, clientSecret, redirectUri)) {
            request.setAttribute("error", OAUTH_CONFIG_MISSING_MESSAGE);
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        // Tạo URL OAuth của Google
        String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
            + "?client_id=" + clientId
            + "&redirect_uri=" + redirectUri
                + "&response_type=code"
                + "&scope=openid%20email%20profile"
                + "&access_type=offline"
                + "&prompt=consent";
        
        response.sendRedirect(googleAuthUrl);
    }
    
    private void handleGoogleCallback(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String clientId = config.getGoogleClientId();
        String clientSecret = config.getGoogleClientSecret();
        String redirectUri = resolveRedirectUri(request);

        if (isMissingGoogleConfig(clientId, clientSecret, redirectUri)) {
            request.setAttribute("error", OAUTH_CONFIG_MISSING_MESSAGE);
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        
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
        
        try {
            // Bước 1: Đổi authorization code lấy access token
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    GsonFactory.getDefaultInstance(),
                    "https://oauth2.googleapis.com/token",
                        clientId,
                        clientSecret,
                    code,
                        redirectUri
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
                user.setPassword(BCrypt.hashpw(googleId, BCrypt.gensalt())); // Dùng Google ID làm password
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
            
            // Bước 4: Đăng nhập thành công - Tạo session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getFullname());
            session.setAttribute("userRole", user.getRole());
            
            // Redirect về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
            
        } catch (Exception e) {
            request.setAttribute("error", "Loi khi dang nhap bang Google. Vui long thu lai sau.");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
        }
    }

    private boolean isMissingGoogleConfig(String clientId, String clientSecret, String redirectUri) {
        return isBlank(clientId) || isBlank(clientSecret) || isBlank(redirectUri)
                || "YOUR_GOOGLE_CLIENT_ID".equals(clientId)
                || "YOUR_GOOGLE_CLIENT_SECRET".equals(clientSecret);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String resolveRedirectUri(HttpServletRequest request) {
        String configured = config.getGoogleRedirectUri();
        if (!isBlank(configured) && !configured.contains("YOUR_GOOGLE_REDIRECT_URI")) {
            return configured;
        }

        StringBuilder base = new StringBuilder();
        base.append(request.getScheme()).append("://").append(request.getServerName());
        int port = request.getServerPort();
        boolean isDefaultPort = ("http".equalsIgnoreCase(request.getScheme()) && port == 80)
                || ("https".equalsIgnoreCase(request.getScheme()) && port == 443);
        if (!isDefaultPort) {
            base.append(":").append(port);
        }
        base.append(request.getContextPath()).append("/oauth/google/callback");
        return base.toString();
    }
}
