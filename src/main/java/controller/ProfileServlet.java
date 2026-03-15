package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;

@WebServlet("/profile/*")
public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/view/login_1.jsp");
            return;
        }
        
        request.getRequestDispatcher("/view/settingProfile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Chưa đăng nhập\"}");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String pathInfo = request.getPathInfo();
        
        // Handle change password
        if (pathInfo != null && pathInfo.equals("/changePassword")) {
            handleChangePassword(request, response, user);
            return;
        }
        
        // Handle update field
        handleUpdateField(request, response, user, session);
    }
    
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        PrintWriter out = response.getWriter();
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        
        // Validate
        if (currentPassword == null || currentPassword.isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Vui lòng nhập mật khẩu hiện tại\"}");
            return;
        }
        
        if (newPassword == null || newPassword.isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Vui lòng nhập mật khẩu mới\"}");
            return;
        }
        
        if (newPassword.length() < 8) {
            out.write("{\"success\": false, \"message\": \"Mật khẩu mới phải có ít nhất 8 ký tự\"}");
            return;
        }
        
        // Change password
        boolean success = userDAO.changePassword(user.getId(), currentPassword, newPassword);
        
        if (success) {
            out.write("{\"success\": true, \"message\": \"Đổi mật khẩu thành công\"}");
        } else {
            out.write("{\"success\": false, \"message\": \"Mật khẩu hiện tại không đúng\"}");
        }
    }
    
    private void handleUpdateField(HttpServletRequest request, HttpServletResponse response, 
            User user, HttpSession session) throws IOException {
        String field = request.getParameter("field");
        String value = request.getParameter("value");
        
        PrintWriter out = response.getWriter();
        
        try {
            boolean success = false;
            
            switch (field) {
                case "fullname":
                    if (value != null && !value.trim().isEmpty()) {
                        user.setFullname(value.trim());
                        success = userDAO.updateField(user.getId(), "fullname", value.trim());
                    }
                    break;
                    
                case "bio":
                    user.setBio(value);
                    success = userDAO.updateField(user.getId(), "bio", value);
                    break;
                    
                case "gender":
                    user.setGender(value);
                    success = userDAO.updateField(user.getId(), "gender", value);
                    break;
                    
                case "birthday":
                    if (value != null && !value.isEmpty()) {
                        Date birthday = Date.valueOf(value);
                        user.setBirthday(birthday);
                        success = userDAO.updateBirthday(user.getId(), birthday);
                    }
                    break;
                    
                case "phone":
                    user.setPhone(value);
                    success = userDAO.updateField(user.getId(), "phone", value);
                    break;
                    
                case "avatar":
                    user.setAvatar(value);
                    success = userDAO.updateField(user.getId(), "avatar", value);
                    break;
                    
                default:
                    out.write("{\"success\": false, \"message\": \"Trường không hợp lệ\"}");
                    return;
            }
            
            if (success) {
                // Cập nhật session
                session.setAttribute("user", user);
                out.write("{\"success\": true, \"message\": \"Cập nhật thành công\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Cập nhật thất bại\"}");
            }
            
        } catch (Exception e) {
            out.write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
    }
}
