package util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.math.BigDecimal;
import java.util.Optional;

/**
 * Lightweight GHTK client wrapper for shipping fee estimation.
 */
public class GhtkClient {
    private static final Logger logger = LoggerFactory.getLogger(GhtkClient.class);
    private final String baseUrl;
    private final String token;
    private final String clientSource;

    public GhtkClient(String baseUrl, String token, String clientSource) {
        this.baseUrl = baseUrl;
        this.token = token;
        this.clientSource = clientSource;
    }

    public Optional<BigDecimal> calculateFee(String queryString) {
        int attempts = 0;
        int maxAttempts = 3;
        while (attempts < maxAttempts) {
            attempts++;
            HttpURLConnection conn = null;
            try {
                String urlString = baseUrl + "/services/shipment/fee";
                if (queryString != null && !queryString.isBlank()) {
                    urlString += "?" + queryString;
                }
                URL url = new URL(urlString);
                conn = (HttpURLConnection) url.openConnection();
                conn.setConnectTimeout(4000);
                conn.setReadTimeout(6000);
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Token", token);
                if (clientSource != null && !clientSource.isBlank()) {
                    conn.setRequestProperty("X-Client-Source", clientSource);
                }

                int status = conn.getResponseCode();
                BufferedReader reader = new BufferedReader(new InputStreamReader(
                        status >= 200 && status < 300 ? conn.getInputStream() : conn.getErrorStream(),
                        StandardCharsets.UTF_8));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
                String resp = sb.toString();

                if (status >= 200 && status < 300) {
                    BigDecimal fee = extractFee(resp);
                    if (fee != null) {
                        return Optional.of(fee);
                    }
                    logger.warn("GHTK returned unexpected response: {}", resp);
                } else {
                    logger.warn("GHTK fee call failed status={} resp={}", status, resp);
                }
            } catch (Exception e) {
                logger.warn("GHTK request error on attempt {}", attempts, e);
            } finally {
                if (conn != null) {
                    conn.disconnect();
                }
            }
        }
        return Optional.empty();
    }

    public static String buildQuery(String pickProvince, String pickDistrict, String pickAddress, String province, String district, String ward, String address, BigDecimal weight, BigDecimal value) {
        StringBuilder sb = new StringBuilder();
        appendParam(sb, "pick_province", pickProvince);
        appendParam(sb, "pick_district", pickDistrict);
        appendParam(sb, "pick_address", pickAddress);
        appendParam(sb, "province", province);
        appendParam(sb, "district", district);
        appendParam(sb, "ward", ward);
        appendParam(sb, "address", address);
        appendParam(sb, "weight", weight == null ? null : weight.toPlainString());
        appendParam(sb, "value", value == null ? null : value.toPlainString());
        appendParam(sb, "transport", "road");
        return sb.toString();
    }

    private static void appendParam(StringBuilder sb, String key, String value) {
        if (value == null || value.isBlank()) {
            return;
        }
        if (sb.length() > 0) {
            sb.append('&');
        }
        sb.append(URLEncoder.encode(key, StandardCharsets.UTF_8));
        sb.append('=');
        sb.append(URLEncoder.encode(value, StandardCharsets.UTF_8));
    }

    private BigDecimal extractFee(String resp) {
        if (resp == null || resp.isBlank()) {
            return null;
        }
        String marker = "\"fee\":";
        int idx = resp.indexOf(marker);
        if (idx < 0) {
            return null;
        }
        int start = idx + marker.length();
        StringBuilder num = new StringBuilder();
        while (start < resp.length() && (Character.isDigit(resp.charAt(start)) || resp.charAt(start) == '.')) {
            num.append(resp.charAt(start++));
        }
        if (num.length() == 0) {
            return null;
        }
        try {
            return new BigDecimal(num.toString());
        } catch (Exception ex) {
            logger.warn("GHTK returned unexpected fee: {}", num, ex);
            return null;
        }
    }
}