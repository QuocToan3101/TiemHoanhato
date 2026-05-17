package util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Factory for creating appropriate shipping client (real GHN or Mock)
 */
public class ShippingClientFactory {
    private static final Logger logger = LoggerFactory.getLogger(ShippingClientFactory.class);

    /**
     * Create shipping client based on configuration
     * @param config AppConfig instance
     * @return GhnClient or MockGhtkClient wrapper
     */
    public static GhnClient createShippingClient(AppConfig config) {
        boolean mockEnabled = config.getBooleanProperty("ghn.mock_enabled", config.getBooleanProperty("ghtk.mock_enabled", false));
        
        if (mockEnabled) {
            logger.info("Using MOCK GHN Client for local development/testing");
            return new MockGhtkClientWrapper();
        } else {
            String baseUrl = config.getProperty("ghn.base_url", "https://online-gateway.ghn.vn");
            String token = firstNonBlank(config.getProperty("ghn.token"), System.getenv("GHN_TOKEN"));
            String shopId = firstNonBlank(config.getProperty("ghn.shop_id"), System.getenv("GHN_SHOP_ID"));
            String clientSource = config.getProperty("ghn.client_source", "");
            String pickProvince = config.getProperty("ghn.pick_province", config.getProperty("ghtk.pick_province", "Hồ Chí Minh"));
            String pickDistrict = config.getProperty("ghn.pick_district", config.getProperty("ghtk.pick_district", "Quận 1"));
            String pickAddress = config.getProperty("ghn.pick_address", config.getProperty("ghtk.pick_address", "Tiệm hoa nhà tớ"));
            int shipmentWeightGrams = config.getIntProperty("ghn.shipment_weight_grams", config.getIntProperty("ghtk.shipment_weight_grams", 1000));
            int shipmentValueVnd = config.getIntProperty("ghn.shipment_value_vnd", config.getIntProperty("ghtk.shipment_value_vnd", 100000));
            int shipmentLengthCm = config.getIntProperty("ghn.shipment_length_cm", 15);
            int shipmentWidthCm = config.getIntProperty("ghn.shipment_width_cm", 15);
            int shipmentHeightCm = config.getIntProperty("ghn.shipment_height_cm", 15);
            int serviceTypeId = config.getIntProperty("ghn.service_type_id", 2);

            logger.info("Using REAL GHN Client: {}", baseUrl);
            return new GhnClient(
                    baseUrl,
                    token,
                    shopId,
                    clientSource,
                    pickProvince,
                    pickDistrict,
                    pickAddress,
                    shipmentWeightGrams,
                    shipmentValueVnd,
                    shipmentLengthCm,
                    shipmentWidthCm,
                    shipmentHeightCm,
                    serviceTypeId
            );
        }
    }

    private static String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value.trim();
            }
        }
        return null;
    }

    /**
     * Wrapper to make MockGhtkClient compatible with GhtkClient interface
     */
    static class MockGhtkClientWrapper extends GhnClient {
        private final MockGhtkClient mockClient = new MockGhtkClient();
        private static final Logger logger = LoggerFactory.getLogger(MockGhtkClientWrapper.class);

        public MockGhtkClientWrapper() {
            super("http://localhost:8080/mock", "mock-token", "0", "mock", "Hồ Chí Minh", "Quận 1", "Tiệm hoa nhà tớ", 1000, 100000, 15, 15, 15, 2);
        }

        @Override
        public java.util.Optional<java.math.BigDecimal> calculateFee(dto.shipping.AddressSuggestion suggestion, String fallbackAddress) {
            String mockKey = firstNonBlank(fallbackAddress, suggestion != null ? suggestion.getDisplayName() : null, suggestion != null ? suggestion.getProvince() : null);
            logger.debug("[Mock] Calculating fee with address: {}", mockKey);
            return mockClient.calculateFee(mockKey);
        }
    }
}
