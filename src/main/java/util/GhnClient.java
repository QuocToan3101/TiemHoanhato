package util;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import dto.shipping.AddressSuggestion;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * GHN client for shipping fee estimation via /v2/shipping-order/fee endpoint.
 * Flow:
 * 1. Get shop info to retrieve from_district_id
 * 2. Resolve destination (to_district_id and to_ward_code)
 * 3. Get available services for route
 * 4. Calculate fee using first available service
 */
public class GhnClient {
    private static final Logger logger = LoggerFactory.getLogger(GhnClient.class);
    private static final String DEFAULT_TO_PHONE = "0900000000";

    private final Gson gson = new Gson();
    private final String baseUrl;
    private final String token;
    private final String shopId;
    private final String clientSource;
    private final String pickProvince;
    private final String pickDistrict;
    private final String pickAddress;
    private final int shipmentWeightGrams;
    private final int shipmentValueVnd;
    private final int shipmentLengthCm;
    private final int shipmentWidthCm;
    private final int shipmentHeightCm;
    private final int serviceTypeId;
    private volatile String lastErrorMessage;

    private volatile List<ProvinceEntry> provinceCache;
    private final ConcurrentHashMap<Integer, List<DistrictEntry>> districtCache = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<Integer, List<WardEntry>> wardCache = new ConcurrentHashMap<>();

    public GhnClient(String baseUrl,
                     String token,
                     String shopId,
                     String clientSource,
                     String pickProvince,
                     String pickDistrict,
                     String pickAddress,
                     int shipmentWeightGrams,
                     int shipmentValueVnd,
                     int shipmentLengthCm,
                     int shipmentWidthCm,
                     int shipmentHeightCm,
                     int serviceTypeId) {
        this.baseUrl = baseUrl;
        this.token = token;
        this.shopId = shopId;
        this.clientSource = clientSource;
        this.pickProvince = pickProvince;
        this.pickDistrict = pickDistrict;
        this.pickAddress = pickAddress;
        this.shipmentWeightGrams = shipmentWeightGrams;
        this.shipmentValueVnd = shipmentValueVnd;
        this.shipmentLengthCm = shipmentLengthCm;
        this.shipmentWidthCm = shipmentWidthCm;
        this.shipmentHeightCm = shipmentHeightCm;
        this.serviceTypeId = serviceTypeId;
    }

    public Optional<BigDecimal> calculateFee(AddressSuggestion suggestion, String fallbackAddress) {
        lastErrorMessage = null;
        if (suggestion == null) {
            return Optional.empty();
        }

        try {
            // Step 1: Get shop info to retrieve from_district_id
            Integer fromDistrictId = getShopDistrict();
            if (fromDistrictId == null) {
                lastErrorMessage = "Không lấy được thông tin shop GHN (from_district)";
                logger.warn("Unable to get GHN shop info");
                return Optional.empty();
            }

            // Step 2: Resolve destination (to_district_id and to_ward_code)
            ResolvedLocation destination = resolveDestination(suggestion, fallbackAddress, true);
            if (destination == null) {
                lastErrorMessage = "Không ánh xạ được địa chỉ sang mã tỉnh/quận/phường GHN";
                logger.warn("Unable to resolve GHN destination for {}", suggestion.getDisplayName());
                return Optional.empty();
            }

            // Step 3: Get available services
            List<ServiceEntry> services = getAvailableServices(fromDistrictId, destination.districtId());
            if (services == null || services.isEmpty()) {
                lastErrorMessage = "Không có dịch vụ GHN khả dụng cho tuyến đường này";
                logger.warn("No GHN services available from {} to {}", fromDistrictId, destination.districtId());
                return Optional.empty();
            }

            // Step 4: Calculate fee using first available service
            ServiceEntry service = services.get(0);
            Optional<BigDecimal> fee = calculateFeeWithService(
                fromDistrictId,
                destination.districtId(),
                destination.wardCode(),
                service.serviceId()
            );

            if (fee.isPresent()) {
                return fee;
            }

            lastErrorMessage = "Không lấy được phí GHN";
            logger.warn("GHN fee calculation returned empty for service {}", service.serviceId());
            return Optional.empty();

        } catch (Exception e) {
            lastErrorMessage = e.getMessage();
            logger.warn("GHN fee request failed", e);
            return Optional.empty();
        }
    }

    public String getLastErrorMessage() {
        return lastErrorMessage;
    }

    // Step 1: Get shop info to retrieve from_district_id
    private Integer getShopDistrict() {
        HttpURLConnection conn = null;
        try {
            String urlString = joinUrl(baseUrl, "/shiip/public-api/v2/shop/all");
            URL url = new URL(urlString);
            conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(8000);
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Token", token);
            if (clientSource != null && !clientSource.isBlank()) {
                conn.setRequestProperty("X-Client-Source", clientSource);
            }

            int status = conn.getResponseCode();
            String responseBody = readBody(conn, status);

            if (status >= 200 && status < 300) {
                JsonObject response = gson.fromJson(responseBody, JsonObject.class);
                if (response != null && response.has("data") && !response.get("data").isJsonNull()) {
                    JsonObject data = response.getAsJsonObject("data");
                    if (data.has("shops") && data.get("shops").isJsonArray()) {
                        JsonArray shops = data.getAsJsonArray("shops");
                        if (shops.size() > 0) {
                            JsonObject shop = shops.get(0).getAsJsonObject();
                            if (shop.has("district_id")) {
                                return shop.get("district_id").getAsInt();
                            }
                        }
                    }
                }
            }
            lastErrorMessage = "GHN shop info not found";
            logger.warn("Failed to get GHN shop district: status={} response={}", status, responseBody);
        } catch (Exception e) {
            lastErrorMessage = e.getMessage();
            logger.warn("GHN shop info request failed", e);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
        return null;
    }

    // Step 3: Get available services between two districts
    private List<ServiceEntry> getAvailableServices(int fromDistrictId, int toDistrictId) {
        HttpURLConnection conn = null;
        try {
            String urlString = joinUrl(baseUrl, "/shiip/public-api/v2/shipping-order/available-services");
            URL url = new URL(urlString);
            conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(8000);
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Token", token);
            conn.setRequestProperty("ShopId", shopId);
            if (clientSource != null && !clientSource.isBlank()) {
                conn.setRequestProperty("X-Client-Source", clientSource);
            }

            JsonObject payload = new JsonObject();
            payload.addProperty("shop_id", Long.parseLong(shopId));
            payload.addProperty("from_district", fromDistrictId);
            payload.addProperty("to_district", toDistrictId);

            byte[] body = payload.toString().getBytes(StandardCharsets.UTF_8);
            conn.getOutputStream().write(body);

            int status = conn.getResponseCode();
            String responseBody = readBody(conn, status);

            if (status >= 200 && status < 300) {
                JsonObject response = gson.fromJson(responseBody, JsonObject.class);
                if (response != null && response.has("data") && response.get("data").isJsonArray()) {
                    JsonArray dataArray = response.getAsJsonArray("data");
                    List<ServiceEntry> services = new ArrayList<>();
                    for (JsonElement element : dataArray) {
                        JsonObject service = element.getAsJsonObject();
                        if (service.has("service_id") && service.has("short_name")) {
                            services.add(new ServiceEntry(
                                service.get("service_id").getAsInt(),
                                service.get("short_name").getAsString()
                            ));
                        }
                    }
                    return services;
                }
            }
            lastErrorMessage = extractErrorMessage(responseBody);
            logger.warn("Failed to get GHN available services: status={} response={}", status, responseBody);
        } catch (Exception e) {
            lastErrorMessage = e.getMessage();
            logger.warn("GHN available services request failed", e);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
        return null;
    }

    // Step 4: Calculate fee using v2/shipping-order/fee endpoint
    private Optional<BigDecimal> calculateFeeWithService(int fromDistrictId, int toDistrictId, String toWardCode, int serviceId) {
        HttpURLConnection conn = null;
        try {
            String urlString = joinUrl(baseUrl, "/shiip/public-api/v2/shipping-order/fee");
            URL url = new URL(urlString);
            conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(8000);
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Token", token);
            conn.setRequestProperty("ShopId", shopId);
            if (clientSource != null && !clientSource.isBlank()) {
                conn.setRequestProperty("X-Client-Source", clientSource);
            }

            JsonObject payload = new JsonObject();
            payload.addProperty("service_id", serviceId);
            payload.addProperty("from_district_id", fromDistrictId);
            payload.addProperty("to_district_id", toDistrictId);
            payload.addProperty("to_ward_code", toWardCode);
            payload.addProperty("weight", shipmentWeightGrams);
            payload.addProperty("length", shipmentLengthCm);
            payload.addProperty("width", shipmentWidthCm);
            payload.addProperty("height", shipmentHeightCm);
            payload.addProperty("insurance_value", shipmentValueVnd);
            payload.addProperty("cod_value", 0);
            payload.addProperty("cod_failed_amount", 0);
            payload.addProperty("coupon", "");

            byte[] body = payload.toString().getBytes(StandardCharsets.UTF_8);
            conn.getOutputStream().write(body);

            int status = conn.getResponseCode();
            String responseBody = readBody(conn, status);

            if (status >= 200 && status < 300) {
                JsonObject response = gson.fromJson(responseBody, JsonObject.class);
                if (response != null && response.has("data") && !response.get("data").isJsonNull()) {
                    JsonObject data = response.getAsJsonObject("data");
                    if (data.has("total") && !data.get("total").isJsonNull()) {
                        return Optional.of(new BigDecimal(data.get("total").getAsString()));
                    }
                }
            }
            lastErrorMessage = extractErrorMessage(responseBody);
            logger.warn("Failed to calculate GHN fee: status={} response={}", status, responseBody);
        } catch (Exception e) {
            lastErrorMessage = e.getMessage();
            logger.warn("GHN fee calculation request failed", e);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
        return Optional.empty();
    }

    private JsonObject buildPreviewPayload(AddressSuggestion suggestion, String fallbackAddress, ResolvedLocation destination) {
        JsonObject body = new JsonObject();
        body.addProperty("payment_type_id", 2);
        body.addProperty("required_note", "KHONGCHOXEMHANG");
        body.addProperty("to_name", firstNonBlank(suggestion.getDisplayName(), fallbackAddress, "Khách hàng"));
        body.addProperty("to_phone", DEFAULT_TO_PHONE);
        body.addProperty("to_address", firstNonBlank(fallbackAddress, suggestion.getDisplayName(), pickAddress));
        body.addProperty("to_ward_code", destination.wardCode());
        body.addProperty("to_district_id", destination.districtId());
        body.addProperty("weight", shipmentWeightGrams);
        body.addProperty("length", shipmentLengthCm);
        body.addProperty("width", shipmentWidthCm);
        body.addProperty("height", shipmentHeightCm);
        body.addProperty("insurance_value", shipmentValueVnd);
        body.addProperty("service_type_id", serviceTypeId);
        body.addProperty("content", firstNonBlank(suggestion.getStreet(), suggestion.getDisplayName(), "Hoa tươi"));
        body.addProperty("coupon", "");
        return body;
    }

    private ResolvedLocation resolveDestination(AddressSuggestion suggestion, String fallbackAddress, boolean preferExactWard) {
        String provinceHint = firstNonBlank(suggestion.getProvince(), suggestion.getDisplayName(), fallbackAddress, pickProvince);
        String districtHint = firstNonBlank(suggestion.getDistrict(), suggestion.getDisplayName(), fallbackAddress, pickDistrict);
        String wardHint = firstNonBlank(suggestion.getWard(), suggestion.getDisplayName(), fallbackAddress);

        ProvinceEntry province = findProvince(provinceHint);
        if (province == null) {
            province = findProvince(pickProvince);
        }
        if (province == null) {
            return null;
        }

        DistrictEntry district = findDistrict(province.provinceId(), districtHint);
        if (district == null) {
            district = findDistrict(province.provinceId(), pickDistrict);
        }
        if (district == null) {
            return null;
        }

        WardEntry ward = findWard(district.districtId(), wardHint);
        if (ward == null && preferExactWard) {
            ward = firstWard(district.districtId());
        }
        if (ward == null) {
            return null;
        }

        return new ResolvedLocation(district.districtId(), ward.wardCode());
    }

    private ProvinceEntry findProvince(String hint) {
        if (hint == null || hint.isBlank()) {
            return null;
        }
        for (ProvinceEntry province : loadProvinces()) {
            if (matches(hint, province.provinceName())) {
                return province;
            }
        }
        return null;
    }

    private DistrictEntry findDistrict(int provinceId, String hint) {
        if (hint == null || hint.isBlank()) {
            return null;
        }
        for (DistrictEntry district : loadDistricts(provinceId)) {
            if (matches(hint, district.districtName())) {
                return district;
            }
        }
        return null;
    }

    private WardEntry findWard(int districtId, String hint) {
        if (hint == null || hint.isBlank()) {
            return null;
        }
        for (WardEntry ward : loadWards(districtId)) {
            if (matches(hint, ward.wardName())) {
                return ward;
            }
        }
        return null;
    }

    private WardEntry firstWard(int districtId) {
        List<WardEntry> wards = loadWards(districtId);
        return wards.isEmpty() ? null : wards.get(0);
    }

    private List<ProvinceEntry> loadProvinces() {
        if (provinceCache != null && !provinceCache.isEmpty()) {
            return provinceCache;
        }
        synchronized (this) {
            if (provinceCache != null && !provinceCache.isEmpty()) {
                return provinceCache;
            }
            JsonArray data = fetchArray("/shiip/public-api/master-data/province", null);
            List<ProvinceEntry> provinces = new ArrayList<>();
            if (data != null) {
                for (JsonElement element : data) {
                    JsonObject object = element.getAsJsonObject();
                    provinces.add(new ProvinceEntry(getInt(object, "ProvinceID"), getString(object, "ProvinceName")));
                }
            }
            provinceCache = provinces;
            return provinces;
        }
    }

    private List<DistrictEntry> loadDistricts(int provinceId) {
        return districtCache.computeIfAbsent(provinceId, id -> {
            JsonObject query = new JsonObject();
            query.addProperty("province_id", id);
            JsonArray data = fetchArray("/shiip/public-api/master-data/district", query);
            List<DistrictEntry> districts = new ArrayList<>();
            if (data != null) {
                for (JsonElement element : data) {
                    JsonObject object = element.getAsJsonObject();
                    districts.add(new DistrictEntry(getInt(object, "DistrictID"), getString(object, "DistrictName")));
                }
            }
            return districts;
        });
    }

    private List<WardEntry> loadWards(int districtId) {
        return wardCache.computeIfAbsent(districtId, id -> {
            JsonObject query = new JsonObject();
            query.addProperty("district_id", id);
            JsonArray data = fetchArray("/shiip/public-api/master-data/ward", query);
            List<WardEntry> wards = new ArrayList<>();
            if (data != null) {
                for (JsonElement element : data) {
                    JsonObject object = element.getAsJsonObject();
                    wards.add(new WardEntry(getString(object, "WardCode"), getString(object, "WardName")));
                }
            }
            return wards;
        });
    }

    private JsonArray fetchArray(String path, JsonObject body) {
        HttpURLConnection conn = null;
        try {
            String urlString = joinUrl(baseUrl, path);
            conn = (HttpURLConnection) new URL(urlString).openConnection();
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(8000);
            if (body != null && body.size() > 0) {
                conn.setRequestMethod("POST");
                conn.setDoOutput(true);
            } else {
                conn.setRequestMethod("GET");
            }
            conn.setRequestProperty("Token", token);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            if (body != null && body.size() > 0) {
                try (java.io.OutputStream os = conn.getOutputStream()) {
                    os.write(body.toString().getBytes(StandardCharsets.UTF_8));
                }
            }

            int status = conn.getResponseCode();
            String responseBody = readBody(conn, status);
            if (status < 200 || status >= 300) {
                lastErrorMessage = extractErrorMessage(responseBody);
                logger.warn("GHN master-data request failed status={} response={}", status, responseBody);
                return null;
            }

            JsonObject response = gson.fromJson(responseBody, JsonObject.class);
            if (response == null || !response.has("data") || response.get("data").isJsonNull()) {
                return null;
            }
            JsonElement data = response.get("data");
            return data.isJsonArray() ? data.getAsJsonArray() : null;
        } catch (Exception e) {
            lastErrorMessage = e.getMessage();
            logger.warn("GHN master-data request failed for {}", path, e);
            return null;
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private String readBody(HttpURLConnection conn, int status) throws Exception {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(
                status >= 200 && status < 300 ? conn.getInputStream() : conn.getErrorStream(),
                StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
        }
    }

    private BigDecimal extractFee(String responseBody) {
        if (responseBody == null || responseBody.isBlank()) {
            return null;
        }
        try {
            JsonObject response = gson.fromJson(responseBody, JsonObject.class);
            if (response == null || !response.has("data") || response.get("data").isJsonNull()) {
                return null;
            }
            JsonObject data = response.getAsJsonObject("data");
            if (data.has("total_fee") && !data.get("total_fee").isJsonNull()) {
                return new BigDecimal(data.get("total_fee").getAsString());
            }
            if (data.has("fee") && data.get("fee").isJsonObject()) {
                JsonObject fee = data.getAsJsonObject("fee");
                BigDecimal total = BigDecimal.ZERO;
                for (String key : fee.keySet()) {
                    JsonElement value = fee.get(key);
                    if (value != null && !value.isJsonNull()) {
                        total = total.add(new BigDecimal(value.getAsString()));
                    }
                }
                return total;
            }
            return null;
        } catch (Exception e) {
            logger.warn("Unable to parse GHN fee response", e);
            return null;
        }
    }

    private String extractErrorMessage(String responseBody) {
        if (responseBody == null || responseBody.isBlank()) {
            return null;
        }
        try {
            JsonObject response = gson.fromJson(responseBody, JsonObject.class);
            if (response != null && response.has("message") && !response.get("message").isJsonNull()) {
                return response.get("message").getAsString();
            }
        } catch (Exception ignored) {
        }
        return responseBody.length() > 200 ? responseBody.substring(0, 200) : responseBody;
    }

    private boolean matches(String hint, String candidate) {
        if (hint == null || candidate == null) {
            return false;
        }
        String normalizedHint = normalize(hint);
        String normalizedCandidate = normalize(candidate);
        return normalizedCandidate.equals(normalizedHint)
                || normalizedCandidate.contains(normalizedHint)
                || normalizedHint.contains(normalizedCandidate);
    }

    private String normalize(String value) {
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toLowerCase();
        return normalized.replaceAll("[^a-z0-9 ]", " ").replaceAll("\\s+", " ").trim();
    }

    private String joinUrl(String base, String path) {
        String cleanBase = base.endsWith("/") ? base.substring(0, base.length() - 1) : base;
        String cleanPath = path.startsWith("/") ? path : "/" + path;
        return cleanBase + cleanPath;
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

    private String getString(JsonObject object, String key) {
        return object != null && object.has(key) && !object.get(key).isJsonNull() ? object.get(key).getAsString() : null;
    }

    private int getInt(JsonObject object, String key) {
        try {
            return object != null && object.has(key) && !object.get(key).isJsonNull() ? object.get(key).getAsInt() : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private record ResolvedLocation(int districtId, String wardCode) {}
    private record ProvinceEntry(int provinceId, String provinceName) {}
    private record DistrictEntry(int districtId, String districtName) {}
    private record WardEntry(String wardCode, String wardName) {}
    private record ServiceEntry(int serviceId, String shortName) {}
}