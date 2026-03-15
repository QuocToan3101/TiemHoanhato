package controller;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.Base64;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import service.AICardService;
import service.CardImageGenerator;

/**
 * Servlet API endpoint để tạo thiệp tự động bằng AI và generate ảnh PNG
 */
@WebServlet({"/api/ai-card-generate", "/api/generate-card-image", "/api/download-card"})
public class AICardServlet extends HttpServlet {
    
    private AICardService aiCardService;
    private CardImageGenerator imageGenerator;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        aiCardService = AICardService.getInstance();
        imageGenerator = new CardImageGenerator();
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        
        if ("/api/ai-card-generate".equals(servletPath)) {
            handleGenerateText(request, response);
        } else if ("/api/generate-card-image".equals(servletPath)) {
            handleGenerateImage(request, response);
        }
    }
    
    /**
     * Generate text message bằng Gemini AI
     */
    private void handleGenerateText(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Set response type
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // CORS headers (nếu cần)
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();
        
        try {
            // Đọc request body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            String requestBody = sb.toString();
            if (requestBody.isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("error", "Request body is empty");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(result));
                return;
            }
            
            // Parse JSON
            JsonObject requestJson = gson.fromJson(requestBody, JsonObject.class);
            
            // Extract parameters
            String recipient = requestJson.has("recipient") ? 
                requestJson.get("recipient").getAsString() : "";
            String occasion = requestJson.has("occasion") ? 
                requestJson.get("occasion").getAsString() : "khac";
            String tone = requestJson.has("tone") ? 
                requestJson.get("tone").getAsString() : "warm";
            String customMessage = requestJson.has("customMessage") ? 
                requestJson.get("customMessage").getAsString() : "";
            String length = requestJson.has("length") ? 
                requestJson.get("length").getAsString() : "trungbinh";
            
            // Generate message
            System.out.println("AI Card Request - Recipient: " + recipient + 
                ", Occasion: " + occasion + ", Tone: " + tone);
            
            String message = aiCardService.generateCardMessage(
                recipient, occasion, tone, customMessage, length);
            
            if (message != null && !message.isEmpty()) {
                // Lưu vào session để dùng sau
                HttpSession session = request.getSession();
                session.setAttribute("lastCardMessage", message);
                session.setAttribute("lastCardOccasion", occasion);
                
                result.addProperty("success", true);
                result.addProperty("message", message);
                result.addProperty("source", "gemini-ai");
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                result.addProperty("success", false);
                result.addProperty("error", "Failed to generate message");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            
        } catch (Exception e) {
            System.err.println("Error in AICardServlet (generate text): " + e.getMessage());
            
            result.addProperty("success", false);
            result.addProperty("error", "Server error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Generate ảnh PNG từ text message
     */
    private void handleGenerateImage(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();
        
        try {
            // Đọc request body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject requestJson = gson.fromJson(sb.toString(), JsonObject.class);
            
            String message = requestJson.has("message") ? 
                requestJson.get("message").getAsString() : "";
            String occasion = requestJson.has("occasion") ? 
                requestJson.get("occasion").getAsString() : "khac";
            
            if (message.isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("error", "Message is empty");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(result));
                return;
            }
            
            // Tạo ảnh thiệp
            BufferedImage cardImage = imageGenerator.generateCardImage(message, occasion);
            
            // Convert sang byte array
            byte[] imageBytes = imageGenerator.imageToBytes(cardImage);
            
            // Lưu vào session để dùng khi checkout
            HttpSession session = request.getSession();
            session.setAttribute("greetingCardImage", imageBytes);
            session.setAttribute("greetingCardMessage", message);
            session.setAttribute("greetingCardOccasion", occasion);
            
            // Encode base64 để gửi về frontend
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);
            
            result.addProperty("success", true);
            result.addProperty("imageData", "data:image/png;base64," + base64Image);
            result.addProperty("message", "Card image generated successfully");
            response.setStatus(HttpServletResponse.SC_OK);
            
        } catch (Exception e) {
            System.err.println("Error in AICardServlet (generate image): " + e.getMessage());
            
            result.addProperty("success", false);
            result.addProperty("error", "Server error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Download ảnh thiệp dưới dạng PNG file
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        byte[] imageBytes = (byte[]) session.getAttribute("greetingCardImage");
        
        if (imageBytes == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No card image found in session");
            return;
        }
        
        // Set headers cho download
        response.setContentType("image/png");
        response.setHeader("Content-Disposition", "attachment; filename=\"greeting-card.png\"");
        response.setContentLength(imageBytes.length);
        
        // Ghi image bytes ra response
        OutputStream os = response.getOutputStream();
        os.write(imageBytes);
        os.flush();
        os.close();
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle CORS preflight
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
