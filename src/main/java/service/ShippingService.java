package service;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.google.gson.Gson;
import dao.DeliveryHistoryDAO;
import dao.DeliveryZoneDAO;
import dao.ShippingFeeRuleDAO;
import dto.shipping.AddressSuggestion;
import dto.shipping.AddressValidationResult;
import dto.shipping.ShippingQuoteResponse;
import model.DeliveryZone;
import model.ShippingFeeRule;
import util.AppConfig;
import util.GeoUtils;
import util.GhnClient;
import util.NominatimClient;
import util.RedisCache;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * Production-oriented shipping service:
 * - validates address with Nominatim
 * - caches route result by place_id
 * - estimates GHN fee server-side
 * - falls back to internal free-shipping-friendly fee rules
 */
public class ShippingService {
    private final AppConfig config = AppConfig.getInstance();
     private final GhnClient ghnClient;
    private final NominatimClient nominatimClient;
    private final RedisCache redisCache;
    private final Gson gson = new Gson();
    private final Cache<String, ShippingQuoteResponse> localCache;
    private final double storeLat;
    private final double storeLng;
    private final double maxRadiusKm;
    private final double avgSpeedKmh;
    private final boolean freeShippingEnabled;
    private final boolean requireCarrierFee;
    private final BigDecimal defaultBaseFee;
    private final BigDecimal defaultPerKmFee;
    private final BigDecimal defaultFreeThreshold;
    private final BigDecimal defaultPeakSurcharge;
    private final BigDecimal defaultHolidaySurcharge;
    private final Set<String> holidayDates;
    public ShippingService(String storeLatStr, String storeLngStr, GhnClient ghnClient, NominatimClient nominatimClient, RedisCache redisCache) {
        this.storeLat = parseDouble(storeLatStr, 0d);
        this.storeLng = parseDouble(storeLngStr, 0d);
        this.ghnClient = ghnClient;
        this.nominatimClient = nominatimClient;
        this.redisCache = redisCache;
        this.maxRadiusKm = config.getDoubleProperty("shipping.max_radius_km", 25d);
        this.avgSpeedKmh = config.getDoubleProperty("shipping.avg_speed_kmh", 28d);
        this.freeShippingEnabled = config.getBooleanProperty("shipping.free_enabled", true);
        this.requireCarrierFee = config.getBooleanProperty("shipping.require_carrier_fee", true);
        this.defaultBaseFee = new BigDecimal(config.getProperty("shipping.base_fee_vnd", "0"));
        this.defaultPerKmFee = new BigDecimal(config.getProperty("shipping.per_km_fee_vnd", "0"));
        this.defaultFreeThreshold = new BigDecimal(config.getProperty("shipping.free_threshold_vnd", "0"));
        this.defaultPeakSurcharge = new BigDecimal(config.getProperty("shipping.peak_surcharge_vnd", "0"));
        this.defaultHolidaySurcharge = new BigDecimal(config.getProperty("shipping.holiday_surcharge_vnd", "0"));
        this.holidayDates = parseHolidayDates(config.getProperty("shipping.holiday_dates", "01-01,04-30,05-01,09-02,12-25"));
        this.localCache = Caffeine.newBuilder()
                .maximumSize(config.getIntProperty("shipping.cache.max_size", 2000))
                .expireAfterWrite(config.getIntProperty("shipping.cache.ttl_minutes", 30), TimeUnit.MINUTES)
                .build();
    }

    public AddressValidationResult validateAddress(String placeId, double lat, double lng) {
        AddressValidationResult result = new AddressValidationResult();
        if (placeId == null || placeId.isBlank()) {
            result.setValid(false);
            result.setMessage("Vui lòng chọn địa chỉ từ danh sách gợi ý.");
            return result;
        }
        if (!isValidLatLng(lat, lng)) {
            result.setValid(false);
            result.setMessage("Tọa độ địa chỉ không hợp lệ.");
            return result;
        }
        try {
            Optional<AddressSuggestion> resolved = nominatimClient.lookupPlaceId(placeId);
            if (resolved.isEmpty()) {
                resolved = nominatimClient.reverse(lat, lng);
            }
            if (resolved.isEmpty()) {
                result.setValid(false);
                result.setMessage("Không xác thực được địa chỉ đã chọn.");
                return result;
            }
            AddressSuggestion suggestion = resolved.get();
            boolean vietnam = nominatimClient.isVietnam(suggestion);
            boolean suspicious = nominatimClient.isSuspicious(suggestion, lat, lng);
            result.setVietnam(vietnam);
            result.setSuspicious(suspicious);
            result.setSuggestion(suggestion);
            result.setValid(vietnam && !suspicious);
            if (!vietnam) {
                result.setMessage("Địa chỉ phải thuộc Việt Nam.");
            } else if (suspicious) {
                result.setMessage("Địa chỉ có dấu hiệu không khớp với vị trí đã chọn.");
            } else {
                result.setMessage("Địa chỉ hợp lệ.");
            }
            return result;
        } catch (Exception e) {
            result.setValid(false);
            result.setMessage("Lỗi xác thực địa chỉ. Vui lòng thử lại.");
            return result;
        }
    }

    public ShippingQuoteResponse calculate(String placeId, String displayName, double lat, double lng, BigDecimal orderAmount) {
        String cacheKey = "shipping:quote:" + placeId;
        ShippingQuoteResponse cached = loadCache(cacheKey);
        if (cached != null) {
            cached.setDisplayFee(resolveDisplayFee(cached.getGhtkFee(), cached.getEstimatedFee()));
            return cached;
        }

        AddressValidationResult validation = validateAddress(placeId, lat, lng);
        ShippingQuoteResponse quote = new ShippingQuoteResponse();
        if (!validation.isValid()) {
            quote.setDeliverable(false);
            quote.setMessage(validation.getMessage());
            quote.setDistanceKm(0d);
            quote.setEtaMinutes(0);
            quote.setFreeShipping(true);
            quote.setDisplayFee(BigDecimal.ZERO);
            return quote;
        }

        double distanceKm = GeoUtils.haversine(storeLat, storeLng, lat, lng);
        quote.setDistanceKm(distanceKm);
        if (distanceKm > maxRadiusKm) {
            quote.setDeliverable(false);
            quote.setMessage("Ngoài phạm vi giao hàng.");
            quote.setFreeShipping(true);
            quote.setDisplayFee(BigDecimal.ZERO);
            return quote;
        }

        DeliveryZone zone = findActiveZoneForDistance(distanceKm);
        if (zone == null) {
            quote.setDeliverable(false);
            quote.setMessage("Không có khu vực giao hàng phù hợp.");
            quote.setFreeShipping(true);
            quote.setDisplayFee(BigDecimal.ZERO);
            return quote;
        }

        ShippingFeeRule rule = loadActiveRule();
        BigDecimal estimatedFee = calculateInternalFee(rule, distanceKm, orderAmount);
        BigDecimal ghnFee = estimateGhnFee(validation.getSuggestion(), displayName).orElse(null);
        String carrierError = ghnClient != null ? ghnClient.getLastErrorMessage() : null;
        boolean invalidCarrierFee = ghnFee == null || ghnFee.compareTo(BigDecimal.ZERO) <= 0;
        boolean hasCarrierError = carrierError != null && !carrierError.isBlank();

        if (!freeShippingEnabled && invalidCarrierFee && (requireCarrierFee || hasCarrierError)) {
            quote.setDeliverable(false);
            quote.setEtaMinutes(Math.max(10, GeoUtils.estimateMinutes(distanceKm, avgSpeedKmh)));
            quote.setFreeShipping(false);
            quote.setDisplayFee(BigDecimal.ZERO);
            quote.setEstimatedFee(estimatedFee);
            quote.setGhtkFee(null);
            quote.setMessage(hasCarrierError
                ? "GHN: " + carrierError
                : "Không lấy được phí GHN. Vui lòng thử lại sau hoặc kiểm tra cấu hình GHN.");
            return quote;
        }

        quote.setEstimatedFee(estimatedFee);
        quote.setGhtkFee(ghnFee);
        quote.setFreeShipping(freeShippingEnabled);
        quote.setDisplayFee(resolveDisplayFee(ghnFee, estimatedFee));
        quote.setEtaMinutes(Math.max(10, GeoUtils.estimateMinutes(distanceKm, avgSpeedKmh)));
        quote.setDeliverable(true);
        if (freeShippingEnabled) {
            quote.setMessage("Miễn phí giao hàng.");
        } else if (ghnFee != null) {
            quote.setMessage("Đã tính phí giao hàng GHN.");
        } else if (carrierError != null && !carrierError.isBlank()) {
            quote.setMessage("GHN: " + carrierError);
        } else {
            quote.setMessage("Đã tính phí giao hàng.");
        }

        saveCache(cacheKey, quote);
        saveHistory(placeId, displayName, lat, lng, quote, validation.isVietnam() ? "vn" : "non_vn", quote.getMessage());
        return quote;
    }

    private Optional<BigDecimal> estimateGhnFee(AddressSuggestion suggestion, String fallbackAddress) {
        try {
            if (ghnClient == null || suggestion == null) {
                return Optional.empty();
            }
            return ghnClient.calculateFee(suggestion, fallbackAddress);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    private BigDecimal calculateInternalFee(ShippingFeeRule rule, double distanceKm, BigDecimal orderAmount) {
        BigDecimal baseFee = firstNonNull(rule.getBaseFee(), defaultBaseFee);
        BigDecimal perKmFee = firstNonNull(rule.getPerKmFee(), defaultPerKmFee);
        BigDecimal fee = baseFee.add(perKmFee.multiply(BigDecimal.valueOf(distanceKm)));
        if (orderAmount != null && rule.getFreeOverAmount() != null && orderAmount.compareTo(rule.getFreeOverAmount()) >= 0) {
            fee = BigDecimal.ZERO;
        }
        if (isPeakHour(rule)) {
            fee = fee.add(firstNonNull(rule.getPeakSurcharge(), defaultPeakSurcharge));
        }
        if (isHoliday()) {
            fee = fee.add(defaultHolidaySurcharge);
        }
        return fee.max(BigDecimal.ZERO);
    }

    private boolean isPeakHour(ShippingFeeRule rule) {
        Integer start = rule.getPeakStartHour();
        Integer end = rule.getPeakEndHour();
        int hour = LocalTime.now().getHour();
        if (start == null || end == null) {
            return false;
        }
        return start <= end ? hour >= start && hour <= end : hour >= start || hour <= end;
    }

    private boolean isHoliday() {
        String today = LocalDate.now().toString().substring(5);
        if (holidayDates.contains(today)) {
            return true;
        }
        DayOfWeek dayOfWeek = LocalDate.now().getDayOfWeek();
        return dayOfWeek == DayOfWeek.SATURDAY || dayOfWeek == DayOfWeek.SUNDAY;
    }

    private boolean isValidLatLng(double lat, double lng) {
        return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
    }

    private ShippingFeeRule buildDefaultRule() {
        ShippingFeeRule rule = new ShippingFeeRule();
        rule.setBaseFee(defaultBaseFee);
        rule.setPerKmFee(defaultPerKmFee);
        rule.setFreeOverAmount(defaultFreeThreshold);
        rule.setPeakSurcharge(defaultPeakSurcharge);
        return rule;
    }

    private DeliveryZone findActiveZoneForDistance(double distanceKm) {
        try {
            DeliveryZoneDAO zoneDAO = new DeliveryZoneDAO();
            DeliveryZone zone = zoneDAO.findActiveZoneForDistance(distanceKm);
            if (zone != null) {
                return zone;
            }
        } catch (Exception ignored) {
        }
        if (distanceKm <= maxRadiusKm) {
            DeliveryZone fallback = new DeliveryZone();
            fallback.setName("Default zone");
            fallback.setMaxKm(maxRadiusKm);
            fallback.setActive(true);
            return fallback;
        }
        return null;
    }

    private ShippingFeeRule loadActiveRule() {
        try {
            ShippingFeeRuleDAO ruleDAO = new ShippingFeeRuleDAO();
            Optional<ShippingFeeRule> rule = ruleDAO.getActiveRule();
            if (rule.isPresent()) {
                return rule.get();
            }
        } catch (Exception ignored) {
        }
        return buildDefaultRule();
    }

    private void saveHistory(String placeId, String displayName, double lat, double lng, ShippingQuoteResponse quote, String addressStatus, String reason) {
        try {
            DeliveryHistoryDAO historyDAO = new DeliveryHistoryDAO();
            historyDAO.insert(placeId, displayName, lat, lng, quote, addressStatus, reason, null, null);
        } catch (Exception ignored) {
        }
    }

    private BigDecimal resolveDisplayFee(BigDecimal ghnFee, BigDecimal estimatedFee) {
        if (freeShippingEnabled) {
            return BigDecimal.ZERO;
        }
        if (requireCarrierFee && ghnFee == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal fallbackFee = firstNonNull(estimatedFee, BigDecimal.ZERO);
        return firstNonNull(ghnFee, fallbackFee);
    }

    private ShippingQuoteResponse loadCache(String key) {
        try {
            ShippingQuoteResponse local = localCache.getIfPresent(key);
            if (local != null) {
                return local;
            }
            if (redisCache != null) {
                String cached = redisCache.get(key);
                if (cached != null) {
                    ShippingQuoteResponse parsed = gson.fromJson(cached, ShippingQuoteResponse.class);
                    if (parsed != null) {
                        localCache.put(key, parsed);
                        return parsed;
                    }
                }
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    private void saveCache(String key, ShippingQuoteResponse quote) {
        try {
            localCache.put(key, quote);
            if (redisCache != null) {
                redisCache.set(key, gson.toJson(quote));
            }
        } catch (Exception ignored) {
        }
    }

    private Set<String> parseHolidayDates(String raw) {
        if (raw == null || raw.isBlank()) {
            return Set.of();
        }
        Set<String> set = new HashSet<>();
        Arrays.stream(raw.split(","))
                .map(String::trim)
                .filter(s -> !s.isBlank())
                .forEach(set::add);
        return set;
    }

    private BigDecimal firstNonNull(BigDecimal primary, BigDecimal fallback) {
        return primary != null ? primary : fallback;
    }

    private double parseDouble(String value, double fallback) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return fallback;
        }
    }

    private String firstNonBlank(String... values) {
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
}
