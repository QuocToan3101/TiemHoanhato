package util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.Optional;

/**
 * Mock GHTK Client for local testing and development.
 * Simulates GHTK fee calculation without requiring real API credentials.
 */
public class MockGhtkClient {
    private static final Logger logger = LoggerFactory.getLogger(MockGhtkClient.class);

    /**
     * Simulated fee calculation based on distance.
     * Formula: base_fee + (distance * per_km_fee)
     */
    public Optional<BigDecimal> calculateFee(String queryString) {
        try {
            // Parse distance from query string for realistic fee calculation
            double distance = extractDistance(queryString);
            
            // Base fee
            BigDecimal baseFee = new BigDecimal("15000");
            
            // Per km fee
            BigDecimal perKmFee = new BigDecimal("3500");
            
            // Calculate total
            BigDecimal totalFee = baseFee.add(perKmFee.multiply(BigDecimal.valueOf(distance)));
            
            // Simulate occasional delays (but very fast)
            Thread.sleep(50);
            
            logger.info("Mock GHTK fee calculated: {} VND for {:.2f} km", totalFee, distance);
            return Optional.of(totalFee);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return Optional.empty();
        } catch (Exception e) {
            logger.warn("Mock GHTK calculation failed", e);
            return Optional.empty();
        }
    }

    /**
     * Extract distance from address (simplified mock logic)
     * In real world, would calculate from coordinates
     */
    private double extractDistance(String queryString) {
        if (queryString == null) {
            return 5.0; // Default distance
        }
        
        // Try to parse distance from query if provided
        if (queryString.contains("distance=")) {
            try {
                int start = queryString.indexOf("distance=") + 9;
                int end = queryString.indexOf("&", start);
                if (end == -1) end = queryString.length();
                String distStr = queryString.substring(start, end);
                return Double.parseDouble(distStr);
            } catch (Exception e) {
                // Fall through to default
            }
        }
        
        // Simulate different distances based on district
        if (queryString.contains("Qu%E1n%205") || queryString.contains("Quận 5")) {
            return 8.5;
        } else if (queryString.contains("Qu%E1n%207") || queryString.contains("Quận 7")) {
            return 12.3;
        } else if (queryString.contains("Th%E1nh%20ph%E1") || queryString.contains("Thành phố")) {
            return 15.0;
        } else if (queryString.contains("Gò%20Vấp") || queryString.contains("Gò Vấp")) {
            return 6.7;
        } else if (queryString.contains("B%C3%ACnh%20Th%E1nh") || queryString.contains("Bình Thạnh")) {
            return 10.2;
        } else {
            return 5.0; // Default for local districts
        }
    }

    /**
     * Get mock response for testing
     */
    public String getMockResponse(BigDecimal fee) {
        return "{\"success\":true,\"message\":\"[Mock] Success\",\"fee\":" + fee.toPlainString() + "}";
    }
}
