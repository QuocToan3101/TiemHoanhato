package service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.junit.jupiter.api.Test;
import util.AppConfig;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

class GhnApiIntegrationTest {

    private static final String DEFAULT_BASE_URL = "https://online-gateway.ghn.vn";

    @Test
    void provinceMasterDataApiShouldReturnData() throws Exception {
        String token = firstNonBlank(System.getenv("GHN_TOKEN"), AppConfig.getInstance().getProperty("ghn.token"));
        assumeTrue(token != null && !token.isBlank(), "GHN token is required");

        ApiResponse response = request("GET", DEFAULT_BASE_URL + "/shiip/public-api/master-data/province", token, null, null);
        assertEquals(200, response.statusCode);

        JsonObject root = JsonParser.parseString(response.body).getAsJsonObject();
        assertEquals(200, root.get("code").getAsInt());
        assertTrue(root.has("data") && root.get("data").isJsonArray());
        assertTrue(root.getAsJsonArray("data").size() > 0);
    }

    @Test
    void previewFeeApiShouldReturnRealFeeWithValidCredentials() throws Exception {
        AppConfig config = AppConfig.getInstance();
        String token = firstNonBlank(System.getenv("GHN_TOKEN"), config.getProperty("ghn.token"));
        String shopId = firstNonBlank(System.getenv("GHN_SHOP_ID"), config.getProperty("ghn.shop_id"));
        assumeTrue(token != null && !token.isBlank(), "GHN token is required");
        assumeTrue(shopId != null && !shopId.isBlank(), "GHN shop id is required");

        JsonObject payload = new JsonObject();
        payload.addProperty("payment_type_id", 2);
        payload.addProperty("required_note", "KHONGCHOXEMHANG");
        payload.addProperty("to_name", "Integration Test");
        payload.addProperty("to_phone", "0909000001");
        payload.addProperty("to_address", "Nguyen An, Phuong Cat Lai, Thu Duc, Ho Chi Minh City");
        payload.addProperty("to_ward_code", "90747");
        payload.addProperty("to_district_id", 3695);
        payload.addProperty("weight", 1000);
        payload.addProperty("length", 15);
        payload.addProperty("width", 15);
        payload.addProperty("height", 15);
        payload.addProperty("insurance_value", 100000);
        payload.addProperty("service_type_id", 2);
        payload.addProperty("content", "Flower test item");
        payload.addProperty("coupon", "");

        ApiResponse response = request(
                "POST",
                DEFAULT_BASE_URL + "/shiip/public-api/v2/shipping-order/preview",
                token,
                shopId,
                payload.toString()
        );

        JsonObject root = JsonParser.parseString(response.body).getAsJsonObject();
        assertNotNull(root);

        int code = root.has("code") && !root.get("code").isJsonNull() ? root.get("code").getAsInt() : response.statusCode;
        assertEquals(200, code, "GHN preview API did not return success. Body: " + response.body);
        assertTrue(root.has("data") && root.get("data").isJsonObject(), "GHN preview missing data object");

        JsonObject data = root.getAsJsonObject("data");
        assertTrue(data.has("total_fee") || data.has("fee"), "GHN preview missing fee fields. Body: " + response.body);

        if (data.has("total_fee") && !data.get("total_fee").isJsonNull()) {
            String totalFeeRaw = data.get("total_fee").getAsString();
            long totalFee = Long.parseLong(totalFeeRaw.trim());
            assertTrue(totalFee > 0, "GHN total_fee must be > 0");
        }
    }

    private ApiResponse request(String method, String url, String token, String shopId, String payload) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setConnectTimeout(10000);
        conn.setReadTimeout(15000);
        conn.setRequestMethod(method);
        conn.setRequestProperty("Token", token);
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        if (shopId != null && !shopId.isBlank()) {
            conn.setRequestProperty("ShopId", shopId);
        }

        if (payload != null) {
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(payload.getBytes(StandardCharsets.UTF_8));
            }
        }

        int status = conn.getResponseCode();
        InputStream stream = status >= 200 && status < 300 ? conn.getInputStream() : conn.getErrorStream();
        String body = readAll(stream);
        conn.disconnect();
        return new ApiResponse(status, body);
    }

    private String readAll(InputStream stream) throws Exception {
        if (stream == null) {
            return "";
        }
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
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

    private static final class ApiResponse {
        private final int statusCode;
        private final String body;

        private ApiResponse(int statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body == null ? "" : body;
        }
    }
}