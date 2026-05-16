package controller;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;
import service.EmailService;
import util.AppConfig;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/view/home.jsp");
            return;
        }
        request.getRequestDispatcher("/view/registration.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");
        String phone = request.getParameter("phone");
        String agree = request.getParameter("agree");

        // 1. Gọi hàm Validation riêng cho code gọn gàng
        String validationError = validateInput(fullname, email, password, repassword, agree);
        if (validationError != null) {
            sendError(request, response, validationError, fullname, email);
            return;
        }

        // 2. Kiểm tra email tồn tại
        if (userDAO.emailExists(email.trim())) {
            sendError(request, response, "Email này đã được đăng ký!", fullname, email);
            return;
        }

        // 3. Tiến hành tạo User
        User newUser = new User();
        newUser.setFullname(fullname.trim());
        newUser.setEmail(email.trim());
        newUser.setPassword(password);
        newUser.setPhone(phone != null ? phone.trim() : null);
        newUser.setRole("customer");
        newUser.setStatus("pending");

        String verificationToken = UUID.randomUUID().toString();
        boolean success = userDAO.registerWithVerification(newUser, verificationToken);

        // 4. Xử lý kết quả và gửi Email
        if (success) {
            try {
                String verificationLink = buildVerificationLink(request, verificationToken);
                boolean mailSent = EmailService.getInstance().sendVerificationEmail(
                        email.trim(),
                        fullname.trim(),
                        verificationLink
                );

                if (mailSent) {
                    request.setAttribute("success", "Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.");
                } else {
                    request.setAttribute("error", "Đăng ký thành công nhưng chưa gửi được email xác thực. Tài khoản của bạn đang chờ xác thực, vui lòng kiểm tra lại cấu hình SMTP (email.username/email.password hoặc biến môi trường EMAIL_PASSWORD).");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Đăng ký thành công nhưng hệ thống lỗi gửi email xác thực. Vui lòng liên hệ Admin để kiểm tra SMTP.");
            }
            request.getRequestDispatcher("/view/login_1.jsp").forward(request, response);
        } else {
            sendError(request, response, "Đăng ký thất bại do lỗi hệ thống! Vui lòng thử lại.", fullname, email);
        }
    }

    // Hàm phụ trợ: Tách logic kiểm tra đầu vào
    private String validateInput(String fullname, String email, String password, String repassword, String agree) {
        if (fullname == null || fullname.trim().isEmpty()) return "Vui lòng nhập họ tên!";
        if (email == null || email.trim().isEmpty()) return "Vui lòng nhập email!";
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) return "Email không hợp lệ!";
        if (password == null || password.length() < 6) return "Mật khẩu phải có ít nhất 6 ký tự!";
        if (!password.equals(repassword)) return "Mật khẩu nhập lại không khớp!";
        if (!"on".equals(agree)) return "Vui lòng đồng ý với chính sách dịch vụ!";
        return null; // Không có lỗi
    }

    private void sendError(HttpServletRequest request, HttpServletResponse response,
                           String error, String fullname, String email)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("fullname", fullname);
        request.setAttribute("email", email);
        request.getRequestDispatcher("/view/registration.jsp").forward(request, response);
    }

    private String buildVerificationLink(HttpServletRequest request, String verificationToken) {
        AppConfig config = AppConfig.getInstance();
        String configuredAppUrl = config.getAppUrl();

        if (configuredAppUrl != null && !configuredAppUrl.trim().isEmpty() && shouldUseConfiguredBaseUrl(configuredAppUrl, request)) {
            String baseUrl = configuredAppUrl.trim();
            if (baseUrl.endsWith("/")) {
                baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
            }
            return baseUrl + "/verify-email?token=" + verificationToken;
        }

        String scheme = request.getScheme();
        String host = request.getServerName();
        int port = request.getServerPort();
        boolean isDefaultPort = ("http".equalsIgnoreCase(scheme) && port == 80)
                || ("https".equalsIgnoreCase(scheme) && port == 443);

        return scheme + "://" + host + (isDefaultPort ? "" : ":" + port)
                + request.getContextPath() + "/verify-email?token=" + verificationToken;
    }

    private boolean shouldUseConfiguredBaseUrl(String appUrl, HttpServletRequest request) {
        try {
            java.net.URI uri = new java.net.URI(appUrl.trim());
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
}