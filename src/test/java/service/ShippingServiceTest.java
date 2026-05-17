package service;

import dto.shipping.AddressSuggestion;
import org.junit.jupiter.api.Test;
import util.GhnClient;
import util.NominatimClient;
import util.RedisCache;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ShippingServiceTest {

    @Test
    void calculateShouldReturnFreeShippingQuoteForValidVietnamAddress() {
        GhnClient ghnClient = new GhnClient(
                "https://example.invalid",
                "token",
                "1",
                "partner",
                "Ho Chi Minh",
                "Quan 1",
                "Shop address",
                1000,
                100000,
                15,
                15,
                15,
                2
        ) {
            @Override
            public Optional<BigDecimal> calculateFee(AddressSuggestion suggestion, String fallbackAddress) {
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

        ShippingService service = new ShippingService("10.762622", "106.660172", ghnClient, nominatimClient, (RedisCache) null);
        var quote = service.calculate("place-123", suggestion.getDisplayName(), suggestion.getLat(), suggestion.getLon(), new BigDecimal("100000"));

        assertTrue(quote.isDeliverable());
        assertTrue(quote.getDisplayFee().compareTo(BigDecimal.ZERO) >= 0);
        assertTrue(quote.getEstimatedFee().compareTo(BigDecimal.ZERO) >= 0);
        assertTrue(quote.getDistanceKm() > 0);
    }
}
