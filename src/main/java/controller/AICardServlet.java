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

import dto.AICardState;
import service.AIContentService;
import service.AIImageService;
import service.CardRenderService;
import service.AICardService;
import service.CardImageGenerator;

/**
 * Refactored AI Card Servlet - Modern architecture
 * Endpoints:
 * - POST /api/ai-card-generate : Generate greeting text
 * - POST /api/generate-card-image : Generate card image
 * - GET /api/download-card : Download card as PNG
 * - POST /api/ai-card-background : Generate background
 * - POST /api/ai-card-complete : One-step complete generation
 */
@WebServlet({"/api/ai-card-generate", "/api/generate-card-image", "/api/download-card",
             "/api/ai-card-background", "/api/ai-card-complete"})
public class AICardServlet extends HttpServlet {
    
    // New services
    private AIContentService contentService;
    private AIImageService imageService;
    private CardRenderService renderService;
    
    // Legacy services (kept for backward compatibility)
    private AICardService aiCardService;
    private CardImageGenerator imageGenerator;
    
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize new services
        contentService = AIContentService.getInstance();
        imageService = AIImageService.getInstance();
        renderService = CardRenderService.getInstance();
        
        // Legacy services
        aiCardService = AICardService.getInstance();
        imageGenerator = new CardImageGenerator();
        
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        
        try {
            if (!ensureAuthenticated(request, response)) {
                return;
            }
            
            setCorsForSameOrigin(request, response);
            
            switch (servletPath) {
                case "/api/ai-card-generate":
                    handleGenerateText(request, response);
                    break;
                case "/api/generate-card-image":
                    handleGenerateImage(request, response);
                    break;
                case "/api/ai-card-background":
                    handleGenerateBackground(request, response);
                    break;
                case "/api/ai-card-complete":
                    handleCompleteGeneration(request, response);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("❌ AICardServlet error: " + e.getMessage());
            e.printStackTrace();
            sendJsonError(response, "Server error: " + e.getMessage(), 
                         HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * Generate greeting text bằng AI
     * New implementation sử dụng AIContentService
     */
    private void handleGenerateText(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Parse request
            JsonObject requestJson = parseJsonRequest(request);
            
            String recipient = requestJson.has("recipient") ? 
                requestJson.get("recipient").getAsString().trim() : "";
            String occasion = requestJson.has("occasion") ? 
                requestJson.get("occasion").getAsString() : "khac";
            String tone = requestJson.has("tone") ? 
                requestJson.get("tone").getAsString() : "warm";
            String customMessage = requestJson.has("customMessage") ? 
                requestJson.get("customMessage").getAsString().trim() : "";
            String length = requestJson.has("length") ? 
                requestJson.get("length").getAsString() : "trungbinh";
            
            // Generate greeting sử dụng new service
            String generatedMessage = contentService.generateGreeting(
                recipient, occasion, tone, customMessage, length
            );
            
            if (generatedMessage == null || generatedMessage.isEmpty()) {
                throw new Exception("Failed to generate message");
            }
            
            // Save to session
            HttpSession session = request.getSession();
            session.setAttribute("lastCardMessage", generatedMessage);
            session.setAttribute("lastCardOccasion", occasion);
            session.setAttribute("lastCardTone", tone);
            session.setAttribute("lastCardRecipient", recipient);
            
            // Response
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("message", generatedMessage);
            result.addProperty("source", "ai-service");
            
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(gson.toJson(result));
            
        } catch (Exception e) {
            System.err.println("❌ Error generating text: " + e.getMessage());
            sendJsonError(response, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        out.flush();
    }
    
    /**
     * Generate card image PNG từ message
     * New implementation sử dụng CardRenderService + AICardState
     */
    private void handleGenerateImage(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Parse request
            JsonObject requestJson = parseJsonRequest(request);
            
            String message = requestJson.has("message") ? 
                requestJson.get("message").getAsString() : "";
            String occasion = requestJson.has("occasion") ? 
                requestJson.get("occasion").getAsString() : "khac";
            String tone = requestJson.has("tone") ? 
                requestJson.get("tone").getAsString() : "warm";
            String recipient = requestJson.has("recipient") ? 
                requestJson.get("recipient").getAsString() : "";
            
            if (message.isEmpty()) {
                throw new IllegalArgumentException("Message is required");
            }
            
            // Build AICardState
            AICardState cardState = new AICardState.Builder()
                .recipient(recipient)
                .occasion(occasion)
                .tone(tone)
                .generatedMessage(message)
                .source("render-service")
                .build();
            
            // Render card
            BufferedImage cardImage = renderService.renderCard(cardState);
            String base64Image = renderService.imageToBase64(cardImage);
            
            // Save to session for later use
            byte[] imageBytes = renderService.imageToBytes(cardImage);
            HttpSession session = request.getSession();
            session.setAttribute("greetingCardImage", imageBytes);
            session.setAttribute("greetingCardMessage", message);
            session.setAttribute("greetingCardOccasion", occasion);
            
            // Response
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("imageData", base64Image);
            result.addProperty("width", cardImage.getWidth());
            result.addProperty("height", cardImage.getHeight());
            
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(gson.toJson(result));
            
        } catch (Exception e) {
            System.err.println("❌ Error generating image: " + e.getMessage());
            sendJsonError(response, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        out.flush();
    }
    
    /**
     * Generate background image URL
     */
    private void handleGenerateBackground(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            JsonObject requestJson = parseJsonRequest(request);
            
            String occasion = requestJson.has("occasion") ? 
                requestJson.get("occasion").getAsString() : "khac";
            String tone = requestJson.has("tone") ? 
                requestJson.get("tone").getAsString() : "warm";
            String message = requestJson.has("message") ? 
                requestJson.get("message").getAsString() : "";
            
            // Generate background (Pollinations AI or gradient fallback)
            String backgroundImageUrl = imageService.generateBackgroundImage(
                occasion, tone, message
            );
            
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("backgroundImageUrl", backgroundImageUrl);
            
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(gson.toJson(result));
            
        } catch (Exception e) {
            System.err.println("❌ Error generating background: " + e.getMessage());
            sendJsonError(response, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        out.flush();
    }
    
    /**
     * Complete one-step generation: text + image + background
     * Optimized endpoint para sa frontend
     */
    private void handleCompleteGeneration(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            JsonObject requestJson = parseJsonRequest(request);
            
            // Parse parameters
            String recipient = requestJson.has("recipient") ? 
                requestJson.get("recipient").getAsString().trim() : "";
            String occasion = requestJson.has("occasion") ? 
                requestJson.get("occasion").getAsString() : "khac";
            String tone = requestJson.has("tone") ? 
                requestJson.get("tone").getAsString() : "warm";
            String customMessage = requestJson.has("customMessage") ? 
                requestJson.get("customMessage").getAsString().trim() : "";
            String length = requestJson.has("length") ? 
                requestJson.get("length").getAsString() : "trungbinh";
            
            // Step 1: Generate text
            String generatedMessage = contentService.generateGreeting(
                recipient, occasion, tone, customMessage, length
            );
            
            // Step 2: Build card state
            AICardState cardState = new AICardState.Builder()
                .recipient(recipient)
                .occasion(occasion)
                .tone(tone)
                .customMessage(customMessage)
                .length(length)
                .generatedMessage(generatedMessage)
                .source("ai-service")
                .build();
            
            // Step 3: Render image
            BufferedImage cardImage = renderService.renderCard(cardState);
            String base64Image = renderService.imageToBase64(cardImage);
            
            // Step 4: Generate background (non-blocking, fallback to gradient)
            String backgroundUrl = imageService.generateBackgroundImage(
                occasion, tone, generatedMessage
            );
            
            // Save to session
            byte[] imageBytes = renderService.imageToBytes(cardImage);
            HttpSession session = request.getSession();
            session.setAttribute("greetingCardImage", imageBytes);
            session.setAttribute("aiCardState", cardState);
            
            // Response
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("message", generatedMessage);
            result.addProperty("imageData", base64Image);
            result.addProperty("backgroundImageUrl", backgroundUrl);
            result.addProperty("width", cardImage.getWidth());
            result.addProperty("height", cardImage.getHeight());
            
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(gson.toJson(result));
            
        } catch (Exception e) {
            System.err.println("❌ Error in complete generation: " + e.getMessage());
            sendJsonError(response, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        out.flush();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!ensureAuthenticated(request, response)) {
            return;
        }

        String servletPath = request.getServletPath();
        
        if ("/api/download-card".equals(servletPath)) {
            handleDownloadCard(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Download card image as PNG file
     */
    private void handleDownloadCard(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        byte[] imageBytes = (byte[]) session.getAttribute("greetingCardImage");
        
        if (imageBytes == null || imageBytes.length == 0) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No card image found");
            return;
        }
        
        // Set download headers
        response.setContentType("image/png");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"thiep-" + System.currentTimeMillis() + ".png\"");
        response.setContentLength(imageBytes.length);
        
        // Write image to response
        OutputStream os = response.getOutputStream();
        os.write(imageBytes);
        os.flush();
        os.close();
        
        System.out.println("✓ Card image downloaded");
    }
    
    /**
     * Helper: Parse JSON from request body
     */
    private JsonObject parseJsonRequest(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        
        String requestBody = sb.toString();
        if (requestBody.isEmpty()) {
            throw new IllegalArgumentException("Request body is empty");
        }
        
        return gson.fromJson(requestBody, JsonObject.class);
    }
    
    /**
     * Helper: Send JSON error response
     */
    private void sendJsonError(HttpServletResponse response, String errorMessage, int statusCode) 
            throws IOException {
        
        response.setStatus(statusCode);
        response.setContentType("application/json;charset=UTF-8");
        
        JsonObject errorJson = new JsonObject();
        errorJson.addProperty("success", false);
        errorJson.addProperty("error", errorMessage);
        
        response.getWriter().print(gson.toJson(errorJson));
        response.getWriter().flush();
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        setCorsForSameOrigin(request, response);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, X-CSRF-Token");
        response.setStatus(HttpServletResponse.SC_OK);
    }
    
    /**
     * Ensure user is authenticated
     */
    private boolean ensureAuthenticated(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            
            JsonObject errorJson = new JsonObject();
            errorJson.addProperty("success", false);
            errorJson.addProperty("error", "Authentication required");
            
            response.getWriter().write(gson.toJson(errorJson));
            return false;
        }
        return true;
    }
    
    /**
     * Set CORS headers for same-origin requests
     */
    private void setCorsForSameOrigin(HttpServletRequest request, HttpServletResponse response) {
        String origin = request.getHeader("Origin");
        if (origin != null && (origin.contains(request.getServerName()) || 
            origin.contains("localhost") || origin.contains("127.0.0.1"))) {
            response.setHeader("Access-Control-Allow-Origin", origin);
            response.setHeader("Access-Control-Allow-Credentials", "true");
        }
    }
}
