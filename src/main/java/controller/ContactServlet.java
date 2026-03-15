package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.ContactDAO;
import model.Contact;
import model.User;

/**
 * Servlet xử lý form liên hệ
 */
@WebServlet(urlPatterns = {"/contact", "/api/contact"})
public class ContactServlet extends HttpServlet {
    
    private ContactDAO contactDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        contactDAO = new ContactDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to contact page
        request.getRequestDispatcher("/view/contact.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            // Get form data
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập tên của bạn");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (phone == null || phone.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập số điện thoại");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (message == null || message.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập nội dung tin nhắn");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Validate phone format (simple check)
            phone = phone.trim().replaceAll("\\s+", "");
            if (!phone.matches("^0\\d{9,10}$")) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Số điện thoại không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Validate email format if provided
            if (email != null && !email.trim().isEmpty()) {
                email = email.trim();
                if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Email không hợp lệ");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
            }
            
            // Create contact
            Contact contact = new Contact();
            contact.setName(name.trim());
            contact.setPhone(phone);
            contact.setEmail(email != null ? email.trim() : null);
            contact.setSubject(subject != null && !subject.trim().isEmpty() ? subject.trim() : null);
            contact.setMessage(message.trim());
            contact.setStatus("new");
            
            // Check if user is logged in
            HttpSession session = request.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    contact.setUserId(user.getId());
                }
            }
            
            // Save to database
            int newId = contactDAO.add(contact);
            
            if (newId > 0) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi trong thời gian sớm nhất.");
                jsonResponse.addProperty("contactId", newId);
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Có lỗi xảy ra, vui lòng thử lại sau");
            }
            
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
}
