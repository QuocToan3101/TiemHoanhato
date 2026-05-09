package util;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dto.shipping.AddressSuggestion;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import okhttp3.HttpUrl;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class NominatimClient {
    private static final Logger logger = LoggerFactory.getLogger(NominatimClient.class);
    private final OkHttpClient client;
    private final Gson gson = new Gson();
    private final String userAgent;
    private final String baseUrl;

    public NominatimClient(String userAgent, String baseUrl) {
        this.userAgent = userAgent == null || userAgent.isBlank() ? "FlowerStore/1.0" : userAgent;
        this.baseUrl = baseUrl == null || baseUrl.isBlank() ? "https://nominatim.openstreetmap.org" : baseUrl;
        this.client = new OkHttpClient.Builder()
                .callTimeout(Duration.ofSeconds(8))
                .connectTimeout(Duration.ofSeconds(3))
                .readTimeout(Duration.ofSeconds(6))
                .build();
    }

    public List<AddressSuggestion> search(String query, int limit) throws IOException {
        HttpUrl url = HttpUrl.parse(baseUrl + "/search").newBuilder()
                .addQueryParameter("q", query)
                .addQueryParameter("format", "jsonv2")
                .addQueryParameter("addressdetails", "1")
                .addQueryParameter("countrycodes", "vn")
                .addQueryParameter("limit", String.valueOf(limit))
                .build();
        Request request = new Request.Builder().url(url).header("User-Agent", userAgent).build();
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful() || response.body() == null) {
                return List.of();
            }
            return parseSuggestions(response.body().string());
        }
    }

    public Optional<AddressSuggestion> lookupPlaceId(String placeId) throws IOException {
        if (placeId == null || placeId.isBlank()) {
            return Optional.empty();
        }
        HttpUrl url = HttpUrl.parse(baseUrl + "/lookup").newBuilder()
                .addQueryParameter("place_ids", placeId)
                .addQueryParameter("format", "jsonv2")
                .addQueryParameter("addressdetails", "1")
                .build();
        Request request = new Request.Builder().url(url).header("User-Agent", userAgent).build();
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful() || response.body() == null) {
                return Optional.empty();
            }
            List<AddressSuggestion> list = parseSuggestions(response.body().string());
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        }
    }

    public Optional<AddressSuggestion> reverse(double lat, double lon) throws IOException {
        HttpUrl url = HttpUrl.parse(baseUrl + "/reverse").newBuilder()
                .addQueryParameter("lat", String.valueOf(lat))
                .addQueryParameter("lon", String.valueOf(lon))
                .addQueryParameter("format", "jsonv2")
                .addQueryParameter("addressdetails", "1")
                .build();
        Request request = new Request.Builder().url(url).header("User-Agent", userAgent).build();
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful() || response.body() == null) {
                return Optional.empty();
            }
            String body = response.body().string();
            JsonObject obj = JsonParser.parseString(body).getAsJsonObject();
            return Optional.of(parseSuggestion(obj));
        }
    }

    public boolean isVietnam(AddressSuggestion suggestion) {
        if (suggestion == null) return false;
        String cc = suggestion.getCountryCode();
        return cc != null && cc.equalsIgnoreCase("vn");
    }

    public boolean isSuspicious(AddressSuggestion suggestion, double submittedLat, double submittedLon) {
        if (suggestion == null) return true;
        double km = GeoUtils.haversine(submittedLat, submittedLon, suggestion.getLat(), suggestion.getLon());
        return km > 2.5; // suspicious if reverse result is far from selected point
    }

    private List<AddressSuggestion> parseSuggestions(String json) {
        List<AddressSuggestion> list = new ArrayList<>();
        JsonElement root = JsonParser.parseString(json);
        if (root.isJsonArray()) {
            JsonArray arr = root.getAsJsonArray();
            for (JsonElement el : arr) {
                if (el.isJsonObject()) {
                    list.add(parseSuggestion(el.getAsJsonObject()));
                }
            }
        }
        return list;
    }

    private AddressSuggestion parseSuggestion(JsonObject obj) {
        AddressSuggestion suggestion = new AddressSuggestion();
        suggestion.setPlaceId(getString(obj, "place_id"));
        suggestion.setDisplayName(getString(obj, "display_name"));
        suggestion.setLat(getDouble(obj, "lat"));
        suggestion.setLon(getDouble(obj, "lon"));
        suggestion.setOsmType(getString(obj, "osm_type"));
        suggestion.setOsmId(getLong(obj, "osm_id"));
        JsonObject address = obj.has("address") && obj.get("address").isJsonObject() ? obj.getAsJsonObject("address") : null;
        if (address != null) {
            suggestion.setCountryCode(getString(address, "country_code"));
        }
        if (suggestion.getCountryCode() == null) {
            suggestion.setCountryCode("vn");
        }
        return suggestion;
    }

    private String getString(JsonObject obj, String key) {
        return obj != null && obj.has(key) && !obj.get(key).isJsonNull() ? obj.get(key).getAsString() : null;
    }

    private double getDouble(JsonObject obj, String key) {
        try { return obj != null && obj.has(key) && !obj.get(key).isJsonNull() ? obj.get(key).getAsDouble() : 0d; }
        catch (Exception e) { return 0d; }
    }

    private long getLong(JsonObject obj, String key) {
        try { return obj != null && obj.has(key) && !obj.get(key).isJsonNull() ? obj.get(key).getAsLong() : 0L; }
        catch (Exception e) { return 0L; }
    }
}
