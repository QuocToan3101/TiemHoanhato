package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Parameter;
import com.restfb.Version;
import com.restfb.exception.FacebookException;
import com.restfb.types.User;

import dao.UserDAO;

@WebServlet(urlPatterns = {"/oauth/facebook", "/oauth/facebook/callback"})
public class FacebookOAuthServlet extends HttpServlet {
    
    private static final String APP_ID = System.getenv("FACEBOOK_APP_ID");
    private static final String APP_SECRET = System.getenv("FACEBOOK_APP_SECRET");
    private static final String REDIRECT_URI = System.getenv("FACEBOOK_REDIRECT_URI");
    private static final String STATE_SESSION_KEY = "oauth_facebook_state";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if (path.equals("/oauth/facebook")) {
            // Bước 1: Chuyển hướng đến Facebook OAuth
            initiateFacebookLogin(request, response);
        } else if (path.equals("/oauth/facebook/callback")) {
            // Bước 2: Xử lý callback từ Facebook
            handleFacebookCallback(request, response);
        }
    }
    
    private void initiateFacebookLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        // Kiểm tra nếu chưa cấu hình OAuth
        if (!isConfigured()) {
            request.setAttribute("error", "🔑 Đăng nhập bằng Facebook chưa được cấu hình. Vui lòng xem file OAUTH_SETUP.md để cấu hình.");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        String state = generateStateToken(request);
        // Tạo URL OAuth của Facebook
        String facebookAuthUrl = "https://www.facebook.com/v19.0/dialog/oauth"
                + "?client_id=" + APP_ID
                + "&redirect_uri=" + REDIRECT_URI
                + "&scope=email,public_profile"
            + "&response_type=code"
            + "&state=" + java.net.URLEncoder.encode(state, "UTF-8");
        
        response.sendRedirect(facebookAuthUrl);
    }
    
    private void handleFacebookCallback(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        String state = request.getParameter("state");
        HttpSession session = request.getSession(false);
        
        if (error != null) {
            // User từ chối hoặc có lỗi
            request.setAttribute("error", "Đăng nhập Facebook thất bại: " + error);
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        if (code == null) {
            request.setAttribute("error", "Không nhận được mã xác thực từ Facebook");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }

        if (session == null || !validateState(session, state)) {
            request.setAttribute("error", "Yêu cầu không hợp lệ (state mismatch)");
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
            return;
        }
        
        try {
            // Bước 1: Đổi code lấy access token
            FacebookClient client = new DefaultFacebookClient(Version.LATEST);
            FacebookClient.AccessToken accessToken = client.obtainUserAccessToken(
                    APP_ID,
                    APP_SECRET,
                    REDIRECT_URI,
                    code
            );
            
            // Bước 2: Dùng access token để lấy thông tin user
            FacebookClient fbClient = new DefaultFacebookClient(accessToken.getAccessToken(), Version.LATEST);
            User fbUser = fbClient.fetchObject("me", User.class, 
                    Parameter.with("fields", "id,name,email,picture"));
            
            String facebookId = fbUser.getId();
            String email = fbUser.getEmail();
            String name = fbUser.getName();
            
            // Kiểm tra email
            if (email == null || email.isEmpty()) {
                request.setAttribute("error", "Không thể lấy email từ Facebook. Vui lòng cấp quyền email.");
                request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
                return;
            }
            
            // Bước 3: Kiểm tra user đã tồn tại chưa
            UserDAO userDAO = new UserDAO();
            model.User user = userDAO.findByEmail(email);
            
            if (user == null) {
                // Tạo user mới
                user = new model.User();
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
            
        } catch (FacebookException e) {
            request.setAttribute("error", "Lỗi Facebook: " + e.getMessage());
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi đăng nhập bằng Facebook: " + e.getMessage());
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
        }
    }

    private boolean isConfigured() {
        return APP_ID != null && !APP_ID.isEmpty() &&
               APP_SECRET != null && !APP_SECRET.isEmpty() &&
               REDIRECT_URI != null && !REDIRECT_URI.isEmpty();
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
