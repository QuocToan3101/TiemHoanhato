package payment;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import util.AppConfig;

/**
 * MoMo Payment Configuration và Helper Methods
 */
public class MoMoConfig {
    
    private AppConfig config;
    private Gson gson;
    
    public MoMoConfig() {
        config = AppConfig.getInstance();
        gson = new Gson();
    }
    
    /**
     * Tạo URL thanh toán MoMo
     */
    public String createPaymentUrl(String orderCode, long amount, String orderInfo) {
        try {
            String partnerCode = config.getMoMoPartnerCode();
            String accessKey = config.getMoMoAccessKey();
            String secretKey = config.getMoMoSecretKey();
            String returnUrl = config.getMoMoReturnUrl();
            String notifyUrl = config.getMoMoNotifyUrl();
            String requestId = UUID.randomUUID().toString();
            String requestType = "captureWallet";
            String extraData = ""; // Pass empty value or Encode base64 JsonString
            
            // Build raw signature
            String rawSignature = "accessKey=" + accessKey +
                    "&amount=" + amount +
                    "&extraData=" + extraData +
                    "&ipnUrl=" + notifyUrl +
                    "&orderId=" + orderCode +
                    "&orderInfo=" + orderInfo +
                    "&partnerCode=" + partnerCode +
                    "&redirectUrl=" + returnUrl +
                    "&requestId=" + requestId +
                    "&requestType=" + requestType;
            
            // Generate signature
            String signature = hmacSHA256(secretKey, rawSignature);
            
            // Build request body
            JsonObject requestBody = new JsonObject();
            requestBody.addProperty("partnerCode", partnerCode);
            requestBody.addProperty("partnerName", "Tiệm Hoa nhà tớ");
            requestBody.addProperty("storeId", "MomoStore");
            requestBody.addProperty("requestId", requestId);
            requestBody.addProperty("amount", amount);
            requestBody.addProperty("orderId", orderCode);
            requestBody.addProperty("orderInfo", orderInfo);
            requestBody.addProperty("redirectUrl", returnUrl);
            requestBody.addProperty("ipnUrl", notifyUrl);
            requestBody.addProperty("lang", "vi");
            requestBody.addProperty("extraData", extraData);
            requestBody.addProperty("requestType", requestType);
            requestBody.addProperty("signature", signature);
            
            // Send request to MoMo
            String endpoint = config.getMoMoEndpoint();
            JsonObject response = sendPostRequest(endpoint, requestBody.toString());
            
            if (response != null && response.has("payUrl")) {
                return response.get("payUrl").getAsString();
            } else {
                System.err.println("✗ MoMo API Error: " + response);
                return null;
            }
            
        } catch (Exception e) {
            System.err.println("✗ Error creating MoMo payment: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Xác thực chữ ký từ MoMo callback
     */
    public boolean validateSignature(String rawData, String signature) {
        String secretKey = config.getMoMoSecretKey();
        String computedSignature = hmacSHA256(secretKey, rawData);
        return computedSignature.equals(signature);
    }
    
    /**
     * HMAC SHA256
     */
    private String hmacSHA256(String key, String data) {
        try {
            Mac hmac256 = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(), "HmacSHA256");
            hmac256.init(secretKeySpec);
            byte[] hash = hmac256.doFinal(data.getBytes(StandardCharsets.UTF_8));
            
            // Convert to hex
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (Exception e) {
            System.err.println("Error generating HMAC SHA256: " + e.getMessage());
            return "";
        }
    }
    
    /**
     * Send POST request
     */
    private JsonObject sendPostRequest(String endpoint, String jsonBody) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            
            // Send request
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // Read response
            int responseCode = conn.getResponseCode();
            BufferedReader br;
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            } else {
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            }
            
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();
            
            return gson.fromJson(response.toString(), JsonObject.class);
            
        } catch (Exception e) {
            System.err.println("Error sending POST request: " + e.getMessage());
            return null;
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
    
    /**
     * Get result message from result code
     */
    public String getResultMessage(int resultCode) {
        switch (resultCode) {
            case 0: return "Giao dịch thành công";
            case 9000: return "Giao dịch đã được xác nhận thành công";
            case 8000: return "Giao dịch đang được xử lý";
            case 7000: return "Giao dịch đang chờ thanh toán";
            case 1000: return "Giao dịch đã được khởi tạo, chờ người dùng xác nhận thanh toán";
            case 11: return "Truy cập bị từ chối";
            case 12: return "Phiên bản API không được hỗ trợ cho yêu cầu này";
            case 13: return "Xác thực doanh nghiệp thất bại";
            case 20: return "Yêu cầu sai định dạng";
            case 21: return "Số tiền giao dịch không hợp lệ";
            case 40: return "RequestId bị trùng";
            case 41: return "OrderId bị trùng";
            case 42: return "OrderId không hợp lệ hoặc không được tìm thấy";
            case 43: return "Yêu cầu bị từ chối vì xung đột trong quá trình xử lý giao dịch";
            case 1001: return "Giao dịch thanh toán thất bại do tài khoản người dùng không đủ tiền";
            case 1002: return "Giao dịch bị từ chối do nhà phát hành tài khoản thanh toán";
            case 1003: return "Giao dịch bị hủy";
            case 1004: return "Giao dịch thất bại do số tiền thanh toán vượt quá hạn mức thanh toán của người dùng";
            case 1005: return "Giao dịch thất bại do url hoặc QR code đã hết hạn";
            case 1006: return "Giao dịch thất bại do người dùng đã từ chối xác nhận thanh toán";
            case 1007: return "Giao dịch bị từ chối vì người dùng MoMo bị tạm khóa";
            case 2001: return "Giao dịch thất bại do sai thông tin liên kết";
            case 2007: return "Giao dịch thất bại do người dùng chưa đăng ký dịch vụ";
            case 3001: return "Liên kết thanh toán không tồn tại hoặc đã hết hạn";
            case 3002: return "orderId không hợp lệ";
            case 3003: return "Giao dịch thanh toán bị từ chối vì requestId và orderId không giống với thông tin ban đầu";
            case 4001: return "Giao dịch bị hạn chế theo thể lệ chương trình";
            case 4015: return "Giao dịch thất bại vì đã vượt quá số lần thanh toán trong ngày cho phép";
            case 4100: return "Giao dịch thất bại do người dùng không đồng ý điều khoản thanh toán";
            default: return "Giao dịch thất bại. Mã lỗi: " + resultCode;
        }
    }
}
