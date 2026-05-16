package util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Factory for creating appropriate shipping client (real GHTK or Mock)
 */
public class ShippingClientFactory {
    private static final Logger logger = LoggerFactory.getLogger(ShippingClientFactory.class);

    /**
     * Create shipping client based on configuration
     * @param config AppConfig instance
     * @return GhtkClient or MockGhtkClient wrapper
     */
    public static GhtkClient createShippingClient(AppConfig config) {
        boolean mockEnabled = config.getBooleanProperty("ghtk.mock_enabled", false);
        
        if (mockEnabled) {
            logger.info("Using MOCK GHTK Client for local development/testing");
            return new MockGhtkClientWrapper();
        } else {
            String baseUrl = config.getProperty("ghtk.base_url", "https://api.ghtk.vn");
            String token = config.getProperty("ghtk.token", "");
            String clientSource = config.getProperty("ghtk.client_source", "");
            
            logger.info("Using REAL GHTK Client: {}", baseUrl);
            return new GhtkClient(baseUrl, token, clientSource);
        }
    }

    /**
     * Wrapper to make MockGhtkClient compatible with GhtkClient interface
     */
    static class MockGhtkClientWrapper extends GhtkClient {
        private final MockGhtkClient mockClient = new MockGhtkClient();
        private static final Logger logger = LoggerFactory.getLogger(MockGhtkClientWrapper.class);

        public MockGhtkClientWrapper() {
            super("http://localhost:8080/mock", "mock-token", "mock");
        }

        @Override
        public java.util.Optional<java.math.BigDecimal> calculateFee(String queryString) {
            logger.debug("[Mock] Calculating fee with query: {}", queryString);
            return mockClient.calculateFee(queryString);
        }
    }
}
