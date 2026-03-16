package payment;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.UUID;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import util.AppConfig;

public class MoMoConfig {

    private final AppConfig config;
    private final Gson gson;

    public MoMoConfig() {
        config = AppConfig.getInstance();
        gson = new Gson();
    }

    /**
     * Tạo URL thanh toán MoMo
     */
    public String createPaymentUrl(String orderId, long amount, String orderInfo) {

        try {

            String partnerCode = config.getMoMoPartnerCode();
            String accessKey = config.getMoMoAccessKey();
            String secretKey = config.getMoMoSecretKey();
            String redirectUrl = config.getMoMoReturnUrl();
            String ipnUrl = config.getMoMoNotifyUrl();

            if (!isValidMoMoConfig(partnerCode, accessKey, secretKey, redirectUrl, ipnUrl)) {
                System.err.println("MoMo config is missing or placeholder. Skip MoMo payment URL generation.");
                return null;
            }

            String requestId = UUID.randomUUID().toString();
            String requestType = "captureWallet";

            String extraData = Base64.getEncoder()
                    .encodeToString("".getBytes(StandardCharsets.UTF_8));

            /**
             * Raw signature đúng format MoMo yêu cầu
             */
            String rawSignature =
                    "accessKey=" + accessKey +
                            "&amount=" + amount +
                            "&extraData=" + extraData +
                            "&ipnUrl=" + ipnUrl +
                            "&orderId=" + orderId +
                            "&orderInfo=" + orderInfo +
                            "&partnerCode=" + partnerCode +
                            "&redirectUrl=" + redirectUrl +
                            "&requestId=" + requestId +
                            "&requestType=" + requestType;

            String signature = hmacSHA256(secretKey, rawSignature);

            JsonObject body = new JsonObject();

            body.addProperty("partnerCode", partnerCode);
            body.addProperty("requestId", requestId);
            body.addProperty("amount", amount);
            body.addProperty("orderId", orderId);
            body.addProperty("orderInfo", orderInfo);
            body.addProperty("redirectUrl", redirectUrl);
            body.addProperty("ipnUrl", ipnUrl);
            body.addProperty("extraData", extraData);
            body.addProperty("requestType", requestType);
            body.addProperty("lang", "vi");
            body.addProperty("signature", signature);

            String endpoint = config.getMoMoEndpoint();

            JsonObject response = sendPostRequest(endpoint, body.toString());

            if (response != null && response.has("payUrl")) {
                return response.get("payUrl").getAsString();
            }

            System.err.println("MoMo API Error: " + response);
            return null;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean isReady() {
        return isValidMoMoConfig(
                config.getMoMoPartnerCode(),
                config.getMoMoAccessKey(),
                config.getMoMoSecretKey(),
                config.getMoMoReturnUrl(),
                config.getMoMoNotifyUrl()
        );
    }

    /**
     * Validate signature từ MoMo callback
     */
    public boolean validateSignature(String rawData, String signature) {

        String secretKey = config.getMoMoSecretKey();
        if (!isConfigured(secretKey) || isPlaceholder(secretKey)) {
            return false;
        }

        String computed = hmacSHA256(secretKey, rawData);

        return computed.equalsIgnoreCase(signature);
    }

    /**
     * HMAC SHA256
     */
    private String hmacSHA256(String key, String data) {

        try {

            Mac mac = Mac.getInstance("HmacSHA256");

            SecretKeySpec secretKey =
                    new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");

            mac.init(secretKey);

            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder hex = new StringBuilder();

            for (byte b : hash) {

                String s = Integer.toHexString(0xff & b);

                if (s.length() == 1) hex.append('0');

                hex.append(s);
            }

            return hex.toString();

        } catch (Exception e) {

            e.printStackTrace();
            return "";
        }
    }

    /**
     * Send POST request
     */
    private JsonObject sendPostRequest(String endpoint, String json) {

        HttpURLConnection conn = null;

        try {

            URL url = new URL(endpoint);

            conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Content-Length",
                    String.valueOf(json.getBytes().length));

            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {

                byte[] input = json.getBytes(StandardCharsets.UTF_8);

                os.write(input, 0, input.length);
            }

            BufferedReader br;

            if (conn.getResponseCode() == 200) {

                br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            } else {

                br = new BufferedReader(
                        new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            }

            StringBuilder response = new StringBuilder();

            String line;

            while ((line = br.readLine()) != null) {

                response.append(line);
            }

            br.close();

            return gson.fromJson(response.toString(), JsonObject.class);

        } catch (Exception e) {

            e.printStackTrace();
            return null;

        } finally {

            if (conn != null) conn.disconnect();
        }
    }

    private boolean isValidMoMoConfig(String partnerCode, String accessKey, String secretKey,
                                      String redirectUrl, String ipnUrl) {
        return isConfigured(partnerCode)
                && isConfigured(accessKey)
                && isConfigured(secretKey)
                && isConfigured(redirectUrl)
                && isConfigured(ipnUrl)
                && !isPlaceholder(partnerCode)
                && !isPlaceholder(accessKey)
                && !isPlaceholder(secretKey);
    }

    private boolean isConfigured(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private boolean isPlaceholder(String value) {
        return value.startsWith("YOUR_");
    }

}