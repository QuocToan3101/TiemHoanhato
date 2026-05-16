package controller;

import com.google.gson.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import util.MockGhtkClient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Optional;

/**
 * Mock GHTK API Servlet for local development and testing.
 * Simulates: https://api.ghtk.vn/services/shipment/fee
 * 
 * Usage:
 *   GET /api/mock-ghtk/services/shipment/fee?pick_province=...&district=...&weight=...
 */
@WebServlet(name = "MockGhtkApiServlet", urlPatterns = {"/api/mock-ghtk/services/shipment/fee"})
public class MockGhtkApiServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(MockGhtkApiServlet.class);
    private MockGhtkClient mockClient;

    @Override
    public void init() throws ServletException {
        super.init();
        mockClient = new MockGhtkClient();
        logger.info("Mock GHTK API initialized - Ready for local testing");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        try {
            String queryString = req.getQueryString();
            logger.info("[Mock GHTK] Received request: {}", queryString);

            // Calculate mock fee
            Optional<BigDecimal> feeOpt = mockClient.calculateFee(queryString);

            if (feeOpt.isPresent()) {
                BigDecimal fee = feeOpt.get();
                
                // Return JSON response matching real GHTK format
                JsonObject response = new JsonObject();
                response.addProperty("success", true);
                response.addProperty("message", "[Mock] Success");
                response.addProperty("fee", fee.doubleValue());
                response.addProperty("source", "mock_local_api");

                resp.setStatus(200);
                resp.getWriter().write(response.toString());
                logger.info("[Mock GHTK] Responded with fee: {}", fee);
            } else {
                // Error response
                JsonObject error = new JsonObject();
                error.addProperty("success", false);
                error.addProperty("message", "[Mock] Failed to calculate fee");
                error.addProperty("source", "mock_local_api");

                resp.setStatus(400);
                resp.getWriter().write(error.toString());
                logger.warn("[Mock GHTK] Failed to calculate fee");
            }
        } catch (Exception e) {
            logger.error("[Mock GHTK] Exception occurred", e);
            resp.setStatus(500);
            
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("message", "Server error: " + e.getMessage());
            error.addProperty("source", "mock_local_api");
            
            resp.getWriter().write(error.toString());
        }
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type, Token");
        resp.setStatus(200);
    }
}
