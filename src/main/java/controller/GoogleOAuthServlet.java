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

@WebServlet(urlPatterns = {"/oauth/google", "/oauth/google/callback"})
public class GoogleOAuthServlet extends HttpServlet {
    
    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");
    private static final String STATE_SESSION_KEY = "oauth_google_state";

    private String getRedirectUri(HttpServletRequest request) {
        int port = request.getServerPort();
        String scheme = request.getScheme();
        boolean isDefaultPort = ("http".equals(scheme) && port == 80) || ("https".equals(scheme) && port == 443);
        return scheme + "://" + request.getServerName()
                + (isDefaultPort ? "" : ":" + port)
                + request.getContextPath() + "/oauth/google/callback";
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
        
        // Kiểm tra nếu chưa cấu hình OAuth
        if (!isConfigured()) {
            request.setAttribute("error", "🔑 Đăng nhập bằng Google chưa được cấu hình. Vui lòng xem file OAUTH_SETUP.md để cấu hình.");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        // Tạo URL OAuth của Google
        String redirectUri = getRedirectUri(request);
        String state = generateStateToken(request);
        String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + CLIENT_ID
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
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        String state = request.getParameter("state");
        HttpSession session = request.getSession(false);
        
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
                    CLIENT_ID,
                    CLIENT_SECRET,
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
            
            // Bước 4: Đăng nhập thành công - Tạo session
            session.removeAttribute(STATE_SESSION_KEY);
            session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getFullname());
            session.setAttribute("userRole", user.getRole());
            
            // Redirect về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi đăng nhập bằng Google: " + e.getMessage());
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
        }
    }

    private boolean isConfigured() {
        return CLIENT_ID != null && !CLIENT_ID.isEmpty() && CLIENT_SECRET != null && !CLIENT_SECRET.isEmpty();
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
