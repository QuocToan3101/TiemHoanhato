package service;

import dto.shipping.AddressSuggestion;
import org.junit.jupiter.api.Test;
import util.GhtkClient;
import util.NominatimClient;
import util.RedisCache;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ShippingServiceTest {

    @Test
    void calculateShouldReturnFreeShippingQuoteForValidVietnamAddress() {
        GhtkClient ghtkClient = new GhtkClient("https://example.invalid", "token", "partner") {
            @Override
            public Optional<BigDecimal> calculateFee(String payloadJson) {
                return Optional.of(new BigDecimal("42000"));
            }
        };

        AddressSuggestion suggestion = new AddressSuggestion();
        suggestion.setPlaceId("place-123");
        suggestion.setDisplayName("Quận 1, TP. Hồ Chí Minh, Việt Nam");
        suggestion.setLat(10.775); 
        suggestion.setLon(106.700);
        suggestion.setCountryCode("vn");
        suggestion.setProvince("Hồ Chí Minh");
        suggestion.setDistrict("Quận 1");
        suggestion.setWard("Phường Bến Nghé");

        NominatimClient nominatimClient = new NominatimClient("FlowerStore-Test", "https://nominatim.openstreetmap.org") {
            @Override
            public Optional<AddressSuggestion> lookupPlaceId(String placeId) {
                return Optional.of(suggestion);
            }

            @Override
            public Optional<AddressSuggestion> reverse(double lat, double lon) {
                return Optional.of(suggestion);
            }

            @Override
            public boolean isVietnam(AddressSuggestion value) {
                return true;
            }

            @Override
            public boolean isSuspicious(AddressSuggestion value, double submittedLat, double submittedLon) {
                return false;
            }
        };

        ShippingService service = new ShippingService("10.762622", "106.660172", ghtkClient, nominatimClient, (RedisCache) null);
        var quote = service.calculate("place-123", suggestion.getDisplayName(), suggestion.getLat(), suggestion.getLon(), new BigDecimal("100000"));

        assertTrue(quote.isDeliverable());
        assertEquals(0, quote.getDisplayFee().compareTo(BigDecimal.ZERO));
        assertTrue(quote.getEstimatedFee().compareTo(BigDecimal.ZERO) >= 0);
        assertTrue(quote.getDistanceKm() > 0);
    }
}
