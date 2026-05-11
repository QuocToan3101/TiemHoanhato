package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dto.shipping.ShippingQuoteResponse;
import service.ShippingService;
import util.AppConfig;
import util.GhtkClient;
import util.NominatimClient;
import util.RedisCache;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Set;

@WebServlet(name = "ShippingApiServlet", urlPatterns = {"/api/shipping/calculate"})
public class ShippingApiServlet extends HttpServlet {
    private final Gson gson = new Gson();
    private ShippingService shippingService;
    private Set<String> allowedOrigins;

    @Override
    public void init() throws ServletException {
        super.init();
        AppConfig config = AppConfig.getInstance();

        String storeLat = config.getProperty("store.latitude", "0");
        String storeLng = config.getProperty("store.longitude", "0");
        String ghtkBase = config.getProperty("ghtk.base_url", "https://api.ghtk.vn");
        String ghtkToken = config.getProperty("ghtk.token", "");
        String ghtkClientSource = config.getProperty("ghtk.client_source", "");
        String userAgent = config.getProperty("nominatim.user_agent", "FlowerStore/1.0");
        String nominatimBase = config.getProperty("nominatim.base_url", "https://nominatim.openstreetmap.org");

        String redisHost = firstNonBlank(config.getProperty("redis.host"), System.getenv("REDIS_HOST"));
        int redisPort = config.getIntProperty("redis.port", 6379);
        RedisCache redis = null;
        if (redisHost != null && !redisHost.isBlank()) {
            redis = new RedisCache(redisHost, redisPort, config.getIntProperty("shipping.cache.ttl_minutes", 30) * 60);
        }

        shippingService = new ShippingService(
                storeLat,
                storeLng,
            new GhtkClient(ghtkBase, ghtkToken, ghtkClientSource),
                new NominatimClient(userAgent, nominatimBase),
                redis
        );

        allowedOrigins = Set.of(splitCsv(config.getProperty("shipping.allowed_origins", "")));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        if (!isAllowedOrigin(req)) {
            resp.setStatus(403);
            resp.getWriter().write(errorJson("Invalid request origin"));
            return;
        }

        if (!"XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))) {
            resp.setStatus(400);
            resp.getWriter().write(errorJson("Missing AJAX header"));
            return;
        }

        JsonObject body;
        try {
            body = JsonParser.parseReader(req.getReader()).getAsJsonObject();
        } catch (Exception e) {
            resp.setStatus(400);
            resp.getWriter().write(errorJson("Invalid JSON"));
            return;
        }

        String placeId = getString(body, "place_id");
        String formattedAddress = getString(body, "formatted_address");
        String displayName = getString(body, "display_name");
        double lat = getDouble(body, "lat");
        double lng = getDouble(body, "lng");
        BigDecimal orderAmount = getBigDecimal(body, "order_amount", BigDecimal.ZERO);

        if (placeId == null || placeId.isBlank()) {
            resp.setStatus(422);
            resp.getWriter().write(errorJson("Vui lòng chọn địa chỉ từ danh sách gợi ý."));
            return;
        }

        if (!isValidCoordinate(lat, lng)) {
            resp.setStatus(422);
            resp.getWriter().write(errorJson("Tọa độ không hợp lệ."));
            return;
        }

        try {
            ShippingQuoteResponse quote = shippingService.calculate(
                    placeId,
                    displayName != null && !displayName.isBlank() ? displayName : formattedAddress,
                    lat,
                    lng,
                    orderAmount
            );

            if (!quote.isDeliverable()) {
                resp.setStatus(422);
                resp.getWriter().write(errorJson(quote.getMessage()));
                return;
            }

            JsonObject response = new JsonObject();
            response.addProperty("deliverable", quote.isDeliverable());
            response.addProperty("distance_km", quote.getDistanceKm());
            response.addProperty("eta_minutes", quote.getEtaMinutes());
            response.addProperty("display_fee", quote.getDisplayFee() == null ? 0 : quote.getDisplayFee().doubleValue());
            response.addProperty("estimated_fee", quote.getEstimatedFee() == null ? 0 : quote.getEstimatedFee().doubleValue());
            response.addProperty("ghtk_fee", quote.getGhtkFee() == null ? 0 : quote.getGhtkFee().doubleValue());
            response.addProperty("free_shipping", quote.isFreeShipping());
            response.addProperty("message", quote.getMessage() == null ? "" : quote.getMessage());
            resp.getWriter().write(gson.toJson(response));
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write(errorJson("Server error"));
        }
    }

    private boolean isAllowedOrigin(HttpServletRequest req) {
        String origin = req.getHeader("Origin");
        String referer = req.getHeader("Referer");
        if ((origin == null || origin.isBlank()) && (referer == null || referer.isBlank())) {
            return false;
        }
        if (allowedOrigins == null || allowedOrigins.isEmpty() || allowedOrigins.contains("")) {
            return true;
        }
        String candidate = origin != null && !origin.isBlank() ? origin : referer;
        if (candidate == null) {
            return false;
        }
        for (String allowed : allowedOrigins) {
            if (!allowed.isBlank() && candidate.contains(allowed)) {
                return true;
            }
        }
        return false;
    }

    private boolean isValidCoordinate(double lat, double lng) {
        return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
    }

    private String[] splitCsv(String raw) {
        if (raw == null || raw.isBlank()) {
            return new String[]{""};
        }
        return raw.split(",");
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value.trim();
            }
        }
        return null;
    }

    private String getString(JsonObject body, String key) {
        return body != null && body.has(key) && !body.get(key).isJsonNull() ? body.get(key).getAsString() : null;
    }

    private double getDouble(JsonObject body, String key) {
        return body != null && body.has(key) && !body.get(key).isJsonNull() ? body.get(key).getAsDouble() : 0d;
    }

    private BigDecimal getBigDecimal(JsonObject body, String key, BigDecimal defaultValue) {
        try {
            return body != null && body.has(key) && !body.get(key).isJsonNull()
                    ? body.get(key).getAsBigDecimal()
                    : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private String errorJson(String message) {
        JsonObject response = new JsonObject();
        response.addProperty("error", message == null ? "Unknown error" : message);
        return gson.toJson(response);
    }
}
