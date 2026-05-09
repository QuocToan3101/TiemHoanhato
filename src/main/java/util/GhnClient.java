package util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

/**
 * Lightweight GHN client wrapper.
 * This implementation is a minimal example and should be extended for production use.
 */
public class GhnClient {
    private static final Logger logger = LoggerFactory.getLogger(GhnClient.class);
    private final String baseUrl;
    private final String token;

    public GhnClient(String baseUrl, String token) {
        this.baseUrl = baseUrl;
        this.token = token;
    }

    /**
     * Call GHN fee calculation endpoint.
     * Returns Optional.empty() on failure.
     */
    public Optional<BigDecimal> calculateFee(String payloadJson) {
        int attempts = 0;
        int maxAttempts = 3;
        int connectTimeout = 4000;
        int readTimeout = 6000;
        while (attempts < maxAttempts) {
            attempts++;
            HttpURLConnection conn = null;
            try {
                URL url = new URL(baseUrl + "/v2/shipping-order/fee");
                conn = (HttpURLConnection) url.openConnection();
                conn.setConnectTimeout(connectTimeout);
                conn.setReadTimeout(readTimeout);
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
                conn.setRequestProperty("Token", token);
                conn.setDoOutput(true);

                byte[] out = payloadJson.getBytes(StandardCharsets.UTF_8);
                try (OutputStream os = conn.getOutputStream()) {
                    os.write(out);
                }

                int status = conn.getResponseCode();
                BufferedReader br = new BufferedReader(new InputStreamReader(
                        status >= 200 && status < 300 ? conn.getInputStream() : conn.getErrorStream(), StandardCharsets.UTF_8));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                String resp = sb.toString();
                if (status >= 200 && status < 300) {
                    String marker = "\"total\":";
                    int idx = resp.indexOf(marker);
                    if (idx >= 0) {
                        int start = idx + marker.length();
                        StringBuilder num = new StringBuilder();
                        while (start < resp.length() && (Character.isDigit(resp.charAt(start)) || resp.charAt(start) == '.')) {
                            num.append(resp.charAt(start++));
                        }
                        try {
                            return Optional.of(new BigDecimal(num.toString()));
                        } catch (Exception ex) {
                            logger.warn("GHN returned unexpected total: {}", num, ex);
                        }
                    }
                } else {
                    logger.warn("GHN fee call failed status={} resp={}", status, resp);
                }
            } catch (Exception e) {
                logger.warn("GHN request error on attempt {}", attempts, e);
            } finally {
                if (conn != null) conn.disconnect();
            }
            try { Thread.sleep(200 * attempts); } catch (InterruptedException ignored) {}
        }
        return Optional.empty();
    }
}
